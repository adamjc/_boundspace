package OptionsScreen 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import com.greensock.TweenMax;
	import com.greensock.data.TweenMaxVars;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxBar;
	import StartScreen.Menu;
	import StartScreen.MenuButton;
	import flash.display.StageQuality;
	import org.flixel.FlxSound;
	
	/**
	 * FlxState that handles the options page. Allows the player to set the volume of the sound and the music and 
	 * the quality of the graphics.
	 * @author Adam
	 */
	public class Options extends FlxObject
	{
		public const NO_OF_ELEMENTS:int = 4;
		public const STARTING_Y:int = 0;
		public const STARTING_X:int = 0;
		
		protected var elementHeight:Number;
		protected var elementPosArray:Array;
		
		/* Selection bar vars. */
		protected var selectionBar:FlxSprite;
		public var selectionBarIndex:int;
		
		/* Title vars. */
		protected var title:FlxText;
		
		/* Sound FX Vars */
		protected var soundFXBar:FlxBar;
		
		/* Music Vars */
		protected var musicFXBar:FlxBar;
		
		public var optionsGroup:FlxGroup;
		
		[Embed(source = "../../assets/Kroeger0553.ttf", fontName = "DefaultFont", embedAsCFF="false")] private var FontClass:Class;
		
		public function Options() 
		{
			// Split the screen up into 5 segments (Title, SoundVolume, MusicVolume and Done).
			
			// Find the height of each element (they all have the same height).
			// Create an array that stores the starting X,Y of each of these 5 sections.
			elementHeight = BoundSpace.SceneHeight / NO_OF_ELEMENTS;
			
			elementPosArray = new Array();
			var tempPos:FlxPoint;
			for (var i:int; i < NO_OF_ELEMENTS; i++)
			{
				// The x value should remain the same, we're only moving downwards, if the menu was left-to-right then we would keep y static instead.
				tempPos = new FlxPoint(STARTING_X, STARTING_Y + (i * elementHeight))
				elementPosArray.push(tempPos);
			}
			
			optionsGroup = new FlxGroup();
			
			// Create the title ("Options").
			title = createTitle();
			optionsGroup.add(title);
			
			// Create the 'soundVolume' section.
			soundFXBar = createVolume("SOUND FX");
			
			// Create the 'musicVolume' section.
			musicFXBar = createVolume("MUSIC");
			
			// Create the 'done section.
			var doneText:FlxText = createDone();
			optionsGroup.add(doneText);
			
			// Create the 'selection' section (the white bar that highlights which section you are choosing).
			selectionBar = createSelection();
			optionsGroup.add(selectionBar);
		}	
		
		public function handleUserInput():void
		{			
			var selectionBarPos:FlxPoint;
			if ((selectionBarIndex > 1) && (FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("W")))
			{
				// Move the selection bar up.
				selectionBarIndex -= 1;
				selectionBarPos = elementPosArray[selectionBarIndex];
				TweenMax.to(selectionBar, 0.2, { y: selectionBarPos.y } );
			}
			
			if ((selectionBarIndex < elementPosArray.length - 1) && (FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("S")))
			{
				// Move the selection bar down.
				selectionBarIndex += 1;
				selectionBarPos = elementPosArray[selectionBarIndex];
				TweenMax.to(selectionBar, 0.2, { y: selectionBarPos.y } );
			}			
			
			if (FlxG.keys.justPressed("LEFT"))
			{	
				switch(selectionBarIndex)
				{					
					case 1:		
						// Sound fx highlighted.
						FlxG.volume -= 0.1;
						soundFXBar.percent = FlxG.volume * 100;
						break;						
					case 2:						
						// Music highlighted.
						FlxG.volume -= 0.1;
						musicFXBar.percent = FlxG.volume * 100;
						break;
					default:
						break;
				}
			}
			
			if (FlxG.keys.justPressed("RIGHT"))
			{
				switch(selectionBarIndex)
				{					
					case 1:		
						// Sound fx highlighted.
						FlxG.volume += 0.1;
						soundFXBar.percent = FlxG.volume * 100;
						break;						
					case 2:
						// Music highlighted.
						FlxG.volume += 0.1;
						musicFXBar.percent = FlxG.volume * 100;
						break;
					default:
						break;
				}
			}
		}
		
		public function createTitle():FlxText
		{
			// Find the centre of the section.
			var width:int = BoundSpace.SceneWidth;
			
			
			// Create the text			
			var title:FlxText = new FlxText(0, 40, width);
			title.setFormat("DefaultFont", 32, 0xFFFFFFF, "center");
			title.text = "OPTIONS";
			return title;
		}
				
		public function createVolume(type:String):FlxBar
		{
			var x:int;
			var y:int;
			if (type == "SOUND FX")
			{
				x = elementPosArray[1].x;
				y = elementPosArray[1].y;
			}
			else
			{
				x = elementPosArray[2].x;
				y = elementPosArray[2].y;
			}
			
			var volText:FlxText = new FlxText(x + 100, y + 60, 100, type);
			volText.setFormat("DefaultFont", 16);
			optionsGroup.add(volText);
			
			var volBar:FlxBar = new FlxBar(volText.x + 200, volText.y - 15, FlxBar.FILL_LEFT_TO_RIGHT, 300, 50, null, "", 0, 100, true);
			volBar.createFilledBar(0x00000000, 0xFFFFFFFF, true, 0xFFFFFFFF);
			volBar.percent = FlxG.volume * 100;
			optionsGroup.add(volBar);
			
			return volBar;
		}
		
		public function createDone():FlxText
		{
			// Find the centre of the section.
			var width:int = BoundSpace.SceneWidth;
						
			// Create the text			
			var done:FlxText = new FlxText(elementPosArray[3].x, elementPosArray[3].y + 55, width);
			done.setFormat("DefaultFont", 24, 0xFFFFFFF, "center");
			done.text = "DONE";
			return done;
		}
		
		public function createSelection():FlxSprite
		{			
			var pos:FlxPoint = elementPosArray[1];
			var sB:FlxSprite = new FlxSprite(pos.x, pos.y);
			sB.makeGraphic(BoundSpace.SceneWidth, elementHeight); 
			sB.alpha = 0.25;
			selectionBarIndex = 1;
			
			return sB;
		}
		
		override public function kill():void
		{
			optionsGroup.kill();
			super.kill();
		}
	}
}