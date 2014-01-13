package  
{
	import org.flixel.FlxState;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	import org.flixel.FlxG;
	import StartScreen.Menu;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class CreditsState extends FlxState 
	{
		
		public function CreditsState() 
		{
			var ms:Menu = new Menu();
			var b:FlxButtonPlus = new FlxButtonPlus(300, 100, FlxG.switchState, [ms], "Credits Stuff Goes Here");
			
			add(b);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}