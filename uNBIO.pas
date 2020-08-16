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
  TNBInOutSupport=Class
  private

    LastDevice: TPCPort;


    procedure DoPort0Out(Value: Byte);
    procedure getregisters;
    function DoPort0In(Value: Byte): byte;
    function DoPort7In(Value: Byte): Byte;
    procedure DoPort4Out(Value: Byte);

    procedure DoPort5Out(Value: Byte);
    procedure DoLastCommand;




  public

    kbint: Boolean;
    KeyPressed: Byte;
    brkpressed: Boolean;

    Procedure NBout(Port:Byte;Value:Byte);
    Function NBIn(Port:Byte):byte;
    constructor Create;
    function GetClock: LongWord;

  End;


Var

       NBIO:TNBInOutSupport=nil;
       mykey:word=0;


implementation
uses uNBMemory,uNBScreen,new,sysutils,jclLogic,z80baseclass,uNBCop,windows,uNBCPM,unbtypes;

constructor TNBInOutSupport.Create;
begin
     inherited;

     KeyPressed:=$80;
    
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
   case port of
      0: Result:=DoPort0In(Value);
      7: Result:=DoPort7In(Value);
   end;

end;

procedure TNBInOutSupport.NBout(Port:Byte;Value:Byte);
begin
    case port of
      0: DoPort0Out(Value);
      4: DoPort4Out(Value);
      5: DoPort5Out(Value);
   end;
end;



procedure TNBInOutSupport.DoPort0Out(Value:Byte);
Begin
 // ODS('Port 0 Out ='+inttostr(Value)+' '+chr(value));
  screenout(  chr(value));

End;

function TNBInOutSupport.DoPort0In(Value: Byte): Byte;
Begin
 ODS('Port 0 IN ='+inttostr(mykey));

 result:=mykey;
 mykey:=0;
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

procedure TNBInOutSupport.DoPort5Out(Value:Byte);
Begin
 // ODS('Port 5 Out ='+inttostr(Value)+' '+chr(value));
  lastData:=Value;
  DoLastCommand;
End;

//Video stuff emulate 7Intch LCD with ssd1963

Type TLCDCommands=(NONE,SETXY_X, SETXY_Y, SETXY);
Var LCDCommand:TLCDCommands;
    dataBytes:array[0..10] of byte;
    di:integer=0;
    setX1,setX2,SetY1,SetY2:word;
    BytesExpected:Integer;
    Kx,Ky:word;

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
  g:=ch shl 5 and ((cl and $3f) shr 6);
  b:=(cl and $3f) SHL 2;
  result:= TORGB(r,g,b);
End;

procedure TNBInOutSupport.DoLastCommand;

       procedure CheckCommandFinished;
       var addr:integer;
       Color:TColor;
       Begin
         case LCDCommand of
           SETXY_X:if di=8 then
                     Begin
                       setX1:=dataBytes[1] shl 8 OR dataBytes[3];
                       setX2:=dataBytes[5] shl 8 OR dataBytes[7];
                       if setX1>setX2 then swap(setX1,setX2);
                       Kx:=setX1;
                     End;
           SETXY_Y:if di=8 then
                     Begin
                       setY1:=dataBytes[1] shl 8 OR dataBytes[3];
                       setY2:=dataBytes[5] shl 8 OR dataBytes[7];
                       if setY1>setY2 then swap(setY1,setY2);
                       Ky:=setY1;


                       BytesExpected:=(abs(setX2-setX1)+1)*(abs(setY2-setY1)+1)-1;
                     End;
           SETXY:Begin
                   if di=4 then //exit;  //2 bytes for each color
                   Begin
                    //translate color 556 rgb
                    Color:=getColor(dataBytes[1],dataBytes[3]);
                    di:=0;
                    addr:=Ky*VideoW+kx;
                    if (ky>479) or (kx>799) then exit;

                   TRY
                    VideoMem[addr]:=Color;
                   EXCEPT

                   END;
                    inc(Kx);  dec(BytesExpected);
                    if Kx>=setX2 then
                    Begin
                      Kx:=setX1;
                      inc(Ky);
                    End;
                    if Ky>setY2 then  //probably finished BytesExpectedshould be 0
                      LCDCommand:=NONE;
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
         case lastData of
           $2a:LCDCommand:= SETXY_X; //4 bytes  x1,x2
           $2b:LCDCommand:= SETXY_Y; //4 bytes  y1,y2
           $2c:LCDCommand:= SETXY;  // Accept data
         else
         Begin
            LCDCommand:= NONE;
         End;
         di:=0;
         end;

       End;


Begin
   if isCommnd then SetLCDCommand
   else
   Begin //DATA
      dataBytes[di]:=lastData;
      inc(di);
      CheckCommandFinished;
   End;



End;


end.