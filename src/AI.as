package  
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class AI extends FlxObject 
	{				
		/**
		 * Constructor.
		 */
		public function AI() 
		{			
			super();
			Registry.game.add(this);
		}
		
		/**
		 * All of the AI updates go here, any changes to the unit
		 * go here also.
		 */
		override public function update():void
		{
			super.update();
			
			
		}
		
		public function removeThis():void
		{
			
		}
		
		/**
		 * 
		 * @param	source
		 * @param	dest
		 * @param	speed
		 * @param	maxTime
		 * @param	angleDelta we can change the angle the object moves at here.
		 */
		public static function angleObject(source:FlxSprite, dest:FlxPoint, speed:int = 60, maxTime:int = 0, angleDelta:int = 0):void
		{
			var a:Number = FlxVelocity.angleBetweenPoint(source, dest);
			
			// convert a to degrees
			a = a * 180 / Math.PI;
			a = a + angleDelta;
			// convert a back to radians.
			a = a * Math.PI / 180;
			
			if (maxTime > 0)
			{
				var d:int = FlxVelocity.distanceToPoint(source, dest);
				
				//	We know how many pixels we need to move, but how fast?
				speed = d / (maxTime / 1000);
			}

			source.angle = a * 180 / Math.PI - 90;			
			
			source.velocity.x = Math.cos(a) * speed;
			source.velocity.y = Math.sin(a) * speed;
		}
		
		
	}
}