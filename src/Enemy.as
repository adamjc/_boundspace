package  
{
	import flash.text.engine.FontDescription;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxMath;
	/**
	 * ...
	 * @author Adam
	 */
	public class Enemy extends Unit 
	{		
		[Embed(source = "../assets/explosy.png")] public var test:Class;
		
		public var weaponCooldown:Number;
		public var weaponTimer:Number;
		
		protected var shootingAngle:Number;
		
		protected var ai:AI;
		
		protected var enemyHitImage:FlxSprite;
		protected var isEnemyHit:Boolean;
		protected var enemyFlashCounter:int = 3;
		protected var enemyFlashIncrementor:int = 0;
		
		public function Enemy(X:Number = 0, Y:Number = 0, _weaponCooldown:Number = 1) 
		{
			super(X, Y);
			this.z = Registry.ENEMY_Z_LEVEL;
			if (!enemyHitImage) { enemyHitImage = new FlxSprite(); }
			weaponCooldown = _weaponCooldown;
			weaponTimer = weaponCooldown;
		}
		
		public function enemyHitAnimation():void
		{
			enemyHitImage.x = this.x;
			enemyHitImage.y = this.y;
			enemyHitImage.visible = true;
		}
		
		public function enemyHit(_damage:int):void
		{
			isEnemyHit = true;
			enemyFlashIncrementor = 0;
			this.enemyHitImage.visible = true;
			
			var damage:int = _damage;
			while (damage > 0)
			{
				if (shields > 0) { shields--; }
				else { armour--; }
				damage--;
			}			
		}
		
		public function killEnemy():void
		{
			var particleEmitter:FlxEmitter = new FlxEmitter(this.x, this.y, 10);
			particleEmitter.z = Registry.ENEMY_Z_LEVEL;
			particleEmitter.makeParticles(test, 10, 16, false, 0);
			particleEmitter.maxParticleSpeed.x = 25;
			particleEmitter.maxParticleSpeed.y = 25;
			particleEmitter.minParticleSpeed.x = -25;
			particleEmitter.minParticleSpeed.y = -25;
			Registry.game.add(particleEmitter);
			particleEmitter.start(true, 1, 0.1, 0);
			
			Registry.player.increaseChargeBar();
			Registry.enemies.remove(this); // Remove the unit from the enemies array in PlayState when it has been killed.											
			if (ai) { ai.removeThis(); }
			ai = null;
			
			this.enemyHitImage.kill();
			this.kill(); // Kill the unit if it's health is reduced to <=0.	
		}
		
		override public function update():void
		{
			super.update();	
			
			if (isEnemyHit)
			{
				if (enemyFlashIncrementor < enemyFlashCounter)
				{
					// toggle visibility
					this.enemyHitImage.x = this.x;
					this.enemyHitImage.y = this.y;					
					enemyFlashIncrementor += 1;
				}
				else
				{
					// make the enemyHitImage invisible.
					isEnemyHit = false;
					this.enemyHitImage.visible = false;
				}
			}
			
			if (armour <= 0) { killEnemy(); }		
		}
	}
}