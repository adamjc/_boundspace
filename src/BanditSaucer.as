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
		protected const WEAPON_COOLDOWN:Number = 2;
		protected const WIDTH:int = 7;
		protected const BULLET_DAMAGE:Number = 1;
		protected const BULLET_SPEED:Number = 100;

		protected var bulletImage:FlxSprite;
		protected var weapon1:FlxWeapon;
		
		public function BanditSaucer(_ai:Boolean = true, _x:Number = 0, _y:Number = 0) 
		{
			if (!_x) { _x = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random(); }
			if (!_y) { _y = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS; }
			super(_x, _y, WEAPON_COOLDOWN);			
			
			armour = HEALTH;			
			
			// used for weapons!
			image = loadGraphic(banditSprite);							
			
			weapons = new Array();	
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE);
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE);
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE);
			Registry.game.enemyProjectiles.add(weapons[0].group);
			Registry.game.enemyProjectiles.add(weapons[1].group);
			Registry.game.enemyProjectiles.add(weapons[2].group);
			
			
			
			var graphic:FlxSprite = loadGraphic(banditSprite, true, false, 44, 31);
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
			
			//if (_ai) { ai = new BanditSaucerAI(this); }
			
			if (_ai)
			{
				var self:BanditSaucer = this;
				startTelprot(this, function():void {
					self.ai = new BanditSaucerAI(self);
				});
			}
			
			addAnimation("banditSprite", array, 60, true);
			this.play("banditSprite");
		}
		
		override public function update():void
		{	
			super.update();			
		}
	}
}