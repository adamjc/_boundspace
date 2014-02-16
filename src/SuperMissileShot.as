package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SuperMissileShot extends FlxSprite 
	{
		[Embed (source = "../assets/super-missile.png")] protected var superMissile:Class;	
		
		protected var previousVelocity:FlxPoint;
		protected var speed:int = 25;
		protected var maxSpeed:int = 5;
		protected var maxTurn:Number = 0.5;
		protected var damage:int = 10;
		
		public function SuperMissileShot(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, Z:int=0) 
		{
			super(X, Y, SimpleGraphic, Z);
			this.z = Registry.PLAYER_PROJECTILE_Z_LEVEL;
			
				
			
			var graphic:FlxSprite = loadGraphic(superMissile, true, false, 17, 47);	
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
						
			addAnimation("superMissile", array, 60, true);
			this.play("superMissile");
		}
		
		// When collides with an enemy, hurts the enemy, blows up.
		// Find new velocity, if it's less than SOME_NUMBER then do it, if not, then new velocity = old velocity +/- SOME_NUMBER
		protected var vx:Number = 0;
		protected var vy:Number = 0;
		override public function update():void
		{
			FlxG.overlap(this, Registry.enemies, missileHit);
			
			super.update();
			
			var dx:Number = FlxG.mouse.x - this.x;
			var dy:Number = FlxG.mouse.y - this.y;
			
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
			
			var a:Number = FlxVelocity.angleBetween(this, new FlxSprite(FlxG.mouse.x, FlxG.mouse.y));
			this.angle = (a * (180 / Math.PI)) + 90;
			
			this.x = this.x + vx;
			this.y = this.y + vy;
		}
		
		protected function missileHit(missile:SuperMissileShot, enemy:Enemy):void
		{
			enemy.enemyHit(this.damage);
			missile.kill();
		}
	}

}