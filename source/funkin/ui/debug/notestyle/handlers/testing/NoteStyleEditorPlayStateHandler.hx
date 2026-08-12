package funkin.ui.debug.notestyle.handlers.testing;

import funkin.play.song.Song;
import funkin.ui.transition.LoadingState;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles loading the PlayState for the NoteStyle Editor.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorPlayStateHandler
{
  public static function loadPlayState(songData:Song, ?variation:String, ?difficulty:String, minimal:Bool = false)
  {
    var targetStateParams = {
      targetSong: songData,
      targetVariation: variation ?? Constants.DEFAULT_VARIATION,
      targetDifficulty: difficulty ?? Constants.DEFAULT_DIFFICULTY,
      targetInstrumental: variation == "default" ? "" : variation,
      minimalMode: minimal
    };

    LoadingState.loadPlayState(targetStateParams, false, true);
  }
}
#end