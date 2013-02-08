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

	public class flumpy extends Sprite
	{
		public function flumpy()
		{
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			this.contextMenu = menu;
			
			if(this.stage)
			{
				this.stage.align = StageAlign.TOP_LEFT;
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			
			//pretends to be an iPhone Retina screen
			DeviceCapabilities.dpi = 326;
			DeviceCapabilities.screenPixelWidth = 960;
			DeviceCapabilities.screenPixelHeight = 640;
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		private var _starling:Starling;
		
		private function start():void
		{
			this.graphics.clear();
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			//const MainType:Class = getDefinitionByName("feathers.examples.componentsExplorer.Main") as Class;
			this._starling = new Starling(Main, this.stage);
			this._starling.enableErrorChecking = false;
			//this._starling.showStats = true;
			//this._starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
			this._starling.start();
		}
		
		private function loaderInfo_completeHandler(event:Event):void
		{
			this.start();
		}
	}
}