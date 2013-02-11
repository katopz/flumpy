package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class TabBarScreen extends PanelScreen
	{
		public function TabBarScreen()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _backButton:Button;
		private var _tabBar:TabBar;
		private var _label:Label;

		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();
			
			this.headerProperties.title = "Preview";

			_navigator = new ScreenNavigator();
			
			const verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
			const verticalLayoutSettings2:VerticalLayoutSettings = new VerticalLayoutSettings();
			
			_navigator.addScreen(VERTICAL, new ScreenNavigatorItem(VerticalLayoutScreen,
				{
					//complete: VERTICAL
				},
				{
					settings: verticalLayoutSettings
				}));
			
			_navigator.addScreen(VERTICAL_SETTINGS, new ScreenNavigatorItem(VerticalLayoutSettingsScreen,
				{
					//complete: VERTICAL
				},
				{
					settings: verticalLayoutSettings2
				}));
			
			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;
			
			addChild(_navigator);
			//_navigator.showScreen(VERTICAL);
			
			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection(
				[
					{ label: "Animation" },
					{ label: "Atlas" }
				]);
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			this._tabBar.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			addChild(_tabBar);
		}
		
		private static const VERTICAL:String = "Animation";
		private static const VERTICAL_SETTINGS:String = "Atlas";
		
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function tabBar_changeHandler(event:Event):void
		{
			//_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			//headerProperties.title = TabBar(event.target).selectedItem.label;
			//invalidate();
			const screenName:String = TabBar(event.target).selectedItem.label;
			this._transitionManager.clearStack();
			this._transitionManager.skipNextTransition = true;
			this._navigator.showScreen(screenName);
		}
	}
}
