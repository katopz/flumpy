package com.sleepydesign.flumpy.data
{
	import feathers.controls.Label;
	
	import org.osflash.signals.Signal;

	public class AssetItemData
	{
		public var filename:String;
		public var modified:String;
		public var valid:String = "init";
		public var isValid:Boolean;

		public var invalidateSignal:Signal = new Signal(/*index*/int, /*fieldName*/String, /*value*/Object);
		public var index:int;
		
		public var updateSignal:Signal = new Signal(/*index*/int, /*toObject*/Object); 

		public function AssetItemData(index:int, filename:String, invalidateSignal:Signal)
		{
			this.index = index;
			this.filename = filename;

			invalidateSignal.add(onInvalidate);
		}

		/*
		TODO : DocStatus
		public var path:String;
		public var modified:String;
		public var valid:String = PENDING;
		public var lib:XflLibrary;
		*/
		public function onInvalidate(docStatus:/*DocStatus*/Object, fieldName:String):void
		{
			this[fieldName] = docStatus[fieldName];
			
			invalidateSignal.dispatch(index, fieldName, this[fieldName]);
			
			trace(fieldName + " : " +  this[fieldName]);
			
			// TODO : clean this mess status 
			isValid = (valid=="Yes");
			
			updateSignal.dispatch(index, toObject());
		}

		public function toObject():Object
		{
			var result:Object = {text: filename};

			var errorLabel:Label = new Label;
			errorLabel.text = isValid?"fine":"error";
			
			result.accessory = errorLabel;

			return result;
		}
	}
}
