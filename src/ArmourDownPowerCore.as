package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Adam
	 */
	public class ArmourDownPowerCore extends PowerCore 
	{
		public static var used:Boolean = false; // Has the player has installed the PowerCore?
		
		public static const VAL:Number = 1;		
		
		public static var img:Class;		
		public static var sprite:Class;	
		
		/**
		 * Constructor.
		 * @param	name
		 * @param	attribute
		 */
		public function ArmourDownPowerCore(_x:Number, _y:Number, _shop:Boolean = false) 
		{
			super(_x, _y, _shop);
			this.usedName = "HPDOWN";
			this.unusedName = "???";
			this.attribute = "armour";
			this.positive = false;
			this.value = VAL;
			
			if (ArmourDownPowerCore.used)
			{
				this.name = this.usedName;
			}
			else
			{
				this.name = this.unusedName;				
			}	
			
			//makeGraphic(3, 3, 0xFF00FF00);
			loadGraphic(sprite);
			
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
			
			Registry.player.maxArmour -= VAL;
			
			
			
			if (!used)
			{
				this.name = this.usedName;		
				ArmourDownPowerCore.used = true;
				this.showText();
			}			
		}		
		
	}

}