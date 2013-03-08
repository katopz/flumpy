package com.sleepydesign.flumpy.screens
{
	import com.sleepydesign.flumpy.core.ExportHelper;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	
	import flump.xfl.ParseError;

	[Event(name = "complete", type = "starling.events.Event")]

	public class LogsScreen extends Screen
	{
		private var _logList:List;

		override protected function initialize():void
		{
			// assets list -------------------------------------------------------------------------

			addChild(_logList = new List);

			_logList.dataProvider = new ListCollection();

			for each (var parseError:ParseError in ExportHelper.logs)
				_logList.dataProvider.addItem({text: "[" + parseError.location + "] " + parseError.severity + " : " + parseError.message});

			_logList.itemRendererProperties.labelField = "text";

			// mediator -------------------------------------------------------------------------

			ExportHelper.importErrorSignal.add(addLogs);
		}

		public function addLogs(path:String, parseErrors:Vector.<ParseError>):void
		{
			for each (var parseError:ParseError in parseErrors)
			{
				if (!_logList.dataProvider)
					_logList.dataProvider = new ListCollection;

				_logList.dataProvider.addItem({text: "[" + parseError.severity + "] " + parseError.message});
			}
		}

		override protected function draw():void
		{
			_logList.y = 32;
			_logList.width = actualWidth;
			_logList.height = actualHeight;
		}
	}
}
