package  
{
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.utils.clearInterval;
	import flash.utils.Dictionary;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxGroup;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.FlxButton;
	import StartScreen.Menu;	
	import org.flixel.plugin.photonstorm.FX.GlitchFX;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class Paused extends FlxGroup 
	{
		protected var background:FlxSprite;
		protected var field:FlxText;
		protected var isDisplaying:Boolean;
		protected var finishCallback:Function;
		protected var resumeButton:FlxButton;
		protected var restartButton:FlxButton;
		protected var quitButton:FlxButton;	
		
		protected var _resumeText:FlxText;
		protected var _restartText:FlxText;
		protected var _quitText:FlxText;
		
		public var isShowing:Boolean;		
		
		[Embed(source = "../assets/paused_frame.png")] protected var pausedFrameSprite:Class;
		[Embed(source = "../assets/fire_rate.png")] protected var fireRate:Class;
		[Embed(source = "../assets/shipSpeed.png")] protected var shipSpeed:Class;
		[Embed(source = "../assets/shot_speed.png")] protected var bulletSpeed:Class;
		[Embed(source = "../assets/bullet_damage.png")] protected var bulletDamage:Class;
		
		public function Paused() 
		{
			background = new FlxSprite(200, 175, pausedFrameSprite, 0);
			
			background.scrollFactor.x = 0;
			background.scrollFactor.y = 0;
			
			field = new FlxText(background.x, background.y, 300, "PAUSED");
			field.setFormat("DefaultFont", 32, 0xFFFFFFFF, "center");
			field.scrollFactor.x = 0;
			field.scrollFactor.y = 0;
				
			var fireRate:FlxSprite = new FlxSprite(background.x + 50, background.y + 60, fireRate);
			var fireRateText:FlxText = new FlxText(fireRate.x + 35, fireRate.y + 2, 150, (1 - ((Registry.fireRate / 100) / Registry.GCF)).toFixed(1).toString() + "/" + (Registry.player.MAX_FIRE_RATE / 10 / Registry.GCF).toString());
			fireRateText.setFormat("DefaultFont", 16, 0xFFFFFFFF);
			
			var shipSpeed:FlxSprite = new FlxSprite(fireRate.x + 100, fireRate.y - 5, shipSpeed);
			shipSpeed.antialiasing = true;
			var shipSpeedText:FlxText = new FlxText(shipSpeed.x + 45, fireRate.y + 2, 150, ((Registry.shipSpeed) / Registry.GCF).toFixed(1).toString() + "/" + (Registry.player.MAX_SHIP_SPEED / Registry.GCF).toString());
			shipSpeedText.setFormat("DefaultFont", 16, 0xFFFFFFFF);
			
			var bulletSpeed:FlxSprite = new FlxSprite(background.x + 55, background.y + 120, bulletSpeed);
			var bulletSpeedText:FlxText = new FlxText(bulletSpeed.x + 32, bulletSpeed.y - 3, 150, ((Registry.bulletSpeed) / Registry.GCF).toString() + "/" + (Registry.player.MAX_BULLET_SPEED / Registry.GCF).toString());
			bulletSpeedText.setFormat("DefaultFont", 16, 0xFFFFFFFF);
			
			var bulletDamage:FlxSprite = new FlxSprite(bulletSpeed.x + 105, bulletSpeed.y - 3, bulletDamage);
			var bulletDamageText:FlxText = new FlxText(bulletDamage.x + 35, bulletDamage.y, 150, ((Registry.weaponDamage) / Registry.GCF).toFixed(1).toString() + "/" + (Registry.player.MAX_WEAPON_DAMAGE / Registry.GCF).toString());
			bulletDamageText.setFormat("DefaultFont", 16, 0xFFFFFFFF);
			
			
			_resumeText = new FlxText(background.x, background.y + 175, 300, "RESUME");
			_resumeText.setFormat("DefaultFont", 16, 0xFFFFFFFF, "center");
			_resumeText.alpha = 0.5;						
			
			_restartText = new FlxText(background.x, _resumeText.y + 40, 300, "RESTART");
			_restartText.setFormat("DefaultFont", 16, 0xFFFFFFFF, "center");
			_restartText.alpha = 0.5;						
			
			_quitText= new FlxText(background.x, _restartText.y + 40, 300, "QUIT");
			_quitText.setFormat("DefaultFont", 16, 0xFFFFFFFF, "center");
			_quitText.alpha = 0.5;						
			
			//resumeButton = new FlxButton(background.x + 100, background.y + 200, "resume", resumeGame);
			//quitButton = new FlxButton(_resumeText.x, _resumeText.y + 40, "quit", quitGame);
			//restartButton = new FlxButton(_resumeText.x, quitButton.y + 40, "restart", restartGame);
			
			add(background);
			
			add(fireRate);
			add(fireRateText);
			
			add(shipSpeed);
			add(shipSpeedText);
			
			add(bulletSpeed);
			add(bulletSpeedText);
			
			add(bulletDamage);
			add(bulletDamageText);
			
			add(field);		
			
			add(_resumeText);
			add(_restartText);
			add(_quitText);						
		}
		
		public function showPaused():void
		{
			isDisplaying = true;
			isShowing = true;
		}
		
		override public function update():void
		{
			if (isDisplaying)
			{				
				if (FlxG.keys.justPressed("ESCAPE"))
				{
					resumeGame();
					if (finishCallback != null)
					{
						finishCallback();
					}
				}
				else
				{
					isShowing = true;
					isDisplaying = true;
				}
				
				if (FlxMath.mouseInFlxRect(false, new FlxRect(_resumeText.x, _resumeText.y, _resumeText.width, _resumeText.height)))
				{
					_resumeText.alpha = 1;
					
					if (FlxG.mouse.justPressed())
					{
						this.resumeGame();
					}
				}
				else
				{
					_resumeText.alpha = 0.5;
				}
				
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
			}			
		}
		
		public function resumeGame():void
		{
			this.kill();
			this.exists = false;
			isShowing = false;
			isDisplaying = false;
		}
		
		public function generalReset():void
		{
			Registry.game.resetIntervals();
			Registry.game.resetPowerCores();
			FlxSpecialFX.clear();
			Registry.game.kill();
			Registry.game.exists = false;
		}
		
		public function quitGame():void
		{			
			generalReset();
			
			this.kill();
			this.exists = false;
			isShowing = false;
			isDisplaying = false;	
			
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
			isShowing = false;
			isDisplaying = false;
		}
	}

}