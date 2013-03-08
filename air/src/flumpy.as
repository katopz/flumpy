package
{
	import com.debokeh.io.WFile;
	import com.debokeh.works.IWork; 
	import com.sleepydesign.flumpy.FlumpyApp;
	
	[SWF(backgroundColor = "#FFFFFF", frameRate = "60", width = "960", height = "640", embedAsCFF = "false")]
	public class flumpy extends FlumpyApp
	{
		/*
		TODO
		1. [atlas] status bar
		2. [atlas] texture scale
		3. [menu] monitor file change and auto refresh (should be delay for 1 sec)
		4. [atlas] test multi texture
		5. [logs] log error/warning icon
		6. [atlas] custom bg color/image
		7. [export] disable button that shouldn't press
		8. [export] export each item
		9. [atlas] change width/height info
		
		*/
		
		public static function importFolder():IWork
		{
			return WFile.browseForDirectory();
		}
		
		public static function exportFolder():IWork
		{
			return WFile.browseForDirectory();
		}
	}
}