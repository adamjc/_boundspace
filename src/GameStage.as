package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxMath;
	import com.greensock.*;
	import com.greensock.easing.*;

	
	/**
	 * ...
	 * @author Adam
	 */
	public class GameStage extends FlxBasic 
	{		
		public var level:int;
		public var wave:Wave;
		public var waveCount:int;
		public var miniBossSpawned:Boolean; // Has the mini boss of the stage been spawned?
		public var endBoss:Boolean;
		
		protected var isAnimating:Boolean;
		
		/**
		 * Constructor
		 * @param	_level
		 */
		public function GameStage(_level:int) 	
		{
			super();
			waveCount = 0;			
			level = _level;
			miniBossSpawned = false;
			if (_level != 6)
			{
				addWaveTween("Enemies approaching!", "pew pew pew!", "Enemy", level);
			}
			else
			{
				addWaveTween("Oh.", "Turds.", "EndBoss", level);
				endBoss = true;
			}			
		}
		
		override public function update():void
		{
			super.update();
			if (Registry.enemies.countLiving() <= 0 && !isAnimating)
			{	
				if (wave) { wave.kill(); }
				if (endBoss)
				{
					// TODO: Game completed. Switch to credits state.
					var cs:CreditsState = new CreditsState();
					FlxG.switchState(cs);
				}
				else if (waveCount < 9)
				{
					if (!miniBossSpawned && FlxMath.chanceRoll(20))
					{
						addWaveTween("Oh no, here comes...!", "MiniBoss!", "MiniBoss", level);
						miniBossSpawned = true;					
					}
					else
					{
						addWaveTween("Enemies approaching!", "pew pew pew!", "Enemy", level);
					}					
				}
				else if (waveCount < 10)
				{
					addWaveTween("Dun dun dun!", "go get 'em!", "Boss", level);
				}
				else if (waveCount < 11)
				{
					addWaveTween("Cue elevator music", "Seriously, buy some stuff", "Shop", level);
				}
			}
		}
		
		public function addWaveTween(topString:String, bottomString:String, type:String, level:int):void
		{
			isAnimating = true;
			
			var topText:FlxText = new FlxText( 0 - 300, 300, 200, topString);
			topText.scale.x = 2;
			topText.scale.y = 2;
			topText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(topText);
			
			var bottomText:FlxText = new FlxText( BoundSpace.SceneWidth, 328, 200, bottomString);
			bottomText.scale.x = 2;
			bottomText.scale.y = 2;
			bottomText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(bottomText);
			
			var box:TextBox = new TextBox(null, 0, 275, 2.75, 0, true, true);			
			
			TweenLite.to(topText, 
						 2, 
						 { x: BoundSpace.SceneWidth + topText.width, 
						   y: topText.y, 
						   onComplete: removeTweenObjs, 
						   onCompleteParams: [[topText, bottomText], type, level], 
						   ease: SlowMo.ease } );	
			
			TweenLite.to(bottomText, 
						 2, 
						 { x: -100, 
						   y: bottomText.y, 
						   ease: SlowMo.ease } );	   
		}
		
		/**
		 * Adds a wave of enemies to the screen.
		 */
		public function addWave(type:String, level:int):void
		{ 
			wave = new Wave(type, level);
			for (var i:int = 0; i < wave.units.length; i++)
			{				
				Registry.game.add(wave.units[i]);	
				if (type != "Shop")
				{
					Registry.enemies.add(wave.units[i]);
				}
			}
			if (type == "Shop")
			{
				Registry.game.shopKeeper = wave.units[2];
			}
			waveCount++;			
		}
		
		public function removeTweenObjs(tweens:Array, type:String, level:int):void
		{
			for each(var o:Object in tweens)
			{
				o.kill();
			}
			
			addWave(type, level);			
			isAnimating = false;
		}
	}

}