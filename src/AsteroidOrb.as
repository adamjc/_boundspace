package {

	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AsteroidOrb extends FlxSprite 
	{
		[Embed(source="../assets/asteroid-orb.png")] protected var sprite:Class;
		public static const DAMAGE:int = 1;
		public static const _VELOCITY:int = 75;
		public var asteroidCoordIndex:int;
		public var fired:Boolean;
		
		public function AsteroidOrb(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null, Z:int = Registry.ENEMY_PROJECTILE_Z_LEVEL, _velocity:FlxPoint = null) 
		{			
			super(X, Y, SimpleGraphic, Z);
			this.loadGraphic(sprite);
			x = X;
			y = Y;
						
			this.velocity = _velocity || new FlxPoint(_VELOCITY, _VELOCITY);
			
			this.drag.x = 0;
			this.drag.y = 0;		
		}
		
		override public function update():void
		{
			super.update();
			
			var self:AsteroidOrb = this;
			FlxG.overlap(this, Registry.player, function():void {
				Registry.player.hit(1);
				self.kill();
			});
			
			if ((this.x > Registry.RIGHT_BOUNDS + 30) ||
				(this.x < Registry.LEFT_BOUNDS - 30) ||
				(this.y > Registry.BOTTOM_BOUNDS + 30) ||
				(this.y < Registry.TOP_BOUNDS - 30))
			{
				self.kill();
			}
		}
		
	}

}