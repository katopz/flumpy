package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TabBar;
	import feathers.core.ToggleGroup;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Quad;
	import starling.events.Event;

	[Event(name = "complete", type = "starling.events.Event")]

	[Event(name = "showSettings", type = "starling.events.Event")]
	[Event(name = "showLogs", type = "starling.events.Event")]

	public class LogsScreen extends Screen
	{
		public static const SHOW_SETTINGS:String = "showSettings";
		public static const SHOW_LOGS:String = "showLogs";

		public var settings:VerticalLayoutSettings;

		private var _container:ScrollContainer;
		private var _header:Header;
		private var _backButton:Button;
		private var _settingsButton:Button;

		// tab
		private var _tabBar:TabBar;
		private var _label:Label;
		
		override protected function initialize():void
		{
			//y = settings.marginTop;
				
			const layout:VerticalLayout = new VerticalLayout();
			layout.gap = settings.gap;
			layout.paddingTop = settings.paddingTop;
			layout.paddingRight = settings.paddingRight;
			layout.paddingBottom = settings.paddingBottom;
			layout.paddingLeft = settings.paddingLeft;
			layout.horizontalAlign = settings.horizontalAlign;
			layout.verticalAlign = settings.verticalAlign;
			
			_container = new ScrollContainer();
			_container.layout = layout;
			//when the scroll policy is set to on, the "elastic" edges will be
			//active even when the max scroll position is zero
			_container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
			_container.snapScrollPositionsToPixels = true;
			addChild(_container);
			for (var i:int = 0; i < settings.itemCount; i++)
			{
				var size:Number = 100;
				var quad:Quad = new Quad(size, 480, 0x333333 + int(0x333333*Math.random()));
				_container.addChild(quad);
			}

			_header = new Header();
			addChild(_header);

			const containerLayout:HorizontalLayout = new HorizontalLayout();
			containerLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			containerLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			containerLayout.gap = 20 * this.dpiScale;
			containerLayout.padding = 8;
			
			var _radioGroup:ToggleGroup = new ToggleGroup();
			_radioGroup.addEventListener(Event.CHANGE, radioGroup_changeHandler);
			
			var _radioContainer:ScrollContainer = new ScrollContainer();
			_radioContainer.layout = containerLayout;
			_radioContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_radioContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			addChild(_radioContainer);
			
			var _radio1:Radio = new Radio();
			_radio1.label = "Plain";
			_radioGroup.addItem(_radio1);
			_radioContainer.addChild(_radio1);
			
			var _radio2:Radio = new Radio();
			_radio2.label = "Tree";
			_radioGroup.addItem(_radio2);
			_radioContainer.addChild(_radio2);
			
			_header.addChild(_radioContainer);
		}

		private function radioGroup_changeHandler(event:Event):void
		{
			//_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			//invalidate();
			trace("todo");
		}
		
		override protected function draw():void
		{
			_header.width = actualWidth;
			_header.validate();

			_container.y = _header.height;
			_container.width = actualWidth;
			_container.height = actualHeight - _container.y;
			
		}

		private function logButton_triggeredHandler(event:Event):void
		{
			dispatchEventWith(SHOW_LOGS);
		}

		private function settingsButton_triggeredHandler(event:Event):void
		{
			dispatchEventWith(SHOW_SETTINGS);
		}
	}
}
