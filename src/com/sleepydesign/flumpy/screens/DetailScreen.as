package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.data.VerticalLayoutSettings;
	
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
		private var _tabBar:TabBar;
		private var _label:Label;

		protected function initializeHandler(event:Event):void
		{
			layout = new AnchorLayout();
			
			headerProperties.title = "Preview";

			_navigator = new ScreenNavigator();
			
			const verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
			
			_navigator.addScreen(VERTICAL, new ScreenNavigatorItem(AnimationScreen,
				{
					//complete: VERTICAL
				},
				{
					settings: verticalLayoutSettings
				}));
			
			_navigator.addScreen(VERTICAL_SETTINGS, new ScreenNavigatorItem(AtlasScreen,
				{
					//complete: VERTICAL
				}));
			
			_navigator.addScreen(LOGS, new ScreenNavigatorItem(LogsScreen,
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
					{ label: "Animation" },
					{ label: "Atlas" },
					{ label: "Logs" }
				]);
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			_tabBar.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			addChild(_tabBar);
		}
		
		private static const VERTICAL:String = "Animation";
		private static const VERTICAL_SETTINGS:String = "Atlas";
		private static const LOGS:String = "Logs";
		
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function tabBar_changeHandler(event:Event):void
		{
			//_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			//headerProperties.title = TabBar(event.target).selectedItem.label;
			//invalidate();
			var tabBar:TabBar = event.target as TabBar;
			const screenName:String = tabBar.selectedItem.label;
			_transitionManager.clearStack();
			_transitionManager.skipNextTransition = true;
			_navigator.showScreen(screenName);
		}
	}
}
