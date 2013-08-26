package substates;
import flixel.FlxG;

/**
 * ...
 * @author MrCdK
 */
class LoseSubState extends BaseSubState
{

	
	
	public function new(BGColor:Int=0x00000000, TextColor:Int = 0xFFFFFF, TextShadow:Int = 0xFFFF00FF, UseMouse:Bool=false)  
	{
		super(BGColor, TextColor, TextShadow, UseMouse);
	}
	
	override public function create():Void 
	{
		super.create();
		
		trollStrings.push("I wanted to die :(");
		trollStrings.push("You can't let me live!");
		trollStrings.push("Pr0tip: Don't get health!");
		trollStrings.push("Get coins -> Pay ninja -> Die. It's easy, isn't it?");
		trollStrings.push(":_____");
	}
	
	override public function tryUpdate():Void 
	{
		if (FlxG.keyboard.anyJustPressed(["ENTER"])) {
			this.close(false);
		}
		super.tryUpdate();
	}
	
}