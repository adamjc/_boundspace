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
	public class HealthDrop extends FlxSprite 
	{
		[Embed(source = "../../assets/health-drop.png")] protected var healthDropImage:Class;		
		
		public function HealthDrop(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, Z:int=0) 
		{			
			super(X, Y, SimpleGraphic, Z);
			this.z = Registry.UI_Z_LEVEL_ELEMENTS;
			this.loadGraphic(healthDropImage);			
			
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
				Registry.player.increaseHealth();
				this.kill();
			}
			
			super.update();
		}
	}
}