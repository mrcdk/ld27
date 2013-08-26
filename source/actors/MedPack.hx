package actors;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author MrCdK
 */
class MedPack extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		ID = Reg.MEDPACK_ID;
		
		loadGraphic("assets/images/medpack.png", false, false, 24, 24);
	}
	
	override public function kill():Void 
	{
		super.kill();
		FlxG.sound.play("assets/sounds/pick_medpack.wav");
	}
}