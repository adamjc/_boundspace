package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.flixel.FlxBasic;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import com.greensock.TweenMax;
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class UI extends FlxBasic 
	{
		[Embed(source = "../assets/credits.png")] protected var creditSymbol:Class;		
				
		protected var stageText:FlxText;
		
		protected var weapon_1:FlxSprite;
		protected var weaponOverlay_1:FlxSprite;
		
		protected var weapon_2:FlxSprite;
		protected var weaponOverlay_2:FlxSprite
		
		protected var weapon_3:FlxSprite;
		protected var weaponOverlay_3:FlxSprite
		
		protected var powerCore:FlxSprite;	
		protected var powerCoreText:FlxText;
		protected var powerCoreStartX:int = 320;
		protected var powerCoreStartY:int = 44;
		protected var powerCoreAreaWidth:int = 60;
		protected var powerCoreCompare:PowerCore;
		protected var specialItemUI:FlxSprite;
		
		protected var chargeBarUI:FlxSprite;
		protected var chargeBar:FlxSprite;	
		protected var _chargeBarWhiteBox:FlxSprite;
		protected const CHARGE_X:int = 245;
		protected const CHARGE_Y:int = 7;
		
		protected var _specialItemGlowIntervalID:Number
		
		protected var _specialItemOuterFlash:FlxSprite;
		
		protected const TEXT_X:int = 100;
		
		protected var waveText:FlxText;
		protected const WAVE_TEXT_Y:int = 1;
		
		protected var creditsText:FlxText;
		protected const CREDITS_TEXT_X:int = 84;
		protected const CREDITS_TEXT_Y:int = 45;
		
		protected const BASE_WAVE_TEXT:String = "0";
		
		protected const BASE_STAGE_TEXT:String = "0";
		protected const STAGE_TEXT_Y:int = 22;
		
		protected var healthBar:FlxSprite;
		protected var healthBarText:FlxText;
		protected const ARMOUR_BAR_CONTAINER_START_X:int = 392;
		protected const ARMOUR_BAR_START_Y:int = 23;
		protected const ARMOUR_BAR_CONTAINER_END_X:int = ARMOUR_BAR_CONTAINER_START_X + 210;	
		
		protected var shieldBar:FlxSprite;
		protected var shieldText:FlxText;
		protected const SHIELD_BAR_CONTAINER_START_X:int = 627;
		protected const SHIELD_BAR_START_Y:int = ARMOUR_BAR_START_Y;
		protected const SHIELD_BAR_CONTAINER_END_X:int = SHIELD_BAR_CONTAINER_START_X + 30;						
		
		protected var whiteShieldBox:FlxSprite;
		
		public function UI() 
		{
			super();						
			
			var spaceBarText:FlxText = new FlxText(CHARGE_X - 1, CHARGE_Y - 11, 66, "SPACE");
			spaceBarText.setFormat("DefaultFont", 16, 0xFFFFFF, "center");
			spaceBarText.z = Registry.UI_TEXT_Z_LEVEL
			Registry.game.add(spaceBarText);
			
			// Make all of the UI elements appear.
			[Embed(source = "../assets/ui-sketch.png")] var UITexture:Class;
			var ui:FlxSprite = new FlxSprite(0, 0, UITexture, Registry.UI_Z_LEVEL_BASE);		
			Registry.game.add(ui);
			
			[Embed(source = "../assets/UIBackground.png")] var backgroundUI:Class;
			var uiBackground:FlxSprite = new FlxSprite(0, 0, backgroundUI, Registry.UI_Z_LEVEL_BACKGROUND);
			Registry.game.add(uiBackground);
			
			// Add stage information.
			stageText = new FlxText(TEXT_X, STAGE_TEXT_Y, 50);
			stageText.text = BASE_STAGE_TEXT;
			//stageText.scale.x = 2;
			//stageText.scale.y = 2;
			stageText.z = Registry.UI_TEXT_Z_LEVEL;
			stageText.setFormat("DefaultFont", 16);
			Registry.game.add(stageText);
			
			// Add wave information.
			waveText = new FlxText(TEXT_X, WAVE_TEXT_Y, 50);
			waveText.text = BASE_WAVE_TEXT;
			//waveText.scale.x = 2;
			//waveText.scale.y = 2;
			waveText.setFormat("DefaultFont", 16);
			waveText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(waveText);
			
			// Add credits information.
			creditsText = new FlxText(CREDITS_TEXT_X, CREDITS_TEXT_Y, 50);
			//creditsText.scale.x = 2;
			//creditsText.scale.y = 2;
			creditsText.setFormat("DefaultFont", 16);
			creditsText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(creditsText);
			
			var c:FlxSprite = new FlxSprite(CREDITS_TEXT_X - 57, CREDITS_TEXT_Y + 2, creditSymbol, 4);
			Registry.game.add(c);
			
			// Add armour information.
			healthBar = new FlxSprite(ARMOUR_BAR_CONTAINER_START_X, ARMOUR_BAR_START_Y);		
			healthBar.z = Registry.UI_Z_LEVEL_ELEMENTS;
			Registry.game.add(healthBar);			
			var hwidth:int = ARMOUR_BAR_CONTAINER_END_X - ARMOUR_BAR_CONTAINER_START_X;
			healthBarText = new FlxText(ARMOUR_BAR_CONTAINER_START_X + (hwidth / 2), ARMOUR_BAR_START_Y + 2, 200, Registry.player.armour.toString()); 
			healthBarText.x -= healthBarText.width / 2;
			//healthBarText.scale.x = 2;
			//healthBarText.scale.y = 2;
			healthBarText.setFormat("DefaultFont", 16);
			healthBarText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(healthBarText);
			healthBarText.alignment = "center";
			
			// Add shield information.
			shieldBar = new FlxSprite(SHIELD_BAR_CONTAINER_START_X, SHIELD_BAR_START_Y);
			shieldBar.makeGraphic(30, 30, 0xFF3eb3fe);
			shieldBar.z = Registry.UI_Z_LEVEL_CHARGE_BAR;
			Registry.game.add(shieldBar);
			
			whiteShieldBox = new FlxSprite(SHIELD_BAR_CONTAINER_START_X, SHIELD_BAR_START_Y);
			whiteShieldBox.makeGraphic(30, 30, 0xFFFFFFFF);
			Registry.game.add(whiteShieldBox);
			whiteShieldBox.z = shieldBar.z + 1;
			whiteShieldBox.alpha = 0.0;
			
			hwidth = SHIELD_BAR_CONTAINER_END_X - SHIELD_BAR_CONTAINER_START_X;
			shieldText = new FlxText(626, 25, 30, Registry.player.shields.toString());
			shieldText.setFormat("DefaultFont", 16, 0xFFFFFF, "center");
			shieldText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(shieldText);
			updatePlayerBars();
			
			// Add charge bar information.
			//chargeBar = new FlxSprite(CHARGE_X, CHARGE_BAR_CONTAINER_START_Y)
			//chargeBar.z = Registry.UI_Z_LEVEL_CHARGE_BAR;			
			//chargeBar.makeGraphic(12, CHARGE_BAR_CONTAINER_START_Y - CHARGE_BAR_CONTAINER_END_Y);
			//Registry.game.add(chargeBar);
			
			[Embed(source = "../assets/specialBoxFlash.png")] var specialBoxFlash:Class;
			chargeBar = new FlxSprite(CHARGE_X, CHARGE_Y, specialBoxFlash);
			chargeBar.z = Registry.UI_Z_LEVEL_SPECIAL_ITEM_GLOW;			
			chargeBar.alpha = 0.0;
			Registry.game.add(chargeBar);
						
			_chargeBarWhiteBox = new FlxSprite(CHARGE_X + 3, CHARGE_Y + 3);
			_chargeBarWhiteBox.z = Registry.UI_Z_LEVEL_CHARGE_BAR;
			_chargeBarWhiteBox.makeGraphic(60, 60, 0xFFFFFFFF);
			_chargeBarWhiteBox.alpha = 0;
			Registry.game.add(_chargeBarWhiteBox);
			
			// Add special item charge information.
			[Embed(source = "../assets/specialBoxFlashy.png")] var specialBoxOuterFlash:Class;
			_specialItemOuterFlash = new FlxSprite(CHARGE_X, CHARGE_Y);
			_specialItemOuterFlash.z = Registry.UI_Z_LEVEL_SPECIAL_ITEM_GLOW;		
			var graphic:FlxSprite = _specialItemOuterFlash.loadGraphic(specialBoxOuterFlash, true, false, 66, 66);
			_specialItemOuterFlash.alpha = 0.0;
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
			
			_specialItemOuterFlash.addAnimation("specialBoxOuterFlash", array, 60, true);
			_specialItemOuterFlash.play("specialBoxOuterFlash");
			Registry.game.add(_specialItemOuterFlash);
			
		}
			
		public function flashShieldContainer():void
		{
			whiteShieldBox.alpha = 1.0;
			var whiteShieldBoxIntervalID:Number = setInterval(function():void {
				whiteShieldBox.alpha -= 0.1;
				if (whiteShieldBox.alpha <= 0) { clearInterval(whiteShieldBoxIntervalID);}
			}, 25);
			Registry.intervals.push(whiteShieldBoxIntervalID);
			
		}
		
		override public function update():void
		{
			super.update();
			updateStageText();
			updateWaveText();
			updateCreditsText();
			updateWeaponUI();
			updatePowerCoreUI();			
			updateSpecialItemUI();
			updatePlayerBars();
			setChargeBar();
		}

		protected var widthToFill:Number;
		public function fillArmourBar(increase:Boolean):void
		{
			if (increase)
			{
				currentArmourWidth += 3;
				healthBar.makeGraphic(currentArmourWidth, 30, 0xFF880000);
				if (currentArmourWidth > targetArmourWidth)
				currentArmourWidth = targetArmourWidth
				healthBar.makeGraphic(currentArmourWidth, 30, 0xFF880000);
			}
			else
			{
				currentArmourWidth -= 3;
				if (currentArmourWidth > 0)
				{
					healthBar.makeGraphic(currentArmourWidth, 30, 0xFF880000);
					if (currentArmourWidth < targetArmourWidth)
					currentArmourWidth = targetArmourWidth
					healthBar.makeGraphic(currentArmourWidth, 30, 0xFF880000);
				}								
			}
		}
		
		protected var currentArmour:int;
		protected var currentArmourWidth:int = 1;
		protected var targetArmourWidth:Number;
		public function updatePlayerBars():void
		{
			if (currentArmour != Registry.player.armour) { currentArmour = Registry.player.armour; }
			
			var maxVal:int = Registry.player.maxArmour;
			var maxWidth:int = ARMOUR_BAR_CONTAINER_END_X - ARMOUR_BAR_CONTAINER_START_X;
			targetArmourWidth = maxWidth * (currentArmour / maxVal);	
			
			if (currentArmour != 0)
			{
				if (currentArmourWidth > targetArmourWidth)
				{
					fillArmourBar(false);
				}
				else if (currentArmourWidth < targetArmourWidth)
				{
					fillArmourBar(true);
				}
			}
			else
			{
				healthBar.kill();
			}	
			
			healthBarText.text = Registry.player.armour.toString() + "/" + Registry.player.maxArmour;
			
			shieldText.text = Registry.player.shields.toString();
			
			if (Registry.player.shields >= 1)
			{
				shieldBar.alpha = 1.0;
			}
			else
			{
				shieldBar.alpha = 0.0;
			}
		}
		
		protected var previousChargeVal:int;
		protected var _specialItemBoxFlashed:Boolean = false;
		public function setChargeBar():void
		{			
			var stepIncrease:Number = 0.5 / Registry.player.MAX_CHARGE;
			
			if (Registry.player)
			{							
				if (Registry.player.chargeBarNumber == Registry.player.MAX_CHARGE && !_specialItemBoxFlashed)
				{
					// flash the box, nigger.
					chargeBar.alpha = 1.0;
					_specialItemOuterFlash.alpha = 1.0;
					TweenMax.to(chargeBar, 0.5, { alpha: 0, onComplete: specialItemGlow });
					_specialItemBoxFlashed = true;
				}
				
				if (previousChargeVal < Registry.player.chargeBarNumber && (previousChargeVal <= Registry.player.MAX_CHARGE)) 
				{
					// Increase intensity
					if (_chargeBarWhiteBox.alpha + stepIncrease > 1.0)
					{
						_chargeBarWhiteBox.alpha = 1.0;
					}
					else
					{
						_chargeBarWhiteBox.alpha += stepIncrease;	
					}
				}
				else if (previousChargeVal > Registry.player.chargeBarNumber) // Player has used special item.
				{
					chargeBar.alpha = 0.0;
					_specialItemOuterFlash.alpha = 0.0;
					_specialItemBoxFlashed = false;
					_chargeBarWhiteBox.alpha = 0.0;
					clearInterval(_specialItemGlowIntervalID);
				}
			}		
			
			previousChargeVal = Registry.player.chargeBarNumber;
			
			
		}
		
		protected var _chargeBarGlowing:Boolean = false;
		protected function specialItemGlow():void
		{			
			
			_specialItemGlowIntervalID = setInterval(function():void {
				if (_chargeBarGlowing)
				{
					_chargeBarWhiteBox.alpha += 0.0125;
				}
				else
				{
					_chargeBarWhiteBox.alpha -= 0.0125;
				}
				
				if (_chargeBarWhiteBox.alpha <= 0)
				{
					_chargeBarGlowing = true;
				}
				if (_chargeBarWhiteBox.alpha >= 0.5)
				{
					_chargeBarGlowing = false;
				}
				
				
			}, 50);
			Registry.intervals.push(_specialItemGlowIntervalID);
		}
		
		/**
		 * This updates every cycle, potential performance bottleneck.
		 */
		public function updatePowerCoreUI():void
		{
			if (Registry.player)
			{
				var pc:PowerCore = Registry.player.powerCore
				if (pc)
				{					
					var p:Class = Object(pc).constructor;
					if (powerCoreCompare && pc.usedName != powerCoreCompare.usedName) // The player is holding a powerCore but it's not the same.
					{						
						powerCoreCompare = pc;
						powerCore.kill();
						powerCore = new FlxSprite(323, 27, p.img);
						powerCore.z = Registry.UI_Z_LEVEL_ELEMENTS;
						Registry.game.add(powerCore);
						
						powerCoreText.kill();
						powerCoreText = new FlxText(powerCoreStartX, powerCoreStartY, powerCoreAreaWidth, pc.name);
						powerCoreText.setFormat("DefaultFont", 8, 0xFFFFFF, "center");
						powerCoreText.z = Registry.UI_Z_LEVEL_ELEMENTS + 100;
						Registry.game.add(powerCoreText);						
					}
					else if (!powerCoreCompare)
					{						
						powerCoreCompare = pc;						
						powerCore = new FlxSprite(323, 27, p.img);
						powerCore.z = Registry.UI_Z_LEVEL_ELEMENTS;
						Registry.game.add(powerCore);
						
						powerCoreText = new FlxText(powerCoreStartX, powerCoreStartY, powerCoreAreaWidth, pc.name);
						powerCoreText.setFormat("DefaultFont", 8, 0xFFFFFF, "center");
						powerCoreText.z = Registry.UI_Z_LEVEL_ELEMENTS + 100;
						Registry.game.add(powerCoreText);
					}
				}
				else if (powerCore)
				{
					// The player is not holding a PowerCore, but the image is still showing.
					powerCoreCompare = null;
					powerCore.kill();
					powerCoreText.kill();
				}
			}
		}
		
		protected var previousSpecialItem:SpecialItem;
		protected var specialItem:SpecialItem;
		protected var uiBoxWidth:int = 60;
		protected var uiBoxXStart:int = 248;		
		
		public function updateSpecialItemUI():void
		{
			if (Registry.player)
			{
				previousSpecialItem = specialItem;
				specialItem = Registry.player.specialItem;
				
				var width:int;
				var difference:int;
				var amountToIncrease:int;
				
				if (specialItem && !specialItemUI)
				{					
					specialItemUI = new FlxSprite(uiBoxXStart, 17, specialItem.image, 1);
					specialItemUI.z = Registry.UI_Z_LEVEL_ELEMENTS;
					
					Registry.game.add(specialItemUI);
					
					width = specialItem.width;
					difference = uiBoxWidth - width;
					amountToIncrease = difference / 2;
					specialItemUI.x = uiBoxXStart + amountToIncrease;					
				}
				else if (specialItem && specialItemUI && (specialItem != previousSpecialItem))
				{					
					specialItemUI.loadGraphic(specialItem.image);	
					
					// update x and y to ensure that image is centred.
					// get the width of the image					
					width = specialItem.width;
					difference = uiBoxWidth - width;
					amountToIncrease = difference / 2;
					specialItemUI.x = uiBoxXStart + amountToIncrease;
				}
				
				if (!specialItem && specialItemUI)
				{
					specialItemUI.kill();
					specialItemUI = null;
				}
			}
		}
		
		/**
		 * This updates every cycle, potential performance bottleneck.
		 */
		public function updateWeaponUI():void
		{
			if (Registry.player)
			{				
				var weapon:WeaponContainer = Registry.player.weapons[0];
				if (weapon && !weapon_1)
				{
					weapon_1 = new FlxSprite(142, 16, weapon.weaponImage, Registry.UI_Z_LEVEL_ELEMENTS);
					Registry.game.add(weapon_1);	
				}
				else if (!weapon && weapon_1)
				{
					weapon_1.kill();
					weapon_1 = null;
				}
				
				weapon = Registry.player.weapons[1];
				if (weapon && !weapon_2)
				{
					weapon_2 = new FlxSprite(178, 15, weapon.weaponImage, Registry.UI_Z_LEVEL_ELEMENTS);
					Registry.game.add(weapon_2);
				}
				else if (!weapon && weapon_2)
				{
					weapon_2.kill();
					weapon_2 = null;
				}
				
				weapon = Registry.player.weapons[2];
				if (weapon && !weapon_3)
				{
					weapon_3 = new FlxSprite(212, 15, weapon.weaponImage, Registry.UI_Z_LEVEL_ELEMENTS);
					Registry.game.add(weapon_3);
				}
				else if (!weapon && weapon_3)
				{
					weapon_3.kill();
					weapon_3 = null;
				}
				
				
			}
		}
		
		/**
		 * This updates every cycle, potential performance bottleneck.
		 */
		public function updateCreditsText():void
		{
			if (Registry.player)
			{
				if (creditsText.text != Registry.player.credits.toString())
				{
					creditsText.text = "x " + Registry.player.credits.toString();
				}
			}
		}
		
		/**
		 * This updates every cycle, potential performance bottleneck.
		 */
		public function updateStageText():void
		{
			if (Registry.stage)
			{
				if (stageText.text != Registry.stage.level.toString())
				{
					stageText.text = Registry.stage.level.toString();
				}
			}			
		}
			
		/**
		 * This updates every cycle, potential performance bottleneck.
		 */
		public function updateWaveText():void
		{			
			if (Registry.stage)
			{
				if (waveText.text != Registry.stage.waveCount.toString())
				{
					var waveString:String;
					if (Registry.stage.waveCount.toString().localeCompare("11") == 0) { waveString = "shop"; }
					else { waveString = Registry.stage.waveCount.toString(); }
					waveText.text = waveString;
				}
			}
		}
	
		
		
	}

}