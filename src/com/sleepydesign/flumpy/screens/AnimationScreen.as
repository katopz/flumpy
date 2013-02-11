package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.MovieCreator;
	import com.sleepydesign.flumpy.data.VerticalLayoutSettings;
	
	import flash.utils.ByteArray;
	
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
	import flump.display.LibraryLoader;
	import flump.display.Movie;
	import flump.executor.Future;
	
	import starling.display.DisplayObject;
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

			// header
			initHeader();

			// footer
			initFooter();
		}
		
		private var _container:ScrollContainer;
		
		private function initLayout():void
		{
			addChild(_container = new ScrollContainer());
			_container.layout = new AnchorLayout();
			_container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
		}
		
		private function initBody():void
		{
			[Embed(source="/../assets-dev/mascot.zip", mimeType="application/octet-stream")]
			const MASCOT_ZIP :Class;
			
			const loader:Future = LibraryLoader.loadBytes(ByteArray(new MASCOT_ZIP()));
			loader.succeeded.add(onLibraryLoaded);
			loader.failed.add(function(e:Error):void
			{
				throw e;
			});
		}
		
		protected var _movieCreator :MovieCreator;
		
		protected function onLibraryLoaded (library :Library) :void {
			_movieCreator = new MovieCreator(library);
			var movie :Movie = _movieCreator.createMovie("walk");
			movie.x = 320;
			movie.y = 240;
			addChild(movie);
			
			// Clean up after ourselves when the screen goes away.
			addEventListener(Event.REMOVED_FROM_STAGE, function (..._) :void {
				_movieCreator.library.dispose();
			});
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
