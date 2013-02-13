package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.ExportHelper;
	import com.sleepydesign.flumpy.data.AssetItemData;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.skins.StandardIcons;
	
	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name = "showVertical", type = "starling.events.Event")]

	public class MainMenuScreen extends Screen
	{
		public static const SHOW_VERTICAL:String = "showVertical";

		// left stuff
		
		private var _header:Header;
		private var _ioList:List;
		private var _assetList:List;

		override protected function initialize():void
		{
			// header ------------------------------------------------------------------
			
			_header = new Header();
			_header.title = "Flumpy v1.0";
			addChild(_header);
			
			// import/export -----------------------------------------------------------
			
			var _importButton:Button = new Button();
			_importButton.label = "import";
			_importButton.addEventListener(Event.TRIGGERED, function importButton_triggeredHandler(event:Event):void
			{
				// browse via desktop
				flumpy.importFolder().whenSuccess(function(... args):void
				{
					ExportHelper.importDirectory(args[0]);
				});
			});
			
			var _exportButton:Button = new Button();
			_exportButton.label = "export";
			_exportButton.addEventListener(Event.TRIGGERED, function exportButton_triggeredHandler(event:Event):void
			{
				// browse via desktop
				flumpy.exportFolder().whenSuccess(function(... args):void
				{
					ExportHelper.exportDirectory(args[0]);
				});
			});
			
			addChild(_ioList = new List);
			
			_ioList.dataProvider = new ListCollection(
				[
					{ text: "Please select import path." , accessory: _importButton },
					{ text: "Please select export path." , accessory: _exportButton }
				]);
			
			_ioList.itemRendererFactory = function(item:Object, index:int):IListItemRenderer
			{
				const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "label";
				renderer.height = 32;
				
				return renderer;
			}
			
			// wtf
			_ioList.itemRendererProperties.labelField = "text";
			
			_ioList.verticalScrollPolicy = GroupedList.SCROLL_POLICY_OFF;
			
			// assets list -------------------------------------------------------------------------

			addChild(_assetList = new List);
			
			/*
			// for test
			_list.dataProvider = new ListCollection(
			[
				//{ text: "Horizontal", event: SHOW_HORIZONTAL },
				{ text: "m40s1_game_intro_ani", event: SHOW_VERTICAL , accessory: previewButton },
				{ text: "m40s1_game_story_ani", event: SHOW_VERTICAL , missing: ["fla", "swf"], accessory: logButton},
				{ text: "m40s1_game_outro_ani", event: SHOW_VERTICAL , missing: ["fla"]}
				//{ text: "Tiled Rows", event: SHOW_TILED_ROWS },
				//{ text: "Tiled Columns", event: SHOW_TILED_COLUMNS },
			]);
			*/
			
			_assetList.itemRendererFactory = tileListItemRendererFactory;
			_assetList.itemRendererProperties.labelField = "text";
			_assetList.addEventListener(Event.CHANGE, list_changeHandler);
			
			// mediator -------------------------------------------------------------------------
			
			ExportHelper.assetImportSignal.add(addAssets);
		}
		
		protected function tileListItemRendererFactory(item:Object, index:int):IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.height = 40;
			renderer.labelOffsetX = -6; //padding;
			renderer.labelOffsetY = -9;

			//renderer.iconSourceField = "texture";
			//renderer.iconPosition = Button.ICON_POSITION_TOP;

			const padding:int = 8;

			// FLA status
			var _flaCheck:Check = new Check();
			_flaCheck.isSelected = (item.missing && item.missing.indexOf("fla") != -1);
			_flaCheck.label = "fla";
			_flaCheck.x = padding + 0;
			_flaCheck.y = renderer.height - 19;
			renderer.addChild(_flaCheck);

			// SWF status
			var _swfCheck:Check = new Check();
			_swfCheck.isSelected = (item.missing && item.missing.indexOf("swf") != -1);
			_swfCheck.label = "swf";
			_swfCheck.x = padding + 40;
			_swfCheck.y = _flaCheck.y;
			renderer.addChild(_swfCheck);

			/*
			const rightButtonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			rightButtonLayoutData.top = 10;
			rightButtonLayoutData.left = 10;
			*/
			/*
			const containerLayout:HorizontalLayout = new HorizontalLayout();
			//containerLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
			containerLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			containerLayout.gap = 20 * this.dpiScale;
			containerLayout.padding = 8;

			var _radioContainer:ScrollContainer = new ScrollContainer();
			//_radioContainer.layoutData = rightButtonLayoutData;
			_radioContainer.layout = containerLayout;
			_radioContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_radioContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			renderer.addChild(_radioContainer);

			var logButton:Button = new Button;
			logButton.label = "log";
			_radioContainer.addChild(logButton);

			var previewButton:Button = new Button;
			previewButton.label = "preview";
			_radioContainer.addChild(previewButton);

			_radioContainer.x = actualWidth - 64;
			*/

			// TODO : dynamic accessory

			return renderer;
		}

		public function addAssets(assets:Array):void
		{
			for each(var item:Object in assets)
			{
				trace("item.path:" + item.path);
				addAssetItem(new AssetItemData(item.path));
			}
		}
			
		public function addAssetItem(assetItemData:AssetItemData):void
		{
			if(!_assetList.dataProvider)
				_assetList.dataProvider = new ListCollection;
			
			_assetList.dataProvider.addItem(assetItemData.toObject());
			//_list.dataProvider.addItem({ text: "m40s1_game_in_ani", event: SHOW_VERTICAL });
		}

		override protected function draw():void
		{
			_header.width = actualWidth;
			_header.validate();
			
			_ioList.y = 32;
			_ioList.width = actualWidth;
			_ioList.height = 32*2;

			_assetList.y = _ioList.y + _ioList.height;
			_assetList.width = actualWidth;
			_assetList.height = actualHeight - _assetList.y;
		}

		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}

		private function list_changeHandler(event:Event):void
		{
			const eventType:String = _assetList.selectedItem.event as String;

			// ignore for now
			if (eventType == SHOW_VERTICAL)
				return;

			dispatchEventWith(eventType);
		}
	}
}
