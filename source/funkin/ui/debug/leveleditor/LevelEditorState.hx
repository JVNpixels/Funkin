package funkin.ui.debug.leveleditor;

#if FEATURE_LEVEL_EDITOR
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxStringUtil;
import funkin.audio.FunkinSound;
import funkin.ui.story.Level;
import funkin.ui.story.LevelProp;
import funkin.ui.story.LevelTitle;
import funkin.data.story.level.LevelRegistry;
import funkin.data.song.SongRegistry;
import funkin.graphics.FunkinSprite;
import funkin.modding.events.ScriptEvent;
import funkin.modding.events.ScriptEventDispatcher;
import funkin.play.PlayStatePlaylist;
import funkin.play.song.Song;
import funkin.save.Save;
import funkin.save.Save.SaveScoreData;
import funkin.ui.mainmenu.MainMenuState;
import funkin.ui.MusicBeatState;
import funkin.ui.transition.LoadingState;
import funkin.ui.transition.stickers.StickerSubState;
import funkin.util.MathUtil;
import funkin.util.SwipeUtil;
import funkin.util.TouchUtil;
import funkin.ui.FullScreenScaleMode;
import funkin.input.Cursor;
import funkin.ui.debug.leveleditor.components.*;
#if FEATURE_DISCORD_RPC
import funkin.api.discord.DiscordClient;
#end

class LevelEditorState extends MusicBeatState
{
  static final DEFAULT_BACKGROUND_COLOR:FlxColor = FlxColor.fromString('#F9CF51');
  static final BACKGROUND_HEIGHT:Int = 400;

  var currentDifficultyId:String = 'normal';
  public var currentLevelId:String = 'tutorial';
  var currentLevel:Level;
  var isLevelUnlocked:Bool;
  var currentLevelTitle:LevelTitle;
  var highScore:Int = 42069420;
  var highScoreLerp:Int = 12345678;
  var exitingMenu:Bool = false;
  //
  // RENDER OBJECTS
  //

  /**
   * The title of the level at the top.
   */
  var levelTitleText:FlxText;

  /**
   * The score text at the top.
   */
  var scoreText:FlxText;

  /**
   * The list of songs on the left.
   */
  var tracklistText:FlxText;

  /**
   * The titles of the levels in the middle.
   */
  var levelTitle:FunkinSprite;

  /**
   * The props in the center.
   */
  var levelProps:FlxTypedGroup<LevelProp>;

  /**
   * The background behind the props.
   */
  var levelBackground:FlxSprite;

  /**
   * The left arrow of the difficulty selector.
   */
  var leftDifficultyArrow:FlxSprite;

  /**
   * The right arrow of the difficulty selector.
   */
  var rightDifficultyArrow:FlxSprite;

  /**
   * The text of the difficulty selector.
   */
  var difficultySprite:FlxSprite;

  /**
   * List of available level IDs.
   */
  public var levelList:Array<String> = [];

  var difficultySprites:Map<String, FlxSprite>;
  var stickerSubState:StickerSubState;

  static var rememberedLevelId:Null<String> = null;
  static var rememberedDifficulty:Null<String> = Constants.DEFAULT_DIFFICULTY;

  public var welcomeDialog:WelcomeDialog;

  var levelTitleItem:LevelTitle;

  public function new(?stickers:StickerSubState = null)
  {
    super();

    if (stickers?.members != null)
    {
      stickerSubState = stickers;
    }
  }

  override function create():Void
  {
    super.create();

    FlxG.sound.music?.stop();

    levelList = ['tutorial'];

    difficultySprites = new Map<String, FlxSprite>();

    transIn = FlxTransitionableState.defaultTransIn;
    transOut = FlxTransitionableState.defaultTransOut;

    if (stickerSubState != null)
    {
      this.persistentUpdate = true;
      this.persistentDraw = true;

      openSubState(stickerSubState);
      stickerSubState.degenStickers();
    }

    persistentUpdate = persistentDraw = true;

    updateDataInitial();
    updateBackground();

    var black:FunkinSprite = new FunkinSprite(levelBackground.x, 0).makeSolidColor(FlxG.width, Std.int(400 + levelBackground.y), FlxColor.BLACK);
    black.zIndex = levelBackground.zIndex - 1;
    add(black);

    levelProps = new FlxTypedGroup<LevelProp>();
    levelProps.zIndex = 1000;
    add(levelProps);

    updateProps();

    // x on tracklistText is set/updated later, we dont need to init it
    tracklistText = new FlxText(0, levelBackground.x + levelBackground.height + 100, 0, 'Tracks', 32);
    tracklistText.setFormat('VCR OSD Mono', 32);
    tracklistText.alignment = CENTER;
    tracklistText.color = 0xFFE55777;
    add(tracklistText);

    scoreText = new FlxText(Math.max(FullScreenScaleMode.gameNotchSize.x, 10), 10, 0, 'HIGH SCORE: 42069420');
    scoreText.setFormat('VCR OSD Mono', 32);
    scoreText.zIndex = 1000;
    add(scoreText);

    levelTitleText = new FlxText(Math.max((FlxG.width * 0.7), FlxG.width - FullScreenScaleMode.gameNotchSize.x), 10, 0, 'LEVEL 1');
    levelTitleText.setFormat('VCR OSD Mono', 32, FlxColor.WHITE, RIGHT);
    levelTitleText.alpha = 0.7;
    levelTitleText.zIndex = 1000;
    add(levelTitleText);

    final useNotch:Bool = Math.max(35, FullScreenScaleMode.gameNotchSize.x) != 35;
    leftDifficultyArrow = new FlxSprite(FlxG.width - (useNotch ? (FullScreenScaleMode.gameNotchSize.x) + 410 : 410), 480);
    leftDifficultyArrow.frames = Paths.getSparrowAtlas('storymenu/ui/arrows');
    leftDifficultyArrow.animation.addByPrefix('idle', 'leftIdle0');
    leftDifficultyArrow.animation.addByPrefix('press', 'leftConfirm0');
    leftDifficultyArrow.animation.play('idle');
    add(leftDifficultyArrow);

    buildDifficultySprite(Constants.DEFAULT_DIFFICULTY);
    buildDifficultySprite();

    rightDifficultyArrow = new FlxSprite(FlxG.width - (useNotch ? FullScreenScaleMode.gameNotchSize.x * 1.5 : 35), leftDifficultyArrow.y);
    rightDifficultyArrow.frames = leftDifficultyArrow.frames;
    rightDifficultyArrow.animation.addByPrefix('idle', 'rightIdle0');
    rightDifficultyArrow.animation.addByPrefix('press', 'rightConfirm0');
    rightDifficultyArrow.animation.play('idle');
    add(rightDifficultyArrow);

    add(difficultySprite);

    levelTitle = new FunkinSprite(0, 475);
    levelTitle.loadGraphic(Paths.image('storymenu/titles/tutorial'));
    levelTitle.screenCenter(X);
    add(levelTitle);

    updateText();
    updateLevelTitle();
    changeDifficulty();
    changeLevel();
    refresh();

    Cursor.show();
    FunkinSound.playMusic('chartEditorLoop', {
      startingVolume: 0.0
    });
    FlxG.sound.music.fadeIn(10, 0, 1);

    welcomeDialog = new WelcomeDialog(this);
    welcomeDialog.showDialog();
    welcomeDialog.onDialogClosed = function(_)
    {
      welcomeDialog = null;
    }
  }

  public function updateDataInitial():Void
  {
    currentLevel = LevelRegistry.instance.fetchEntry(currentLevelId);
    if (currentLevel == null) throw 'Could not fetch data for level: ${currentLevelId}';
    isLevelUnlocked = currentLevel == null ? false : currentLevel.isUnlocked();
  }

  public function updateData():Void
  {
    currentLevel = LevelRegistry.instance.fetchEntry(currentLevelId);
    if (currentLevel == null) throw 'Could not fetch data for level: ${currentLevelId}';
    isLevelUnlocked = currentLevel == null ? false : currentLevel.isUnlocked();
    updateBackground();
    updateProps();
    updateText();
    updateLevelTitle();
  }

  function updateLevelTitle()
  {
    levelTitle.loadGraphic(Paths.image(currentLevel.getTitleGraphic()));
    levelTitle.screenCenter(X);
  }

  function buildDifficultySprite(?diff:String):Void
  {
    if (diff == null) diff = currentDifficultyId;
    remove(difficultySprite);
    difficultySprite = difficultySprites.get(diff);
    if (difficultySprite == null)
    {
      difficultySprite = new FlxSprite(leftDifficultyArrow.x + leftDifficultyArrow.width + 10, leftDifficultyArrow.y);

      if (Assets.exists(Paths.file('images/storymenu/difficulties/${diff}.xml')))
      {
        difficultySprite.frames = Paths.getSparrowAtlas('storymenu/difficulties/${diff}');
        difficultySprite.animation.addByPrefix('idle', 'idle0', 24, true);
        if (Preferences.flashingLights) difficultySprite.animation.play('idle');
      }
      else
      {
        difficultySprite.loadGraphic(Paths.image('storymenu/difficulties/${diff}'));
      }

      difficultySprites.set(diff, difficultySprite);

      difficultySprite.x += (difficultySprites.get(Constants.DEFAULT_DIFFICULTY).width - difficultySprite.width) / 2;
    }
    difficultySprite.alpha = 0;

    difficultySprite.y = leftDifficultyArrow.y - 15;
    var targetY:Float = leftDifficultyArrow.y + 10;
    targetY -= (difficultySprite.height - difficultySprites.get(Constants.DEFAULT_DIFFICULTY).height) / 2;
    FlxTween.tween(difficultySprite, {y: targetY, alpha: 1}, 0.07);

    add(difficultySprite);
  }

  override function update(elapsed:Float):Void
  {
    Conductor.instance.update();

    highScoreLerp = Std.int(MathUtil.snap(MathUtil.smoothLerpPrecision(highScoreLerp, highScore, elapsed, 0.307), highScore, 1));

    levelTitleText.text = currentLevel.getTitle();

    levelTitleText.x = FlxG.width - (levelTitleText.width + Math.max(10, FullScreenScaleMode.gameNotchSize.x)); // Right align.

    if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight) FunkinSound.playOnce(Paths.sound('chartingSounds/ClickDown'));
    if (FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight) FunkinSound.playOnce(Paths.sound('chartingSounds/ClickUp'));

    handleKeyPresses();

    if ((FlxG.sound.music?.volume ?? 1.0) < 0.8)
    {
      FlxG.sound.music.volume += 0.5 * elapsed;
    }

    if (pressingControl() && FlxG.keys.justPressed.N && welcomeDialog == null)
    {
        welcomeDialog = new WelcomeDialog(this);
        welcomeDialog.showDialog();
        welcomeDialog.closable = true;
        welcomeDialog.onDialogClosed = function(_)
        {
          welcomeDialog = null;
        }
    }

    super.update(elapsed);
  }

  /**
   * Small helper for MacOS, "WINDOWS" is keycode 15, which maps to "COMMAND" on Mac, which is more often used than "CONTROL"
   * Everywhere else, it just returns `FlxG.keys.pressed.CONTROL`
   * @return Bool
   */
  function pressingControl():Bool
  {
    #if mac
    return FlxG.keys.pressed.WINDOWS;
    #else
    return FlxG.keys.pressed.CONTROL;
    #end
  }

  function handleKeyPresses():Void
  {
    @:privateAccess
    if ((stickerSubState?.switchingState ?? false)) return;

    if (!exitingMenu)
    {
        if (controls.UI_RIGHT #if FEATURE_TOUCH_CONTROLS || TouchUtil.overlaps(rightDifficultyArrow) #end)
        {
          rightDifficultyArrow.animation.play('press');
        }
        else
        {
          rightDifficultyArrow.animation.play('idle');
        }

        if (controls.UI_LEFT #if FEATURE_TOUCH_CONTROLS || TouchUtil.overlaps(leftDifficultyArrow) #end)
        {
          leftDifficultyArrow.animation.play('press');
        }
        else
        {
          leftDifficultyArrow.animation.play('idle');
        }
    }

    if (FlxG.keys.justPressed.F4) Cursor.hide();
    if (pressingControl() && FlxG.keys.justPressed.Q)
    {
      Cursor.hide();
      goBack();
    }
  }

  /**
   * Changes the selected level.
   * @param change +1 (down), -1 (up)
   */
  function changeLevel(change:Int = 0):Void
  {
    var currentIndex:Int = levelList.indexOf(currentLevelId);
    var prevIndex:Int = currentIndex;

    currentIndex += change;

    var previousLevelId:String = currentLevelId;
    currentLevelId = levelList[currentIndex];
    rememberedLevelId = currentLevelId;

    if (currentIndex != prevIndex) FunkinSound.playOnce(Paths.sound('scrollMenu'), 0.4);

    updateText();
    updateBackground(previousLevelId);
    updateProps();
    refresh();
  }

  /**
   * Changes the selected difficulty.
   * @param change +1 (right) to increase difficulty, -1 (left) to decrease difficulty
   */
  function changeDifficulty(change:Int = 0):Void
  {
    // "For now, NO erect in story mode" -Dave

    var difficultyList:Array<String> = currentLevel.getDifficulties().filter(e -> Constants.DEFAULT_DIFFICULTY_LIST.contains(e));
    // Use this line to displays all difficulties
    // var difficultyList:Array<String> = currentLevel.getDifficulties();
    var currentIndex:Int = difficultyList.indexOf(currentDifficultyId);

    currentIndex += change;

    // Wrap around
    if (currentIndex < 0) currentIndex = difficultyList.length - 1;
    if (currentIndex >= difficultyList.length) currentIndex = 0;

    var hasChanged:Bool = currentDifficultyId != difficultyList[currentIndex];
    currentDifficultyId = difficultyList[currentIndex];
    rememberedDifficulty = currentDifficultyId;

    if (difficultyList.length <= 1)
    {
      leftDifficultyArrow.visible = false;
      rightDifficultyArrow.visible = false;
    }
    else
    {
      leftDifficultyArrow.visible = true;
      rightDifficultyArrow.visible = true;
    }

    if (hasChanged)
    {
      buildDifficultySprite();
      FunkinSound.playOnce(Paths.sound('scrollMenu'), 0.4);
      // Disable the funny music thing for now.
      // funnyMusicThing();
    }

    scoreText.text = 'LEVEL SCORE: 0';

    refresh();
  }

  function testProps():Void
  {
    for (prop in levelProps.members)
    {
      prop.playConfirm();
    }
  }

  function updateBackground(?previousLevelId:String = ''):Void
  {
    if (levelBackground == null || previousLevelId == '')
    {
      // Build a new background and display it immediately.
      levelBackground = currentLevel.buildBackground();
      levelBackground.x = 0;
      levelBackground.y = 56;
      levelBackground.zIndex = 100;
      levelBackground.alpha = 1.0; // Not hidden.
      add(levelBackground);
    }
  }

  function updateProps():Void
  {
    for (ind => prop in currentLevel.buildProps(levelProps.members))
    {
      prop.x += (FullScreenScaleMode.gameCutoutSize.x / 4);
      prop.zIndex = 1000;
      if (levelProps.members[ind] != prop) levelProps.replace(levelProps.members[ind], prop) ?? levelProps.add(prop);
    }

    refresh();
  }

  function updateText():Void
  {
    if (currentLevel != null)
    {
      tracklistText.text = 'TRACKS\n\n';
      tracklistText.text += currentLevel.getSongDisplayNames(currentDifficultyId).join('\n');
    } else if (currentLevel.getSongDisplayNames(currentDifficultyId) == null || currentLevel.getSongDisplayNames(currentDifficultyId) == []) {
      tracklistText.text = 'TRACKS\n\n';
      tracklistText.text += 'Unknown';
    } else {
      tracklistText.text = 'TRACKS\n\n';
      tracklistText.text += 'Unknown';
    }
    
    tracklistText.screenCenter(X);
    tracklistText.x -= (FlxG.width * 0.33);

    var levelScore:Null<SaveScoreData> = Save.instance.getLevelScore(currentLevelId, currentDifficultyId);
    highScore = levelScore?.score ?? 0;
    // levelScore.accuracy
  }

  function goBack():Void
  {
    @:privateAccess
    if (exitingMenu || (stickerSubState?.switchingState ?? false)) return;

    exitingMenu = true;
    FlxG.keys.enabled = false;
    FlxG.switchState(() -> new MainMenuState());
    FunkinSound.playOnce(Paths.sound('cancelMenu'));
  }

  override function beatHit()
  {
    for (prop in levelProps.members)
    {
      if (prop.hasAnimation('idle') || (prop.hasAnimation('danceLeft') && prop.hasAnimation('danceRight'))) prop.dance();
    }

    return super.beatHit();
  }
}
#end