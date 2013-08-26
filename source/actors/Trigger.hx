package actors;

import flixel.FlxObject;

/**
 * ...
 * @author MrCdK
 */
class Trigger extends FlxObject
{

	public var action:String = "start";
	public var to:Array<String>;
	public var triggered:Bool = false;
	
	public function new(To:Array<String>, Action:String = "", X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) 
	{
		super(X, Y, Width, Height);
		this.action = Action;
		this.to = To;
	}
	
}