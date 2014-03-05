package AchievementsPackage
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxText;
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class AchievementsScreen extends FlxObject 
	{				
		public const NO_OF_ELEMENTS:int = 3;
		public const STARTING_Y:int = 0;
		public const STARTING_X:int = 0;
		
		protected var elementHeight:Number;
		protected var elementPosArray:Array;
		
		/* Selection bar vars. */
		protected var selectionBar:FlxSprite;
		public var selectionBarIndex:int;
		
		/* Title vars. */
		protected var title:FlxText;		
		
		/* The group of all the elements in the achievements menu */
		public var achievementsGroup:FlxGroup;
		
		protected var baseX:int = -200; // The "start" x value of the buttons, all of the other x positions are relatively calculated.
		protected var xAchievementSpacing:int; // The x spacing between the buttons.		
		protected const BASE_Y:int = 240;
		protected const NUMBER_OF_BUTTONS_ON_SCREEN:int = 3;
		protected const BUTTON_MOVE_DURATION:int = 1;
		
		public var achievementArray:Array;
		public var achievementPositions:Array;
		
		/* Sounds */
		[Embed(source = "../../assets/sounds/menu-select.mp3")] public var menuSelect:Class;
		[Embed(source= "../../assets/sounds/menu-enter.mp3")] public var menuEnter:Class;
		
		// Constructor that creates an object representing all of the elements of an achievements screen.
		// Also handles all of the updating of it's children.
		public function AchievementsScreen() 
		{
			achievementsGroup = new FlxGroup();
			// Split up the screen into  3 segments (Title, Achievements, Done)
			
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
			
			// Create the title ("Options").
			title = createTitle();
			achievementsGroup.add(title);
			
			// Create the 'done section.
			var doneText:FlxText = createDone();
			achievementsGroup.add(doneText);
			
			// Create the 'selection' section (the white bar that highlights which section you are choosing).
			selectionBar = createSelection();
			achievementsGroup.add(selectionBar);
			
			loadButtons();
		}		
		
		protected function loadButtons():void
		{			
			var xml:XML = 
				<achievements>
					<achievement>
						<title>UNBOUND</title>						
						<desc>Get all of the achievements</desc>
						<image>10</image>
						<bit>1</bit>
					</achievement>
					<achievement>
						<title>UNTOUCHABLE</title>						
						<desc>Kill a boss without taking any damage</desc>
						<image>0</image>
						<bit>2</bit>
					</achievement>
					<achievement>
						<title>BUILT LIKE A TANK</title>
						<desc>Get the maximum health possible</desc>
						<image>1</image>
						<bit>4</bit>
					</achievement>
					<achievement>
						<title>FIVE FINGER DISCOUNT</title>
						<desc>Kill a shopkeeper</desc>
						<image>2</image>
						<bit>8</bit>
					</achievement>
					<achievement>
						<title>NO LIFER</title>
						<desc>Complete the game five times</desc>
						<image>3</image>
						<bit>16</bit>
					</achievement>
					<achievement>
						<title>SEEING THE CODE</title>
						<desc>Complete Stage 5 with no damage taken</desc>
						<image>5</image>
						<bit>32</bit>
					</achievement>
					<achievement>
						<title>A GOOD START</title>
						<desc>Complete Stage 1 with no damage taken</desc>
						<image>6</image>
						<bit>64</bit>
					</achievement>
					<achievement>
						<title>HOARDER</title>
						<desc>Hold the maximum number of credits possible</desc>
						<image>7</image>
						<bit>128</bit>
					</achievement>
					<achievement>
						<title>GLUTTON FOR PUNISHMENT</title>
						<desc>Die 100 times</desc>
						<image>8</image>
						<bit>256</bit>
					</achievement>
					<achievement>
						<title>CAPTAIN FANTASTIC</title>
						<desc>Complete the game once</desc>
						<image>9</image>
						<bit>512</bit>
					</achievement>					
				</achievements>;				
				
			var xmlList:XMLList = xml.*;			
			
			achievementArray = new Array();
			achievementPositions = new Array();
			var achievement:MenuAchievement;			
						 
			// Find the baseX.
			//var halfAchievementWidth:int = MenuAchievement.WIDTH / 2;
			//baseX = -halfAchievementWidth;
			
			// Calculate the spacing between the buttons.			
			// There will be a maximum of NUMBER_OF_BUTTONS_ON_SCREEN.			
			var totalAchievementWidth:int = (NUMBER_OF_BUTTONS_ON_SCREEN - 1) * MenuAchievement.WIDTH;
			var screenWidthLeft:int = BoundSpace.SceneWidth - totalAchievementWidth;
			
			xAchievementSpacing = (screenWidthLeft / (NUMBER_OF_BUTTONS_ON_SCREEN - 1)) + MenuAchievement.WIDTH + 100;												
			
			var i:int;
			for (i = 0; i < xmlList.length(); i++)
			{
				var achievementX:int = baseX + (i * xAchievementSpacing);	
				var title:String = "LOCKED";
				var text:String = "...";
				if (Achievements.achievements & xmlList.bit[i]) { title = xmlList.title[i]; text = xmlList.desc[i]; }
				achievement = new MenuAchievement(xmlList.image[i], title, text, achievementX, BASE_Y);
				achievementArray.push(achievement);
				
				if (i < NUMBER_OF_BUTTONS_ON_SCREEN) { achievementPositions.push(new FlxPoint(achievementX, BASE_Y)); }				
			}
			
			for (i = 0; i < achievementArray.length; i++)
			{
				//achievementArray[i].add(this);
				
				achievementsGroup.add(achievementArray[i].achievementsGroup);
				achievementsGroup.add(achievementArray[i]);
			}
		}	
		
		protected function firstButtonTweenedRight(bArry:Array):void
		{
			if (bArry.length <= NUMBER_OF_BUTTONS_ON_SCREEN)
			{
				// If it is, we need to tween it into position.
				bArry[bArry.length - 1].x = -MenuAchievement.WIDTH * 2; 
				TweenMax.to(bArry[bArry.length - 1], BUTTON_MOVE_DURATION, { x: achievementPositions[0].x } );
			}
			else
			{				
				TweenMax.to(bArry[NUMBER_OF_BUTTONS_ON_SCREEN], BUTTON_MOVE_DURATION, { x: achievementPositions[NUMBER_OF_BUTTONS_ON_SCREEN + 1] } );
				// We need to get the button a number of buttons on screen + 1 and add it to the screen and tween it.				
				bArry[bArry.length - 1].x = -MenuAchievement.WIDTH * 2; 
				TweenMax.to(bArry[bArry.length - 1], BUTTON_MOVE_DURATION, { x: achievementPositions[0].x } );
			}
			
			// We will be overwriting buttonArray[length - 1].
			var tempAchievement:MenuAchievement = achievementArray[achievementArray.length - 1];
			var i:int;
							
			// move all of the elements down 1.
			for (i = achievementArray.length - 1; i >= 0; i--)
			{
				if (i < achievementArray.length - 1)
				{
					achievementArray[i + 1] = achievementArray[i];
				}
			}
			
			//add the element at [length - 1] to [0].
			achievementArray[0] = tempAchievement;				
		}
		
		protected function firstButtonTweenedLeft(bArry:Array):void
		{									
			if (bArry.length <= NUMBER_OF_BUTTONS_ON_SCREEN)
			{
				// If it is, we need to add this button again and tween it into position.
				bArry[0].x = BoundSpace.SceneWidth + MenuAchievement.WIDTH * 2; 
				TweenMax.to(bArry[0], BUTTON_MOVE_DURATION, { x: achievementPositions[bArry.length - 1].x } );
			}
			else
			{
				TweenMax.to(bArry[0], BUTTON_MOVE_DURATION, { x: -600 } );
				// We need to get the button a number of buttons on screen + 1 and add it to the screen and tween it.				
				bArry[NUMBER_OF_BUTTONS_ON_SCREEN].x = BoundSpace.SceneWidth + MenuAchievement.WIDTH * 2; 
				TweenMax.to(bArry[NUMBER_OF_BUTTONS_ON_SCREEN], BUTTON_MOVE_DURATION, { x: achievementPositions[NUMBER_OF_BUTTONS_ON_SCREEN - 1].x } );
			}
			
			// We will be overwriting buttonArray[0].
			var tempAchievement:MenuAchievement = achievementArray[0];
			var i:int;
			
			for (i = 0; i < achievementArray.length; i++)
			{
				if (i > 0)
				{
					achievementArray[i - 1] = achievementArray[i];
				}
			}
							
			// Add the element at [0] to [length - 1].
			achievementArray[achievementArray.length - 1] = tempAchievement;
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
		
		public function handleUserInput():void
		{								
			var selectionBarPos:FlxPoint;
			if ((selectionBarIndex > 1) && (FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("W")))
			{
				FlxG.play(menuSelect);
				
				// Move the selection bar up.
				selectionBarIndex -= 1;
				selectionBarPos = elementPosArray[selectionBarIndex];
				TweenMax.to(selectionBar, 0.2, { y: selectionBarPos.y } );
			}
			
			if ((selectionBarIndex < elementPosArray.length - 1) && (FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("S")))
			{
				FlxG.play(menuSelect);
				
				// Move the selection bar down.
				selectionBarIndex += 1;
				selectionBarPos = elementPosArray[selectionBarIndex];
				TweenMax.to(selectionBar, 0.2, { y: selectionBarPos.y } );
			}		
			
			var i:int;
			if (FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D")) // Move the carousel right.
			{
				FlxG.play(menuSelect);
				
				// tween all of the elements. 
				for (i = 0; i < achievementArray.length; i++)
				{					
					if (i < NUMBER_OF_BUTTONS_ON_SCREEN)
					{
						if ((i - 1) >= 0)
						{	
							TweenMax.to(achievementArray[i], BUTTON_MOVE_DURATION, { x: achievementPositions[i - 1].x } );							
						}
						else // We are tweening the first button, which does not have a location in buttonPositions[].
						{
							TweenMax.to(achievementArray[i], 
										0.1, 
										{ x: -MenuAchievement.WIDTH, 
										  onComplete: firstButtonTweenedLeft, 
										  onCompleteParams: [achievementArray] } 
							);
						}						
					}
				}
			}
			
			if (FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A")) // Move the carousel left.
			{
				FlxG.play(menuSelect);
				
				// tween all of the elements.
				for (i = achievementArray.length - 1; i >= 0; i--)
				{
					if (i < NUMBER_OF_BUTTONS_ON_SCREEN)
					{
						if ((i + 1) < NUMBER_OF_BUTTONS_ON_SCREEN)
						{
							TweenMax.to(achievementArray[i], BUTTON_MOVE_DURATION, { x: achievementPositions[i + 1].x } );
						}
						else // We are tweening the last button, which does not have a location in buttonPositions[].
						{
							TweenMax.to(achievementArray[i], 
										0.1, 
										{ x: BoundSpace.SceneWidth + MenuAchievement.WIDTH,
										  onComplete: firstButtonTweenedRight, 
										  onCompleteParams: [achievementArray] } 
							);
						}						
					}
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
			title.text = "ACHIEVEMENTS";
			return title;
		}
		
		public function createDone():FlxText
		{
			// Find the centre of the section.
			var width:int = BoundSpace.SceneWidth;
						
			// Create the text			
			var done:FlxText = new FlxText(elementPosArray[2].x, elementPosArray[2].y + 55, width);
			done.setFormat("DefaultFont", 24, 0xFFFFFFF, "center");
			done.text = "DONE";
			return done;
		}
		
		override public function kill():void
		{
			achievementsGroup.kill();
			super.kill();
		}
	}
}