package funkin.ui.debug.notestyle.handlers.ui;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import funkin.ui.debug.notestyle.dialogs.*;
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
}
#end