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
		//DONE// - [atlas] status bar
		- [atlas] texture scale
		- [menu] monitor file change and auto refresh (should be delay for 1 sec)
		- [atlas] test multi texture
		- [logs] log error/warning icon
		- [atlas] custom bg color/image
		- [export] disable button that shouldn't press
		- [export] export each item
		- [atlas] change width/height info

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
