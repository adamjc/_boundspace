package  
{
	import flash.display.Shader;
	import mx.core.FlexSprite;
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	import flash.display.Shape;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class SuperMissile extends SpecialItem 
	{
		public static const RADIUS:int = 20;
		public static const DAMAGE:int = 10;
				
		[Embed (source = "../assets/super-missile-pickup.png")] protected var sprite:Class;
		
		public function SuperMissile(_x:int, _y:int, _shop:Boolean = false) 
		{			
			super(_x, _y, _shop);
			this.loadGraphic(sprite);
			x = _x;
			y = _y;
			
			this.image = sprite;
			this.scale.x = 0.6;
			this.scale.y = 0.6;
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
				var missile:SuperMissileShot = new SuperMissileShot(Registry.player.x, Registry.player.y);
				Registry.game.add(missile);				
			}
			
			super.useSpecial();
		}
	}

}