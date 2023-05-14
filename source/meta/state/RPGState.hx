package meta.state;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.transition.FlxTransitionableState;
import meta.state.PlayState;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.display.GraphicsShader;
import openfl.filters.ShaderFilter;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxTiledSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import meta.Controls;
import meta.data.PlayerSettings;

class Fall extends FlxState
{
	public static var gameCam:FlxCamera;
	public static var uiCam:FlxCamera;
	public static var gameboyCam:FlxCamera;

	public var Her:FlxSprite;

	public static var collisionMap:Array<Array<Bool>> = [];
	public static var collisionSprite:FlxSprite;

	public var bgOcean:FlxTiledSprite;


	public static var inCutscene:Bool = false;

	var blackFade:FlxSprite;
	var pointTo:FlxPoint;

	override public function create()
	{
		super.create();

		FlxG.sound.playMusic(Paths.music('CinnabarOverworld'), 0.8, true);

		inCutscene = false;
		blackFade = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);

		gameCam = new FlxCamera(0, 0, 800, 720);
		gameCam.x += (FlxG.width / 2 - gameCam.width / 2);
		FlxG.cameras.reset(gameCam);
		FlxCamera.defaultCameras = [gameCam];
		gameCam.pixelPerfectRender = true;
		// gameCam.bgColor = FlxColor.GRAY;

		uiCam = new FlxCamera(0, 0, 800, 720);
		uiCam.x += (FlxG.width / 2 - gameCam.width / 2);
		FlxG.cameras.add(uiCam);
		uiCam.bgColor.alpha = 0;


		add(blackFade);
		blackFade.alpha = 0;
		blackFade.cameras = [gameboyCam];

		FlxG.camera.zoom = 5;

		//
		var imagePath:String = 'fall';
		var bg = new FlxSprite().loadGraphic(Paths.image(imagePath));
		add(bg);

		// collision bullshit

		trace('end time: ${Sys.time() - startTime}');
		bgCollision.visible = false;
		collisionSprite.visible = false;

		//
		gameCam.minScrollX = bg.x;
		gameCam.minScrollY = bg.y;
		//
		gameCam.maxScrollX = bg.x + bg.width;
		gameCam.maxScrollY = bg.y + bg.height + 60;

		Her.setPosition(160, 64);
		// Her.screenCenter();
		add(Her);
		FlxG.camera.follow(Her, LOCKON, 1);
		FlxG.camera.deadzone = FlxRect.get((FlxG.camera.width - Her.width) / 2, (FlxG.camera.height - Her.height) / 2, Her.width - 8, Her.height);


		pointTo = new FlxPoint(320 + 8, 192 + 8);
	}

	var shiftX:Float = 0;
	var fullElapsed:Float = 0;
	var stripGroup:FlxTypedGroup<FlxSprite>;

	override public function update(elapsed:Float)
	{
		// FlxG.camera.zoom += 0.0125;
		fullElapsed += (elapsed / (1 / (12)));
		var sinAmount:Float = (fullElapsed / 240) * (180 / Math.PI);
		shiftX = Math.floor(Math.sin(sinAmount) * 4);
		bgOcean.scrollX = shiftX;

		//
		var distanceToPoint:Float = Math.sqrt(Math.pow((pointTo.x - (Her.x + 8)), 2) + Math.pow(((Her.y + 8) - pointTo.y), 2));
		//
		if (Math.floor(distanceToPoint) == 0 && !inCutscene)
		{
			inCutscene = true;

			stripGroup = new FlxTypedGroup<FlxSprite>();
			var divisions = 18;
			for (i in 0...divisions)
			{
				var newStrip:FlxSprite = new FlxSprite().makeGraphic(uiCam.width, Std.int(uiCam.height / divisions), FlxColor.BLACK);
				newStrip.y += (FlxG.height / divisions) * i;
				//
				newStrip.x = -newStrip.width;
				if (i % 2 == 0)
					newStrip.x = uiCam.width;
				//
				stripGroup.add(newStrip);
				stripGroup.cameras = [uiCam];
			}
			add(stripGroup);

			FlxG.sound.music.fadeOut(0.5, 0);
			FlxG.sound.play(Paths.sound("StartupBroke"), 0.8, false, null, true, function()
			{
				FlxTween.tween(gameboyCam, {zoom: 5}, 1, {
					ease: FlxEase.circInOut,
					onComplete: function(tween:FlxTween)
					{
						FlxTransitionableState.skipNextTransIn = false;
						Main.switchState(this, new PlayState());
					}
				});
			});
			new FlxTimer().start(0.1, moveForward);
		}
		else
		{
			var shaderGlitchAmount = Math.max((1 / distanceToPoint - Math.abs(Math.sin(sinAmount) / 16)) * 4, 0);
			glitchSprite.shader.data.prob.value = [shaderGlitchAmount];
			glitchSprite.shader.data.time.value = [fullElapsed / 16];
		}
		super.update(elapsed);
	}

	function moveForward(timer:FlxTimer)
	{
		var stopped:Bool = false;
		for (i in 0...stripGroup.members.length)
		{
			var newStrip = stripGroup.members[i];
			var incremento:Float = 10;
			if (i % 2 == 0)
			{
				newStrip.x -= 5 * incremento;
				if (Math.floor(newStrip.x) <= 0)
				{
					stopped = true;
					newStrip.x = 0;
				}
			}
			else
			{
				newStrip.x += 5 * incremento;
				if (Math.floor(newStrip.x) >= 0)
				{
					stopped = true;
					newStrip.x = 0;
				}
			}
		}
		if (!stopped)
			new FlxTimer().start(0.1, moveForward);
	}
}

/**
 * The Scrunkly
 */
class OverworldHer extends FlxSprite
{
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public function new()
	{
		super();
				Her = new FlxSprite(Paths.image('rpg/her'), true, 16, 16);
		animation.add('down', [0, 1, 2, 1], 8, false);
		animation.add('up', [3, 4, 5, 4], 8, false);
		animation.add('left', [6, 7], 8, false);
		animation.add('right', [8, 9], 8, false);
		animation.play('down', true);
	}

	var walkSpeed:Float = 1;
	//
	var movingX:Bool = false;
	var movingY:Bool = false;

	var direction:Int = 0;

	var lastX:Float = 0;
	var lastY:Float = 0;

	override public function update(elapsed:Float)
	{
		// hey kade watch this
		if (!Fall.inCutscene)
		{
			var trueElapsed:Float = (elapsed / (1 / 60));
			if (!movingX && !movingY)
			{
				if (!controls.UI_UP && !controls.UI_DOWN)
				{
					if ((controls.UI_LEFT || controls.UI_RIGHT) && !(controls.UI_LEFT && controls.UI_RIGHT))
					{
						direction = wrapAngle(0 + (90 * (controls.UI_LEFT ? -1 : 0)) + (90 * (controls.UI_RIGHT ? 1 : 0)));
						if (direction == 270)
							animation.play('left');
						else if (direction == 90)
							animation.play('right');
						if (canMoveNext(x, y, direction))
						{
							movingX = true;
							lastX = x;
						}
						//
					}
				}
				if (!controls.UI_LEFT && !controls.UI_RIGHT)
				{
					if ((controls.UI_DOWN || controls.UI_UP) && !(controls.UI_DOWN && controls.UI_UP))
					{
						direction = wrapAngle(90 + (90 * (controls.UI_DOWN ? -1 : 0)) + (90 * (controls.UI_UP ? 1 : 0)));
						if (direction == 180)
							animation.play('up');
						else if (direction == 0)
							animation.play('down');
						if (canMoveNext(x, y, direction))
						{
							movingY = true;
							lastY = y;
						}
						//
					}
				}
			}
			else
			{
				if (movingX)
				{
					x += walkSpeed * Math.sin(direction * (Math.PI / 180)) * trueElapsed;
					if (Math.abs((lastX + 8) - (x + 8)) >= 16)
					{
						movingX = false;
						x = Math.floor((x + 8) / 16) * 16;
					}
				}
				//
				if (movingY)
				{
					y += walkSpeed * Math.cos(direction * (Math.PI / 180)) * trueElapsed;
					if (Math.abs((lastY + 8) - (y + 8)) >= 16)
					{
						movingY = false;
						y = Math.floor((y + 8) / 16) * 16;
					}
				}
			}
		}

		// bounds
		if (x > Fall.gameCam.maxScrollX - 16 || x < Fall.gameCam.minScrollX)
			movingX = false;
		x = Math.max(Fall.gameCam.minScrollX, x);
		x = Math.min(x, Fall.gameCam.maxScrollX - 16);

		if (y > Fall.gameCam.maxScrollX - (60 + 16) || y < Fall.gameCam.minScrollY)
			movingY = false;
		y = Math.max(Fall.gameCam.minScrollY, y);
		y = Math.min(y, Fall.gameCam.maxScrollY - (60 + 16));

		super.update(elapsed);
	}

	public function canMoveNext(x:Float, y:Float, direction:Float):Bool
	{
		var nextPointX:Int = Std.int(Math.floor(x + 8 + Math.sin(direction * (Math.PI / 180)) * 16) / 16);
		var nextPointY:Int = Std.int(Math.floor(y + 8 + Math.cos(direction * (Math.PI / 180)) * 16) / 16);
		//
		Fall.collisionSprite.setPosition(nextPointX * 16, nextPointY * 16);
		if (nextPointX >= Fall.collisionMap.length
			|| nextPointY >= Fall.collisionMap[nextPointX].length
			|| Fall.collisionMap[nextPointX][nextPointY])
			return false;
		return true;
	}

	public function wrapAngle(angle:Int)
	{
		while (angle < 0)
			angle += 360;
		return angle;
	}
}

class OverworldObject extends FlxSprite {}
