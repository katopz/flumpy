package com.sleepydesign.flumpy.model
{
	import feathers.controls.ScreenNavigator;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;

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
	}
}
com.sleepydesign.flumpy.model.FlumpAppModel.init();