package com.sleepydesign.flumpy.core
{
	import com.sleepydesign.flumpy.model.ActionItemData;
	import com.sleepydesign.flumpy.model.TextureAtlasData;
	import com.sleepydesign.flumpy.model.TextureAtlasItemData;
	import com.sleepydesign.system.DebugUtil;

	import flash.geom.Rectangle;

	import flump.display.Movie;
	import flump.export.Atlas;
	import flump.export.DisplayCreator;
	import flump.export.ProjectConf;
	import flump.export.TexturePacker;
	import flump.mold.MovieMold;
	import flump.xfl.XflLibrary;
	import flump.xfl.XflTexture;

	import org.osflash.signals.Signal;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class AnimationHelper
	{
		private static var _previewSprite:starling.display.DisplayObject;
		private static var _previewBounds:Rectangle;
		private static var _container:starling.display.Sprite;
		private static var _originIcon:starling.display.Sprite;
		private static var _creator:DisplayCreator;

		private static var _project:ProjectConf;

		// init complete
		public static const initializedSignal:Signal = new Signal( /*totalMemory*/int, /* totalPercentSize*/ Number);

		public static function init(lib:XflLibrary, project:ProjectConf = null):Vector.<ActionItemData>
		{
			DebugUtil.trace(" * init : " + lib.location);

			var _controlsWindow_movies_dataProvider:Vector.<ActionItemData>;

			// TODO : load project config
			_project = project;

			_creator = new DisplayCreator(lib);

			// information ----------------------------------------------------------

			// All explicitly exported movies
			const previewMovies:Vector.<MovieMold> = lib.movies.filter(function(movie:MovieMold, ... _):Boolean
			{
				return lib.isExported(movie);
			});

			_controlsWindow_movies_dataProvider = new Vector.<ActionItemData>;

			for each (var movie:MovieMold in previewMovies)
				_controlsWindow_movies_dataProvider.push(new ActionItemData(movie.id, _creator.getMemoryUsage(movie.id), _creator.getMaxDrawn(movie.id)));

			//trace("_controlsWindow_movies_dataProvider: " + _controlsWindow_movies_dataProvider);
			return _controlsWindow_movies_dataProvider;
		}

		public static function getTextureAtlasData(lib:XflLibrary, project:ProjectConf = null):TextureAtlasData
		{
			var textureItems:Vector.<TextureAtlasItemData> = new Vector.<TextureAtlasItemData>;
			var totalMemory:Number = 0;

			//_controlsWindow_textures_dataProvider = [];

			for each (var tex:XflTexture in lib.textures)
			{
				var itemUsage:int = _creator.getMemoryUsage(tex.symbol);
				totalMemory += itemUsage;
				//_controlsWindow_textures_dataProvider.push({texture: tex.symbol, memory: itemUsage});

				textureItems.push(new TextureAtlasItemData(tex.symbol, itemUsage));
			}

			trace(" ! totalMemory : " + totalMemory);
			//trace("first id : " + previewMovies[0].id);

			var atlasSize:Number = 0;
			var atlasUsed:Number = 0;
			for each (var atlas:Atlas in TexturePacker.withLib(lib).createAtlases())
			{
				atlasSize += atlas.area;
				atlasUsed += atlas.used;
			}

			var totalPercentSize:Number = (1.0 - atlasUsed / atlasSize);
			trace(" ! totalPercentSize : " + Number(totalPercentSize * 100).toPrecision(4) + "%");

			return new TextureAtlasData(textureItems, totalMemory, totalPercentSize);
		}

		public static function initContainer(container:starling.display.Sprite):void
		{
			_container = container;
		}

		public static function displayLibraryItem(name:String):void
		{

			while (_container.numChildren > 0)
				_container.removeChildAt(0);
			/*
						_previewBounds = _previewSprite.bounds;
						_container.addChild(_previewSprite);
						//_container.addChild(_originIcon);
						*/

			// add movie to container
			_previewSprite = _creator.createDisplayObject(name);
			_container.addChild(_previewSprite);

			// bound
			//trace("_previewSprite.bounds:"+ _previewSprite.bounds);

			// animate it
			if (_previewSprite is Movie)
				Starling.juggler.add(Movie(_previewSprite));
		}
	}
}
