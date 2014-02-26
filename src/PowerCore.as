package  
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.BounceIn;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
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
		
		public static var sprite:FlxSprite;
		
		public static const PRICE:int = 90;
		
		public static var z:int;
		
		/**
		 * Constructor.
		 * @param	name
		 * @param	attribute
		 */
		public function PowerCore(_x:int, _y:int, _shop:Boolean, graphic:Class = null) 
		{
			super();
			if (_shop)
			{
				this.price = PowerCore.PRICE;
				priceText = new FlxText(_x, _y + 20, 50, this.price.toString() + "c");
				priceText.z = Registry.UI_Z_LEVEL_ELEMENTS;
				priceText.setFormat("DefaultFont", 16);
				Registry.game.add(priceText);
			}
			this.makeGraphic(3, 3, 0xFF00FF00);
			this.explosionRadius = 50;
			droppedTimer = DROPPED_TIMER_VAL;
		}
		
		override public function reset(X:Number, Y:Number):void
		{	
			this.canBePickedUp = false;	
			super.reset(X, Y);
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

		public function showText():void
		{
			var text:FlxText = new FlxText(0, Registry.TOP_BOUNDS - 10, BoundSpace.SceneWidth, "FOUND " + this.usedName + " !!");
			text.setFormat("DefaultFont", 16, 0xFFFFFF, "center");
			text.z = Registry.UI_Z_LEVEL_ELEMENTS - 1;
			
			TweenMax.to(text, 0.3, { y: text.y + 10, ease: Quad.easeOut } );
			
			Registry.game.add(text);
			
			//var _id:Number = setInterval(function():void { text.alpha -= 0.1; if (text.alpha >= 1) clearInterval(_id); }, 50, _id);
			var _id:Number = setTimeout(fadeOut, 1500, text);
			Registry.intervals.push(_id);
		}
		
		public function fadeOut(text:FlxText):void
		{
			var _id:Number = setInterval(function():void { text.alpha -= 0.1; if (text.alpha >= 1) clearInterval(_id); }, 50, _id);
			Registry.intervals.push(_id);
		}
		
		override public function update():void
		{
			super.update();
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