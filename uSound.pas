unit uSound;

interface

uses mmsystem,classes,dialogs,sysutils,types;

var
  mo: HMIDIOUT;

const
  MIDI_NOTE_ON = $90;
  MIDI_NOTE_OFF = $80;
  MIDI_CHANGE_INSTRUMENT = $C0;

  procedure NoteOn(NewNote, NewIntensity: byte);forward;
procedure NoteOff(NewNote, NewIntensity: byte);forward;


implementation

function MIDIEncodeMessage(Msg, Param1, Param2: byte): integer;
begin
  result := Msg + (Param1 shl 8) + (Param2 shl 16);
end;

procedure NoteOn(NewNote, NewIntensity: byte);
begin
  midiOutShortMsg(mo, MIDIEncodeMessage(MIDI_NOTE_ON, NewNote, NewIntensity));
end;

procedure NoteOff(NewNote, NewIntensity: byte);
begin
  midiOutShortMsg(mo, MIDIEncodeMessage(MIDI_NOTE_OFF, NewNote, NewIntensity));
end;

procedure SetInstrument(NewInstrument: byte);
begin
  midiOutShortMsg(mo, MIDIEncodeMessage(MIDI_CHANGE_INSTRUMENT, NewInstrument, 0));
end;

procedure InitMIDI;
begin
  midiOutOpen(@mo, 0, 0, 0, CALLBACK_NULL);
  midiOutShortMsg(mo, MIDIEncodeMessage(MIDI_CHANGE_INSTRUMENT, 0, 0));
end;



initialization
InitMIDI;
//SetInstrument(100);
//Noteon(99,127);
//sleep(500);
//Noteoff(99,127);


end.
