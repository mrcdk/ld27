package;

import flixel.util.FlxSave;

/**
* Handy, pre-built Registry class that can be used to store 
* references to objects and other things for quick-access. Feel
* free to simply ignore it or change it in any way you like.
*/
class Reg
{
	public static inline var PLAYER_ID:Int = 0;
	public static inline var PLATFORM_ID:Int = 1;
	public static inline var COIN_ID:Int = 2;
	public static inline var MEDPACK_ID:Int = 3;
	public static inline var NINJA_ID:Int = 4;
	public static inline var WOMAN_ID:Int = 5;
	
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	static public var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	static public var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	static public var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	static public var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	static public var saves:Array<FlxSave> = [];
	/**
	 * Generic container for a <code>FlxSave</code>. You might want to 
	 * consider assigning <code>FlxG._game._prefsSave</code> to this in
	 * your state if you want to use the same save flixel uses internally
	 */
	static public var save:FlxSave;
}