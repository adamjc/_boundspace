package Enemies.MoonBoss 
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MoonBoss extends Boss 
	{
		[Embed(source="../../../assets/units/moon-boss.png")] protected var unitSprite:Class;		
		protected const HEALTH:int = 10;
		protected const WEAPON_COOLDOWN:Number = 2;
		protected const WIDTH:int = 7;
		protected const BULLET_DAMAGE:Number = 1;
		protected const BULLET_SPEED:Number = 100;

		protected var bulletImage:FlxSprite;
		protected var weapon1:FlxWeapon;		
		
		public function MoonBoss(_ai:Boolean = true, xArg:Number = 350, yArg:Number = 200) 
		{		
			super(xArg, yArg, WEAPON_COOLDOWN);
			
			armour = HEALTH;
			
			var graphic:FlxSprite = loadGraphic(unitSprite, true, false, 54, 46);
			
			image = graphic;
			image.frame = 2;
			
			xOffsetWeapon = this.x + this.width / 2;
			yOffsetWeapon = this.y + this.height / 2;
			
			weapons = new Array();	
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE, "xOffsetWeapon", "yOffsetWeapon");
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE, "xOffsetWeapon", "yOffsetWeapon");
			addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE, "xOffsetWeapon", "yOffsetWeapon");
			Registry.game.enemyProjectiles.add(weapons[0].group);
			Registry.game.enemyProjectiles.add(weapons[1].group);
			Registry.game.enemyProjectiles.add(weapons[2].group);
			
			if (_ai)
			{
				var self:MoonBoss = this;
				startTelprot(this, function():void {
					self.ai = new MoonBossAI(self);
				});
			}			
		}
		
		public override function update():void
		{
			xOffsetWeapon = this.x + this.width / 2;
			yOffsetWeapon = this.y + this.height / 2;
			
			super.update();
		}
		
	}

}