package Enemies.Brain 
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import com.greensock.TweenMax;
	
	import Enemies.BrainMissile.BrainMissile;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BrainAI extends AI 
	{
		protected var unit:Enemy;
		protected var targetX:int;
		protected var targetY:int; 
		
		protected var moveTimer:int = 2000;		
		protected var speed:int = 10;
		
		protected var _fireIntervalId:Number;
		protected var _moveIntervalId:Number;
		
		protected var _rightAngledIncrement:Boolean = true;
		
		public function BrainAI(_unit:Unit) 
		{
			super();			
			unit = Enemy(_unit);
			
			this.unit.drag.x = 0;
			this.unit.drag.y = 0;
			
			_fireIntervalId = setInterval(fire, 5000);
			Registry.intervals.push(_fireIntervalId);
		}
		
		/**
		 * All of the AI updates go here, any changes to the unit
		 * go here also.
		 */
		override public function update():void
		{				
			
		}
		
		//protected var moved:Boolean = false;
		protected function moveThis():void
		{			
			//var _angle:int = (unit.angle + 45) % 360;
			//TweenMax.to(this.unit, 0.3, { angle: _angle } );
			
			//_rightAngledIncrement = !_rightAngledIncrement;
		}
		
		protected var intervalId:Number;
		protected var numberOfTimes:int;
		protected var maxNumberOfTimes:int = 3;
		protected var animId:Number;
		protected function fire():void
		{			
			var _this:BrainAI = this;
			if (!Registry.game.pausedState.isShowing) {
				// Update the sprite.
				_this.unit.image.frame = 1;
				
				setTimeout(function():void {
					_this.unit.image.frame = 0;
					
					// Create a new BrainMissile
					var brainMissile:BrainMissile = new BrainMissile(false, _this.unit.x, _this.unit.y);
					Registry.game.add(brainMissile);
					Registry.game.otherItems.add(brainMissile);
					
					animId = setTimeout(function():void {
						_this.unit.image.frame = 2;
						Registry.intervals.push(animId);
					}, 1000);
				}, 500);												
				
				// Update the sprite.
				//_this.unit.image.frame = 0;								
			}			
		}
		
		override public function removeThis():void
		{
			unit = null;
			this.kill();
			clearInterval(_fireIntervalId);
			Registry.intervals.splice(_fireIntervalId, 1);
			clearInterval(_moveIntervalId);
			Registry.intervals.splice(_moveIntervalId, 1);
			clearInterval(animId);
			Registry.intervals.splice(animId, 1);
		}
	}

}