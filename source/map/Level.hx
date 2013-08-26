package map;

import actors.Actor;
import actors.Clock;
import actors.Coin;
import actors.MedPack;
import actors.Ninja;
import actors.Platform;
import actors.Player;
import actors.Trigger;
import actors.Woman;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledPropertySet;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTilemapExt;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPath;
import flixel.util.FlxRect;
import flixel.util.FlxTimer;

/**
 * ...
 * @author MrCdK
 */
class Level extends TiledMap
{
	
	public inline static var TILESET_DIR = "assets/maps/";

	public var backgroundGroup:FlxGroup;
	public var foregroundGroup:FlxGroup;
	
	public var player:Player;
	public var triggersGroup:FlxGroup;
	public var eventsGroup:FlxGroup;
	public var coinsGroup:FlxGroup;
	public var medpacksGroup:FlxGroup;
	public var clocksGroup:FlxGroup;
	public var collisionsGroup:FlxGroup;
	
	public var totalCoins:Int = 0;
	public var totalMedPacks:Int = 0;
	
	var platforms:Map<String, Platform>;
	
	public var bounds(default, null):FlxRect;
	
	public var state:IMyGame;
	
	var startHealth:Int = 1;
	
	public function new(Data:Dynamic, State:IMyGame) 
	{
		super(Data);
		
		state = State;

		backgroundGroup = new FlxGroup();
		foregroundGroup = new FlxGroup();
		coinsGroup = new FlxGroup();
		medpacksGroup = new FlxGroup();
		clocksGroup = new FlxGroup();
		triggersGroup = new FlxGroup();
		eventsGroup = new FlxGroup();
		collisionsGroup = new FlxGroup();
		
		platforms = new Map<String, Platform>();
		
		bounds = new FlxRect(0, 0, fullWidth, fullHeight);
		
		loadMap();
		
		FlxG.watch.add(this, "totalCoins", "total Coins");
	}
	
	public function destroy():Void {
		player = null;
		
		backgroundGroup = null;
		foregroundGroup = null;
		eventsGroup = null;
		triggersGroup = null;
		medpacksGroup = null;
		coinsGroup = null;
		clocksGroup = null;
		collisionsGroup = null;	
		
		platforms = null;
	}
	
	public function update():Void {
		//collisions
		FlxG.overlap(player, collisionsGroup, null, FlxObject.separate);
		FlxG.overlap(eventsGroup, collisionsGroup, null, FlxObject.separate);
		FlxG.overlap(player, triggersGroup, null, resolveTriggerCollision);
		FlxG.overlap(player, eventsGroup, null, resolveEventCollision);
		FlxG.overlap(player, coinsGroup, null, resolveCoinCollision);
		FlxG.overlap(player, clocksGroup, null, resolveClockCollision);
		FlxG.overlap(player, medpacksGroup, null, resolveMedPackCollision);
		
		
	}
	
	private function resolveTriggerCollision(obj1:Dynamic, obj2:Dynamic):Bool {
		var trigger:Trigger = cast(obj2, Trigger);
		if (!trigger.triggered) {
			for (s in trigger.to) {
				if (platforms.exists(s)) {
					switch (trigger.action) {
						case "start":
							platforms.get(s).startPath();
						case "pause":
							platforms.get(s).pausePath();
					}
				}
			}
			trigger.triggered = true;
		}
		return false;
	}
	
	private function resolveEventCollision(obj1:Dynamic, obj2:Dynamic):Bool {
		if ((!Std.is(obj1, Player) || !Std.is(obj2, Player)) && (Std.is(obj2, Platform) || Std.is(obj1, Platform))) {
			return FlxObject.separate(obj1, obj2);
		}
		obj1 = cast(obj1, Player);
		obj2 = cast(obj2, Actor);
		if (obj2.ID == Reg.NINJA_ID) {
			if (obj1.ninjaCollision()) {
				state.win();
			} else {
				if (totalCoins <= 0) {
					state.lose("Not enough coins in the level to die :/\nTry again!");
				}
			}
		} else if (obj2.ID == Reg.WOMAN_ID) {
			obj2 = cast(obj2, Woman);
			if (state != null && obj2.hasPower) {
				var t:Float = obj1.womanCollision(obj2.power);
				obj2.follow(obj1);
				state.getMainTimer().time += t * 2;
				state.stopTimerFor(2,
					function() {
						player.diffuse.exists = false;
						player.controllable = true;
						obj2.follow(null);
					});
				obj2.hasPower = false;
			}
			
		}
		return false;
	}
	
	private function resolveCoinCollision(obj1:Dynamic, obj2:Dynamic):Bool {
		obj1 = cast(obj1, Actor);
		obj2 = cast(obj2, Coin);
		obj1.coins += 1;
		if (state != null) {
			state.getMainTimer().time += 1;
		}
		obj2.kill();
		if(obj2.count) {
			totalCoins -= 1;
		}
		coinsGroup.remove(obj2);
		return false;
	}
	
	private function resolveMedPackCollision(obj1:Dynamic, obj2:Dynamic):Bool {
		obj1 = cast(obj1, Actor);
		obj2 = cast(obj2, MedPack);
		obj1.health += 1;
		obj2.kill();
		medpacksGroup.remove(obj2);
		return false;
	}
	
	private function resolveClockCollision(obj1:Dynamic, obj2:Dynamic):Bool {
		obj1 = cast(obj1, Actor);
		obj2 = cast(obj2, Clock);
		if(state != null) {
			state.stopTimerFor(obj2.time);
		}
		obj2.kill();
		clocksGroup.remove(obj2);
		return false;
	}

	
	
	private function loadMap():Void {
		if (this.properties.contains("health")) {
			startHealth = Std.parseInt(properties.get("health"));
		}
		//load map
		var layer:TiledLayer;
		var tilemap:FlxTilemapExt;
		var tileset:TiledTileSet;
		for (layer in layers) {
			if (layer.properties.contains("tileset")) {
				tileset = getTileSet(layer.properties.get("tileset"));
			} else {
				throw "No tileset in layer";
			}
			
			if (tileset == null) {
				throw "The tileset doesn't exists";
			}
			
			var csv:String = FlxTilemap.arrayToCSV(layer.tileArray, width);
			
			tilemap = new FlxTilemapExt();
			tilemap.loadMap(csv,
						TILESET_DIR + tileset.imageSource,
						tileset.tileWidth, tileset.tileHeight, 
						FlxTilemap.OFF, tileset.firstGID);
			
			if (layer.properties.contains("fg")) {
				foregroundGroup.add(tilemap);
			} else {
				backgroundGroup.add(tilemap);
			}
		}
		
		loadObjects();
	}
	
	private function loadObjects():Void {
		for (group in objectGroups) {
			for (object in group.objects) {
				loadObject(object, group);
			}
		}
	}
	
	private function loadObject(object:TiledObject, group:TiledObjectGroup):Void {
		var prop:TiledPropertySet = object.custom;
		var actor:Actor;
		var coin:Coin;
		var clock:Clock;
		var med:MedPack;
		var plat:Platform;
		var col:FlxObject;
		var tri:Trigger;
		switch(object.type) {
			case "player":
				var health:Int = startHealth;
				if (prop.contains("health")) {
					health = Std.parseInt(prop.get("health"));
				}
				player = new Player(object.x, object.y);
				player.controllable = true;
				player.health = health;
				player.maxBounds = bounds;
				FlxG.camera.follow(player);
				
			case "ninja":
				actor = new Ninja(object.x, object.y);
				actor.controllable = false;
				actor.maxBounds = bounds;
				eventsGroup.add(actor);

			case "woman":
				var power:Int = 1;
				if (prop.contains("power")) {
					power = Std.parseInt(prop.get("power"));
				}
				var destine:Float = 0;
				if (prop.contains("destine")) {
					destine = Std.parseFloat(prop.get("destine"));
				}
				var velocity:Float = 0;
				if (prop.contains("velocity")) {
					velocity = Std.parseFloat(prop.get("velocity"));
				}
				var fake:Bool = false;
				if (prop.contains("fake")) {
					fake = true;
				}
				actor = new Woman(object.x, object.y, destine, fake);
				actor.maxVelocity.x = velocity;
				actor.controllable = false;
				actor.maxBounds = bounds;
				eventsGroup.add(actor);
			
			case "coin":
				coin = new Coin(object.x, object.y);
				coin.immovable = true;
				if (!prop.contains("nocount")) {
					totalCoins++;
				} else {
					coin.count = false;
				}
				coinsGroup.add(coin);
				
			case "clock":
				var time:Float = 0;
				if (prop.contains("time")) {
					time = Std.parseFloat(prop.get("time"));
				}
				clock = new Clock(object.x, object.y, time);
				clock.immovable = true;
				clocksGroup.add(clock);				
				
			case "medpack":
				med = new MedPack(object.x, object.y);
				med.immovable = true;
				medpacksGroup.add(med);
				
			case "platform":
				var direction:Int = Platform.HORIZONTAL;
				if (prop.contains("direction")) {
					if (prop.get("direction") == "vertical") {
						direction = Platform.VERTICAL;
					}
				}
				
				var vel:Float = 0;
				if (prop.contains("velocity")) {
					vel = Std.parseFloat(prop.get("velocity"));
				}
				
				var distance:Float = 0;
				if (prop.contains("distance")) {
					distance = Std.parseFloat(prop.get("distance"));
				}
				
				var mode:Int = FlxPath.FORWARD;
				if (prop.contains("mode")) {
					switch (prop.get("mode")) {
						case "yoyo":
							mode = FlxPath.YOYO;
						case "forward":
							mode = FlxPath.FORWARD;
						default:
							mode = FlxPath.FORWARD;
					}
				}
				var start:Bool = false;
				if (prop.contains("start")) {
					start = true;
				}
				plat = new Platform(object.x, object.y, object.width, object.height, start);
				plat.immovable = true;
				plat.direction = direction;
				plat.vel = vel;
				plat.distance = distance;
				plat.mode = mode;
				if (object.name != "[object]") {
					platforms.set(object.name, plat);
				}
				//plat.startPath();
				eventsGroup.add(plat);
				
			case "collision":
				col = new FlxObject(object.x, object.y, object.width, object.height);
				col.immovable = true;
				#if !FLX_NO_DEBUG
				col.debugBoundingBoxColor = 0xffff00ff;
				#end
				collisionsGroup.add(col);
				
			case "trigger":
				var action:String = "start";
				if (prop.contains("action")) {
					action = prop.get("action");
				}
				var to:Array<String> = [""];
				if (prop.contains("to")) {
					to = prop.get("to").split(",");
				}
				tri = new Trigger(to, action, object.x, object.y, object.width, object.height);
				tri.immovable = true;
				#if !FLX_NO_DEBUG
				tri.debugBoundingBoxColor = 0xffffffff;
				#end
				triggersGroup.add(tri);
		}
	}
}