package funkin.ui.debug.notestyle.toolboxes;

#if FEATURE_NOTESTYLE_EDITOR
import haxe.ui.containers.dialogs.CollapsibleDialog;

/**
 * The toolbox which allows modifying basic information like NoteStyle name, author, and fallbacks.
 */

@:access(funkin.ui.debug.notestyle.NoteStyleEditorState) @:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/notestyle-editor/toolboxes/basic-metadata.xml'))
class NoteStyleEditorBasicMetadataToolbox extends CollapsibleDialog
{
  public function new(state:NoteStyleEditorState)
  {
    super();
  }
}
#end
