package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class TextBox extends FlxSprite 
	{
		public const FADE_OUT_VALUE:Number = 0.05;
		
		public var text:FlxText;
		public var image:FlxSprite;
		public var tBox:FlxGroup; // A container for everything in this object.
		public var count:Number;
		public var fadeOutTimer:int;	
				
		public function TextBox(_text:String, _x:int, _y:int, _count:Number = 2, _padding:int = 0, _fade:Boolean = true, _image:Boolean = false)
		{
			super();
			count = _count;
			tBox = new FlxGroup();
			tBox.z = Registry.UI_Z_LEVEL_ELEMENTS;
			text = new FlxText(_x + _padding, _y + _padding, 100, _text);
			x = _x;
			y = _y;
			z = Registry.UI_Z_LEVEL_ELEMENTS;
			if (_fade) { fadeOutTimer = count / 2; }
			if (_image)
			{
				image = new FlxSprite(x, y);
				image.makeGraphic(BoundSpace.SceneWidth, 100, 0xAAAAAAAA);	
				image.alpha = 0.5;
				image.z = Registry.UI_Z_LEVEL_ELEMENTS;
				tBox.add(image);
			}
			else
			{
				
			}
			tBox.add(this);
			tBox.add(text);
			this.visible = false;
			addEverything();
		}
		
		override public function update():void
		{
			super.update();
			countDown();
		}
		
		public function countDown():void
		{
			count -= FlxG.elapsed;
					
			if (count <= fadeOutTimer)
			{
				// Make the image more transparent.				
				text.alpha -= FADE_OUT_VALUE;
				if (image) image.alpha -= FADE_OUT_VALUE;
			}
			
			if (count <= 0)
			{
				removeEverything();
			}
		}
		
		public function removeEverything():void
		{
			tBox.kill();
		}
		
		public function addEverything():void
		{
			Registry.game.add(tBox);
		}
		
	}

}