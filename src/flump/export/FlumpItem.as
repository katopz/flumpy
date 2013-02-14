package flump.export
{
	import flump.xfl.XflLibrary;
	
	import org.osflash.signals.Signal;

	public class FlumpItem
	{
		public var fileName:String;
		public var modified:String;
		public var valid:String = PENDING;
		public var lib:XflLibrary;
		
		public var invalidateSignal:Signal = new Signal(FlumpItem);
		
		public function FlumpItem(fileName:String, modified:Ternary, valid:Ternary, lib:XflLibrary)
		{
			this.lib = lib;
			this.fileName = fileName;
			
			updateModified(modified);
			updateValid(valid);
		}
		
		public function updateValid(newValid:Ternary):void
		{
			if (newValid == Ternary.TRUE)
				valid = YES;
			else if (newValid == Ternary.FALSE)
				valid = ERROR;
			else
				valid = PENDING;
			
			invalidateSignal.dispatch(this, "valid");
		}
		
		public function get isValid():Boolean
		{
			return valid == YES;
		}
		
		public function updateModified(newModified:Ternary):void
		{
			if (newModified == Ternary.TRUE)
				modified = YES;
			else if (newModified == Ternary.FALSE)
				modified = " ";
			else
				modified = PENDING;
			
			invalidateSignal.dispatch(this, "modified");
		}
		
		private static const PENDING:String = "...";
		private static const ERROR:String = "ERROR";
		private static const YES:String = "Yes";
	}
}
