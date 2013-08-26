package actors;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author MrCdK
 */
class Coin extends FlxSprite
{

	public var count:Bool = true;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		ID = Reg.COIN_ID;
		
		loadGraphic("assets/images/coin3.png", true, false, 24, 24);
		addAnimation("idle", [0, 1], 4, true);
		play("idle");
		
		offset.set(4, 4);
		width = 20;
		height = 20;
	}
	
	override public function kill():Void 
	{
		super.kill();
		FlxG.sound.play("assets/sounds/pick_coin.wav");
	}
}