package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class PowerCoreManager extends FlxBasic 
	{
		public static var powerCores:Array;
		powerCores = new Array();
		
		[Embed(source = "../assets/powercore-a.png")] public static var a:Class;
		[Embed(source = "../assets/powercore-b.png")] public static var b:Class;
		public static var aSprite:FlxSprite;
		public static var bSprite:FlxSprite;
		public static var powerCoreSprites:Array = new Array();
		
		[Embed(source = "../assets/powercore-a-small.png")] public static var aSmall:Class;
		[Embed(source = "../assets/powercore-b-small.png")] public static var bSmall:Class;				
		
		public static var powerCoreImages:Array = new Array();
		
		protected static const NO_POWERCORES:int = 2;
		
		/**
		 * Constructor.
		 */
		public function PowerCoreManager() 
		{			
			// Randomly assign powercore images to powercores.
		}
		
		public static function initialiseSprites():void
		{
			powerCoreImages.push([aSmall, a]);
			powerCoreImages.push([bSmall, b]);

			var powerCoreIndices:Array = new Array();
			
			for (var i:int = 0; i < NO_POWERCORES; i++)
			{
				powerCoreIndices[i] = i;
			}
			
			var r:int;
			
			r = Math.floor(Math.random() * powerCoreImages.length);						
			ArmourDownPowerCore.img = powerCoreImages[r][1];
			ArmourDownPowerCore.sprite = powerCoreImages[r][0];			
			powerCoreImages.splice(r, 1);
			
			r = Math.floor(Math.random() * powerCoreImages.length);						
			ArmourUpPowerCore.img = powerCoreImages[r][1];
			ArmourUpPowerCore.sprite = powerCoreImages[r][0];
			powerCoreImages.splice(r, 1);
						
			powerCores.push(new ArmourDownPowerCore(0, 0));
			powerCores.push(new ArmourUpPowerCore(0, 0));
		}
		
		public static function pickPowerCore(_x:Number = 100, _y:Number = 100, _shop:Boolean = false):PowerCore
		{
			// Pick randomly a new PowerCore to add.
			var r:int = Math.random() * ((powerCores.length - 1) + 0.5);	
			
			var p:Class = Object(powerCores[r]).constructor;
			var pc:PowerCore;
			pc = new p(_x, _y, _shop);
			return pc;
		}
		
		/**
		 * Randomly chooses a PowerCore from the powerCores array,
		 * instantiates it and adds it to the current game state.
		 */
		public static function addPowerCore(_x:Number = 100, _y:Number = 100, _shop:Boolean = false):PowerCore
		{
			var pc:PowerCore = pickPowerCore(_x, _y, _shop);
			
			// Add it to the PlayState.
			Registry.game.add(pc);
			
			// Add it to the PlayState's PowerCore collision group.
			Registry.game.items.add(pc);
			
			return pc;
		}
	}

}