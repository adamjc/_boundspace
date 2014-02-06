package CreditsScreen 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * A credits item, consisting of a title and some text
	 * @author ...
	 */
	public class CreditsItem extends FlxObject 
	{		
		protected var titleText:FlxText;
		protected var personsText:FlxText;
		
		protected const DEFAULT_X:int = 0;
		protected const DEFAULT_Y:int = 600;
		protected const DEFAULT_WIDTH:int = 700;
		
		protected const PADDING:int = 40;
		
		public var items:FlxGroup;
		
		public function CreditsItem(title:String, persons:String, x:int = DEFAULT_X, y:int = DEFAULT_Y, width:int = DEFAULT_WIDTH) 
		{	
			items = new FlxGroup;
			
			this.x = x;
			this.y = y;
			
			titleText = new FlxText(x, y, width, title);
			titleText.alignment = "center";
			titleText.size = 16;
			personsText = new FlxText(x, titleText.y + PADDING, width, persons);
			personsText.alignment = "center";
			personsText.size = 16;
			
			items.add(titleText);
			items.add(personsText);
		}		

		public function add(state:FlxState):void
		{
			state.add(items);
		}
		
		override public function update():void
		{
			super.update();
			
			titleText.x = this.x;
			titleText.y = this.y;
			
			personsText.x = this.x;
			personsText.y = this.y + PADDING;			
		}
		
		override public function kill():void
		{
			items.kill();
			super.kill();
		}
	}
}