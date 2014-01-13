package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * When a player enters a Portal, it ends the current GameStage 
	 * and starts a new GameStage with the given parameters.
	 * @author Adam
	 */
	public class Portal extends FlxSprite 
	{		
		/**
		 * Constructor.
		 */
		
		[Embed(source = "../assets/portal.png")] public var portalImage:Class;
		 
		public function Portal(name:int) 
		{
			if (name === 1)
			{
				x = Registry.PORTAL_1_POS.x;
				y = Registry.PORTAL_2_POS.y;
			}
			else
			{
				x = Registry.PORTAL_2_POS.x;
				y = Registry.PORTAL_2_POS.y;
			}
			
			var graphic:FlxSprite = loadGraphic(portalImage, true, false, 50, 50);
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i;
			}
			
			this.z = Registry.PORTAL_Z_LEVEL;
			
			addAnimation("portal", array, 24, true);
			this.play("portal");
			Registry.portals.add(this);
		}
		
	}

}