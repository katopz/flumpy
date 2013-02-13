package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.AnimationHelper;
	import com.sleepydesign.flumpy.core.ExportHelper;
	import com.sleepydesign.flumpy.core.MovieCreator;
	import com.sleepydesign.flumpy.data.VerticalLayoutSettings;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.core.ToggleGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import flump.display.Library;
	import flump.display.Movie;
	
	import starling.display.Sprite;
	import starling.events.Event;

	[Event(name = "complete", type = "starling.events.Event")]

	public class AnimationScreen extends Screen
	{
		public var settings:VerticalLayoutSettings;

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
			
			var btn:Button=new Button;
			btn.label = "test"
			_body.addChild(btn);
			btn.addEventListener(Event.TRIGGERED, testButton_triggeredHandler);
			
			/*
			[Embed(source = "/../assets-dev/mascot.zip", mimeType = "application/octet-stream")]
			const MASCOT_ZIP:Class;

			const loader:Future = LibraryLoader.loadBytes(ByteArray(new MASCOT_ZIP()));
			loader.succeeded.add(onLibraryLoaded);
			loader.failed.add(function(e:Error):void
			{
				throw e;
			});
			*/
			_movieContainer = new Sprite;
			addChild(_movieContainer);
		}

		private var _movieCreator:MovieCreator;
		private var _movieContainer:starling.display.Sprite;

		protected function onLibraryLoaded(library:Library):void
		{
			_movieCreator = new MovieCreator(library);
			_movieContainer = _movieCreator.createMovie("walk");
			//_body.addChild(_movieContainer);
			addChild(_movieContainer);

			// Clean up after ourselves when the screen goes away.
			addEventListener(Event.REMOVED_FROM_STAGE, function(... _):void
			{
				_movieCreator.library.dispose();
			});
			
			draw();
		}

		// header -----------------------------------------------------------------------

		private var _header:Header;

		private function initHeader():void
		{
			_header = new Header();
			_container.addChild(_header);

			const radioLayout:HorizontalLayout = new HorizontalLayout();
			radioLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			radioLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			radioLayout.gap = 20 * dpiScale;
			radioLayout.padding = 8;

			var _radioGroup:ToggleGroup = new ToggleGroup();
			_radioGroup.addEventListener(Event.CHANGE, radioGroup_changeHandler);

			var _radioContainer:ScrollContainer = new ScrollContainer();
			_radioContainer.layout = radioLayout;
			_radioContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_radioContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;

			var _radio1:Radio = new Radio();
			_radio1.label = "walk";
			_radioGroup.addItem(_radio1);
			_radioContainer.addChild(_radio1);

			var _radio2:Radio = new Radio();
			_radio2.label = "run";
			_radioGroup.addItem(_radio2);
			_radioContainer.addChild(_radio2);

			_header.addChild(_radioContainer);
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
			if(_movieContainer)
			{
				_movieContainer.x = currentWidth*.5;
				_movieContainer.y = 32*3 + _container.height*.5;
			}
		}
		
		private function testButton_triggeredHandler(event:Event):void
		{
			AnimationHelper.init(ExportHelper.getLibraryAt(0));
			
			AnimationHelper.initContainer(_movieContainer);
			AnimationHelper.displayLibraryItem("walk");
		}

		private function radioGroup_changeHandler(event:Event):void
		{
			//_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			//invalidate();
			trace("todo");
		}

		private function pageIndicator_changeHandler(event:Event):void
		{
			//invalidate();
			trace("todo");
		}
	}
}
