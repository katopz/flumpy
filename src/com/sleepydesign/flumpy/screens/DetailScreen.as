package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.AnimationHelper;
	import com.sleepydesign.flumpy.core.ExportHelper;
	import com.sleepydesign.flumpy.model.ActionItemData;
	import com.sleepydesign.flumpy.model.FlumpAppModel;
	import com.sleepydesign.flumpy.model.TextureAtlasData;
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

	import flump.xfl.XflLibrary;

	import org.osflash.signals.Signal;

	import starling.events.Event;

	[Event(name = "complete", type = "starling.events.Event")]

	public class DetailScreen extends PanelScreen implements IFlumpyScreen
	{
		// mediator.startup
		public static const initializedSignal:Signal = new Signal(DetailScreen);

		public function DetailScreen()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		protected function initializeHandler(event:Event):void
		{
			// layout
			initLayout();

			// header
			initHeader();

			// default screen
			//currentScreenID = ANIMATION_SCREEN;

			// mediator
			initMediator();

			// ready to roll
			initializedSignal.dispatch(this);
		}

		private function initMediator():void
		{
			FlumpAppModel.requestClearSreenSignal.add(clear);
		}

		// layout -----------------------------------------------------------------------

		private static var _tabBar:TabBar;

		private var _backButton:Button;
		private var _label:Label;

		private function initLayout():void
		{
			layout = new AnchorLayout();

			addChild(_navigator = new ScreenNavigator);
			_navigator.addScreen(ANIMATION_SCREEN, new ScreenNavigatorItem(AnimationScreen, {}, {settings: new VerticalLayoutSettings}));
			_navigator.addScreen(ATLAS_SCREEN, new ScreenNavigatorItem(AtlasScreen));
			_navigator.addScreen(LOGS_SCREEN, new ScreenNavigatorItem(LogsScreen));

			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;
		}

		private function initHeader():void
		{
			headerProperties.title = "Preview";

			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection([{label: ANIMATION_SCREEN}, {label: ATLAS_SCREEN}, {label: LOGS_SCREEN}]);
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			_tabBar.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			addChild(_tabBar);
		}

		public static const tabChangeSignal:Signal = new Signal( /*tabID*/String);

		public static const ANIMATION_SCREEN:String = "Animation";
		public static const ATLAS_SCREEN:String = "Atlas";
		public static const LOGS_SCREEN:String = "Logs";

		public static const _SCREENS:Vector.<String> = Vector.<String>([ANIMATION_SCREEN, ATLAS_SCREEN, LOGS_SCREEN]);

		private static var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private static var _currentAssetIndex:int;

		public static function get currentAssetID():String
		{
			return ExportHelper.getLibraryAt(_currentAssetIndex).location;
		}

		private static var _actionItemDatas:Vector.<ActionItemData>;

		private function tabBar_changeHandler(event:Event):void
		{
			const tabBar:TabBar = event.target as TabBar;
			const screenID:String = tabBar.selectedItem.label;

			_transitionManager.clearStack();
			_transitionManager.skipNextTransition = true;

			// clear
			if (_navigator.activeScreen)
				IFlumpyScreen(_navigator.activeScreen).clear();

			// bind initial
			whenScreenInitialized(screenID);

			// show view
			_navigator.showScreen(screenID);

			tabChangeSignal.dispatch(screenID);
		}

		private function whenScreenInitialized(screenID:String):void
		{
			var lib:XflLibrary = ExportHelper.getLibraryAt(_currentAssetIndex);

			if (!lib)
				return;

			var textureAtlasData:TextureAtlasData = AnimationHelper.getTextureAtlasData(lib);

			switch (screenID)
			{
				case ANIMATION_SCREEN:

					AnimationScreen.initializedSignal.addOnce(function(animationScreen:AnimationScreen):void
					{
						// injection 
						FlumpAppModel.requestShowAnimationSignal.dispatch(_actionItemDatas, textureAtlasData.totalMemory, textureAtlasData.totalPercentSize);
					});
					break;
				case ATLAS_SCREEN:

					AtlasScreen.initializedSignal.addOnce(function(atlasScreen:AtlasScreen):void
					{
						// injection 
						FlumpAppModel.requestShowAtlasSignal.dispatch(lib, textureAtlasData);
					});
					break;
				case LOGS_SCREEN:

					LogsScreen.initializedSignal.addOnce(function(logsScreen:LogsScreen):void
					{
						// injection 
						FlumpAppModel.requestShowLogsSignal.dispatch(currentAssetID, ExportHelper.logs);
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

			// wait for extra info
			var lib:XflLibrary = ExportHelper.getLibraryAt(index);
			_actionItemDatas = AnimationHelper.init(lib);
			var textureAtlasData:TextureAtlasData = AnimationHelper.getTextureAtlasData(lib);

			switch (currentScreenID)
			{
				case ANIMATION_SCREEN:
					if (!_actionItemDatas || _actionItemDatas.length <= 0)
					{
						currentScreenID = LOGS_SCREEN;
					}
					else
					{
						FlumpAppModel.requestShowAnimationSignal.dispatch(_actionItemDatas, textureAtlasData.totalMemory, textureAtlasData.totalPercentSize);
					}
					break;
				case ATLAS_SCREEN:
					FlumpAppModel.requestShowAtlasSignal.dispatch(lib, textureAtlasData);
					break;
				case LOGS_SCREEN:
					FlumpAppModel.requestShowLogsSignal.dispatch(currentAssetID, ExportHelper.logs);
					break;
			}
		}

		// clear -----------------------------------------------------------------------

		public function clear():void
		{
			trace(" ! " + this + ".clear");

			if (_navigator.activeScreen)
				IFlumpyScreen(_navigator.activeScreen).clear();
		}
	}
}
