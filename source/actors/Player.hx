package actors;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author MrCdK
 */
class Player extends Actor
{

	public var emitter:FlxEmitterExt;
	
	public var diffuse:FlxSprite;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		ID = Reg.PLAYER_ID;
		
		loadGraphic("assets/images/player.png", true, true, 32, 32);
		addAnimation("idle", [0, 1, 2, 1], 1, true);
		addAnimation("walk", [3, 4, 5], 5, true);
		addAnimation("run", [3, 4, 5], 8, true);
		addAnimation("jump", [6], 1, true);
		addAnimation("jump_m", [7], 1, true);
		addAnimation("fall", [8], 1, true);
		addAnimation("fall_m", [9], 1, true);
		
		emitter = new FlxEmitterExt();
		emitter.setRotation(0, 360);
		emitter.setMotion(0, 8, 0.2, 360, 100, 1.8);
		emitter.makeParticles("assets/images/blood_particle.png", 100, 0, true, 0);
		emitter.setAlpha(1, 1, 0, 0);
		emitter.gravity = 800;
		
		diffuse = new FlxSprite(0, 0);
		diffuse.loadGraphic("assets/images/diff.png", true, false, 64, 64);
		diffuse.addAnimation("idle", [0, 1], 10, true);
		diffuse.play("idle");
		diffuse.exists = false;
	}
	
	public function ninjaCollision():Bool {
		this.health = Math.max(0, health - coins);
		if (coins > 0) {
			FlxG.sound.play("assets/sounds/give_coins.wav");
		}
		coins = 0;
		return (health <= 0);
	}
	
	public function womanCollision(power:Int):Int {
		FlxG.sound.play("assets/sounds/oh_yeah.wav");
		diffuse.exists = true;
		controllable = false;
		acceleration.x = 0;
		velocity.x = 0;
		var p:Int = Std.int(Math.abs(power - coins));
		this.health += p;
		this.coins = Std.int(Math.max(0, (coins - p)));
		return p;
	}
	
	override public function update():Void 
	{
		emitter.x = x + _halfWidth;
		emitter.y = y + height - 3;
		
		diffuse.x = x + _halfWidth - diffuse._halfWidth;
		diffuse.y = y + _halfHeight- diffuse._halfHeight;
		
		super.update();
	}
	
	override private function boundBottom():Void 
	{
		var state:IMyGame = null;
		if (Std.is(FlxG.state, IMyGame)) {
			state = cast(FlxG.state, IMyGame);
		}
		
		if (state != null) {
			state.lose("You can't die this way!");
		}
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		emitter = null;
		diffuse = null;
	}
	
	override public function kill():Void 
	{		
		if (!alive)
		{
			return;
		}
		
		super.kill();
		FlxG.cameras.shake(0.005, 0.35);
		FlxG.cameras.flash(0xffDB3624, 0.35);
		FlxG.sound.play("assets/sounds/die.wav");
		if (emitter != null) {
			emitter.at(this);
			emitter.start(true, 2, 0, 400);
		}
	}
	
	override private function playNormalJumpSound():Void 
	{
		FlxG.sound.play("assets/sounds/jump.wav");
	}
	
	override private function playWallJumpSound():Void 
	{
		FlxG.sound.play("assets/sounds/jump.wav");
	}
}