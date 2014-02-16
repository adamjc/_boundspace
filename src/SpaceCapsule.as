package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxWeapon;

	/**
	 * ...
	 * @author Adam
	 */
	public class SpaceCapsule extends Enemy 
	{		
		protected const HEALTH:Number = 10;	
		protected const WIDTH:Number = 5;
		protected const WEAPON_COOLDOWN:Number = 1 + (0.5 * Math.random());
		protected const BULLET_DAMAGE:Number = 1;
		protected const BULLET_SPEED:Number = 50;
		
		private var bulletImage:FlxSprite;		
		
		[Embed(source = "../assets/spacecapsule.png")] public var capsuleImg:Class;
//		[Embed(source = "../assets/saucer_hit.png")] public var capsuleHit:Class;		
		
		public function SpaceCapsule(_ai:Boolean = true) 
		{
			var _x:Number = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random();
			var _y:Number = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS;
			super(_x, _y, WEAPON_COOLDOWN);
			
			// used for weapons!
			image = loadGraphic(capsuleImg);							
			armour = HEALTH;
			
			weapons = new Array();	
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE);
			Registry.game.enemyProjectiles.add(weapons[0].group);
						
			if (_ai) { ai = new SaucerAI(this); }
		}
		
		override public function update():void
		{		
			super.update();			
		}
	}
}