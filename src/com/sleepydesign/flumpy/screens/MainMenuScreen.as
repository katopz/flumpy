package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.ExportHelper;
	import com.sleepydesign.flumpy.model.ActionItemData;
	import com.sleepydesign.flumpy.model.AssetItemData;

	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.skins.StandardIcons;

	import flump.export.FlumpItem;

	import org.osflash.signals.Signal;

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

		// inject
		public static const assetItemUpdatedSignal:Signal = new Signal(Vector.<ActionItemData>);

		override protected function initialize():void
		{
			// header ------------------------------------------------------------------

			addChild(_header = new Header);
			_header.title = "Flumpy v1.0";

			// import/export -----------------------------------------------------------

			var _importButton:Button = new Button();
			_importButton.label = "browse import";
			_importButton.addEventListener(Event.TRIGGERED, function importButton_triggeredHandler(event:Event):void
			{
				// browse via desktop
				flumpy.importFolder().whenSuccess(ExportHelper.setImportDirectory);
			});

			var _exportButton:Button = new Button();
			_exportButton.label = "browse export";
			_exportButton.addEventListener(Event.TRIGGERED, function exportButton_triggeredHandler(event:Event):void
			{
				// browse via desktop
				flumpy.exportFolder().whenSuccess(function(... args):void
				{
					ExportHelper.exportDirectory(args[0]);
				});
			});

			addChild(_ioList = new List);

			_ioList.dataProvider = new ListCollection([{text: "Please select import path.", accessory: _importButton}, {text: "Please select export path.", accessory: _exportButton}]);

			// wtf
			_ioList.itemRendererProperties.labelField = "text";

			_ioList.verticalScrollPolicy = GroupedList.SCROLL_POLICY_OFF;

			_ioList.isSelectable = false;

			// export all button -------------------------------------------------------------------------

			var _exportAllButton:Button = new Button();
			addChild(_exportAllButton);
			_exportAllButton.x = 4;
			_exportAllButton.y = 48 * 2 + 4;
			_exportAllButton.label = "export all";
			_exportAllButton.addEventListener(Event.TRIGGERED, function exportButton_triggeredHandler(event:Event):void
			{
				ExportHelper.export();
			});

			// assets list -------------------------------------------------------------------------

			addChild(_assetList = new List);

			_assetList.itemRendererProperties.labelField = "text";
			_assetList.addEventListener(Event.CHANGE, list_changeHandler);

			// mediator -------------------------------------------------------------------------

			ExportHelper.assetImportSignal.add(addAssets);

			DetailScreen.initializedSignal.add(function(detailScreen:DetailScreen):void
			{
				trace("TODO : DetailScreen");
			});
		}

		public function addAssets(path:String, flumpItems:Vector.<FlumpItem>):void
		{
			// update import path
			_ioList.dataProvider.getItemAt(0).text = path;
			_ioList.dataProvider.updateItemAt(0);

			// not choose output folder just yet 
			if (String(_ioList.dataProvider.getItemAt(1).text).indexOf("Please") == 0)
			{
				// set export folder as import folder
				ExportHelper.exportDirectory(ExportHelper.importDirectory);

				// update export path default to import path
				_ioList.dataProvider.getItemAt(1).text = path;
				_ioList.dataProvider.updateItemAt(1);
			}

			for each (var flumpItem:FlumpItem in flumpItems)
			{
				trace("item.fileName:" + flumpItem.fileName);
				addAssetItem(flumpItem.fileName, flumpItem.invalidateSignal);
			}
		}

		public function addAssetItem(filename:String, invalidateSignal:Signal):void
		{
			if (!_assetList.dataProvider)
				_assetList.dataProvider = new ListCollection;

			var assetItemData:AssetItemData = new AssetItemData(_assetList.dataProvider.length, filename, invalidateSignal);

			_assetList.dataProvider.addItem(assetItemData.toObject());

			// watch for update
			assetItemData.updateSignal.add(onAssetItemDataUpdate);
		}

		private function onAssetItemDataUpdate(index:int, assetItemDataObject:Object):void
		{
			var _assetItemDataObject:Object = _assetList.dataProvider.getItemAt(index);
			_assetItemDataObject["accessory"] = assetItemDataObject["accessory"];
			_assetList.dataProvider.updateItemAt(index);

			// show 1st item
			if (index == 0)
				_assetList.selectedIndex = 0;
		}

		override protected function draw():void
		{
			_header.width = actualWidth - 8;
			_header.validate();

			_ioList.y = 32;
			_ioList.width = actualWidth - 8;
			_ioList.height = 32 * 2;

			_assetList.y = _ioList.y + _ioList.height + 32;
			_assetList.width = actualWidth - 8;
			_assetList.height = actualHeight - _assetList.y;
		}

		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}

		private function list_changeHandler(event:Event):void
		{
			var list:List = event.target as List;
			DetailScreen.showItemAt(list.selectedIndex);
		}
	}
}
