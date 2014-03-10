package  
{
	import flash.utils.setInterval;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	import flash.ui.Mouse;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.FlxRect;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import StartScreen.Menu;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class DeathState extends FlxState 
	{
		protected var _diedText:FlxText;
		protected var _topBar:FlxSprite;
		protected var _bottomBar:FlxSprite;
		
		protected var _demotivatorText:FlxText;
		protected var _demotivatorTexts:Array = ["TRY NOT DOING THAT...", "I SHOULDN'T HAVE EXPECTED ANY LESS, REALLY.", "DODGE MORE."];
		
		protected var _progressInfo:Array;
		protected var _progressText:FlxText;
		protected var _progressMetric:FlxText;
		protected var _progressIntervalID:Number;
		
		protected var _restartText:FlxText;
		protected var _quitText:FlxText;
		
		protected const _bloom:uint = 6;	//How much light bloom to have - larger numbers = more
		protected var _fx:FlxSprite;		//Our helper sprite - basically a mini screen buffer (see below)
		
		override public function create():void
		{
			//This is the sprite we're going to use to help with the light bloom effect
			//First, we're going to initialize it to be a fraction of the screens size
			_fx = new FlxSprite();
			_fx.makeGraphic(FlxG.width/_bloom,FlxG.height/_bloom,0,true);
			_fx.setOriginToCorner();	//Zero out the origin so scaling goes from top-left, not from center
			_fx.scale.x = _bloom;		//Scale it up to be the same size as the screen again
			_fx.scale.y = _bloom;		//Scale it up to be the same size as the screen again
			_fx.antialiasing = true;	//Set AA to true for maximum blurry
			_fx.blend = "screen";		//Set blend mode to "screen" to make the blurred copy transparent and brightening
			//Note that we do not add it to the game state!  It's just a helper, not a "real" sprite.

			//Then we scale the screen buffer down, so it draws a smaller version of itself
			// into our tiny FX buffer, which is already scaled up.  The net result of this operation
			// is a blurry image that we can render back over the screen buffer to create the bloom.
			FlxG.camera.screen.scale.x = 1/_bloom;
			FlxG.camera.screen.scale.y = 1/_bloom;
		}
		
		public function DeathState() 
		{	
			
			
			FlxG.bgColor = 0xFF000000;
			
			_diedText = new FlxText(0, 20, BoundSpace.SceneWidth, "YOU DIED!");
			_diedText.setFormat("DefaultFont", 48, 0xffffff, "center");
			
			_topBar = new FlxSprite(220, _diedText.y);
			_topBar.makeGraphic(260, 7, 0xffffffff);
			
			_bottomBar = new FlxSprite(220, _diedText.y + _diedText.height);
			_bottomBar.makeGraphic(260, 7, 0xffffffff);
			
			var r:int = Math.floor(Math.random() * _demotivatorTexts.length);
			_demotivatorText = new FlxText(0, _diedText.y + _diedText.height + 10, BoundSpace.SceneWidth);
			_demotivatorText.setFormat("DefaultFont", 16, 0xffffff, "center");
			_demotivatorText.text = _demotivatorTexts[r];
			_demotivatorText.alpha = 0.5;
			
			_restartText = new FlxText(0, 480, BoundSpace.SceneWidth, "RESTART");
			_restartText.setFormat("DefaultFont", 24, 0xFFFFFFFF, "center");
			_restartText.alpha = 0.5;						
			
			_quitText = new FlxText(0, _restartText.y + _restartText.height + 5, BoundSpace.SceneWidth, "MAIN MENU");
			_quitText.setFormat("DefaultFont", 24, 0xFFFFFFFF, "center");
			_quitText.alpha = 0.5;	
				
			_progressInfo = [
				["CREDITS\n\t\tCOLLECTED!", Registry.creditsCollected], 
				["STAGE\n\t\tREACHED!", Registry.stageReached], 
				["WAVE\n\t\tREACHED!", Registry.waveReached], 
				["ENEMIES\n\t\tKILLED!", Registry.enemiesKilled]
			];
			
			var progressIncreasing:Boolean;
			var progressIndex:int = 0;
			_progressIntervalID = setInterval(function():void {
				if (_progressText.alpha >= 1.0)
				{
					progressIncreasing = false;
				}
				
				if (_progressText.alpha <= 0.0)
				{
					progressIncreasing = true;
					_progressText.text = _progressInfo[progressIndex][0];
					_progressMetric.text = _progressInfo[progressIndex][1];
					progressIndex = (progressIndex + 1) % _progressInfo.length;
				}
				
				if (progressIncreasing)
				{
					_progressText.alpha += 0.025;
					_progressMetric.alpha += 0.025;
				}
				else
				{
					_progressText.alpha -= 0.025;
					_progressMetric.alpha -= 0.025;
				}
			}, 50);
			
			_progressText = new FlxText( -100, _demotivatorText.y + 110, BoundSpace.SceneWidth, _progressInfo[1][0]);
			_progressText.setFormat("DefaultFont", 56, 0xffffff, "center");
			_progressText.angle = -25;
			_progressText.antialiasing = true;
			_progressText.alpha = 0;
			
			_progressMetric = new FlxText(0, _progressText.y + _progressText.height - 40, BoundSpace.SceneWidth, _progressInfo[1][1]);
			_progressMetric.setFormat("DefaultFont", 56, 0x23b8c5, "center");
			_progressMetric.angle = -25;
			_progressMetric.antialiasing = true;
			_progressMetric.alpha = 0;
			
			
			
			add(_diedText);
			add(_topBar);
			add(_bottomBar);
			add(_demotivatorText);
			add(_restartText);
			add(_quitText);
			add(_progressText);
			add(_progressMetric);
		}
			
		override public function draw():void
		{
			//The actual blur process is quite simple now.
			//First we draw the contents of the screen onto the tiny FX buffer:
			_fx.stamp(FlxG.camera.screen);
			//Then we draw the scaled-up contents of the FX buffer back onto the screen:
			_fx.draw();
			
			//This draws all the game objects
			super.draw();
		}
		
		override public function update():void
		{			
			if (FlxMath.mouseInFlxRect(false, new FlxRect(_restartText.x, _restartText.y, _restartText.width, _restartText.height)))
			{
				_restartText.alpha = 1;
				
				if (FlxG.mouse.justPressed())
				{
					this.restartGame();
				}
			}
			else
			{
				_restartText.alpha = 0.5;
			}
			
			if (FlxMath.mouseInFlxRect(false, new FlxRect(_quitText.x, _quitText.y, _quitText.width, _quitText.height)))
			{
				_quitText.alpha = 1;
				
				if (FlxG.mouse.justPressed())
				{
					this.quitGame();
				}
			}
			else
			{
				_quitText.alpha = 0.5;
			}
			
			super.update();
			Mouse.show();
		}
		
		public function generalReset():void
		{
			Registry.game.resetIntervals();
			Registry.game.resetPowerCores();
			FlxSpecialFX.clear();
		}
		
		public function quitGame():void
		{			
			generalReset();
			
			this.kill();
			this.exists = false;
			
			var menu:Menu = new Menu();
			FlxG.switchState(menu);
		}
		
		public function restartGame():void
		{
			generalReset();		
						
			var p:PlayState = new PlayState();
			Registry.game = p;
			FlxG.switchState(p);
			this.kill();
			this.exists = false;
		}
	}

}