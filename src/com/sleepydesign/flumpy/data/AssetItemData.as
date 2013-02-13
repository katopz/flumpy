package com.sleepydesign.flumpy.data
{

	public class AssetItemData
	{
		public var text:String;

		public function AssetItemData(text:String)
		{
			this.text = text;
		}
		
		public function toObject():Object
		{
			return {text:text};
		}
	}
}
