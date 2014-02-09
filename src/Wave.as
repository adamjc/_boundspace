package  
{
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
		public static var stageOneEnemies:Array = new Array(new SpaceCapsule(false));
		public static var stageOneMiniBosses:Array = new Array(new SaucerMiniBoss(false));
		public static var stageOneBosses:Array = new Array(new SpaceInvaderBoss(false));		
		
		public const MIN:int = 10;
		public const MAX:int = 15;
		
		public var units:Array;
		public var unitGroup:FlxGroup;
		
		public var portal1:Portal;
		public var portal2:Portal;		
		public var shopKeeper:ShopKeeper;	
		
		public var maxQueueSize:int = 5;
		
		/**
		 * Constructor.
		 * 
		 * @param	type
		 * @param	stageNumber
		 */
		public function Wave(type:String, stageNumber:int) 
		{
			super();			
			
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
			return units;
		}
		
		public function createBoss(stageNumber:int):Array
		{
			var units:Array = new Array();
			var boss:Boss;
			
			switch (stageNumber)
			{
				case 1:
					boss = new SpaceInvaderBoss();
					break;
				default:
					boss = new SpaceInvaderBoss();
					break;
			}
			units.push(boss);
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
			
			switch(stageNumber)
			{
				case 1:
					miniBoss = new SaucerMiniBoss();
					break;
				default:
					miniBoss = new SaucerMiniBoss();
					break;
			}
			units.push(miniBoss);
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
		public function createEnemies(min:int, max:int, stageNumber:int):Array
		{		
			var random:Number = Math.floor(min + (Math.random() * (MAX - MIN + .5)));
			unitGroup = new FlxGroup(random);
			var tempEnemies:Array = new Array();
			
			unitGroup.z = Registry.ENEMY_Z_LEVEL;
			
			var i:int;
			var choices:int;
			var enemyClass:Class;
			var enemy:Enemy;			
			
			for (i = 0; i < 2; i++)
			{						
				switch(stageNumber)
				{
					case 1:
						choices = stageOneEnemies.length * Math.random(); // Choose a random enemy to spawn.
						enemyClass = Object(stageOneEnemies[choices]).constructor; // Find the class of the enemy.
						break;
					default:
						choices = stageOneEnemies.length * Math.random();
						enemyClass = Object(stageOneEnemies[choices]).constructor;
						break;
				}
				
				enemy = new enemyClass();
				
				tempEnemies.push(enemy);
				unitGroup.add(enemy);				
			}
			
			return tempEnemies;
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}
}