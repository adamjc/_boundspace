package  
{
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxMath;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author Adam
	 */
	public class Unit extends FlxSprite 
	{
		public static const MAX_WEAPONS:int = 3;
		
		public var armour:int;
		public var maxArmour:int;
		public var image:FlxSprite; // used for weapons!
		public var shields:int;		
		public var speed:int;
		public var weapons:Array = new Array();				
				
		protected var aiReady:Boolean;		
		
		//public static var z:int = 0;
		
		[Embed(source = "../assets/enemy_bullet_shot.png")] protected static var enemyShot:Class;
		
		public function Unit(X:Number = 0, Y:Number = 0, SimpleGraphics:Class = null) 
		{			
			super(X, Y, SimpleGraphics, Registry.ENEMY_Z_LEVEL);
		}
				
		override public function update():void
		{
			super.update();
		}	
		
		public function getAngle():Number
		{
			var a:Number;
			var dx:Number = FlxG.mouse.x - (this.x + (this.width / 2));
			var dy:Number = FlxG.mouse.y - (this.y + (this.height / 2));
			a = Math.atan2(dy, dx);
			a = a * 180 / Math.PI;	
			return a + 90; 
		}		
		
		public function rotatePoint(pivot:FlxPoint, point:FlxPoint, _angle:Number):FlxPoint
		{
			var s:Number = Math.sin(_angle * Math.PI / 180);
			var c:Number = Math.cos(_angle * Math.PI / 180);
			
			point.x -= pivot.x
			point.y -= pivot.y
			
			var xnew:Number = point.x * c - point.y * s;
			var ynew:Number = point.x * s + point.y * c;			
			
			point.x = xnew + pivot.x;
			point.y = ynew + pivot.y;
			
			return point;
		}
		
		public function addWeapon(_type:String, _bulletSpeed:int, _fireRate:int, _damage:int):void
		{			
			var weapon:FlxWeapon = new FlxWeapon(_type, this.image, "x", "y", _damage);			
			weapon.setBulletSpeed(_bulletSpeed);
			weapon.setFireRate(_fireRate);
			weapon.makeImageBullet(100, enemyShot);
			this.weapons.push(weapon);	
		}		
		
		public static function getRandLineInsideLine(begin:int, innerLeft:int, innerRight:int, end:int):int
		{
			// choose X
			// randomly pick lhs or rhs
			var lhs:Boolean = FlxMath.chanceRoll();
			
			var randVal:int;
			
			if (lhs)
			{
				// select a random X value between the outerRect left X coord and the innerRect left X coord
				randVal = (innerLeft + begin) * Math.random();								
			}
			else
			{
				var randDiff:int = Math.abs(innerRight - end) * Math.random();
				randVal = randDiff + innerRight;
			}
			
			return randVal;
		}
		
		/**
		 * Generates x,y outside the screen co-ordinates. Used to spawning enemies in. Adds a tween. Has a dependency on transportComplete().
		 */
		public function spawnFromOutside():FlxPoint
		{
			var startX:Number = Unit.getRandLineInsideLine(Registry.ENEMY_SPAWN_POS_MIN, Registry.LEFT_BOUNDS, Registry.RIGHT_BOUNDS, Registry.ENEMY_SPAWN_POS_MAX);
			
			var endX:Number;
			
			if (startX <= 0)
			{
				endX = Math.abs(Registry.RIGHT_BOUNDS / 2) * Math.random();
			}
			else
			{
				endX = Registry.RIGHT_BOUNDS / 2 + Math.abs(Registry.RIGHT_BOUNDS / 2) * Math.random();
			}
			
			var startY:Number = Unit.getRandLineInsideLine(Registry.ENEMY_SPAWN_POS_MIN, Registry.TOP_BOUNDS, Registry.BOTTOM_BOUNDS, Registry.ENEMY_SPAWN_POS_MAX);
			//var endY:Number = ((Registry.BOTTOM_BOUNDS - Registry.TOP_BOUNDS) * Math.random()) + Registry.TOP_BOUNDS;			
			
			var endY:Number;
			
			
			
			if (startY < 0)
			{
				endY = Registry.BOTTOM_BOUNDS + (((Registry.TOP_BOUNDS - Registry.BOTTOM_BOUNDS) / 2) * Math.random());			
			}
			else
			{
				endY = Registry.BOTTOM_BOUNDS + (((Registry.TOP_BOUNDS - Registry.BOTTOM_BOUNDS) / 2) * Math.random());	 + Registry.TOP_BOUNDS;			
			}
			
			
			TweenLite.to(this, 2, {	x: endX, 
						y: endY, 
						onComplete: transportComplete, 
						ease: Quad.easeOut } );
						
			return new FlxPoint(startX, startY);
		}
		
		public function transportComplete():void
		{
			aiReady = true;
		}		
	}
}