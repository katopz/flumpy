package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.AnimationHelper;
	import com.sleepydesign.flumpy.model.ActionItemData;
	import com.sleepydesign.flumpy.model.FlumpAppModel;
	import com.sleepydesign.flumpy.themes.VerticalLayoutSettings;
	
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Sprite;
	import starling.events.Event;

	[Event(name = "complete", type = "starling.events.Event")]

	public class AnimationScreen extends Screen
	{
		// mediator.startup
		public static const initializedSignal:Signal = new Signal(AnimationScreen);
		
		public var settings:VerticalLayoutSettings;

		override protected function initialize():void
		{
			// layout
			initLayout();

			// body
			initBody();

			// actions
			initActions();

			// footer
			initFooter();
			
			// mediator
			initMediator();
			
			// ready to roll
			initializedSignal.dispatch(this);
		}
		
		private function initMediator():void
		{
			// injected
			FlumpAppModel.requestShowAnimationSignal.add(showActionItemDatas);
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
		private var _movieContainer:starling.display.Sprite;

		private function initBody():void
		{
			_container.addChild(_body = new ScrollContainer());

			const bodyLayout:HorizontalLayout = new HorizontalLayout();
			bodyLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			bodyLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			_body.layout = bodyLayout;
			_body.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			_body.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
		}

		// actions -----------------------------------------------------------------------
		
		private var _pickerList:PickerList;
		private var _actionList:List;

		private function initActions():void
		{
			_pickerList = new PickerList();
			_pickerList.prompt = "Actions";
			addChild(_pickerList);

			addChild(_actionList = new List);
			_actionList.itemRendererFactory = function():IListItemRenderer
			{
				const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "label";
				renderer.height = 20;

				return renderer;
			}

			_actionList.dataProvider = new ListCollection;
			_actionList.itemRendererProperties.labelField = "text";
			_actionList.addEventListener(starling.events.Event.CHANGE, onSelectActionItem);

			// prepare canvas
			addChild(_movieContainer = new Sprite);
			AnimationHelper.initContainer(_movieContainer);
		}
		
		private function onSelectActionItem(event:starling.events.Event):void
		{
			// can be -1 then null while reset
			if(List(event.target).selectedItem)
				act(List(event.target).selectedItem.text);
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

			_footer.width = currentWidth;
			_footer.height = 32;
			_footer.validate();

			_container.width = currentWidth;
			_container.height = actualHeight - _footer.height;
			_container.validate();

			_body.width = currentWidth;
			_body.height = _container.height;
			_body.validate();

			_pickerList.x = 10;
			_pickerList.y = 32 + 4;
			_pickerList.width = 96;
			_pickerList.isEnabled = false;

			_actionList.x = 10;
			_actionList.y = _pickerList.y + 22;
			_actionList.width = _pickerList.width;
			_actionList.height = _container.height - 32 - 4 - _actionList.y;
			_actionList.validate();

			// TODO : responsive to movie container size, must test with bella
			if (_movieContainer)
			{
				_movieContainer.x = currentWidth * .5;
				_movieContainer.y = 32 * 3 + _container.height * .5;
			}
		}

		private function act(action:String):void
		{
			AnimationHelper.displayLibraryItem(action);
		}
		
		public function showActionItemDatas(actionItemDatas:Vector.<ActionItemData>):void
		{
			if(!actionItemDatas || actionItemDatas.length <= 0)
				return;
			
			// remove old stuff
			if(_actionList.dataProvider)
			{
				_actionList.dataProvider.removeAll();
				_actionList.selectedIndex = -1;
			}
			
			trace(" ! actionItemDatas : " + actionItemDatas.length);
			
			for each (var actionItemData:ActionItemData in actionItemDatas)
				_actionList.dataProvider.push(actionItemData.toObject());
			
			// auto show first movie
			_actionList.selectedIndex = 0;
		}
	}
}
