package  
{
	import org.flixel.FlxBasic;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class SpecialItemManager extends FlxBasic 
	{
		public static var specialItems:Array;
		specialItems = new Array();
		specialItems.push(new MBomb(0, 0));
				
		
		/**
		 * Constructor.
		 */
		public function SpecialItemManager() 
		{
		}
		
		public function initialiseSprites():void
		{
			
			// TODO: Add all of the sprites for the powerCores.
		}
		
		public static function pickSpecialItem(_x:Number = 100, _y:Number = 100, _shop:Boolean = false):SpecialItem
		{
			// Pick randomly a new SpecialItem to add.
			var r:int = Math.random() * ((specialItems.length - 1) + 0.5);	
			
			var s:Class = Object(specialItems[r]).constructor;
			var si:SpecialItem;
			
			si = new s(_x, _y, _shop);
			return si;
		}
		
		/**
		 * Randomly chooses a PowerCore from the powerCores array,
		 * instantiates it and adds it to the current game state.
		 */
		public static function addSpecialItem(_x:Number = 100, _y:Number = 100, _shop:Boolean = false):SpecialItem
		{
			var si:SpecialItem = pickSpecialItem(_x, _y, _shop);
			
			// Add it to the PlayState.
			Registry.game.add(si);
			
			// Add it to the PlayState's PowerCore collision group.
			Registry.game.items.add(si);
			
			return si;
		}
	}

}