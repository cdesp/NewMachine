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

unit uNBIO;

interface
uses upccomms,classes,graphics;

{$i 'dsp.inc'}

type

  TSvLdStat=(SVNONE,COMMD,FNAME,BTLEN,BYTES);

  TNBInOutSupport=Class
  private

    LastDevice: TPCPort;
    SvLdstat:TSvLdStat;
    SvLdCommd:Byte;
    SvLdFname:String;
    SvLdLen:Integer;
    SvLdFile:TFileStream;
    SvLdInLenHI:boolean;

    procedure DoPort32Out(Value: Byte);
    procedure getregisters;
    function DoPort32In(Value: Byte): byte;
    function DoPort7In(Value: Byte): Byte;
    procedure DoPort4Out(Value: Byte);

    procedure DoPort16Out(Value: Byte);
    function DoLastCommand:byte;
    function DoPort56In(Value: Byte): Byte;
    procedure DoPort56Out(Value: Byte);
    function DoPort37In(Value: Byte): Byte;
    function DoPort24In(Value: Byte): Byte;
    procedure DoPort17Out(Value: Byte);
    function DoPort17In(Value: Byte): byte;
    procedure DoPort64Out(Value: Byte);
    function DoPort72In(Value: Byte): Byte;
    procedure DoPort72Out(Value: Byte);
    procedure SerialOut(s: String);
    procedure DoPort73Out(Value: Byte);
    function DoPort75In(Value: Byte): Byte;
    procedure DoPort75Out(Value: Byte);




  public

    kbint: Boolean;
    KeyPressed: Byte;
    brkpressed: Boolean;

    Procedure NBout(Port:Byte;Value:Byte);
    Function NBIn(Port:Byte):byte;
    constructor Create;
    function GetClock: LongWord;

  End;


CONST
    BASICPATH='.\BASIC\';
    COMMD_SAVE=10;
    COMMD_LOAD=20;


Var
       ldsv:boolean=false;
       NBIO:TNBInOutSupport=nil;
       mykey:word=0;
       tmr1:cardinal;
       interrupt1:boolean=FALSE;
       interrupt2:boolean=FALSE;


implementation
uses uNBMemory,uNBScreen,new,sysutils,jclLogic,z80baseclass,uNBCop,windows,uNBCPM,unbtypes;

constructor TNBInOutSupport.Create;
begin
     inherited;

     KeyPressed:=$80;
     SvLdstat:=SVNONE;
     SvLdCommd:=0;
     SvLdFname:='';
     SvLdLen:=-1;
     SvLdFile:=nil;
     SvLdInLenHI:=false;
end;




PRocedure TNBInOutSupport.getregisters;

   procedure ODS2(a:String);
   Begin
     Outputdebugstring(Pchar(a));
   end;

Begin
  ODS2('PC='+Inttostr( z80_get_reg(Z80_REG_PC)));
  ODS2('AF='+Inttostr( z80_get_reg(Z80_REG_AF)));
  ODS2('HL='+Inttostr( z80_get_reg(Z80_REG_HL)));
  ODS2('BC='+Inttostr( z80_get_reg(Z80_REG_BC)));
  ODS2('DE='+Inttostr( z80_get_reg(Z80_REG_DE)));
  ODS2('IX='+Inttostr( z80_get_reg(Z80_REG_IX)));
  ODS2('IY='+Inttostr( z80_get_reg(Z80_REG_IY)));
  ODS2('BC2='+Inttostr( z80_get_reg(Z80_REG_BC2)));
End;




function TNBInOutSupport.GetClock: LongWord;
begin

end;

function TNBInOutSupport.NBIn(Port:Byte): byte;
Var value:integer;
begin
   Value:=z80_get_reg(Z80_REG_AF);
   Result:=00;
   case port of

      7: Result:=DoPort7In(Value);
     17: RESULT:=DoPort17In(Value); //LCD data
     24: Result:=DoPort24In(Value); //USB KEYB
     32: Result:=DoPort32In(Value); //RS232
     37: Result:=DoPort37In(Value);
     56: Result:=DoPort56In(Value);
     72: Result:=DoPort72In(Value);    //I2c
     75: Result:=DoPort75In(Value);    //I2c
   end;

end;

procedure TNBInOutSupport.NBout(Port:Byte;Value:Byte);
begin
    case port of
      4: DoPort4Out(Value);
     16: DoPort16Out(Value);//LCD command
     17: DoPort17Out(Value);//LCD data
     32: DoPort32Out(Value);//RS232
     56: DoPort56Out(Value);//SAVE
     64: DoPort64Out(Value);//Interrupt device
     72: DoPort72Out(Value);//I2C device
     73: DoPort73Out(Value);//I2C device
     75: DoPort75Out(Value);//I2C device
   end;
end;

procedure TNBInOutSupport.SerialOut(s:String);
Begin
   fnewbrain.Memo1.Lines.Add(s);
End;

function TNBInOutSupport.DoPort72In(Value: Byte): Byte;
Begin
 result:=$28; //MASTER_DATA_W_ACK
End;

function TNBInOutSupport.DoPort75In(Value: Byte): Byte;
Begin
 result:=8; //SET BIT 3
End;


procedure TNBInOutSupport.DoPort72Out(Value:Byte);
Begin
  Serialout(inttostr(value));
End;

procedure TNBInOutSupport.DoPort73Out(Value:Byte);
Begin
  Serialout(inttostr(value));
End;

procedure TNBInOutSupport.DoPort75Out(Value:Byte);
Begin
  Serialout(inttostr(value));
End;


function TNBInOutSupport.DoPort24In(Value: Byte): Byte;
var k:integer;
Begin
  k:=0;
  if interrupt2 THEN
  BEGIN
    k:=2;//bit 0,1,2 is for the 8 interrupts
    K:=7-K; //1 0 1   ;5 FOR INT 2
  END
  else
  if interrupt1 THEN
  BEGIN
    k:=1;//bit 0,1,2 is for the 8 interrupts
    K:=7-K; //1 1 0  ;6 FOR INT 1
  END;

  Result:= 64+K;
End;

function TNBInOutSupport.DoPort37In(Value: Byte): Byte;
Begin
 Result:=32;  //UART READY
  if (mykey<>0) OR (Fnewbrain.svserial.checked and ldsv) then
   result:=result+1;
End;

function TNBInOutSupport.DoPort56In(Value: Byte): Byte;
var btread:Integer;
Begin
   case SvLdstat of
     BTLEN:Begin
             if SvLdFile=nil then
             Begin
              try
               SvLdFile:=TFileStream.Create(BASICPATH+SvLdFname,fmOpenRead);
              except
                //todo:return an error filename not found
                Result:=0;
              end;
             End;
             if svldinlenHI then
             begin
               if assigned(SvLdFile) then
                 result:=(SvLdFile.Size shr 8) and $FF
               else
                 result:=0;
               SvLdstat:=BYTES;
             end
             else
             Begin
               if assigned(SvLdFile) then
                result:=SvLdFile.Size and $FF
               else
                result:=0;
               SvLdInLenHI:=true;
             End;
           End;
     BYTES:Begin
             if SvLdFile=nil then
             begin
               //todo:send an error
               result:=04; //file not found
               exit;
             end;
             btread:=SvLdFile.read(result,1);
             if (btread=0) or (SvLdFile.Position=SvLdFile.Size) then
             begin
               freeandnil(SvLdFile);
               SvLdLen:=-1;
               SvLdInLenHI:=false;
               SvLdstat:=SVNONE;
               SvLdFname:='';
               ldsv:=false;

             end;
           End;
   end;

End;

procedure TNBInOutSupport.DoPort56Out(Value:Byte);
Begin
   case SvLdstat of
     SVNONE:if value=$DD then
             SvLdstat:=COMMD
            else
             SvLdstat:=SVNONE;//should never come here
     COMMD:Begin
             SvLdstat:=FNAME;
             SvLdCommd:=Value;
           End;
     FNAME:if value<>$0D then
            SvLdFname:=SvLdFname+chr(Value)
           else
            SvLdstat:=BTLEN;
     BTLEN:if SvLdLen=-1 then
               SvLdLen:=Value
           else
           Begin
               SvLdLen:= SvLdLen+Value shl 8;
               SvLdstat:=BYTES;
           End;
     BYTES:Begin
             if SvLdFile=nil then
             Begin
               SvLdFile:=TFileStream.Create(BASICPATH+SvLdFname,fmCreate or fmOpenWrite);
             End;
             SvLdFile.Write(value,1);
             if SvLdFile.Size=SvLdLen then
             begin
               freeandnil(SvLdFile);
               SvLdLen:=-1;
               SvLdstat:=SVNONE;
               SvLdFname:='';
               ldsv:=false;
             end;
           End;
   end;

End;



procedure TNBInOutSupport.DoPort32Out(Value:Byte);
Begin
 // ODS('Port 0 Out ='+inttostr(Value)+' '+chr(value));
  ldsv:=ldsv or (fNewBrain.svserial.Checked and (value=$DD));

 if fNewBrain.svserial.Checked and ldsv then
    DoPort56Out(Value)
 else
 Begin
  screenout(  chr(value));
  ldsv:=false;
 End;
End;

procedure TNBInOutSupport.DoPort64Out(Value:Byte);
Begin
 // ODS('Port 0 Out ='+inttostr(Value)+' '+chr(value));
  if value =0 then
  Begin
    interrupt1:=false;
  End;
  if value =1 then
  Begin
    interrupt2:=false;
  End;
  //fNewbrain.clearinterrupt(value);
End;



function TNBInOutSupport.DoPort32In(Value: Byte): Byte;
Begin
 //ODS('Port 0 IN ='+inttostr(mykey));
 ldsv:=ldsv or (fNewBrain.svserial.Checked and (value=$DD));

 if fNewBrain.svserial.Checked and ldsv then
    RESULT:=DoPort56In(Value)
 else
 Begin
  ldsv:=false;
  result:=mykey;
  mykey:=0;
 End;
End;

//flags
function TNBInOutSupport.DoPort7In(Value: Byte): Byte;
Begin
 if mykey<>0 then
 Begin
    ODS('Port 7 IN ='+inttostr(mykey));
 End;
 if mykey >0 then
   result:=1
 else result:=0;

 //esc disables?     bit 6
 result:=result+64;

End;


var isCommnd:boolean=false;
    lastData:integer;

procedure TNBInOutSupport.DoPort4Out(Value:Byte);
Begin
 // ODS('Port 4 Out ='+inttostr(Value)+' '+chr(value));
  iscommnd:= value=0;



End;

procedure TNBInOutSupport.DoPort16Out(Value:Byte);
Begin
 // ODS('Port 5 Out ='+inttostr(Value)+' '+chr(value));
 iscommnd:=TRUE;
  lastData:=Value;
  DoLastCommand;
End;

procedure TNBInOutSupport.DoPort17Out(Value:Byte);
Begin
 // ODS('Port 5 Out ='+inttostr(Value)+' '+chr(value));
 iscommnd:=false;
  lastData:=Value;
  DoLastCommand;
End;

function TNBInOutSupport.DoPort17In(Value:Byte):byte;
Begin
 iscommnd:=false;
 result:=DoLastCommand;
End;


//Video stuff emulate 7Intch LCD with ssd1963

Type TLCDCommands=(NONE,SETXY_X, SETXY_Y, SETXY,GETPIXEL,SLAREA,SLSTART);
Var LCDCommand:TLCDCommands;
    dataBytes:array[0..10] of byte;
    di:integer=0;
    setX1,setX2,SetY1,SetY2:word;
    BytesExpected:Integer;
    Kx,Ky:word;
    fixtop,fixbot,scrarea,scls:word;

Procedure swap(var n1:word;var n2:word);
var t:integer;
Begin
   t:=n2;
   n2:=n1;
   n1:=t;
End;

Function TORGB(r,g,b:TCOLOR):Tcolor;
Begin
  result:=(r shl 16) OR (g shl 8) OR b;

End;

function getColor(ch,cl:Byte):tcolor;
var r,g,b:byte;
Begin
  r:=ch and $F8;
  g:=ch shl 5 OR ((cl and $C0) shr 3); //3 BITS FROM HI AND 2 FROM LOW
  b:=(cl and $3f) SHL 2;
  result:= TORGB(r,g,b);
End;

function encColor(col:Tcolor):word;
var r,g,b:byte;
    resh,resl:byte;
begin
  r:=col shr 16;
  g:=(col shr 8) and $ff;
  b:=col and $ff;
  resh:=(r or (g shr 5));
  resl:=(g shl 3) or (b shr 2);
  result:=resh shl 8+resl;
end;

function TNBInOutSupport.DoLastCommand;

       procedure CheckCommandFinished;
       var addr:integer;
       Color:TColor;
       Begin
         case LCDCommand of
           SETXY_X:if di=4 then
                     Begin
                       setX1:=dataBytes[0] shl 8 OR dataBytes[1];
                       setX2:=dataBytes[2] shl 8 OR dataBytes[3];
                       if setX1>setX2 then swap(setX1,setX2);
                       Kx:=setX1;
                     End;
           SETXY_Y:if di=4 then
                     Begin
                       setY1:=dataBytes[0] shl 8 OR dataBytes[1];
                       setY2:=dataBytes[2] shl 8 OR dataBytes[3];
                       if setY1>setY2 then swap(setY1,setY2);
                       Ky:=setY1;


                       BytesExpected:=(abs(setX2-setX1)+1)*(abs(setY2-setY1)+1);
                     End;
           SETXY:Begin
                   if di=2 then //exit;  //2 bytes for each color
                   Begin
                    //translate color 556 rgb
                    Color:=getColor(dataBytes[0],dataBytes[1]);
                    di:=0;
                    addr:=Ky*VideoW+kx;
                    if (ky>479) or (kx>799) then exit;
                    if addr>=VideoTotal-2 THEN EXIT;
                    if addr<0 then exit;

                   TRY
                    VideoMem[addr]:=Color;
                   EXCEPT

                   END;
                    inc(Kx);  dec(BytesExpected);
                    if Kx>setX2 then   //WAS >=
                    Begin
                      Kx:=setX1;
                      inc(Ky);
                    End;
                    if Ky>setY2 then  //probably finished BytesExpectedshould be 0
                      LCDCommand:=NONE;
                   End;
                 End;
            GETPIXEL:Begin   //2 bytes for each color
                       addr:=Ky*VideoW+kx;
                       if addr>=VideoTotal-2 then exit;
                       if addr<0 then exit;


                       Color:=VideoMem[addr];
                       color:=encColor(color);
                       if di =1 then  //hi byte
                        result:=Color shr 8
                       else
                       if di =2 then //2nd byte of color low byte
                       Begin
                         result:=Color and $ff;
                         inc(Kx);  dec(BytesExpected);
                         di:=0;
                         if Kx>setX2 then   //WAS >=
                         Begin
                           Kx:=setX1;
                           inc(Ky);
                         End;
                         if Ky>setY2 then  //probably finished BytesExpectedshould be 0
                          LCDCommand:=NONE;
                       End;
                     End;
            SLAREA:Begin
                      if di=6 then
                      Begin
                       fixtop:= dataBytes[0] shl 8 OR dataBytes[1];
                       scrarea:=dataBytes[2] shl 8 OR dataBytes[3];
                       fixbot:=dataBytes[2] shl 8 OR dataBytes[3];
                      End;
            end;
            SLSTART:Begin
                      if di=2 then
                      Begin
                        scls:= dataBytes[0] shl 8 OR dataBytes[1];
                        unbscreen.scrollline:=scls;
                      End;
            End;
            NONE:Begin
                    di:=0;
                    //shouldnt come here
                 End;

         end;
       End;

       Procedure SetLCDCommand;
       Begin
         di:=0;
         case lastData of
           $2a:LCDCommand:= SETXY_X; //4 bytes  x1,x2
           $2b:LCDCommand:= SETXY_Y; //4 bytes  y1,y2
           $2c:LCDCommand:= SETXY;  // Accept data
           $2e:LCDCommand:= GETPIXEL;
           $33:LCDCommand:= SLAREA;
           $37:LCDCommand:= SLSTART;
         else
         Begin
            LCDCommand:= NONE;
         End;

         end;

       End;


Begin
   result:=0;
   if isCommnd then SetLCDCommand
   else
   Begin //DATA
      if di>length(dataBytes) then
      begin
       ODS('DI TOO BIG.ERROR!!!');
       di:=0;
      end;
      dataBytes[di]:=lastData;
      inc(di);
      CheckCommandFinished;
   End;



End;


end.
