package com.sleepydesign.flumpy
{
	import com.sleepydesign.flumpy.screens.MainMenuScreen;
	import com.sleepydesign.flumpy.screens.PreviewScreen;
	import com.sleepydesign.flumpy.themes.GrayScaleTheme;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;

	public class Main extends Sprite
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const PREVIEW_SCREEN:String = "PreviewScreen";
		
		private static const MAIN_MENU_EVENTS:Object =
		{
			showPreviewScreen: PREVIEW_SCREEN
		}

		public function Main()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private var _theme:GrayScaleTheme;
		private var _container:ScrollContainer;
		private var _navigator:ScreenNavigator;
		private var _menu:MainMenuScreen;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function layoutForTablet():void
		{
			_container.width = stage.stageWidth;
			_container.height = stage.stageHeight;
		}

		private function addedToStageHandler(event:Event):void
		{
			_theme = new GrayScaleTheme();

			_navigator = new ScreenNavigator();

			_navigator.addScreen(PREVIEW_SCREEN, new ScreenNavigatorItem(PreviewScreen,
				{
					complete: MAIN_MENU
				}));

			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

				_container = new ScrollContainer();
				_container.layout = new AnchorLayout();
				_container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				_container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				addChild(_container);

				_menu = new MainMenuScreen();
				
				for(var eventType:String in MAIN_MENU_EVENTS)
					_menu.addEventListener(eventType, mainMenuEventHandler);
				
				_menu.width = 960 * DeviceCapabilities.dpi / _theme.originalDPI;
				const menuLayoutData:AnchorLayoutData = new AnchorLayoutData();
				menuLayoutData.top = 0;
				menuLayoutData.bottom = 0;
				menuLayoutData.left = 0;
				_menu.layoutData = menuLayoutData;
				_container.addChild(_menu);

				_navigator.clipContent = true;
				const navigatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
				navigatorLayoutData.top = 0;
				navigatorLayoutData.right = 0;
				navigatorLayoutData.bottom = 0;
				navigatorLayoutData.leftAnchorDisplayObject = _menu;
				navigatorLayoutData.left = 0;
				_navigator.layoutData = navigatorLayoutData;
				_container.addChild(_navigator);

				layoutForTablet();
			}
			else
			{
				_navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, MAIN_MENU_EVENTS));

				addChild(_navigator);

				_navigator.showScreen(MAIN_MENU);
			}
			
			_navigator.showScreen(PREVIEW_SCREEN);
		}

		private function removedFromStageHandler(event:Event):void
		{
			stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}

		// TODO : this should be receive event from MainMenuScreen
		private function mainMenuEventHandler(event:Event):void
		{
			trace("todo");
			/*
			const screenName:String = MAIN_MENU_EVENTS[event.type];
			//because we're controlling the navigation externally, it doesn't
			//make sense to transition or keep a history
			_transitionManager.clearStack();
			_transitionManager.skipNextTransition = true;
			_navigator.showScreen(screenName);
			*/
		}

		private function stage_resizeHandler(event:ResizeEvent):void
		{
			//we don't need to layout for phones because ScreenNavigator knows
			//to automatically resize itself to fill the stage if we don't give
			//it a width and height.
			layoutForTablet();
		}
	}
}
