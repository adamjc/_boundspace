package  
{
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class SaucerAI extends AI 
	{		
		protected var unit:Enemy;
		
		/**
		 * Constructor.
		 * @param	_unit
		 */
		public function SaucerAI(_unit:Unit) 
		{
			super();			
			unit = Enemy(_unit);
		}
		
		/**
		 * All of the AI updates go here, any changes to the unit
		 * go here also.
		 */
		override public function update():void
		{			
			unit.velocity.x += Math.random() * 10 - 5;
			unit.velocity.y += Math.random() * 10 - 5;
			
			unit.weaponTimer -= FlxG.elapsed;
			if (unit.weaponTimer <= 0)
			{
				unit.weaponTimer = unit.weaponCooldown;
				
				if (FlxMath.chanceRoll(40))
				{
					var i:int; 
					for (i = 0; i < unit.weapons.length; i++)
					{										
						unit.weapons[i].fireAtTarget(Registry.player.playerSprite);
						Registry.game.add(unit.weapons[i].currentBullet);			
						trace(unit.weapons[i].currentBullet.x);
						unit.weapons[i].currentBullet.z = Registry.ENEMY_PROJECTILE_Z_LEVEL;
					}
				}
			}			
		}
		
		override public function removeThis():void
		{
			unit = null;
			this.kill();
		}
	}

}