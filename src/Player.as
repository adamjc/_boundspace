package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxPoint;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class Player extends Unit
	{		
		public const INITIAL_VELOCITY:Number = 80;
		public const INITIAL_ARMOUR:Number = 5;
		
		public const MAX_CHARGE:int = 20;		
		public const MAX_SPEED:Number = 10;
		public const MAX_CREDITS:int = 99;
		
		protected var aimAngle:Number = 0;					
		
		public var shootingPoint:FlxPoint;		
		public var weapon:FlxWeapon;
		public var weaponPoint:FlxPoint;
		public var wPx:Number;
		public var wPy:Number;
		
		public var weaponPoint1:FlxPoint;
		public var wP1x:Number;
		public var wP1y:Number;
		
		public var weaponPoint2:FlxPoint;
		public var wP2x:Number;
		public var wP2y:Number;
		
		public var weaponPoint3:FlxPoint;
		public var wP3x:Number;
		public var wP3y:Number;
		
		public var pivotPoint:FlxPoint;
		public var playerSprite:FlxSprite;
		[Embed(source = "../assets/spaceship2.png")] public var playerShip:Class;
		public var powerCore:PowerCore;		
		
		public var credits:int;
		
		public var chargeBarNumber:int;
		public var specialItem:SpecialItem;
		
		protected const INVULN_COOLDOWN:int = 1;
		protected var invulnTimeLeft:Number = 0;
		protected var invulnerable:Boolean = false;
		
		public var fireRate:int;
		public var bulletSpeed:int;
		public var shipSpeed:int;
		public var weaponDamage:int;
		
		public const MAX_FIRE_RATE:int = 100;
		public const MAX_BULLET_SPEED:int = 200;
		public const MAX_SHIP_SPEED:int = 10;
		public const MAX_WEAPON_DAMAGE:int = 10;
		
		/**
		 * Constructor.
		 * @param	X
		 * @param	Y
		 * @param	SimpleGraphics
		 */
		public function Player(X:Number = 0, Y:Number = 0, SimpleGraphics:Class = null) 
		{
			super(X, Y);
			this.z = Registry.PLAYER_Z_LEVEL;
			this.speed = 5;			
			this.credits = 98;			
			
			Registry.game.player = this;
			
			playerSprite = loadGraphic(playerShip);
			playerSprite.antialiasing = true;
			maxVelocity.x = INITIAL_VELOCITY;
			maxVelocity.y = INITIAL_VELOCITY;
			
			drag.x = maxVelocity.x;	
			drag.y = maxVelocity.y;
			this.weapons = new Array();

			shootingPoint = new FlxPoint;
			shootingPoint.x = this.x + this.width / 2;
			shootingPoint.y = this.y;			
		
			this.maxArmour = 5;
			this.shields = 0;
			pivotPoint = new FlxPoint;
			pivotPoint.x = this.x + this.width / 2;
			pivotPoint.y = this.y + this.height / 2;
			
			weaponPoint = new FlxPoint;
			weaponPoint.x = this.x + this.width / 2;
			weaponPoint.y = this.y;
			wPx = weaponPoint.x;
			wPy = weaponPoint.y;
			
			weaponPoint1 = new FlxPoint;
			weaponPoint1.x = (this.x + this.width / 2);
			weaponPoint1.y = this.y;
			wP1x = weaponPoint1.x;
			wP1y = weaponPoint1.y;
			
			weaponPoint2 = new FlxPoint;
			weaponPoint2.x = (this.x + this.width / 2) + 5;
			weaponPoint2.y = this.y;
			wP2x = weaponPoint2.x;
			wP2y = weaponPoint2.y;
			
			weaponPoint3 = new FlxPoint;
			weaponPoint3.x = (this.x + this.width / 2) - 5;
			weaponPoint3.y = this.y;
			wP3x = weaponPoint3.x;
			wP3y = weaponPoint3.y;
			
			armour = INITIAL_ARMOUR;
			
			Registry.fireRate = 800;
			Registry.bulletSpeed = 100;
			Registry.shipSpeed = 5
			Registry.weaponDamage = 5;				
				
		}
		
		override public function update():void
		{			
			super.update();
			this.angle = getAngle();			
			
			// update weaponPoint values
			weaponPoint1.x = (this.x + this.width / 2);
			weaponPoint1.y = this.y - 5;			
			weaponPoint1 = this.rotatePoint(pivotPoint, weaponPoint1, this.angle);			
			wP1x = weaponPoint1.x;
			wP1y = weaponPoint1.y;
			
			weaponPoint2.x = (this.x + this.width / 2) + 5;
			weaponPoint2.y = this.y;			
			weaponPoint2 = this.rotatePoint(pivotPoint, weaponPoint2, this.angle);			
			wP2x = weaponPoint2.x;
			wP2y = weaponPoint2.y;
			
			weaponPoint3.x = (this.x + this.width / 2) - 5;
			weaponPoint3.y = this.y;			
			weaponPoint3 = this.rotatePoint(pivotPoint, weaponPoint3, this.angle);			
			wP3x = weaponPoint3.x;
			wP3y = weaponPoint3.y;
			
			pivotPoint.x = this.x + this.width / 2;
			pivotPoint.y = this.y + this.height / 2;			
			
			acceleration.x = 0;
			acceleration.y = 0;							
			
			if (FlxG.keys.A)
			{
				acceleration.x = -maxVelocity.x * speed;				
			}
			if (FlxG.keys.D)
			{
				acceleration.x = maxVelocity.x * speed;
			}
			if (FlxG.keys.W)
			{
				acceleration.y = -maxVelocity.y * speed;
			}
			if (FlxG.keys.S)
			{
				acceleration.y = maxVelocity.y * speed;
			}			
			if (FlxG.mouse.pressed())
			{
				var i:int;
				for (i = 0; i < weapons.length; i++)
				{
					var w:WeaponContainer = weapons[i];
					if (w.weapon.readyToFire())
					{
						switch (w.weaponType)
						{
							case "homingPulse":			
									var f:FlxSprite = getClosestTarget();
									if (f) { w.weapon.fireAtTarget(f); }
									else { w.weapon.fireFromAngle(this.angle - 90);  }				
								break;
							default:
								w.weapon.fireFromAngle(this.angle - 90);
								break;	
						}					
						w.weapon.currentBullet.angle = this.angle;
					}
					
					w.weapon.currentBullet.z = Registry.PLAYER_PROJECTILE_Z_LEVEL;
					
					Registry.game.add(w.weapon.currentBullet);
					var s:FlxSound = new FlxSound();					
				}
			}
			
			if (invulnerable)
			{				
				invulnTimeLeft -= FlxG.elapsed;
				if (invulnTimeLeft <= 0)
				{
					invulnerable = false;
				}
			}
			
			if (this.armour <= 0)
			{
				Registry.game.isPlayerDead = true;
			}
		}
		
		/**
		 * Finds the closest FlxSprite (that is an enemy) to the player.
		 * 
		 * @return The closest FlxSprite (that is an enemy) to the player.
		 */ 		
		protected function getClosestTarget():FlxSprite
		{
			var playerCoords:FlxPoint = new FlxPoint(this.x, this.y);
			
			var smallestDistance:Number = undefined;
			var closestTarget:Unit = null;
			
			for each (var u:Enemy in Registry.enemies.members)
			{
				if (u)
				{
					var enemyCoords:FlxPoint = new FlxPoint(u.x, u.y);
					var distance:Number = FlxU.getDistance(playerCoords, enemyCoords);
					if (isNaN(smallestDistance) || distance < smallestDistance)
					{ 
						smallestDistance = distance; 
						closestTarget = u;
					}	
				}
			}
			
			return FlxSprite(closestTarget);
		}
		
		/**
		 * The player has been hurt.
		 * 
		 * @param The amount of damage the player takes.
		 */
		public function hit(val:int):void
		{
			if (!invulnerable)
			{
				if ((Registry.player.shields - val) > 0)
				{
					Registry.player.shields -= val;
				}	
				else // Handle cases where enemy damage is more than shields left.
				{
					val -= Registry.player.shields;
					Registry.player.shields = 0;
					if ((Registry.player.armour - val) > 0)
					{
						Registry.player.armour -= val;
					}
					else // Handle cases where enemy damage is more than armour left.
					{
						Registry.player.armour = 0;
					}				
				}			
			
				invulnerable = true;
				invulnTimeLeft = INVULN_COOLDOWN;
				this.flicker(INVULN_COOLDOWN);				
				
				Registry.ui.updatePlayerBars();
			}
			
		}
		
		/**
		 * The Player installs the PowerCore that it is currently holding, applying
		 * value the PowerCore holds to the Player's attributes.
		 */
		public function installPowerCore():void
		{
			if (powerCore)
			{				
				powerCore.installCore();
				powerCore = null;
			}
		}
		
		/**
		 * The Player installs the PowerCore that it is currently holding, applying
		 * value the PowerCore holds to the Player's attributes.
		 */
		public function useSpecial():void
		{
			if (this.specialItem && this.chargeBarNumber >= this.MAX_CHARGE)
			{				
				this.specialItem.useSpecial();
			}
		}
		
		/**
		 * The player drops the SpecialItem that it is currently holding.
		 */
		public function dropSpecialItem():void
		{
			if (specialItem) // If the player is holding a SpecialItem.
			{
				// Make it alive with the co-ordinates where the player is and given an initial random velocity.
				//var point:FlxPoint = rotatePoint(new FlxPoint(this.x + (this.width / 2), this.y + (this.height / 2)), 
				//								 new FlxPoint(this.x + this.width / 2, this.y - 10), 
				//								 angle);
												 
				specialItem.reset(this.x, this.y);
				specialItem.drag.x = 60;
				specialItem.drag.y = 60;
				specialItem.maxVelocity.x = 100;
				specialItem.maxVelocity.y = 100;
				FlxVelocity.moveTowardsMouse(specialItem, 20, 1000);
				//specialItem.dropped = true;
				//specialItem = null;
			}
		}
		
		/**
		 * The player drops the PowerCore that it is currently holding.
		 */
		public function dropPowerCore():void
		{			
			if (powerCore) // If the player has a Power Core to drop
			{
				// Make it alive with the co-ordinates where the player is and given an initial random velocity.
				//var point:FlxPoint = rotatePoint(new FlxPoint(this.x + (this.width / 2), this.y + (this.height / 2)), 
					//							 new FlxPoint(this.x + this.width / 2, this.y - 10), 
						//						 angle);
												 
				powerCore.reset(this.x, this.y);
				powerCore.drag.x = 60;
				powerCore.drag.y = 60;
				powerCore.maxVelocity.x = 100;
				powerCore.maxVelocity.y = 100;
				FlxVelocity.moveTowardsMouse(powerCore, 20, 1000);
				//powerCore.dropped = true;
				//powerCore = null;
			}
		}
		
		/**
		 * The player drops the last weapon it picked up.
		 */
		public function dropWeapon():void
		{
			if (weapons.length > 0) // If the player has a weapon to drop.
			{
								// Make it alive with the co-ordinates where the player is and given an initial random velocity.
				//var point:FlxPoint = rotatePoint(new FlxPoint(this.x + (this.width / 2), this.y + (this.height / 2)), 
					//							 new FlxPoint(this.x, this.y), 
						//						 angle);

				var wc:WeaponContainer = weapons.pop();
				wc.reset(this.x, this.y);
				wc.drag.x = 60;
				wc.drag.y = 60;
				wc.maxVelocity.x = 100;
				wc.maxVelocity.y = 100;
				FlxVelocity.moveTowardsMouse(wc, 20, 1000);				
			}			
		}
		
		public function increaseCredits(val:int):void
		{
			if ((this.credits + val) <= MAX_CREDITS)
			{
				this.credits += val;
			}
			else
			{
				this.credits = MAX_CREDITS;
			}
		}
		
		public function decreaseCredits(val:int):void
		{
			if ((this.credits - val) >= 0)
			{
				this.credits -= val;
			}
			else
			{
				this.credits = 0;
			}
		}
		
		public function increaseChargeBar():void
		{
			// update the chargeBarUI here.						
			if (chargeBarNumber < MAX_CHARGE)
			{	
				chargeBarNumber++;
				Registry.ui.setChargeBar();
			}
		}
		
		public function emptyChargeBar():void
		{
			// update the chargeBarUI here.			
			chargeBarNumber = 0;
			Registry.ui.setChargeBar();
		}
		
		public function increaseHealth(val:int = 1):void
		{
			if (this.armour + val <= this.maxArmour)
			{
				this.armour += val;
			}
			else
			{
				this.armour = this.maxArmour;
			}
		}
		
		public function increaseShield(val:int = 1):void
		{
			Registry.game.ui.flashShieldContainer();
			
			if (this.shields + val <= 99)
			{
				this.shields += val;
			}
			else
			{
				this.shields = 99;
			}
		}
	}
}