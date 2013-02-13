package com.debokeh.io
{
	import com.debokeh.works.IWork;
	import com.debokeh.works.Work;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileReference;

	public class WFile
	{
		private static const _work: Work = new Work;
		
		// native ---------------------------------------------------------------------------------------------
		
		private static function _browseForDirectory(title:String = "Select folder.", eventHandler:Function = null):FileReference
		{
			var directory:File = File.desktopDirectory;
			
			function _eventHandler(event:Event):void
			{
				// release
				directory.removeEventListener(Event.CANCEL, _eventHandler);
				directory.removeEventListener(Event.SELECT, _eventHandler);
				
				// handler
				if (eventHandler is Function)
					eventHandler(event);
				
				if (event.type == Event.SELECT)
					_handler(event);
				
				// release
				directory = null;
			}
			
			// add
			directory.addEventListener(Event.CANCEL, _eventHandler);
			directory.addEventListener(Event.SELECT, _eventHandler);
			
			// browse
			directory.browseForDirectory(title);
			
			return directory;
		}
		
		private static function _handler(event:Event):void
		{
			var file:File = File(event.target);
			
			// handler
			if(_work.onSuccess is Function)
				_work.onSuccess(file);
			
			// release
			file = null;
		}
		
		// work ---------------------------------------------------------------------------------------------
		
		public static function browseForDirectory(title:String = "Select folder.", eventHandler:Function = null):IWork
		{
			_browseForDirectory(title, eventHandler);
			
			return _work;
		}
	}
}