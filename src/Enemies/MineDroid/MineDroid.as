package Enemies.MineDroid 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MineDroid extends Enemy
	{
		[Embed (source = "../../../assets/mineDroid.png")] protected var minedroidSprite:Class;		
		protected const HEALTH:int = 10;
		protected const WIDTH:int = 27;			
		
		public var _direction:String;
		
		public function MineDroid(_ai:Boolean = true, _x:Number = 0, _y:Number = 0, direction:String = "RIGHT") 
		{
			if (!_x) { _x = Math.abs(Registry.RIGHT_BOUNDS - WIDTH) * Math.random(); }
			if (!_y) { _y = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS; }
			super(_x, _y, 0);
			
			armour = HEALTH;			
			
			_direction = direction;			
			
			image = loadGraphic(minedroidSprite, true, false, 30, 23);		
			
			var graphic:FlxSprite = image;
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
			
			addAnimation("minedroidSprite", array, 60, true);
			this.play("minedroidSprite");
			
			if (_ai)
			{
				var self:MineDroid = this;
				startTelprot(this, function():void {
					self.ai = new MineDroidAI(self);
				});
			}
		}
		
		override public function update():void
		{
			super.update(); 
			
			if (this.touching & UP && this._direction == "UP") { this._direction = "DOWN"; }
			if (this.touching & RIGHT && this._direction == "RIGHT") { this._direction = "LEFT"; }
			if (this.touching & DOWN && this._direction == "DOWN") { this._direction = "UP"; }
			if (this.touching & LEFT && this._direction == "LEFT") { this._direction = "RIGHT"; }
		}
	}

}