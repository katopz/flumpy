package com.debokeh.io
{
	import com.debokeh.works.IWork;
	import com.debokeh.works.Work;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileReference;

	public class WFile extends Work implements IWork
	{
		// native ---------------------------------------------------------------------------------------------
		
		private function _browseForDirectory(title:String = "Select folder.", eventHandler:Function = null):FileReference
		{
			directory = File.desktopDirectory;
			
			function _eventHandler(event:Event):void
			{
				directory.removeEventListener(Event.CANCEL, _eventHandler);
				directory.removeEventListener(Event.SELECT, _eventHandler);
				
				if (eventHandler is Function)
					eventHandler(event);
				
				if (event.type == Event.SELECT)
					_handler(event);
			}
			
			// add
			directory.addEventListener(Event.CANCEL, _eventHandler);
			directory.addEventListener(Event.SELECT, _eventHandler);
			
			// browse
			directory.browseForDirectory(title);
			
			return directory;
		}
		
		private function _handler(event:Event):void
		{
			var file:File = File(event.target);
			
			if(_whenDone is Function)
				_whenDone(file);
		}
		
		// work ---------------------------------------------------------------------------------------------
		
		public var directory:File;
		
		public function browseForDirectory(title:String = "Select folder.", eventHandler:Function = null):WFile
		{
			_browseForDirectory(title);
			
			return this;
		}
	}
}