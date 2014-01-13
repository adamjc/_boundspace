package  
{
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class AI extends FlxObject 
	{				
		/**
		 * Constructor.
		 */
		public function AI() 
		{			
			super();
			Registry.game.add(this);
		}
		
		/**
		 * All of the AI updates go here, any changes to the unit
		 * go here also.
		 */
		override public function update():void
		{
			super.update();
			
			
		}
		
		public function removeThis():void
		{
			
		}
	}
}