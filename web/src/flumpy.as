package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	
	import feathers.examples.componentsExplorer.Main;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;

	[SWF(backgroundColor = "#FFFFFF", frameRate = "60", width = "960", height = "640", embedAsCFF = "false")]
	public class flumpy extends Sprite
	{
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
			DeviceCapabilities.dpi = 326;
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
			
			const _starling:Starling = new Starling(Main, stage);
			_starling.enableErrorChecking = false;
			_starling.start();
		}
	}
}