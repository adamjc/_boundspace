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
	import org.flixel.plugin.photonstorm.FlxVelocity;
	
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
		
		protected var unitMidpoint:FlxPoint;
		protected var asteroidCoords:Array;
		protected var asteroids:Array = [];
		
		protected const DISTANCE_OFFSET:int = 40;
		protected const ROUNDING_VALUE:int = 8; // used to make the orbs curve around moon more, too lazy to do it properly.
		
		public function MoonBossAI(_unit:Unit) 
		{
			super();			
			unit = Enemy(_unit);
			
			this.unit.velocity.x = baseVelocity;
			this.unit.velocity.y = baseVelocity;
			
			this.unit.drag.x = 0;
			this.unit.drag.y = 0;
			
			resetAsteroidCoords();
		}
		
		public function resetAsteroidCoords():void {
			unitMidpoint = new FlxPoint(unit.x + unit.width / 2 - 5, unit.y + unit.height / 2 - 5);
			asteroidCoords = [
				new FlxPoint(unitMidpoint.x - DISTANCE_OFFSET + ROUNDING_VALUE, unitMidpoint.y - DISTANCE_OFFSET + ROUNDING_VALUE),
				new FlxPoint(unitMidpoint.x, unitMidpoint.y - DISTANCE_OFFSET),
				new FlxPoint(unitMidpoint.x + DISTANCE_OFFSET - ROUNDING_VALUE, unitMidpoint.y - DISTANCE_OFFSET + ROUNDING_VALUE),
				new FlxPoint(unitMidpoint.x + DISTANCE_OFFSET, unitMidpoint.y),
				new FlxPoint(unitMidpoint.x + DISTANCE_OFFSET - ROUNDING_VALUE, unitMidpoint.y + DISTANCE_OFFSET - ROUNDING_VALUE),
				new FlxPoint(unitMidpoint.x, unitMidpoint.y + DISTANCE_OFFSET),
				new FlxPoint(unitMidpoint.x - DISTANCE_OFFSET + ROUNDING_VALUE, unitMidpoint.y + DISTANCE_OFFSET - ROUNDING_VALUE),
				new FlxPoint(unitMidpoint.x - DISTANCE_OFFSET, unitMidpoint.y)
			];
		}
		
		/**
		 * All of the AI updates go here, any changes to the unit
		 * go here also.
		 */
		override public function update():void
		{	
			if (this.unit.isTouching(UP)) {
				this.unit.velocity.y = baseVelocity;
			}
			if (this.unit.isTouching(RIGHT)) {
				this.unit.velocity.x = -baseVelocity;
			}
			if (this.unit.isTouching(DOWN))	this.unit.velocity.y = -baseVelocity;
			if (this.unit.isTouching(LEFT))	this.unit.velocity.x = baseVelocity;
			
			resetAsteroidCoords()
			
			if (asteroids && asteroids.length > 0) {
				for (var i:int = 0; i < asteroids.length; i++) {
					asteroids[i].x = asteroidCoords[asteroids[i].asteroidCoordIndex].x;
					asteroids[i].y = asteroidCoords[asteroids[i].asteroidCoordIndex].y;
					asteroids[i].angle += Math.random() * 5;
				}
			}
			
			unit.weaponTimer -= FlxG.elapsed;
			if (unit.weaponTimer <= 0)
			{
				unit.weaponTimer = unit.weaponCooldown;
				
				targetX = Registry.player.x;
				targetY = Registry.player.y;								
				
				if (asteroids && asteroids.length) {
					// There are asteroids to shoot.
					fireAsteroid();
				}
				else {
					// There are not, so make more.
					createAsteroids();
				}
			}			
		}
		
		protected function fireAsteroid():void {
			var asteroid:AsteroidOrb = asteroids.shift();
			FlxVelocity.moveTowardsObject(asteroid, Registry.player, 150);
		}
		
		protected function createAsteroids():void 
		{
			for (var i:int = 0; i < asteroidCoords.length; i++) {
				var asteroid:AsteroidOrb = new AsteroidOrb(asteroidCoords[i].x, asteroidCoords[i].y, null, Registry.ENEMY_PROJECTILE_Z_LEVEL, new FlxPoint(0, 0));
				asteroid.asteroidCoordIndex = i;
				Registry.game.add(asteroid);
				asteroids.push(asteroid);
			}
		}
		
		override public function removeThis():void
		{
			unit = null;
			
			for (var i:int = 0; i < asteroids.length; i++) {
				asteroids[i].kill();
			}
			
			this.kill();
			//clearInterval(_fireIntervalId);
			//Registry.intervals.splice(_fireIntervalId, 1);
		}
	}

}