package StartScreen 
{
	import CreditsScreen.CreditsScreen;
	import flash.utils.setTimeout;
	import OptionsScreen.Options;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import AchievementsPackage.AchievementsScreen;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class MenuButton extends FlxObject
	{		
		public static const WIDTH:int = 150;
		public static const HEIGHT:int = 50;
		
		protected var buttonText:FlxText;
		protected var trigger:String;
		
		protected var buttonImage:FlxSprite;
				
		[Embed(source = "../../assets/Kroeger0553.ttf", fontName = "DefaultFont", embedAsCFF="false")] private var FontClass:Class;
		
		public function MenuButton(text:String, x:int, y:int, trigger:String = null) 
		{
			this.x = x;
			this.y = y;
			buttonText = new FlxText(x, y, WIDTH, text);
			buttonText.setFormat("DefaultFont", 16, FlxG.WHITE, "center");
			if (trigger) { this.trigger = trigger; }
			buttonText.alpha = 0.5;
		}
		
		public function getButton():FlxText
		{
			return buttonText;
		}				
		
		public function getButtonImage():FlxSprite
		{
			return buttonImage;
		}
		
		public function setButtonImage(b:FlxSprite):void
		{
			buttonImage = b;
		}
		
		public function getTrigger():String
		{
			return trigger;
		}
		
		public function startGame(state:FlxState):void
		{
			Menu._menuMusic.kill();
			
			FlxSpecialFX.clear();

			FlxG.fade();
			
			setTimeout(function():void {
				var p:PlayState = new PlayState();
				FlxG.switchState(p);			
			}, 1000);			
		}
		
		public function optionsMenu(state:Menu):void
		{
			var o:Options = new Options();
			state.add(o.optionsGroup);
			state.menuIndex = state.OPTIONS_MENU_INDEX;
			state.hideMainMenu();
			state.optionsScreen = o;
		}
		
		public function creditsSequence(state:Menu):void
		{
			var c:CreditsScreen.CreditsScreen = new CreditsScreen.CreditsScreen();			
			c.add(state);
			state.add(c);
			state.menuIndex = state.CREDITS_MENU_INDEX;
			state.hideMainMenu();
			state.creditsScreen = c;
			
		}
		
		public function achievementsMenu(state:Menu):void
		{
			var a:AchievementsScreen = new AchievementsScreen();
			state.add(a.achievementsGroup);
			state.menuIndex = state.ACHIEVEMENTS_MENU_INDEX;
			state.hideMainMenu();
			state.achievementsScreen = a;
		}
		
		/**
		 * Adds this objects elements to the playstate.
		 * @param	playState
		 */
		public function add(playState:FlxState):void
		{		
			playState.add(this);
			if (buttonImage) { playState.add(buttonImage); }
			playState.add(buttonText);			
		}
		
		override public function update():void
		{
			super.update();
			
			buttonText.x = this.x;
			buttonText.y = this.y;
		}
		
		override public function kill():void
		{
			buttonText.kill();
			if (buttonImage) { buttonImage.kill(); }
			super.kill();
		}
	}
}