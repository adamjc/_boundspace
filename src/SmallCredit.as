package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class SmallCredit extends Credit 
	{
		[Embed(source = "../assets/credits.png")] protected var creditImg:Class;
		protected const VALUE:int = 1;
		
		protected var sprite:FlxSprite;
		
		public function SmallCredit(_x:int, _y:int) 
		{
			super(_x, _y);	
			this.value = VALUE;
			sprite = loadGraphic(creditImg, false);
			sprite.scale.x = 0.5;
			sprite.scale.y = 0.5;
			sprite.antialiasing = true;
		}
		
		
		
	}

}