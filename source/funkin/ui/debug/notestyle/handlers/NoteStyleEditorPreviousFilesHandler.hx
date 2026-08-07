package funkin.ui.debug.notestyle.handlers;

import haxe.ui.containers.menus.MenuItem;
import funkin.save.Save;
import funkin.util.FileUtil;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles previously opened files within the NoteStyle Editor.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorPreviousFilesHandler
{
  public static function updateRecentFiles(state:NoteStyleEditorState):Void
  {
    var files = Save.instance.noteStyleEditorPreviousFiles.value;
    files.remove(state.currentFile);
    files.unshift(state.currentFile);

    while (files.length > Constants.MAX_PREVIOUS_WORKING_FILES) files.pop();

    Save.instance.noteStyleEditorPreviousFiles.value = files;
    Save.system.flush();
  }

  public static function reloadRecentFiles(state:NoteStyleEditorState):Void
  {
    for (child in state.menubarItemOpenRecent.childComponents) state.menubarItemOpenRecent.removeComponent(child);

    for (file in Save.instance.noteStyleEditorPreviousFiles.value)
    {
      if (!FileUtil.fileExists(file)) continue; // Don't load a non-existent file.

      var path = new haxe.io.Path(file);
      var item = new MenuItem();
      item.text = path.file + '.' + path.ext;
      state.menubarItemOpenRecent.addComponent(item);
    }
  }
}
#end