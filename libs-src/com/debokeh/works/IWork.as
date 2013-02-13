package com.debokeh.works
{
	public interface IWork
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
		function whenSuccess(callback:Function):IWork;
	}
}