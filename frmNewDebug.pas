{
Grundy NewBrain Emulator Pro Made by Despsoft

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

unit frmNewDebug;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DXDraws, ExtCtrls, Buttons, Grids,uz80dsm;

type
  TNewDebug = class(TForm)
    debugscr: TDXDraw;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    Button3: TButton;
    bpnts: TComboBox;
    Button4: TButton;
    Offset: TEdit;
    Button5: TButton;
    CheckBox2: TCheckBox;
    Streams: TButton;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Search: TButton;
    edSrch: TEdit;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label1: TLabel;
    SpeedButton5: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    SpeedButton6: TSpeedButton;
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StreamsClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { Private declarations }
    Mstrings:PString16;
       fds:TfrmDisasm;
    CanWeDraw: Boolean;
    bps: TStringlist;
  public
    { Public declarations }
     offs:Integer;
    procedure ShowDisasm;
    procedure PaintListing;
    function CheckBreak(Const pc:Word):boolean;
  end;

var
  NewDebug: TNewDebug;
  SlowRun:Boolean;
  tmpbpt:integer=-1;


implementation

uses unbscreen,unbmemory, New,z80baseclass,ustrings,unbio;

{$R *.DFM}

procedure TNewDebug.Button2Click(Sender: TObject);
begin
   if frmdisasm=nil then
    frmDisasm:= TfrmDisasm.create(nil);
   frmdisasm.show;
end;

procedure TNewDebug.Button5Click(Sender: TObject);
begin
 offs:=strtoint(offset.text);
end;

procedure TNewDebug.FormCreate(Sender: TObject);
begin
 offs:=2048;
 SlowRun:=false;
end;

procedure TNewDebug.StreamsClick(Sender: TObject);
Var s:String;
begin
 Memo1.clear;
 nbscreen.pgnbs.First;
 Repeat
  s:=Format('Stream No: %d',[nbscreen.pgnbs.StreamNo]);
  memo1.Lines.add(s);
  s:=Format('ObjectNo No : %d',[nbscreen.pgnbs.ObjectNo.w]);
  memo1.Lines.add(s);
  s:=Format('Page No 2: %d',[nbscreen.pgnbs.PageNo2nd]);
  memo1.Lines.add(s);
  s:=Format('Page Offset 2: %d',[nbscreen.pgnbs.PageOffset2nd.w]);
  memo1.Lines.add(s);
  s:=Format('Page No : %d',[nbscreen.pgnbs.PageNo]);
  memo1.Lines.add(s);
  s:=Format('Page Offset : %d',[nbscreen.pgnbs.PageOffset.w]);
  memo1.Lines.add(s);
  s:=Format('Device No : %d',[nbscreen.pgnbs.Deviceno]);
  memo1.Lines.add(s);
  memo1.Lines.add('-------------------');
 Until not nbscreen.pgnbs.NextOpen;
end;

procedure TNewDebug.SearchClick(Sender: TObject);
Var sl:TStringList;


    Procedure SearchBank(i:Integer);
    Var j,l,t:Integer;
        fnd:Boolean;
    Begin
     j:=0;
     l:=sl.count;
     repeat
      fnd:=true;
      For t:=0 to sl.count-1 do
       if strtoint(sl[t])<>nbmem.NBPages[i]^.Memory[j+t] then
        fnd:=false;
      if fnd then break;
      inc(j);
     Until j>($2000-l);
     if fnd then
      memo1.Lines.add('Found at Page:'+inttostr(i)+' Offset:'+Inttostr(j));
    End;

Var  i:Integer;

begin
  If EdSrch.text='' then exit;
  Memo1.lines.add('============= Search Start ===========');
  sl:=TStringlist.create;
  Try
   if pos(',',EdSrch.text)>0 then
    Sl.Commatext:=edSrch.text
   Else
   Begin
    For i:=1 to Length(edSrch.text) do
     sl.add(Inttostr(Ord(edSrch.text[i])));
   End;
   For i:=0 to 255 do
    if nbmem.NBPages[i]<>nil then
      SearchBank(i);
  Finally
     sl.free;
  End;
  Memo1.lines.add('============= Search End ===========');
end;

//Enable debugger
procedure TNewDebug.SpeedButton1Click(Sender: TObject);
begin
   fnewbrain.debugging:=true;
   ShowDisasm;
end;

//disable debugger
procedure TNewDebug.SpeedButton2Click(Sender: TObject);
begin
  fnewbrain.debugging:=false;
end;

procedure TNewDebug.SpeedButton3Click(Sender: TObject);
begin
  Fnewbrain.step;
  ShowDisasm;
end;

procedure TNewDebug.ShowDisasm;
Var
    slt,addr,len1:Integer;
    ra:Integer;
    dy:Integer;
Begin
 CanWeDraw:=false;
// Sleep(5);
 dy:=50;
 ra:=z80_get_reg(Z80_REG_PC);
// Addr:=ra-dy div 2;
 aDDR:=RA;
 if addr<0 then addr:=0;
 if addr+dy>65535 then
  addr:=65535-dy;
 Slt:=Addr div $2000;
 Addr:=Addr mod $2000;
 len1:=dy;
 If fds=nil then
 Begin
  fds:=TfrmDisasm.Create(Application);
  fds.visible:=false;
 End
 Else
  fds.ClearStruct;

 if nbmem.AltSet then
  fds.Disasm(@( NBMEm.AltSlots[Slt].Memory),Addr-6,addr+len1)
 Else
  fds.Disasm(@( NBMEm.MainSlots[Slt].Memory),Addr-6,addr+len1);
 mStrings:=fds.oStrings;

 CanWeDraw:=true;
end;

procedure TNewDebug.PaintListing;
Var i:integer;
    y:Integer;
    sy:Integer;
    pcs:String;
    Instr:String;
    realad,ra:Integer;
    oldc:TColor;
    slt:Integer;
    col4:Integer;
    lns:String;
    fnd:Boolean;
begin
  If not canwedraw then exit;
  fnd:=false;
 try

  if mstrings=nil then
   exit;
  ra:=z80_get_reg(Z80_REG_PC);
  Slt:=ra div $2000;
//  Addr:=ra mod $2000;
 // x:=100;//not used
  y:=10;
  sy:=12;
  col4:=560;
  oldc:=debugscr.Surface.Canvas.Font.Color;
  for i:=1 to 30 do
  Begin
   If not canwedraw then exit;
   pcs:=Copy(mStrings^[i], 1, 4);
   realad:=hextoint(pcs);
   realad:=slt*$2000+realAd;
   pcs:=InttoHex(realad,4);
   instr:=Copy(mStrings^[i], 25, 200);
   lns:=PCS+'  '+instr;
   if realad=ra then
   Begin
    debugscr.Surface.Canvas.Font.Color:=clLime;
    fnd:=true;
   End
   Else
    debugscr.Surface.Canvas.Font.Color:=clAqua;
    debugscr.Surface.Canvas.TextOut(Col4,y+sy*i,lns);
   if i=fds.ntotinstr then break;
  End;
  debugscr.Surface.Canvas.Font.Color:= oldc;
 Finally
  if not fnd then
   showdisasm;
 End;  
end;

procedure TNewDebug.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If fnewbrain.Debugging then
 Begin
  if key=vk_F7 then
     SpeedButton3Click(Nil);
  if key=vk_F8 then
     SpeedButton6Click(Nil);
  if key=vk_F9 then
     SpeedButton2Click(nil);
 End
 Else
 if key=vk_F11 then
     SpeedButton1Click(Nil);
end;

procedure TNewDebug.Button3Click(Sender: TObject);
var v:String;
begin
 if inputquery('Address (HEX)','Value:',v) then
 Begin
  bpnts.items.add(v);
  bps.assign(bpnts.items);
 End;
end;

procedure TNewDebug.Button4Click(Sender: TObject);
begin
   if bpnts.itemindex<>-1 then
   Begin
    bpnts.Items.delete(bpnts.itemindex);
    bps.assign(bpnts.items);
   End;
end;

function TNewDebug.CheckBreak(Const pc:Word):boolean;
var idx:integer;
begin
 result:=false;
 if not visible then exit;
 if bps=nil then exit;
 if bps.Count=0 then exit;
 idx:=bps.indexof(inttohex(pc,4));
 If (idx>-1) and (not fnewbrain.debugging) then
 Begin
  z80_stop_emulating;
  Stopped:=true;
  fnewbrain.debugging:=true;
  result:=true;
  ShowDisasm;
  if tmpbpt<>-1 then
  Begin
     if tmpbpt=pc then
     Begin
       tmpbpt:=-1;
       bps.Delete(idx);
       exit;
     End;
  End;

  ods('BreakPoint Reached at PC :'+inttostr(pc)+' '+inttohex(PC,4));
 End;
end;

procedure TNewDebug.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fNewbrain.Debug2.Checked:=False;
  fnewbrain.debugging:=false;
end;

procedure TNewDebug.FormShow(Sender: TObject);
begin
 if bps=nil then
  bps:=tstringlist.create;
 bps.assign(bpnts.items);
end;

//Step or free run
procedure TNewDebug.SpeedButton4Click(Sender: TObject);
begin
  SlowRun:=Not SlowRun;
  SpeedButton4.Down:=Slowrun;
end;

//Mark Output debug screen
Var mrk:Integer=0;
procedure TNewDebug.SpeedButton5Click(Sender: TObject);
begin
 ODS('================== MARK '+inttostr(mrk)+' ======================');
 inc(mrk);
end;

procedure TNewDebug.SpeedButton6Click(Sender: TObject);
var
    slt,addr,len1:Integer;
    ra:Integer;
    dy:Integer;
    cmd:integer;
    s:String;
begin
 ra:=z80_get_reg(Z80_REG_PC);
// Addr:=ra-dy div 2;
 aDDR:=RA;
 if addr<0 then addr:=0;
 if addr+dy>65535 then
  addr:=65535-dy;
 Slt:=Addr div $2000;
 Addr:=Addr mod $2000;
 cmd:=nbmem.MainSlots[slt].Memory[addr];
 if cmd in [$cd,$dc,$d4,$cc,$c4,$fc,$F4,$ec,$e4] then
 begin
   tmpbpt:=addr+3;
   s:=copy(inttohex(tmpbpt),5,maxint);
   bps.Add(s);
   fnewbrain.debugging:=false;
 end
 else
 Begin
  fnewbrain.thrEmulate.tag:=0;
  Fnewbrain.step;
 End;
 ShowDisasm;
end;

end.
