package funkin.ui.debug.notestyle.dialogs;

#if FEATURE_NOTESTYLE_EDITOR
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.components.Link;
import funkin.ui.debug.notestyle.handlers.NoteStyleEditorActionHandler;
import funkin.play.notes.notestyle.NoteStyle;
import funkin.data.notestyle.NoteStyleRegistry;
import funkin.data.notestyle.NoteStyleData;
import funkin.ui.debug.notestyle.handlers.NoteStyleEditorPreviousFilesHandler;
import funkin.save.Save;
import funkin.util.FileUtil;
import funkin.util.WindowUtil;

@:build(haxe.ui.macros.ComponentMacros.build("assets/exclude/data/ui/notestyle-editor/dialogs/welcome.xml"))
class WelcomeDialog extends Dialog
{
  var notestyleEditorState:NoteStyleEditorState;

  override public function new(state:NoteStyleEditorState)
  {
    super();

    notestyleEditorState = state;

    buttonNew.onClick = function(_)
    {
      killDialog();
      loadNoteStyle(Constants.DEFAULT_NOTE_STYLE);
      NoteStyleEditorActionHandler.doCreationProcess(state, "Create New NoteStyle");
    }

    NoteStyleEditorPreviousFilesHandler.updateRecentFiles(state);
    
    for (file in Save.instance.noteStyleEditorPreviousFiles.value)
    {
      trace(file);

      if (!FileUtil.fileExists(file)) continue; // Don't load a non-existent file.

      var path = new haxe.io.Path(file);

      var fileText = new Link();
      fileText.percentWidth = 100;
      fileText.text = path.file + "." + path.ext;
      fileText.onClick = function(_)
      {
        killDialog();
        WindowUtil.setWindowTitle("Friday Night Funkin' NoteStyle Editor - " + file);
      };

      #if sys
      var stat = sys.FileSystem.stat(file);
      var sizeInMB = (stat.size / 1000000).round(3);

      fileText.tooltip = "Full Name: " + file + "\nLast Modified: " + stat.mtime.toString() + "\nSize: " + sizeInMB + " MB";
      #end

      contentRecent.addComponent(fileText);
    }

    // Eventually, this should change the window title to whatever file you open.
    boxDrag.onClick = function(_) FileUtil.browseForFile("Open NoteStyle Data", [FileUtil.FILE_FILTER_FNFNS],
      (fileInfo) -> killDialog()); 

    var defaultNoteStyles:Array<String> = NoteStyleRegistry.instance.listEntryIds();
    defaultNoteStyles.sort(funkin.util.SortUtil.alphabetically);

    for (noteStyle in defaultNoteStyles)
    {
      var baseNoteStyle = NoteStyleRegistry.instance.parseEntryDataWithMigration(noteStyle, NoteStyleRegistry.instance.fetchEntryVersion(noteStyle));
      if (baseNoteStyle == null) continue;

      var link = new Link();
      link.percentWidth = 100;
      link.text = baseNoteStyle.name;

      link.onClick = function(_)
      {
        WindowUtil.setWindowTitle("Friday Night Funkin' NoteStyle Editor - New File");
        loadNoteStyle(noteStyle);
      }

      contentPresets.addComponent(link);
    }
  }

  function fakeNewFileDemo()
  {
    WindowUtil.setWindowTitle("Friday Night Funkin\' NoteStyle Editor - New File");
  }

  function loadNoteStyle(notestyleString:String)
  {
    notestyleEditorState.loadNoteStyle(notestyleString);
    killDialog();
  }

  function killDialog()
  {
    hide();
    destroy();
  }
}
#end