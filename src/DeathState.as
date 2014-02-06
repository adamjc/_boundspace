package  
{
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class DeathState extends FlxState 
	{
		
		public function DeathState() 
		{			
			var p:PlayState = new PlayState();
			var b:FlxButtonPlus = new FlxButtonPlus(350, 100, FlxG.switchState, [p], "Start!");
			FlxG.bgColor = 0xFF000000;
			add(b);
		}
		
		public function achievementsMenu():void
		{
			
		}
			
		override public function update():void
		{
			super.update();
			Mouse.show();
		}
	}

}