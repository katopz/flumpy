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
		function whenDone(callback:Function):IWork;
	}
}