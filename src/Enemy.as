package  
{
	import Drops.HealthDrop;
	import Drops.ShieldDrop;
	import EmitterXL.EmitterXL;
	import Enemies.MineDroid.MineDrop;
	import flash.geom.ColorTransform;
	import flash.text.engine.FontDescription;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxMath;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import org.flixel.plugin.photonstorm.FX.GlitchFX;
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

		protected var enemyFlashCounter:int = 3;
		protected var enemyFlashIncrementor:int = 0;
		
		protected var _unflashIntervalId:Number;
		
		public function Enemy(X:Number = 0, Y:Number = 0, _weaponCooldown:Number = 1) 
		{
			super(X, Y);
			//this.z = Registry.ENEMY_Z_LEVEL;
			this.z = 0;
			weaponCooldown = _weaponCooldown;
			weaponTimer = weaponCooldown;
			this.antialiasing = true;						
		}
		
		public function enemyHit(_damage:int):void
		{			
			var damage:int = _damage;			
			while (damage > 0)
			{
				if (shields > 0) { shields--; }
				else { armour--; }
				damage--;
			}
			
			if (Registry.player.specialItem) { Registry.player.increaseChargeBar(); }
			
			flashWhite();
		}
		
		public function flashWhite():void
		{
			_colorTransform = new ColorTransform();
			_colorTransform.color = 0xFFFFFFFF;
			calcFrame();
			
			_unflashIntervalId = setTimeout(unflash, 25);
			Registry.intervals.push(_unflashIntervalId);
		}
		
		protected function unflash():void
		{
			_colorTransform = null;
			calcFrame();
		}
		
		public function killEnemy():void
		{
			clearInterval(_unflashIntervalId);
			Registry.intervals.splice(_unflashIntervalId, 1);
			
			//var particleEmitter:FlxEmitter = new FlxEmitter(this.x + this.width / 2, this.y + this.height / 2, 10);
			var particleEmitter:EmitterXL = new EmitterXL(this.x + this.width / 2, this.y + this.height / 2, 10, {"fadeOut": true, "rotation": true, "fadeOutSpeed": 0.01});
			particleEmitter.z = Registry.ENEMY_Z_LEVEL;
			
			for (var i:int = 0; i < 20; i++)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(4, 4, 0xFFFFFFFF);
				particle.exists = false;
				particle.z = 0;
				particleEmitter.add(particle);
				particleEmitter.minRotation = 0;
				particleEmitter.maxRotation = 0;
			}	
			
			particleEmitter.maxParticleSpeed.x = 50;
			particleEmitter.maxParticleSpeed.y = 50;
			particleEmitter.minParticleSpeed.x = -50;
			particleEmitter.minParticleSpeed.y = -50;
			
			Registry.game.add(particleEmitter);
			particleEmitter.start(true, 2, 0.1, 0);
						
			Registry.enemies.remove(this); // Remove the unit from the enemies array in PlayState when it has been killed.											
			if (ai) { ai.removeThis(); }
			ai = null;
			
			var healthDrop:HealthDrop;
			var shieldDrop:ShieldDrop;
			var creditDrop:Credit;
			
			if (getDefinitionByName(getQualifiedClassName(this)) !== MineDrop && FlxMath.chanceRoll(50))
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
		
			this.kill(); // Kill the unit if it's health is reduced to <=0.	
			if (getDefinitionByName(getQualifiedClassName(this)) !== MineDrop) { Registry.stage.wave.numberOfEnemies -= 1; }
		}
		
		override public function update():void
		{
			super.update();							
			
			if (armour <= 0) { killEnemy(); }		
		}
	}
}