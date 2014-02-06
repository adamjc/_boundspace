package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Adam
	 */
	public class ArmourUpPowerCore extends PowerCore 
	{
		public static var used:Boolean = false; // Has the player has installed the PowerCore?
		
		public static const VAL:Number = 1;		
		
		public static var img:Class;		
		
		/**
		 * Constructor.
		 * @param	name
		 * @param	attribute
		 */
		public function ArmourUpPowerCore(_x:Number, _y:Number, _shop:Boolean = false) 
		{
			super(_x, _y, _shop);
			this.usedName = "armour+";
			this.unusedName = "???";
			this.attribute = "armour";
			this.positive = true;
			this.value = VAL;
			

			
			if (ArmourUpPowerCore.used)
			{
				this.name = this.usedName;
			}
			else
			{
				this.name = this.unusedName;
			}	
			
			makeGraphic(3, 3, 0xFF000FF0);
			x = _x;
			y = _y;
		}		

		override public function update():void
		{
			super.update();
		}
		
		/**
		 * Alters the player's attributes depending on the value of 
		 * the PowerCore and what attribute it changes.
		 */
		override public function installCore():void
		{
			super.installCore();
			
			if (!used)
			{
				this.name = this.usedName;		
				ArmourUpPowerCore.used = true;
			}			
		}		
		
	}

}