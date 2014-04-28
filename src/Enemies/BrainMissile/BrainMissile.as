package Enemies.BrainMissile
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
	public class BrainMissile extends Enemy
	{
		[Embed(source="../../../assets/units/brain-missile.png")]
		protected var brainMissileSprite:Class;
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
		
		public function BrainMissile(_ai:Boolean = false, _x:Number = 0, _y:Number = 0)
		{
			if (!_x) _x = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random();
			if (!_y) _y = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS;

			super(_x, _y, WEAPON_COOLDOWN);
			
			this.z = Registry.ENEMY_Z_LEVEL + 1;
			
			
			
			
			armour = HEALTH;						
			
			// used for weapons!
			//image = loadGraphic(brainMissileSprite);
			var graphic:FlxSprite = loadGraphic(brainMissileSprite, true, false, 18, 39);
			//image = graphic;			
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
						
			addAnimation("brainMissile", array, 24, true);
			this.play("brainMissile");
			
			_target = Registry.game.player;
			
			//weapons = new Array();				
			
			//this.xOffsetWeapon = this.x + (this.width / 2) - 3;
			//this.yOffsetWeapon = this.y + (this.width / 2) - 3;
			
			//for (var i:int = 0; i < 4; i++)
			//{
			//	addWeapon("cannon", BULLET_SPEED, WEAPON_COOLDOWN, BULLET_DAMAGE, "xOffsetWeapon", "yOffsetWeapon");
			//	Registry.game.enemyProjectiles.add(weapons[i].group);
			//}
			
			//var graphic:FlxSprite = loadGraphic(brainMissileSprite);
			
			if (_ai)
			{
				var self:BrainMissile = this;
				startTelprot(this, function():void {
					self.ai = new BrainMissileAI(self);
					
					glitch.stop();
					//glitch.destroy();
					scratch.kill();
				});
			}
		}
		
		protected var _target:Unit;
		protected function followUnit():void
		{		
			if (_target)
			{
				// Follow that bad boy.
				var dx:Number = _target.x - this.x;
				var dy:Number = _target.y - this.y;
				
				var distance:Number = Math.sqrt((dx * dx) + (dy * dy));

				dx = dx / distance;
				dy = dy / distance;
							
				vx = vx + (dx * maxTurn);
				vy = vy + (dy * maxTurn);
				
				var velocity:Number = Math.sqrt((vx * vx) + (vy * vy));
				
				if (velocity > maxSpeed)
				{
					vx = (vx * maxSpeed) / velocity;
					vy = (vy * maxSpeed) / velocity;
				}
				
				var a:Number = FlxVelocity.angleBetween(this, _target);
				this.angle = (a * (180 / Math.PI)) + 90;
				
				this.x = this.x + vx;
				this.y = this.y + vy;
			}
		}
		
		// When collides with an enemy, hurts the enemy, blows up.
		// Find new velocity, if it's less than SOME_NUMBER then do it, if not, then new velocity = old velocity +/- SOME_NUMBER
		protected var vx:Number = 0;
		protected var vy:Number = 0;
		public override function update():void
		{			
			super.update();						
			
			if (FlxG.overlap(Registry.game.player, this)) {
				this.killEnemy();
				Registry.player.hit(BULLET_DAMAGE);		
			}
			
			this.followUnit();
		}
	}
}