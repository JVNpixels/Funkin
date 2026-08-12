package funkin.ui.debug.notestyle.dialogs.testing;

#if FEATURE_NOTESTYLE_EDITOR
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.components.Link;
import funkin.ui.debug.notestyle.handlers.testing.NoteStyleEditorPlayStateHandler;
import funkin.play.notes.notestyle.NoteStyle;
import funkin.data.song.SongRegistry;
import funkin.play.song.Song;

@:build(haxe.ui.macros.ComponentMacros.build("assets/exclude/data/ui/notestyle-editor/dialogs/testing/difficulties.xml"))
class DifficultiesDialog extends Dialog
{
  var notestyleEditorState:NoteStyleEditorState;

  override public function new(state:NoteStyleEditorState, ?songData:Song, ?variation:String, minimalMode:Bool = false)
  {
    super();

    notestyleEditorState = state;

    var difficulties = songData.listDifficulties(variation);

    if (difficulties == null || difficulties.length == 1)
    {
      NoteStyleEditorPlayStateHandler.loadPlayState(songData, variation, difficulties[0], minimalMode); // We can use the first difficulty pushed in the array, since the game has already determined that there is only 1 difficulty in the current variation.
      return;
    }

    this.title = '${songData.songName} (${variation.toTitleCase()}) - Select a Difficulty';
    if (minimalMode) this.title += ' (Minimal Mode)';

    for (difficulty in difficulties)
    {
      var link = new Link();
      link.percentWidth = 100;
      link.textAlign = "center";
      link.text = difficulty.toTitleCase();

      link.onClick = function(_)
      {
       NoteStyleEditorPlayStateHandler.loadPlayState(songData, variation, difficulty, minimalMode);
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