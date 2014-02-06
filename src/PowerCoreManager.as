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
		powerCores.push(new ArmourDownPowerCore(0, 0));
		powerCores.push(new ArmourUpPowerCore(0, 0));
		
		[Embed(source = "../assets/powercore-a-sketch.png")] public static var a:Class;
		[Embed(source = "../assets/powercore-b-sketch.png")] public static var b:Class;
		public static var aSprite:FlxSprite;
		public static var bSprite:FlxSprite;
		public static var powerCoreSprites:Array = new Array();
		
		
		/**
		 * Constructor.
		 */
		public function PowerCoreManager() 
		{			
		
		}
		
		public static function initialiseSprites():void
		{
			aSprite = new FlxSprite(0, 0, a);
			bSprite = new FlxSprite(0, 0, b);
			powerCoreSprites.push(a);
			powerCoreSprites.push(b);
			
			ArmourDownPowerCore.img = a;
			ArmourUpPowerCore.img = b;
			// TODO: Add all of the sprites for the powerCores.
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