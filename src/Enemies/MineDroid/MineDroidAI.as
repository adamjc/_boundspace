package Enemies.MineDroid 
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MineDroidAI extends AI 
	{
		protected var unit:Enemy;
		protected var targetX:int;
		protected var targetY:int; 
		
		protected var moveTimer:int = 2000;		
		protected var speed:int = 100;
		
		protected var _fireIntervalId:Number;
		protected var _moveIntervalId:Number;
		
		public function MineDroidAI(_unit:Unit) 
		{
			super();
			unit = Enemy(_unit);
			_moveIntervalId = setInterval(moveThis, 1000);
			Registry.intervals.push(_moveIntervalId);
		}
			
		protected var moved:Boolean = false;
		protected function moveThis():void
		{			
			// need to find out what direction we're supposed to be going in...
			switch (MineDroid(unit)._direction)
			{
				case "UP":
					TweenMax.to(unit, 0.5, { angle: 270 } );
					if (!unit.velocity.x && !unit.velocity.y) { this.fire(); unit.velocity.y = -speed; }
					else { unit.velocity.y = 0; }
					if (this.touching & UP) { MineDroid(unit)._direction = "RIGHT"; }
					break;
				case "DOWN":
					TweenMax.to(unit, 0.5, { angle: 90 } );
					if (!unit.velocity.x && !unit.velocity.y) { this.fire(); unit.velocity.y = speed; }
					else { unit.velocity.y = 0; }
					if (this.touching & DOWN) { MineDroid(unit)._direction = "LEFT"; }
					break;
				case "LEFT":
					TweenMax.to(unit, 0.5, { angle: 180 } );
					if (!unit.velocity.x && !unit.velocity.y) { this.fire(); unit.velocity.x = -speed; }
					else { unit.velocity.x = 0; }
					
					break;
				case "RIGHT":
					TweenMax.to(unit, 0.5, { angle: 0 } );
					if (!unit.velocity.x && !unit.velocity.y) { this.fire(); unit.velocity.x = speed; }
					else { unit.velocity.x = 0; }
					if (this.touching & RIGHT) { MineDroid(unit)._direction = "DOWN"; }
					break;
			}
			
			if (this.touching)
			{
				MineDroid(unit)._direction
			}
		}
		
		public function fire():void
		{
			if (!Registry.game.pausedState.isShowing) {
				// drop a mother fucking mine.
				var mine:MineDrop = new MineDrop(false, unit.x + unit.width / 2, unit.y + 5);
				Registry.game.add(mine);
				Registry.game.otherItems.add(mine);
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
		}
	}

}