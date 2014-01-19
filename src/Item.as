package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;	
	
	/**
	 * ...
	 * @author Adam
	 */
	public class Item extends FlxSprite 
	{
		public var price:Number = 0;
		
		public static const item1Point:FlxPoint = new FlxPoint(100, 350);
		public static const item2Point:FlxPoint = new FlxPoint(150, 350);
		public static const item3Point:FlxPoint = new FlxPoint(200, 350);
		
		public static var shopItems:Array;
		
		public var priceText:FlxText;
		
		public var canBePickedUp:Boolean = true;
		public const TIMER:Number = 1.0;
		
		/**
		 * Constructor.
		 */
		public function Item() 
		{
			super();
		}
			
		public function changePrice(newPrice:int = 0):void
		{
			if (newPrice == 0)
			{
				this.price = 0;
				if (this.priceText) { this.priceText.kill(); }
				this.priceText = null;
			}
			else
			{
				this.price = newPrice;
				if (this.priceText) { Registry.game.remove(this.priceText); }
				this.priceText = new FlxText(x - 8, y + 2, 50, this.price.toString());
			}
		}
		
		override public function update():void
		{
			super.update();
			if (!canBePickedUp)
			{
				droppedCooldown();
			}
		}
		
		/**
		 * TODO 
		 * Randomly picks 3 items from either PowerCore, SpecialItem or Upgrades and
		 * gives it it's price.
		 */
		public static function addShopItems():Array
		{
			var shopItems:Array = new Array();
			var i:int;
			for (i = 0; i < 3; i++)
			{				
			}
			shopItems.push(PowerCoreManager.addPowerCore(item1Point.x, item1Point.y, true));
			shopItems.push(PowerCoreManager.addPowerCore(item2Point.x, item2Point.y, true));
			shopItems.push(PowerCoreManager.addPowerCore(item3Point.x, item3Point.y, true));
			return shopItems;
		}
		
		/**
		 * Removes the item from the state, and its text if it has any.
		 */
		public function removeThis():void
		{
			if (priceText) { this.priceText.kill(); }
			this.kill();
		}		
		
		public var timer:Number = TIMER;
		public function droppedCooldown():void
		{
			if (timer <= 0)
			{
				timer = TIMER;
				canBePickedUp = true;
				return;
			}
			else
			{
				timer -= FlxG.elapsed;
			}
		}
		
	}

}