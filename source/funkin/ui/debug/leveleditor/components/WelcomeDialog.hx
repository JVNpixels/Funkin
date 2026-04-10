package funkin.ui.debug.leveleditor.components;

#if FEATURE_LEVEL_EDITOR
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.components.Link;
import funkin.save.Save;
import funkin.util.FileUtil;
import flixel.FlxG;
import funkin.data.story.level.LevelRegistry;
import funkin.ui.story.Level;
import funkin.ui.debug.leveleditor.LevelEditorState;

@:build(haxe.ui.macros.ComponentMacros.build("assets/exclude/data/ui/level-editor/dialogs/welcome.xml"))
class WelcomeDialog extends Dialog
{
  var levelEditorState:LevelEditorState;

  override public function new(state:LevelEditorState)
  {
    super();

    levelEditorState = state;

    var defaultLevels:Array<String> = LevelRegistry.instance.listEntryIds();
    defaultLevels.sort(funkin.util.SortUtil.alphabetically);

    for (level in defaultLevels)
    {
      var level:Level = new Level(level);
      var link = new Link();
      link.percentWidth = 100;
      link.text = level.id;

      link.onClick = function(_)
      {
        link.hide();
        levelEditorState.currentLevelId = link.text;
        levelEditorState.updateData();
        killDialog();
      };

      contentPresets.addComponent(link);
      
    }
  }

  function killDialog()
  {
    hide();
    destroy();
  }
}
#end
