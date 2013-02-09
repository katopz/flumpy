package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.layout.VerticalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;

	[Event(name = "complete", type = "starling.events.Event")]

	[Event(name = "showSettings", type = "starling.events.Event")]

	public class VerticalLayoutScreen extends Screen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function VerticalLayoutScreen()
		{
			super();
		}

		public var settings:VerticalLayoutSettings;

		private var _container:ScrollContainer;
		private var _header:Header;
		private var _backButton:Button;
		private var _settingsButton:Button;

		override protected function initialize():void
		{
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
				var quad:Quad = new Quad(size, size, 0xff8800);
				_container.addChild(quad);
			}

			_header = new Header();
			_header.title = "Preview";
			addChild(_header);

			var _logButton:Button = new Button();
			_logButton.label = "Log";
			_logButton.addEventListener(Event.TRIGGERED, logButton_triggeredHandler);

			_header.leftItems = new <DisplayObject>[_logButton];

			_settingsButton = new Button();
			_settingsButton.label = "export";
			_settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

			_header.rightItems = new <DisplayObject>[_settingsButton];
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
			//TODO
			trace("todo show log screen");
		}

		private function settingsButton_triggeredHandler(event:Event):void
		{
			dispatchEventWith(SHOW_SETTINGS);
		}
	}
}
