package funkin.ui.debug.notestyle.handlers;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles the testing mode used in the NoteStyle Editor.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorModeHandler
{
  public static var testingModes:Array<NoteStyleEditorMode> = [NoteStyleEditorMode.Confirm, NoteStyleEditorMode.Press, NoteStyleEditorMode.Notesplashes, NoteStyleEditorMode.HoldCovers, NoteStyleEditorMode.Notes];
  public static var testingModeIndex:Int = 0;
  public static var currentMode:NoteStyleEditorMode = NoteStyleEditorMode.Confirm;

  public static function switchModes(state:NoteStyleEditorState, change:Int = 1)
  {
    testingModeIndex += change;

    state.clearNoteStyle();

    if (testingModeIndex > testingModes.length - 1) 
    {
      testingModeIndex = 0;
    } else if (testingModeIndex < 0)  {
      testingModeIndex = testingModes.length - 1;
    }

    currentMode = testingModes[testingModeIndex];
    trace(currentMode);

    state.testingModeText.text = testingModes[testingModeIndex];
  }
}

enum abstract NoteStyleEditorMode(String) from String to String
{
  /**
   * The mode for testing the "confirm" animations on a strumline.
   */
  var Confirm = "Confirm";

  /**
   * The mode for testing the "press" animations on a strumline.
   */
  var Press = "Press";

  /**
   * The mode for testing notesplash animations on a strumline.
   */
  var Notesplashes = "Notesplashes";

  /**
   * The mode for testing the hold note cover animations on a strumline.
   */
  var HoldCovers = "Hold Covers";

  /**
   * The mode for testing notes that scroll past a strumline.
   */
  var Notes = "Notes";
}
#end