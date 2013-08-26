package actors;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;

/**
 * ...
 * @author MrCdK
 */
class Woman extends Actor
{

	public var power:Int = 0;
	public var hasPower:Bool = true;
	public var destine:Float = 0;
	var path:FlxPath;
	
	public var fake:Bool = false;
	
	public function new(X:Float = 0, Y:Float = 0, Destine:Float = 0, Fake:Bool = false, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		ID = Reg.WOMAN_ID;
		fake = Fake;
		loadGraphic(!fake ? "assets/images/woman.png" : "assets/images/fake_ninja.png", true, true, 32, 32);
		addAnimation("idle", [0, 1, 2, 1], 1, true);
		addAnimation("walk", [3, 4, 5], 5, true);
		addAnimation("run", [3, 4, 5], 8, true);
		addAnimation("jump", [6], 1, true);
		addAnimation("jump_m", [7], 1, true);
		addAnimation("fall", [8], 1, true);
		addAnimation("fall_m", [8], 1, true);
		addAnimation("smoke", [9,10,11,10], 5, true);
		
		destine = Destine;
		
		var dest:FlxPoint = getMidpoint();
		dest.x += destine;
		path = FlxPath.start(this, [getMidpoint(), dest], maxVelocity.x, FlxPath.YOYO);
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	override private function selectAnimation():String 
	{
		if(hasPower) {
		return super.selectAnimation();
		} else {
			return "smoke";
		}
	}
	
	override private function boundBottom():Void 
	{
		
	}
}