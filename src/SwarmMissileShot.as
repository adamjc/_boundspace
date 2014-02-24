package  
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SwarmMissileShot extends FlxSprite 
	{
		[Embed (source = "../assets/swarm-missile.png")] protected var superMissile:Class;	
		
		protected var previousVelocity:FlxPoint;
		protected var speed:int = 25;
		protected var maxSpeed:int = 5;
		protected var maxTurn:Number = 0.5;
		protected var damage:int = 10;
		
		protected var _follow:Boolean;
		
		protected var _timeAlive:Number = 0;
		
		public function SwarmMissileShot(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, Z:int=0) 
		{
			super(X, Y, SimpleGraphic, Z);
			this.z = Registry.PLAYER_PROJECTILE_Z_LEVEL;
										
			var graphic:FlxSprite = loadGraphic(superMissile, true, false, 12, 27);	
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
						
			addAnimation("swarmMissile", array, 60, true);
			this.play("swarmMissile");
			// Start moving in some direction.
			var rx:int = Math.random() * BoundSpace.SceneWidth;
			var ry:int = Math.random() * BoundSpace.SceneHeight;
			FlxVelocity.moveTowardsPoint(this, new FlxPoint(rx, ry), 100);
			var a:Number = FlxVelocity.angleBetween(this, new FlxSprite(rx, ry));
			this.angle = (a * (180 / Math.PI)) + 90;
			// After a period of time, pick an enemy and move towards it.
			setTimeout(function():void { _follow = true; }, 1000);
			
			setTimeout(kill, 3000);
		}
		
		protected var _target:Unit;
		protected function followUnit():void
		{
			if (!_target || !_target.alive)
			{
				var enemies:Array = Registry.enemies.members;
				var r:int = Math.floor(Math.random() * enemies.length);
				trace("enemiesLength: " + enemies.length + "random: " + r);
				if (enemies[r]) { _target = enemies[r]; }
			}
			
			if (_target)
			{
				// Follow that bad boy.
				var dx:Number = _target.x - this.x;
				var dy:Number = _target.y - this.y;
				
				var distance:Number = Math.sqrt((dx * dx) + (dy * dy));

				dx = dx / distance;
				dy = dy / distance;
							
				vx = vx + (dx * maxTurn);
				vy = vy + (dy * maxTurn);
				
				var velocity:Number = Math.sqrt((vx * vx) + (vy * vy));
				
				if (velocity > maxSpeed)
				{
					vx = (vx * maxSpeed) / velocity;
					vy = (vy * maxSpeed) / velocity;
				}
				
				var a:Number = FlxVelocity.angleBetween(this, _target);
				this.angle = (a * (180 / Math.PI)) + 90;
				
				this.x = this.x + vx;
				this.y = this.y + vy;
			}
		}
		
		// When collides with an enemy, hurts the enemy, blows up.
		// Find new velocity, if it's less than SOME_NUMBER then do it, if not, then new velocity = old velocity +/- SOME_NUMBER
		protected var vx:Number = 0;
		protected var vy:Number = 0;
		override public function update():void
		{					
			FlxG.overlap(this, Registry.enemies, missileHit);
			
			super.update();						
			
			if (_follow) { this.followUnit(); }
		}
		
		protected function missileHit(missile:SwarmMissileShot, enemy:Enemy):void
		{
			enemy.enemyHit(this.damage);
			missile.kill();
		}
	}

}