package com.sleepydesign.flumpy.model
{

	public class ActionItemData
	{
		public var movie:String;
		public var memory:int;
		public var drawn:int;

		public function ActionItemData(movie:String, memory:int, drawn:int)
		{
			this.movie = movie;
			this.memory = memory;
			this.drawn = drawn;
		}
		
		public function toObject():Object
		{
			return {text:movie, memory:memory, drawn:drawn};
		}
	}
}
