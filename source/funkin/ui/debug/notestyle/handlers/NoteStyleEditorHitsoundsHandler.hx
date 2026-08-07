package funkin.ui.debug.notestyle.handlers;

import funkin.save.Save;
import funkin.audio.FunkinSound;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles the hitsound noises when testing notes in the NoteStyle Editor.
 */
@:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorHitsoundsHandler
{
  public static var hitsound:NoteStyleEditorHitsound;

  public static var hitsoundVolume:Float = 1.0;

  public static function checkForHitsounds(state:NoteStyleEditorState)
  {
    hitsound = Save.instance.noteStyleEditorHitsound.value;
    if (pressingKeys())
    {
      switch (hitsound)
      {
        case NoteStyleEditorHitsound.Player:
          FunkinSound.playOnce(Paths.sound('chartingSounds/hitNotePlayer'), hitsoundVolume);
        case NoteStyleEditorHitsound.Opponent:
          FunkinSound.playOnce(Paths.sound('chartingSounds/hitNoteOpponent'), hitsoundVolume);
        case NoteStyleEditorHitsound.None:
      }
    }
  }

  public static function changeHitsound(state:NoteStyleEditorState, newHitsound:NoteStyleEditorHitsound)
  {
    hitsound = newHitsound;
    Save.instance.noteStyleEditorHitsound.value = newHitsound;
    Save.system.flush();
  }

  public static function saveHitsoundVolume(state:NoteStyleEditorState)
  {
    Save.instance.noteStyleEditorHitsoundVolume.value = hitsoundVolume;
    Save.system.flush();
  }

  public static function pressingKeys():Bool
  {
    var pressed:Bool = (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT);
    return pressed;
  }
}

enum abstract NoteStyleEditorHitsound(String)
{
  /**
   * The option to have the player hitsound from the chart editor when testing in the notestyle editor.
   */
  var Player;

  /**
   * The option to have the opponent hitsound from the chart editor when testing in the notestyle editor.
   */
  var Opponent;

  /**
   * The option to have no hitsound when testing in the notestyle editor.
   */
  var None;
}
#end