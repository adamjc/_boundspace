package  
{
	import EmitterXL.EmitterXL;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGame;
	import org.flixel.FlxGroup;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSave;
	import org.flixel.FlxSound;
	import org.flixel.FlxState;
	/**
	 * ...
	 * @author Adam
	 */
	public class Registry 
	{		
		[Embed(source = "../assets/Laser_Shoot.mp3")] public static var laserShoot:Class;
		
		[Embed(source = "../assets/explosy.png")] public static var basicParticle:Class;
		
		public static var stage:GameStage;		
		public static var player:Player;
		public static var currentWaveType:String;
		public static var level:int;
		public static var game:PlayState;
		public static var enemies:FlxGroup;	
		public static var otherEnemies:FlxGroup;
		public static var shopItems:Array = new Array();
		public static var portals:FlxGroup = new FlxGroup();
		public static var ui:UI;
		public static var intervals:Array = new Array();
		
		public static var mainMusic:FlxSound;
		public static var shopMusic:FlxSound;
		
		public static var creditsCollected:int = 0;
		public static var stageReached:int = 0;
		public static var waveReached:int = 0;
		public static var enemiesKilled:int = 0;
		
		public static const TOP_BOUNDS:Number = BoundSpace.UIMaxY;
		public static const RIGHT_BOUNDS:Number = BoundSpace.SceneWidth;
		public static const BOTTOM_BOUNDS:Number = BoundSpace.SceneHeight;
		public static const LEFT_BOUNDS:Number = 0;
		
		public static const ENEMY_SPAWN_POS_MIN:Number = -100;
		public static const ENEMY_SPAWN_POS_MAX:Number = 100;
		
		public static const PLAYER_LAYER:int = 0;
		public static const ITEM_LAYER:int = 1;
		public static const ENEMY_LAYER:int = 2;
		
		public static const PORTAL_1_POS:FlxPoint = new FlxPoint(LEFT_BOUNDS + 200, BoundSpace.UIMaxY + 100);
		public static const PORTAL_2_POS:FlxPoint = new FlxPoint(LEFT_BOUNDS + 400, BoundSpace.UIMaxY + 100);
		
		public static var fireRate:int;
		public static var bulletSpeed:int;
		public static var shipSpeed:int;
		public static var weaponDamage:int;
		
		public static const maxFireRate:int = 100;
		public static const maxBulletSpeed:int = 200;
		public static const maxShipSpeed:int = 10;
		public static const maxWeaponDamage:int = 50;
		public static const GCF:int = 10; // should write a function to do this.	
		
		public static const achievements:XML =	<achievements>
													<achievement>
													<title>UNTOUCHABLE</title>
														<trigger>optionsMenu</trigger>
													</achievement>
													<achievement>
														<title>START</title>
														<trigger>startGame</trigger>
													</achievement>
													<achievement>
														<title>ACHIEVEMENTS</title>
														<trigger>achievementsMenu</trigger>
													</achievement>
													<achievement>
														<title>CREDITS</title>
														<trigger>creditsSequence</trigger>
													</achievement>
												</achievements>;
		
		public static const BACKGROUND_START_X:int = -100;
		public static const BACKGROUND_START_Y:int = -100;
		
		
		
		public static const BACKGROUND_STARS_Z_LEVEL:int = 6999;
		public static const BACKGROUND_Z_LEVEL:int = 7000;
		
		
		//public static const UI_Z_LEVEL_BACKGROUND:int = 7250;
		public static const UI_Z_LEVEL_BACKGROUND:int = 9048;
		public static const UI_Z_LEVEL_CHARGE_BAR:int = 9049;
		
		public static const PORTAL_Z_LEVEL:int = 8000;
		public static const ITEM_Z_LEVEL:int = 8001;
		public static const ENEMY_Z_LEVEL:int = 8250;
		public static const PLAYER_Z_LEVEL:int = 8250;
		public static const ENEMY_SPAWNER_Z_LEVEL:int = 8251;
		public static const ENEMY_BOSS_Z_LEVEL:int = 8252;
		public static const ENEMY_PROJECTILE_Z_LEVEL:int = 8249;
		public static const PLAYER_PROJECTILE_Z_LEVEL:int = 8501;
		
		public static const UI_Z_LEVEL_ELEMENTS:int = 9050;		
		public static const UI_Z_LEVEL_BASE:int = 9100;	
		public static const UI_Z_LEVEL_SPECIAL_ITEM_GLOW:int = 9150;
		public static const UI_TEXT_Z_LEVEL:int = 9175;
		
		public static const ACHIEVEMENT_BACKGROUND:int = 9200;
		public static const ACHIEVEMENT_FOREGROUND:int = 9201;
		
		public static var SOUND_VOLUME:int = 0.5;
				
		public static function explode(object:Object) {
			var particleEmitter:EmitterXL = new EmitterXL(object.x + object.width / 2, object.y + object.height / 2, 10, {"fadeOut": true, "rotation": true, "fadeOutSpeed": 0.01});
			particleEmitter.z = Registry.ENEMY_Z_LEVEL;
			
			for (var i:int = 0; i < 20; i++)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(4, 4, 0xFFFFFFFF);
				particle.exists = false;
				particle.z = 0;
				particleEmitter.add(particle);
				particleEmitter.minRotation = 0;
				particleEmitter.maxRotation = 0;
			}	
			
			particleEmitter.maxParticleSpeed.x = 50;
			particleEmitter.maxParticleSpeed.y = 50;
			particleEmitter.minParticleSpeed.x = -50;
			particleEmitter.minParticleSpeed.y = -50;
			
			Registry.game.add(particleEmitter);
			particleEmitter.start(true, 2, 0.1, 0);
		}
		
		public function Registry()
		{			
		}
		
		/**
		 * 
		 * @param	max
		 * @return
		 */
		public static function pickRandom(max:int):int
		{
			return Math.random() * ((max - 1) + 0.5);
		}
	}
}