package ;
import flixel.util.FlxTimer;

/**
 * ...
 * @author MrCdK
 */
interface IMyGame
{

	public function win():Void;
	public function lose(why:String):Void;
	public function getMainTimer():FlxTimer;
	public function stopTimerFor(time:Float, ?endCallback:Void->Void):Void;
	
}