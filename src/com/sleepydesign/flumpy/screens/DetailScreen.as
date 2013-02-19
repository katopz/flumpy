package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.themes.VerticalLayoutSettings;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class DetailScreen extends PanelScreen
	{
		public function DetailScreen()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _backButton:Button;
		private static var _tabBar:TabBar;
		private var _label:Label;

		protected function initializeHandler(event:Event):void
		{
			layout = new AnchorLayout();
			
			headerProperties.title = "Preview";

			_navigator = new ScreenNavigator();
			
			const verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
			
			_navigator.addScreen(ANIMATION_SCREEN, new ScreenNavigatorItem(AnimationScreen,
				{
					//complete: VERTICAL
				},
				{
					settings: verticalLayoutSettings
				}));
			
			_navigator.addScreen(ATLAS_SCREEN, new ScreenNavigatorItem(AtlasScreen,
				{
					//complete: VERTICAL
				}));
			
			_navigator.addScreen(LOGS_SCREEN, new ScreenNavigatorItem(LogsScreen,
				{
					//complete: VERTICAL
				}));
			
			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;
			
			addChild(_navigator);
			//_navigator.showScreen(VERTICAL);
			
			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection(
				[
					{ label: ANIMATION_SCREEN },
					{ label: ATLAS_SCREEN },
					{ label: LOGS_SCREEN }
				]);
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			_tabBar.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			addChild(_tabBar);
		}
		
		public static const ANIMATION_SCREEN:String = "Animation";
		public static const ATLAS_SCREEN:String = "Atlas";
		public static const LOGS_SCREEN:String = "Logs";
		
		private static var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function tabBar_changeHandler(event:Event):void
		{
			//_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			//headerProperties.title = TabBar(event.target).selectedItem.label;
			//invalidate();
			const tabBar:TabBar = event.target as TabBar;
			const screenName:String = tabBar.selectedItem.label;
			_transitionManager.clearStack();
			_transitionManager.skipNextTransition = true;
			_navigator.showScreen(screenName);
		}
		
		public static function set currentScreenID(screenID:String):void
		{
			const screens:Vector.<String> = _navigator.getScreenIDs();
			_tabBar.selectedIndex = screens.indexOf(screenID);
		}
	}
}
