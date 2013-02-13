package com.debokeh.works
{
	public class Work implements IWork
	{
		/**
		 * target
		 * 
		 * + start
		 *   - success
		 *   - fail 
		 * + progress
		 *   - success
		 *   - fail
		 * + complete
		 *   - success
		 *   - fail 
		 * 
		 */
		public function Work()
		{
		}
		
		// callback ---------------------------------------------------------------------------------------------
		
		public var onSuccess:Function;
		
		public function whenSuccess(callback:Function):IWork
		{
			onSuccess = callback;
			
			return this;
		}
	}
}