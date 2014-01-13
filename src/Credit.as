package  
{
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.FlxSound;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class Credit extends FlxSprite 
	{	
		[Embed(source = "../assets/Randomize30.mp3")] protected var pickupSound:Class;
		public var isPickedUp:Boolean;
		public var value:int;
		
		public function Credit(_x:int, _y:int) 
		{
			super(_x, _y);						
			addAnimation("pickup", [1, 2, 3], 60, false);		
		}
			
		protected var scaleUp:Boolean = true;
		protected var rotateClockwise:Boolean = true;
		override public function update():void
		{			
			if (finished)
			{
				this.kill();
			}
			
			if (this.angle >= 20)
			{
				rotateClockwise = false;
			}
			else if (this.angle <= -20)
			{
				rotateClockwise = true;
			}
			
			if (rotateClockwise)
			{
				this.angle += 0.2;
			}
			else
			{
				this.angle -= 0.2;
			}
			
			
			if (this.scale.x <= 0.5)
			{
				scaleUp = true;
			}
			else if (this.scale.x >= 0.6)
			{
				scaleUp = false;
			}
			
			if (scaleUp)
			{
				this.scale.x += 0.0025;
				this.scale.y += 0.0025;
			}
			else
			{
				this.scale.x -= 0.0025;
				this.scale.y -= 0.0025;
			}
			
		}
		
		public function creditPickedUp(credit:Credit):void
		{
			FlxG.play(pickupSound);
			play("pickup", false);
		}
		

		
	}

}