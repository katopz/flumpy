package com.sleepydesign.flumpy.core
{
	import com.threerings.util.Log;
	import com.threerings.util.StringUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.filesystem.File;
	
	import flump.executor.Executor;
	import flump.executor.Future;
	import flump.export.Files;
	import flump.export.FlaLoader;
	import flump.export.ProjectConf;
	import flump.export.ProjectController;
	import flump.export.Publisher;
	import flump.export.Ternary;
	import flump.export.XflLoader;
	import flump.xfl.ParseError;
	import flump.xfl.XflLibrary;

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

		public static function importDirectory(file:File):ExportHelper
		{
			trace(" ^ path : " + file.nativePath);

			if (!_importChooserFile)
			{
				_importChooserFile = file; //, file.nativePath, file.nativePath);
				//todo : select export path
				_exportChooserFile = file; //, file.nativePath, file.nativePath);
			}

			setImportDirectory(file);

			return _this;
		}

		// old stuff --------------------------------------------------------------

		private static var _importDirectory:File;

		private static var _docFinder:Executor;
		private static var _flashDocsGrid_dataProvider:Array;
		private static var _errorsGrid_dataProvider:Array;
		private static var _exportChooserFile:File;
		private static var _importChooserFile:File;
		private static var _conf:ProjectConf = new ProjectConf();
		private static var _confFile:File;

		private static var _projectDirty:Boolean; // true if project has unsaved changes

		private static const log:Log = Log.getLog(ProjectController);

		private static function setImportDirectory(dir:File):void
		{
			_importDirectory = dir;
			_flashDocsGrid_dataProvider = [];
			_errorsGrid_dataProvider = [];

			if (dir == null)
				return;

			if (_docFinder != null)
				_docFinder.shutdownNow();

			_docFinder = new Executor();
			findFlashDocuments(dir, _docFinder, true);
		}

		private static function findFlashDocuments(base:File, exec:Executor, ignoreXflAtBase:Boolean = false):void
		{
			Files.list(base, exec).succeeded.add(function(files:Array):void
			{
				if (exec.isShutdown)
					return;
				for each (var file:File in files)
				{
					if (Files.hasExtension(file, "xfl"))
					{
						if (ignoreXflAtBase)
						{
							_errorsGrid_dataProvider.push(new ParseError(base.nativePath, ParseError.CRIT, "The import directory can't be an XFL directory, did you mean " + base.parent.nativePath + "?"));
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
			});
		}

		private static function addFlashDocument(file:File):void
		{
			var importPathLen:int = _importDirectory.nativePath.length + 1;
			var name:String = file.nativePath.substring(importPathLen).replace(new RegExp("\\" + File.separator, "g"), "/");

			var load:Future;
			switch (Files.getExtension(file))
			{
				case "xfl":
					name = name.substr(0, name.lastIndexOf("/"));
					load = new XflLoader().load(name, file.parent);
					break;
				case "fla":
					name = name.substr(0, name.lastIndexOf("."));
					load = new FlaLoader().load(name, file);
					break;
				default:
					// Unsupported file type, ignore
					return;
			}

			const status:DocStatus = new DocStatus(name, Ternary.UNKNOWN, Ternary.UNKNOWN, null);
			_flashDocsGrid_dataProvider.push(status);

			load.succeeded.add(function(lib:XflLibrary):void
			{
				var pub:Publisher = createPublisher();
				status.lib = lib;
				status.updateModified(Ternary.of(pub == null || pub.modified(lib)));
				for each (var err:ParseError in lib.getErrors())
					_errorsGrid_dataProvider.push(err);
				status.updateValid(Ternary.of(lib.valid));
			});
			load.failed.add(function(error:Error):void
			{
				trace("Failed to load " + file.nativePath + ": " + error);
				status.updateValid(Ternary.FALSE);
				throw error;
			});
		}

		private static function createPublisher():Publisher
		{
			return new Publisher(_exportChooserFile, _conf);
		}
		
		// export -------------------------------------------------------------------------
		
		public static function exportDirectory(file:File):ExportHelper
		{
			trace(" ^ path : " + file.nativePath);
			
			for each (var status:DocStatus in _flashDocsGrid_dataProvider)
				if (status.isValid)
					exportFlashDocument(status);
				
			setImportDirectory(file);
			
			return _this;
		}
		
		private static function exportFlashDocument(status:DocStatus):void
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
				//ErrorWindowMgr.showErrorPopup("Publishing Failed", e.message, _win);
			}
			
			stage.quality = prevQuality;
			status.updateModified(Ternary.FALSE);
		}
	}
}

import flash.events.EventDispatcher;

import flump.export.Ternary;
import flump.xfl.XflLibrary;

class DocStatus extends EventDispatcher
{
	public var path:String;
	public var modified:String;
	public var valid:String = PENDING;
	public var lib:XflLibrary;

	public function DocStatus(path:String, modified:Ternary, valid:Ternary, lib:XflLibrary)
	{
		this.lib = lib;
		this.path = path;
		_uid = path;

		updateModified(modified);
		updateValid(valid);
	}

	public function updateValid(newValid:Ternary):void
	{
		changeField("valid", function(... _):void
		{
			if (newValid == Ternary.TRUE)
				valid = YES;
			else if (newValid == Ternary.FALSE)
				valid = ERROR;
			else
				valid = PENDING;
		});
	}

	public function get isValid():Boolean
	{
		return valid == YES;
	}

	public function updateModified(newModified:Ternary):void
	{
		changeField("modified", function(... _):void
		{
			if (newModified == Ternary.TRUE)
				modified = YES;
			else if (newModified == Ternary.FALSE)
				modified = " ";
			else
				modified = PENDING;
		});
	}

	protected function changeField(fieldName:String, modifier:Function):void
	{
		const oldValue:Object = this[fieldName];
		modifier();
		const newValue:Object = this[fieldName];
		trace("dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, fieldName, oldValue, newValue));");
		//dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, fieldName, oldValue, newValue));
	}

	public function get uid():String
	{
		return _uid;
	}

	public function set uid(uid:String):void
	{
		_uid = uid;
	}

	protected var _uid:String;

	protected static const PENDING:String = "...";
	protected static const ERROR:String = "ERROR";
	protected static const YES:String = "Yes";
}
