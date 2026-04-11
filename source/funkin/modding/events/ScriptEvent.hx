package funkin.modding.events;

import funkin.data.song.SongData.SongNoteData;
import funkin.data.song.SongData.SongEventData;
import flixel.FlxState;
import flixel.FlxSubState;
import funkin.play.notes.NoteSprite;
import funkin.play.notes.SustainTrail;
import funkin.play.cutscene.dialogue.Conversation;
import funkin.play.Countdown.CountdownStep;
import funkin.play.notes.NoteDirection;
import funkin.ui.freeplay.SongMenuItem;
import funkin.play.scoring.Scoring.ScoringRank;
import openfl.events.KeyboardEvent;

/**
 * This is a base class for all events that are issued to scripted classes.
 * It can be used to identify the type of event called, store data, and cancel event propagation.
 */
@:nullSafety
class ScriptEvent
{
  /**
   * If true, the behavior associated with this event can be prevented.
   * For example, cancelling COUNTDOWN_START should prevent the countdown from starting,
   * until another script restarts it, or cancelling NOTE_HIT should cause the note to be missed.
   */
  public var cancelable:Bool = false;

  /**
   * The type associated with the event.
   */
  public var type:ScriptEventType = CREATE;

  /**
   * Whether the event should continue to be triggered on additional targets.
   */
  public var shouldPropagate:Bool = true;

  /**
   * Whether the event has been canceled by one of the scripts that received it.
   */
  public var eventCanceled:Bool = false;

  public function new(?type:ScriptEventType):Void
  {
    @:bypassAccessor
    {
      this.cancelable = false;
      this.shouldPropagate = true;
      this.type = type != null ? type : CREATE;
      this.eventCanceled = false;
    }
  }

  /**
   * Call this function on a cancelable event to cancel the associated behavior.
   * For example, cancelling COUNTDOWN_START will prevent the countdown from starting.
   */
  public function cancelEvent():Void
  {
    if (cancelable)
    {
      @:bypassAccessor
      eventCanceled = true;
    }
  }

  /**
   * Cancel this event.
   * This is an alias for cancelEvent() but I make this typo all the time.
   */
  public function cancel():Void
  {
    cancelEvent();
  }

  /**
   * Call this function to stop any other Scripteds from receiving the event.
   */
  public function stopPropagation():Void
  {
    @:bypassAccessor
    shouldPropagate = false;
  }

  public function toString():String
  {
    return 'ScriptEvent(type=$type, cancelable=$cancelable)';
  }
}

/**
 * SPECIFIC EVENTS
 */
/**
 * An event that is fired associated with a specific note.
 */
class NoteScriptEvent extends ScriptEvent
{
  /**
   * The note associated with this event.
   * You cannot replace it, but you can edit it.
   */
  public var note:Null<NoteSprite>;

  /**
   * The combo count as it is with this event.
   * Will be (combo) on miss events and (combo + 1) on hit events (the stored combo count won't update if the event is cancelled).
   */
  public var comboCount:Int;

  /**
   * Whether to play the record scratch sound (if this event type is `NOTE_MISS`).
   */
  public var playSound:Bool;

  /**
   * The health gained or lost from this note.
   * This affects both hits and misses. Remember that max health is 2.00.
   */
  public var healthChange:Float;

  public function new():Void
  {
    super();
    this.playSound = true;
  }

  override public function toString():String
  {
    return 'NoteScriptEvent(type=' + type + ', cancelable=' + cancelable + ', note=' + note + ', comboCount=' + comboCount + ')';
  }
}

class HitNoteScriptEvent extends NoteScriptEvent
{
  /**
   * The judgement the player received for hitting the note.
   */
  public var judgement:String;

  /**
   * The score the player received for hitting the note.
   */
  public var score:Float;

  /**
   * If the hit causes a combo break.
   */
  public var isComboBreak:Bool = false;

  /**
   * The time difference when the player hit the note
   */
  public var hitDiff:Float = 0;

  /**
   * Whether this note hit causes a note splash to display.
   * Defaults to true only on "sick" notes.
   */
  public var doesNotesplash:Bool = false;

  public function new():Void
  {
    super();
    this.type = NOTE_HIT;
    this.cancelable = true;
  }

  override public function toString():String
  {
    return 'HitNoteScriptEvent(note=' + note + ', comboCount=' + comboCount + ', judgement=' + judgement + ', score=' + score + ', isComboBreak='
      + isComboBreak + ', hitDiff=' + hitDiff + ', doesNotesplash=' + doesNotesplash + ')';
  }
}

/**
 * An event that is fired when you press a key with no note present.
 */
class GhostMissNoteScriptEvent extends ScriptEvent
{
  /**
   * The direction that was mistakenly pressed.
   */
  public var dir:NoteDirection;

  /**
   * Whether there was a note within judgement range when this ghost note was pressed.
   */
  public var hasPossibleNotes:Bool;

  /**
   * How much health should be lost when this ghost note is pressed.
   * Remember that max health is 2.00.
   */
  public var healthChange:Float;

  /**
   * How much score should be lost when this ghost note is pressed.
   */
  public var scoreChange:Float;

  /**
   * Whether to play the record scratch sound.
   */
  public var playSound:Bool;

  /**
   * Whether to play the miss animation on the player.
   */
  public var playAnim:Bool;

  public function new():Void
  {
    super();
    this.type = NOTE_GHOST_MISS;
    this.cancelable = true;
  }

  override public function toString():String
  {
    return 'GhostMissNoteScriptEvent(dir=' + dir + ', hasPossibleNotes=' + hasPossibleNotes + ')';
  }
}

class HoldNoteScriptEvent extends NoteScriptEvent
{
  /**
   * The hold note that was hit (or dropped).
   */
  public var holdNote:Null<SustainTrail>;

  /**
   * The score the player received for hitting the note.
   */
  public var score:Float;

  /**
   * If the hit causes a combo break.
   */
  public var isComboBreak:Bool = false;

  /**
   * The time difference when the player hit the note
   */
  public var hitDiff:Float = 0;

  /**
   * Whether this note hit causes a note splash to display.
   * Defaults to true only on "sick" notes.
   */
  public var doesNotesplash:Bool = false;

  public function new():Void
  {
    super();
    this.cancelable = true;
  }

  override public function toString():String
  {
    return 'HoldNoteScriptEvent(type=$type, holdNote=$holdNote, healthChange=$healthChange, score=$score, isComboBreak=$isComboBreak, cancelable=$cancelable)';
  }
}

/**
 * An event that is fired when the song reaches an event.
 */
class SongEventScriptEvent extends ScriptEvent
{
  /**
   * The note associated with this event.
   * You cannot replace it, but you can edit it.
   */
  public var eventData:SongEventData;

  public function new():Void
  {
    super();
    this.type = SONG_EVENT;
    this.cancelable = true;
  }

  override public function toString():String
  {
    return 'SongEventScriptEvent(event=' + eventData + ')';
  }
}

/**
 * An event that is fired during the update loop.
 */
class UpdateScriptEvent extends ScriptEvent
{
  /**
   * The note associated with this event.
   * You cannot replace it, but you can edit it.
   */
  public var elapsed:Float;

  public function new():Void
  {
    super();
    this.type = UPDATE;
    this.cancelable = false;
  }

  override public function toString():String
  {
    return 'UpdateScriptEvent(elapsed=$elapsed)';
  }
}

/**
 * An event that is fired regularly during the song.
 * May be on beat or on step.
 */
class SongTimeScriptEvent extends ScriptEvent
{
  /**
   * The current beat of the song.
   */
  public var beat:Int;

  /**
   * The current step of the song.
   */
  public var step:Int;

  public function new():Void
  {
    super();
    this.cancelable = true;
  }

  override public function toString():String
  {
    return 'SongTimeScriptEvent(type=' + type + ', beat=' + beat + ', step=' + step + ')';
  }
}

/**
 * An event that is fired regularly during the song.
 * May be on beat or on step.
 */
class CountdownScriptEvent extends ScriptEvent
{
  /**
   * The current step of the countdown.
   */
  public var step:CountdownStep;

  public function new():Void
  {
    super();
  }

  override public function toString():String
  {
    return 'CountdownScriptEvent(type=' + type + ', step=' + step + ')';
  }
}

/**
 * An event that is fired during a dialogue.
 */
class DialogueScriptEvent extends ScriptEvent
{
  /**
   * The dialogue being referenced by the event.
   */
  public var conversation:Conversation;

  public function new():Void
  {
    super();
  }

  override public function toString():String
  {
    return 'DialogueScriptEvent(type=$type, conversation=$conversation)';
  }
}

/**
 * An event that is fired when the player presses a key.
 */
class KeyboardInputScriptEvent extends ScriptEvent
{
  /**
   * The associated keyboard event.
   */
  public var event:KeyboardEvent;

  public function new():Void
  {
    super();
    this.cancelable = false;
  }

  override public function toString():String
  {
    return 'KeyboardInputScriptEvent(type=' + type + ', event=' + event + ')';
  }
}

/**
 * An event that is fired once the song's chart has been parsed.
 *
 * The event data includes the song's full note data and event data, which lets you modify it if you like.
 * Override `onSongLoad(event:SongLoadScriptEvent)` on a song/character/stage/module to use it.
 */
class SongLoadScriptEvent extends ScriptEvent
{
  /**
   * The note data for the song that just loaded.
   * Modifying this will carry over to the song, so feel free to edit it
   * (to easily mirror a chart, randomize it, add/remove notes, etc.)
   */
  public var notes:Array<SongNoteData>;

  /**
   * The event data for the song that just loaded.
   * Modifying this will carry over to the song, so feel free to edit it
   * (add/remove events, modify event data, etc.)
   */
  public var events:Array<SongEventData>;

  /**
   * The ID of the song that just loaded.
   */
  public var id:String;

  /**
   * The difficulty of the song that just loaded.
   */
  public var difficulty:String;

  public function new():Void
  {
    super();
    this.type = SONG_LOADED;
    this.cancelable = false;
  }

  override public function toString():String
  {
    var noteStr = notes == null ? 'null' : 'Array(' + notes.length + ')';
    var eventStr = events == null ? 'null' : 'Array(' + events.length + ')';
    return 'SongLoadScriptEvent(notes=$noteStr, events=$eventStr, id=$id, difficulty=$difficulty)';
  }
}

/**
 * An event that is fired when the player retries the song.
 */
class SongRetryEvent extends ScriptEvent
{
  /**
   * The new difficulty of the song.
   */
  public var difficulty:String;

  public function new():Void
  {
    super();
    this.type = SONG_RETRY;
    this.cancelable = false;
  }

  override public function toString():String
  {
    return 'SongRetryEvent(difficulty=$difficulty)';
  }
}

/**
 * An event that is fired when moving out of or into an FlxState.
 */
class StateChangeScriptEvent extends ScriptEvent
{
  /**
   * The state the game is moving into.
   */
  public var targetState:FlxState;

  public function new():Void
  {
    super();
  }

  override public function toString():String
  {
    return 'StateChangeScriptEvent(type=' + type + ', targetState=' + targetState + ')';
  }
}

/**
 * An event that is fired when the game loses or gains focus.
 */
class FocusScriptEvent extends ScriptEvent
{
  public function new():Void
  {
    super();
    this.cancelable = false;
  }

  override public function toString():String
  {
    return 'FocusScriptEvent(type=' + type + ')';
  }
}

/**
 * An event that is fired when a capsule is selected.
 */
class CapsuleScriptEvent extends ScriptEvent
{
  /**
   * The capsule that was selected.
   */
  public var capsule:SongMenuItem;

  /**
   * The difficulty ID of the selected song.
   */
  public var difficultyId:String;

  /**
   * The variation ID of the selected song.
   */
  public var variationId:String;

  /**
   * The rank achieved on the selected song.
   */
  public var rank(default, null):ScoringRank;

  public function new(type:ScriptEventType, capsule:SongMenuItem, difficultyId:String, variationId:String, ?rank:ScoringRank):Void
  {
    super();
    this.capsule = capsule;
    this.difficultyId = difficultyId;
    this.variationId = variationId;
    this.rank = rank;
  }

  override public function toString():String
  {
    var songName = this.capsule.freeplayData?.fullSongName ?? 'Random';
    return 'CapsuleScriptEvent(type=$type, capsule=$songName)';
  }
}

/**
 * An event that is fired when Freeplay is entered or exited.
 */
class FreeplayScriptEvent extends ScriptEvent
{
  public function new():Void
  {
    super();
    this.cancelable = false;
  }

  override public function toString():String
  {
    return 'FreeplayScriptEvent(type=' + type + ')';
  }
}

/**
 * An event that is fired when a character is selected or deselected.
 */
class CharacterSelectScriptEvent extends ScriptEvent
{
  /**
   * The character ID of the selected character.
   */
  public var characterId:String;

  public function new():Void
  {
    super();
    this.cancelable = false;
  }

  override public function toString():String
  {
    return 'CharacterSelectScriptEvent(type=' + type + ')';
  }
}

/**
 * An event that is fired when moving out of or into an FlxSubState.
 */
class SubStateScriptEvent extends ScriptEvent
{
  /**
   * The state the game is moving into.
   */
  public var targetState:FlxSubState;

  public function new():Void
  {
    super();
  }

  override public function toString():String
  {
    return 'SubStateScriptEvent(type=' + type + ', targetState=' + targetState + ')';
  }
}

/**
 * An event which is called when the player attempts to pause the game.
 */
class PauseScriptEvent extends ScriptEvent
{
  /**
   * Whether to use the Gitaroo Man pause.
   */
  public var gitaroo:Bool;

  public function new():Void
  {
    super();
    this.type = PAUSE;
    this.cancelable = false;
  }
}
