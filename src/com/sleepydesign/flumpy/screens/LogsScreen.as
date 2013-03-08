package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.model.FlumpAppModel;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	
	import flump.xfl.ParseError;
	
	import org.osflash.signals.Signal;

	[Event(name = "complete", type = "starling.events.Event")]

	public class LogsScreen extends Screen
	{
		// mediator.startup
		public static const initializedSignal:Signal = new Signal(LogsScreen);
		
		override protected function initialize():void
		{
			// layout
			initLayout();
			
			// mediator
			initMediator();
			
			// ready to roll
			initializedSignal.dispatch(this);
		}
		
		private function initMediator():void
		{
			// injected
			FlumpAppModel.requestShowLogsSignal.add(showLogs);
		}
		
		// layout -----------------------------------------------------------------------
		
		private var _logList:List;
		
		private function initLayout():void
		{
			addChild(_logList = new List);
			_logList.dataProvider = new ListCollection();
			_logList.itemRendererProperties.labelField = "text";
			_logList.y = 32;
		}

		public function showLogs(assetID:String, parseErrors:Vector.<ParseError>):void
		{
			if (_logList.dataProvider)
				_logList.dataProvider.removeAll();
			
			for each (var parseError:ParseError in parseErrors)
			{
				if(parseError.location.split(":")[0] == assetID)
					_logList.dataProvider.addItem({text: "[" + parseError.location + "] " + parseError.severity + " : "+ parseError.message});
			}
		}

		override protected function draw():void
		{
			_logList.width = actualWidth;
			_logList.height = actualHeight;
		}
	}
}
