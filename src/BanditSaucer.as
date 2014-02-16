package  
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BanditSaucer extends MiniBoss 
	{		
		[Embed (source = "../assets/bandit-saucer.png")] protected var banditSprite:Class;		
		protected const HEALTH:int = 10;
		protected const WEAPON_COOLDOWN:Number = 1 + (0.5 * Math.random());
		protected const WIDTH:int = 7;
		protected const BULLET_DAMAGE:Number = 1;
		protected const BULLET_SPEED:Number = 50;

		protected var bulletImage:FlxSprite;
		protected var weapon1:FlxWeapon;
		
		public function BanditSaucer(_ai:Boolean = true) 
		{
			var _x:Number = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random();
			var _y:Number = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS;
			super(_x, _y, WEAPON_COOLDOWN);			
			
			armour = HEALTH;			
			
			// used for weapons!
			image = loadGraphic(banditSprite);							
			
			weapons = new Array();	
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE);
			Registry.game.enemyProjectiles.add(weapons[0].group);
			
			var graphic:FlxSprite = loadGraphic(banditSprite, true, false, 44, 31);
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
			
			if (_ai) { ai = new SaucerAI(this); }
			
			addAnimation("banditSprite", array, 60, true);
			this.play("banditSprite");
		}
		
		override public function update():void
		{	
			super.update();			
		}
	}
}