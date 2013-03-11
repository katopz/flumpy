package com.sleepydesign.flumpy.model
{

	public class TextureAtlasData
	{
		public var textureItems:Vector.<TextureAtlasItemData>;

		public var totalMemory:Number;
		public var totalPercentSize:Number;

		public function TextureAtlasData(textureItems:Vector.<TextureAtlasItemData>, totalMemory:Number, totalPercentSize:Number)
		{
			this.textureItems = textureItems;

			this.totalMemory = totalMemory;
			this.totalPercentSize = totalPercentSize;
		}
	}
}
