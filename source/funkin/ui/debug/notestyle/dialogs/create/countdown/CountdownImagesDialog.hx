package funkin.ui.debug.notestyle.dialogs.create.countdown;

#if FEATURE_NOTESTYLE_EDITOR
import funkin.input.Cursor;
import funkin.util.WindowUtil;
import funkin.util.FileUtil;
import funkin.ui.debug.notestyle.handlers.ui.NoteStyleEditorDialogHandler;
import funkin.ui.debug.notestyle.handlers.NoteStyleEditorActionHandler;
import funkin.ui.debug.notestyle.handlers.create.NoteStyleEditorCountdownHandler;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.components.Label;
import haxe.ui.containers.Box;

@:build(haxe.ui.macros.ComponentMacros.build("assets/exclude/data/ui/notestyle-editor/dialogs/countdown/images.xml"))
class CountdownImagesDialog extends Dialog
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
            continueDialog(state);
        }
    }

    function buildEntries()
    {
        var threeEntry = new CountdownImageEntry("Three");
        countdownImagesContainer.addComponent(threeEntry);

        var twoEntry = new CountdownImageEntry("Two");
        countdownImagesContainer.addComponent(twoEntry);

        var oneEntry = new CountdownImageEntry("One");
        countdownImagesContainer.addComponent(oneEntry);

        var goEntry = new CountdownImageEntry("Go");
        countdownImagesContainer.addComponent(goEntry);

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

    function browse(entry:CountdownImageEntry, step:String)
    {
        FileUtil.browseForFile('Open image', [FileUtil.FILE_FILTER_PNG], function(selectedFile)
        {
          if (selectedFile != null && selectedFile.bytes != null)
          {
            trace('Selected file for $step entry: ${selectedFile.name}');

            // TODO: Rework this to be better.
            switch (step)
            {
                case "Three":
                    NoteStyleEditorCountdownHandler.THREE_IMAGE = selectedFile;
                    NoteStyleEditorCountdownHandler.THREE_IMAGE_NAME = selectedFile.name;
                case "Two":
                    NoteStyleEditorCountdownHandler.TWO_IMAGE = selectedFile;
                    NoteStyleEditorCountdownHandler.TWO_IMAGE_NAME = selectedFile.name;
                case "One":
                    NoteStyleEditorCountdownHandler.ONE_IMAGE = selectedFile;
                    NoteStyleEditorCountdownHandler.ONE_IMAGE_NAME = selectedFile.name;
                case "Go":
                    NoteStyleEditorCountdownHandler.GO_IMAGE = selectedFile;
                     NoteStyleEditorCountdownHandler.GO_IMAGE_NAME = selectedFile.name;
            }

            #if FEATURE_FILE_DROP
            entry.countdownImagesEntryLabel.text = 'Image for countdown step $step (drag and drop, or click to browse)\nSelected file: ${selectedFile.name}';
            #else
            entry.countdownImagesEntryLabel.text = 'Image for countdown step $step (click to browse)\n${selectedFile.name}';
            #end
          }
        });
    }

    function killDialog()
    {
        hide();
        destroy();
    }
    
    function continueDialog(state:NoteStyleEditorState)
    {
        NoteStyleEditorActionHandler.doCreationProcess(state, "Create Countdown - Sounds");
        killDialog();
    }
}

@:build(haxe.ui.ComponentBuilder.build('assets/exclude/data/ui/notestyle-editor/dialogs/countdown/images-entry.xml'))
class CountdownImageEntry extends Box
{
  public var countdownImagesEntryLabel:Label = new Label();

  public function new(step:String)
  {
    super();

    #if FEATURE_FILE_DROP
    countdownImagesEntryLabel.text = 'Drag and drop an image to use for the $step countdown step, or click to browse.';
    #else
    countdownImagesEntryLabel.text = 'Click to browse for an image to use for the $step countdown step.';
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