package actors;

import flixel.addons.display.FlxGridOverlay;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * ...
 * @author MrCdK
 */
class Clock extends FlxSprite
{
	public var time:Float = 0;

	public function new(X:Float = 0, Y:Float = 0, Time:Float = 0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		time = Time;
		
		loadGraphic("assets/images/clock.png", false, false, 24, 24);
		
		offset.set(4, 4);
		width = 20;
		height = 20;
	}
	
	override public function kill():Void 
	{
		super.kill();
		FlxG.sound.play("assets/sounds/tictac.wav");
	}
}