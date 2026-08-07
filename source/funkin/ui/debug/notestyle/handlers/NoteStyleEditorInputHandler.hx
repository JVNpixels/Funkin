package funkin.ui.debug.notestyle.handlers;

import flixel.input.keyboard.FlxKey;
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
        if (pressedLeft()) state.strumline.holdConfirm(0);
        if (pressedDown()) state.strumline.holdConfirm(1);
        if (pressedUp()) state.strumline.holdConfirm(2);
        if (pressedRight()) state.strumline.holdConfirm(3);

        if (releasedLeft()) state.strumline.playStatic(0);
        if (releasedDown()) state.strumline.playStatic(1);
        if (releasedUp()) state.strumline.playStatic(2);
        if (releasedRight()) state.strumline.playStatic(3);
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.Press:
        if (justPressedLeft()) state.strumline.playPress(0);
        if (justPressedDown()) state.strumline.playPress(1);
        if (justPressedUp()) state.strumline.playPress(2);
        if (justPressedRight()) state.strumline.playPress(3);

        if (releasedLeft()) state.strumline.playStatic(0);
        if (releasedDown()) state.strumline.playStatic(1);
        if (releasedUp()) state.strumline.playStatic(2);
        if (releasedRight()) state.strumline.playStatic(3);
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.Notesplashes:
        if (justPressedLeft()) state.strumline.playNoteSplash(0);
        if (justPressedDown()) state.strumline.playNoteSplash(1);
        if (justPressedUp()) state.strumline.playNoteSplash(2);
        if (justPressedRight()) state.strumline.playNoteSplash(3);
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.HoldCovers:
        if (justPressedLeft()) state.doSustain(NoteDirection.LEFT);
        if (justPressedDown()) state.doSustain(NoteDirection.DOWN);
        if (justPressedUp()) state.doSustain(NoteDirection.UP);
        if (justPressedRight()) state.doSustain(NoteDirection.RIGHT);

        if (releasedLeft()) state.endSustain();
        if (releasedDown()) state.endSustain();
        if (releasedUp()) state.endSustain();
        if (releasedRight()) state.endSustain();
      case NoteStyleEditorModeHandler.NoteStyleEditorMode.Notes:
    }
  }

  static function justPressedLeft():Bool
  {
    return FlxG.keys.anyJustPressed([FlxKey.A, FlxKey.LEFT]); 
  }

  static function justPressedDown():Bool
  {
    return FlxG.keys.anyJustPressed([FlxKey.S, FlxKey.DOWN]); 
  }

  static function justPressedUp():Bool
  {
    return FlxG.keys.anyJustPressed([FlxKey.W, FlxKey.UP]); 
  }

  static function justPressedRight():Bool
  {
    return FlxG.keys.anyJustPressed([FlxKey.D, FlxKey.RIGHT]);
  }

  static function pressedLeft():Bool
  {
    return FlxG.keys.anyPressed([FlxKey.A, FlxKey.LEFT]); 
  }

  static function pressedDown():Bool
  {
    return FlxG.keys.anyPressed([FlxKey.S, FlxKey.DOWN]); 
  }

  static function pressedUp():Bool
  {
    return FlxG.keys.anyPressed([FlxKey.W, FlxKey.UP]); 
  }

  static function pressedRight():Bool
  {
    return FlxG.keys.anyPressed([FlxKey.D, FlxKey.RIGHT]);
  }

  static function releasedLeft():Bool
  {
    return FlxG.keys.anyJustReleased([FlxKey.A, FlxKey.LEFT]); 
  }

  static function releasedDown():Bool
  {
    return FlxG.keys.anyJustReleased([FlxKey.S, FlxKey.DOWN]); 
  }

  static function releasedUp():Bool
  {
    return FlxG.keys.anyJustReleased([FlxKey.W, FlxKey.UP]); 
  }

  static function releasedRight():Bool
  {
    return FlxG.keys.anyJustReleased([FlxKey.D, FlxKey.RIGHT]);
  }
}
#end