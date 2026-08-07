package funkin.ui.debug.notestyle.handlers;

import haxe.io.Bytes;
import haxe.zip.Entry;
import funkin.util.FileUtil;
import funkin.play.notes.notestyle.NoteStyle;
import funkin.data.notestyle.NoteStyleData;
import funkin.ui.debug.notestyle.handlers.create.NoteStyleEditorCountdownHandler;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles files with a file extension of ".fnfns".
 * This includes parsing NoteStyle files, zipping and loading zipped (unzipping) NoteStyle files, and more.
 */
@:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorFNFNSHandler
{
  public static function zip(state:NoteStyleEditorState, noteStyle:NoteStyle)
  {
    var data:NoteStyleData = noteStyle._data;

    data.name = state.name;
    data.author = state.author;
    data.fallback = state.fallback;

    data.assets.countdownThree.data.audioPath = NoteStyleEditorCountdownHandler.SOUND_PATH + data.name + "/" + NoteStyleEditorCountdownHandler.THREE_SOUND_NAME;
    data.assets.countdownThree.assetPath = NoteStyleEditorCountdownHandler.IMAGE_PATH + data.name + "/" + NoteStyleEditorCountdownHandler.THREE_IMAGE_NAME;

    data.assets.countdownTwo.data.audioPath = NoteStyleEditorCountdownHandler.SOUND_PATH + data.name + "/" + NoteStyleEditorCountdownHandler.TWO_SOUND_NAME;
    data.assets.countdownTwo.assetPath = NoteStyleEditorCountdownHandler.IMAGE_PATH + data.name + "/" + NoteStyleEditorCountdownHandler.TWO_IMAGE_NAME;

    data.assets.countdownOne.data.audioPath = NoteStyleEditorCountdownHandler.SOUND_PATH + data.name + "/" + NoteStyleEditorCountdownHandler.ONE_SOUND_NAME;
    data.assets.countdownOne.assetPath = NoteStyleEditorCountdownHandler.IMAGE_PATH + data.name + "/" + NoteStyleEditorCountdownHandler.ONE_IMAGE_NAME;

    data.assets.countdownGo.data.audioPath = NoteStyleEditorCountdownHandler.SOUND_PATH + data.name + "/" + NoteStyleEditorCountdownHandler.GO_SOUND_NAME;
    data.assets.countdownGo.assetPath = NoteStyleEditorCountdownHandler.IMAGE_PATH + data.name + "/" + NoteStyleEditorCountdownHandler.GO_IMAGE_NAME;

    var entryList = new Array<Entry>();

    var noteStyleBytes = Bytes.ofString(serialize(data));
    entryList.push({
      fileName: state.nameID + ".json",
      fileSize: noteStyleBytes.length,
      fileTime: Date.now(),
      compressed: false,
      dataSize: noteStyleBytes.length,
      data: noteStyleBytes,
      crc32: null
    });

    var zipFileBytes = FileUtil.createZIPFromEntries(entryList);
    return zipFileBytes;
  }

  public static function serialize(data:NoteStyleData, pretty:Bool = true)
  {
    var writer = new json2object.JsonWriter<NoteStyleData>();
    return writer.write(data, pretty ? ' ' : null);
  }

  public static function unzip(state:NoteStyleEditorState, noteStyle:NoteStyle)
  {

  }
}
#end