package substates;
import flixel.FlxG;

/**
 * ...
 * @author MrCdK
 */
class PauseSubState extends BaseSubState
{
	
	public function new(BGColor:Int=0x00000000, TextColor:Int = 0xFFFFFF, TextShadow:Int = 0xFF0000FF, UseMouse:Bool=false)  
	{
		super(BGColor, TextColor, TextShadow, UseMouse);
	}
	
	override public function create():Void 
	{
		super.create();
		trollStrings.push("I'm ready to die!");
		trollStrings.push("Don't get close to the girl!");
		trollStrings.push("Pr0tip: Don't get health!");
		trollStrings.push("Press R anytime to restart the level");
		trollStrings.push("Coins, coins! make ninja happy!");
		trollStrings.push("The ONLY way to die is paying the ninja!");
	}
	
	override public function tryUpdate():Void 
	{
		if (FlxG.keyboard.anyJustPressed(["ESCAPE"])) {
			this.close(false);
		}
		
		if (FlxG.keyboard.anyJustPressed(["R"])) {
			FlxG.resetState();
		}
		
		super.tryUpdate();
	}
	
}