package  
{
	import CreditsScreen.CreditsScreen;
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
		protected var creditsScreen:CreditsScreen.CreditsScreen;
		protected var menu:Menu;		
		
		public function CreditsState() 
		{
			creditsScreen = new CreditsScreen.CreditsScreen();			
			creditsScreen.add(this);
			this.add(creditsScreen);

			FlxG.bgColor = 0xFF000000;
			
			menu = new Menu();			
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("ESCAPE"))
			{
				FlxG.switchState(menu);
			}
			
			if (creditsScreen.endOfCredits < 0)
			{
				FlxG.switchState(menu);
			}
		}
	}		
}
