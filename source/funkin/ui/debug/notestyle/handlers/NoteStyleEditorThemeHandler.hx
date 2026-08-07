package funkin.ui.debug.notestyle.handlers;

import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import funkin.graphics.FunkinSprite;
import funkin.save.Save;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles the theme and background used in the NoteStyle Editor.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorThemeHandler
{
  public static final LIGHT_MODE_COLORS:Array<FlxColor> = [0xFFE7E6E6, 0xFFF8F8F8];
  public static final DARK_MODE_COLORS:Array<FlxColor> = [0xFF181919, 0xFF202020];

  public static var theme = NoteStyleEditorTheme.Light;

  public static var bgMode = NoteStyleEditorBackground.Grid;

  static var gridMode = true;
  static var colorArray = [];

  public static function changeTheme(state:NoteStyleEditorState, newTheme:NoteStyleEditorTheme)
  {
    theme = newTheme;
    Save.instance.noteStyleEditorTheme.value = newTheme;
    Save.system.flush();
    updateBG(state);
  }

  public static function changeBackground(state:NoteStyleEditorState, newMode:NoteStyleEditorBackground)
  {
    bgMode = newMode;
    Save.instance.noteStyleEditorBackground.value = newMode;
    Save.system.flush();
    updateBG(state);
  }
  
  public static function updateBG(state:NoteStyleEditorState):Void
  {
    setColorsAndBackground();
    var index = state.members.indexOf(state.bg);
    killBackground(state);

    if (gridMode)
    {
      state.bg = FlxGridOverlay.create(10, 10, -1, -1, true, colorArray[0], colorArray[1]);
      state.bg.scrollFactor.set();
      state.members.insert(index, state.bg);
    } else {
      state.bg = new FunkinSprite().loadGraphic(Paths.image('menuDesat'));
      state.bg.updateHitbox();
      state.bg.screenCenter();
      state.bg.scrollFactor.set(0, 0);
      state.bg.color = colorArray[0];
      state.bg.setGraphicSize(Std.int(FlxG.width * 1.1));
      state.members.insert(index, state.bg);
    }
  }

  static function setColorsAndBackground()
  {
    colorArray = Save.instance.noteStyleEditorTheme.value == NoteStyleEditorTheme.Light ? LIGHT_MODE_COLORS : DARK_MODE_COLORS;
    gridMode = Save.instance.noteStyleEditorBackground.value == NoteStyleEditorBackground.Grid ? true : false;
  }

  static function killBackground(state:NoteStyleEditorState)
  {
    state.bg.kill();
    state.remove(state.bg);
    state.bg.destroy();
  }
}

enum abstract NoteStyleEditorTheme(String)
{
  /**
   * The default theme for the notestyle editor.
   */
  var Light;

  /**
   * The dark theme for the notestyle editor.
   */
  var Dark;
}

enum abstract NoteStyleEditorBackground(String)
{
  /**
   * The grid backgorund for the notestyle editor.
   */
  var Grid;

  /**
   * The menu background for the notestyle editor.
   */
  var Menu;
}
#end