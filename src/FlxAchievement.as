package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author Adam
	 */
	public class FlxAchievement extends FlxSprite 
	{		
		protected var title:FlxText;
		protected var bodyText:FlxText;
		protected var image:FlxSprite;	
		protected var tweenCompleted:Boolean = false;
		protected var counter:Number;
		
		protected const ALPHA_DECREASE_VAL:Number = 0.025;
		
		public function FlxAchievement(startPt:FlxPoint, endPt:FlxPoint, width:int, height:int, lifespan:Number, text:String) 
		{
			super(startPt.x, startPt.y, null, 3);
			this.makeGraphic(width, height, 0xFF888888);			
			this.z = Registry.ACHIEVEMENT_BACKGROUND;
			
			image = new FlxSprite(this.x, this.y, null, 4);
			image.makeGraphic(50, 50, 0xFFAAAAAA);
			Registry.game.add(image);
			image.z = Registry.ACHIEVEMENT_BACKGROUND;
			
			title = new FlxText(35 + image.x + image.width, this.y, 70, "Achieve Get!!");
			title.scale.x = 2;
			title.scale.y = 2;
			title.z = Registry.ACHIEVEMENT_FOREGROUND;
			title.alignment = "center";
			Registry.game.add(title);
			
			bodyText = new FlxText(35 + image.x + image.width, title.y + 25, 70, text);
			bodyText.scale.x = 2;
			bodyText.scale.y = 2;
			bodyText.z = Registry.ACHIEVEMENT_FOREGROUND;
			bodyText.alignment = "center";
			Registry.game.add(bodyText);
			
			TweenLite.to(this, 0.5, { x: endPt.x, y: endPt.y, onComplete: tweenComplete, ease: Back.easeOut } );
		}
		
		override public function update():void
		{
			super.update();
			
			// update all contained elements.
			image.x = this.x;
			image.y = this.y;			
			
			title.x = 35 + image.x + image.width;
			title.y = this.y;
			
			bodyText.x = 35 + image.x + image.width
			bodyText.y = title.y + 25;
			
			// fade out over time, but only after the tween has completed
			// and only after the player has had the time to see it.
			if (tweenCompleted)
			{
				if (counter < 0)
				{
					this.alpha -= ALPHA_DECREASE_VAL;	
					image.alpha -= ALPHA_DECREASE_VAL;
					title.alpha -= ALPHA_DECREASE_VAL;
					bodyText.alpha -= ALPHA_DECREASE_VAL;
				}
				this.counter -= FlxG.elapsed;		
			}
			
			if (this.alpha < 0)
			{
				this.kill();
				image.kill();
				title.kill();
				bodyText.kill();
			}
			
		}
		
		public function tweenComplete():void 
		{
			tweenCompleted = true;
			counter = 1.0;
		}
	}

}