package feathers.examples.layoutExplorer
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.examples.layoutExplorer.screens.LogsScreen;
	import feathers.examples.layoutExplorer.screens.MainMenuScreen;
	import feathers.examples.layoutExplorer.screens.TabBarScreen;
	import feathers.examples.layoutExplorer.screens.VerticalLayoutScreen;
	import feathers.examples.layoutExplorer.screens.VerticalLayoutSettingsScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;

	public class Main extends Sprite
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const VERTICAL:String = "vertical";
		private var VERTICAL_SETTINGS:String = "vertical-setting";
		//private var LOGS_SCREEN:String = "logs-screen";
		private static const TAB_BAR:String = "tabBar";
		
		private static const MAIN_MENU_EVENTS:Object =
		{
			showVertical: VERTICAL,
			showTabBar: TAB_BAR
		}

		public function Main()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private var _theme:MetalWorksMobileTheme;
		private var _container:ScrollContainer;
		private var _navigator:ScreenNavigator;
		private var _menu:MainMenuScreen;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function layoutForTablet():void
		{
			this._container.width = this.stage.stageWidth;
			this._container.height = this.stage.stageHeight;
		}

		private function addedToStageHandler(event:Event):void
		{
			this._theme = new MetalWorksMobileTheme();

			this._navigator = new ScreenNavigator();

			const verticalLayoutSettings2:VerticalLayoutSettings = new VerticalLayoutSettings();
			const verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
			/*
			this._navigator.addScreen(LOGS_SCREEN, new ScreenNavigatorItem(LogsScreen,
				{
					complete: VERTICAL
				},
				{
					settings: verticalLayoutSettings2
				}));
			
			this._navigator.addScreen(VERTICAL, new ScreenNavigatorItem(VerticalLayoutScreen,
			{
				complete: MAIN_MENU,
				showSettings: VERTICAL_SETTINGS,
				showLogs: LOGS_SCREEN
			},
			{
				settings: verticalLayoutSettings
			}));
			this._navigator.addScreen(VERTICAL_SETTINGS, new ScreenNavigatorItem(VerticalLayoutSettingsScreen,
			{
				complete: VERTICAL
			},
			{
				settings: verticalLayoutSettings
			}));
			*/
			
			this._navigator.addScreen(TAB_BAR, new ScreenNavigatorItem(TabBarScreen,
				{
					complete: MAIN_MENU
				}));

			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

				this._container = new ScrollContainer();
				this._container.layout = new AnchorLayout();
				this._container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				this._container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				this.addChild(this._container);

				this._menu = new MainMenuScreen();
				for(var eventType:String in MAIN_MENU_EVENTS)
				{
					this._menu.addEventListener(eventType, mainMenuEventHandler);
				}
				this._menu.width = 960 * DeviceCapabilities.dpi / this._theme.originalDPI;
				const menuLayoutData:AnchorLayoutData = new AnchorLayoutData();
				menuLayoutData.top = 0;
				menuLayoutData.bottom = 0;
				menuLayoutData.left = 0;
				this._menu.layoutData = menuLayoutData;
				this._container.addChild(this._menu);

				this._navigator.clipContent = true;
				const navigatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
				navigatorLayoutData.top = 0;
				navigatorLayoutData.right = 0;
				navigatorLayoutData.bottom = 0;
				navigatorLayoutData.leftAnchorDisplayObject = this._menu;
				navigatorLayoutData.left = 0;
				this._navigator.layoutData = navigatorLayoutData;
				this._container.addChild(this._navigator);

				this.layoutForTablet();
			}
			else
			{
				this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, MAIN_MENU_EVENTS));

				this.addChild(this._navigator);

				this._navigator.showScreen(MAIN_MENU);
			}
			
			this._navigator.showScreen(TAB_BAR);
		}

		private function removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}

		private function mainMenuEventHandler(event:Event):void
		{
			const screenName:String = MAIN_MENU_EVENTS[event.type];
			//because we're controlling the navigation externally, it doesn't
			//make sense to transition or keep a history
			this._transitionManager.clearStack();
			this._transitionManager.skipNextTransition = true;
			this._navigator.showScreen(screenName);
		}

		private function stage_resizeHandler(event:ResizeEvent):void
		{
			//we don't need to layout for phones because ScreenNavigator knows
			//to automatically resize itself to fill the stage if we don't give
			//it a width and height.
			this.layoutForTablet();
		}
	}
}
