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
		protected const HEALTH:int = 50;
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
			super.update();
		}
		
	}

}