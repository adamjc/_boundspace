package CreditsScreen 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import CreditsScreen.CreditsItem;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CreditsScreen extends FlxObject 
	{		
		protected const TIME:int = 60;
		
		protected const ITEM_PADDING:int = 200;
		
		protected var items:FlxGroup;
		
		public var endOfCredits:int;
		
		protected var basicallyEverything:CreditsItem;
		protected var music:CreditsItem;
		
		
		
		public function CreditsScreen() 
		{
			basicallyEverything	= new CreditsItem("Basically Everything", "Adam Cook \n @_AdamC");
			music = new CreditsItem("Music", "Not for Nothing \n @notfornothing", basicallyEverything.x, basicallyEverything.y + ITEM_PADDING);
			
			endOfCredits = music.y + 200;
			
			items = new FlxGroup();
			items.add(basicallyEverything);
			items.add(music);
			
			this.velocity = new FlxPoint(0, -100);
			
			y = BoundSpace.SceneHeight;
		}	
		
		public function add(state:FlxState):void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				state.add(items.members[i]);
				items.members[i].add(state);
			}
		}
		
		override public function update():void
		{
			super.update();
			
			for (var i:int = 0; i < items.length; i++)
			{
				items.members[i].x = x;
				items.members[i].y = items.members[i - 1] ? items.members[i - 1].y + ITEM_PADDING : y;
			}
						
			endOfCredits = music.y + 200;
		}
		
		override public function kill():void
		{
			items.kill();
			super.kill();		
		}
	}
}