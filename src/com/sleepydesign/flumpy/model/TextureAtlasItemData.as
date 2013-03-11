package com.sleepydesign.flumpy.model
{
	import flash.geom.Rectangle;

	public class TextureAtlasItemData
	{
		public var id:String;
		public var memory:int;
		public var bound:Rectangle;

		public function TextureAtlasItemData(id:String, memory:int, bound:Rectangle)
		{
			this.id = id;
			this.memory = memory;
			this.bound = bound;
		}

		public function toObject():Object
		{
			return {text: id, memory: memory, bound:bound};
		}
	}
}
