package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.FlumpyListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="showVertical",type="starling.events.Event")]

	public class MainMenuScreen extends Screen
	{
		public static const SHOW_VERTICAL:String = "showVertical";

		public function MainMenuScreen()
		{
			super();
		}
		
		private var _container:ScrollContainer;

		private var _header:Header;
		private var _list:List;

		override protected function initialize():void
		{
			_header = new Header();
			_header.title = "Flumpy v1.0";
			addChild(_header);
			
			var previewButton:Button = new Button;
			previewButton.label = "preview";
			
			var logButton:Button = new Button;
			logButton.label = "log";
			
			_list = new List();
			_list.dataProvider = new ListCollection(
			[
				//{ text: "Horizontal", event: SHOW_HORIZONTAL },
				{ text: "m40s1_game_intro_ani", event: SHOW_VERTICAL , accessory: previewButton },
				{ text: "m40s1_game_story_ani", event: SHOW_VERTICAL , missing: ["fla", "swf"], accessory: logButton},
				{ text: "m40s1_game_outro_ani", event: SHOW_VERTICAL , missing: ["fla"]}
				//{ text: "Tiled Rows", event: SHOW_TILED_ROWS },
				//{ text: "Tiled Columns", event: SHOW_TILED_COLUMNS },
			]);
			_list.itemRendererFactory = tileListItemRendererFactory;
			_list.itemRendererProperties.labelField = "text";
			_list.addEventListener(Event.CHANGE, list_changeHandler);
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				_list.itemRendererProperties.accessorySourceFunction = accessorySourceFunction;
			}
			else
			{
				_list.selectedIndex = 0;
			}
			addChild(_list);
			
			var _exportButton:Button = new Button();
			_exportButton.label = "export";
			_exportButton.addEventListener(Event.TRIGGERED, exportButton_triggeredHandler);
			
			_header.rightItems = new <DisplayObject>[_exportButton];
		}
		
		private function exportButton_triggeredHandler(event:Event):void
		{
			//TODO
			trace("todo");
			//dispatchEventWith(EXPORT);
		}
		
		private var padding:int = 8;
		
		protected function tileListItemRendererFactory(item:Object, index:int):IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.height = 40;
			renderer.labelOffsetX = -6;//padding;
			renderer.labelOffsetY = -9;
			
			//renderer.iconSourceField = "texture";
			//renderer.iconPosition = Button.ICON_POSITION_TOP;
			
			// FLA status
			var _flaCheck:Check = new Check();
			_flaCheck.isSelected = (item.missing && item.missing.indexOf("fla")!=-1);
			_flaCheck.label = "fla";
			_flaCheck.x = padding + 0;
			_flaCheck.y = renderer.height - 19;
			renderer.addChild(_flaCheck);
			
			// SWF status
			var _swfCheck:Check = new Check();
			_swfCheck.isSelected = (item.missing && item.missing.indexOf("swf")!=-1);
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
		
		private function onExportCheckChangeHandler(event:Event):void
		{
			trace(ToggleSwitch(event.target).isSelected);
			//_list.dataProvider.addItem({ text: "m40s1_game_in_ani", event: SHOW_VERTICAL });
		}
		
		override protected function draw():void
		{
			_header.width = actualWidth;
			_header.validate();

			_list.y = _header.height;
			_list.width = actualWidth;
			_list.height = actualHeight - _list.y;
		}

		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}

		private function list_changeHandler(event:Event):void
		{
			const eventType:String = _list.selectedItem.event as String;
			
			// ignore for now
			if(eventType == SHOW_VERTICAL)
				return;
			
			dispatchEventWith(eventType);
		}
	}
}
