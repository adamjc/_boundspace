package  
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class SaucerAI extends AI 
	{		
		protected var unit:Enemy;
		
		protected var moveTimer:int = 2000;		
		protected var speed:int = 50;
		
		protected var _moveThisIntervalId:Number;
		
		/**
		 * Constructor.
		 * @param	_unit
		 */
		public function SaucerAI(_unit:Unit) 
		{
			super();			
			unit = Enemy(_unit);
			_moveThisIntervalId = setInterval(moveThis, moveTimer);
			Registry.intervals.push(_moveThisIntervalId);
		}
		
		/**
		 * All of the AI updates go here, any changes to the unit
		 * go here also.
		 */
		override public function update():void
		{						
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
						
						unit.weapons[i].currentBullet.z = Registry.ENEMY_PROJECTILE_Z_LEVEL;
					}
				}
			}			
		}
		
		protected var moved:Boolean = false;
		protected function moveThis():void
		{
			if (moved)
			{
				// Set velocity to 0.
				unit.velocity.x = 0;
				unit.velocity.y = 0;
			}
			else
			{
				// move the unit.				
				var rx:int = Math.floor(Math.random() * 3) - 1;
				var ry:int = Math.floor(Math.random() * 3) - 1;
				unit.velocity.x = speed * rx;
				unit.velocity.y = speed * ry;
			}
			
			moved = !moved;
				
			unit.handleVelocity();
		}
		
		override public function removeThis():void
		{
			unit = null;
			this.kill();
			clearInterval(_moveThisIntervalId);
			Registry.intervals.splice(_moveThisIntervalId, 1);
		}
	}

}