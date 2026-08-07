package funkin.ui.debug.notestyle.handlers;

import funkin.ui.debug.notestyle.handlers.NoteStyleEditorModeHandler;
import funkin.play.notes.NoteDirection;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles the inputs from the NoteStyle Editor for various testing modes.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorInputHandler
{
  public static function checkInputs(state:NoteStyleEditorState)
  {
    switch (NoteStyleEditorModeHandler.currentMode)
    {
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.Confirm:
        if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT) state.strumline.holdConfirm(0);
        if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN) state.strumline.holdConfirm(1);
        if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP) state.strumline.holdConfirm(2);
        if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) state.strumline.holdConfirm(3);

        if (FlxG.keys.justReleased.A || FlxG.keys.justReleased.LEFT) state.strumline.playStatic(0);
        if (FlxG.keys.justReleased.S || FlxG.keys.justReleased.DOWN) state.strumline.playStatic(1);
        if (FlxG.keys.justReleased.W || FlxG.keys.justReleased.UP) state.strumline.playStatic(2);
        if (FlxG.keys.justReleased.D || FlxG.keys.justReleased.RIGHT) state.strumline.playStatic(3);
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.Press:
        if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) state.strumline.playPress(0);
        if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN) state.strumline.playPress(1);
        if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) state.strumline.playPress(2);
        if (FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) state.strumline.playPress(3);

        if (FlxG.keys.justReleased.A || FlxG.keys.justReleased.LEFT) state.strumline.playStatic(0);
        if (FlxG.keys.justReleased.S || FlxG.keys.justReleased.DOWN) state.strumline.playStatic(1);
        if (FlxG.keys.justReleased.W || FlxG.keys.justReleased.UP) state.strumline.playStatic(2);
        if (FlxG.keys.justReleased.D || FlxG.keys.justReleased.RIGHT) state.strumline.playStatic(3);
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.Notesplashes:
        if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) state.strumline.playNoteSplash(0);
        if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN) state.strumline.playNoteSplash(1);
        if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) state.strumline.playNoteSplash(2);
        if (FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) state.strumline.playNoteSplash(3);
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.HoldCovers:
        if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) state.doSustain(NoteDirection.LEFT);
        if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN) state.doSustain(NoteDirection.DOWN);
        if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) state.doSustain(NoteDirection.UP);
        if (FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) state.doSustain(NoteDirection.RIGHT);

        if (FlxG.keys.justReleased.A || FlxG.keys.justReleased.LEFT) state.endSustain();
        if (FlxG.keys.justReleased.S || FlxG.keys.justReleased.DOWN) state.endSustain();
        if (FlxG.keys.justReleased.W || FlxG.keys.justReleased.UP) state.endSustain();
        if (FlxG.keys.justReleased.D || FlxG.keys.justReleased.RIGHT) state.endSustain();
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.Notes:
    }
  }
}
#end