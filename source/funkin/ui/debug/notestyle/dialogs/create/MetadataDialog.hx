package funkin.ui.debug.notestyle.dialogs.create;

#if FEATURE_NOTESTYLE_EDITOR
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.components.DropDown;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.components.Link;
import funkin.play.notes.notestyle.NoteStyle;
import funkin.data.notestyle.NoteStyleRegistry;
import funkin.data.notestyle.NoteStyleData;
import funkin.play.notes.Strumline;
import funkin.save.Save;
import funkin.util.FileUtil;
import funkin.util.WindowUtil;
import funkin.ui.debug.notestyle.handlers.NoteStyleEditorActionHandler;
import funkin.ui.debug.notestyle.handlers.ui.NoteStyleEditorDialogHandler;

@:build(haxe.ui.macros.ComponentMacros.build("assets/preload/data/ui/notestyle-editor/dialogs/new-notestyle.xml"))
class MetadataDialog extends Dialog
{
  var noteStyleEditorState:NoteStyleEditorState;

  override public function new(state:NoteStyleEditorState)
  {
    super();

    noteStyleEditorState = state;

    var inputFallback:Null<DropDown> = this.findComponent('inputFallback', DropDown);
    if (inputFallback == null) throw 'Could not locate inputFallback DropDown in New NoteStyle dialog';
    var startingValueNoteStyle = funkin.ui.debug.charting.util.ChartEditorDropdowns.populateDropdownWithNoteStyles(inputFallback, Constants.DEFAULT_NOTE_STYLE); // We can reuse this function from the Chart Editor.
    inputFallback.value = startingValueNoteStyle;

    dialogCancel.onClick = function(_)
    {
      killDialog();
      NoteStyleEditorDialogHandler.showWelcomeDialog(state);
      WindowUtil.setWindowTitle("Friday Night Funkin\' NoteStyle Editor");
    }

    dialogContinue.onClick = function(_)
    {
      continueDialog(state);
    }
  }

  function killDialog()
  {
    hide();
    destroy();
  }

  function continueDialog(state:NoteStyleEditorState)
  {
    trace(inputNoteStyleName.text);
    trace(inputNoteStyleAuthor.text);
    trace(inputFallback.value.id);
    state.name = inputNoteStyleName.text;
    state.nameID = inputNoteStyleName.text.toLowerCase();
    state.author = inputNoteStyleAuthor.text;
    state.fallback = inputFallback.value.id;
    
    #if FEATURE_DISCORD_RPC
    state.updateDiscordRPC();
    #end

    NoteStyleEditorActionHandler.doCreationProcess(state, "Create Countdown - Images");

    killDialog();
  }
}
#end