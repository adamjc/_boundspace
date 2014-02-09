package Drops 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import com.greensock.TweenMax;
	import com.greensock.easing.Ease
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShieldDrop extends FlxSprite 
	{
		[Embed(source = "../../assets/shield-drop.png")] protected var shieldDropImage:Class;		
		
		protected var val:int = 1;
		
		public function ShieldDrop(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, Z:int=0) 
		{			
			super(X, Y, SimpleGraphic, Z);
			this.z = Registry.UI_Z_LEVEL_ELEMENTS;
			this.loadGraphic(shieldDropImage);			
			
			var tween:TweenMax = new TweenMax(this, 1, { y: this.y - 4, ease: Ease} );
			tween.yoyo(true);
			tween.repeat( -1);
			tween.repeatDelay(0.8);
			trace(tween.yoyo());
			tween.play();
		}
		
		override public function update():void
		{						
			// Handle collision with player.
			if (FlxG.collide(this, Registry.player))
			{
				Registry.player.increaseShield(val);
				this.kill();
			}
			
			super.update();
		}
	}
}