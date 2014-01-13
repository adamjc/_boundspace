package AchievementsPackage 
{
	import flash.display.BitmapData;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class MenuAchievement extends FlxObject 
	{		
		public static const WIDTH:int = 350;
		public static const HEIGHT:int = 300;
		public static const SCALE:int = 2;
		
		public var achievementTitle:FlxText;
		protected var achievementTitleXOffset:int = 120;
		protected var achievementTitleYOffset:int = 10;
		
		protected var achievementText:FlxText;
		protected var achievementTextXOffset:int = achievementTitleXOffset;
		protected var achievementTextYOffset:int = achievementTitleYOffset + 30;
		
		protected var achievementImage:FlxSprite;
		protected var achievementImageXOffset:int = 0;
		protected var achievementImageYOffset:int = 10;
			
		public var achievementsGroup:FlxGroup;
		// TODO: Here we embed all of our achievement images.		
		
		// TODO: Here we add the embedded images to the array. The constructor will pick out the image from the index.
		//protected static const achievementImages:Array;
		
		public function MenuAchievement(achievementImgLoc:int, achievementTitleText:String, achievementTextText:String, xPos:int, yPos:int) 
		{
				x = xPos;
				y = yPos;
				achievementTitle = new FlxText(x + achievementTitleXOffset, y + achievementTitleYOffset, 300, achievementTitleText);
				achievementTitle.setFormat(null, 16);
				achievementText = new FlxText(x + achievementTextXOffset, y + achievementTextYOffset, 300, achievementTextText);				
				achievementText.setFormat(null, 16);
				achievementImage = new FlxSprite(x + achievementImageXOffset, y + achievementImageYOffset);
				achievementImage.pixels = new BitmapData(100, 100, false, 0xFFFFFFFF);
				
				if (achievementTitleText == "LOCKED")
				{
					achievementTitle.alpha = 0.5;
					achievementText.alpha = 0.5;
					achievementImage.alpha = 0.5;
				}
				
				// TODO: give the achievement an image.
				
				achievementsGroup = new FlxGroup();
				achievementsGroup.add(achievementTitle);
				achievementsGroup.add(achievementText);
				achievementsGroup.add(achievementImage);
		}
		
		/**
		 * Adds this objects elements to the playstate.
		 * @param	playState
		 */
		public function add(playState:FlxState):void
		{		
			playState.add(achievementsGroup);
		}		
		
		override public function update():void
		{
			super.update();
			
			achievementTitle.x = x + achievementTitleXOffset;
			achievementText.x = x + achievementTextXOffset;
			achievementImage.x = x + achievementImageXOffset;
		}		
		
	}
}