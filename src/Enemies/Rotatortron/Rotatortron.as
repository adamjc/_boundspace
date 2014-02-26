package Enemies.Rotatortron 
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Rotatortron extends Enemy 
	{
		[Embed (source = "../../../assets/rotatortron.png")] protected var rotatortronSprite:Class;		
		protected const HEALTH:int = 10;
		protected const WEAPON_COOLDOWN:Number = 5;
		protected const WIDTH:int = 27;
		protected const BULLET_DAMAGE:Number = 1;
		protected const BULLET_SPEED:Number = 100;

		protected var bulletImage:FlxSprite;
		protected var weapon1:FlxWeapon;				
		
		public function Rotatortron(_ai:Boolean = true, _x:Number = 0, _y:Number = 0) 
		{		
			if (!_x) { _x = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random(); }
			if (!_y) { _y = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS; }
			super(_x, _y, WEAPON_COOLDOWN);			
			
			armour = HEALTH;			
			
			// used for weapons!
			image = loadGraphic(rotatortronSprite);							
			
			weapons = new Array();				
			
			this.xOffsetWeapon = this.x + (this.width / 2) - 3;
			this.yOffsetWeapon = this.y + (this.width / 2) - 3;
			
			for (var i:int = 0; i < 4; i++)
			{
				addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE, "xOffsetWeapon", "yOffsetWeapon");
				Registry.game.enemyProjectiles.add(weapons[i].group);
			}
			
			var graphic:FlxSprite = loadGraphic(rotatortronSprite);		
			
			if (_ai)
			{
				var self:Rotatortron = this;
				startTelprot(this, function():void {
					self.ai = new RotatortronAI(self);
					glitch.stop();
					//glitch.destroy();
					scratch.kill();					
				});
			}			
		}	
		
		public override function update():void
		{
			this.xOffsetWeapon = this.x + (this.width / 2) - 3;
			this.yOffsetWeapon = this.y + (this.width / 2) - 3;
			
			super.update();
		}
	}
}