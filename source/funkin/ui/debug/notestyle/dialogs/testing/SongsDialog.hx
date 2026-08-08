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

@:build(haxe.ui.macros.ComponentMacros.build("assets/exclude/data/ui/notestyle-editor/dialogs/testing/songs.xml"))
class SongsDialog extends Dialog
{
  var notestyleEditorState:NoteStyleEditorState;

  override public function new(state:NoteStyleEditorState, minimalMode:Bool = false)
  {
    super();

    notestyleEditorState = state;

    var songs:Array<String> = SongRegistry.instance.listEntryIds();
    songs.sort(funkin.util.SortUtil.alphabetically);

    for (song in songs)
    {
      var songData:Null<Song> = SongRegistry.instance.fetchEntry(song, {variation: Constants.DEFAULT_VARIATION});
      if (songData == null) continue;

      var songName:Null<String> = songData.getDifficulty('normal')?.songName;
      if (songName == null) songName = songData.getDifficulty()?.songName;
      if (songName == null)
      {
        trace(' WARNING '.warning() + ' Could not fetch song name for ${song}');
        continue;
      }

      var link = new Link();
      link.percentWidth = 100;
      link.textAlign = "center";
      link.text = songName;

      link.onClick = function(_)
      {
        var variations = songData.variations;

        if (variations == null || variations.length == 1)
        {
          NoteStyleEditorDialogHandler.showTestingDifficultiesDialog(state, songData, variations[0], minimalMode); // We can use the first variation pushed in the array, since the game has already determined that there is only 1 variation.
          killDialog();
          return;
        }

        NoteStyleEditorDialogHandler.showTestingVariationsDialog(state, songData, minimalMode);
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