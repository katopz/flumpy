package com.sleepydesign.flumpy.model
{
	import feathers.controls.ScreenNavigator;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import flump.xfl.XflLibrary;
	
	import org.osflash.signals.Signal;

	public class FlumpAppModel
	{
		private static var _navigator:ScreenNavigator;
		private static var _transitionManager:ScreenSlidingStackTransitionManager;
		
		public static function get navigator():ScreenNavigator
		{
			return _navigator;
		}
		
		public static function init():void
		{
			_navigator = new ScreenNavigator();
				
			_transitionManager = new ScreenSlidingStackTransitionManager(FlumpAppModel.navigator);
			_transitionManager.duration = 0.4;
		}
		
		//TODO : return AssetItemData
		public static function get currentSeletedItem():AssetItemData
		{
			return null;
		}
		
		// mediator.update
		public static const requestShowAnimationSignal:Signal = new Signal(Vector.<ActionItemData>);
		public static const requestShowAtlasSignal:Signal = new Signal(XflLibrary);
	}
}
com.sleepydesign.flumpy.model.FlumpAppModel.init();