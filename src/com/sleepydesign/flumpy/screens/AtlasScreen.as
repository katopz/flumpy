package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.FlumpyApp;
	import com.sleepydesign.flumpy.core.MovieCreator;
	import com.sleepydesign.flumpy.model.FlumpAppModel;
	import com.sleepydesign.system.DebugUtil;
	import com.threerings.text.TextFieldUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import flump.export.Atlas;
	import flump.export.AtlasUtil;
	import flump.export.TexturePacker;
	import flump.xfl.XflLibrary;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Sprite;
	import starling.events.Event;

	[Event(name = "complete", type = "starling.events.Event")]

	public class AtlasScreen extends Screen
	{
		// mediator.startup
		public static const initializedSignal:Signal = new Signal(AtlasScreen);

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

			// mediator
			initMediator();

			// ready to roll
			initializedSignal.dispatch(this);
		}

		private function initMediator():void
		{
			FlumpAppModel.requestShowAtlasSignal.add(showAtlas);
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

			_movieContainer = new starling.display.Sprite;
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

			// scale

			var scaleLabel:Label = new Label();
			scaleLabel.text = "Scale";
			_headerContainer.addChild(scaleLabel);

			var decreaseButton:Button = new Button;
			decreaseButton.label = "-"
			_headerContainer.addChild(decreaseButton);
			decreaseButton.addEventListener(Event.TRIGGERED, trace);

			var _progress:Slider = new Slider();
			_progress.minimum = 0;
			_progress.maximum = 1;
			_progress.value = 1;
			_progress.step = 0.1;
			_progress.addEventListener(Event.CHANGE, trace);
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

			// TODO : update from real data
			var _radio1:Label = new Label();
			_radio1.text = "Memory used : 100KB";
			_radioContainer.addChild(_radio1);

			// TODO : update from real data
			var _radio2:Label = new Label();
			_radio2.text = "Atlas Wasted : 66.67%";
			_radioContainer.addChild(_radio2);

			_footer.addChild(_radioContainer);
		}

		override protected function draw():void
		{
			_currentWidth = actualWidth - 320;

			_header.width = _currentWidth;
			_header.height = 32;
			_header.validate();

			_footer.width = _currentWidth;
			_footer.height = 32;
			_footer.validate();

			_container.y = _header.height;
			_container.width = _currentWidth;
			_container.height = actualHeight - _header.height - _footer.height;

			_container.validate();

			_body.width = _currentWidth;
			_body.height = _container.height;
			_body.validate();

			// TODO : responsive to movie container size, test with bella
			if (_movieContainer)
			{
				_movieContainer.x = _currentWidth * .5;
				_movieContainer.y = 32 * 3 + _container.height * .5;
			}

			// for preview atlas texture
			_atlasCanvas.x = 350;
			_atlasCanvas.y = _container.y + 32 * 2;

			// bg TODO : custom bg
			/*
			_atlasCanvas.graphics.clear();
			_atlasCanvas.graphics.beginFill(0xFFFFFF, .5);
			_atlasCanvas.graphics.drawRect(0, 0, _currentWidth, _container.height - _atlasCanvas.y);
			_atlasCanvas.graphics.endFill();
			*/

			//_atlasCanvas.scrollRect = new Rectangle(0, 0, _currentWidth, _container.height);
		}

		private var _atlasCanvas:flash.display.Sprite = new flash.display.Sprite();

		private var _currentWidth:int = 610;

		protected function showAtlas(lib:XflLibrary):void
		{
			DebugUtil.trace(" * showAtlas : " + lib.location);

			clear();

			const scale:Number = 1;
			var atlases:Vector.<Atlas> = TexturePacker.withLib(lib).baseScale(scale).createAtlases();

			if (!atlases || atlases.length <= 0)
			{
				DebugUtil.trace(" ! No atlas found.");
				return;
			}

			for (var i:int = 0; i < atlases.length; ++i)
			{
				var atlas:Atlas = atlases[i];
				var atlasSprite:flash.display.Sprite = AtlasUtil.toSprite(atlas);
				var w:int = atlasSprite.width;
				var h:int = atlasSprite.height;

				atlasSprite.y = _atlasCanvas.height;

				// atlas info
				var tf:TextField = TextFieldUtil.newBuilder().text("Atlas " + i + ": " + int(w) + "x" + int(h)).color(0x0).autoSizeCenter().build();

				tf.x = 2;
				tf.y = _atlasCanvas.height;
				_atlasCanvas.addChild(tf);

				// border
				atlasSprite.graphics.lineStyle(1, 0x0000ff);
				atlasSprite.graphics.drawRect(0, 0, w, h);
				atlasSprite.graphics.endFill();

				_atlasCanvas.addChild(atlasSprite);
			}

			// TODO : scroll
			FlumpyApp.stage2d.addChild(_atlasCanvas);
		}

		public function clear():void
		{
			if (_atlasCanvas)
			{
				_atlasCanvas.removeChildren();
				//_atlasCanvas.graphics.clear();

				if (_atlasCanvas.parent)
					_atlasCanvas.parent.removeChild(_atlasCanvas);
			}
		}

		override public function dispose():void
		{
			trace(" ! " + this + ".dispose");

			FlumpAppModel.requestShowAtlasSignal.remove(showAtlas);

			clear();
			_atlasCanvas = null;

			super.dispose();
		}
	}
}
