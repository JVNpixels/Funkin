package funkin.play.event;

import flixel.FlxSprite;
import funkin.play.character.BaseCharacter;
// Data from the chart
import funkin.data.song.SongData;
import funkin.data.song.SongData.SongEventData;
// Data from the event schema
import funkin.play.event.SongEvent;
import funkin.data.event.SongEventSchema;
import funkin.data.event.SongEventSchema.SongEventFieldType;
import funkin.play.character.CharacterData;
import funkin.play.character.CharacterData.CharacterDataParser;
import funkin.util.SortUtil;

class CharacterSwitchEvent extends SongEvent
{
  public function new()
  {
    super('CharacterSwitch');
  }

  public override function handleEvent(data:SongEventData):Void
  {
    if (PlayState.instance == null || PlayState.instance.currentStage == null) return;

    var targetName = data.getString('target');
    var toWho = data.getString('towho');

    var target:FlxSprite = null;
    var type:CharacterType = BF;

    switch (targetName)
    {
      case 'bf':
        target = PlayState.instance.currentStage.getBoyfriend();
        type = CharacterType.BF;
      case 'opp':
        target = PlayState.instance.currentStage.getDad();
        type = CharacterType.DAD;
      case 'gf':
        target = PlayState.instance.currentStage.getGirlfriend();
        type = CharacterType.GF;
    }

    if (target != null)
    {
      if (Std.isOfType(target, BaseCharacter))
      {
        var targetChar:BaseCharacter = cast target;
        targetChar.destroy();
        var newChar = CharacterDataParser.fetchCharacter(toWho);
        if (newChar != null)
        {
          newChar.characterType = type;
          switch (type)
          {
            case BF:
              newChar.initHealthIcon(false);
            case DAD:
              newChar.initHealthIcon(true);
            default:
          }

          PlayState.instance.currentStage.addCharacter(newChar, type);
        }
      }
    }

    PlayState.instance.currentStage.refresh();
    PlayState.instance.needsCharacterReset = true;
  }

  public override function getTitle():String
  {
    return 'Switch Character';
  }

  public override function getEventSchema():SongEventSchema
  {
    /*var charIds:Array<String> = CharacterDataParser.listCharacterIds();
    charIds.sort(SortUtil.alphabetically);*/

    return new SongEventSchema([
      {
        name: 'target',
        title: 'Target',
        defaultValue: 'bf',
        type: SongEventFieldType.ENUM,
        keys: ['Boyfriend' => 'bf', 'Opponent' => 'opp', 'Girlfriend' => 'gf']
      },
      {
        name: 'towho',
        title: 'To Who',
        defaultValue: 'bf-pixel',
        type: SongEventFieldType.ENUM,
        // TODO: Add these via charIds to support custom characters
        keys: [
          'Boyfriend' => 'bf',
          'Boyfriend (Car)' => 'bf-car',
          'Boyfriend (Christmas)' => 'bf-christmas',
          'Boyfriend (Pixel)' => 'bf-pixel',
          'Bf Holding Gf' => 'bf-holding-bf',
          'Daddy Dearest' => 'dad',
          'Darnell' => 'darnell',
          'Girlfriend' => 'gf',
          'Girlfriend (Car)' => 'gf-car',
          'Girlfriend (Christmas)' => 'gf-christmas',
          'Girlfriend (Pixel)' => 'gf-pixel',
          'Mommy Mearest' => 'mom-car',
          'Monster' => 'monster',
          'Monster (Christmas)' => 'monster-christmas',
          'Nene' => 'nene',
          'Mom & Dad (Christmas)' => 'parents-christmas',
          'Pico' => 'pico',
          'Pico (Playable)' => 'pico-playable',
          'Pico (Speaker)' => 'pico-speaker',
          'Senpai' => 'senpai',
          'Senpai (Angry)' => 'senpai-angry',
          'Spooky' => 'spooky',
          'Tankman' => 'tankman'
        ]
      }
    ]);
  }
}
