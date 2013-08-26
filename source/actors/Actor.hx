package actors;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;

/**
 * ...
 * @author MrCdK
 */
class Actor extends FlxSprite
{
	private static inline var JUMP_FORCE:Float = 100.0;
	
	private static inline var WALK_VELOCITY:Float = 160.0;
	private static inline var RUN_VELOCITY:Float = 320.0;
	
	private static inline var NORMAL_Y_VELOCITY:Float = 450.0;
	private static inline var WALL_Y_VELOCITY:Float = 100.0;
	
	public var coins:Int = 0;
	
	public var controllable:Bool = false;
	var normalJump:Bool = false;
	var touchingFloor:Bool = false;
	var touchingWall:Bool = false;
	var wallJump:Bool = false;
	private var _jumpAcc:Float;
	
	public var maxBounds:FlxRect;
	
	public var objToFollow:FlxObject;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		maxVelocity.x = WALK_VELOCITY;
		maxVelocity.y = NORMAL_Y_VELOCITY;
		acceleration.y = 800;
		drag.x = RUN_VELOCITY * 4;
		
		ID = -1;
		health = 1;
		_jumpAcc = JUMP_FORCE;
	}
	
	override public function update():Void 
	{	
		resetVelocities();
		
		if (controllable) {
			// MOVE LEFT OR RIGHT
			acceleration.x = 0;
			if (FlxG.keyboard.anyPressed(["LEFT"])) {
				acceleration.x = -drag.x;
			} else if (FlxG.keyboard.anyPressed(["RIGHT"])) {
				acceleration.x = drag.x;
			}
			
			// RUN
			if (FlxG.keyboard.anyPressed(["A"]) && (!normalJump && !wallJump)) {
				maxVelocity.x = RUN_VELOCITY;
			}
			if (FlxG.keyboard.anyJustReleased(["A"])) {
				maxVelocity.x = WALK_VELOCITY;
			}
			
			//JUMP
			if (FlxG.keyboard.anyJustPressed(["S"])) {
				if (!normalJump && touchingFloor) { // normal jump
					normalJump = true;
					touchingFloor = false;
					playNormalJumpSound();
				}
				if (touchingWall && !touchingFloor) { // wall jump
					wallJump = true;
					playWallJumpSound();
				}
			}
			if (FlxG.keyboard.anyJustReleased(["S"]) && normalJump) {
				normalJump = false;
			}
		}
		
		computeJumpVelocities();
		
		if (objToFollow != null) {
			x = objToFollow.x;
			y = objToFollow.y;
		}
		
		if (velocity.x > 0) {
			facing = FlxObject.RIGHT;
		} else if (velocity.x < 0) {
			facing = FlxObject.LEFT;
		}
		
		play(selectAnimation());
		
		keepInBounds();
		
		super.update();
	}
	
	public function follow(obj:FlxObject):Void {
		objToFollow = obj;
	}
	
	private function selectAnimation():String {
		var anim:String = "idle";
		if (velocity.x != 0) {
			if (maxVelocity.x == RUN_VELOCITY) {
				anim = "run";
			} else {
				anim = "walk";
			}
		}
		
		if (velocity.y > 0) {
			if (touchingWall || velocity.x != 0) {
				anim = "fall_m";
			} else {
				anim = "fall";
			}
		} else if (velocity.y < 0) {
			if (touchingWall || velocity.x != 0) {
				anim = "jump_m";
			} else {
				anim = "jump";
			}
		}
		
		return anim;
	}
	
	private function resetVelocities():Void {
		if (justTouched(FlxObject.DOWN)) {
			normalJump = false;
			touchingFloor = true;
			_jumpAcc = JUMP_FORCE;
		}
		
		touchingWall = isTouching(FlxObject.WALL) || wasTouching == FlxObject.WALL;
		
		if (touchingWall) {
			maxVelocity.y = WALL_Y_VELOCITY;
		} else {
			maxVelocity.y = NORMAL_Y_VELOCITY;
		}		
	}
	
	private function computeJumpVelocities():Void {
		if (normalJump && !touchingFloor) {
			velocity.y = -_jumpAcc;
			_jumpAcc += JUMP_FORCE;
			if (_jumpAcc >= maxVelocity.y) {
				normalJump = false;
			}
		}
		
		if (wallJump) {
				maxVelocity.y = NORMAL_Y_VELOCITY;
				acceleration.x = -acceleration.x * JUMP_FORCE;
				velocity.y = -NORMAL_Y_VELOCITY * 0.75;
				wallJump = false;
		}		
	}
	
	private function keepInBounds():Void {
		if (maxBounds == null) {
			return;
		}
		
		if (x < maxBounds.x)
		{
			boundLeft();
		}
		else if ((x + width) > (maxBounds.x + maxBounds.width))
		{
			boundRight();
		}

		if (y < maxBounds.y)
		{
			boundTop();
		}
		else if ((y + height) > (maxBounds.y + maxBounds.height))
		{
			boundBottom();
		}
	}
	
	private function boundLeft():Void {
		x = maxBounds.x;
		acceleration.x = 0;
	}
	
	private function boundRight():Void {
		x = (maxBounds.x + maxBounds.width) - width;
		acceleration.x = 0;
	}
	
	private function boundBottom():Void {
		y = (maxBounds.y + maxBounds.height) - height;
		acceleration.y = 0;
	}
	
	private function boundTop():Void {
		y = maxBounds.y;
		acceleration.y = 0;
	}
	
	private function playNormalJumpSound():Void {
		
	}
	
	private function playWallJumpSound():Void {
		
	}
}