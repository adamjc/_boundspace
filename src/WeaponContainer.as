package  
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.FlxText
	import com.greensock.TweenMax;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class WeaponContainer extends Item 
	{
		public var weapon:FlxWeapon;
		public var sprite:FlxSprite;
		
		public var weaponBulletSpeed:Number;
		public var weaponFireRate:Number;
		public var weaponDamage:Number;
		public var weaponImage:Class;
		public var weaponType:String;
		
		
		
		[Embed(source = "../assets/cannon.png")] public var cannon:Class;	
		[Embed(source = "../assets/cannon_bullet_shot.png")] public var cannon_bullet:Class;
		
		[Embed(source = "../assets/homingPulse.png")] public var homingPulse:Class;	
		[Embed(source = "../assets/homing_pulse_bullet_shot.png")] public var homingPulse_bullet:Class;	
		
		[Embed(source = "../assets/autoCannon.png")] public var autoCannon:Class;	
		[Embed(source = "../assets/auto_cannon_bullet_shot.png")] public var autoCannon_bullet:Class;
		
		public function WeaponContainer(_x:int, _y:int, _shop:Boolean, _weaponType:String, 
										_weaponBulletSpeed:Number, _weaponFireRate:Number, _weaponDamage:Number) 
		{
			super();
			x = _x;
			y = _y;
			
			z = Registry.ITEM_Z_LEVEL;
			
			weapon = new FlxWeapon(_weaponType); 
			weapon.setBulletSpeed(_weaponBulletSpeed);
			weapon.setFireRate(_weaponFireRate);
			weapon.bulletDamage = _weaponDamage;
			weaponBulletSpeed = _weaponBulletSpeed;
			weaponFireRate = _weaponFireRate;
			weaponDamage = _weaponDamage;						
			weapon.setBulletLifeSpan(5000);			
			weaponType = _weaponType;				
			
			switch (weaponType)
			{
				case "cannon": 
					weaponImage = cannon;
					weapon.makeImageBullet(100, cannon_bullet);
					break;
				case "homingPulse":
					weaponImage = homingPulse;
					weapon.makeImageBullet(100, homingPulse_bullet);
					break;
				case "autoCannon":
					weaponImage = autoCannon;		
					weapon.rndFactorAngle = 10;
					weapon.makeImageBullet(100, autoCannon_bullet);
					break;
				default: 
					weaponImage = cannon;		
					weapon.makeImageBullet(100, cannon_bullet);
					break;
			}
			
			weapon.group.z = Registry.PLAYER_PROJECTILE_Z_LEVEL;
			
			if (_shop)
			{
				this.price = PowerCore.PRICE; // lol, what.
				priceText = new FlxText(_x - 5, _y + 40, 50, this.price.toString() + "c");
				priceText.z = Registry.UI_Z_LEVEL_ELEMENTS;
				priceText.setFormat("DefaultFont", 16);
				Registry.game.add(priceText);
			}
			
			sprite = this.loadGraphic(weaponImage, false);
			this.scale.x = 0.4;
			this.scale.y = 0.4;			
						
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			canBePickedUp = false;	
			super.reset(X, Y);
		}
		
		protected var scaleUp:Boolean = true;
		protected var rotateClockwise:Boolean = true;
		override public function update():void
		{
			super.update();						
			
			if (this.angle >= 10)
			{
				rotateClockwise = false;
			}
			else if (this.angle <= -10)
			{
				rotateClockwise = true;
			}
			
			if (rotateClockwise)
			{
				this.angle += 0.1;
			}
			else
			{
				this.angle -= 0.1;
			}
			
			
			if (this.scale.x <= 0.4)
			{
				scaleUp = true;
			}
			else if (this.scale.x >= 0.5)
			{
				scaleUp = false;
			}
			
			if (scaleUp)
			{
				this.scale.x += 0.0025;
				this.scale.y += 0.0025;
			}
			else
			{
				this.scale.x -= 0.0025;
				this.scale.y -= 0.0025;
			}
		}					
		
		
	}

}