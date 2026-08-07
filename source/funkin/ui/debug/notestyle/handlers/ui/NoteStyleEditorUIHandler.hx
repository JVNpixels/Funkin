package funkin.ui.debug.notestyle.handlers.ui;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import funkin.ui.debug.notestyle.dialogs.*;
import funkin.ui.debug.notestyle.handlers.*;
import funkin.save.Save;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles all of the user interface callbacks, selections, and UI values for the NoteStyle Editor.
 */
@:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorUIHandler
{
  public static function addUI(state:NoteStyleEditorState)
  {
    NoteStyleEditorHitsoundsHandler.hitsoundVolume = Save.instance.noteStyleEditorHitsoundVolume.value;
    state.menubarItemVolumeHitsound.value = Save.instance.noteStyleEditorHitsoundVolume.value * 100;
    state.menubarLabelVolumeHitsound.text = 'Hitsound Volume - ${Save.instance.noteStyleEditorHitsoundVolume.value * 100}%';

    state.menubarItemToggleMusic.selected = Save.instance.noteStyleEditorThemeMusic.value;

    state.menubarItemToggleMusic.onClick = function (_)
    {
      state.menubarItemToggleMusic.selected ? state.startMusic() : FlxG.sound.music.stop();
      Save.instance.noteStyleEditorThemeMusic.value = state.menubarItemToggleMusic.selected;
      Save.system.flush();
    }

    state.menubarItemNewNoteStyle.onClick = function(_) NoteStyleEditorActionHandler.doCreationProcess(state, "New NoteStyle");
    state.menubarItemSaveNoteStyle.onClick = function(_) NoteStyleEditorActionHandler.doAction(state, "Save NoteStyle");
    state.menubarItemSaveNoteStyleAs.onClick = function(_) NoteStyleEditorActionHandler.doAction(state, "Save NoteStyle");
    state.menubarItemOpenNoteStyle.onClick = function(_) NoteStyleEditorActionHandler.doAction(state, "Open NoteStyle");
    state.menubarItemExit.onClick = function(_) NoteStyleEditorActionHandler.doAction(state, "Exit");

    state.menubarItemWelcomeDialog.onClick = function(_) NoteStyleEditorActionHandler.doCreationProcess(state, "New NoteStyle");
    state.menubarItemUserGuide.onClick = function(_) NoteStyleEditorDialogHandler.showUserGuide(true);
    state.menubarItemBackupsFolder.onClick = function(_) NoteStyleEditorActionHandler.doAction(state, "NoteStyle Backups");
    state.menubarItemAbout.onClick = function(_) NoteStyleEditorActionHandler.doAction(state, "About...");

    state.testingModeText.onClick = function(_) NoteStyleEditorModeHandler.switchModes(state, 1);
    state.testingModeText.onRightClick = function(_) NoteStyleEditorModeHandler.switchModes(state, -1);

    state.menubarItemThemeLight.onClick = function(_) NoteStyleEditorThemeHandler.changeTheme(state, NoteStyleEditorThemeHandler.NoteStyleEditorTheme.Light);
    state.menubarItemThemeLight.selected =  Save.instance.noteStyleEditorTheme.value == NoteStyleEditorThemeHandler.NoteStyleEditorTheme.Light;
    state.menubarItemThemeDark.onClick = function(_) NoteStyleEditorThemeHandler.changeTheme(state, NoteStyleEditorThemeHandler.NoteStyleEditorTheme.Dark);
    state.menubarItemThemeDark.selected = Save.instance.noteStyleEditorTheme.value == NoteStyleEditorThemeHandler.NoteStyleEditorTheme.Dark;

    state.menubarItemBackgroundGrid.onClick = function(_) NoteStyleEditorThemeHandler.changeBackground(state, NoteStyleEditorThemeHandler.NoteStyleEditorBackground.Grid);
    state.menubarItemBackgroundGrid.selected =  Save.instance.noteStyleEditorBackground.value == NoteStyleEditorThemeHandler.NoteStyleEditorBackground.Grid;
    state.menubarItemBackgroundMenu.onClick = function(_) NoteStyleEditorThemeHandler.changeBackground(state, NoteStyleEditorThemeHandler.NoteStyleEditorBackground.Menu);
    state.menubarItemBackgroundMenu.selected = Save.instance.noteStyleEditorBackground.value == NoteStyleEditorThemeHandler.NoteStyleEditorBackground.Menu;

    state.menubarItemHitsoundPlayer.onClick = function(_) 
    {
      NoteStyleEditorHitsoundsHandler.changeHitsound(state, NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.Player);
      state.menubarItemVolumeHitsound.disabled = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;
      state.menubarLabelVolumeHitsound.disabled = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;
    }

    state.menubarItemHitsoundOpponent.onClick = function(_) 
    {
      NoteStyleEditorHitsoundsHandler.changeHitsound(state, NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.Opponent);
      state.menubarItemVolumeHitsound.disabled = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;
      state.menubarLabelVolumeHitsound.disabled = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;
    }

    state.menubarItemHitsoundNone.onClick = function(_)
    {
      NoteStyleEditorHitsoundsHandler.changeHitsound(state, NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None);
      state.menubarItemVolumeHitsound.disabled = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;
      state.menubarLabelVolumeHitsound.disabled = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;
    }

    state.menubarItemHitsoundPlayer.selected = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.Player;
    state.menubarItemHitsoundOpponent.selected = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.Opponent;
    state.menubarItemHitsoundNone.selected = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;

    state.menubarItemVolumeHitsound.onChange = event -> 
    {
      var volume:Float = event.value.toFloat();
      var volumeDisplay:Float = Std.int(volume);
      NoteStyleEditorHitsoundsHandler.hitsoundVolume = volume / 100;
      state.menubarLabelVolumeHitsound.text = 'Hitsound Volume - ${volumeDisplay}%';
    }

    state.menubarItemVolumeHitsound.disabled = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;
    state.menubarLabelVolumeHitsound.disabled = Save.instance.noteStyleEditorHitsound.value == NoteStyleEditorHitsoundsHandler.NoteStyleEditorHitsound.None;
  }
}
#end