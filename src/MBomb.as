package  
{
	import flash.display.Shader;
	import mx.core.FlexSprite;
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Adam
	 */
	public class MBomb extends SpecialItem 
	{
		public static const RADIUS:int = 20;
		public static const DAMAGE:int = 10;
				
		
		public function MBomb(_x:int, _y:int, _shop:Boolean = false) 
		{			
			super(_x, _y, _shop);
			this.makeGraphic(10, 10);
			x = _x;
			y = _y;
		}

		override public function update():void
		{
			super.update();
		}			
		
		public function explode():void
		{
			var a:Array = Registry.enemies.members;
			var i:int;		

			for (i = 0; i < a.length; i++)
			{
				if (a[i])
				{	
					a[i].enemyHit(DAMAGE);	
				}
			}			
		}	
		
		override public function useSpecial():void
		{			
			if (Registry.player.chargeBarNumber >= Registry.player.MAX_CHARGE)
			{	
				explode();				
				super.useSpecial();
			}
		}
	}

}