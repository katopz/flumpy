package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.FlumpyListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="showHorizontal",type="starling.events.Event")]

	[Event(name="showVertical",type="starling.events.Event")]

	[Event(name="showTiledRows",type="starling.events.Event")]

	[Event(name="showTiledColumns",type="starling.events.Event")]

	public class MainMenuScreen extends Screen
	{
		public static const SHOW_HORIZONTAL:String = "showHorizontal";
		public static const SHOW_VERTICAL:String = "showVertical";
		public static const SHOW_TILED_ROWS:String = "showTiledRows";
		public static const SHOW_TILED_COLUMNS:String = "showTiledColumns";

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
			
			_list = new List();
			_list.dataProvider = new ListCollection(
			[
				//{ text: "Horizontal", event: SHOW_HORIZONTAL },
				{ text: "m40s1_game_intro_ani", event: SHOW_VERTICAL },
				{ text: "m40s1_game_story_ani", event: SHOW_VERTICAL },
				{ text: "m40s1_game_outro_ani", event: SHOW_VERTICAL }
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
		}
		
		private var padding:int = 8;
		
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.height = 40;
			renderer.labelOffsetX = -6;//padding;
			renderer.labelOffsetY = -9;
			//renderer.iconSourceField = "texture";
			//renderer.iconPosition = Button.ICON_POSITION_TOP;
			
			var _check1:Check = new Check();
			_check1.isSelected = false;
			_check1.label = "fla";
			_check1.x = padding + 0;
			_check1.y = renderer.height - 19;
			renderer.addChild(_check1);
			
			var _check2:Check = new Check();
			_check2.isSelected = false;
			_check2.label = "swf";
			_check2.x = padding + 40;
			_check2.y = _check1.y;
			renderer.addChild(_check2);
			
			var _exportCheck:Check = new Check();
			_exportCheck.isSelected = false;
			_exportCheck.label = "export";
			_exportCheck.x = actualWidth - 56;
			_exportCheck.y = renderer.height*.5 - 8;
			_exportCheck.isSelected = true;
			renderer.addChild(_exportCheck);
			
			_exportCheck.addEventListener(Event.CHANGE, onExportCheckChangeHandler);
			
			return renderer;
		}
		
		private function onExportCheckChangeHandler(event:Event):void
		{
			trace(Check(event.target).isSelected);
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
			dispatchEventWith(eventType);
		}
	}
}
