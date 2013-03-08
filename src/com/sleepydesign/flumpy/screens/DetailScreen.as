package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.AnimationHelper;
	import com.sleepydesign.flumpy.core.ExportHelper;
	import com.sleepydesign.flumpy.model.ActionItemData;
	import com.sleepydesign.flumpy.model.FlumpAppModel;
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
	
	import org.osflash.signals.Signal;
	
	import starling.events.Event;

	[Event(name = "complete", type = "starling.events.Event")]

	public class DetailScreen extends PanelScreen
	{
		// mediator.startup
		public static const initializedSignal:Signal = new Signal(DetailScreen);
		
		private static var _this:DetailScreen;

		public function DetailScreen()
		{
			_this = this;
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

			_navigator.addScreen(ANIMATION_SCREEN, new ScreenNavigatorItem(AnimationScreen, {
				//complete: VERTICAL
				}, {settings: verticalLayoutSettings}));


			_navigator.addScreen(ATLAS_SCREEN, new ScreenNavigatorItem(AtlasScreen));

			_navigator.addScreen(LOGS_SCREEN, new ScreenNavigatorItem(LogsScreen));

			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;

			addChild(_navigator);
			//_navigator.showScreen(VERTICAL);

			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection([{label: ANIMATION_SCREEN}, {label: ATLAS_SCREEN}, {label: LOGS_SCREEN}]);
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			_tabBar.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			addChild(_tabBar);

			currentScreenID = ANIMATION_SCREEN;
		}

		public static const ANIMATION_SCREEN:String = "Animation";
		public static const ATLAS_SCREEN:String = "Atlas";
		public static const LOGS_SCREEN:String = "Logs";

		public static const _SCREENS:Vector.<String> = Vector.<String>([ANIMATION_SCREEN, ATLAS_SCREEN, LOGS_SCREEN]);

		private static var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private static var _currentAssetIndex:int;
		private static var _currentAssetID:String;

		public static function get currentAssetID():String
		{
			return ExportHelper.getLibraryAt(_currentAssetIndex).location;
		}

		private static var _actionItemDatas:Vector.<ActionItemData>;

		private function tabBar_changeHandler(event:Event):void
		{
			//_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			//headerProperties.title = TabBar(event.target).selectedItem.label;
			//invalidate();
			const tabBar:TabBar = event.target as TabBar;
			const screenID:String = tabBar.selectedItem.label;

			_transitionManager.clearStack();
			_transitionManager.skipNextTransition = true;

			// bind initial
			whenScreenInitialized(screenID);

			// show view
			_navigator.showScreen(screenID);
		}

		private function whenScreenInitialized(screenID:String):void
		{
			switch (screenID)
			{
				case ANIMATION_SCREEN:

					//var actionItemDatas:Vector.<ActionItemData> = AnimationHelper.init(ExportHelper.getLibraryAt(screenIndex));

					AnimationScreen.initializedSignal.add(function(animationScreen:AnimationScreen):void
					{
						// injection 
						FlumpAppModel.requestShowAnimationSignal.dispatch(_actionItemDatas);
						
						// push data to view
						//animationScreen.showActionItemDatas(actionItemDatas);
					});
					break;
				case ATLAS_SCREEN:
					
					AtlasScreen.initializedSignal.add(function(atlasScreen:AtlasScreen):void
					{
						// injection 
						FlumpAppModel.requestShowAtlasSignal.dispatch(ExportHelper.getLibraryAt(_currentAssetIndex));
						
						// push data to view
						//animationScreen.showActionItemDatas(actionItemDatas);
					});
					break;
				case LOGS_SCREEN:
					
					LogsScreen.initializedSignal.add(function(logsScreen:LogsScreen):void
					{
						if(!ExportHelper.logs || ExportHelper.logs.length <= 0)
							return;
						
						// injection 
						FlumpAppModel.requestShowLogsSignal.dispatch(currentAssetID, ExportHelper.logs);
						
						// push data to view
						//animationScreen.showActionItemDatas(actionItemDatas);
					});
					break;
			}
		}

		public static function set currentScreenID(screenID:String):void
		{
			const screenIndex:int = _SCREENS.indexOf(screenID);

			if (_tabBar.selectedIndex == screenIndex)
				return;

			_tabBar.selectedIndex = screenIndex;
		}
		
		public static function get currentScreenID():String
		{
			return _SCREENS[_tabBar.selectedIndex];
		}

		public static function showItemAt(index:int):void
		{
			// store for later use after view init
			_currentAssetIndex = index;
			
			// store for later use after view init
			_actionItemDatas = AnimationHelper.init(ExportHelper.getLibraryAt(index));

			switch (currentScreenID)
			{
				case ANIMATION_SCREEN:
					if (!_actionItemDatas || _actionItemDatas.length <= 0)
					{
						currentScreenID = LOGS_SCREEN;
					} else {
						FlumpAppModel.requestShowAnimationSignal.dispatch(_actionItemDatas);
					}
					break;
				case ATLAS_SCREEN:
					FlumpAppModel.requestShowAtlasSignal.dispatch(ExportHelper.getLibraryAt(_currentAssetIndex));
					break;
				case LOGS_SCREEN:
					FlumpAppModel.requestShowLogsSignal.dispatch(currentAssetID, ExportHelper.logs);
					break;
			}
			
			/*
			// has something to show
			if (_actionItemDatas.length > 0)
			{
				// auto display animation screen if on log screen
				if(currentScreenID == LOGS_SCREEN)
					currentScreenID = ANIMATION_SCREEN;
				else
					FlumpAppModel.requestShowAnimationSignal.dispatch(_actionItemDatas);
			}
			else
			{
				currentScreenID = LOGS_SCREEN;
			}
			*/
		}
	}
}
