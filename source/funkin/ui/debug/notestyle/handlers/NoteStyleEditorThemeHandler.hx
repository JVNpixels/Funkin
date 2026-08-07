package funkin.ui.debug.notestyle.handlers;

import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import funkin.save.Save;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles the theme used in the NoteStyle Editor.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorThemeHandler
{
  public static final LIGHT_MODE_COLORS:Array<FlxColor> = [0xFFE7E6E6, 0xFFF8F8F8];
  public static final DARK_MODE_COLORS:Array<FlxColor> = [0xFF181919, 0xFF202020];

  public static var theme = NoteStyleEditorTheme.Light;

  public static function changeTheme(state:NoteStyleEditorState, newTheme:NoteStyleEditorTheme)
  {
    theme = newTheme;
    Save.instance.noteStyleEditorTheme.value = newTheme;
    Save.system.flush();
    updateBGColors(state);
  }

  public static function updateBGColors(state:NoteStyleEditorState):Void
  {
    var colorArray = Save.instance.noteStyleEditorTheme.value == NoteStyleEditorTheme.Light ? LIGHT_MODE_COLORS : DARK_MODE_COLORS;

    var index = state.members.indexOf(state.bg);
    state.bg.kill();
    state.remove(state.bg);
    state.bg.destroy();

    state.bg = FlxGridOverlay.create(10, 10, -1, -1, true, colorArray[0], colorArray[1]);
    state.bg.scrollFactor.set();
    state.members.insert(index, state.bg);
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
#end