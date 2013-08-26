package substates;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;

/**
 * ...
 * @author MrCdK
 */
class BaseSubState extends FlxSubState
{
	var textColor:Int;
	var textShadow:Int;
	
	var title:FlxText;
	var info:FlxText;
	var info2:FlxText;
	var trolling:FlxText;
	
	var trollStrings:Array<String>;
	
	var player:FlxSprite;
	
	public function new(BGColor:Int=0xAA333333, TextColor:Int = 0xFFFFFF, TextShadow:Int = 0x00000000, UseMouse:Bool=false) 
	{
		super(BGColor, UseMouse);
		textColor = TextColor;
		textShadow = TextShadow;
		trollStrings = new Array<String>();
	}
	
	override public function create():Void 
	{
		super.create();
		
		title = new FlxText(0, 0, FlxG.stage.stageWidth, " ", 48);
		title.y = (FlxG.stage.stageHeight / 2) -  (title.height / 2);
		title.color = textColor;
		title.shadow = textShadow;
		title.useShadow = true;
		title.alignment = "center";
		title.scrollFactor.set(0, 0);
		
		info2 = new FlxText(0, title.y + 75, FlxG.stage.stageWidth, " ", 24);
		info2.color = textColor;
		info2.shadow = textShadow;
		info2.useShadow = true;
		info2.alignment = "center";
		info2.scrollFactor.set(0, 0);
		
		info = new FlxText(0, info2.y + 75, FlxG.stage.stageWidth, " ", 20);
		info.color = textColor;
		info.shadow = textShadow;
		info.useShadow = true;
		info.alignment = "center";
		info.scrollFactor.set(0, 0);
		
		trolling = new FlxText(40, 0, FlxG.stage.stageWidth, " ", 16);
		trolling.y = FlxG.stage.stageHeight - trolling.height;
		trolling.color = textColor;
		trolling.shadow = textShadow;
		trolling.useShadow = true;
		trolling.scrollFactor.set(0, 0);
		
		player = new FlxSprite(0, FlxG.stage.stageHeight - 32);
		player.loadGraphic("assets/images/player.png", false, false, 32, 32, true);
		player.scrollFactor.set(0, 0);
		
		add(title);
		add(info);
		add(info2);
		add(player);
		add(trolling);
		
	}
	
	public function init(Title:String, Info:String):Void 
	{
		title.text = Title;
		info.text = Info;
		if(trollStrings.length > 0) {
			var r:Int = Std.int(Math.random() * trollStrings.length);
			trolling.text = trollStrings[r];
		}
	}
	
	public function why(why:String):Void {
		info2.text = why;
	}
	
	override public function tryUpdate():Void 
	{
		//super.tryUpdate();
	}
}