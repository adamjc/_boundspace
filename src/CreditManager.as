package  
{
	import org.flixel.FlxBasic;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class CreditManager extends FlxBasic 
	{
		protected static var credits:Array = new Array();
		credits.push(new SmallCredit(0, 0));
		
		public function CreditManager() 
		{
			
		}
		
		public static function makeCredit(_x:int, _y:int):Credit
		{
			var r:int = Math.random() * ((credits.length - 1) + 0.5);	
			
			var c:Class = Object(credits[r]).constructor;
			var ci:Credit;
			
			ci = new c(_x, _y);
			ci.z = Registry.UI_Z_LEVEL_ELEMENTS;
			
			return ci;
		}
		
	}

}