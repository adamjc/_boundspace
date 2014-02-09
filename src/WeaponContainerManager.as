package  
{
	import org.flixel.FlxBasic;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class WeaponContainerManager extends FlxBasic 
	{		
		public static var weaponContainers:Array;
		weaponContainers = new Array();
		
		public static const CANNON_DAMAGE_MULTIPLIER:Number = 1.0;
		public static const CANNON_SPEED_MULTIPLIER:Number = 1.0;
		public static const CANNON_FIRE_RATE_MULTIPLIER:Number = 1.0;		
		weaponContainers.push(new WeaponContainer(0, 0, false, "cannon", Registry.bulletSpeed * CANNON_SPEED_MULTIPLIER, Registry.fireRate * CANNON_FIRE_RATE_MULTIPLIER, Registry.weaponDamage * CANNON_DAMAGE_MULTIPLIER));
		
		public static const HOMING_PULSE_DAMAGE_MULTIPLIER:Number = 1.0;
		public static const HOMING_PULSE_SPEED_MULTIPLIER:Number = 1.0;
		public static const HOMING_PULSE_FIRE_RATE_MULTIPLIER:Number = 1.0;		
		weaponContainers.push(new WeaponContainer(0, 0, false, "homingPulse", Registry.bulletSpeed * HOMING_PULSE_SPEED_MULTIPLIER, Registry.fireRate * HOMING_PULSE_FIRE_RATE_MULTIPLIER, Registry.weaponDamage * HOMING_PULSE_DAMAGE_MULTIPLIER));
		
		public static const AUTO_CANNON_DAMAGE_MULTIPLIER:Number = 0.5;
		public static const AUTO_CANNON_SPEED_MULTIPLIER:Number = 1.0;
		public static const AUTO_CANNON_FIRE_RATE_MULTIPLIER:Number = 0.5;						
		weaponContainers.push(new WeaponContainer(0, 0, false, "autoCannon", Registry.bulletSpeed * AUTO_CANNON_SPEED_MULTIPLIER, Registry.fireRate * AUTO_CANNON_FIRE_RATE_MULTIPLIER, Registry.weaponDamage * AUTO_CANNON_DAMAGE_MULTIPLIER));
		
		weaponSprites:Array;
		
		/**
		 * Constructor.
		 */
		public function WeaponContainerManager() 
		{
		}
		
		public function initialiseSprites():void
		{
			
			// TODO: Add all of the sprites for the powerCores.
		}
		
		public static function pickWeapon(_x:Number = 100, _y:Number = 100, _shop:Boolean = false):WeaponContainer
		{
			
			// Pick randomly a new PowerCore to add.
			//var r:int = Math.random() * ((weaponContainers.length - 1) + 0.5);	
			var r:int = Math.random() * 10;

			var w:WeaponContainer;
			if (r > 8)
			{
				w = weaponContainers[2];
			}
			else if (r > 7)
			{
				w = weaponContainers[1];
			}
			else
			{
				w = weaponContainers[0];
			}
			
			//var w:WeaponContainer = weaponContainers[r];
			
			var wc:WeaponContainer;
			wc = new WeaponContainer(_x, _y, _shop, w.weapon.name, w.weaponBulletSpeed, w.weaponFireRate, w.weaponDamage);
			return wc;
		}
		
		/**
		 * Randomly chooses a PowerCore from the powerCores array,
		 * instantiates it and adds it to the current game state.
		 */
		public static function addWeapon(_x:Number = 100, _y:Number = 100, _shop:Boolean = false):WeaponContainer
		{			
			var wc:WeaponContainer = pickWeapon(_x + 5, _y - 20, _shop);
			
			// Add it to the PlayState.
			Registry.game.add(wc);
			
			// Add it to the PlayState's Item collision group.
			Registry.game.items.add(wc);
			
			return wc;
		}
	}

}