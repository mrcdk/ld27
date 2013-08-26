package substates;
import flixel.FlxG;

/**
 * ...
 * @author MrCdK
 */
class ReadySubState extends BaseSubState
{

	public function new(BGColor:Int=0x00000000, TextColor:Int = 0xFFFFFF, TextShadow:Int = 0xFF000000, UseMouse:Bool=false)  
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
	}
	
	override public function tryUpdate():Void 
	{
		if (FlxG.keyboard.anyJustPressed(["ENTER"])) {
			this.close(false);
		}
		
		super.tryUpdate();
	}
}