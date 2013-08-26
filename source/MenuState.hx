package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		//FlxG.mouse.show();
		#end
		
		FlxG.sound.playMusic("assets/music/menu.mp3");
		
		var title:FlxSprite = new FlxSprite(0, 0, "assets/images/title.png");
		add(title);
		//load levels
		Reg.levels.push("assets/maps/level1.tmx");
		Reg.levels.push("assets/maps/level2.tmx");
		Reg.levels.push("assets/maps/level3.tmx");
		Reg.levels.push("assets/maps/level4.tmx");
		Reg.levels.push("assets/maps/level5.tmx");
		Reg.level = 0;
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keyboard.anyJustPressed(["ENTER"])) {
			FlxG.switchState(new PlayState());
		}
		
		super.update();
	}	
}