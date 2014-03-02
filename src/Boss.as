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
		
		override public function kill():void
		{
			if (Registry.game.timesHitByBoss <= 0) 
			{
				Registry.game.hitByBoss = false;
			}
			
			Registry.game.timesHitByBoss = 0;
			
			super.kill();
		}
	}

}