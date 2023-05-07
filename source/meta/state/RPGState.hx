package meta.state;

#if desktop

import meta.data.dependency.Discord.DiscordClient;

import sys.thread.Thread;

#end

import flixel.FlxG;

import flixel.FlxSprite;

import flixel.FlxState;

import flixel.input.keyboard.FlxKey;

import flixel.addons.display.FlxGridOverlay;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;

import flixel.addons.transition.FlxTransitionableState;

import flixel.addons.transition.TransitionData;

import haxe.Json;

import openfl.display.Bitmap;

import openfl.display.BitmapData;

#if (MODS_ALLOWED && FUTURE_POLYMOD)

import sys.FileSystem;

import sys.io.File;

#end

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.graphics.frames.FlxFrame;

import flixel.group.FlxGroup;

import flixel.math.FlxMath;

import flixel.math.FlxPoint;

import flixel.math.FlxRect;

import flixel.system.FlxSound;

import flixel.system.ui.FlxSoundTray;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;

import flixel.util.FlxTimer;

import lime.app.Application;

import openfl.Assets;

#if FUTURE_POLYMOD

import core.ModCore;

#end

import meta.*;

import meta.data.*;

import meta.data.options.*;

import meta.state.*;

import meta.data.alphabet.*;

import objects.shaders.*;




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
}	
}
}
}
}