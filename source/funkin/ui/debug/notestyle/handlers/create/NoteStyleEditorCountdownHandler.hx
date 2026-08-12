package funkin.ui.debug.notestyle.handlers.create;

import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import funkin.util.FileUtil.SelectedFileData;
import funkin.save.Save;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles paths related to files uploaded during the countdown part of the new notestyle process.
 */
@:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorCountdownHandler
{
  /**
   * Paths used when generating an ".fnfns" ZIP file.
   */
  public static var IMAGE_PATH:String = "shared:ui/countdown/";
  public static var SOUND_PATH:String = "shared:gameplay/countdown/";
  
  public static var THREE_IMAGE:SelectedFileData;
  public static var TWO_IMAGE:SelectedFileData;
  public static var ONE_IMAGE:SelectedFileData;
  public static var GO_IMAGE:SelectedFileData;

  public static var THREE_SOUND:SelectedFileData;
  public static var TWO_SOUND:SelectedFileData;
  public static var ONE_SOUND:SelectedFileData;
  public static var GO_SOUND:SelectedFileData;

  public static var THREE_IMAGE_NAME:String = "";
  public static var TWO_IMAGE_NAME:String = "";
  public static var ONE_IMAGE_NAME:String = "";
  public static var GO_IMAGE_NAME:String = "";

  public static var THREE_SOUND_NAME:String = "";
  public static var TWO_SOUND_NAME:String = "";
  public static var ONE_SOUND_NAME:String = "";
  public static var GO_SOUND_NAME:String = "";

  public static function reset()
  {
    THREE_IMAGE = null;
    TWO_IMAGE = null;
    ONE_IMAGE = null;
    GO_IMAGE = null;

    THREE_SOUND = null;
    TWO_SOUND = null;
    ONE_SOUND = null;
    GO_SOUND = null;

    THREE_IMAGE_NAME = "";
    TWO_IMAGE_NAME = "";
    ONE_IMAGE_NAME = "";
    GO_IMAGE_NAME = "";

    THREE_SOUND_NAME = "";
    TWO_SOUND_NAME = "";
    ONE_SOUND_NAME = "";
    GO_SOUND_NAME = "";
  }
}
#end