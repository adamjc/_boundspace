package Enemies.Rotatortron 
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
	public class RotatortronAI extends AI 
	{
		protected var unit:Enemy;
		protected var targetX:int;
		protected var targetY:int; 
		
		protected var moveTimer:int = 2000;		
		protected var speed:int = 50;
		
		protected var _fireIntervalId:Number;
		protected var _moveIntervalId:Number;
		
		protected var _rightAngledIncrement:Boolean = true;
		
		public function RotatortronAI(_unit:Unit) 
		{
			super();			
			unit = Enemy(_unit);
			_fireIntervalId = setInterval(fire, 2000);
		}
		
		/**
		 * All of the AI updates go here, any changes to the unit
		 * go here also.
		 */
		override public function update():void
		{					
		}
		
		protected var moved:Boolean = false;
		protected function moveThis():void
		{			
			var _angle:int = (unit.angle + 45) % 360;
			TweenMax.to(this.unit, 0.3, { angle: _angle } );
			
			_rightAngledIncrement = !_rightAngledIncrement;
		}
		
		protected var intervalId:Number;
		protected var numberOfTimes:int;
		protected var maxNumberOfTimes:int = 3;
		protected function fire():void
		{			
			var _angle:int = (_rightAngledIncrement ? 0 : 45);		
			var i:int = 0;
			
			for (i = 0; i < unit.weapons.length; i++)
			{					
				unit.weapons[i].fireFromAngle(_angle);
				Registry.game.add(unit.weapons[i].currentBullet);									
				unit.weapons[i].currentBullet.z = Registry.ENEMY_PROJECTILE_Z_LEVEL;	
					
				// change the current bullet's trajectory.
				//AI.angleObject(unit.weapons[i].currentBullet, new FlxPoint(targetX, targetY), unit.weapons[i].getBulletSpeed(), 0, angle);						
				_angle += 90;
				unit.weapons[i].currentBullet.angle = _angle;								
			}			
			
			_moveIntervalId = setTimeout(moveThis, 200);
		}
		
		override public function removeThis():void
		{
			unit = null;
			this.kill();
			clearInterval(_fireIntervalId);
			clearInterval(_moveIntervalId);
			
		}
	}

}