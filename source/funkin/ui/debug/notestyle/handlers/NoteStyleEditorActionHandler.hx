package funkin.ui.debug.notestyle.handlers;

#if FEATURE_NOTESTYLE_EDITOR

import funkin.util.FileUtil;
import funkin.util.WindowUtil;
import funkin.ui.debug.notestyle.handlers.ui.NoteStyleEditorDialogHandler;

/**
 * Handles quick action keybinds for the NoteStyle Editor.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorActionHandler
{
  public static function doAction(state:NoteStyleEditorState, action:String)
  {
    switch (action)
    {
      case "Open NoteStyle":
        FileUtil.browseForFile("Open NoteStyle Data", [FileUtil.FILE_FILTER_FNFNS], (fileInfo) -> NoteStyleEditorNotificationHandler.success(state, 'Success', 'Opened file' + state.currentFile));

      case "Save NoteStyle":
        state.saveNoteStyle();

      case "NoteStyle Backups":
        FileUtil.openFolder("backups/notestyles", true);

      case "Exit":
        state.exitEditor();

      case "About...":
        NoteStyleEditorDialogHandler.showAboutDialog();
    }
  }

  public static function doCreationProcess(state:NoteStyleEditorState, process:String)
  {
    switch (process)
    {
      case "New NoteStyle":
        NoteStyleEditorDialogHandler.showWelcomeDialog(state);

      case "Create New NoteStyle":
        WindowUtil.setWindowTitle("Friday Night Funkin' NoteStyle Editor - New File");
        NoteStyleEditorDialogHandler.showMetadataDialog(state);

      case "Create Countdown - Images":
        NoteStyleEditorDialogHandler.showCountdownImagesDialog(state, true);

      case "Create Countdown - Sounds":
       NoteStyleEditorDialogHandler.showCountdownSoundsDialog(state, true);
    }
  }
}
#end