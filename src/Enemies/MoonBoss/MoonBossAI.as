package Enemies.MoonBoss 
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
	public class MoonBossAI extends AI 
	{
		protected var unit:Enemy;
		protected var targetX:int;
		protected var targetY:int; 
		
		protected var moveTimer:int = 2000;		
		protected var speed:int = 50;
		
		protected var _moveThisIntervalId:Number
		
		protected var baseVelocity:Number = 50.0;
		
		public function MoonBossAI(_unit:Unit) 
		{
			super();			
			unit = Enemy(_unit);
			
			this.unit.velocity.x = baseVelocity;
			this.unit.velocity.y = baseVelocity;
			
			this.unit.drag.x = 0;
			this.unit.drag.y = 0;
		}
		
		/**
		 * All of the AI updates go here, any changes to the unit
		 * go here also.
		 */
		override public function update():void
		{	
			if (this.unit.isTouching(UP)) this.unit.velocity.y = baseVelocity;
			if (this.unit.isTouching(RIGHT)) this.unit.velocity.x = -baseVelocity;
			if (this.unit.isTouching(DOWN))	this.unit.velocity.y = -baseVelocity;
			if (this.unit.isTouching(LEFT))	this.unit.velocity.x = baseVelocity;
			
			unit.weaponTimer -= FlxG.elapsed;
			if (unit.weaponTimer <= 0)
			{
				unit.weaponTimer = unit.weaponCooldown;
				
				targetX = Registry.player.x;
				targetY = Registry.player.y;
				
				numberOfTimes = 0;
				intervalId = setInterval(fireThreeAngled, 200);
				Registry.intervals.push(intervalId);
			}			
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
				var wL:int = unit ? unit.weapons.length : 0;
				
				for (i = 0; i < wL; i++)
				{										
					if (unit)
					{
						FlxG.play(WeaponContainer.cannonSound);
						unit.weapons[i].fireAtPosition(targetX, targetY);
						Registry.game.add(unit.weapons[i].currentBullet);									
						unit.weapons[i].currentBullet.z = Registry.ENEMY_PROJECTILE_Z_LEVEL;	
							
						// change the current bullet's trajectory.
						AI.angleObject(unit.weapons[i].currentBullet, new FlxPoint(targetX, targetY), unit.weapons[i].getBulletSpeed(), 0, angle);		
						
						angle = angle + 10;
					}					
				}
				
				numberOfTimes++;
			}
			
		}
		
		override public function removeThis():void
		{
			unit = null;
			this.kill();
			//clearInterval(_fireIntervalId);
			//Registry.intervals.splice(_fireIntervalId, 1);
		}
	}

}