package com.sleepydesign.flumpy.core
{
	import com.threerings.util.StringUtil;

	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.filesystem.File;

	import flump.executor.Executor;
	import flump.executor.Future;
	import flump.export.Files;
	import flump.export.FlaLoader;
	import flump.export.FlumpItem;
	import flump.export.ProjectConf;
	import flump.export.Publisher;
	import flump.export.Ternary;
	import flump.export.XflLoader;
	import flump.xfl.ParseError;
	import flump.xfl.XflLibrary;

	import org.osflash.signals.Signal;

	public class ExportHelper
	{
		public static var _this:ExportHelper = new ExportHelper;

		/**
		 * Contain all current path, will use for monitor file changed
		 */
		public static var currentPaths:Vector.<String>;

		/**
		 * Will monitor all path in this list
		 *
		 * @param path
		 */
		public static function addPath(path:String):ExportHelper
		{
			if (!currentPaths)
				currentPaths = new Vector.<String>;

			if (currentPaths.indexOf(path) != -1)
				return null;

			currentPaths.push(path);

			return _this;
		}

		public static function setImportDirectory(file:File):ExportHelper
		{
			trace(" ^ path : " + file.nativePath);

			if (!_importChooserFile)
			{
				_importChooserFile = file; //, file.nativePath, file.nativePath);
				//todo : select export path
				//_exportChooserFile = file; //, file.nativePath, file.nativePath);
			}

			_setImportDirectory(file);

			return _this;
		}

		// TODO select from item
		public static function getLibraryAt(index:int):XflLibrary
		{
			return _flashDocsGrid_dataProvider[index].lib;
		}

		// for binding
		public static const assetImportSignal:Signal = new Signal( /*path*/String, /*FlumpItem*/ Vector.<FlumpItem>);
		public static const importErrorSignal:Signal = new Signal( /*path*/String, /*ParseError*/ Vector.<ParseError>);

		// for init
		public static function get logs():Vector.<ParseError>
		{
			return _errorsGrid_dataProvider;
		}

		// old stuff --------------------------------------------------------------

		// targets
		private static var _importDirectory:File;
		
		public static function get importDirectory():File
		{
			return _importDirectory;
		}
		
		private static var _exportChooserFile:File;
		private static var _importChooserFile:File;

		// wtf
		private static var _docFinder:Executor;

		// file-items
		private static var _flashDocsGrid_dataProvider:Vector.<FlumpItem>;

		// logs
		private static var _errorsGrid_dataProvider:Vector.<ParseError>;

		// configs
		private static var _conf:ProjectConf = new ProjectConf();
		private static var _confFile:File;
		private static var _projectDirty:Boolean; // true if project has unsaved changes
		//public static var importDirectory:File;

		private static function _setImportDirectory(dir:File):void
		{
			_importDirectory = dir;
			_flashDocsGrid_dataProvider = new Vector.<FlumpItem>;
			_errorsGrid_dataProvider = new Vector.<ParseError>;

			if (dir == null)
				return;

			if (_docFinder != null)
				_docFinder.shutdownNow();

			_docFinder = new Executor();
			findFlashDocuments(dir, _docFinder, true);
		}

		private static function _setExportDirectory(dir:File):void
		{
			_exportChooserFile = dir;
		}

		private static function findFlashDocuments(base:File, exec:Executor, ignoreXflAtBase:Boolean = false):void
		{
			Files.list(base, exec).succeeded.add(function(files:Array):void
			{
				var isError:Boolean;

				if (exec.isShutdown)
					return;

				for each (var file:File in files)
				{
					if (Files.hasExtension(file, "xfl"))
					{
						if (ignoreXflAtBase)
						{
							_errorsGrid_dataProvider.push(new ParseError(base.nativePath, ParseError.CRIT, "The import directory can't be an XFL directory, did you mean " + base.parent.nativePath + "?"));
							isError = true;
						}
						else
							addFlashDocument(file);
						return;
					}
				}
				for each (file in files)
				{
					if (StringUtil.startsWith(file.name, ".", "RECOVER_"))
					{
						continue; // Ignore hidden VCS directories, and recovered backups created by Flash
					}
					if (file.isDirectory)
						findFlashDocuments(file, exec);
					else
						addFlashDocument(file);
				}

				assetImportSignal.dispatch(base.nativePath, _flashDocsGrid_dataProvider);

				// some error occurs
				if (isError)
					importErrorSignal.dispatch(base.nativePath, _errorsGrid_dataProvider);
			});
		}

		private static function addFlashDocument(file:File):void
		{
			var importPathLen:int = _importDirectory.nativePath.length + 1;
			var fileName:String = file.nativePath.substring(importPathLen).replace(new RegExp("\\" + File.separator, "g"), "/");

			var load:Future;
			switch (Files.getExtension(file))
			{
				case "xfl":
					fileName = fileName.substr(0, fileName.lastIndexOf("/"));
					load = new XflLoader().load(fileName, file.parent);
					break;
				case "fla":
					fileName = fileName.substr(0, fileName.lastIndexOf("."));
					load = new FlaLoader().load(fileName, file);
					break;
				default:
					// Unsupported file type, ignore
					return;
			}

			const status:FlumpItem = new FlumpItem(fileName, Ternary.UNKNOWN, Ternary.UNKNOWN, null);
			_flashDocsGrid_dataProvider.push(status);

			load.succeeded.add(function(lib:XflLibrary):void
			{
				var isError:Boolean;

				// TOFIX : this is dependency bad practise, publisher shouldn't be call until export phase
				var pub:Publisher = createPublisher();
				status.lib = lib;
				status.updateModified(Ternary.of(pub == null || pub.modified(lib)));

				for each (var err:ParseError in lib.getErrors())
				{
					_errorsGrid_dataProvider.push(err);
					isError = true;
				}

				status.updateValid(Ternary.of(lib.valid));

				// some error occurs
				if (isError)
					importErrorSignal.dispatch(status.fileName, _errorsGrid_dataProvider);
			});

			load.failed.add(function(error:Error):void
			{
				status.updateValid(Ternary.FALSE);
				throw error;
			});
		}

		private static function createPublisher():Publisher
		{
			// TOFIX : this is dependency bad practise, publisher shouldn't be call until export phase
			if(!_exportChooserFile)
				return null;
			
			return new Publisher(_exportChooserFile, _conf);
		}

		// export -------------------------------------------------------------------------

		public static function exportDirectory(file:File):ExportHelper
		{
			_setExportDirectory(file);

			return _this;
		}

		private static function exportFlashDocument(status:FlumpItem):void
		{
			const stage:Stage = NativeApplication.nativeApplication.activeWindow.stage;
			const prevQuality:String = stage.quality;

			stage.quality = StageQuality.BEST;

			try
			{
				createPublisher().publish(status.lib);
			}
			catch (e:Error)
			{
				// TODO : throw error
				trace(e);
			}

			stage.quality = prevQuality;
			status.updateModified(Ternary.FALSE);
		}
		
		public static function export():void
		{
			trace(" * export");
			
			for each (var status:FlumpItem in _flashDocsGrid_dataProvider)
				if (status.isValid)
					exportFlashDocument(status);
		}
	}
}
