package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		protected var powerCoreCompare:PowerCore;
		protected var specialItemUI:FlxSprite;
		
		protected var chargeBarUI:FlxSprite;
		protected var chargeBar:FlxSprite;	
		protected const CHARGE_X:int = 243;
		protected const CHARGE_Y:int = 10;
		
		protected const TEXT_X:int = 60;
		
		protected var waveText:FlxText;
		protected const WAVE_TEXT_Y:int = 10;
		
		protected var creditsText:FlxText;
		protected const CREDITS_TEXT_X:int = 390;
		protected const CREDITS_TEXT_Y:int = 13;
		
		protected const BASE_WAVE_TEXT:String = "wave: ";
		
		protected const BASE_STAGE_TEXT:String = "stage: ";
		protected const STAGE_TEXT_Y:int = 45;
		
		protected var healthBar:FlxSprite;
		protected var healthBarText:FlxText;
		protected const ARMOUR_BAR_CONTAINER_START_X:int = 400;
		protected const ARMOUR_BAR_START_Y:int = 25;
		protected const ARMOUR_BAR_CONTAINER_END_X:int = ARMOUR_BAR_CONTAINER_START_X + 230;	
		
		protected var shieldBar:FlxSprite;
		protected var shieldText:FlxText;
		protected const SHIELD_BAR_CONTAINER_START_X:int = ARMOUR_BAR_CONTAINER_END_X + 10;
		protected const SHIELD_BAR_START_Y:int = ARMOUR_BAR_START_Y;
		protected const SHIELD_BAR_CONTAINER_END_X:int = SHIELD_BAR_CONTAINER_START_X + 30;						
		
		public function UI() 
		{
			super();
			
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
			stageText.scale.x = 2;
			stageText.scale.y = 2;
			stageText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(stageText);
			
			// Add wave information.
			waveText = new FlxText(TEXT_X, WAVE_TEXT_Y, 50);
			waveText.text = BASE_WAVE_TEXT;
			waveText.scale.x = 2;
			waveText.scale.y = 2;
			waveText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(waveText);
			
			// Add credits information.
			creditsText = new FlxText(CREDITS_TEXT_X, CREDITS_TEXT_Y, 50);
			creditsText.scale.x = 2;
			creditsText.scale.y = 2;
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
			healthBarText.scale.x = 2;
			healthBarText.scale.y = 2;
			healthBarText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(healthBarText);
			healthBarText.alignment = "center";
			
			// Add shield information.
			shieldBar = new FlxSprite(SHIELD_BAR_CONTAINER_START_X, SHIELD_BAR_START_Y);
			Registry.game.add(shieldBar);
			hwidth = SHIELD_BAR_CONTAINER_END_X - SHIELD_BAR_CONTAINER_START_X;
			shieldText = new FlxText(SHIELD_BAR_CONTAINER_START_X + (hwidth / 2) + 4, SHIELD_BAR_START_Y + 2, 25, Registry.player.shields.toString());
			shieldText.scale.x = 2;
			shieldText.scale.y = 2;
			shieldText.z = Registry.UI_TEXT_Z_LEVEL;
			Registry.game.add(shieldText);
			updatePlayerBars();
			
			// Add charge bar information.
			//chargeBar = new FlxSprite(CHARGE_X, CHARGE_BAR_CONTAINER_START_Y)
			//chargeBar.z = Registry.UI_Z_LEVEL_CHARGE_BAR;			
			//chargeBar.makeGraphic(12, CHARGE_BAR_CONTAINER_START_Y - CHARGE_BAR_CONTAINER_END_Y);
			//Registry.game.add(chargeBar);
			
			chargeBar = new FlxSprite(CHARGE_X, CHARGE_Y);
			chargeBar.z = Registry.UI_Z_LEVEL_CHARGE_BAR;
			chargeBar.makeGraphic(60, 60);
			chargeBar.alpha = 0.0;
			Registry.game.add(chargeBar);
			
			// Add special item charge information.
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
				healthBar.makeGraphic(currentArmourWidth, 30, 0xFF880000);
				if (currentArmourWidth < targetArmourWidth)
				currentArmourWidth = targetArmourWidth
				healthBar.makeGraphic(currentArmourWidth, 30, 0xFF880000);
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
			shieldBar.makeGraphic(SHIELD_BAR_CONTAINER_END_X - SHIELD_BAR_CONTAINER_START_X, 30, 0xFF5555AA);
			var hwidth:int = SHIELD_BAR_CONTAINER_END_X - SHIELD_BAR_CONTAINER_START_X;
			
			if (Registry.player.shields > 9)
			{				
				shieldText.x = SHIELD_BAR_CONTAINER_START_X + (hwidth / 2) - 1
			}
			else
			{
				shieldText.x = SHIELD_BAR_CONTAINER_START_X + (hwidth / 2) + 4
			}
			
			if (Registry.player.shields < 1)
			{
				shieldBar.makeGraphic(SHIELD_BAR_CONTAINER_END_X - SHIELD_BAR_CONTAINER_START_X, 25, 0xFF333333);
			}
		
		}
		
		protected var previousChargeVal:int;
		public function setChargeBar():void
		{			
			var stepIncrease:Number = 1.0 / Registry.player.MAX_CHARGE;
			
			if (Registry.player)
			{				
				if (previousChargeVal < Registry.player.chargeBarNumber)
				{
					// Increase intensity
					if (chargeBar.alpha + stepIncrease > 1.0)
					{
						chargeBar.alpha = 1.0;
					}
					else
					{
						chargeBar.alpha += stepIncrease;	
					}
				}
				else if (previousChargeVal > Registry.player.chargeBarNumber)
				{
					chargeBar.alpha = 0.0;
				}
			}		
			
			previousChargeVal = Registry.player.chargeBarNumber;
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
						powerCore = new FlxSprite(191, 3, p.img);
						powerCore.z = Registry.UI_Z_LEVEL_ELEMENTS;
						Registry.game.add(powerCore);
					}
					else if (!powerCoreCompare)
					{						
						powerCoreCompare = pc;						
						powerCore = new FlxSprite(191, 3, p.img);
						powerCore.z = Registry.UI_Z_LEVEL_ELEMENTS;
						Registry.game.add(powerCore);
					}
				}
				else if (powerCore)
				{
					// The player is not holding a PowerCore, but the image is still showing.
					powerCore.kill();
				}
			}
		}
		
		public function updateSpecialItemUI():void
		{
			if (Registry.player)
			{
				var specialItem:SpecialItem = Registry.player.specialItem;
				if (specialItem && !specialItemUI)
				{
					specialItemUI = new FlxSprite(145, 3, specialItem.image, 1);
					Registry.game.add(specialItemUI);
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
					weapon_1 = new FlxSprite(144, 15, weapon.weaponImage, Registry.UI_Z_LEVEL_ELEMENTS);
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
					creditsText.text = Registry.player.credits.toString();
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
					stageText.text = BASE_STAGE_TEXT + Registry.stage.level.toString();
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
					else { waveString = BASE_WAVE_TEXT + Registry.stage.waveCount.toString(); }
					waveText.text = waveString;
				}
			}
		}
	
		
		
	}

}