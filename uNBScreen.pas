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
unit uNBScreen;

interface
Uses uNBTypes,DXDraws,uNBStream,graphics,classes;

Const ScreenYOffset=2;
      ScreenXOffset=2;

Type

  TNBScreen=Class

  private
       Char8: Boolean;
       FPSTick: Cardinal;
       GraphExists: Boolean;
       Grst: TNbStream;
       lengx, lengy: integer;
       ParamPg: Integer;
       ParamOffset: Word;
       ParamGrPage: Byte;
       ParamGrOffset: Word;
       ISCpmV: Boolean;
       Startofgraph: Integer;
       GrPage: Byte;
       EndOfText: Integer;
       HasText: Boolean;
       Printedlines: Integer;
       procedure dopaint(Sender: TObject);
    procedure putPixel(const x, y: integer; px: TColor);
  public
       horzmult:Integer;
       vertmult:Integer;
       EMUScrheight:integer; //variable
       EMUScrWidth:integer;
       FPS: Integer;
       Lastfps: Integer;
       nbs:TNBStreamManipulation;
       pgnbs:TNBPGStreamManipulation;
       Newscr: TDXDraw;
       ShowFps: Boolean;
       LedText: string;
       VideoAddrReg: Word;
       TVModeReg: Byte;
       VIdeoPage: Byte;
       WhiteColor: TColor;
       BlackColor: TColor;
       Reverse:Boolean;
       Dev33Page: Integer;
       VIDEOMSB: Integer;
       CpTm:Cardinal;
       CkTm:Cardinal;
       Constructor Create;
       procedure Clearscr;
       procedure paintGraph();
       function PaintVideo: Boolean;
       procedure PaintLetter(Const cx,cy:Integer;Ch:Byte;const dopaint:boolean=false);
       procedure PaintLeds(txt:String);
       procedure PaintDebug;
       procedure CaptureToDisk;

  End;

procedure LoadCharSet(fname:string);



CONST
    VideoW=800;
    VideoH=480;
    VideoTotal=VideoW*VideoH;


Var NBScreen:TNbScreen;
    CharArr:Array[0..2560] of byte; //charset array
    VideoMem:array[0..VideoTotal] of TColor;





implementation
Uses z80baseclass,Sysutils,forms,uNBMemory,frmNewdebug,new,
     jcllogic,windows,uNBCop,uNBIO,controls;

function ToRGB(r:byte;g:byte;b:byte):TColor;
Begin
  result:=r shl 16+g shl 8 +b;

End;

//loads the charset from the disk
procedure LoadCharSet(fname:string);
Var f:File Of byte;
    i:Integer;
    pth:String;
begin
 pth:=Extractfilepath(application.exename);
 if FileExists(pth+fname) then
 Begin
  system.Assign(f,pth+fname);
  reset(f);
  For i:=0 to 2560 do
  BEgin
    read(f,CharArr[i]);
  End;
  system.Close(f);
 End;
end;

constructor TNBScreen.Create;
begin
//  Frame:=nil;
  WhiteColor:=clWhite;
  BlackColor:=clBlack;
  nbs:=TNBStreamManipulation.Create;
  pgnbs:=TNBPGStreamManipulation.Create;
  horzmult:=1;
  vertmult:=1;
  EMUScrheight:=480; //variable
  EMUScrWidth:=800;

end;

procedure TNBScreen.ClearScr;
var i:Integer;
Begin
 for i:=0 to VideoTotal-1 do
  VideoMem[i]:=BlackColor;
End;


//Paint the debug information on Newdebug form
procedure TNBScreen.PaintDebug;
Var
    h,i:Integer;
    s:String;
    Col1,Col2,Col3,col4:Integer;

    Procedure PaintFlags;
    Var af:TPair;
        f:Byte;
        s:String;
        i:Integer;

    Begin
      af.w:=z80_get_reg(Z80_REG_AF);
      f:=af.l;
      s:='szxnxpnc';
      for i:=0 to 7 do
       if TestBit(f,Byte(i)) then
        s[8-i]:=Uppercase(s[8-i])[1]
       else
        s[8-i]:=Lowercase(s[8-i])[1];
      NewDebug.debugscr.Surface.Canvas.
        TextOut(Col3,1*h,'FL : '+s);
    End;

    Procedure PAintSP;
    var sp:TPair;
        i:Integer;
    Begin
      sp.w:=z80_get_reg(Z80_REG_SP);
      i:=2;
      with NewDebug.debugscr.Surface.Canvas do
      begin
       repeat
        s:=Format('%s : %s',[inttohex(sp.w,4),Inttohex(nbmem.rom[sp.w],4)]);
        sp.w:=sp.w-2;
        inc(i);
        TextOut(Col4,i*h,s);
        if i>15 then break;
       until false;
      End;
    End;

Begin
  Col1:=10;
  Col2:=140;
  Col3:=320;
  col4:=450;


  if not NewDebug.debugscr.CanDraw then exit;

  NewDebug.debugscr.Surface.Fill(0);
  NewDebug.debugscr.Surface.Lock();

  with NewDebug.debugscr.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Name:='Courier New';
    Font.Color := clWhite;
    Font.Size := 8;
    h:=10;
    if fNewBrain.Suspended then
     s:='Suspended'
    else
     s:='Running';
    Textout(Col1, 0, DateTimeToStr(Now)+' Engine is '+s);
    TextOut(Col1,1*h,'PC    : '+inttohex(z80_get_reg(Z80_REG_PC),4));
    TextOut(Col1,2*h,'AF    : '+inttohex(z80_get_reg(Z80_REG_AF),4));
    TextOut(Col1,3*h,'HL    : '+inttohex(z80_get_reg(Z80_REG_HL),4)+'('+Inttostr(nbmem.rom[z80_get_reg(Z80_REG_HL)])+')');
    TextOut(Col1,4*h,'DE    : '+inttohex(z80_get_reg(Z80_REG_DE),4));
    TextOut(Col1,5*h,'BC    : '+inttohex(z80_get_reg(Z80_REG_BC),4));
    TextOut(Col1,6*h,'IX    : '+inttohex(z80_get_reg(Z80_REG_IX),4));
    TextOut(Col1,7*h,'IY    : '+inttohex(z80_get_reg(Z80_REG_IY),4));
    TextOut(Col1,8*h,'IM    : '+inttohex(z80_get_reg(Z80_REG_IM),4));
    TextOut(Col1,9*h,'IR    : '+inttohex(z80_get_reg(Z80_REG_IR),4));
    TextOut(Col1,10*h,'IF1   : '+inttohex(z80_get_reg(Z80_REG_IFF1),4));
    TextOut(Col1,11*h,'IF2   : '+inttohex(z80_get_reg(Z80_REG_IFF2),4));
    TextOut(Col1,12*h,'SP    : '+inttohex(z80_get_reg(Z80_REG_SP),4));
    TextOut(Col1,13*h,'IRQV  : '+inttohex(z80_get_reg(Z80_REG_IRQVector),4));
    TextOut(Col1,14*h,'IRQL  : '+inttohex(z80_get_reg(Z80_REG_IRQLine),4));
    TextOut(Col1,15*h,'Halt  : '+inttohex(z80_get_reg(Z80_REG_Halted),4));

    PaintFlags;

    TextOut(Col1,18*h,'COPCTL: '+getbinaryfrombyte(nbmem.ROM[$3b]));
    TextOut(Col1,19*h,'COPST : '+getbinaryfrombyte(nbmem.ROM[$3c]));
    TextOut(Col1,20*h,'ENREG1: '+getbinaryfrombyte(nbmem.ROM[$24]));
    TextOut(Col1,21*h,'IOPUC : '+inttohex(nbmem.ROM[$25],2));
    s:=inttohex(nbmem.ROM[$1f],2)+inttohex(nbmem.ROM[$1e],2);
    TextOut(Col1,22*h,'SAVE1 : '+s);
  //  TextOut(Col1,23*h,'EL    : '+inttohex(EL,4));
  //  TextOut(Col1,24*h,'LL    : '+inttohex(LL,4));
  //  TextOut(Col1,25*h,'LN    : '+inttohex(LN,4));
  //  TextOut(Col1,26*h,'DEP   : '+inttohex(DEP,4));
  //  TextOut(Col1,27*h,'FRM   : '+inttohex(FRM,4));
  //  TextOut(Col1,28*h,'FLAGS : '+getbinaryfrombyte(FLAGS));
  //  TextOut(Col1,29*h,'EXFLAG: '+getbinaryfrombyte(EXFLAGS));
  //  TextOut(Col1,30*h,'INPB  : '+inttohex(inpb,4));
  //  TextOut(Col1,31*h,'INPC  : '+inttohex(inpc,4));
    s:=inttohex(nbmem.ROM[$5b],2)+inttohex(nbmem.ROM[$5a],2);
    TextOut(Col1,32*h,'TVCUR : '+s);
    s:=inttohex(nbmem.ROM[$5d],2)+inttohex(nbmem.ROM[$5c],2);
    TextOut(Col1,33*h,'TVRAM : '+s);
    s:=inttohex(nbmem.ROM[$05],2)+inttohex(nbmem.ROM[$04],2);
    TextOut(Col1,34*h,'B3PRM : '+s);
    s:=inttohex(nbmem.ROM[$38],2)+inttohex(nbmem.ROM[$3A],2)+inttohex(nbmem.ROM[$39],2);
    TextOut(Col1,35*h,'RST56 : '+s);
    s:=inttohex(nbmem.ROM[$2d],2)+inttohex(nbmem.ROM[$2c],2);
    TextOut(Col1,36*h,'GSPR  : '+s);
    s:=inttohex(nbmem.ROM[$07],2)+inttohex(nbmem.ROM[$06],2);
    TextOut(Col1,37*h,'B4    : '+s);
    s:=inttohex(nbmem.ROM[$57],2)+inttohex(nbmem.ROM[$56],2);
    TextOut(Col1,38*h,'STRTAB: '+s);
    s:=inttohex(nbmem.ROM[$65],2)+inttohex(nbmem.ROM[$64],2);
    TextOut(Col1,39*h,'STRTOP: '+s);
    TextOut(Col1,40*h,'ENREG2: '+getbinaryfrombyte(nbmem.ROM[$B6]));

    if Breaked or stopped then
     TextOut(Col1,41*h,'Breakpoint reached');



  //  TextOut(Col2,30*h,'TVMode: '+inttostr(TVMode));

    s:=inttohex(nbmem.ROM[120],2)+inttohex(nbmem.ROM[119],2);
    TextOut(Col2,31*h,'CHRROM: '+s);

    s:=inttohex(nbmem.ROM[85],2)+inttohex(nbmem.ROM[84],2)
       +inttohex(nbmem.ROM[83],2)+inttohex(nbmem.ROM[82],2);
    TextOut(Col2,1*h,'CL/CK : '+s);
    s:=inttohex(nbmem.ROM[107],2)+inttohex(nbmem.ROM[106],2)
       +inttohex(nbmem.ROM[105],2);
    TextOut(Col2,2*h,'FICLK : '+s);
    s:=inttohex(nbmem.ROM[21],2)+inttohex(nbmem.ROM[20],2);
    TextOut(Col2,3*h,'SAVE2 : '+s);
    s:=inttohex(nbmem.ROM[23],2)+inttohex(nbmem.ROM[22],2);
    TextOut(Col2,4*h,'SAVE3 : '+s);
    s:=inttohex(nbmem.ROM[$3D],2);
    TextOut(Col2,6*h,'COPBF : '+s);
    s:=inttohex(nbmem.ROM[$51],2)+inttohex(nbmem.ROM[$50],2);
    TextOut(Col2,7*h,'CHSUM : '+s);

    TextOut(Col2,37*h,'TV0   : '+inttostr(nbmem.rom[13]));
    TextOut(Col2,38*h,'TV2   : '+getbinaryfrombyte(nbmem.rom[14]));
    TextOut(Col2,39*h,'TV1   : '+inttostr(nbmem.rom[15]));
  //  TextOut(Col3,39*h,'TV4   : '+inttostr(TV4));

    For i:=0 to 7 do
     if nbmem.mainslots[i]<>nil then
      TextOut(Col2,(10+i)*h,'M/S '+inttostr(i)+' : '+Inttostr(nbmem.mainslots[i].Page)+'.'+nbmem.mainslots[i].Name)
     Else
      TextOut(Col2,(10+i)*h,'M/S '+inttostr(i)+' : 000.N/A');

    If nbmem.AltSet then
     TextOut(Col2,19*h,'ALTN Set ')
    Else
     TextOut(Col2,19*h,'MAIN Set ');

    For i:=0 to 7 do
     if nbmem.Altslots[i]<>nil then
       TextOut(Col2,(21+i)*h,'A/S '+inttostr(i)+' : '+Inttostr(nbmem.altslots[i].Page)+'.'+nbmem.Altslots[i].Name)
     Else
       TextOut(Col2,(21+i)*h,'A/S '+inttostr(i)+' : 0.N/A');

  //  TextOut(Col3,4*h,'VTop  : '+inttostr(Videotop.w));
  //  TextOut(Col3,5*h,'VBase : '+inttostr(VideoBase.w));
  //  TextOut(Col3,6*h,'AVtop : '+inttostr(AVideotop.w));


  if pclist<>nil then
  Begin
    For i:=pclist.count-1 downto 0 do
    Begin
     TextOut(Col3,(19+(pclist.count-i))*h,'PC-'+inttoStr(i)+' : '+inttoHex(Integer(PClist[i]),4));
     if pclist.count-i>10 then break;
    End;

    For i:=splist.count-1 downto 0 do
    Begin
     TextOut(Col4,(19+(splist.count-i))*h,'sp-'+inttoStr(i)+' : '+inttoHex(Integer(splist[i]),4));
     if splist.count-i>10 then break;
    End;

    PaintSp;
 End;

    try
     newdebug.PaintListing;
    Except
    End;
    Release; {  Indispensability  }
  end;

  NewDebug.debugscr.Surface.unLock;
  NewDebug.DebugScr.Flip;

End;

//Paint the graphics screen if there is one
procedure TNBScreen.paintGraph();
Var i,j:Integer;
    x,y:Integer;
    lengx,lengy:integer;
    addr:Integer;
    nocx:integer;
    nocy:integer;
    ch:TColor;



   Procedure DrawPixel(const x1,y1:integer; clr:TColor);
   var
       nx,ny:Integer;
       i,j:Integer;
   Begin

    nx:=ScreenXOffset+x1*horzmult;
    ny:=ScreenYOffset+y1*vertmult;
    newscr.Surface.Pixel[x1,y1]:=clr;
   End;


begin


  If printedlines>=VideoH then exit;//max lines

  lengx:=1; //8 bit
  lengy:=1; //1 byte

 // if not HasText then
 //    addr:=startGraph.w;


  nocx:=VideoW;     //280 bytes
  nocy:=VideoH;

   addr:=0;
   nocy:=nocy+10-(nocy mod 10);  //multiple of 10 lines always
   if nocy>VideoH then nocy:=VideoH;
//   ODS(Format('Start Graph Video=%4x , Page=%d',[addr,grpage]));






 for i:=0 to nocy-1 do     //count lines
 Begin
  for j:=0 to nocx-1 do //count column bytes
  Begin

    ch:=Videomem[addr];
    inc(addr);

    Drawpixel(j,i, ch );

  End; //for j

  printedlines:=printedlines+1;
  If printedlines>=VideoH then break;//max lines
 End;//for i

// ODS(Format('End  Video=%4x , Page=%d',[addr,grp]));
end;

//paint the 16 char vfd
procedure TNBScreen.PaintLeds(txt:String);
begin
   ledtext:=copy(txt,1,16);
   Fnewbrain.SetLed(nil);
end;

procedure TNBScreen.putPixel(Const x,y:integer;px:TColor);
var addr:integer;
Begin
   addr:=y*800+x;
   VideoMem[addr]:=px;

End;

//Paint a letter(ch) on screen at position cx,cy
procedure TNBScreen.PaintLetter(Const cx,cy:Integer;Ch:Byte;const
    dopaint:boolean=false);
Var
    x,y:Integer;
    addr:Integer;
    charb:array[0..9] of byte;
    col:TColor;

    Procedure getchar;
    var i:Integer;
    Begin
     charb[8]:=0;
     charb[9]:=0;

     for i:=0 to 9 do
      charb[i]:=ReverseBits(Chararr[addr+i*256]);

     //two bottom lines
     if ((ch>31) and (ch<128)) or (ch>159)  then
     Begin
       if charb[0] and 128=128 then
       Begin
         charb[0]:=charb[0] and $7f; //clear bit 8
         charb[8]:=charb[0];
         charb[0]:=0;
       End;
       if charb[1] and 128=128 then
       Begin
         charb[1]:=charb[1] and $7f; //clear bit 8
         charb[9]:=charb[1];
         charb[1]:=0;
       End;
     End
     else
      charb[8]:=charb[7];

     if reverse then
     Begin
       for i:=0 to 9 do
        charb[i]:=Charb[i] xor $ff;
     End;
    End;

    Procedure getchar8;
    var i:Integer;
    Begin
     for i:=0 to lengy-1 do
      charb[i]:=ReverseBits(Chararr[addr+i*256]);
     if reverse then
     Begin
       for i:=0 to lengy-1 do
        charb[i]:=Charb[i] xor $ff;
     End;
      charb[8]:=0;
     charb[9]:=0;
    End;


begin
  addr:=ch;
  lengy:=10;lengx:=8;
  getchar; //get the char pattern to charb 10 byte array

  for y:=0 to lengy-1 do
   for x:=0 to lengx-1 do
   Begin
     if (TestBit(charb[y],x)) then
       putPixel(cx*lengx+x,cy*lengy+y,WhiteColor)
     else
       putPixel(cx*lengx+x,cy*lengy+y,BlackColor);
   End;

end;


//Paint the video screen text
function TNBScreen.PaintVideo: Boolean;
var x,y,nender:Integer;
    nValue:Byte;
    s:String;
    Visy:Integer;
    FormOffst:Integer;


    Procedure CheckScreen;

    Begin
     Fnewbrain.ClientWidth:=2*(fnewbrain.newscr.Left-fnewbrain.Panel6.Left)+ VideoW +200   ;//+ScreenXOffset*2;
     FormOffst:= fnewbrain.panel1.Height+fnewbrain.panel2.Height+fnewbrain.StatusBar1.Height;  //48;// = led+Statusbar+4 bytes =25+19+4
     EMUScrheight:=520; //should never change cause in 8x8 we show 30 lines not 25
     fnewbrain.clientheight:=2*(fnewbrain.newscr.top)+FormOffst+VideoH+265;//+ScreenYOffset*2;//4 bytes around the real screen
    End;





var
    brked:boolean;
    v1,v2:Byte;
    v3,v4:Byte;
    vp:Integer;
    v,ofs:Integer;

    IsDev33:Boolean;
    nStart:Integer;
begin
   Result:=false;
   Printedlines:=0;

 try
   if not newscr.candraw then exit;
   Inc(fps);

  lengx:=8; //8x10 chars

  horzmult:=1;
   CheckScreen;


  // lengy:=10; //8x10 chars
  //  LoadCharset('CharSet2.chr');

   //lengy:=8; //8x8
   // LoadCharset('CharSet4.chr');
  // Char8:=true;


  newscr.Surface.Fill(WhiteColor);

  newscr.Surface.lock();

   Startofgraph:=0;
   PrintedLines:=0;


    paintgraph();
    //count frames painted
    if (GetTickCount-FpsTick>=1000) then
    Begin
     Lastfps:=fps;
     fps:=0;
     fpstick:=gettickcount;
    End;

   if showfps then
   Begin
    Newscr.Surface.Canvas.TextOut(VideoW-100,5 ,'FPS    : '+inttostr(lastfps));
    Newscr.Surface.Canvas.TextOut(VideoW-100,25,'MULT.  : '+Floattostr(fnewbrain.Emuls)+'/'+Floattostr(fnewbrain.Mhz));
    Newscr.Surface.Canvas.TextOut(VideoW-100,45,'MHz    : '+Floattostr(fnewbrain.Emuls*4));
    Newscr.Surface.Canvas.TextOut(VideoW-100,65,'Delay  : '+inttostr(nbdel));
//    Newscr.Surface.Canvas.TextOut(newscr.width-100,85,'Frm Skp: '+inttostr(maxpn));
    Newscr.Surface.Canvas.TextOut(VideoW-100,85,'COP: '+inttostr(CPTM));
    Newscr.Surface.Canvas.TextOut(v-100,105,'CLK: '+inttostr(CkTm));
//    Newscr.Surface.Canvas.TextOut(newscr.width-100,105 ,'FPS    : '+inttostr(fNewBrain.thrEmulate.FrameRate));
    if doHardware in newscr.NowOptions then
     Newscr.Surface.Canvas.TextOut(VideoW-100,170,'HARDWARE')
    else
     Newscr.Surface.Canvas.TextOut(VideoW-100,170,'SOFTWARE')
   end;

   Newscr.Surface.Canvas.Release;
   {Flip the buffer}
   try
    newscr.surface.unlock;
    Newscr.Flip;
   except
   end; 
   result:=true;
  finally
  end;
end;





//Save screen to disk as bitmap RAW
//Needed on NB laptop to test the screen
procedure TNBScreen.CaptureToDisk;
var f:TFilestream;
    xmax,ymax,x,y,i:Integer;
    b:byte;
    nbb:byte;
    ft:tform;
Begin
   f:=tfilestream.Create(AppPath+'ScrRaw.bin',fmCreate  );
   xmax:=800 div 8;
   ymax:=480 ;

   for y := 0 to ymax - 1 do
     for x := 0 to xmax - 1 do
     Begin
       for i := 0 to 7 do
       Begin
        b:=newscr.Surface.canvas.Pixels[x*8+i,y*2];
        if b=0 then
         nbb:=clearbit(nbb,i)
        else
         nbb:=Setbit(nbb,i);
       end;
        f.Write(nbb,1);
     End;
  f.Free;

  ft:=tform.Create(Application);
  ft.Caption:='Picture Preview';
  ft.ClientWidth:=800;
  ft.ClientHeight:=480;
  ft.OnPaint:= dopaint;

  ft.show;
  Application.MessageBox('Screen saved at ScrRaw.bin','Message');

End;

//just paint the screen to show the user what will be saved on disk
procedure TNBScreen.dopaint(Sender:Tobject);
var
    xmax,ymax,x,y,i:Integer;
    b:byte;
    nbb:byte;

Begin
   xmax:=640 div 8;
   ymax:=256 ;

   for y := 0 to ymax - 1 do
     for x := 0 to xmax - 1 do
     Begin
       for i := 0 to 7 do
       Begin
        b:=newscr.Surface.canvas.Pixels[x*8+i,y*2];
        TForm(Sender).canvas.Pixels[x*8+i,y]:=b;
       End;
     End;
end;

end.
