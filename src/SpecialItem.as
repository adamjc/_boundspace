package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class SpecialItem extends Item 
	{
		public var dropped:Boolean;
		public var droppedTimer:Number;
		
		public var image:Class;
		
		/**
		 * Constructor.
		 */
		public function SpecialItem(_x:int, _y:int, _shop:Boolean) 
		{
			super();
			this.makeGraphic(4, 4, 0xFFF0FFF0);
			
			
		}
		
		override public function reset(X:Number, Y:Number):void
		{	
			this.canBePickedUp = false;	
			super.reset(X, Y);
		}				
		
		protected var scaleUp:Boolean = true;
		protected var rotateClockwise:Boolean = true;
		override public function update():void
		{
			super.update();
			
			if (dropped)
			{
				droppedTimer -= FlxG.elapsed;
			}
			
			if (this.angle >= 10)
			{
				rotateClockwise = false;
			}
			else if (this.angle <= -10)
			{
				rotateClockwise = true;
			}
			
			if (rotateClockwise)
			{
				this.angle += 0.1;
			}
			else
			{
				this.angle -= 0.1;
			}
			
			
			if (this.scale.x <= 0.6)
			{
				scaleUp = true;
			}
			else if (this.scale.x >= 0.7)
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
		
		/**
		 * Override this.
		 */
		public function useSpecial():void
		{
			Registry.player.emptyChargeBar();
		}
	}

}