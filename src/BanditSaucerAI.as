package  
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BanditSaucerAI extends AI 
	{
		protected var unit:Enemy;
		protected var targetX:int;
		protected var targetY:int; 
		
		protected var moveTimer:int = 2000;		
		protected var speed:int = 50;
		
		protected var _moveThisIntervalId:Number
		
		public function BanditSaucerAI(_unit:Unit) 
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
				
				targetX = Registry.player.x;
				targetY = Registry.player.y;
				
				intervalId = setTimeout(fireThreeAngled, 200);
				Registry.intervals.push(intervalId);
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
		
		protected var intervalId:Number;
		protected var numberOfTimes:int;
		protected var maxNumberOfTimes:int = 3;
		protected function fireThreeAngled():void
		{
			if (numberOfTimes > maxNumberOfTimes)
			{
				clearInterval(intervalId);
				Registry.intervals.splice(intervalId, 1);
				numberOfTimes = 0;
			}
			else
			{
				var angle:int = -10;
				var i:int = 0;
				
				for (i = 0; i < unit.weapons.length; i++)
				{										
					unit.weapons[i].fireAtPosition(targetX, targetY);
					Registry.game.add(unit.weapons[i].currentBullet);									
					unit.weapons[i].currentBullet.z = Registry.ENEMY_PROJECTILE_Z_LEVEL;	
						
					// change the current bullet's trajectory.
					AI.angleObject(unit.weapons[i].currentBullet, new FlxPoint(targetX, targetY), unit.weapons[i].getBulletSpeed(), 0, angle);		
					
					angle = angle + 10;
				}
				
				numberOfTimes++;
			}
			
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