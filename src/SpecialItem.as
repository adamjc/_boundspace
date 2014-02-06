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
		
		override public function update():void
		{
			super.update();
			
			if (dropped)
			{
				droppedTimer -= FlxG.elapsed;
			}
		}
		
		/**
		 * Override this.
		 */
		public function useSpecial():void
		{
			
		}
	}

}