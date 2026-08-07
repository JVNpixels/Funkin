package funkin.ui.debug.notestyle.handlers.create;

import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import funkin.save.Save;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles paths related to files uploaded during the countdown part of the new notestyle process.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorCountdownHandler
{
  public static var IMAGE_PATH:String = "shared:ui/countdown/";
  public static var SOUND_PATH:String = "shared:gameplay/countdown/";
  
  public static var THREE_IMAGE:String = "";
  public static var TWO_IMAGE:String = "";
  public static var ONE_IMAGE:String = "";
  public static var GO_IMAGE:String = "";

  public static var THREE_SOUND:String = "";
  public static var TWO_SOUND:String = "";
  public static var ONE_SOUND:String = "";
  public static var GO_SOUND:String = "";

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
    IMAGE_PATH = "";
    SOUND_PATH = "";

    THREE_IMAGE = "";
    TWO_IMAGE = "";
    ONE_IMAGE = "";
    GO_IMAGE = "";

    THREE_SOUND = "";
    TWO_SOUND = "";
    ONE_SOUND = "";
    GO_SOUND = "";

    THREE_IMAGE_NAME = "";
    TWO_IMAGE_NAME = "";
    ONE_IMAGE_NAME = "";
    GO_IMAGE_NAME = "";

    THREE_SOUND = "";
    TWO_SOUND = "";
    ONE_SOUND = "";
    GO_SOUND = "";
  }
}
#end