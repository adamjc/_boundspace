package  
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Adam
	 */
	public class SaucerMiniBoss extends MiniBoss 
	{
		protected const HEALTH:int = 10;
		protected const WEAPON_COOLDOWN:Number = 1 + (0.5 * Math.random());
		protected const WIDTH:int = 7;

		protected var bulletImage:FlxSprite;
		protected var weapon1:FlxWeapon;
		
		/**
		 * Constructor.
		 */
		public function SaucerMiniBoss(_ai:Boolean = true) 
		{
			var _x:Number = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random();
			var _y:Number = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS;
			super(_x, _y, WEAPON_COOLDOWN);
			//this.z = 1;
			this.z = Registry.ENEMY_BOSS_Z_LEVEL;
			
			image = makeGraphic(7, 7, 0xFF0F0FFF);			
			
			armour = HEALTH;
			this.weapons = new Array();
			
			weapon1 = new FlxWeapon("cannon", image);
			weapon1.setBulletSpeed(50);
			weapon1.setFireRate(1500);
			weapon1.makePixelBullet(10, 2, 2, 0xFFFF00FF);
			this.weapons.push(weapon1);				
			
			(FlxG.state as PlayState).enemyProjectiles.add(weapon1.group);				
		}
		
		override public function update():void
		{
			super.update();
		}
	}

}