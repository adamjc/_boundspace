package  
{
	/**
	 * ...
	 * @author Adam
	 */
	public class Boss extends Enemy 
	{				
		public function Boss(X:Number = 0, Y:Number = 0, _weaponCooldown:Number = 1) 
		{
			super(X, Y, _weaponCooldown);
		}
		
		override public function update():void
		{
			super.update();
		}
	}

}