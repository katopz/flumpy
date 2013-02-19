package com.sleepydesign.flumpy.core
{
	import com.sleepydesign.flumpy.model.ActionItemData;
	
	import flash.geom.Rectangle;
	
	import flump.display.Movie;
	import flump.export.Atlas;
	import flump.export.DisplayCreator;
	import flump.export.ProjectConf;
	import flump.export.TexturePacker;
	import flump.mold.MovieMold;
	import flump.xfl.XflLibrary;
	import flump.xfl.XflTexture;
	
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

		private static var _lib:XflLibrary;
		private static var _project:ProjectConf;

		// information
		private static var _controlsWindow_movies_dataProvider:Vector.<ActionItemData>;
		private static var _controlsWindow_textures_dataProvider:Array;

		public static function init(lib:XflLibrary, project:ProjectConf = null):Vector.<ActionItemData>
		{
			_lib = lib;
			_project = project;

			_creator = new DisplayCreator(_lib);

			// information ----------------------------------------------------------

			// All explicitly exported movies
			const previewMovies:Vector.<MovieMold> = _lib.movies.filter(function(movie:MovieMold, ... _):Boolean
			{
				return _lib.isExported(movie);
			});

			_controlsWindow_movies_dataProvider = new Vector.<ActionItemData>;

			for each (var movie:MovieMold in previewMovies)
				_controlsWindow_movies_dataProvider.push(new ActionItemData(movie.id, _creator.getMemoryUsage(movie.id),  _creator.getMaxDrawn(movie.id)));
			
			//trace("_controlsWindow_movies_dataProvider: " + _controlsWindow_movies_dataProvider);

			var totalUsage:int = 0;
			_controlsWindow_textures_dataProvider = [];
			
			for each (var tex:XflTexture in _lib.textures)
			{
				var itemUsage:int = _creator.getMemoryUsage(tex.symbol);
				totalUsage += itemUsage;
				_controlsWindow_textures_dataProvider.push({texture: tex.symbol, memory: itemUsage});
			}
			
			trace("totalUsage: " + totalUsage);
			//trace("first id : " + previewMovies[0].id);
			
			var atlasSize :Number = 0;
			var atlasUsed :Number = 0;
			for each (var atlas :Atlas in TexturePacker.withLib(_lib).createAtlases()) {
				atlasSize += atlas.area;
				atlasUsed += atlas.used;
			}
			
			trace("atlasSize: " + ((1.0 - (atlasUsed/atlasSize)) * 100).toPrecision(4) + "%");
			
			return _controlsWindow_movies_dataProvider;
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
			trace("_previewSprite.bounds:"+ _previewSprite.bounds);
			
			// animate it
			if (_previewSprite is Movie)
				Starling.juggler.add(Movie(_previewSprite));
		}
	}
}
