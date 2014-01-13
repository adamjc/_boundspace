package StartScreen
{
	import AchievementsPackage.AchievementsScreen;
	import com.greensock.loading.data.DataLoaderVars;
	import CreditsScreen.CreditsScreen;
	import EmitterXL.EmitterXL;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import OptionsScreen.Options;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	import flash.ui.Mouse;
	import flash.utils.getQualifiedClassName;
	import com.greensock.TweenMax;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import com.greensock.easing.*;
	import com.greensock.*;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class Menu extends FlxState 
	{			
		
		public var menuIndex:int = 0;
		public const MAIN_MENU_INDEX:int = 0;
		public const OPTIONS_MENU_INDEX:int = 1;
		public const ACHIEVEMENTS_MENU_INDEX:int = 2;
		public const CREDITS_MENU_INDEX:int = 3;
		
		protected var menuArray:Array;
		
		public var achievementsScreen:AchievementsScreen;
		public var optionsScreen:Options;
		public var creditsScreen:CreditsScreen;
		
		protected var baseX:int = -100; // The "start" x value of the buttons, all of the other x positions are relatively calculated.
		protected var xButtonSpacing:int; // The x spacing between the buttons.		
		protected const BASE_Y:int = 350;
		protected const NUMBER_OF_BUTTONS_ON_SCREEN:int = 3;
		protected const BUTTON_MOVE_DURATION:int = 1;		
		
		protected var buttonArray:Array;
		protected var buttonPositions:Array; // This is used for when tweening the buttons.
		
		protected var buttonsBackground:FlxSprite;
		
		protected var emitter:EmitterXL.EmitterXL;
		
		protected var logo:FlxSprite;
		[Embed(source = "../../assets/temp-logo.png")] protected var logoGraphic:Class;
		protected var logoTimer:Number;
		protected var initialLogoTimer:Number;
		
		public function Menu() 
		{						
			
			
			loadButtons();							
			
			menuArray = [mainMenuUpdate, optionsMenuUpdate, achievementsMenuUpdate, creditsScreenUpdate];
			
			// Particle stuff
			emitter = new EmitterXL(0, 0, 100, {"fadeOut": true});
			emitter.setSize(BoundSpace.SceneWidth, 1);			
			emitter.setYSpeed(10, 100);
			emitter.setXSpeed(0, 0);
			
			for (var i:int = 0; i < 100; i++)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(4, 4, 0xFFFFFFFF);
				particle.exists = false;
				particle.z = 1;
				emitter.add(particle);
				emitter.minRotation = 0;
				emitter.maxRotation = 0;
				emitter.z = 1;
			}							
			
			this.add(emitter);
			this.add(emitter.blurEffect);
			emitter.start(false, 10, 0.5, 0);			
			emitter.blurry.start(2);
		}
		
		protected var _flashed:Boolean;
		protected function updateTween(tween)
		{
			if (!_flashed && tween.totalProgress() >= 0.35)
			{
				FlxG.flash();
				_flashed = true;
			}
		}
		
		protected function loadButtons():void
		{
			/*buttonsBackground = new FlxSprite(0, BASE_Y - 13, null, 0);
			buttonsBackground.makeGraphic(BoundSpace.SceneWidth, 50);
			buttonsBackground.alpha = 0.25;
			add(buttonsBackground);*/
			
			// Logo stuff
			logo = new FlxSprite(0, 0, logoGraphic, 0);
			logo.scaleX = 0;
			logo.scaleY = 0;
			logo.x = (BoundSpace.SceneWidth / 2) - (logo.width / 2);
			//logo.x = BoundSpace.SceneWidth / 2;
			var maxWidth:Number = logo.width;
			var maxHeight:Number = logo.height;
			logo.scale = new FlxPoint(0, 0);
			logo.y = 20;			
			logo.z = 1000;			
			add(logo);
			initialLogoTimer = 0;
			
			TweenMax.to(logo, 1, {	x: (BoundSpace.SceneWidth / 2) - (logo.width / 2),
									scaleX:1, 
									scaleY: 1, 
									ease: Bounce.easeOut,
									onUpdate: updateTween,
									onUpdateParams:["{self}"]
								 }
			);
			
			var xml:XML = 
				<buttons>
					<button>
						<title>OPTIONS</title>
						<trigger>optionsMenu</trigger>
					</button>
					<button>
						<title>START</title>
						<trigger>startGame</trigger>
					</button>
					<button>
						<title>ACHIEVEMENTS</title>
						<trigger>achievementsMenu</trigger>
					</button>
					<button>
						<title>CREDITS</title>
						<trigger>creditsSequence</trigger>
					</button>
				</buttons>;
			
			var xmlList:XMLList = xml.*;			
			
			buttonArray = new Array();
			buttonPositions = new Array();
			var button:MenuButton;			
						
			// Find the baseX.
			var halfButtonWidth:int = MenuButton.WIDTH / 2;
			baseX = -halfButtonWidth;
			
			// Calculate the spacing between the buttons.			
			// There will be a maximum of NUMBER_OF_BUTTONS_ON_SCREEN.			
			var totalButtonWidth:int = (NUMBER_OF_BUTTONS_ON_SCREEN - 1) * MenuButton.WIDTH;
			var screenWidthLeft:int = BoundSpace.SceneWidth - totalButtonWidth;
			
			xButtonSpacing = (screenWidthLeft / (NUMBER_OF_BUTTONS_ON_SCREEN - 1)) + MenuButton.WIDTH;												
			
			var i:int;
			for (i = 0; i < xmlList.length(); i++)
			{
				var buttonX:int = baseX + (i * xButtonSpacing);				
				button = new MenuButton(xmlList.title[i], buttonX, BASE_Y, xmlList.trigger[i]);
				buttonArray.push(button);
				
				if (i < NUMBER_OF_BUTTONS_ON_SCREEN) { buttonPositions.push(new FlxPoint(buttonX, BASE_Y)); }				
			}
			
			for (i = 0; i < buttonArray.length; i++)
			{
				buttonArray[i].add(this);
			}
		}
		
		
		override public function update():void
		{
			super.update();
			
			// Find out which 'menu' we are in.
			menuArray[menuIndex]();			
			
			if (initialLogoTimer + FlxG.elapsed <= logoTimer)
			{
				var newScale:FlxPoint = new FlxPoint(0.1 + logo.scale.x, 0.1 + logo.scale.y);
				logo.scale = newScale;
				initialLogoTimer += FlxG.elapsed;
			}
			else
			{
				initialLogoTimer += FlxG.elapsed;
			}
			
			Mouse.show();
		}
		
		/**
		 * Essentially the 'update' function. Runs when we are in main menu.
		 */
		protected function mainMenuUpdate():void
		{
			var tempButton:MenuButton;
			var i:int;
			
			if (FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D")) // Move the carousel right.
			{
				// tween all of the elements.
				for (i = 0; i < buttonArray.length; i++)
				{
					if (i < NUMBER_OF_BUTTONS_ON_SCREEN)
					{
						if ((i - 1) >= 0)
						{
							TweenMax.to(buttonArray[i], BUTTON_MOVE_DURATION, { x: buttonPositions[i - 1].x } );
						}
						else // We are tweening the first button, which does not have a location in buttonPositions[].
						{
							TweenMax.to(buttonArray[i], 
										0.1, 
										{ x: -MenuButton.WIDTH, 
										  onComplete: firstButtonTweenedLeft, 
										  onCompleteParams: [buttonArray] } 
							);
						}						
					}
				}
			}
			
			if (FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A")) // Move the carousel left.
			{
				// tween all of the elements.
				for (i = buttonArray.length - 1; i >= 0; i--)
				{
					if (i < NUMBER_OF_BUTTONS_ON_SCREEN)
					{
						if ((i + 1) < NUMBER_OF_BUTTONS_ON_SCREEN)
						{
							TweenMax.to(buttonArray[i], BUTTON_MOVE_DURATION, { x: buttonPositions[i + 1].x } );
						}
						else // We are tweening the last button, which does not have a location in buttonPositions[].
						{
							TweenMax.to(buttonArray[i], 
										0.1, 
										{ x: BoundSpace.SceneWidth + MenuButton.WIDTH,
										  onComplete: firstButtonTweenedRight, 
										  onCompleteParams: [buttonArray] } 
							);
						}						
					}
				}				
			}
			
			// Handle button selection.
			if (FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE"))
			{
				var b:MenuButton = buttonArray[1];
				
				// e.g. "startGame()", "creditsSequence()", "optionsMenu()", etc...
				var buttonsTriggerMethod:String = b.getTrigger();
				b[buttonsTriggerMethod](this);
			}
		}

		/**
		 * Hides the main menu buttons and shit.
		 */
		public function hideMainMenu():void
		{
			//buttonsBackground.kill();
			logo.kill();
			
			for each (var b:MenuButton in buttonArray)
			{
				b.kill();
			}
		}		
		
		/**
		 * Essentially the 'update' function. Runs when we are in achievements menu.
		 */		
		protected function achievementsMenuUpdate():void
		{			
			if (FlxG.keys.justPressed("ESCAPE"))
			{
				achievementsScreen.kill();
				menuIndex = MAIN_MENU_INDEX;
				loadButtons();
			}
			
			if (FlxG.keys.justPressed("ENTER") && achievementsScreen.selectionBarIndex == 2)
			{
				// Return to the main menu.
				achievementsScreen.kill();
				menuIndex = MAIN_MENU_INDEX;
				loadButtons();
			}
			
			achievementsScreen.handleUserInput();
		}
		
		/**
		 * Essentially the 'update' function. Runs when we are in options menu.
		 */		
		protected function optionsMenuUpdate():void
		{
			if (FlxG.keys.justPressed("ESCAPE"))
			{
				optionsScreen.kill();
				menuIndex = MAIN_MENU_INDEX;
				loadButtons();
			}
			
			if (FlxG.keys.justPressed("ENTER") && optionsScreen.selectionBarIndex == 3)
			{
				// Return to the main menu.
				optionsScreen.kill();
				menuIndex = MAIN_MENU_INDEX;
				loadButtons();
			}
			
			optionsScreen.handleUserInput();
		}
		
		/**
		 * Essentially the 'update' function. Runs when we are in credits menu.
		 */
		protected function creditsScreenUpdate():void
		{
			if (FlxG.keys.justPressed("ESCAPE"))
			{
				creditsScreen.kill();
				menuIndex = MAIN_MENU_INDEX;
				loadButtons();
			}
			
			if (creditsScreen.endOfCredits < 0)
			{
				creditsScreen.kill();
				menuIndex = MAIN_MENU_INDEX;
				loadButtons();
			}
		}
		
		protected function firstButtonTweenedRight(bArry:Array):void
		{
			if (bArry.length <= NUMBER_OF_BUTTONS_ON_SCREEN)
			{
				// If it is, we need to tween it into position.
				bArry[bArry.length - 1].x = -MenuButton.WIDTH * 2; 
				TweenMax.to(bArry[bArry.length - 1], BUTTON_MOVE_DURATION, { x: buttonPositions[0].x } );
			}
			else
			{
				TweenMax.to(bArry[NUMBER_OF_BUTTONS_ON_SCREEN], BUTTON_MOVE_DURATION, { x: buttonPositions[NUMBER_OF_BUTTONS_ON_SCREEN + 1] } );
				// We need to get the button a number of buttons on screen + 1 and add it to the screen and tween it.				
				bArry[bArry.length - 1].x = -MenuButton.WIDTH * 2; 
				TweenMax.to(bArry[bArry.length - 1], BUTTON_MOVE_DURATION, { x: buttonPositions[0].x } );
			}
			
			// We will be overwriting buttonArray[length - 1].
			var tempButton:MenuButton = buttonArray[buttonArray.length - 1];
			var i:int;
							
			// move all of the elements down 1.
			for (i = buttonArray.length - 1; i >= 0; i--)
			{
				if (i < buttonArray.length - 1)
				{
					buttonArray[i + 1] = buttonArray[i];
				}
			}
			
			//add the element at [length - 1] to [0].
			buttonArray[0] = tempButton;				
		}
		
		protected function firstButtonTweenedLeft(bArry:Array):void
		{									
			if (bArry.length <= NUMBER_OF_BUTTONS_ON_SCREEN)
			{
				// If it is, we need to add this button again and tween it into position.
				bArry[0].x = BoundSpace.SceneWidth + MenuButton.WIDTH * 2; 
				TweenMax.to(bArry[0], BUTTON_MOVE_DURATION, { x: buttonPositions[bArry.length - 1].x } );
			}
			else
			{
				TweenMax.to(bArry[0], BUTTON_MOVE_DURATION, { x: -200 } );
				// We need to get the button a number of buttons on screen + 1 and add it to the screen and tween it.				
				bArry[NUMBER_OF_BUTTONS_ON_SCREEN].x = BoundSpace.SceneWidth + MenuButton.WIDTH * 2; 
				TweenMax.to(bArry[NUMBER_OF_BUTTONS_ON_SCREEN], BUTTON_MOVE_DURATION, { x: buttonPositions[NUMBER_OF_BUTTONS_ON_SCREEN - 1].x } );
			}
			
			// We will be overwriting buttonArray[0].
			var tempButton:MenuButton = buttonArray[0];
			var i:int;
			
			for (i = 0; i < buttonArray.length; i++)
			{
				if (i > 0)
				{
					buttonArray[i - 1] = buttonArray[i];
				}
			}
							
			//add the element at [0] to [length - 1].
			buttonArray[buttonArray.length - 1] = tempButton;
		}
	}
}