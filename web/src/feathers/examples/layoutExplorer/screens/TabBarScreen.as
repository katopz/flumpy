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
			
			this.headerProperties.title = "Detail";

			/*
			_label = new Label();
			_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			const labelLayoutData:AnchorLayoutData = new AnchorLayoutData();
			labelLayoutData.horizontalCenter = 0;
			labelLayoutData.verticalCenter = 0;
			_label.layoutData = labelLayoutData;
			addChild(DisplayObject(_label));
			*/

			//headerProperties.title = "Logs";

			/*
			var _exportButton:Button = new Button();
			_exportButton.label = "export";
			_exportButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			
			headerProperties.rightItems = new <DisplayObject>[_exportButton];
			
			// handles the back hardware key on android
			backButtonHandler = onBackButton;
			*/
			
			//--------------------------------------------------------------------
			
			/*
			_container = new ScrollContainer();
			_container.layout = new AnchorLayout();
			_container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			addChild(_container);
			*/
			
			_navigator = new ScreenNavigator();
			
			const verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
			
			_navigator.addScreen(VERTICAL, new ScreenNavigatorItem(VerticalLayoutScreen,
				{
					//complete: VERTICAL
				},
				{
					settings: verticalLayoutSettings
				}));
			
			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;
			
			addChild(_navigator);
			_navigator.showScreen(VERTICAL);
			
			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection(
				[
					{ label: "Preview" },
					{ label: "Logs" },
					{ label: "Option" },
				]);
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			this._tabBar.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			addChild(_tabBar);
		}
		
		private static const VERTICAL:String = "vertical";
		
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function tabBar_changeHandler(event:Event):void
		{
			//_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			//headerProperties.title = TabBar(event.target).selectedItem.label;
			//invalidate();
			trace("todo");
		}
	}
}
