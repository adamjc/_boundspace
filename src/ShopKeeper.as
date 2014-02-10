package  
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class ShopKeeper extends Unit 
	{		
		public const X:Number = 300;
		public const Y:Number = 300;
		public const HEALTH:Number = 100;
		public var weaponCooldown:Number;
		public var weaponTimer:Number;
		public var weapon1:FlxWeapon;
		
		public var items:Array;
		
		public var angry:Boolean;
		public var angryCounter:int = 0;
		
		public static var aShopKeeperHasDied:Boolean = false;
		
		public var currentTextBox:TextBox;
		
		[Embed (source = "../assets/shopkeeper.png")] protected var shopKeeperImage:Class;
		
		/**
		 * Constructor.
		 */
		public function ShopKeeper() 
		{			
			var _x:Number = X;
			var _y:Number = Y;
			super(_x, _y);
			
			//image = makeGraphic(10, 10, 0xFF0F00FF);			
			
			var graphic:FlxSprite = loadGraphic(shopKeeperImage, true, false, 47, 33);
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
			
			addAnimation("shopkeeper", array, 60, true);
			this.play("shopkeeper");
			
			
			armour = HEALTH;
			this.weapons = new Array();
			
			weapon1 = new FlxWeapon("cannon", image);
			weapon1.setBulletSpeed(50);
			weapon1.setFireRate(1500);
			weapon1.makePixelBullet(10, 2, 2, 0xFFFF00FF);
			this.weapons.push(weapon1);
			
			(FlxG.state as PlayState).enemyProjectiles.add(weapon1.group);	
			
			items = Item.addShopItems();
			
			weaponTimer = 1;
			weaponCooldown = 1;
			
			/*
			 * If a ShopKeeper has previously been killed, then there is a 50% chance
			 * that any new ShopKeeper will be angry at the player
			 */
			if (aShopKeeperHasDied)
			{
				angry = FlxMath.chanceRoll(50);
			}
			else
			{
				angry = false;
			}
		}		
		
		/**
		 * Make the ShopKeeper slightly more angry.
		 */
		public function makeAngry():void
		{		
			switch (angryCounter)
			{
				case 0: // A little angry		
					if (currentTextBox) { currentTextBox.removeEverything(); }
					angryCounter++;
					currentTextBox = new TextBox("Hey! Stop that.", x + this.width + 20, y);
					break;
				case 1: // More angry
					if (currentTextBox) { currentTextBox.removeEverything();  }
					angryCounter++;
					currentTextBox = new TextBox("One more time, I'm warning ya!", x + this.width + 20, y);
					break;
				case 2: // Very angry
					if (currentTextBox) { currentTextBox.removeEverything();  }
					angryCounter++;
					currentTextBox = new TextBox("Right, that's it!", x + this.width + 20, y);					
					angry = true;										
					break;
				default:
					break;
			}			
		}
		
		/**
		 * 
		 */
		public function killShopKeeper(_playerKilled:Boolean = true):void
		{
			// TODO: When the ShopKeeper dies, all of the items that he owns have their price set to null.	
			var i:int;
			for (i = 0; i < items.length; i++)
			{
				items[i].changePrice();
			}
			Registry.enemies.remove(this); // Remove the unit from the enemies array in PlayState when it has been killed.		
			if (_playerKilled) { aShopKeeperHasDied = true; }
			this.kill(); // Kill the unit if it's health is reduced to <= 0.	
		}
		
		/**
		 * 
		 */
		override public function update():void
		{
			if (armour <= 0)
			{
				killShopKeeper();
			}
			
			// If the ShopKeeper is angry, it should attack the player.
			if (angry)
			{
				weaponTimer -= FlxG.elapsed;
				if (weaponTimer <= 0)
				{
					weaponTimer = weaponCooldown;
					
					if (FlxMath.chanceRoll(40))
					{
						var i:int;
						for (i = 0; i < this.weapons.length; i++)
						{				
							this.weapons[i].fireAtTarget(Registry.player.playerSprite);
							Registry.game.add(this.weapons[i].currentBullet);				
						}
					}
				}	
			}
		}
	}
}