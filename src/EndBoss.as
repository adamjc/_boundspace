package  
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class EndBoss extends Boss 
	{
		protected const HEALTH:Number = 5;	
		protected const WIDTH:Number = 5;
		protected const WEAPON_COOLDOWN:Number = 1 + (0.5 * Math.random());
		
		protected var bulletImage:FlxSprite;
		protected var weapon1:FlxWeapon;
		
		public function EndBoss(X:Number = 0, Y:Number = 0, _weaponCooldown:Number = 1, _ai:Boolean = true) 
		{
			var _x:Number = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random();
			var _y:Number = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS;
			super(_x, _y, WEAPON_COOLDOWN);
			this.z = 0;
			image = makeGraphic(20, 20, 0xF0FF00F0);			
			
			armour = HEALTH;
			weapons = new Array();
			
			weapon1 = new FlxWeapon("cannon", image);
			weapon1.setBulletSpeed(50);
			weapon1.setFireRate(1500);
			weapon1.makePixelBullet(10);
			this.weapons.push(weapon1);				
			
			(FlxG.state as PlayState).enemyProjectiles.add(weapon1.group);					
		}
		
		override public function update():void
		{
			super.update();
		}		
	}

}