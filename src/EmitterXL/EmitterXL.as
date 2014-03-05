package EmitterXL 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.FlxBasic;
	import flash.utils.getQualifiedClassName;
	import org.flixel.plugin.photonstorm.FX.BlurFX;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import org.flixel.FlxG
	
	/**
	 * Extends the FLxEmitter class by providing some extra stuff like gradiented particles, rotation, random particle scaling, fading out of particles, etc.
	 * 
	 * @author Adam Cook
	 */
	public class EmitterXL extends FlxEmitter 
	{	
		protected var _fadeOut:Boolean;
		protected var _rotation:Boolean;
		protected var _gradient:Boolean;
		protected var _gradientStart:Number;
		protected var _gradientEnd:Number;
		protected var _blur:Boolean;
		protected var _menu:Boolean;
		
		public var rotationSpeed:Number = 10;
		public var blurry:BlurFX;
		public var blurEffect:FlxSprite;
		public var fadeOutSpeed:Number;
		
		
		
		/**
		 * Constructor
		 * 
		 * @param	x 		the initial x position of the emitter.
		 * @param	y		the initial y position of the emitter.
		 * @param	size	optional, specifies a maximum capacity for this emitter.
		 * @param	options	a k/v object, of the following:
		 *			gradientStart: {rgb colour, used to generate particle colours between start and end, default is 0x000000}
		 * 			gradientEnd: {rgb colour, used to generate particle colours between start and end, default is 0xFFFFFF}
		 * 			fadeOut: {boolean, should the particles fade out over time, default is false}
		 * 			rotation: {boolean, should the particles rotate?}
		 */
		public function EmitterXL(x:int = 0, y:int = 0, size:int = 0, options:Object = null) 
		{
			super(x, y, size);
			
			
			
			if (options)
			{
				_fadeOut = options.fadeOut || false;
				_rotation = options.rotation || false;
				_gradient = (options.gradientStart || options.gradientEnd) ? true : false;
				_gradientStart = options.gradientStart || 0xFFFFFF;
				_gradientEnd = options.gradientEnd || 0xFFFFFF;
				_blur = options.blur || false;
				_menu = options.menu || false;
				fadeOutSpeed = options.fadeOutSpeed || 0.002;
			}
			
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			
			if (_blur) 
			{
				blurry = FlxSpecialFX.blur();
				blurEffect = blurry.create(BoundSpace.SceneWidth, BoundSpace.SceneHeight, 2, 2, 1);			
			}
			
		}	

		override public function add(object:FlxBasic):FlxBasic
		{			
			if (getQualifiedClassName(object) === getQualifiedClassName(FlxParticle))
			{				
				// This is a particle we are adding. Set the appropriate shits.
				var particle:FlxParticle = FlxParticle(object);
				
				var red:Number = 0x000000;
				var green:Number = (Math.random() * 0x66) << 8;
				green += 0x11;
				var blue:Number = Math.random() * 0xAA;
				blue += 0x11;
				
				if (_menu) { particle.color = red + green + blue; }
				else
				{
					particle.color = 0x05E8DB;
				}
				
				if (_blur) { blurry.addSprite(particle); }
				
				var scales:Array = [0.25, 0.5, 1];
				var scaleChosen:int = Math.floor(Math.random() * 3);
				
				var scale:Number = scales[scaleChosen];
				
				particle.scale = new FlxPoint(scale, scale);
				
				return super.add(object);
			}				
			
			return super.add(object);
		}
		
		override public function update():void
		{						
			var i:int;
			if (this._rotation)
			{				
				for (i = 0; i < this.members.length; i++)
				{
					// If the particle is rotating one way, keep rotating it that way.
					var operation:Number = (this.members[i].angle > 0) ? 1 : -1
					
					this.members[i].angle += operation * (this.rotationSpeed * Math.random());
				}
			}
			
			if (this._fadeOut)
			{				
				for (i = 0; i < this.members.length; i++)
				{
					if (this.members[i].alive) 
					{
						this.members[i].alpha -= this.fadeOutSpeed;
						if (this.members[i].alpha <= 0) { this.members[i].exists = false; }
					}
				}
			}
			
			super.update();
		}
		
		override public function kill():void
		{
			FlxSpecialFX.clear();
			
			if (blurry)
			{
				blurry.stop();
				blurry.destroy();			
				blurEffect.kill();			
			}
			
			super.kill();
		}
	}
}