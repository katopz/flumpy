package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	
	import feathers.examples.layoutExplorer.Main;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;

	[SWF(backgroundColor = "#FFFFFF", frameRate = "60", width = "960", height = "640", embedAsCFF = "false")]
	public class flumpy extends Sprite
	{
		private var _starling:Starling;
		
		public function flumpy()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(...args):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			// init
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			//pretends to be an iPhone Retina screen
			DeviceCapabilities.dpi = 96;//326;
			DeviceCapabilities.screenPixelWidth = 960;
			DeviceCapabilities.screenPixelHeight = 640;
			
			start();
		}
		
		private function start():void
		{
			// hm?
			graphics.clear();
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			
			_starling = new Starling(Main, stage);
			_starling.enableErrorChecking = false;
			_starling.start();
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			this._starling.stage.stageWidth = this.stage.stageWidth;
			this._starling.stage.stageHeight = this.stage.stageHeight;
			
			const viewPort:Rectangle = this._starling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			try
			{
				this._starling.viewPort = viewPort;
			}
			catch(error:Error) {}
		}
		
		private function stage_deactivateHandler(event:Event):void
		{
			this._starling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this._starling.start();
		}
	}
}