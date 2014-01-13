package  
{
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.utils.Dictionary;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	import org.flixel.FlxButton;
	
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
			
			field = new FlxText(background.x + 80, background.y + 25, 400, "Game Paused");
			field.setFormat(null, 16, 0xFFFFFFFF);
			field.scrollFactor.x = 0;
			field.scrollFactor.y = 0;
				
			var fireRate:FlxSprite = new FlxSprite(background.x + 50, background.y + 70, fireRate);
			var fireRateText:FlxText = new FlxText(fireRate.x + 35, fireRate.y + 2, 150, (1 - ((Registry.fireRate / 100) / Registry.GCF)).toFixed(1).toString() + "/" + (Registry.player.MAX_FIRE_RATE / 10 / Registry.GCF).toString());
			fireRateText.setFormat(null, 16, 0xFFFFFFFF);
			
			var shipSpeed:FlxSprite = new FlxSprite(fireRate.x + 100, fireRate.y - 5, shipSpeed);
			shipSpeed.antialiasing = true;
			var shipSpeedText:FlxText = new FlxText(shipSpeed.x + 45, fireRate.y + 2, 150, ((Registry.shipSpeed) / Registry.GCF).toFixed(1).toString() + "/" + (Registry.player.MAX_SHIP_SPEED / Registry.GCF).toString());
			shipSpeedText.setFormat(null, 16, 0xFFFFFFFF);
			
			var bulletSpeed:FlxSprite = new FlxSprite(background.x + 55, background.y + 140, bulletSpeed);
			var bulletSpeedText:FlxText = new FlxText(bulletSpeed.x + 32, bulletSpeed.y - 3, 150, ((Registry.bulletSpeed) / Registry.GCF).toString() + "/" + (Registry.player.MAX_BULLET_SPEED / Registry.GCF).toString());
			bulletSpeedText.setFormat(null, 16, 0xFFFFFFFF);
			
			var bulletDamage:FlxSprite = new FlxSprite(bulletSpeed.x + 105, bulletSpeed.y - 3, bulletDamage);
			var bulletDamageText:FlxText = new FlxText(bulletDamage.x + 35, bulletDamage.y, 150, ((Registry.weaponDamage) / Registry.GCF).toFixed(1).toString() + "/" + (Registry.player.MAX_WEAPON_DAMAGE / Registry.GCF).toString());
			bulletDamageText.setFormat(null, 16, 0xFFFFFFFF);
			
			
			resumeButton = new FlxButton(background.x + 100, background.y + 200, "resume", resumeGame);
			quitButton = new FlxButton(resumeButton.x, resumeButton.y + 25, "quit", quitGame);
			restartButton = new FlxButton(resumeButton.x, quitButton.y + 25, "restart", restartGame);
			
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
			add(resumeButton);
			add(quitButton);
			add(restartButton);
			
			
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
		
		public function quitGame():void
		{
			Registry.game.kill();
			Registry.game.exists = false;
			this.kill();
			this.exists = false;
			isShowing = false;
			isDisplaying = false;			
		}
		
		public function restartGame():void
		{
			Registry.game.kill();
			Registry.game.exists = false;
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