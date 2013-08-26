package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import map.Level;
import substates.EndSubState;
import substates.LoseSubState;
import substates.PauseSubState;
import substates.ReadySubState;
import substates.WinSubState;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState implements IMyGame
{
	
	var level:Level;
	
	public var mainTimer:FlxTimer;
	var timerText:FlxText;
	var healthText:FlxText;
	var coinsText:FlxText;
	var gameOver:Bool = false;
	var gameWin:Bool = false;
	var whyLose:String = " ";
	
	var winSubState:WinSubState;
	var pauseSubState:PauseSubState;
	var readySubState:ReadySubState;
	var loseSubState:LoseSubState;
	var endSubState:EndSubState;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xFFCCCCCC;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		//FlxG.mouse.show();
		#end
		

		FlxG.sound.playMusic("assets/music/music.mp3");

		
		mainTimer = FlxTimer.start(10.0, timeOut);
		mainTimer.paused = true;
		
		level = new Level(Reg.levels[Reg.level], this);
		
		add(level.backgroundGroup);
		add(level.eventsGroup);
		add(level.triggersGroup);
		add(level.coinsGroup);
		add(level.medpacksGroup);
		add(level.clocksGroup);
		add(level.player);
		add(level.player.emitter);
		add(level.player.diffuse);
		add(level.foregroundGroup);
		
		add(level.collisionsGroup);
		
		
		var border_top:FlxSprite = new FlxSprite(0, 0);
		border_top.makeGraphic(120, 70, 0xCC000000);
		border_top.scrollFactor.set(0, 0);
		add(border_top);
		
		FlxG.camera.setBounds(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
		FlxG.worldBounds.set(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
		
		timerText = new FlxText(0, 0, FlxG.stage.stageWidth, parseTime(mainTimer.timeLeft), 16);
		timerText.shadow = 0xFF000000;
		timerText.useShadow = true;
		timerText.scrollFactor.set(0, 0);
		healthText = new FlxText(0, 20, FlxG.stage.stageWidth, "Health: " + level.player.health, 16);
		healthText.shadow = 0xFF000000;
		healthText.useShadow = true;
		healthText.scrollFactor.set(0, 0);
		coinsText = new FlxText(0, 40, FlxG.stage.stageWidth, "Coins: " + level.player.coins, 16);
		coinsText.shadow = 0xFF000000;
		coinsText.useShadow = true;
		coinsText.scrollFactor.set(0, 0);
		add(timerText);
		add(healthText);
		add(coinsText);
		
		// sub states
		pauseSubState = new PauseSubState();
		pauseSubState.create();
		pauseSubState.init("Paused", "Press R to restart the level");
		readySubState = new ReadySubState();
		readySubState.create();
		readySubState.init("Ready?", "Press ENTER to start the level");
		winSubState = new WinSubState();
		winSubState.create();
		winSubState.init("YOU WIN!!!1!!", "Press ENTER to go to the next level");
		loseSubState = new LoseSubState();
		loseSubState.create();
		loseSubState.init("YOU LOSE :(", "Press ENTER to restart the level");
		endSubState = new EndSubState();
		endSubState.create();
		endSubState.init("THE END :D", "Press ENTER to restart the game");
		
		super.create();
		
		setSubState(readySubState, function() { mainTimer.paused = false; });
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		level.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keyboard.anyJustPressed(["ESCAPE"])) {
			setSubState(pauseSubState, function() { mainTimer.paused = false; } );
			mainTimer.paused = true;
		}
		
		if (FlxG.keyboard.anyJustPressed(["R"])) {
			FlxG.resetState();
		}
		
		if (gameWin) {
			level.player.emitter.update();
		}
		
		if (gameOver) {
			loseSubState.why(whyLose);
			setSubState(loseSubState, function() { FlxG.resetState(); } );
		}
		
		super.update();
		
		if (mainTimer != null) {
			if(!gameOver && !gameWin && !mainTimer.paused) {
				mainTimer.update();
			}
			
			timerText.text = parseTime(mainTimer.timeLeft);
		}
		healthText.text = "Health: " + level.player.health;
		coinsText.text = "Coins: " + level.player.coins;
		
		level.update();
	}
	
	public function win():Void {
		if(!gameWin) {
			gameWin = true;
			mainTimer.paused = true;
			level.player.kill();
			Reg.level++;
			setSubState(Reg.level >= Reg.levels.length ? endSubState : winSubState, 
				function() { 
					if (Reg.level >= Reg.levels.length) {
						FlxG.resetGame();
					}
					FlxG.switchState(new PlayState());
				});
		}
	}
	
	
	public function lose(why:String):Void {
		if(!gameOver) {
			gameOver = true;
			mainTimer.time = 0.0;
			mainTimer.paused = true;
			whyLose = why;
		}
	}
	
	public function getMainTimer():FlxTimer {
		return mainTimer;
	}
	
	public function stopTimerFor(time:Float, ?endCallback:Void->Void):Void {
		mainTimer.paused = true;
		FlxTimer.start(time, 
			function(t:FlxTimer) {
				if (endCallback != null) {
					endCallback();
				}
				if (!gameWin && !gameOver && !mainTimer.finished) { 
					mainTimer.paused = false;
				}
			});
	}
	
	private function timeOut(timer:FlxTimer):Void {
		lose("TIME OUT!\nRUN RUN RUN");
	}
	
	private function parseTime(time:Float):String {
		var mili:Float = Math.floor((time - Std.int(time)) * 100);
		if (mili < 0) mili = 0;
		return Std.int(time) + "." + (mili < 9 ? "0" : "") + Std.string(mili).substr(0,2) + " segs";
	}
}