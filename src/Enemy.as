package  
{
	import Drops.HealthDrop;
	import Drops.ShieldDrop;
	import flash.text.engine.FontDescription;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxMath;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
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
			this.antialiasing = true;
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
			
			var healthDrop:HealthDrop;
			var shieldDrop:ShieldDrop;
			var creditDrop:Credit;
			
			if (FlxMath.chanceRoll(50))
			{
				if (Registry.player.armour < Registry.player.maxArmour)
				{
					// chance to drop health pack.
					if (FlxMath.chanceRoll(10))
					{
						// drop some health.
						healthDrop = new HealthDrop(this.x, this.y);
						Registry.game.add(healthDrop);
					}
					else if (FlxMath.chanceRoll(10))
					{
						// drop a shield.
						shieldDrop = new ShieldDrop(this.x, this.y);
						Registry.game.add(shieldDrop);
					}
					else
					{
						// drop some monies instead.					
						creditDrop = CreditManager.makeCredit(this.x, this.y);
						Registry.game.add(creditDrop);
					}
				}
				else
				{
					// no chance to drop health pack.
					if (FlxMath.chanceRoll(10))
					{
						// drop a shield.
						shieldDrop = new ShieldDrop(this.x, this.y);
						Registry.game.add(shieldDrop);
					}
					else
					{
						// drop some monies instead.
						creditDrop = CreditManager.makeCredit(this.x, this.y);
						Registry.game.add(creditDrop);
					}
				}
			}
			
			
			this.enemyHitImage.kill();
			this.kill(); // Kill the unit if it's health is reduced to <=0.	
			
			
		}
		
		override public function update():void
		{
			super.update();	
			
			if (this.velocity.x > 0)
			{
				TweenMax.to(this, 1, { angle: 10, ease: Ease } );
			}
			else if (this.velocity.x < 0)
			{
				TweenMax.to(this, 1, { angle: -10, ease: Ease } );
			}
			else
			{
				TweenMax.to(this, 1, { angle: 0, ease: Ease } );
			}
			
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