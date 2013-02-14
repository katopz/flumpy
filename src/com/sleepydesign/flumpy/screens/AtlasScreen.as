package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.MovieCreator;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.Sprite;
	import starling.events.Event;

	[Event(name = "complete", type = "starling.events.Event")]

	public class AtlasScreen extends Screen
	{
		override protected function initialize():void
		{
			// layout
			initLayout();

			// body
			initBody();

			// footer
			initFooter();

			// header
			initHeader();
		}

		// layout -----------------------------------------------------------------------

		private var _container:ScrollContainer;

		private function initLayout():void
		{
			addChild(_container = new ScrollContainer());
			_container.layout = new AnchorLayout();
			_container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
		}

		// body -----------------------------------------------------------------------

		private var _body:ScrollContainer;

		private function initBody():void
		{
			_container.addChild(_body = new ScrollContainer());

			const radioLayout:HorizontalLayout = new HorizontalLayout();
			radioLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			radioLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			_body.layout = radioLayout;
			_body.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_body.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;

			var btn:Button = new Button;
			btn.label = "test"
			_body.addChild(btn);
			btn.addEventListener(Event.TRIGGERED, testButton_triggeredHandler);

			_movieContainer = new Sprite;
			addChild(_movieContainer);
		}

		private var _movieCreator:MovieCreator;
		private var _movieContainer:starling.display.Sprite;

		// header -----------------------------------------------------------------------

		private var _header:Header;

		private function initHeader():void
		{
			_header = new Header();
			_container.addChild(_header);

			const headerLayout:HorizontalLayout = new HorizontalLayout();
			headerLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			headerLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			headerLayout.gap = 20 * dpiScale;
			headerLayout.padding = 8;

			var _headerContainer:ScrollContainer = new ScrollContainer();
			_headerContainer.layout = headerLayout;
			_headerContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_headerContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;

			var scaleLabel:Label = new Label();
			scaleLabel.text = "Scale";
			_headerContainer.addChild(scaleLabel);

			var decreaseButton:Button = new Button;
			decreaseButton.label = "-"
			_headerContainer.addChild(decreaseButton);
			decreaseButton.addEventListener(Event.TRIGGERED, trace);

			var _progress:ProgressBar = new ProgressBar();
			_progress.minimum = 0;
			_progress.maximum = 1;
			_progress.value = 1;
			_headerContainer.addChild(_progress);
			
			var increaseButton:Button = new Button;
			increaseButton.label = "+"
			_headerContainer.addChild(increaseButton);
			increaseButton.addEventListener(Event.TRIGGERED, trace);

			_header.addChild(_headerContainer);
		}

		// footer -----------------------------------------------------------------------

		private var _footer:Header;

		private function initFooter():void
		{
			_footer = new Header();
			_footer.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			_container.addChild(_footer);

			const radioLayout:HorizontalLayout = new HorizontalLayout();
			radioLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			radioLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			radioLayout.padding = 8;

			var _radioContainer:ScrollContainer = new ScrollContainer();
			_radioContainer.layout = radioLayout;
			_radioContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_radioContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;

			var _radio1:Label = new Label();
			_radio1.text = "Memory used : 100KB";
			_radioContainer.addChild(_radio1);

			var _radio2:Label = new Label();
			_radio2.text = "Atlas Wasted : 66.67%";
			_radioContainer.addChild(_radio2);

			_footer.addChild(_radioContainer);
		}

		override protected function draw():void
		{
			const currentWidth:int = actualWidth - 320;

			_header.width = currentWidth;
			_header.height = 32;
			_header.validate();

			_footer.width = currentWidth;
			_footer.height = 32;
			_footer.validate();

			_container.y = _header.height;
			_container.width = currentWidth;
			_container.height = actualHeight - _header.height - _footer.height;

			_container.validate();

			_body.width = currentWidth;
			_body.height = _container.height;
			_body.validate();

			// TODO : responsive to movie container size, test with bella
			if (_movieContainer)
			{
				_movieContainer.x = currentWidth * .5;
				_movieContainer.y = 32 * 3 + _container.height * .5;
			}
		}

		private function testButton_triggeredHandler(event:Event):void
		{
		}
	}
}
