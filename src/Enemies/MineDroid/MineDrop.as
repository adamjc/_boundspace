package Enemies.MineDroid 
{
	import org.flixel.FlxSprite
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MineDrop extends Enemy
	{
		[Embed (source = "../../../assets/mine-drop.png")] protected var mineDropSprite:Class;		
		
		public function MineDrop(_ai:Boolean = true, _x:Number = 0, _y:Number = 0) 
		{
			if (!_x) { _x = Math.abs(Registry.RIGHT_BOUNDS - 0) * Math.random(); }
			if (!_y) { _y = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS; }
			super(_x, _y, 0);
			this.z = Registry.ENEMY_Z_LEVEL - 1;
			armour = 1;	
			
			image = loadGraphic(mineDropSprite, true, false, 16, 15);		
			
			var graphic:FlxSprite = image;
			
			var array:Array = new Array();
			
			for (var i:int = 0; i < graphic.frames; i++)
			{
				array[i] = i+1;
			}
			
			addAnimation("mineDropSprite", array, 60, true);
			this.play("mineDropSprite");						
		}		
		
		override public function update():void
		{
			super.update();
			// handle player collision...
			if (FlxG.overlap(this, Registry.player))
			{				
				Registry.game.player.hit(1);
				this.kill();
			}			
			
		}
	}

}