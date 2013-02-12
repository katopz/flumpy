package
{
	import com.debokeh.io.WFile;
	import com.debokeh.works.IWork;
	import com.sleepydesign.flumpy.FlumpyApp;
	
	[SWF(backgroundColor = "#FFFFFF", frameRate = "60", width = "960", height = "640", embedAsCFF = "false")]
	public class flumpy extends FlumpyApp
	{
		public static function importFolder():IWork
		{
			return new WFile().browseForDirectory();
		}
		
		public static function exportFolder():IWork
		{
			return new WFile().browseForDirectory();
		}
	}
}