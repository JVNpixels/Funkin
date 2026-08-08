package funkin.ui.debug.notestyle.dialogs.testing;

#if FEATURE_NOTESTYLE_EDITOR
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.components.Link;
import funkin.ui.debug.notestyle.handlers.ui.NoteStyleEditorDialogHandler;
import funkin.play.notes.notestyle.NoteStyle;
import funkin.ui.transition.LoadingState;
import funkin.data.song.SongRegistry;
import funkin.play.song.Song;

@:build(haxe.ui.macros.ComponentMacros.build("assets/exclude/data/ui/notestyle-editor/dialogs/testing/variations.xml"))
class VariationsDialog extends Dialog
{
  var notestyleEditorState:NoteStyleEditorState;

  override public function new(state:NoteStyleEditorState, ?songData:Song)
  {
    super();

    notestyleEditorState = state;

    var variations = songData.variations;
    variations.sort(funkin.util.SortUtil.alphabetically);

    if (variations == null || variations.length == 1)
    {
      NoteStyleEditorDialogHandler.showTestingDifficultiesDialog(state, songData, variations[0]); // We can use the first variation pushed in the array, since the game has already determined that there is only 1 variation.
      killDialog();
      return;
    }

    this.title = '${songData.songName} - Select a Variation';

    for (variation in variations)
    {
      var link = new Link();
      link.percentWidth = 100;
      link.textAlign = "center";
      link.text = variation.toTitleCase();

      link.onClick = function(_)
      {
        NoteStyleEditorDialogHandler.showTestingDifficultiesDialog(state, songData, variation);
        killDialog();
      }

      splashTemplateContainer.addComponent(link);
    }
  }

  function killDialog()
  {
    hide();
    destroy();
  }
}
#end