package funkin.ui.debug.notestyle.handlers.ui;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import funkin.play.song.Song;
import funkin.ui.debug.notestyle.dialogs.*;
import funkin.ui.debug.notestyle.dialogs.testing.*;
import funkin.ui.debug.notestyle.dialogs.create.*;
import funkin.ui.debug.notestyle.dialogs.create.countdown.*;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles all of the dialogs for the NoteStyle Editor.
 */
@:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorDialogHandler
{
  public static var welcomeDialog:WelcomeDialog;

  public static var metadataDialog:MetadataDialog;
  public static var countdownImagesDialog:CountdownImagesDialog;
  public static var countdownSoundsDialog:CountdownSoundsDialog;

  public static var userGuideDialog:UserGuideDialog;
  public static var aboutDialog:AboutDialog;

  public static var testingSongsDialog:SongsDialog;
  public static var testingVariationsDialog:VariationsDialog;
  public static var testingDifficultiesDialog:DifficultiesDialog;

  public static function showMetadataDialog(state:NoteStyleEditorState, closable:Bool = true)
  {
    metadataDialog = new MetadataDialog(state);
    metadataDialog.showDialog();
    metadataDialog.closable = closable;
    metadataDialog.onDialogClosed = function(_)
    {
      metadataDialog = null;
    }
  }

  public static function showWelcomeDialog(state:NoteStyleEditorState, closable:Bool = true)
  {
    welcomeDialog = new WelcomeDialog(state);
    welcomeDialog.showDialog();
    welcomeDialog.closable = closable;
    welcomeDialog.onDialogClosed = function(_)
    {
      welcomeDialog = null;
    }
  }

  public static function showAboutDialog(closable:Bool = true)
  {
    aboutDialog = new AboutDialog();
    aboutDialog.showDialog();
    aboutDialog.closable = closable;
    aboutDialog.onDialogClosed = function(_)
    {
      aboutDialog = null;
    }
  }

  public static function showUserGuide(closable:Bool = true)
  {
    userGuideDialog = new UserGuideDialog();
    userGuideDialog.showDialog();
    userGuideDialog.closable = closable;
    userGuideDialog.onDialogClosed = function(_)
    {
      userGuideDialog = null;
    }
  }

  public static function showCountdownImagesDialog(state:NoteStyleEditorState, closable:Bool = true)
  {
    countdownImagesDialog = new CountdownImagesDialog(state);
    countdownImagesDialog.showDialog();
    countdownImagesDialog.closable = closable;
    countdownImagesDialog.onDialogClosed = function(_)
    {
      countdownImagesDialog = null;
    }
  }

  public static function showCountdownSoundsDialog(state:NoteStyleEditorState, closable:Bool = true)
  {
    countdownSoundsDialog = new CountdownSoundsDialog(state);
    countdownSoundsDialog.showDialog();
    countdownSoundsDialog.closable = closable;
    countdownSoundsDialog.onDialogClosed = function(_)
    {
      countdownSoundsDialog = null;
    }
  }

  public static function showTestingSongsDialog(state:NoteStyleEditorState, minimalMode:Bool = false, closable:Bool = true)
  {
    trace("\n\n\n da minimal mode shit when handling dialogs: " + minimalMode + "\n\n\n");
    testingSongsDialog = new SongsDialog(state, minimalMode);
    testingSongsDialog.showDialog();
    testingSongsDialog.closable = closable;
    testingSongsDialog.onDialogClosed = function(_)
    {
      testingSongsDialog = null;
    }
  }

  public static function showTestingVariationsDialog(state:NoteStyleEditorState, songData:Song, minimalMode:Bool = false, closable:Bool = true)
  {
    testingVariationsDialog = new VariationsDialog(state, songData, minimalMode);
    testingVariationsDialog.showDialog();
    testingVariationsDialog.closable = closable;
    testingVariationsDialog.onDialogClosed = function(_)
    {
      testingVariationsDialog = null;
    }
  }

  public static function showTestingDifficultiesDialog(state:NoteStyleEditorState, songData:Song, ?variation:String, minimalMode:Bool = false, closable:Bool = true)
  {
    testingDifficultiesDialog = new DifficultiesDialog(state, songData, variation, minimalMode);
    testingDifficultiesDialog.showDialog();
    testingDifficultiesDialog.closable = closable;
    testingDifficultiesDialog.onDialogClosed = function(_)
    {
      testingDifficultiesDialog = null;
    }
  }
}
#end