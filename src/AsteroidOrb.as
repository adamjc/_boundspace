package {

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
		
		public function AsteroidOrb(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null, Z:int = 0, _velocity:FlxPoint = null) 
		{			
			super(X, Y, SimpleGraphic, Z);
			this.loadGraphic(sprite);
			x = X;
			y = Y;
			
			this.velocity = _velocity;
			
			this.drag.x = 0;
			this.drag.y = 0;
						
			trace(this.z + 1);
			//this.image = sprite;
		}
		
		override public function update():void
		{
			super.update();
			
			var self:AsteroidOrb = this;
			FlxG.overlap(this, Registry.player, function() {
				Registry.player.hit(1);
				self.kill();
			});
		}
		
	}

}