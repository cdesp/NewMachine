{
Grundy NewBrain Emulator Pro Made by Despsoft
BSD 3-Clause License (https://opensource.org/licenses/BSD-3-Clause)


Copyright (c) 2004, Despoinidis Chris
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON A
NY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}

unit New;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls,  Menus, AppEvnts,   ExtCtrls,
   ComCtrls,  JDLed,uNBTypes, Vcl.ToolWin, Vcl.ImgList, System.Actions,
  Vcl.ActnList, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage{, JvRegAuto}
  , IdBaseComponent, DXClass, System.ImageList, DXDraws,Z80BaseClass
  ;
{$i 'dsp.inc'}
type


  TfNewBrain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Start1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Debug1: TMenuItem;
    Debug2: TMenuItem;
    Suspend1: TMenuItem;
    terminate1: TMenuItem;
    SetMHz1: TMenuItem;
    SetBasicFile1: TMenuItem;
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    N4: TMenuItem;
    LoadTextFile1: TMenuItem;
    N5: TMenuItem;
    DesignChars1: TMenuItem;
    Tools1: TMenuItem;
    N6: TMenuItem;
    About1: TMenuItem;
    TapeManagement1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    WithExpansion1: TMenuItem;
    WithCPM1: TMenuItem;
    DiskManagement1: TMenuItem;
    SaveMemoryMap1: TMenuItem;
    Storage1: TMenuItem;
    Options1: TMenuItem;
    VFDisplayUp1: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    NBDigitizer1: TMenuItem;
    CheckRoms1: TMenuItem;
    ShowDriveContents1: TMenuItem;
    E1: TMenuItem;
    KeyboardMapping1: TMenuItem;
    Restart1: TMenuItem;
    FullScreen1: TMenuItem;
    SaveNewSystem1: TMenuItem;
    Disassembly1: TMenuItem;
    SelectRomVersion1: TMenuItem;
    LoadBinaryFileInMemory1: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDisckNOW1: TMenuItem;
    WithPibox: TMenuItem;
    N9: TMenuItem;
    PeripheralSetup1: TMenuItem;
    Options2: TMenuItem;
    ShowInstructions1: TMenuItem;
    CaptureRawScreen1: TMenuItem;
    ape1: TMenuItem;
    SaveMemorytoDisk1: TMenuItem;
    Setup1: TMenuItem;
    N3: TMenuItem;
    N1: TMenuItem;
    N10: TMenuItem;
    Reset1: TMenuItem;
    aclist: TActionList;
    acStEmul: TAction;
    acRomSel: TAction;
    ImageList1: TImageList;
    acReset: TAction;
    acGenOptions: TAction;
    acTapeSelect: TAction;
    acTapeManagement: TAction;
    acDiskManagement: TAction;
    Action1: TAction;
    UpdateCheck1: TMenuItem;
    Panel4: TPanel;
    Panel3: TPanel;
    Panel1: TPanel;
    LedDisp: TJDLed;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton7: TToolButton;
    ToolButton3: TToolButton;
    ToolButton9: TToolButton;
    ToolButton8: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    Panel6: TPanel;
    newscr: TDXDraw;
    thrEmulate: TDXTimer;
    Memo1: TMemo;
    thrVideo: TTimer;
    timptimer: TTimer;
    svserial: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Debug2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Suspend1Click(Sender: TObject);
    procedure terminate1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetMHz1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetBasicFile1Click(Sender: TObject);
    procedure LoadTextFile1Click(Sender: TObject);
    procedure DesignChars1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure About1Click(Sender: TObject);
    procedure SaveCharMap1Click(Sender: TObject);
    procedure TapeManagement1Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure WithExpansion1Click(Sender: TObject);
    procedure WithCPM1Click(Sender: TObject);
    procedure DiskManagement1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SaveMemoryMap1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure VFDisplayUp1Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure Help2Click(Sender: TObject);
    procedure NBDigitizer1Click(Sender: TObject);
    procedure CheckRoms1Click(Sender: TObject);
    procedure Disassembly1Click(Sender: TObject);
    procedure ShowDriveContents1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure KeyboardMapping1Click(Sender: TObject);
    procedure Restart1Click(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure LoadBinaryFileInMemory1Click(Sender: TObject);
    procedure PeripheralSetup1Click(Sender: TObject);
    procedure WithPiboxClick(Sender: TObject);
    procedure SaveDisckNOW1Click(Sender: TObject);
    procedure SaveNewSystem1Click(Sender: TObject);
    procedure SelectRomVersion1Click(Sender: TObject);
    procedure ShowInstructions1Click(Sender: TObject);
    procedure CaptureRawScreen1Click(Sender: TObject);
    procedure SaveMemorytoDisk1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure UpdateCheck1Click(Sender: TObject);
    procedure thrEmulateTimer(Sender: TObject; LagCount: Integer);
    procedure newscrResize(Sender: TObject);
    procedure thrVideoTimer(Sender: TObject);
    procedure timptimerTimer(Sender: TObject);
    procedure svserialClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);


  private
    { Private declarations }
    Halted:Boolean;
    IsSuspended: Boolean;
    bDebugging: Boolean;
    procedure HideInstructions;
    procedure ShowInstructions;
    function GetNewbrainDescr: String;
    procedure RefreshRomVer;
    procedure WriteP3(s: String);
    procedure LoadOptions;
    procedure SaveOptions;

    procedure SetParams;
    procedure DoEmulation(st:integer=40000);
    function GetRoot: string;
    function CreateOpenDialog: TOpenDialog;
    procedure MakeTapeButtons;
    procedure tpbtnClick(Sender: TObject);
    function GetOLDOS: Byte;
    procedure OpenFile(Fname: String);
    function GetColor(cl: TColor): TColor;
    procedure DoOnidle(sender: TObject; var Done: Boolean);
    function getDebugging: Boolean;
    procedure setDebugging(const Value: Boolean);
    procedure doImport;
    function getemulsatspeedtime(eml, time: cardinal): longint;
    function checkBpts: boolean;
    procedure LoadImage;
    procedure AddNewKeyPressed(nk: word);



  public
    { Public declarations }
    keybFileinp:Boolean;
    bootok: boolean;
    Emuls: Real;
    MHz: Real;

    DoOne: Boolean;
    Constructor Create(Aowner:TComponent);Override;
    procedure clearinterrupt(v: byte);
    procedure StartEmulation;
    procedure SuspendEmul;
    procedure ResumeEmul;
    procedure StartEmul;
    procedure WriteP1(s:String);
    procedure SaveCharMap;
    procedure LoadCharMap;
    procedure SetLed(Sender: Tobject);
    procedure WriteP2(s: String);
    procedure Step;
    procedure ShowSplash(DoShow:Boolean=true);
    function getNewKey: byte;

    property Root: string read GetRoot;
    property OLDOS: Byte read GetOLDOS;
    property Suspended: Boolean read IsSuspended;
    property Debugging:Boolean read getDebugging write setDebugging;
  end;


function GetFiles(Wld:AnsiString;ODirs:Boolean): TStrings;

procedure ODS(s:String);
procedure screenout(s:string);

//z80 commands
    function z80_emulate(cycles: integer): integer;
    function z80_get_reg(reg: z80_register): word;
    procedure z80_set_reg(reg: z80_register; value: word);
    procedure z80_stop_emulating;



var
  fNewBrain: TfNewBrain;
  LASTPC:WORD;  //last pc for debugging
  InterruptServed:Boolean=True;
  NBDel:Integer=33000;   //Emulation Delay
  idif:integer;         //EMULATION DIF
  fl:String;
  pclist:Tlist=nil;
  SPlist:Tlist=nil;
  Stopped:Boolean=false;
  LastIN:Byte;
  LastOut:Byte;
  LastError:string='';
  AppCaption:String='';

 Pretick:Cardinal=0;
    ems:Cardinal=0;
    LASTEMS:cardinal;
    lasttime:cardinal;

    Doesc:Boolean=true;

    //1.000.000 States is 1Mhz
    //13000 States is 13ms in 1MHz Clock
    //13000*4=52000 States is 13ms in 4Mhz Clock

    //EMULATION IS FASTER BECAUSE WE 'REFRESH' THE SCREEN FASTER
    //SHOULD FIND OUT HOW MANY ms NEWBRAIN NEEDS TO REFRESH THE SCREEN
    //AND DELAY AS MUCH

    cEmuls:integer=0;
    sle:tstringlist=nil;
    St:Integer=0;
    emuled:Integer=0;
    CopTime:Cardinal=0;
    CLKTime:Cardinal=0;
    EMUTime:Cardinal=0;
    EMUReal:Cardinal=0;
    EMUDif:Cardinal=0;
    CpTm:Cardinal=0;
    CkTm:Cardinal=0;
    cpcnt,ckcnt:integer;
    emudel:Integer=1;
    CPUStates:longint=1*1000000; //4mhZ
    keylist:tstringlist=nil;
    kbint:integer=0;



implementation
uses uz80dsm,math, frmNewDebug,jcllogic, frmChrDsgn, frmAbout, frmTapeMgmt,
     uNBMemory,uNBIO,uNBCPM,uNBScreen,uNBTapes,uNBKeyboard2,
     frmDiskMgmt,mmsystem, frmOptions,shellapi, frmDrvInfo,SendKey,
     frmSplash,frmDisassembly,inifiles, frmRomVersion,ustrings, frmPeriferals,
     frmInstructions, uUpdate,uStopwatch,z80intf, frmVGA;

Var dbgsl:TStringlist=nil;
    stopwatch:TStopWatch;
    stopwatch2:TStopWatch;
    MyZ80:TZ80Interface;


{$R *.DFM}

//z80 commands




    // Z80 main functions

    function z80_emulate(cycles: integer): integer;
    Begin
     result:=MyZ80.Z_Emulate(cycles);
    End;


    // Z80 context functions
    function z80_get_reg(reg: z80_register): word;
    Begin
      result:=MyZ80.Z_Get_Reg(reg);
    End;

    procedure z80_set_reg(reg: z80_register; value: word);
    Begin
      MyZ80.Z_Set_Reg(reg,value);
    End;

    // Z80 cycle functions
//    function z80_get_cycles_elapsed: integer; cdecl; external 'raze.dll' name '_z80_get_cycles_elapsed';
    procedure z80_stop_emulating;
    Begin
    End;






//z80 commands


//Delay procedure in secs and millisecs
Procedure Delay(s,ms:Word);
VAr totdel:Word;
    Lasttick:Cardinal;
Begin
  totdel:=s*1000+ms;
  lasttick:=Gettickcount;
  While (Gettickcount-LastTick)<totdel do
  Begin
   application.processmessages;
  End;
End;

//Get Directories or .Bin and .bas Files
Function GetFiles(Wld:AnsiString;ODirs:Boolean):TStrings;
Var pth:AnsiString;
    pfnddat:_Win32_Find_DataA;
    h:THandle;

    FUnction ISValid:Boolean;
    Begin
      if sametext(pfnddat.cFileName,'.') or
       sametext(pfnddat.cFileName,'..') then
      Begin
        result:=false;
        exit;
      End;
      if odirs then
      Begin
       if pfnddat.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY=FILE_ATTRIBUTE_DIRECTORY then
        result:=true
       else
        result:=false;
      End
      Else
      Begin
       if pfnddat.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY=FILE_ATTRIBUTE_DIRECTORY then
        result:=False
       else
        result:=True;
       if result then
        if (pos('.bin',LOWERCASE(pfnddat.cFileName))=0) and
           (pos('.bas',LOWERCASE(pfnddat.cFileName))=0) then
           result:=false;
      End;
    End;

Begin
  pth:=ExtractFilepath(application.exename);
  Result:=TStringlist.create;
  h:=FindFirstFileA(PAnsiChar(pth+wld),pfnddat);
  if h>0 then
  Begin
    if isvalid then
     result.Add(pfnddat.cFileName);
    While FindNextFileA(h,pfnddat) do
    Begin
     if isvalid then
      result.Add(pfnddat.cFileName);
    End;
  End;
End;


Procedure ODS(s:String);
Var a:word;
Begin
  a:=z80_get_reg(Z80_REG_PC);
  LASTPC:=a;
  if dbgsl=nil then
   dbgsl:=tstringlist.create;
 {$IFNDEF NBDEBUG}
  EXIT;
 {$ENDIF}
  a:=z80_get_reg(Z80_REG_PC);
  s:=Timetostr(now)+'PC: '+inttohex(a,4)+','+inttohex(LastPC,4)+' '+s;
  OutputDebugString(pchar(s));
try
 dbgsl.add(s);
Except
 on e:Exception do
  Outputdebugstring(Pchar(e.message));
End;
 // NewDebug.dbg.items.insert(0,s);
  LASTPC:=a;
End;

var stl:string='';
    posx:integer=0;
    posy:integer=0;

procedure screenout(s:string);
Begin
  if ord(s[1])=hextoint('0a') then
  Begin
   fNewBrain.Memo1.Lines.Add(stl);
   stl:='';
   exit;
  end;
  stl:=stl+s;
  if ord(s[1])=13 then
  Begin
    inc(posY);
    posx:=0;
  end
  else
  Begin
   // nbscreen.PaintLetter(posx,posy,byte(s[1]));
    inc(posx);
    if posx>99 then       //100 chars horizontally
    Begin
      inc(posy);
      posx:=0;
    End;
  end;


End;

//Call back from emulator DLL


function IsBkpnt(thePc:Integer):Boolean;
Begin
  result:=newdebug.CheckBreak(thePC);
End;


Function READBYTE(ADDR:Integer):Integer;
Var a:word;
Begin
//  a:=z80_get_reg(Z80_REG_PC);   //not used
  result:=nbmem.ROM[ADDR];




END;

Procedure WRITEBYTE(Addr:Integer;B:Integer);
Var a:word;
Begin
 // a:=z80_get_reg(Z80_REG_PC);
{  if not fnewbrain.bootok then
   if addr>=$8000 then exit
  else
   if addr>=$A000 then exit;}
  nbmem.ROM[addr]:=b;

End;

Function GetCommentOnPort(prt:Integer):String;
Var s:String;
Begin
  S:='';
  Case prt of
    1:s:='Load En Reg 2';
    2:s:='Load Page Registers';
    3:s:='Centronics Printer Port';
    4:s:='Reset Clock Interrupt';
    5:s:='Load DAC';
    6:s:='Communicate With COP420';
    7:s:='Load Enable Register 1';
    8,10:s:='Set 9th bit of Video Addr';
    9,11:s:='Load First 8 bit of Video Addr';
    12,13,14,15:s:='Load Video Control Register';
    16:s:='Anin0 - Conversion channel 0,4';
    17:s:='Anin1 - Conversion channel 1,5';
    18:s:='Anin2 - Conversion channel 1,5';
    19:s:='Anin3 - Conversion channel 1,5';
    20:s:='Read Status Reg 1';
    21:s:='Read Status Reg 2';
    22:s:='Data Input Reg 1';
    23:s:='User Data Bus';
    24:s:='Control Reg ACIA';
    25:s:='Receive Data Reg ACIA';
    26,27:s:='Unused';
    28:s:='Ch 0 of CTC';
    29:s:='Ch 1 of CTC';
    30:s:='Ch 2 of CTC';
    31:s:='Ch 3 of CTC';
    200:s:='PIBOX ACIA';
    204:s:='PIBOX PAGING STATUS';
    205:s:='PIBOX PAGING STATUS';
    206:s:='PIBOX PAGING STATUS';
    207:s:='PIBOX PAGING STATUS';
    255:s:='Load Page Status Reg';
  End;

  Result:=s;
End;

Const ReversePorts=True;


function NewIn(port: Integer):Integer;
   {$IFDEF NBOutDEBUG}
var
    a:word;
    {$Endif}

   Function PortValid:Boolean;
   Begin
      Case Port And $ff of
//       2,255,9,12,4,6,20:result:=false;
       255:Result:=False;//SCREEN IO
      Else
       Result:=true;
     End;
     if ReversePorts then
      Result:=not Result;
   End;

Begin
 //Result := $FF;
 {$IFDEF NBOutDEBUG}
  a:=z80_get_reg(Z80_REG_PC);
 LASTPC:=a;
 {$Endif}
 LastIn:=(port and $ff);
 result:=NbIO.NBIN(LastIn);
 {$IFDEF NBOutDEBUG}
 if PortValid then
 ODS('PC:'+inttostr(a)+' Port IN '+inttostr(LastIn)+
  ' '+inttostr((Port and $f000) div 256 )+
   ' : '+inttostr(result)+'  -  '+GetCommentOnPort(LastIn));
 {$Endif}
End;



procedure NewOut(port: Integer; value: Integer);
Var ch:Char;

   Function PortValid:Boolean;
   Begin
      Case Port And $ff of
       7:result:=false;
       //2,255,9,12,4,6,7:result:=false;
       128:Result:=false;//SCREEN IO
      Else
       Result:=True;
     End;
     if ReversePorts then
      Result:=not Result;
   End;

Begin
 LastOut:=port and $ff;
 {$IFDEF NBOutDEBUG}
 ch:=' ';
 If value>32 then
  ch:=chr(value);
  if PortValid then
  ODS(' Port OUT '+inttostr(LastOut) +
      ' '+inttostr((Port and $f000) div 256 )+' : '
       +inttostr(value)+'['+ch+']  -  '+GetCommentOnPort(LastOut) );
 {$ENDIF}
  NbIO.NBOut(LastOut,Value);
End;

Var mytimeinterrupt:cardinal=0;
    mytimeinterrupt2:cardinal=0;
Function Getint:Boolean;
Begin
  result:=false;
  if newdebug.Visible then exit;

  if gettickcount-mytimeinterrupt>=22 then
  Begin
    INTERRUPT1:=TRUE;
    InterruptServed:=FALSE;
  end;
  if gettickcount-mytimeinterrupt2>=42 then
  Begin
    INTERRUPT2:=TRUE;
    InterruptServed:=FALSE;
  end;
  if kbint=1 then
  Begin
     INTERRUPT3:=TRUE;
     InterruptServed:=FALSE;
  end
  ELSE   INTERRUPT3:=FALSE;

  RESULT:=interrupt1 OR INTERRUPT2 OR INTERRUPT3;

End;

procedure TfNewBrain.clearinterrupt(v:byte);
Begin
  if v=0 then
   mytimeinterrupt:=gettickcount;
  if v=1 then
   mytimeinterrupt2:=gettickcount;

  InterruptServed:=true;
end;

{
Procedure RETI;cdecl;
Begin
  exit;
End;
}
Const MAxHist=50;
Var Prepc:Word;
    NTI:iNTEGER=0;
    Dostop:boolean;

procedure StepProc(Const pc: word);
var
    sp:word;
    IF1:word;

Begin
 //fnewbrain.thrEmulate.enabled:=false;
{$IFDEF NBDEBUG}
// sp:=  z80_get_reg(Z80_REG_SP);
// if pclist=nil then
// Begin
//  pclist:=tlist.create;
//  splist:=tlist.create;
//  pclist.Capacity:= MAxHist;
//  splist.Capacity:= MAxHist;
// End;
// if nti>10 then
// Begin
//   nti:=0;
//   if splist.count>MAxHist then
//   Begin
//    splist.delete(0);
//    splist.Add(Pointer(sp));
//   End
//   Else
//    splist.Add(Pointer(sp));
//   if pclist.count>MAxHist then
//   Begin
//    pclist.delete(0);
//    pclist.Add(Pointer(pc));
//   End
//   Else
//    pclist.Add(Pointer(pc));
//  End
//  Else
//   inc(nti);
{$ENDIF}
  IF1:=z80_get_reg(Z80_REG_IFF1);
//  Dostop:=  newdebug.checkbreak(pc);
  Prepc:=pc;

//  if dostop or (fnewbrain.debugging AND NOT STOPPED) then
//  Begin
//   z80_stop_emulating;
//   Stopped:=true;
//  End;


//  fnewbrain.thrEmulate.enabled:=true
End;

//interface with emulation DLL
procedure TfNewBrain.SetParams;
Begin

      Z80_getByte:=Readbyte;
      Z80_SetByte:=WriteByte;
      Z80_InB:=NewIn;
      Z80_OutB:=Newout;
      Z80_GetInterrupt:=Getint;
      z80_StepProc:=Stepproc;
      Z80_IsBreakpoint:=  IsBkpnt;
      myz80.setZ80_getByte(Readbyte);
      myz80.setZ80_SetByte(WriteByte);
      myz80.setZ80_InB(NewIn);
      myz80.setZ80_OutB(Newout);
      myz80.setZ80_GetInterrupt(GetInt);
      myz80.setZ80_IsBreakpoint(IsBkpnt);
   //   z80_set_reti(@RETI);
End;

procedure TfNewBrain.Button1Click(Sender: TObject);
begin
LoadImage;
frmvga.isGraph:=true;
end;

procedure TfNewBrain.Button2Click(Sender: TObject);
var staddr,addr,i:integer;
  j: Integer;
  ch:byte;
  fclr,bclr:byte;
begin
  staddr:=$0000;


  for j := 0 to 20-1 do
  Begin
   if j mod 2=1 then
    ch:=64
   else ch:=33;
   fclr:=random(15);
   bclr:=random(15);
   if fclr=bclr then
    bclr:=15-fclr;
   for i := 0 to 40-1 do
   Begin
     addr:=staddr+i+(j*40);
     nbmem.SetDirectMem(8,addr,ch);
     nbmem.SetDirectMem(8,addr+1024,fclr+bclr shl 4);
//     nbmem.SetRom(addr,ch);
//     nbmem.SetRom(addr+1024,fclr+bclr shl 4);
     inc(ch);
   End;
  end;
   frmvga.isGraph:=false;
end;

constructor TfNewBrain.Create(Aowner: TComponent);
begin
  inherited;
  acTapeSelect.enabled:=false;
  acTapeManagement.enabled:=false;
  acDiskManagement.enabled:=false;
  acReset.enabled:=false;
  acStEmul.Enabled:=true;
  acRomSel.Enabled:=true;
end;

procedure TfNewBrain.LoadImage;
Var img:Timage;
    i,x,y:integer;
    bt,bh,bl:byte;
    coll,colh:tColor;

    function makergb(col:TColor):byte;
    Const thres=83;
    var r,g,b,i:byte;
    Begin
       result:=0;
       b     := Col;
       g     := Col shr 8;
       r     := Col shr 16;
       if r>thres then
         result:=result or 4;
       if g>thres then
         result:=result or 2;
       if b>thres then
         result:=result or 1;
       if (r>127) or (g>127) or (b>127) then //intensity
          result:=result or 8;
    end;

Begin
  img:=timage.Create(nil);
  img.Picture.Bitmap.PixelFormat:= pf4bit;
  img.Picture.LoadFromFile('img.bmp');
  i:=0;
  for y:=0 to 200-1 do
    for x:=0 to 160-1 do
    Begin
      coll:=img.Canvas.Pixels[x*2,y];
      colh:=img.Canvas.Pixels[x*2+1,y];
      bl:=makergb(coll);
      bh:=makergb(colh);
      bt:=bl or (bh shl 4);
      nbmem.SetDirectMem(8,i,bt);
     // nbmem.SetRomForce($8000+i,bt);
      inc(i);
    end;
 // image1.Picture.Assign(img.Picture);
  img.Free;
End;

procedure TfNewBrain.Start1Click(Sender: TObject);
begin
  //Set Title
  if start1.Tag=0 then
  begin
   AppCaption:=caption;
   caption:=AppCaption+' ~ [ '+GetNewbrainDescr+' ]';
   start1.Tag:=1;
  end;
  //CREATE CLASSES
  acStEmul.enabled:=false;
  acReset.enabled:=true;
  WithExpansion1.Enabled:=false;
  WithCpm1.enabled:=false;
  acTapeSelect.enabled:=true;
  acTapeManagement.enabled:=true;
  acDiskManagement.enabled:=true;
  acRomSel.Enabled:=false;
  ShowDriveContents1.enabled:=true;
  SaveNewSystem1.enabled:=true;
  LoadBinaryFileInMemory1.enabled:=true;
  LoadTextFile1.enabled:=true;
  Restart1.enabled:=true;
  //Disassembly1.enabled:=true;
  //Start Emulation
  BootOk:=false;
  try
   freeandnil(nbio);
   freeandnil(nbmem);
   freeandnil(nbscreen);
   freeandnil(TapeInfo);
  except

  end;
  TapeInfo:=TTapeInfo.create;
  NBIO:=TNBInoutSupport.Create;
  NBMem:=TNBMemory.Create;
  NBScreen:=TNbScreen.create;
  nbscreen.whitecolor:=GetColor(foptions.Fore.Selected);
  nbscreen.Blackcolor:=GetColor(foptions.Back.Selected);
  nbscreen.Newscr:=newscr;
  nbscreen.Clearscr;
  halted:=false;


   LoadCharset('CharSet2.chr');
  //---- Z80 Engine interface
  nbmem.Fpath:=root+'\roms\';
  if not nbmem.LoadMem then
   nbmem.init
  else
    WriteP1('Ram/Rom Setup from .ini');
    //todo:print to info panel the loaded rom version

  fVGA.show;


 { For j:=0 to $1fff do
   nbmem.Rom[j]:=nbmem.rom[$e000+j];}
  SetParams;        //Add Handlers
  MyZ80.Z_Reset; // reset the CPU */

//---- Z80 Engine interface


//newdebug.bpnts.items.add('48E1');
//newdebug.bpnts.items.add('48EE');

 // newdebug.bpnts.items.add('B785');
 // newdebug.bpnts.items.add('E162');
//  newdebug.bpnts.items.add('E17c');
//  newdebug.bpnts.items.add('E17B');
//  bpnts.items.add('E025');
//  bpnts.items.add('E039');
 //newdebug.bpnts.items.add('6039');
// newdebug.bpnts.items.add('0000');
// newdebug.bpnts.items.add('0001');
  FullScreen1.Checked:=Not FullScreen1.Checked;
  FullScreen1Click(nil);
  if ShowDriveContents1.Checked and WithCPM1.Checked then
   ShowDriveContents1Click(nil);
  if not withcpm1.Checked then
  Begin
     acDiskManagement.Enabled:=false;
     ShowDriveContents1.Enabled:=false;
     SaveDisckNOW1.Enabled:=false;
  End;
 // MyZ80.Z_Set_Reg(Z80_REG_PC,hextoint('8200h'));
  thrvideo.Enabled:=true;



  Resumeemul;

  fNewbrain.SetFocus;
end;

var shft:TShiftState;

function translatekey(key:word):word;
var KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState) ;
   RESULT:=KEY;

 if ssShift in shft then
 Begin
   case key of
      16,20:result:=0;
      49:result:=33;   //!
      50,106:result:=64;    //@
      51:result:=35;    //#
      52:result:=36;    //$
      53:result:=37;    //%
      54:result:=94;    //^
      55:result:=38;    //&
      56:result:=42;   //*
      57:result:=40;    //(
      48:result:=41;    //)
      65..90: Begin
               if (KeyState[VK_CAPITAL] = 0) then
                 result:=key+32;
              end;
      186:result:=58; // :
      107,187:result:=43; //+
      188:result:=60; //<
      189:result:=95; //_
      190:result:=62; //>
      191:result:=63; //?
      192:result:=126;//~
      219:result:=123; //{
      221:result:=125; //}
      222:result:=34;
      39:result:=7;//->
      37:result:=5;//<-
      116:RESULT:=165; //3 F5
      117:RESULT:=166; //$0B;   //F6
      118:RESULT:=167; //$83;       //F7
      119:RESULT:=168;//$0A;           //F8


     else result:=key;
   end;
 end
 else
  case key of
    //  8:result:=8;
    //  10:result:=10;
    //  13:result:=13;
      16,20:result:=0;
      106:result:=42; //*
      186:result:=59; // ;
      187:result:=61; //=
      188:result:=44;  //,
      109,189:result:=45; //-
      190:result:=46; //.
      111,191:result:=47; ///
      192:result:=44; //`
      219:result:=91; // [
      221:result:=93; //]
      222:result:=96; //'
      //65..90:result:=key+32;
      65..90: Begin
               if (KeyState[VK_CAPITAL] = 0) then
                 result:=key+32;
              end;
      39:result:=3;//->
      37:result:=4;//<-
      38:result:=11;//pano
      40:result:=10;//kato
      36:result:=9;//home
      46:result:=2;//del
      8: result:=6;//backspase
      45:result:=1;//insert
      116:RESULT:=165;//3;
      117:RESULT:=166;//$0B;
      118:RESULT:=167;//$83;
      119:RESULT:=168;//$0A;

     else result:=key;
   end;
End;

procedure TfNewBrain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  If key=vk_f9 then
  Begin
    if nbdel>1 then
     dec(nbdel);
    Exit;
  End;
  If key=vk_f10 then
  Begin
    inc(nbdel);
    Exit;
  End;
 
 // nbkeyboard.PCKeyUp(Key,Shift);
end;

procedure TfNewBrain.MakeTapeButtons;
Var btn:TButton;
    bw,bh:Integer;
Begin
 bw:=20;
 bh:=18;

 btn:=TButton.create(self);
 btn.Parent:=statusbar1;
 btn.left:=0;
 btn.top:=1;
 btn.width:=bw;
 btn.height:=bh;
 btn.font.Size:=6;
 btn.caption:='<<';
 btn.tag:=1;
 btn.onClick:=tpbtnClick;
 btn.Hint:='First file on tape';
 btn.ShowHint:=true;
 btn.TabStop:=false;

 btn:=TButton.create(self);
 btn.Parent:=statusbar1;
 btn.left:=bw+1;
 btn.top:=1;
 btn.width:=bw;
 btn.height:=bh;
 btn.font.Size:=6;
 btn.caption:='<';
 btn.tag:=2;
 btn.onClick:=tpbtnClick;
 btn.Hint:='Previous file on tape';
 btn.ShowHint:=true;
 btn.TabStop:=false;

 btn:=TButton.create(self);
 btn.Parent:=statusbar1;
 btn.left:=2*(bw+1);
 btn.top:=1;
 btn.width:=bw;
 btn.height:=bh;
 btn.font.Size:=6;
 btn.caption:='>';
 btn.tag:=3;
 btn.onClick:=tpbtnClick;
 btn.Hint:='Next file on tape';
 btn.ShowHint:=true;
 btn.TabStop:=false;

 btn:=TButton.create(self);
 btn.Parent:=statusbar1;
 btn.left:=3*(bw+1);
 btn.top:=1;
 btn.width:=bw;
 btn.height:=bh;
 btn.font.Size:=6;
 btn.caption:='>>';
 btn.tag:=4;
 btn.onClick:=tpbtnClick;
 btn.Hint:='Last file on tape';
 btn.ShowHint:=true;
 btn.TabStop:=false;

 btn:=TButton.create(self);
 btn.Parent:=statusbar1;
 btn.left:=4*(bw+1);
 btn.top:=1;
 btn.width:=bw;
 btn.height:=bh;
 btn.font.Size:=6;
 btn.caption:='^';
 btn.tag:=5;
 btn.onClick:=tpbtnClick;
 btn.Hint:='Eject tape';
 btn.ShowHint:=true;
 btn.TabStop:=false;

End;

procedure TfNewBrain.tpbtnClick(Sender: TObject);
Var btn:TButton;
Begin
  Self.activecontrol:=nil;
  if not (sender is tbutton) then exit;
  if not tapeinfo.TapeLoaded then
  Begin
   ShowMessage('Load A Tape First');
   exit;
  End;
  btn:=TButton(sender);
  Case btn.tag of
   1:Tapeinfo.FirstFile;
   2:Tapeinfo.PrevFile;
   3:Tapeinfo.NextFile;
   4:Tapeinfo.LastFile;
   5:Tapeinfo.Eject;
  End;
  fnewbrain.StatusBar1.Panels[0].Text:=Tapeinfo.GetNextFileName;
End;

procedure TfNewBrain.UpdateCheck1Click(Sender: TObject);
begin
 frmUpdate.show;
end;

procedure TfNewBrain.FormCreate(Sender: TObject);
begin
//   thremulate:=nil;
   timeBeginPeriod(1);
   Savedialog1.initialdir:=root+'Progs\';
   Mhz:=8;
   statusbar1.TabStop:=false;
//   statusbar1.onkeydown:=FormKeyDown;
//   statusbar1.onkeyup:=FormKeyUp;
   if fileexists(ExtractFilepath(application.exename)+'charmap0.cmp') then
    LoadCharMap
   else
    FillCharArray;
end;



var copcnt:cardinal=0;
    clkcnt:cardinal=0;
    emulating:boolean=false;
    tm:cardinal=0;
    s1:string;

procedure TfNewBrain.thrEmulateTimer(Sender: TObject; LagCount: Integer);
begin
 thrEmulate.Enabled:=false;
 try
  StartEmulation;
 finally
    thrEmulate.Enabled:=true;
 end;
end;


procedure TfNewBrain.thrVideoTimer(Sender: TObject);
begin
 thrVideo.enabled:=false;
 try
  if nbscreen<>nil then
   try
    nbscreen.PaintVideo;
   except
   end;
  finally
   thrVideo.enabled:=true;
  end;
end;

var emulate:integer=2000;

//should return tstates difference
function TfNewBrain.getemulsatspeedtime(eml,time:cardinal):longint;
var t,sd:real;
Begin
  //eml tstates at time
  t:=Mhz*CPUSTates;//convert speed at states
  //t states at 1 sec
  sd:=(t*time)/1000; //should done tstates at time
  emuls:=eml*(1000/time)/CPUStates;//in MHZ
  emuls:=Trunc(emuls*100) / 100;
  result:=trunc(sd-eml);
end;


var Pretick2:cardinal;
    mydelay,extradel:integer;

    lastmhz1,lastmhz2:real;
    meanamhz:real;
    OLDINT,oldnbdel:integer;
    wasdebug:boolean=false;
    EXECUTINGINTERRUPT:BOOLEAN=FALSE;
procedure TfNewBrain.DoEmulation(st:integer=40000);
var dif:Real;
    tr,m1:integer;
    tmdif:Integer;
    tmellapsed:Cardinal;
Begin


  if sle=nil then sle:=tstringlist.create;
  if bootok and ((NBkey=$80) or (nbkey=0))  then
     CheckKeyBoard;
  If Debugging or checkBpts then
  Begin
    Stopped:=false;
    oldint:=thrEmulate.Interval;
    oldnbdel:=nbdel;
    thrEmulate.Interval:=0;
    NBDEL:=1;
    wasdebug:=true;
    if not debugging and checkBpts then
         emuled:=emuled+Z80_Emulate(st)
    else
     //emuled:=emuled+Z80_Emulate(st-emuled);
     emuled:=emuled+Z80_Emulate(st);

  End
  Else
  Begin
     if wasdebug then
     Begin
      wasdebug:=false;
      nbdel:=oldnbdel;
      thrEmulate.Interval:=oldint;
     End;
     Emuled:=0;
//     EMUReal:=emureal+(st*1000) div 4000000; //time to process st Tstates @ 4Mhz
//     EMUReal:=emureal+st DIV trunc((CPUStates * Mhz)); //time to process st Tstates @ 4Mhz
    // EMUReal:=emureal+st;

     // st:=Z80_Emulate(st);
      st:=Z80_Emulate(emulate);

    // EMUDif:=Stopwatch.ElapsedMilliseconds-EMUTime;

  End;
  // if DEBUGGING OR (tmpbpt<>-1) then EXIT;
  if EXECUTINGINTERRUPT then EXIT;
  //check if there is an interrupt
  if GETINT then
  Begin
  // z80_set_reg(Z80_REG_IFF1,1);
   if z80_get_reg(Z80_REG_IFF1)=1 then
   Begin
     EXECUTINGINTERRUPT:=TRUE;
     st:=st+Myz80.Z_Interrupt;
     if interrupt2 then
       clearinterrupt(1)
     ELSE
     if interrupt1 then
       clearinterrupt(0);

      EXECUTINGINTERRUPT:=FALSE;
   end;

  end;



 { Inc(cEmuls);
  if cemuls<2000 then
   sle.add(inttostr(st)+'  '+fl)
  else
  Begin
   sle.savetofile('c:\emuls.txt');
   suspend1click(nil);
  End;
  }
  Ems:=Ems+st;//Tstates

  tmellapsed:=GetTickCount-Pretick2;
  If  tmellapsed>=1000 then
  Begin
    Pretick2:=GetTickCount;
    //how many tstates should have done
//    EMUReal:=trunc((GetTickCount-Pretick)  *(CPUStates * Mhz) );
    lastmhz2:=lastmhz1;
    lastmhz1:=trunc(emuls);
    idif:=getemulsatspeedtime(ems,tmellapsed);
    if idif>0 then
     m1:=1 else m1:=-1;
    meanamhz:=(emuls+lastmhz1+lastmhz2) / 3;
    idif:=abs(idif);
    lastems:=ems;
    lasttime:=tmellapsed;
    Ems:=0;

  if abs(meanamhz-mhz)>0.15 then
  begin

//    tr:=abs(trunc(idif/100000));
    if idif>20000000 then
      tr:=7000
    else
    if idif>15000000 then
      tr:=5000
    else
    if idif>10000000 then
      tr:=4000
    else
    if idif>7000000 then
      tr:=3000
    else
    if idif>4000000 then
      tr:=2000
    else
    if idif>3000000 then
      tr:=2000
    else
    if idif>1500000 then
      tr:=300
    else
    if idif>1000000 then
      tr:=20
    else
    if idif>50000 then
      tr:=4
    ELSE
      tr:=1;

    tr:=math.max(integer(1),integer(tr));

    if m1>0 then
     dec(nbdel,tr)
    else
    if m1<0 then
      inc(nbdel,tr);

      if nbdel<0 then
       nbdel:=1;
      if nbdel>50000 then
       nbdel:=49000;

     emulate:=50000-nbdel;
//      tr:=nbdel div 80;
   //  if (thrEmulate.Interval=1) and (tr=0) then
    //  extradel:=nbdel*10;


     thrEmulate.Interval:=0;

    end;
   // if thrEmulate.Interval>0 then
     //extradel:=0;
   // DELAY(0,nbdel mod 80);
    //DELAY(0,nbdel);

  end;


 {
  If GetTickCount-Pretick>=1000 then
  Begin


   // cpcnt:=0;
   //  ckcnt:=0;
   Emuls:= Ems / (1000000);//4Mhz
   dif:=mhz-emuls;

     Stopwatch.Stop;
     EMUTIME:=Stopwatch.ElapsedMilliseconds;
     if (emureal>1000) and (emutime<1100) then
     Begin
    //   delay(0,(emureal-emutime) );
     End;

//     While EMUTime<1000 do
//     Begin
//      Stopwatch.Start;
//      sleep(1);
//      application.ProcessMessages;
//      Stopwatch.Stop;
//      Emutime:=Emutime+Stopwatch.ElapsedMilliseconds
//     end;
     EMUReal:=0;
     Stopwatch.Start;
   Ems:=0;
   PreTick:=GetTickCount;
//   sleep(nbdel);
  End; //gettickcount}
End;

procedure TfNewBrain.Button3Click(Sender: TObject);
Var addr:String;
    k:Integer;
begin
 if InputQuery('ADDRESS', 'Prompt', Addr) then
 BEgin
   k:=NewDebug.bpnts.items.indexof(Addr);
   if k=-1 then
    NewDebug.bpnts.items.add(ADDR);
 End;
end;

procedure TfNewBrain.Button4Click(Sender: TObject);
begin
 if NewDebug.bpnts.ItemIndex>-1 then
   NewDebug.bpnts.Items.delete(NewDebug.bpnts.ItemIndex);
end;

procedure TfNewBrain.Exit1Click(Sender: TObject);
begin
 Close;
end;

function TfNewBrain.GetRoot: string;
begin
   Result := Extractfilepath(application.exename);
end;

procedure TfNewBrain.Debug2Click(Sender: TObject);
begin
 debug2.checked:= not debug2.checked;
 if assigned(NewDebug) then
   NewDebug.Visible:=debug2.checked;
end;

Function TfNewBrain.CreateOpenDialog:TOpenDialog;
Begin
  result:=TopenDialog.create(Self);
  result.Options:=[ofHideReadOnly,ofEnableSizing];
  result.filter:='NewBrain Files|*.sav';
  result.DefaultExt:='*.sav';
  Result.initialdir:=root+'Progs\';
  result.FilterIndex:=1;
End;

procedure TfNewBrain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
    AShift: TShiftState;
begin
   ashift:=[];
   if getasynckeystate(VK_RShift)<>0 then
    RShift:=true //send it in nbkeyboard
   else
     RShift:=false;
   if getasynckeystate(VK_RShift)<>0 then
    ashift:=ashift+[ssShift];
   if getasynckeystate(VK_LShift)<>0 then
    ashift:=ashift+[ssShift];
   if getasynckeystate(VK_LControl)<>0 then
    ashift:=ashift+[ssCtrl];
   if getasynckeystate(VK_RControl)<>0 then
    ashift:=ashift+[ssAlt];

   //nbKeyboard.PCKeyDown(Key,AShift);
    shft:=Shift;
    mykey:=translatekey(key);
    ODS('KEY='+inttostr(key)+' NEW='+inttostr(mykey));
    //TO EMULATE REAL KEYBOARD
//    AddNewKeyPressed($58);//CAPS
//    AddNewKeyPressed($F0);
//    AddNewKeyPressed($58);    
//    
//    AddNewKeyPressed($21);//C
//    AddNewKeyPressed($F0);
//    AddNewKeyPressed($21);    
end;

procedure TfNewbrain.AddNewKeyPressed(nk:word);
var k:integer;
Begin
  nk:=reversebits(byte(nk));
  if keylist=nil then
    keylist:=tstringlist.Create;

  k:=keylist.Count; inc(k);
  keylist.AddObject(inttostr(nk),tobject(nk));
  kbint:=1;
end;

function TfNewbrain.getNewKey:byte;
var k:integer;
Begin
   result:=0;
   if not assigned(keylist) then exit;
   k:=keylist.Count;
   if k>0 then
   Begin
     result:=byte(keylist.Objects[0]);
     keylist.Delete(0);
     k:=keylist.Count;
   end;

   if k=0 then kbint:=0;

end;

Function ReverseBits(b1:Byte):Byte;
Begin
  Asm
      push ax
      push bx
      mov al,b1
      mov bl,0
      mov bh,8
@@ee: rcr al,1
      rcl bl,1
      dec bh
      jnz @@ee
      mov Result,bl
      pop bx
      pop ax
  End;
End;

var eer:integer=0;

procedure TfNewBrain.SuspendEmul;
begin
 IsSuspended:=true;
 //thrscreen.Enabled:=false;
 thrEmulate.Enabled:=False;
end;

procedure TfNewBrain.svserialClick(Sender: TObject);
begin
 NEWSCR.SetFocus;
end;

procedure TfNewBrain.ResumeEmul;
begin
 IsSuspended:=False;
// thrscreen.Enabled:=true;
 //IdThreadComponent1.Start;
 thrEmulate.Enabled:=true;
end;

procedure TfNewBrain.Suspend1Click(Sender: TObject);
begin
 Suspend1.checked:= not Suspend1.checked;
 if  Suspend1.checked then
  Suspendemul
 else
  resumeemul;
end;

procedure TfNewBrain.StartEmul;
begin
 IsSuspended:=False;
end;

procedure TfNewBrain.terminate1Click(Sender: TObject);
begin
 //FPS Check Menu
 Terminate1.Checked:=not Terminate1.Checked;
 if Assigned(nbscreen) then
  Nbscreen.ShowFps:=Terminate1.Checked;
end;

procedure TfNewBrain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

 SaveOptions;
end;

procedure TfNewBrain.SetMHz1Click(Sender: TObject);
var m:String;
begin
 m:=floattostr(mhz);
 if inputquery('Input Cpu Speed in MHz ','Value (Float) (Default 8)',m) then
 Begin
   try
     Mhz:=strtofloat(m);
   Except
     if pos(',',m)>0 then
       m:=stringreplace(m,',','.',[])
     else
       m:=stringreplace(m,'.',',',[]);
     try
      Mhz:=strtofloat(m);
     Except
      Mhz:=1;
     End; 
   End;
 End;
end;

procedure TfNewBrain.FormShow(Sender: TObject);
var fRomVersion: TfRomVersion;
begin
   fRomVersion:= TfRomVersion.create(nil);
   try
    fRomVersion.getRomVersion(Vers,sVers);
    RefreshRomVer;
   finally
     fRomVersion.free;
   end;
   MakeTapeButtons;
   Debug2Click(Sender);
   //Memo1.SetFocus;
   //left:=screen.DesktopWidth-width-10-80;
end;

procedure TfNewBrain.SetBasicFile1Click(Sender: TObject);
begin
  opendialog1.initialdir:='';
  if opendialog1.Execute then
  Begin
   if Sametext(extractfileext(opendialog1.FileName),'.bin') then
   ;
//   BinaryFile1.checked:=cop420.FileIsBinary;

   delay(1,0);
   kbuf:='LOAD';
   nbkeyboard.import(kbuf);
  End;

end;

procedure TfNewBrain.setDebugging(const Value: Boolean);
begin
 bDebugging:=value;
 Z80Steping:=value;
 if not value then
 Begin
   fnewbrain.thrEmulate.Tag:=0;
 end;

end;

procedure TfNewBrain.WriteP1(s:String);
begin
 fnewbrain.statusbar1.Panels[0].text:=s;
end;

procedure TfNewBrain.WriteP2(s:String);
begin
 fnewbrain.statusbar1.Panels[1].text:=s;
end;

procedure TfNewBrain.WriteP3(s:String);
begin
 fnewbrain.statusbar1.Panels[3].text:=s;
end;

procedure TfNewBrain.timptimerTimer(Sender: TObject);
var ch:char;
Begin
   if  length(kbuf)=0 then
   Begin
     timptimer.Enabled:=false;
     ShowMessage('Import Finished');
   end
   else
   if mykey=0 then
   Begin
      ch:=kbuf[1];
      kbuf:=copy(kbuf,2,maxint);
      mykey:=ord(ch);
   end;

end;

procedure TfNewBrain.doImport;

Begin
 timptimer.enabled:=true;
end;


procedure TfNewBrain.LoadTextFile1Click(Sender: TObject);
Var sl:Tstringlist;
    fpath:String;
    opdlg:TopenDialog;
begin
 fpath:=Extractfilepath(application.exename);
 opdlg:=TopenDialog.create(nil);
try
 opdlg.InitialDir:=fpath;
 if opdlg.execute then
 Begin
   sl:=Tstringlist.create;
   try
    sl.loadfromfile(opdlg.FileName);
   kbuf:=sl.text;
   finally
    sl.free;
   end;
   kbufc:=1;
  // nbkeyboard.import(kbuf);
   keybFileinp:=true;
   doImport;
 End;
Finally
  opdlg.free;
End;
end;

procedure TfNewBrain.DesignChars1Click(Sender: TObject);
begin
  // Suspendemul;
   fchrdsgn:= Tfchrdsgn.create(nil);
   fchrdsgn.show;
end;

procedure TfNewBrain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var s:String;
   i:Integer;
begin
 try
  if assigned(nbdiscctrl) then
  Begin
   nbdiscctrl.dir1:='';
   nbdiscctrl.dir2:='';
  End;
 Except
 End;
 IsSuspended:=true;
// sleep(1000); 
 try
  if assigned( dbgsl) then
  Begin
    if pclist<>nil then
    Begin
      dbgsl.add('------END-----');
      dbgsl.add('PC,SP HISTORY');
      For i:=0 to pclist.count-1 do
      Begin
        s:=format('PC: %d - SP: %d',[Integer(pclist[i]),Integer(splist[i])]);
        dbgsl.add(s);
      end;
    End;
    dbgsl.SaveToFile(AppPath+ 'ODS2.txt');
   End;
  Except
  End;
end;

procedure TfNewBrain.About1Click(Sender: TObject);
begin
 Fabout:=Tfabout.Create(Self);
 fabout.showmodal;
 Freeandnil(fabout);
end;

procedure TfNewBrain.SetLed(Sender:Tobject);
BEgin
 leddisp.text:=Nbscreen.ledtext;
End;

//Keyboard Mappings
procedure TfNewBrain.SaveCharMap;
Var i:Integer;
    sl:tstringlist;
begin
     sl:=tstringlist.create;
     try
       For i:=1 to 255 do
        sl.values['PC_'+inttostr(i)]:=inttostr(a[0,i]);
       sl.savetofile(ExtractFilepath(application.exename)+'charmap0.cmp');
       sl.clear;
       For i:=1 to 255 do
        sl.values['PC_'+inttostr(i)]:=inttostr(a[1,i]);
       sl.savetofile(ExtractFilepath(application.exename)+'charmap1.cmp');
     Finally
       sl.free;
     End;
end;

//Keyboard Mappings
procedure TfNewBrain.LoadCharMap;
Var i:Integer;
    sl:tstringlist;
begin
     sl:=tstringlist.create;
     try
       sl.Loadfromfile(ExtractFilepath(application.exename)+'charmap0.cmp');
       For i:=1 to 255 do
        a[0,i]:=strtoint(sl.values['PC_'+inttostr(i)]);
       sl.clear;
       sl.LoadFromfile(ExtractFilepath(application.exename)+'charmap1.cmp');
       For i:=1 to 255 do
         a[1,i]:=Strtoint(sl.values['PC_'+inttostr(i)]);
     Finally
       sl.free;
     End;
end;

procedure TfNewBrain.SaveCharMap1Click(Sender: TObject);
begin
  SaveCharMap;
end;

procedure TfNewBrain.TapeManagement1Click(Sender: TObject);
begin
   fTapeMgmt:= TfTapeMgmt.create(Self);
   try
    if fTapeMgmt.showmodal=MROk then
     if fTapeMgmt.Selected<>'' then
       tapeinfo.LoadTape(fTapeMgmt.Selected);
   Finally
    fTapeMgmt.free;
   End;
//  Seldir.InitialDir:=extractfilepath(Application.exename)+'\Basic\';
//  if seldir.Execute then
//   tapeinfo.LoadTape(extractfilename(seldir.Directory));
end;

procedure TfNewBrain.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
 exit;
 case msg.message of
  WM_KEYFIRST..WM_KEYLAST:
   ShowMEssage('hi');
 End;
 Handled:=false;
end;

procedure TfNewBrain.WithExpansion1Click(Sender: TObject);
begin
 WithExpansion1.Checked:=not WithExpansion1.checked;
end;

procedure TfNewBrain.WithCPM1Click(Sender: TObject);
begin
 WithCPM1.Checked:=not WithCPM1.checked;
end;

procedure TfNewBrain.WithPiboxClick(Sender: TObject);
begin
  Withpibox.Checked:=not WithPibox.Checked;
  if Withpibox.Checked then
  Begin
    WithExpansion1.Checked:=false;
//    WithCPM1.Checked:=false;
    WithExpansion1.Enabled:=false;
//    WithCPM1.Enabled:=false;
  end
  else
  begin
    WithExpansion1.Enabled:=true;
//    WithCPM1.Enabled:=true;
    WriteP2('');
  end;
end;

function TfNewBrain.GetOLDOS: Byte;
begin
   Result := nbmem.rom[$AD];
end;

procedure TfNewBrain.DiskManagement1Click(Sender: TObject);
Var dir1,dir2:String;
    t:integer;
begin
 dir1:=NBDiscCtrl.dir1;
 Dir2:=NBDiscCtrl.dir2;
 t:= fDiskMgmt.lb1.items.indexof(dir1);
 fDiskMgmt.lb1.itemindex:=t;
 if t=-1 then
  Dir1:='';
 t:= fDiskMgmt.lb2.items.indexof(dir2);
 fDiskMgmt.lb2.itemindex:=t;
 if t=-1 then
  Dir2:='';
 if fDiskMgmt.ShowModal=mrok then
 Begin
  if fDiskMgmt.lb1.Itemindex>-1 then
   dir1:=fDiskMgmt.lb1.items[fDiskMgmt.lb1.Itemindex]
  Else
   Dir1:='';
  if fDiskMgmt.lb2.Itemindex>-1 then
   dir2:=fDiskMgmt.lb2.items[fDiskMgmt.lb2.Itemindex]
  Else
   Dir2:='';
  NBDiscCtrl.dir1:=Dir1;
  NBDiscCtrl.dir2:=Dir2;
  ShowDriveContents1Click(nil);
 End;
end;

procedure TfNewBrain.FormDestroy(Sender: TObject);
begin
  timeEndPeriod(1);
end;

procedure TfNewBrain.SaveMemoryMap1Click(Sender: TObject);
Var m:TNBMemory;
begin
 m:=TNBMemory.create;
 m.SaveMem;
 m.free;
end;

procedure TfNewBrain.SaveMemorytoDisk1Click(Sender: TObject);
var stmem,bytelen:integer;
    f:TFilestream;
    nbb:byte;
    i:integer;
begin
  if start1.enabled then exit;
  stmem:= 642;//nb screen start
  bytelen:=11000;
  f:=tfilestream.Create(AppPath+'nbscreen.bin',fmCreate  );
  for i := stmem to stmem+bytelen-1  do
  Begin
   nbb:=nbmem.Rom[i];
   f.Write(nbb,1);
  end;
  f.Destroy;
end;

procedure TfNewBrain.Step;
begin
  DoOne:=true;
end;

Type tcolrec=record
               r:Byte;
               g:Byte;
               b:Byte;
             End;
     pColRec=^tcolrec;

Function TfNewBrain.GetColor(cl:TColor):TColor;
Var pc:pColRec;
    t:Byte;
Begin
  pc:=@cl;
  t:=pc.r;
  pc.r:=pc.b;
  pc.b:=t;
  result:=cl;
End;

function TfNewBrain.getDebugging: Boolean;
begin
  result:=bDebugging;
end;

procedure TfNewBrain.Options1Click(Sender: TObject);
begin
   if foptions.showmodal=mrok then
   Begin
    if assigned(nbscreen) then
    Begin
     nbscreen.whitecolor:=GetColor(foptions.Fore.Selected);
     nbscreen.Blackcolor:=GetColor(foptions.Back.Selected);
    End;
   End;
end;

procedure TfNewBrain.VFDisplayUp1Click(Sender: TObject);
begin
  VFDisplayUp1.checked:=not VFDisplayUp1.checked;
  if VFDisplayUp1.checked then
   panel1.align:=altop
  else
   panel1.align:=albottom; 
end;

procedure TfNewBrain.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
 ShowMessage(e.message+#13#10+'Emulator will be terminated');
 ExitProcess(0);
 Halt(0);
end;

procedure TfNewBrain.Help2Click(Sender: TObject);
//Var pth:String;
begin
 // pth:=ExtractFilePath(Application.exename);
//  ShowText('',pth+'help.txt','Newbrain Help');
 Shellexecute(Handle,'open',Pchar('newbrain.hlp'),nil,Pchar(Root),SW_SHOW);
end;

procedure TfNewBrain.OpenFile(Fname:String);
Begin
 Shellexecute(Handle,'open',Pchar(Fname),nil,Pchar(ExtractFilePath(Fname)),SW_SHOW);
End;

procedure TfNewBrain.NBDigitizer1Click(Sender: TObject);
begin
 If fileexists(Root+'tools\NBDigit2.exe') then
  OpenFile(Root+'tools\NBDigit2.exe')
 Else
  MessageDlg('Place NbDigit2.exe in the tools subdir.', mtWarning, [mbOK], 0);
end;

procedure TfNewBrain.newscrResize(Sender: TObject);
begin
  //
  ods('screen resizs');
end;

procedure TfNewBrain.CaptureRawScreen1Click(Sender: TObject);
begin
 if assigned(NBScreen) then
  nbscreen.capturetodisk;
end;

procedure TfNewBrain.CheckRoms1Click(Sender: TObject);
begin
 if fileexists(Root+'tools\CRoms.exe') then
  OpenFile(Root+'tools\CRoms.exe')
 else
  MessageDlg('Place CRoms.exe in the tools subdir.', mtWarning, [mbOK], 0);
end;

procedure TfNewBrain.Disassembly1Click(Sender: TObject);
begin
  ShowDisassembler;
end;

procedure TfNewBrain.ShowDriveContents1Click(Sender: TObject);
begin
 if sender<>nil then
   ShowDriveContents1.Checked:= not ShowDriveContents1.checked;
 if fDrvInfo=nil then
  fDrvInfo:=TfDrvInfo.create(Self);
 fDrvInfo.visible:=ShowDriveContents1.checked;
 fDrvInfo.FillInfo(-1);
end;

procedure TfNewBrain.FormResize(Sender: TObject);
begin
  if fDrvInfo.Visible then
   fDrvInfo.DoResize1;
  if fvga.visible then
   fVGA.DoResize1;
end;

procedure TfNewBrain.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if assigned(fDrvInfo) and fDrvInfo.Visible then
   fDrvInfo.DoResize1;
  if assigned(fvga) and fvga.visible then
   fVGA.DoResize1;

end;

procedure TfNewBrain.ShowSplash(DoShow:Boolean=true);
begin
 If DoShow then
 Begin
  fsplash:=TFSplash.create(Self);
  fsplash.Show;
 End
 Else
  FSplash.free;
end;

procedure TfNewBrain.FormActivate(Sender: TObject);
var s:string;
begin
   OnActivate:=nil;
//   ShowSplash(True);
   LoadOptions;
   RefreshRomVer;
//   Delay(1,500);
//   ShowSplash(False);
   ShowInstructions1Click(nil);
   if frmupdate.CheckVersion(s) then
     WriteP2('New Version exist!!! Please update.');

end;

procedure TfNewBrain.KeyboardMapping1Click(Sender: TObject);
begin
  if fileexists(Root+'tools\NBMapKeyb.exe') then
   OpenFile(Root+'tools\NBMapKeyb.exe')
  else
    MessageDlg('Place NBMapKeyb.exe in the tools subdir.', mtWarning, [mbOK], 0);
end;

procedure TfNewBrain.Reset1Click(Sender: TObject);
begin
   SuspendEmul;
   fnewbrain.bootok:=false;
   start1.enabled:=true;
   start1click(nil);
end;

procedure TfNewBrain.Restart1Click(Sender: TObject);
Var fn:String;
begin
 fn:=Application.exename;
 ShellExecute(0,'OPEN',Pchar(fn),nil,Pchar(ExtractFilepath(fn)),SW_SHOW);
 Close;
end;

procedure TfNewBrain.FullScreen1Click(Sender: TObject);
begin
 FullScreen1.Checked:=not FullScreen1.Checked;
 if Start1.enabled then exit; 
 If FullScreen1.Checked then
 Begin
  newscr.Options:=Newscr.Options+[doFullScreen];
  Debug2.enabled:=false;
  LedDisp.visible:=false;
 End
 else
 Begin
   newscr.Options:=Newscr.Options-[doFullScreen];
   Debug2.enabled:=True;
   LedDisp.visible:=true;
 End;
 newscr.Initialize;
end;

//Load a .LDR and the correspondin bin file to memory
procedure TfNewBrain.LoadBinaryFileInMemory1Click(Sender: TObject);
var sl:Tstringlist;
    sts,ses:String;
    st,se,i:Integer;
    sf:TFileStream;
    b:byte;
begin
  if OpenDialog2.execute then
  Begin
     sl:=Tstringlist.create;
     try
       sl.LoadFromFile(OpenDialog2.filename);
       sts:=sl.Values['ADDRESS'];
       ses:=sl.Values['LENGTH'];
       If GetValidInteger(sts,st) and GetValidInteger(ses,se) then
       Begin
          sf:=TFileStream.Create(ChangeFileext(OpenDialog2.filename,'.BIN'),fmOpenRead);
          try
            for i := 0 to se-1 do
            Begin
               sf.Read(b,1);
               nbmem.SetRom(st+i,b);
            end;
            ShowMessage('File Loaded at Address:'+sts+' ['+ses+' bytes]');
          finally
            sf.Free;
          end;
       end;
     finally
       sl.free;
     end;
  end;
end;

procedure TfNewBrain.SaveNewSystem1Click(Sender: TObject);
Var NewSysNm:String;
begin
  NewSysNm:='System1.dsk';
  If InputQuery('Sys File Name', 'Prompt', NewSysnm) then
   nbdiscctrl.SaveNewSystem(NewSysnm);
end;

Var DebugTimer:Integer;

function TfNewBrain.checkBpts:boolean;
Begin
  //result:=(NewDebug<>nil) and (NewDebug.Visible);
  result:=false;
End;

procedure TfNewBrain.StartEmulation;
var pc:integer;
begin


  if LastError<>'' then
    Begin
      try
        ShowMessage(LastError);
        LastError:='';
      finally
      end;
    End;
    if not IsSuspended then
    Begin
      if debugging then
      Begin
        if doOne then
        Begin
         doone:=false;
         Doemulation(1);
        End;
        //Sleep(1);
      End
      else
       if checkBpts then
       begin
         pc:=z80_get_reg(Z80_REG_PC);
         Z80_StepProc(PC);
         if not dostop then
           Doemulation(1);
       end
      else
       doEmulation;
    End;

    IF Debug2.Checked then
    Begin
      if DebugTimer>10 then
      Begin
        Nbscreen.paintDebug;
        DebugTimer:=0
      end
      Else
       Inc(DebugTimer);
    end;
end;

procedure TfNewBrain.PeripheralSetup1Click(Sender: TObject);
begin
  if frmPerif.showmodal=mrOk then
  Begin
    if withMicropage or withdatapack or unbtypes.withpibox then
    Begin
      WithExpansion1.Checked:=false;
      WithCPM1.Checked:=false;
      WithExpansion1.Enabled:=false;
      WithCPM1.Enabled:=false;
      if withDatapack then
        WriteP2('Type "OPEN#0,10" for Datapack MENU')
      Else
        WriteP2('');
      Peripheralsetup1.Checked:=true;
    end
    else
    Begin
      WithExpansion1.Enabled:=false;
      WithCPM1.Enabled:=false;
      Peripheralsetup1.Checked:=false;
    end;
  End;
end;

Function TfNewbrain.GetNewbrainDescr:String;
Var v:String;
Begin
  v:='AD Ver.';
  v:=v+Inttostr(Vers)+'.'+inttostr(sVers);
  if WithCPM1.Checked then
   v:=v+' - CPM';
  if WithExpansion1.Checked then
   v:=v+' - EIM';
  if WithMicroPage then
   v:=v+' - MP';
  if WithDataPack then
   v:=v+' - DP';
  if unbtypes.WithPIBOX then
   v:=v+' - PIBOX';
  Result:= v;
end;


procedure TfNewbrain.LoadOptions;
Var Inif:TIniFile;
    pth:String;
begin
  pth:=ExtractFilePath(Application.Exename);
  Inif:=TIniFile.create(pth+'Config.Ini');
  try
   VFDisplayUp1.Checked:=inif.ReadBool('FILE','VFDisp',VFDisplayUp1.Checked);
   WithExpansion1.Checked:=inif.ReadBool('FILE','withExp',WithExpansion1.Checked);
   WithCPM1.Checked:=inif.ReadBool('FILE','withCPM',WithCPM1.Checked);
   ShowInstructions1.Checked:=inif.ReadBool('OPTIONS','ShowInst',ShowInstructions1.Checked);
   ShowDriveContents1.Checked:=inif.ReadBool('DISK','ShowDriveCont',ShowDriveContents1.Checked);
  Finally
     inif.free;
  End;
end;


procedure TfNewbrain.SaveOptions;
Var Inif:TIniFile;
    pth:String;
begin
  pth:=ExtractFilePath(Application.Exename);
  Inif:=TIniFile.create(pth+'Config.Ini');
  try
   inif.WriteBool('FILE','VFDisp',VFDisplayUp1.Checked);
   inif.WriteBool('FILE','withExp',WithExpansion1.Checked);
   inif.WriteBool('FILE','withCPM',WithCPM1.Checked);
   inif.WriteBool('OPTIONS','ShowInst',ShowInstructions1.Checked);
   inif.WriteBool('DISK','ShowDriveCont',ShowDriveContents1.Checked);
  Finally
     inif.free;
  End;
end;

procedure TfNewBrain.RefreshRomVer;
Var s:String;
Begin
 s:=Inttostr(Vers)+'.'+inttostr(sVers);
 WriteP3(s);
end;

procedure TfNewBrain.SaveDisckNOW1Click(Sender: TObject);
begin
  NBDiscCtrl.WriteDisk('temp.dsk');
end;

procedure TfNewBrain.SelectRomVersion1Click(Sender: TObject);
begin
   fRomVersion:= TfRomVersion.create(nil);
   try
    If fRomVersion.showmodal=mrOk then
    Begin
     Vers:=fRomVersion.MjVersion;
     sVers:=fRomVersion.MnVersion;
     RefreshRomVer;
    end;
   finally
      fRomVersion.free;
   end;
end;

procedure TfNewBrain.ShowInstructions1Click(Sender: TObject);
begin
 if sender<>nil then 
   ShowInstructions1.checked:= Not ShowInstructions1.checked;
 if ShowInstructions1.checked then
   ShowInstructions
 Else
   HideInstructions;
end;

procedure TfNewBrain.ShowInstructions;
Begin
  if Assigned(fInstructions) then
  Begin
   fInstructions.Bringtofront;
   fInstructions.Show;
   Exit;
  end;
  fInstructions:= TfInstructions.Create(Self);
  fInstructions.Show;
end;


procedure TfNewBrain.HideInstructions;
Begin
    fInstructions.free;
    fInstructions:=nil;
end;

procedure  TfNewBrain.DoOnidle(sender:TObject;var Done:Boolean);
Begin
   StartEmulation;
End;


Initialization
registerclass(tbutton);
AppPath:=ExtractFilePath(Application.ExeName);
stopwatch:=TStopWatch.Create;
stopwatch2:=TStopWatch.Create;
MyZ80:=CreateCPPDescClass;

Finalization


end.
