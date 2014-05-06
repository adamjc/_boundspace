package  
{
	import Enemies.AsteroidShooter.AsteroidShooter;
	import Enemies.MineDroid.MineDroid;
	import Enemies.MoonBoss.MoonBoss;
	import Enemies.Rotatortron.Rotatortron;
	import Enemies.Asteroid.Asteroid;
	import Enemies.Brain.Brain;	
	import Enemies.Spike.Spike;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import StartScreen.Menu;
	import flash.desktop.ClipboardTransferMode;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class Wave extends FlxBasic 
	{
		public static var stageOneEnemies:Array = new Array([new AsteroidShooter(false, 500, 300)],[]);
		public static var stageOneMiniBosses:Array = new Array(new BanditSaucer(false));
		public static var stageOneBosses:Array = new Array(new MoonBoss(false));		
		
		public const MIN:int = 10;
		public const MAX:int = 15;
		
		public var units:Array;
		public var unitGroup:FlxGroup;
		
		public var portal1:Portal;
		public var portal2:Portal;		
		public var shopKeeper:ShopKeeper;	
		
		public var maxQueueSize:int = 5;
		
		public var numberOfEnemies:int;
		
		protected var _waveChosen:Array;
		
		/**
		 * Constructor.
		 * 
		 * @param	type
		 * @param	stageNumber
		 */
		public function Wave(type:String, stageNumber:int) 
		{
			super();			
			
			Registry.currentWaveType = type;
			
			if (type.localeCompare("Enemy") == 0)
			{
				units = createEnemies(MIN, MAX, stageNumber); // Create a normal enemy wave.
			}
			else if (type.localeCompare("MiniBoss") == 0)
			{
				units = createMiniBoss(stageNumber) // Create a MiniBoss wave.
			}
			else if (type.localeCompare("Boss") == 0)
			{
				units = createBoss(stageNumber);
			}
			else if (type.localeCompare("Shop") == 0)
			{
				units = createShop();
			}
			else if (type.localeCompare("EndBoss") == 0)
			{
				units = createEndBoss();
			}
		}	
		
		public function createEndBoss():Array
		{
			var units:Array = new Array();
			var endBoss:EndBoss = new EndBoss();
			units.push(endBoss);
			return units;
		}
		
		public function createShop():Array
		{
			var units:Array = new Array();
			units.push(new Portal(1), new ShopKeeper());
			
			Registry.game.add(units[0]);
			Registry.game.add(units[1]);
			
			return units;
		}
		
		public function createBoss(stageNumber:int):Array
		{
			var units:Array = new Array();
			var boss:Boss;			
			var arrayToUse:Array;
			var bossClass:Class;
			
			switch (stageNumber)
			{
				case 1:
					arrayToUse = stageOneBosses;
					break;
				default:
					arrayToUse = stageOneBosses;
					break;
			}
			
			var length:int = arrayToUse.length;
			var random:Number = Math.floor(Math.random());
			
			var bossClass:Class = Object(arrayToUse[random]).constructor; // Find the class of the enemy.					
			
			var boss:Boss = new bossClass(true, 350, 200);
			
			Registry.game.add(boss)
			Registry.enemies.add(boss);
			
			units.push(boss);
			numberOfEnemies = 1;
			return units;
		}
		
		/**
		 * 
		 * @param	stageNumber
		 * @return
		 */
		public function createMiniBoss(stageNumber:int):Array
		{
			var units:Array = new Array();
			var miniBoss:MiniBoss;									
			var arrayToUse:Array;
			var bossClass:Class;
			
			switch(stageNumber)
			{
				case 1:
					arrayToUse = stageOneMiniBosses;
					break;
				default:
					arrayToUse = stageOneMiniBosses;
					break;
			}
			
			var length:int = arrayToUse.length;
			var random:Number = Math.floor(Math.random() * (length));
						
			bossClass = Object(arrayToUse[random]).constructor; // Find the class of the enemy.		
			
			miniBoss = new bossClass(true, 350, 200);
			
			Registry.game.add(miniBoss)
			Registry.enemies.add(miniBoss);
			
			units.push(miniBoss);
			numberOfEnemies = 1;
			return units;
		}
		
		/**
		 * Creates a group of enemies, between min and max, chosen from the group difficulty.
		 * 
		 * @param	min
		 * @param	max
		 * @param	stageNumber
		 * @return a group of enemies
		 */
		protected var _tempEnemies:Array;
		protected var _addEnemyIntervalID:Number;
		public function createEnemies(min:int, max:int, stageNumber:int):Array
		{		
			var random:Number = Math.floor(min + (Math.random() * (MAX - MIN + .5)));
			unitGroup = new FlxGroup(random);
			_tempEnemies = new Array();
			
			unitGroup.z = Registry.ENEMY_Z_LEVEL;
			
			var i:int;
			var choices:int;			
			
			switch(stageNumber)
			{
				case 1:
					choices = stageOneEnemies.length * Math.random(); // Choose a random wave.
					choices = 0; // DEBUG
					_waveChosen = stageOneEnemies[choices];					
					break;
				default:
					choices = stageOneEnemies.length * Math.random();					
					choices = 0; // DEBUG
					_waveChosen = stageOneEnemies[choices];
					break;
			}
			
			enemiesLeftToAdd = _waveChosen.length - 1;
			_addEnemyIntervalID = setInterval(addEnemy, 500);
			Registry.intervals.push(_addEnemyIntervalID);
			
			numberOfEnemies = _waveChosen.length;
			
			return _tempEnemies;
		}
			
		protected var enemiesLeftToAdd:int;
		protected function addEnemy():void
		{
			var enemyClass:Class;
			var enemy:Enemy;	
			
			if (enemiesLeftToAdd < 0)
			{
				clearInterval(_addEnemyIntervalID);
				Registry.intervals.splice(_addEnemyIntervalID, 1);
			}
			else
			{
				enemyClass = Object(_waveChosen[enemiesLeftToAdd]).constructor; // Find the class of the enemy.		
				
				if (enemyClass === MineDroid)
				{
					enemy = new enemyClass(true, _waveChosen[enemiesLeftToAdd].x, _waveChosen[enemiesLeftToAdd].y, _waveChosen[enemiesLeftToAdd]._direction);
				}
				else
				{
					enemy = new enemyClass(true, _waveChosen[enemiesLeftToAdd].x, _waveChosen[enemiesLeftToAdd].y);
				}
				
				
				_tempEnemies.push(enemy);
				unitGroup.add(enemy);	
				enemiesLeftToAdd -= 1;	
				
				Registry.game.add(enemy)
				Registry.enemies.add(enemy);
				
			}						
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}
}