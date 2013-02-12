package com.sleepydesign.flumpy.core
{
	import flash.geom.Rectangle;
	
	import flump.display.Movie;
	import flump.export.DisplayCreator;
	import flump.export.ProjectConf;
	import flump.xfl.XflLibrary;
	
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

		public static function init(lib:XflLibrary, project :ProjectConf = null):void
		{
			_lib = lib;
			_project = project;
			
			_creator = new DisplayCreator(_lib);
		}
		
		public static function initContainer(container:starling.display.Sprite):void
		{
			_container = container;
		}

		public static function displayLibraryItem(name:String):void
		{
			/*
			while (_container.numChildren > 0)
				_container.removeChildAt(0);

			_previewSprite = _creator.createDisplayObject(name);
			_previewBounds = _previewSprite.bounds;
			_container.addChild(_previewSprite);
			//_container.addChild(_originIcon);
			if (_previewSprite is Movie)
			{
				Starling.juggler.add(Movie(_previewSprite));
			}
			*/
			
			_previewSprite = _creator.createDisplayObject(name);
			_container.addChild(_previewSprite);
		}
	}
}
