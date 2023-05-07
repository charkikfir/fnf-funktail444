#if sys

package meta.state;

import flixel.FlxG;

import flixel.FlxSprite;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;

import flixel.addons.transition.FlxTransitionableState;

import flixel.addons.transition.TransitionData;

import flixel.graphics.FlxGraphic;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.math.FlxPoint;

import flixel.util.FlxTimer;

import flixel.text.FlxText;

import flixel.system.FlxSound;

import lime.app.Application;

#if windows

import Discord.DiscordClient;

#end

import openfl.display.BitmapData;

import openfl.utils.Assets;

import haxe.Exception;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import flixel.tweens.FlxTween;

#if cpp

import sys.FileSystem;

import sys.io.File;

#end

using StringTools;

class RPGState extends MusicBeatState

{

	public static var bitmapData:Map<String,FlxGraphic>;	public static var bitmapData2:Map<String,FlxGraphic>;

	var images = [];

	var shitz:FlxText;

	override function create()

	{

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();

		bitmapData2 = new Map<String,FlxGraphic>();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('Fall'));

		menuBG.screenCenter();

		add(menuBG);

               var her:FlxSprite;

her.AnimOffsets = new Map<String, Array<Dynamic>>();

		her = new FlxSprite(0, 0);

		her.antialiasing = ClientPrefs.globalAntialiasing;
		
		her.frames = Paths.getSparrowAtlas('rpg/her');
		
			her.animation.addByPrefix('right', 'right', 24, false);

        her.animation.addByPrefix('down', 'down', 24, false);

        her.animation.addByPrefix('left', 'left', 24, false);

		her.animation.addByPrefix('up', 'up', 24, false);

		her.AddOffset('right', 10, 0);

		her.AddOffset('down', -47, 57);

		her.AddOffset('left', -54, 0);

		her.AddOffset('up', -47, -10);

		her.PlayAnim('up');

		

		#end
}
}
		//orbyy	

		sys.thread.Thread.create(() -> {

			cache();

		});

		super.create();


	override function update(elapsed) 

	{

		super.update(elapsed);

	}

	function cache()

	{

		#if !linux

			var sound1:FlxSound;

			sound1 = new FlxSound().loadEmbedded(Paths.voices('fresh'));

			sound1.play();

			sound1.volume = 0.00001;

			FlxG.sound.list.add(sound1);

			var sound2:FlxSound;

			sound2 = new FlxSound().loadEmbedded(Paths.inst('fresh'));

			sound2.play();

			sound2.volume = 0.00001;

			FlxG.sound.list.add(sound2);

		for (i in images)

		{

			var replaced = i.replace(".png","");

			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);

			var graph = FlxGraphic.fromBitmapData(data);

			graph.persist = true;

			graph.destroyOnNoUse = false;

			bitmapData.set(replaced,graph);

			trace(i);

		}

		#end

		FlxG.switchState(new TitleState());

	}

}
