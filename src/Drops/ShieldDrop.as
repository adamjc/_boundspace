package Drops 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import com.greensock.TweenMax;
	import com.greensock.easing.Ease
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShieldDrop extends FlxSprite 
	{
		[Embed(source = "../../assets/shield-drop.png")] protected var shieldDropImage:Class;		
		
		protected var val:int = 1;
		protected var price:int;
		protected var priceText:FlxText;
		
		public function ShieldDrop(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, Z:int=0) 
		{			
			super(X, Y, SimpleGraphic, Z);
			this.z = Registry.UI_Z_LEVEL_ELEMENTS;
			this.loadGraphic(shieldDropImage);			
			
			var tween:TweenMax = new TweenMax(this, 1, { y: this.y - 4, ease: Ease} );
			tween.yoyo(true);
			tween.repeat( -1);
			tween.repeatDelay(0.8);
			tween.play();
			
			Registry.game.items.add(this);
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
			// Handle collision with player.
			if (FlxG.collide(this, Registry.player) && (!this.price || this.price <= Registry.player.credits))
			{
				Registry.player.increaseShield(val);
				
				if (this.price)
				{
					Registry.player.decreaseCredits(this.price);
				}
				
				if (this.priceText) { this.priceText.kill(); }
				this.kill();
			}
			
			super.update();
		}
	}
}