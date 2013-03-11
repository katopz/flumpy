package com.sleepydesign.flumpy.model
{

	public class TextureAtlasItemData
	{
		public var id:String;
		public var memory:int;

		public function TextureAtlasItemData(id:String, memory:int)
		{
			this.id = id;
			this.memory = memory;
		}

		public function toObject():Object
		{
			return {text: id, memory: memory};
		}
	}
}
