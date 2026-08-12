package funkin.ui.debug.notestyle.dialogs.create.countdown;

#if FEATURE_NOTESTYLE_EDITOR
import funkin.input.Cursor;
import funkin.util.WindowUtil;
import funkin.util.FileUtil;
import funkin.ui.debug.notestyle.handlers.ui.NoteStyleEditorDialogHandler;
import funkin.ui.debug.notestyle.handlers.create.NoteStyleEditorCountdownHandler;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.components.Label;
import haxe.ui.containers.Box;

@:build(haxe.ui.macros.ComponentMacros.build("assets/exclude/data/ui/notestyle-editor/dialogs/countdown/sounds.xml"))
class CountdownSoundsDialog extends Dialog
{
    override public function new(state:NoteStyleEditorState)
    {
        super();

        buildEntries();

        dialogCancel.onClick = function(_)
        {
            killDialog();
            NoteStyleEditorCountdownHandler.reset();
            NoteStyleEditorDialogHandler.showWelcomeDialog(state);
            WindowUtil.setWindowTitle("Friday Night Funkin\' NoteStyle Editor");
        }

        dialogContinue.onClick = function(_)
        {
            killDialog();
        }
    }

    function buildEntries()
    {
        var threeEntry = new CountdownSoundEntry("Three");
        countdownSoundsContainer.addComponent(threeEntry);

        var twoEntry = new CountdownSoundEntry("Two");
        countdownSoundsContainer.addComponent(twoEntry);

        var oneEntry = new CountdownSoundEntry("One");
        countdownSoundsContainer.addComponent(oneEntry);

        var goEntry = new CountdownSoundEntry("Go");
        countdownSoundsContainer.addComponent(goEntry);

        threeEntry.onClick = function(_event)
        {
            browse(threeEntry, "Three");
        }
        twoEntry.onClick = function(_event)
        {
            browse(twoEntry, "Two");
        }
        oneEntry.onClick = function(_event)
        {
            browse(oneEntry, "One");
        }
        goEntry.onClick = function(_event)
        {
            browse(goEntry, "Go");
        }
    }

    function browse(entry:CountdownSoundEntry, step:String)
    {
        FileUtil.browseForFile('Open sound', [FileUtil.FILE_FILTER_OGG], function(selectedFile)
        {
          if (selectedFile != null && selectedFile.bytes != null)
          {
            trace('Selected file for $step entry: ${selectedFile.name}');

            // TODO: Rework this to be better.
            switch (step)
            {
                case "Three":
                    NoteStyleEditorCountdownHandler.THREE_SOUND = selectedFile;
                    NoteStyleEditorCountdownHandler.THREE_SOUND_NAME = selectedFile.name;
                case "Two":
                    NoteStyleEditorCountdownHandler.TWO_SOUND = selectedFile;
                    NoteStyleEditorCountdownHandler.TWO_SOUND_NAME = selectedFile.name;
                case "One":
                    NoteStyleEditorCountdownHandler.ONE_SOUND = selectedFile;
                    NoteStyleEditorCountdownHandler.ONE_SOUND_NAME = selectedFile.name;
                case "Go":
                    NoteStyleEditorCountdownHandler.GO_SOUND = selectedFile;
                    NoteStyleEditorCountdownHandler.GO_SOUND_NAME = selectedFile.name;
            }
            #if FEATURE_FILE_DROP
            entry.countdownSoundsEntryLabel.text = 'Sound for countdown step $step (drag and drop, or click to browse)\nSelected file: ${selectedFile.name}';
            #else
            entry.countdownSoundsEntryLabel.text = 'Sound for countdown step $step (click to browse)\n${selectedFile.name}';
            #end
          }
        });
    }

    function killDialog()
    {
        hide();
        destroy();
    }
}

@:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/notestyle-editor/dialogs/countdown/sounds-entry.xml'))
class CountdownSoundEntry extends Box
{
  public var countdownSoundsEntryLabel:Label = new Label();

  public function new(step:String)
  {
    super();

    #if FEATURE_FILE_DROP
    countdownSoundsEntryLabel.text = 'Drag and drop a sound to use for the $step countdown step, or click to browse.';
    #else
    countdownSoundsEntryLabel.text = 'Click to browse for a sound to use for the $step countdown step.';
    #end

    this.onMouseOver = function(_event)
    {
      this.swapClass('upload-bg', 'upload-bg-hover');
      Cursor.cursorMode = Pointer;
    }

    this.onMouseOut = function(_event)
    {
      this.swapClass('upload-bg-hover', 'upload-bg');
      Cursor.cursorMode = Default;
    }
  }
}
#end