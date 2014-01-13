package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class SpaceSaucer extends Enemy 
	{		
		protected const HEALTH:Number = 20;	
		protected const WEAPON_COOLDOWN:Number = 1 + (0.5 * Math.random());
		protected const BULLET_DAMAGE:Number = 1;
		protected const BULLET_SPEED:Number = 50;
		
		[Embed(source = "../assets/saucer.png")] public var saucerImg:Class;
		[Embed(source = "../assets/saucer_hit.png")] public var saucerHit:Class;		
		
		private var bulletImage:FlxSprite;
		
		public function SpaceSaucer(_ai:Boolean = true) 
		{	
			var f:FlxPoint = spawnFromOutside();
			
			super(f.x, f.y, WEAPON_COOLDOWN);

			image = loadGraphic(saucerImg);		
			enemyHitImage = new FlxSprite(0, 0, saucerHit, 2);
			enemyHitImage.visible = false;
			Registry.game.add(enemyHitImage);			
			armour = HEALTH;
			this.weapons = new Array();
			
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE);
			Registry.game.enemyProjectiles.add(weapons[0].group);
			
			//aiReady = _ai;			
		}

		override public function update():void
		{	
			if (aiReady) 
			{ 
				trace("hi from update");
				ai = new SaucerAI(this); 
				aiReady = false;
			}
			
			enemyHitImage.x = this.x;
			enemyHitImage.y = this.y;
			super.update();			
		}
	}
}