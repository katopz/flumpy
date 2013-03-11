package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.AnimationHelper;
	import com.sleepydesign.flumpy.model.ActionItemData;
	import com.sleepydesign.flumpy.model.FlumpAppModel;
	import com.sleepydesign.flumpy.themes.VerticalLayoutSettings;
	import com.sleepydesign.utils.StringUtil;

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

			// actions picker
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

			// visibility
			_pickerList.visible = _actionList.visible = false;

			// prepare canvas
			addChild(_movieContainer = new Sprite);
			AnimationHelper.initContainer(_movieContainer);
		}

		private function onSelectActionItem(event:starling.events.Event):void
		{
			// can be -1 then null while reset
			if (List(event.target).selectedItem)
				act(List(event.target).selectedItem.text);
		}

		// footer -----------------------------------------------------------------------

		private var _footer:Header;
		private var _footer_radio1:Label;
		private var _footer_radio2:Label;

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

			_radioContainer.addChild(_footer_radio1 = new Label);
			_radioContainer.addChild(_footer_radio2 = new Label);

			_footer.addChild(_radioContainer);
		}

		public function updateStatusBar(totalMemory:Number, totalPercentSize:Number):void
		{
			_footer_radio1.text = "Memory used : " + StringUtil.formatThousand(Math.ceil(totalMemory / 1000).toString()) + "KB";
			_footer_radio2.text = "Atlas Wasted : " + Number(totalPercentSize * 100).toPrecision(4) + "%";
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

			_pickerList.y = 32 + 4;
			_pickerList.width = 96;

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

		public function showActionItemDatas(actionItemDatas:Vector.<ActionItemData>, totalMemory:Number, totalPercentSize:Number):void
		{
			if (!actionItemDatas || actionItemDatas.length <= 0)
			{
				// visibility
				_pickerList.visible = _actionList.visible = false;

				return;
			}

			// visibility
			_pickerList.visible = _actionList.visible = true;

			// remove old stuff
			if (_actionList.dataProvider)
			{
				_actionList.dataProvider.removeAll();
				_actionList.dataProvider = new ListCollection;
			}

			trace(" ! actionItemDatas : " + actionItemDatas.length);

			for each (var actionItemData:ActionItemData in actionItemDatas)
				_actionList.dataProvider.push(actionItemData.toObject());

			// reset selectedIndex to -1;
			_actionList.deselect();

			// auto show first movie
			_actionList.selectedIndex = 0;

			// update footer
			updateStatusBar(totalMemory, totalPercentSize);
		}

		override public function dispose():void
		{
			trace(" ! " + this + ".dispose");

			FlumpAppModel.requestShowAnimationSignal.remove(showActionItemDatas);

			super.dispose();
		}
	}
}
