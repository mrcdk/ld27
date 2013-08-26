package actors;

import flixel.effects.particles.FlxParticle;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;

/**
 * ...
 * @author MrCdK
 */
class Platform extends FlxSprite
{
	public static inline var HORIZONTAL:Int = 0;
	public static inline var VERTICAL:Int = 1;
	
	
	public var direction:Int;
	public var distance:Float;
	public var vel:Float;
	public var mode:Int = FlxPath.FORWARD;
	public var path:FlxPath;
	
	public function new(X:Float = 0, Y:Float = 0, Width:Int = 0, Height:Int = 0, Start:Bool = false, Velocity:Float = 0, Distance:Float = 0, Direction:Int = HORIZONTAL, Mode:Int = FlxPath.FORWARD) 
	{
		super(X, Y);
		
		ID = Reg.PLATFORM_ID;
		immovable = true;
		
		this.direction = Direction;
		this.vel = Velocity;
		this.distance = Distance;
		this.mode = Mode;
		
		//helper sprite
		var s:FlxSprite = new FlxSprite(0, 0);
		s.loadGraphic("assets/maps/tileset.png", false, false, 32, 32);
		
		makeGraphic(Width, Height, FlxColor.TRANSPARENT);
		
		var t:Int = 0;
		while (t <= Width) {
			s.frame = Std.int(Math.random() * 2) + 1;
			this.stamp(s, t, 0);
			t += 32;
		}
		
		if (Start) {
			startPath();
		}
	}
	
	public function startPath():Void {
		var dest:FlxPoint = getMidpoint();
		if(direction == HORIZONTAL) {
			dest.x += distance;
		} else {
			dest.y += distance;
		}
		path = FlxPath.start(this, [getMidpoint(), dest], vel, mode);
	}
	
	public function pausePath():Void {
		path.paused = true;
	}
	
	
}