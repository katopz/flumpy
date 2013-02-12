package com.debokeh.works
{
	public class Work implements IWork
	{
		/**
		 * target
		 * 
		 * + start
		 *   - done
		 *   - fail 
		 * + progress
		 *   - done
		 *   - fail
		 * + complete
		 *   - done
		 *   - fail 
		 * 
		 */
		public function Work()
		{
		}
		
		// callback ---------------------------------------------------------------------------------------------
		
		protected var _whenDone:Function;
		
		public function whenDone(callback:Function):IWork
		{
			_whenDone = callback;
			return this;
		}
	}
}