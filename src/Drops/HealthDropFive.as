package Drops 
{
	/**
	 * ...
	 * @author ...
	 */
	public class HealthDropFive extends HealthDrop 
	{
		public function HealthDropFive(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, Z:int=0) 
		{
			super(X, Y, SimpleGraphic, Z);		
			this.val = 5;
			this.color = 0xFFCCCC;		
		}		
	}
}