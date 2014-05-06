package Enemies.Spike
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.FlxG;	
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Spike extends Enemy
	{
		[Embed(source="../../../assets/units/spikey.png")] protected var spikeySprite:Class;
		protected const HEALTH:int = 10;
		protected const WEAPON_COOLDOWN:Number = 5;
		protected const WIDTH:int = 27;
		protected const BULLET_DAMAGE:Number = 1;
		protected const BULLET_SPEED:Number = 100;
		
		protected var bulletImage:FlxSprite;
		protected var weapon1:FlxWeapon;
		
		protected var previousVelocity:FlxPoint;
		protected var maxSpeed:int = 1;
		protected var maxTurn:Number = 0.5;
		protected var damage:int = 10;
		
		public function Spike(_ai:Boolean = false, _x:Number = 0, _y:Number = 0)
		{
			if (!_x) _x = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random();
			if (!_y) _y = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS;

			super(_x, _y, WEAPON_COOLDOWN);
			
			this.z = Registry.ENEMY_Z_LEVEL;
					
			armour = HEALTH;						
			
			this.drag.x = 0;
			this.drag.y = 0;
			
			// used for weapons!
			image = loadGraphic(spikeySprite);
			var graphic:FlxSprite = loadGraphic(spikeySprite);
			//image = graphic;			
			
			//weapons = new Array();				
			
			//this.xOffsetWeapon = this.x + (this.width / 2) - 3;
			//this.yOffsetWeapon = this.y + (this.width / 2) - 3;
			
			//for (var i:int = 0; i < 4; i++)
			//{
			//	addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE, "xOffsetWeapon", "yOffsetWeapon");
			//	Registry.game.enemyProjectiles.add(weapons[i].group);
			//}
					
			if (_ai)
			{
				var self:Spike = this;
				startTelprot(this, function():void {
					//self.ai = new BrainAI(self);

					glitch.stop();
					//glitch.destroy();
					scratch.kill();					
				});
			}
		}
		
		protected var baseVelocity:int = 100;
		public override function update():void
		{			
			super.update();						
			
			var _playerX:int = int(Registry.player.x);
			var _playerY:int = int(Registry.player.y);
			
			if (_playerX <= int(this.x + this.width / 2) && _playerX > int(this.x - this.width / 2)) {
				this.velocity.x = 0;
				if (int(Registry.player.y) >= int(this.y)) this.velocity.y = baseVelocity;
				else this.velocity.y = -baseVelocity;
			}
			else if (_playerY <= int(this.y + this.height / 2) && _playerY > int(this.y - this.height / 2)) {
				this.velocity.y = 0;
				if (int(Registry.player.x) >= int(this.x)) this.velocity.x = baseVelocity;
				else this.velocity.x = -baseVelocity;
			}
			
			
		}
	}
}