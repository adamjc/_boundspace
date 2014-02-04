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
				
		[Embed (source = "../assets/textbox-upper-left.png")] protected var textboxUpperLeft:Class;
		[Embed (source = "../assets/textbox-upper-right.png")] protected var textboxUpperRight:Class;
		[Embed (source = "../assets/textbox-bottom-right.png")] protected var textboxBottomRight:Class;
		[Embed (source = "../assets/textbox-bottom-left.png")] protected var textboxBottomLeft:Class;
		[Embed (source = "../assets/textbox-speech-arrow.png")] protected var textboxSpeechArrow:Class;
		
		public function TextBox(_text:String, _x:int, _y:int, _count:Number = 2, _padding:int = 0, _fade:Boolean = true, _image:Boolean = false)
		{
			super();
			count = _count;
			tBox = new FlxGroup();
			tBox.z = Registry.UI_Z_LEVEL_ELEMENTS;
			text = new FlxText(_x + _padding, _y + _padding, 100, _text);
			text.setFormat("DefaultFont", 16);
			text.color = 0x00000000;
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
				var upperLeftCorner:FlxSprite = new FlxSprite();
				upperLeftCorner.z = Registry.UI_Z_LEVEL_ELEMENTS;
				upperLeftCorner.loadGraphic(textboxUpperLeft);
				upperLeftCorner.x = text.x - upperLeftCorner.width;
				upperLeftCorner.y = text.y - upperLeftCorner.height;
				tBox.add(upperLeftCorner);
				
				var upperRightCorner:FlxSprite = new FlxSprite();
				upperRightCorner.z = Registry.UI_Z_LEVEL_ELEMENTS;
				upperRightCorner.loadGraphic(textboxUpperRight);
				upperRightCorner.x = text.x + text.width;
				upperRightCorner.y = text.y - upperRightCorner.height;
				tBox.add(upperRightCorner);
				
				var bottomRightCorner:FlxSprite = new FlxSprite();
				bottomRightCorner.z = Registry.UI_Z_LEVEL_ELEMENTS;
				bottomRightCorner.loadGraphic(textboxBottomRight);
				bottomRightCorner.x = text.x + text.width;
				bottomRightCorner.y = text.y + text.height;
				tBox.add(bottomRightCorner);
				
				var bottomLeftCorner:FlxSprite = new FlxSprite();
				bottomLeftCorner.z = Registry.UI_Z_LEVEL_ELEMENTS;
				bottomLeftCorner.loadGraphic(textboxBottomLeft);
				bottomLeftCorner.x = text.x - bottomLeftCorner.width;
				bottomLeftCorner.y = text.y + text.height;
				tBox.add(bottomLeftCorner);				
				
				var upperConnector:FlxSprite = new FlxSprite();				
				upperConnector.makeGraphic(text.width, upperLeftCorner.height);
				upperConnector.z = Registry.UI_Z_LEVEL_ELEMENTS;
				upperConnector.x = text.x;
				upperConnector.y = text.y - upperConnector.height;
				
				var rightConnector:FlxSprite = new FlxSprite();
				rightConnector.makeGraphic(upperRightCorner.width, text.height);
				rightConnector.z = Registry.UI_Z_LEVEL_ELEMENTS;
				rightConnector.x = text.x + text.width;
				rightConnector.y = text.y;
				
				var bottomConnector:FlxSprite = new FlxSprite();
				bottomConnector.makeGraphic(text.width, bottomRightCorner.height);
				bottomConnector.z = Registry.UI_Z_LEVEL_ELEMENTS;
				bottomConnector.x = text.x;
				bottomConnector.y = text.y + text.height;
				
				var leftConnector:FlxSprite = new FlxSprite();
				leftConnector.makeGraphic(bottomLeftCorner.width, text.height);
				leftConnector.z = Registry.UI_Z_LEVEL_ELEMENTS;
				leftConnector.x = text.x - bottomLeftCorner.width;
				leftConnector.y = text.y;
				
				tBox.add(upperConnector);
				tBox.add(rightConnector);
				tBox.add(bottomConnector);
				tBox.add(leftConnector);
								
				var textFill:FlxSprite = new FlxSprite();
				textFill.makeGraphic(text.width, text.height);
				textFill.x = text.x;
				textFill.y = text.y;
				text.z = Registry.UI_Z_LEVEL_ELEMENTS - 1;
				tBox.add(textFill);
				
				var speechArrow:FlxSprite = new FlxSprite();
				speechArrow.loadGraphic(textboxSpeechArrow);
				speechArrow.x = text.x - leftConnector.width - speechArrow.width;
				speechArrow.y = text.y + (text.height / 2) - (speechArrow.height / 2);
				speechArrow.z = Registry.UI_Z_LEVEL_ELEMENTS;
				tBox.add(speechArrow);
				
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