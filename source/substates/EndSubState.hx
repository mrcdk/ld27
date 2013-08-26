package substates;
import flixel.FlxG;

/**
 * ...
 * @author MrCdK
 */
class EndSubState extends BaseSubState
{

	public function new(BGColor:Int=0x00000000, TextColor:Int = 0xFFFFFF, TextShadow:Int = 0xFF000000, UseMouse:Bool=false)  
	{
		super(BGColor, TextColor, TextShadow, UseMouse);
	}
	
	override public function create():Void 
	{
		super.create();
		trollStrings.push("Good work! Thanks for playing!!!");
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