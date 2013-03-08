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
		
		// referrer ---------------------------------------------------------------------------------------------
		
		private var _somewhere:Object;
		
		public function at(somewhere:Object):IWork
		{
			_somewhere = somewhere;
			
			return this;
		}
		
		// callback ---------------------------------------------------------------------------------------------
		
		private var _onSuccess:Function;

		public function success(...args):Work
		{
			if(_onSuccess is Function)
				 _onSuccess.apply(this, args);
				
			return this;
		}

		public function whenSuccess(callback:Function):IWork
		{
			_onSuccess = callback;
			
			return this;
		}
		
		// release ---------------------------------------------------------------------------------------------
		
		public function dispose():IWork
		{
			// callback
			_onSuccess = null;
			
			// referrer
			_somewhere = null;
			
			return this;
		}
		
		// renew ---------------------------------------------------------------------------------------------
		
		public static function renew(_work:Work):Work
		{
			if(_work)
				_work.dispose();
				
			return _work = new Work;
		}
	}
}