package
{
	import com.sleepydesign.flumpy.FlumpyApp;
	
	import flash.ui.ContextMenu;

	[SWF(backgroundColor = "#FFFFFF", frameRate = "60", width = "960", height = "640", embedAsCFF = "false")]
	public class flumpy extends FlumpyApp
	{
		public function flumpy()
		{
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			super();
		}
	}
}