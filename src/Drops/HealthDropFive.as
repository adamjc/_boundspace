package Drops 
{
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HealthDropFive extends HealthDrop 
	{
		public function HealthDropFive(X:Number = 0, Y:Number = 0, price:int = 0, shop:Boolean = false, SimpleGraphic:Class = null, Z:int = 0) 
		{
			super(X, Y, SimpleGraphic, Z);		
			this.val = 5;
			this.color = 0xFFCCCC;		
			this.price = price;
			
			if (shop)
			{
				priceText = new FlxText(x - 5, y + 40, 50, this.price.toString() + "c");
				priceText.z = Registry.UI_Z_LEVEL_ELEMENTS;
				priceText.setFormat("DefaultFont", 16);
				Registry.game.add(priceText);
			}
		}		
	}
}