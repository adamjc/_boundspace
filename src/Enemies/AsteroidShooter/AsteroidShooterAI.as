package Enemies.AsteroidShooter 
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
	public class AsteroidShooterAI extends AI 
	{
		protected var unit:Enemy;
		protected var targetX:int;
		protected var targetY:int; 
		
		protected var moveTimer:int = 2000;		
		protected var speed:int = 50;
		
		protected var _fireIntervalId:Number;
		protected var _moveIntervalId:Number;
		
		protected var _rightAngledIncrement:Boolean = true;
		
		protected var baseVelocity:Number = 50.0;
		
		public function AsteroidShooterAI(_unit:Unit) 
		{
			super();			
			unit = Enemy(_unit);
			
			this.unit.velocity.x = baseVelocity;
			this.unit.velocity.y = baseVelocity;
			
			this.unit.drag.x = 0;
			this.unit.drag.y = 0;
			
			//_fireIntervalId = setInterval(fire, 2000);
			//Registry.intervals.push(_fireIntervalId);
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
				
				if (FlxMath.chanceRoll(75))
				{
					var i:int; 
					for (i = 0; i < unit.weapons.length; i++)
					{				
						FlxG.play(WeaponContainer.cannonSound);
						unit.weapons[i].fireAtTarget(Registry.player.playerSprite);
						Registry.game.add(unit.weapons[i].currentBullet);			
						
						unit.weapons[i].currentBullet.z = Registry.ENEMY_PROJECTILE_Z_LEVEL;
					}
				}
			}			
		}
		
		//protected var moved:Boolean = false;
		protected function moveThis():void
		{			
			//var _angle:int = (unit.angle + 45) % 360;
			//TweenMax.to(this.unit, 0.3, { angle: _angle } );
			
			//_rightAngledIncrement = !_rightAngledIncrement;
		}
		
		protected var intervalId:Number;
		protected var numberOfTimes:int;
		protected var maxNumberOfTimes:int = 3;
		protected function fire():void
		{			
			//var _angle:int = (_rightAngledIncrement ? 0 : 45);		
			//var i:int = 0;
			
			/*for (i = 0; i < unit.weapons.length; i++)
			{		
				FlxG.play(WeaponContainer.cannonSound);
				unit.weapons[i].fireFromAngle(_angle);
				Registry.game.add(unit.weapons[i].currentBullet);									
				unit.weapons[i].currentBullet.z = Registry.ENEMY_PROJECTILE_Z_LEVEL;	
					
				// change the current bullet's trajectory.
				//AI.angleObject(unit.weapons[i].currentBullet, new FlxPoint(targetX, targetY), unit.weapons[i].getBulletSpeed(), 0, angle);						
				_angle += 90;
				unit.weapons[i].currentBullet.angle = _angle;								
			}*/			
			
			//_moveIntervalId = setTimeout(moveThis, 200);
			//Registry.intervals.push(_moveIntervalId);
		}
		
		override public function removeThis():void
		{
			unit = null;
			this.kill();
			//clearInterval(_fireIntervalId);
			//Registry.intervals.splice(_fireIntervalId, 1);
			//clearInterval(_moveIntervalId);
			//Registry.intervals.splice(_moveIntervalId, 1);
			
		}
	}

}