package  
{
	import Drops.HealthDrop;
	import Drops.HealthDropFive;
	import Drops.ShieldDrop;
	import flash.utils.ByteArray;
	import mx.core.FlexApplicationBootstrap;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import flash.ui.Mouse;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxCamera;
	import Drops.HealthDrop;
	import Drops.ShieldDropFive;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class PlayState extends FlxState
	{		
		public var player:Player;
		public var shopKeeper:ShopKeeper;
		public var ui:UI;
		
		public var topBox:FlxSprite;
		public var rightBox:FlxSprite;
		public var bottomBox:FlxSprite;
		public var leftBox:FlxSprite;
		public var boundingBox:FlxGroup;
		
		public var playerProjectiles:FlxGroup;
		public var enemyProjectiles:FlxGroup;
		public var credits:FlxGroup;
		
		public var items:FlxGroup;
		public var isShaking:Boolean;
		public var pausedState:Paused;
		
		// Saved values.
		public var achievements:uint;	
		public var timesPlayerDied:int;
				
		public var allAchievementsGet:uint =			1;
		public var killedBossWithoutTakingDamage:uint =	2;
		public var gotMaxHealthOf20:uint =				4;
		public var killedAShopKeeper:uint =				8;		
		public var gameCompletedFiveTimes:uint =		16;		
		public var stageFiveCompletedWithNoHits:uint =	32;		
		public var stageOneCompletedWithNoHits:uint =	64;		
		public var maxCreditsCollected:uint =			128;		
		public var died100Times:uint =					256;		
		public var gameCompletedOnce:uint =				512;		
		
		public var achievementsAdded:uint =	killedBossWithoutTakingDamage +
											gotMaxHealthOf20 +
											killedAShopKeeper +
											gameCompletedFiveTimes +
											stageFiveCompletedWithNoHits +
											stageOneCompletedWithNoHits +
											maxCreditsCollected +
											died100Times +
											gameCompletedOnce;
		
											
		[Embed(source = "../assets/keys.png")] public var keys:Class;	
		[Embed(source = "../assets/mouse_keys.png")] public var mouseKeys:Class;	
		[Embed(source = "../assets/powercore_and_weapons_keys.png")] public var powerCoreKeys:Class;	
		[Embed(source = "../assets/space.png")] public var spaceKey:Class;
		
		[Embed(source = "../assets/background.png")] public var backgroundImage:Class;
		[Embed(source = "../assets/stars.jpg")] public var backgroundStars:Class;
		
		protected var mouseKey:FlxSprite;
		protected var weaponsKeys:FlxSprite;
		protected var moveKeys:FlxSprite;
		protected var spaceKeys:FlxSprite;
		
		protected var background:FlxSprite; 
		protected var stars:FlxSprite;
		
		override public function create():void
		{						
			Registry.game = this;
			Registry.level = 1;					
			
			// Create the player.
			Registry.player = new Player(343, 250);
			add(Registry.player);
			
			PowerCoreManager.initialiseSprites();
			shopKeeper = null;
			
			// Add the top bounding box.
			topBox = new FlxSprite(0, BoundSpace.UIMaxY);
			topBox.width = BoundSpace.SceneWidth;
			topBox.height = 0.5;
			topBox.makeGraphic(BoundSpace.SceneWidth, 1, 0xFFFFFFFF);
			topBox.immovable = true;
			add(topBox);
			
			// Add the right bounding box.
			rightBox = new FlxSprite(BoundSpace.SceneWidth, BoundSpace.UIMaxY);
			rightBox.width = 0.5;
			rightBox.height = BoundSpace.SceneHeight - BoundSpace.UIMaxY;
			rightBox.makeGraphic(1, rightBox.height, 0xFFFFFFFF);
			rightBox.immovable = true;
			add(rightBox);
			
			// Add the bottom bounding box.
			bottomBox = new FlxSprite(0, BoundSpace.SceneHeight);
			bottomBox.width = BoundSpace.SceneWidth;
			bottomBox.height = 0.5;
			bottomBox.makeGraphic(BoundSpace.SceneWidth, 1, 0xFFFFFFFF);
			bottomBox.immovable = true;
			add(bottomBox);
			
			// Add the left bounding box.
			leftBox = new FlxSprite(0, BoundSpace.UIMaxY);
			leftBox.width = 0.5;
			leftBox.height = BoundSpace.SceneHeight - BoundSpace.UIMaxY;;
			leftBox.makeGraphic(1, leftBox.height, 0xFFFFFFFF);
			leftBox.immovable = true;
			add(leftBox);
						
			boundingBox = new FlxGroup(4);
			boundingBox.add(topBox);
			boundingBox.add(rightBox);
			boundingBox.add(bottomBox);
			boundingBox.add(leftBox);
			
			enemyProjectiles = new FlxGroup(1000);
			playerProjectiles = new FlxGroup(100);	
			credits = new FlxGroup(10);
			Registry.enemies = new FlxGroup();
			items = new FlxGroup();									
			
			FlxG.debug = true;	
			pausedState = new Paused();

			ui = new UI();
			Registry.ui = ui;
			this.add(ui);			
			FlxG.bgColor = 0xFF333333;
			
			var p:Portal = new Portal(1);
			p.x = 325;
			p.y = 100;
			this.add(p);
			
			mouseKey = new FlxSprite(90, 150, mouseKeys);
			weaponsKeys = new FlxSprite(430, 160, powerCoreKeys);
			moveKeys = new FlxSprite(60, 350, keys);
			spaceKeys = new FlxSprite(300, 400, spaceKey);
			
			add(mouseKey);
			add(weaponsKeys);
			add(moveKeys);
			add(spaceKeys);
			
			WeaponContainerManager.addWeapon(345, 180);
			
			background = new FlxSprite();
			background.loadGraphic(backgroundImage);
			background.y = Registry.BACKGROUND_START_X;
			background.x = Registry.BACKGROUND_START_Y;
			background.z = Registry.BACKGROUND_Z_LEVEL;
			add(background);
			
			stars = new FlxSprite();
			stars.loadGraphic(backgroundStars);
			stars.y = Registry.BACKGROUND_START_X;
			stars.x = Registry.BACKGROUND_START_Y;
			stars.z = Registry.BACKGROUND_STARS_Z_LEVEL;
			add(stars);
			
			this.add(SpecialItemManager.addSpecialItem(100, 300));
			this.add(SpecialItemManager.addSpecialItem(200, 300));
		}

		public var c:Credit;
		public var isPlayerDead:Boolean = false;
		public var playerExplodeAnimPlayed:Boolean = false;
		public var countDown:Number = 0.2;
		public var particleEmitter:FlxEmitter;
		[Embed(source = "../assets/explosy.png")] public var test:Class;
		public var rect:FlxSprite;
		override public function update():void
		{		
			Mouse.show();
			if (!pausedState.isShowing)
			{
				super.update();			
				
				var pos:FlxPoint = calculatePos();

				background.x = pos.x * 0.5;
				background.y = pos.y * 0.5;
				stars.x = pos.x * 0.25;
				stars.y = pos.y * 0.25;
				
				
				// TODO: empty the group at the end of every stage...
				// TODO: handle specialItem collision.
				
				this.sort("z"); // Ensure proper rendering order.
				
				FlxG.collide(Registry.player, boundingBox); // Ensure the player collides with the boundaries of the game.
				FlxG.collide(Registry.enemies, boundingBox); // Ensure that enemies collide with the boundaries of the game.	
				
				var i:int;
				for (i = 0; i < Registry.player.weapons.length; i++)
				{
					var w:FlxWeapon = Registry.player.weapons[i].weapon;
					FlxG.collide(w.group, boundingBox, playerHit); // Ensure that the player's projectiles collide with the boundaries of the game.
					FlxG.overlap(w.group, Registry.enemies, playerShotEnemy); // Ensure that the player's projectiles can hit enemies.
					if (shopKeeper) { FlxG.overlap(w.group, shopKeeper, playerShotShopKeeper); }
				}
							
				FlxG.collide(enemyProjectiles, boundingBox, enemyHit); // Ensure that the enemy's projectiles collide with the boundaries of the game.
				FlxG.collide(Registry.enemies, Registry.enemies);
				FlxG.overlap(enemyProjectiles, Registry.player, enemyShotPlayer); 			
				
				FlxG.overlap(Registry.player, items, pickUpItem); // Ensure that the player can pick up any items.
				FlxG.collide(items, boundingBox); // Ensure that the items collide with the boundingBox.
				
				FlxG.collide(Registry.player, Registry.enemies, playerCollideEnemy);
				FlxG.collide(Registry.player, shopKeeper);
				
				FlxG.overlap(Registry.player, Registry.portals, playerEnteredPortal);
				
				if (FlxG.keys.justPressed("M"))
				{ 
					Registry.stage = new GameStage(Registry.level++);
					add(Registry.stage);
				}			
				
				if (FlxG.keys.justPressed("Q"))
				{
					Registry.player.installPowerCore();
				}	
				
				if (FlxG.keys.justPressed("E"))
				{
					Registry.player.chargeBarNumber = 5;
				}
				
				if (FlxG.keys.justPressed("F"))
				{
					Registry.player.dropWeapon();
				}
				
				if (FlxG.keys.justPressed("G"))
				{
					killEnemies();
				}
				
				if (FlxG.keys.justPressed("ESCAPE"))
				{
					pausedState = new Paused;
					pausedState.showPaused();
					add(pausedState);
				}
								
				if (FlxG.keys.justPressed("B"))
				{					
					var shieldDrop:ShieldDrop;
					shieldDrop = new ShieldDrop(Registry.player.x + 50, Registry.player.y);
					this.add(shieldDrop);
				}									
				
				if (FlxG.keys.justPressed("L"))
				{
					var ess:SpaceSaucer = new SpaceSaucer(true);
					ess.x = 100;
					ess.y = 100;
					Registry.enemies.add(ess);
					Registry.game.add(ess);
				}
				
				if (FlxG.keys.justPressed("SPACE"))
				{
					Registry.player.useSpecial();
				}
				
				if (isPlayerDead)
				{
					var fp:FlxPoint = new FlxPoint(2, 2);
					particleEmitter = new FlxEmitter(Registry.player.x + (Registry.player.width / 2), Registry.player.y + (Registry.player.height / 2), 50);
					
					FlxG.timeScale = 0.1;
					countDown -= FlxG.elapsed;
															
					if (countDown < 0 && !playerExplodeAnimPlayed)
					{
						Registry.player.visible = false;
						particleEmitter.makeParticles(test, 100, 16, false, 0);						
						Registry.game.add(particleEmitter);
						particleEmitter.minParticleSpeed.x = -400;
						particleEmitter.minParticleSpeed.y = -400;
						particleEmitter.maxParticleSpeed.x = 400;
						particleEmitter.maxParticleSpeed.y = 400;
						particleEmitter.start(true, 1, 0.1, 0);	
						playerExplodeAnimPlayed = true;		
						
						rect = new FlxSprite(0, 0, null, 999);
						rect.makeGraphic(Registry.RIGHT_BOUNDS, Registry.BOTTOM_BOUNDS, 0xFF000000);
						rect.alpha = 0.0;
						this.add(rect);
						playerExplodeAnimPlayed = true;
					}
					
					if (countDown < -0.1)
					{
						// Fadeout screen
						rect.alpha += 0.01;						
					}
					
					if (countDown < -0.3)
					{
						// Switch to playerDeath state, show "Oh no, you died!", etc
						FlxG.timeScale = 1;
						var ds:DeathState = new DeathState();
						FlxG.switchState(ds);
					}
				}
				
				if (FlxG.keys.justPressed("C"))
				{
					Registry.player.hit(1)
				}	
				
				if (FlxG.keys.justPressed("H"))
				{
					Achievements.achievements = 0x0;
				}
				
				if (FlxG.keys.justPressed("J"))
				{
					Registry.player.increaseChargeBar();
				}
				
				if (FlxG.keys.justPressed("K"))
				{
					Registry.player.emptyChargeBar();
				}
				
				checkAchievements();
			}
			else
			{
				pausedState.update();
			}
		}
				
		public function calculatePos():FlxPoint
		{
			var multiplier:Array = getMultiplier();
			
			var centreOfScreenX:int = Registry.RIGHT_BOUNDS / 2;
			var centreOfScreenY:int = Registry.BOTTOM_BOUNDS / 2 + Registry.TOP_BOUNDS;			
			
			var distanceToAdd:FlxPoint = new FlxPoint();
			distanceToAdd.x = Registry.player.x - centreOfScreenX;
			distanceToAdd.y = Registry.player.y - centreOfScreenY;

			var backgroundPos:FlxPoint = new FlxPoint();
			
			backgroundPos.x = Registry.BACKGROUND_START_X - (multiplier[0] * distanceToAdd.x);
			backgroundPos.y = Registry.BACKGROUND_START_Y - (multiplier[1] * distanceToAdd.y);
			
			return backgroundPos;
		}

		public function getMultiplier():Array
		{
			var centreOfScreen:FlxPoint = new FlxPoint();
			
			var centreOfScreenX:int = Registry.RIGHT_BOUNDS / 2;
			var centreOfScreenY:int = Registry.BOTTOM_BOUNDS / 2 + Registry.TOP_BOUNDS;

			// Get the distance from the centre of the screen to the end of the screen
			var centreToEndX:int = getDistanceInt(centreOfScreenX, Registry.RIGHT_BOUNDS);
			var centreToEndY:int = getDistanceInt(centreOfScreenX, Registry.TOP_BOUNDS);

			// Get the distance from the starting background x,y to 0,0
			var backgroundToOrigin:FlxPoint = new FlxPoint();
			backgroundToOrigin.x = getDistanceInt(Registry.BACKGROUND_START_X, 0);
			backgroundToOrigin.y = getDistanceInt(Registry.BACKGROUND_START_Y, 0);
			
			return new Array(Number(backgroundToOrigin.x) / centreToEndX, Number(backgroundToOrigin.y) / centreToEndY);
		}

		public function getDistanceInt(a:int, b:int):int
		{
			return Math.abs(a - b);
		}				
		
		public function checkAchievements():void
		{
			var s:FlxPoint
			var e:FlxPoint;
			var f:FlxAchievement;
			
			// Check credits.			
			if (!(Achievements.achievements & maxCreditsCollected) && 
				(Registry.player.credits == Registry.player.MAX_CREDITS))
			{
				Achievements.achievements |= maxCreditsCollected;
				s = new FlxPoint(0, -50);
				e = new FlxPoint(0, 0);
				f = new FlxAchievement(s, e, 200, 50, 5, "Gold Digger.");
				Registry.game.add(f);
			}
			
			
			
			//public var allAchievementsGet:uint =			1;
			//public var killedBossWithoutTakingDamage:uint =	2;
			//public var gotMaxHealthOf20:uint =				4;
			//public var killedAShopKeeper:uint =				8;		
			//public var gameCompletedFiveTimes:uint =		16;		
			//public var stageFiveCompletedWithNoHits:uint =	32;		
			//public var stageOneCompletedWithNoHits:uint =	64;		
			//public var maxCreditsCollected:uint =			128;		
			//public var died100Times:uint =					256;		
			//public var gameCompletedOnce:uint =				512;
		}
		
		public function playerEnteredPortal(_player:FlxObject, _portal:FlxObject):void
		{			
			Registry.enemies.kill();			
			Registry.portals.kill();
			items.kill();
			if (shopKeeper) shopKeeper.killShopKeeper(false);
			
			if (mouseKey) { mouseKey.kill(); }
			if (moveKeys) { moveKeys.kill(); }
			if (weaponsKeys) { weaponsKeys.kill(); }
			if (spaceKeys) { spaceKeys.kill(); }
			
			if (Registry.stage) Registry.stage.kill();
			Registry.stage = new GameStage(Registry.level++);				
			add(Registry.stage);
			
			FlxG.camera.flash();
		}
		
		/**
		 * Debug function.
		 */
		public function killEnemies():void
		{
			var i:int;
			var a:Array = Registry.enemies.members;
			for (i = 0; i < a.length; i++)
			{								
				if (a[i] != undefined)
				{
					a[i].armour = 0;
				}
			}
		}
		
		public function playerShotShopKeeper(_bullet:FlxObject, _shopKeeper:ShopKeeper):void
		{
			_bullet.kill();
			_shopKeeper.armour -= Bullet(_bullet).bulletDamage;
			_shopKeeper.makeAngry();
		}
		
		/**
		 * 
		 * @param	_player
		 * @param	_item
		 */
		public function pickUpItem(_player:Player, _item:Item):void
		{	
			if (_item && _item.canBePickedUp)
			{
				if (_item is PowerCore)
				{
					// Player is overlapping with a PowerCore.
					var item:PowerCore = PowerCore(_item);
					if (!Registry.player.powerCore && (!item.price || item.price <= Registry.player.credits)) // Player does not have a power core.
					{					
						if (item.price) // Buy the item.
						{
							Registry.player.credits -= item.price;
						}
						Registry.player.powerCore = item;
						//Registry.player.powerCore.droppedTimer = Registry.player.powerCore.DROPPED_TIMER_VAL;
						item.removeThis();
					}	
					else if (!item.price || item.price <= Registry.player.credits) // Player already owns a power core.
					{
						Registry.player.dropPowerCore();						
						Registry.player.powerCore = item;
						//Registry.player.powerCore.droppedTimer = Registry.player.powerCore.DROPPED_TIMER_VAL;
						item.removeThis();										
					}
				}
				if (_item is SpecialItem)
				{
					// Player is overlapping with a SpecialItem.
					var specialItem:SpecialItem = SpecialItem(_item);
					
					if (!Registry.player.specialItem && (!specialItem.price || specialItem.price <= Registry.player.credits)) // Player does not have a power core.
					{					
						if (specialItem.price) // Buy the item.
						{
							Registry.player.credits -= specialItem.price;
						}
						Registry.player.specialItem = specialItem;
						
						specialItem.removeThis();
					}	
					else if (!specialItem.price || specialItem.price <= Registry.player.credits) // Player already owns a power core.
					{
						trace("second");
						Registry.player.dropSpecialItem();						
						Registry.player.specialItem = specialItem;
						
						specialItem.removeThis();										
					}
					
					
					
					//if (Registry.player.specialItem)
					//{
					//	// The player already has a SpecialItem. Drop it and pick this one up.
					//	Registry.player.dropSpecialItem();					
					//}
					//if (specialItem.price) // Buy the item.
					//{
					//	Registry.player.credits -= specialItem.price;
					//}
					//Registry.player.specialItem = specialItem;
					//specialItem.removeThis();
				}
				if (_item is WeaponContainer)
				{
					// Player is overlapping with a Weapon.				
					var weaponContainer:WeaponContainer = WeaponContainer(_item);
					if (Registry.player.weapons.length < Unit.MAX_WEAPONS)
					{															
						if (weaponContainer.price) // Buy the item.
						{
							Registry.player.credits -= weaponContainer.price;
						}					
						
						Registry.player.weapons.push(weaponContainer);
						switch (Registry.player.weapons.length)
						{						
							case 1:							
								weaponContainer.weapon.setParent(Registry.player, "wP1x", "wP1y");								
								break;
							case 2:
								weaponContainer.weapon.setParent(Registry.player, "wP2x", "wP2y");
								break;
							case 3: 
								weaponContainer.weapon.setParent(Registry.player, "wP3x", "wP3y");
								break;
						}
						weaponContainer.removeThis();	
					}
				}
			}			
		}
		
		public function pickUpCredit(_player:Player, credit:Credit):void
		{
			if (FlxCollision.pixelPerfectCheck(credit, Registry.player))
			{
				if (!credit.isPickedUp && _player.credits != _player.MAX_CREDITS)
				{
					_player.increaseCredits(credit.value);
					credit.isPickedUp = true;
					credit.creditPickedUp(credit);
				}				
			}									
		}
		
		/**
		 * 
		 * @param	_player
		 * @param	powerCore
		 */
		public function pickUpPowerCore(_player:FlxObject, _pc:FlxObject):void
		{			
			var p:PowerCore = PowerCore(_pc);
			if (!Registry.player.powerCore && (!p.price || p.price <= Registry.player.credits))
			{				
				if (p.price) // Buy the item.
				{ 
					Registry.player.credits -= p.price;
				}
				Registry.player.powerCore = p;
				Registry.player.powerCore.droppedTimer = Registry.player.powerCore.DROPPED_TIMER_VAL;
				p.removeThis();				
			}
		}
		
		/**
		 * 
		 * @param	_player
		 * @param	_enemy
		 */
		public function playerCollideEnemy(_player:FlxObject, _enemy:FlxObject):void
		{
			// TODO: 		
		}
		
		/**
		 * 
		 * @param	o1
		 * @param	o2
		 */
		public function enemyShotPlayer(projectile:Bullet, player:Player):void
		{						
			projectile.kill();
			enemyProjectiles.remove(projectile);
			Registry.player.hit(projectile.bulletDamage);
		}
		
		/**
		 * 
		 * @param	o1
		 * @param	o2
		 */
		public function playerShotEnemy(o1:FlxObject, o2:FlxObject):void
		{
			(o2 as Enemy).enemyHit(Bullet(o1).bulletDamage);
			o1.kill();						
		}
		
		/**
		 * 
		 * @param	o1
		 * @param	o2
		 */
		public function playerHit(o1:FlxObject, o2:FlxObject):void
		{
			o1.kill();			
		}
		
		/**
		 * 
		 * @param	o1
		 * @param	o2
		 */
		public function enemyHit(o1:FlxObject, o2:FlxObject):void
		{
			o1.kill();
			enemyProjectiles.remove(o1);
		}
	}
}