package actors;

/**
 * ...
 * @author MrCdK
 */
class Ninja extends Actor
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		ID = Reg.NINJA_ID;
		
		loadGraphic("assets/images/ninja.png", true, true, 32, 32);
		addAnimation("idle", [0, 1, 2, 1], 1, true);
		addAnimation("walk", [3, 4, 5], 5, true);
		addAnimation("run", [3, 4, 5], 8, true);
		addAnimation("jump", [6], 1, true);
		addAnimation("jump_m", [7], 1, true);
		addAnimation("fall", [8], 1, true);
		addAnimation("fall_m", [8], 1, true);
	}
	
}