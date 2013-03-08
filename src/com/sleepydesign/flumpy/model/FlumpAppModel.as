package com.sleepydesign.flumpy.model
{
	import feathers.controls.ScreenNavigator;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import flump.xfl.ParseError;
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
		
		// mediator.update
		public static const requestShowAnimationSignal:Signal = new Signal(Vector.<ActionItemData>);
		public static const requestShowAtlasSignal:Signal = new Signal(XflLibrary);
		public static const requestShowLogsSignal:Signal = new Signal(String, Vector.<ParseError>);
	}
}
com.sleepydesign.flumpy.model.FlumpAppModel.init();