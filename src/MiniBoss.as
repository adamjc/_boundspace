package  
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	/**
	 * ...
	 * @author Adam
	 */
	public class MiniBoss extends Enemy 
	{		
		/**
		 * Constructor.
		 */
		public function MiniBoss(_x:int, _y:int, _weaponCooldown:int) 
		{			
			super(_x, _y, _weaponCooldown);
		}

		override public function update():void
		{	
			super.update();			
		}
	}

}