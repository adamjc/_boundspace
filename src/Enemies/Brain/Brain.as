package Enemies.Brain 
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Brain extends Enemy 
	{
		[Embed (source = "../../../assets/units/brain.png")] protected var brainSprite:Class;		
		protected const HEALTH:int = 10;
		protected const WEAPON_COOLDOWN:Number = 5;
		protected const WIDTH:int = 27;
		protected const BULLET_DAMAGE:Number = 1;
		protected const BULLET_SPEED:Number = 100;

		protected var bulletImage:FlxSprite;
		protected var weapon1:FlxWeapon;				
		
		public function Brain(_ai:Boolean = true, _x:Number = 0, _y:Number = 0) 
		{		
			if (!_x) { _x = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random(); }
			if (!_y) { _y = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS; }
			super(_x, _y, WEAPON_COOLDOWN);			
			
			armour = HEALTH;			
			
			// used for weapons!
			//image = loadGraphic(brainSprite);							
			
			//weapons = new Array();				
			
			//this.xOffsetWeapon = this.x + (this.width / 2) - 3;
			//this.yOffsetWeapon = this.y + (this.width / 2) - 3;
			
			//for (var i:int = 0; i < 4; i++)
			//{
			//	addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE, "xOffsetWeapon", "yOffsetWeapon");
			//	Registry.game.enemyProjectiles.add(weapons[i].group);
			//}
			
			var graphic:FlxSprite = loadGraphic(brainSprite, true, false, 42, 36);								
			
			image = graphic;
			image.frame = 2;
			
			if (_ai)
			{
				var self:Brain = this;
				startTelprot(this, function():void {
					self.ai = new BrainAI(self);

					glitch.stop();
					//glitch.destroy();
					scratch.kill();					
				});
			}			
		}	
		
		public override function update():void
		{
			//this.xOffsetWeapon = this.x + (this.width / 2) - 3;
			//this.yOffsetWeapon = this.y + (this.width / 2) - 3;
			
			super.update();
		}
	}
}