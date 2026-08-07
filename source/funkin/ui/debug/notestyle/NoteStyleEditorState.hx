package funkin.ui.debug.notestyle;

#if FEATURE_NOTESTYLE_EDITOR
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;
import funkin.save.Save;
import funkin.input.Cursor;
import haxe.ui.backend.flixel.UIState;
import haxe.ui.containers.menus.MenuItem;
import haxe.ui.containers.menus.Menu;
import haxe.ui.containers.menus.MenuBar;
import haxe.ui.containers.menus.MenuOptionBox;
import haxe.ui.containers.menus.MenuCheckBox;
import funkin.util.FileUtil;
import funkin.ui.mainmenu.MainMenuState;
import funkin.ui.debug.notestyle.handlers.*;
import funkin.ui.debug.notestyle.handlers.ui.*;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.components.Button;
import haxe.ui.containers.windows.WindowList;
import haxe.ui.containers.windows.WindowManager;
import haxe.ui.components.Label;
import funkin.ui.debug.FunkinDebugDisplay.DebugDisplayMode;
import funkin.util.WindowUtil;
import funkin.audio.FunkinSound;
import funkin.util.logging.CrashHandler;
import funkin.play.notes.notestyle.NoteStyle;
import funkin.data.notestyle.NoteStyleRegistry;
import funkin.graphics.FunkinCamera;
import funkin.play.notes.NoteSprite;
import funkin.play.notes.Strumline;
import funkin.play.notes.StrumlineNote;
import funkin.play.notes.SustainTrail;
import funkin.play.notes.NoteDirection;

/**
 * A state dedicated to allowing the user to create and edit notestyles
 * Built with HaxeUI for use by both developers and modders.
 *
 * Majority of the functionality has been moved to it's own separate handler classes to keep this class tidy.
 *
 * @author JVN
 */

@:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/notestyle-editor/main-view.xml'))
class NoteStyleEditorState extends UIState
{
  public static final BACKUPS_PATH:String = './backups/notestyles/';

  var currentFile:String;
  var saved:Bool = false;

  var instance:NoteStyleEditorState;

  var sustain:SustainTrail;

  public var name:String = "Funkin'";
  public var nameID:String = "funkin";
  public var author:String = "PhantomArcade";
  public var fallback:String = "funkin";

  public var bg:FlxSprite;

  public var strumline:Strumline;

  public function new()
  {
    super();
  }

  override public function create():Void
  {
    WindowManager.instance.reset();
    instance = this;
    FlxG.sound.music?.stop();
    WindowUtil.setWindowTitle("Friday Night Funkin\' NoteStyle Editor");

    setupAutoSave();

    if (Preferences.debugDisplay == DebugDisplayMode.Off) menubar.paddingLeft = null;

    FileUtil.createDirIfNotExists("backups/notestyles");

    persistentUpdate = false;

    setupBG();
    NoteStyleEditorThemeHandler.updateBGColors(this);

    #if FEATURE_DISCORD_RPC
    updateDiscordRPC();
    #end

    strumline = new Strumline(NoteStyleRegistry.instance.fetchDefault(), true, Constants.DEFAULT_SCROLLSPEED);
    strumline.screenCenter();
    add(strumline);

    if (sustain != null)
    {
      sustain.destroy();
      remove(sustain);
    }

    @:privateAccess
    sustain = new SustainTrail(0, 1, strumline.noteStyle);
    sustain.visible = false;
    add(sustain);

    NoteStyleEditorUIHandler.addUI(this);

    super.create();

    NoteStyleEditorDialogHandler.showWelcomeDialog(this, false);

    Cursor.show();
    if (Save.instance.noteStyleEditorThemeMusic.value) startMusic();
  }

  function setupBG()
  {
    bg = FlxGridOverlay.create(10, 10);
    bg.scrollFactor.set();
    add(bg);
  }

  #if FEATURE_DISCORD_RPC
  public function updateDiscordRPC():Void
  {
    funkin.api.discord.DiscordClient.instance.setPresence({
      state: 'Editing ${name} by ${author}',
      details: 'NoteStyle Editor'
    });
  }
  #end

  public function startMusic()
  {
    FunkinSound.playMusic('chartEditorLoop', {
      startingVolume: 0.0
    });
    FlxG.sound.music.fadeIn(10, 0, 1);
  }

  public function loadNoteStyle(noteStyleString:String) // check if the path exists, rather than loading a class
  {
    nameID = noteStyleString;
    var noteStyleInUse = new NoteStyle(noteStyleString);
    loadData(noteStyleInUse);
    @:privateAccess
    strumline.noteStyle = noteStyleInUse;
    clearNoteStyle();

    for (i in 0...Strumline.KEY_COUNT) 
    {
			strumline.strumlineNotes.members[i].kill();
			strumline.strumlineNotes.remove(strumline.strumlineNotes.members[i]);
      @:privateAccess
			var newChildNote:StrumlineNote = new StrumlineNote(strumline.noteStyle, true, Strumline.DIRECTIONS[i]);
			@:privateAccess
      newChildNote.x = strumline.getXPos(Strumline.DIRECTIONS[i]) + Strumline.INITIAL_OFFSET;
			@:privateAccess
      strumline.noteStyle.applyStrumlineOffsets(newChildNote);
			strumline.strumlineNotes.add(newChildNote);
		}

    strumline.screenCenter();
  }

  function loadData(noteStyle:NoteStyle)
  {
    name = noteStyle.getName();
    nameID = noteStyle.getName().toLowerCase();
    author = noteStyle.getAuthor();
    @:privateAccess
    if (noteStyle.get_fallback() == null)
    {
      fallback = "null"; // Upon saving your NoteStyle file, this will be converted into a real null value.
    } else {
      fallback = noteStyle.get_fallback().getName();
    }
  }

  public function clearNoteStyle()
  {
    @:privateAccess
    strumline.noteSplashes.clear();
    @:privateAccess
		strumline.noteHoldCovers.clear();
    strumline.playStatic(0);
    strumline.playStatic(1);
    strumline.playStatic(2);
    strumline.playStatic(3);
  }

  function exitEditor()
  {
    saveAudioPreferences();

    resetWindowTitle();

    Cursor.hide();
    FlxG.switchState(() -> new MainMenuState());
    FlxG.sound.music.stop();
  }

  function saveNoteStyle()
  {
    @:privateAccess
    var data = NoteStyleEditorFNFNSHandler.zip(this, strumline.noteStyle);

    FileUtil.saveFile('Save NoteStyle as FNFNS...', data, [FileUtil.FILE_FILTER_FNFNS], function(path:String)
    {
        saved = true;
        currentFile = path;
        WindowUtil.setWindowTitle("Friday Night Funkin\' NoteStyle Editor - " + currentFile);
        NoteStyleEditorPreviousFilesHandler.updateRecentFiles(this);
        NoteStyleEditorPreviousFilesHandler.reloadRecentFiles(this);
        NoteStyleEditorNotificationHandler.success(this, 'Success', 'Saved NoteStyle file $currentFile');
    }, null, name + '.' + Constants.EXT_NOTESTYLE);
  }

  /**
   * Setup timers and listeners to handle auto-save.
   */
  function setupAutoSave():Void
  {
    // Called when clicking the X button on the window.
    WindowUtil.windowExit.add(onWindowClose);

    // Called when the game crashes.
    CrashHandler.errorSignal.add(onWindowCrash);
    CrashHandler.criticalErrorSignal.add(onWindowCrash);
  }

  /**
   * Called when the window was closed, to save a backup of the chart.
   * @param exitCode The exit code of the window. We use `-1` when calling the function due to a game crash.
   */
  function onWindowClose(exitCode:Int):Void
  {
    trace('Window exited with exit code: $exitCode');

    saveAudioPreferences();
  }

  function onWindowCrash(message:String):Void
  {
    trace('NoteStyle editor intercepted crash:');
    trace('${message}');

    saveAudioPreferences();
  }

  public function saveAudioPreferences()
  {
    NoteStyleEditorHitsoundsHandler.saveHitsoundVolume(this);
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);
    
    if (pressingControl() && haxe.ui.focus.FocusManager.instance.focus == null)
    {
      if (FlxG.keys.justPressed.N && NoteStyleEditorDialogHandler.welcomeDialog == null) NoteStyleEditorActionHandler.doCreationProcess(this, "New NoteStyle");
      if (FlxG.keys.justPressed.O) NoteStyleEditorActionHandler.doCreationProcess(this, "Open NoteStyle");
      if (FlxG.keys.justPressed.Q) exitEditor();
      if (FlxG.keys.justPressed.S) saveNoteStyle();
    }

    if (FlxG.keys.justPressed.TAB && haxe.ui.focus.FocusManager.instance.focus == null) NoteStyleEditorModeHandler.switchModes(this, 1);

    if (FlxG.keys.justPressed.F4 && haxe.ui.focus.FocusManager.instance.focus == null)
    {
      saveAudioPreferences();

      resetWindowTitle();

      Cursor.hide();
      FlxG.sound.music.stop();
      return;
    }

    if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight) FunkinSound.playOnce(Paths.sound('chartingSounds/ClickDown'));
    if (FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight) FunkinSound.playOnce(Paths.sound('chartingSounds/ClickUp'));
    
    if (!pressingControl() && haxe.ui.focus.FocusManager.instance.focus == null) NoteStyleEditorInputHandler.checkInputs(this);
    if (!pressingControl() && haxe.ui.focus.FocusManager.instance.focus == null) NoteStyleEditorHitsoundsHandler.checkForHitsounds(this);
  }

  function doSustain(direction:NoteDirection)
  {
    sustain.noteDirection = direction;
    sustain.sustainLength = 1;
    strumline.playNoteHoldCover(sustain);
  }

  function endSustain()
  {
    if (sustain.cover != null) sustain.cover.playEnd();
  }

  function resetWindowTitle()
  {
    WindowUtil.setWindowTitle('Friday Night Funkin\'');
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
}
#end