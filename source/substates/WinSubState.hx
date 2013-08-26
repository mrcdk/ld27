package substates;
import flixel.FlxG;

/**
 * ...
 * @author MrCdK
 */
class WinSubState extends BaseSubState
{

	public function new(BGColor:Int=0x00000000, TextColor:Int = 0xFFFFFF, TextShadow:Int = 0xFF00FF00, UseMouse:Bool=false)  
	{
		super(BGColor, TextColor, TextShadow, UseMouse);
	}
	
	override public function create():Void 
	{
		super.create();
		trollStrings.push("WIIIIIIIIIIIIN!!!!!!11!!!!");
		trollStrings.push("Yeah! I'm dead, baby!");
		trollStrings.push("Wait, so... I have to die to win?!?!?");
		trollStrings.push("Next level? There are more levels?!?!?!?");
		trollStrings.push("Coins, coins! make ninja happy!");
	}
	
	override public function tryUpdate():Void 
	{
		if (FlxG.keyboard.anyJustPressed(["ENTER"])) {
			this.close(false);
			return;
		}
		if(_parentState != null) {
			_parentState.update();
		}
		super.tryUpdate();
	}
	
	
}