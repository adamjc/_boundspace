package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class PowerCore extends Item
	{
		public const DROPPED_TIMER_VAL:Number = 2;
		
		public var name:String; // The name of the PowerCore right now.
		public var usedName:String; // The name of the PowerCore once it's been installed.
		public var unusedName:String; // The name of the PowerCore before it's been installed.
		
		public var attribute:String; // The attribute to modify.
		public var positive:Boolean; // Is the attribute positive?
		public var value:Number; // The number to increase.
		public var explosionRadius:Number;
		public var dropped:Boolean;
		public var droppedTimer:Number;
		
		
		public static const PRICE:int = 100;
		
		public static var z:int;
		
		/**
		 * Constructor.
		 * @param	name
		 * @param	attribute
		 */
		public function PowerCore(_x:int, _y:int, _shop:Boolean) 
		{
			super();
			if (_shop)
			{
				this.price = PowerCore.PRICE;
				priceText = new FlxText(_x - 8, _y + 2, 50, this.price.toString());
				Registry.game.add(priceText);
			}
			this.makeGraphic(3, 3, 0xFF00FF00);
			this.explosionRadius = 50;
			droppedTimer = DROPPED_TIMER_VAL;
		}
		
		/**
		 * Designed to be overriden by a subclass.
		 */
		public function installCore():void
		{						
			if (positive) 
			{
				Registry.player[attribute] += value;
			}
			else
			{
				Registry.player[attribute] -= value;
			}
		}

		override public function update():void
		{
			super.update();
			
			if (dropped)
			{
				droppedTimer -= FlxG.elapsed;
				if (droppedTimer <= 0)
				{
					explode();
				}
			}
		}	
		
		public function intersects(object:FlxSprite):Boolean
		{
			var circleDistanceX:int;
			var circleDistanceY:int;
			
			circleDistanceX = Math.abs((this.x + this.width / 2) - object.x);
			circleDistanceY = Math.abs((this.y + this.height / 2) - object.y);
				
			if (circleDistanceX > (object.width / 2 + this.explosionRadius)) { return false; }
			if (circleDistanceY > (object.height / 2 + this.explosionRadius)) { return false; }
												
			if (circleDistanceX <= (object.width/2)) { return true; } 
			if (circleDistanceY <= (object.height/2)) { return true; }

			var cornerDistance_sq:Number = Math.pow((circleDistanceX - object.width/2), 2) +
										   Math.pow((circleDistanceY - object.height / 2), 2);
										   
			return (cornerDistance_sq <= Math.pow(explosionRadius, 2));
		}
		
		/**
		 * The PowerCore explodes giving a radius of a certain size, and affecting
		 * all enemies within the circle.
		 */
		public function explode():void
		{
			var a:Array = Registry.enemies.members;
			var i:int;		
			
			for (i = 0; i < a.length; i++)
			{
				if (a[i])
				{
					if (this.intersects(a[i]))
					{
						if (this.positive) { a[i][attribute] += value; }
						else { a[i][attribute] -= value; }
					}
				}
			}
			
			this.kill();	
		}
		

		
	}

}