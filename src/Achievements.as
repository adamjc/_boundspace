package  
{
	import org.flixel.FlxSave;
 
	public class Achievements
	{
		private static var _save:FlxSave; //The FlxSave instance
		private static var _temp:uint = 0x0; //Holds level data if bind() did not work. This is not persitent, and will be deleted when the application ends
		private static var _loaded:Boolean = false; //Did bind() work? Do we have a valid SharedObject?
		
		/**
		 * Returns the number of achievements that the player has completed
		 */
		public static function get achievements():uint
		{
			//We only get data from _save if it was loaded properly. Otherwise, use _temp
			if (_loaded)
			{
				return _save.data.achievements;
			}
			else
			{
				return _temp;
			}
		}
		
		/**
		 * Sets the number of achievements that the player has completed
		 */
		public static function set achievements(value:uint):void
		{
			if (_loaded)
			{
				_save.data.achievements = value;
			}
			else
			{
				_temp = value;
			}
		}
 
		/**
		 * Setup Achievements
		 */
		public static function load():void
		{
			_save = new FlxSave();
			_loaded = _save.bind("myAchievementData");
			if (_loaded && _save.data.achievements == null)
			{
				_save.data.achievements = 0x0;
			}
		}
	}
}