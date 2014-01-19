package  
{
	import flash.display.Shader;
	import mx.core.FlexSprite;
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Adam
	 */
	public class MBomb extends SpecialItem 
	{
		public static const RADIUS:int = 20;
		public static const DAMAGE:int = 2;
		
		[Embed(source = "../assets/MBomb.png")] public var mbomb_img:Class;	
		
		public function MBomb(_x:int, _y:int, _shop:Boolean = false) 
		{			
			super(_x, _y, _shop);
			this.image = mbomb_img;
			x = _x;
			y = _y;
		}

		override public function update():void
		{
			super.update();
		}			
		
		public function intersects(object:FlxSprite):Boolean
		{
			var circleDistanceX:int;
			var circleDistanceY:int;
			
			circleDistanceX = Math.abs(this.x - object.x);
			circleDistanceY = Math.abs(this.y - object.y);
				
			if (circleDistanceX > (object.width / 2 + (RADIUS * Registry.player.chargeBarNumber))) { return false; }
			if (circleDistanceY > (object.height / 2 + (RADIUS * Registry.player.chargeBarNumber))) { return false; }
												
			if (circleDistanceX <= (object.width/2)) { return true; } 
			if (circleDistanceY <= (object.height/2)) { return true; }

			var cornerDistance_sq:Number = Math.pow((circleDistanceX - object.width/2), 2) +
										   Math.pow((circleDistanceY - object.height / 2), 2);
										   
			return (cornerDistance_sq <= Math.pow((RADIUS * Registry.player.chargeBarNumber), 2));
		}		
		
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
						a[i].enemyHit(DAMAGE * Registry.player.chargeBarNumber);	
					}
				}
			}
			
		}	
		
		override public function useSpecial():void
		{
			// Do something.			
			explode();
			// The Mega Bomb will explode in a radius out of the player, the larger the player's charge bar, the 
			// larger the radius and the more damage it will do.				
			
			//Registry.player.emptyChargeBar();
		}
	}

}