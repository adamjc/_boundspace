package  
{	
	import org.flixel.*;
	import flash.ui.Mouse;
	import StartScreen.Menu;
	
	[SWF(width = "700", height = "600", backgroundColor = "#FFFFFF")];
	[Frame(factoryClass = "Preloader")]; // Tells flixel to use the default preloader.
	
	/**
	 * ...
	 * @author Adam
	 */
	public class BoundSpace extends FlxGame
	{		
		public static const SceneScale:int = 1;
		public static var SceneWidth:int = 700;
		public static var SceneHeight:int = 600;
		public static var UIMaxY:int = 79;				
		
		public function BoundSpace() 
		{
			SceneWidth = SceneWidth / SceneScale;
			SceneHeight = SceneHeight / SceneScale;
			UIMaxY = UIMaxY / SceneScale;			
			
			super(SceneWidth, SceneHeight, Menu, SceneScale);
			
			FlxG.volume = 0.2
			
			Achievements.load();
			this.forceDebugger = true;
			FlxG.flashFramerate = 60;	
			FlxG.framerate = 60;			
		}
	}	
}