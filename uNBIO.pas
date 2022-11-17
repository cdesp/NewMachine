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
    function DoPort48In(Value: Byte): Byte;
    procedure DoPort48Out(Value: Byte);
    function DoPort53In(Value: Byte): Byte;
    function DoPort54In(Value: Byte): Byte;
    procedure exec_cmd(V:Byte);
    function getfreefilestream: TFilestream;
    procedure DoPort0Out(Value: Byte);
    function DoPort120In(Value: Byte): Byte;
    procedure DoPort120Out(Value: Byte);
    procedure DoPort38Out(Value: Byte);
    procedure doSoundCommand;




  public
    sh,sl:byte;
    sb:byte;

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

OPENCARD 	  = 1;
OPENFILE 	  = 2;
CLOSEFILE 	= 3;
READBLOCK 	= 6;
WRITEBLOCK 	= 7;
POSITIONS 	= 8;
POSITIONG 	= 9;
LISTDIR 	  = 10;
CHANGEDIR 	= 11;
FILESIZE 	  = 12;
ENDOFFILE	  = 13;
INVALIDCMD 	= 99;

FCMDOK 		= 200;
FNOTDIR 	= 201;
FNOTFND 	= 202;
FNOMOR 		= 203;

var strgcmd:array[0..3] of byte;
    comd_k:integer=0;
    sendbuf:TmemoryStream=nil;
    recvbuf:TmemoryStream=nil;
    totrecv:integer;
    totsend:integer;
    state:integer;
    filename:ansistring;
    retval:byte;
    Maindir:String;
    opfiles:array[0..9] of TFileStream;
    curdir:string;

       ldsv:boolean=false;
       NBIO:TNBInOutSupport=nil;
       mykey:word=0;
       tmr1:cardinal;
       interrupt1:boolean=FALSE;
       interrupt2:boolean=FALSE;
       interrupt3:boolean=FALSE;


implementation
uses usound,uNBMemory,uNBScreen,new,sysutils,jclLogic,z80baseclass,windows,uNBCPM,unbtypes,vcl.forms;

constructor TNBInOutSupport.Create;
var i:integer;
begin
     inherited;

     KeyPressed:=$80;
     SvLdstat:=SVNONE;
     SvLdCommd:=0;
     SvLdFname:='';
     SvLdLen:=-1;
     SvLdFile:=nil;
     SvLdInLenHI:=false;
     maindir:=extractfilepath(application.exename)+'\BASIC\';
     //maindir:='d:\NEWMStorage\';
     curdir:=MAINDIR;
     for I := 0 to length(opfiles)-1 do
      opfiles[i]:=nil;
     sb:=0;
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
     $10+1: RESULT:=DoPort17In(Value); //LCD data
     $68: Result:=DoPort24In(Value); //interrupt service input
     $18: Result:=DoPort32In(Value); //RS232
     $18+5: Result:=DoPort37In(Value); //RS232
     $28: Result:=DoPort48In(Value); //RS232 for storage -->Arduino
     $28+5: Result:=DoPort53In(Value); //LSR RS232 for storage -->Arduino
     $28+6: Result:=DoPort54In(Value); //MSR RS232 for storage -->Arduino
     56: Result:=DoPort56In(Value);
     $70: Result:=DoPort72In(Value);    //I2c
     $70+3: Result:=DoPort75In(Value);    //I2c
     $20: Result:=DoPort120In(Value);    //PS/2 KB
   end;

end;

procedure TNBInOutSupport.NBout(Port:Byte;Value:Byte);
begin
    case port of
     $00: Doport0Out(Value); //MMU Paging
      4: DoPort4Out(Value);
     $10: DoPort16Out(Value);//LCD command
     $10+1: DoPort17Out(Value);//LCD data
     $18: DoPort32Out(Value);//RS232
     $28: DoPort48Out(Value);//RS232 for storage -->Arduino
     $38: DoPort38Out(value);//sound module
     //56: DoPort56Out(Value);//SAVE
     $68: DoPort64Out(Value);//Interrupt device
     $70: DoPort72Out(Value);//I2C device
     $70+1: DoPort73Out(Value);//I2C device
     $70+3: DoPort75Out(Value);//I2C device
     $20: DoPort120Out(Value);//PS/2 KB
   end;
end;

var lastNote:integer;


procedure TNBInOutSupport.doSoundCommand;
var ch:byte;
    dat:integer;
Begin
  ch:=sh and $60 shr 5; //bits 5 & 6
  if sh and $10 =$10 then  //sound volume
  Begin
    dat := sh and $0f;
    ods ('Volume '+inttostr(ch)+'-->'+inttostr(dat));
    if dat=15 then    NoteOff(lastNote, 127);

  End
  else
  BEgin
    dat :=(sh and $0f shr 2) *256 + (sh and $0f shl 6) or (sl and $3f);
    ods ('Note '+inttostr(ch)+'-->'+inttostr(dat));
    NoteOff(lastNote, 127);
    if dat>127 then   //todo make an array with correct notes
     dat := dat and $7f;
    lastNote:=dat;
    NoteOn(dat,127);

  End;

End;



procedure TNBInOutSupport.DoPort38Out(Value:Byte);
var ch:byte;
    dat:integer;
Begin
  ODS('SND:Byte-> '+inttohex(value));
  if sb=0 then
  Begin
   sh:=value;
   if  (sh and $10)=$10 then //check volume
   Begin
     sl:=0;
     doSoundCommand;
     sb:=1;       //one byte command
   End;
  End
  else
  begin
    sl:=value;
    doSoundCommand;
  end;
  inc(sb);
  if sb=2 then sb:=0;

End;


procedure TNBInOutSupport.DoPort0Out(Value:Byte);
var bc,b:integer;
Begin
 //MMU paging system
 bc:=z80_get_reg(Z80_REG_BC);
 b:=bc shr 8;
 b:=b shr 5; //a15-a13 --> a2-a0
 //b is the 8k bank  0-7
 //value is the page (0-7) is the default
 if nbmem.ChipExists(value) then
   nbmem.SetPageInSlot(b,value,False)
 else
  ODS('ERR:Page '+inttostr(value)+' does not exist');



End;


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

function TNBInOutSupport.DoPort120In(Value: Byte): Byte;
Begin
 result:=fnewbrain.getNewkey;
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

procedure TNBInOutSupport.DoPort120Out(Value:Byte);
Begin
 if Assigned(keylist) and (keylist.Count>0) then
   new.kbint:=1;
End;


function TNBInOutSupport.DoPort24In(Value: Byte): Byte;
var k:integer;
Begin
  k:=0;
  if interrupt3 then
  Begin
    k:=2;//bit 0,1,2 is for the 8 interrupts
    K:=7-K; //1 0 0   ;6 FOR INT 3
  End
  else
  if interrupt2 THEN
  BEGIN
    k:=1;//bit 0,1,2 is for the 8 interrupts
    K:=7-K; //1 0 1   ;6 FOR INT 2
  END
  else
  if interrupt1 THEN
  BEGIN
    k:=0;//bit 0,1,2 is for the 8 interrupts
    K:=7-K; //1 1 0  ;7 FOR INT 1
  END;

  Result:= 64+K;
End;

function TNBInOutSupport.DoPort37In(Value: Byte): Byte;
Begin
 Result:=32;  //UART READY
  if (mykey<>0) OR (Fnewbrain.svserial.checked and ldsv) then
   result:=result+1;
End;

function TNBInOutSupport.DoPort53In(Value: Byte): Byte;
Begin
 Result:=32;  //UART READY
 // if (mykey<>0) OR (Fnewbrain.svserial.checked and ldsv) then
   result:=result+1; //Always ready
End;

function TNBInOutSupport.DoPort54In(Value: Byte): Byte;
Begin
//cts IS bit 4
 Result:=16 ;//0 = cts NOT READY
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



function TNBInOutSupport.getfreefilestream:TFilestream;
var
  i: Integer;
Begin
  result:=nil;
  for i := 0 to 9 do
   if opfiles[i]=nil then
   Begin
    try
     if strgcmd[2]=0 then
      opfiles[i]:=TFilestream.Create(curdir+filename,fmOpenRead)
     else
     if strgcmd[2]=1 then
       opfiles[i]:=TFilestream.Create(curdir+filename,fmOpenWrite)
     else
     if strgcmd[2]=2 then
       opfiles[i]:=TFilestream.Create(curdir+filename,fmOpenReadWrite)
     else
     if strgcmd[2]=4 then
       opfiles[i]:=TFilestream.Create(curdir+filename,fmOpenReadWrite or fmCreate);
     result:=opfiles[i];
     retval:=i;
     break;
    except
      result:=nil;
      retval:=FNOTFND;
      break;
    end;
   End;
   if i=9 then
       retval:=FNOMOR;

End;

procedure DirtoStream(dr:string;st:TmemoryStream);
var SR      : TSearchRec;
    ch:ansichar;

    procedure writeNL;
    Begin
      ch:=#13;
      st.Write(ch,1);
    End;

    procedure writestring(s:AnsiString);
    Begin
      st.Write(s[1],length(s));
    End;

var k:integer;
Begin
   writeNL;writestring('DIRECTORY ['+extractfilepath(dr)+']');writeNL;
   k:=0;
   if FindFirst(dr + '*.*', FaDirectory OR faArchive, SR) = 0 then
   begin
      repeat
        if (sr.Attr and faDirectory) = sr.Attr then
          writestring('  <DIR>  ')
        else
          writestring('         ');
        writestring(SR.name);writeNL;
        inc(k);
      until FindNext(SR) <> 0;
      system.SysUtils.findclose(SR);
   end;
   writeNL;writestring('Total Files:'+inttostr(k));writeNL;
   st.SaveToFile('d:\test.txt');
   st.Position:=0;

End;


procedure TNBInOutSupport.exec_cmd(V:Byte);
var cmd:byte;

  function getfilename:boolean;
  var
    I: Integer;
    ch:ansichar;
    Begin
        result:=false;
         if not assigned(recvbuf) then
         Begin
           recvbuf:=TmemoryStream.Create;
           filename:='';
         End
         else
          if v<>0 then //expect a zero terminated string
          Begin
            recvbuf.Write(v,1);
           // s:=chr(V);
           // outputdebugstring(PWideChar(s));
          End
          else
          Begin
            //we got the filename
            recvbuf.Position:=0;
            for I := 0 to recvbuf.Size-1 do
            Begin
               recvbuf.Read(ch,1);
               filename:=filename+ch;
            End;
            recvbuf.Free;
            recvbuf:=nil;
            result:=true;
          End;

    End;


var fs:TFileStream;
var newpos:integer;
Begin
   cmd:=strgcmd[0];

   case cmd of
       OPENCARD:Begin
         curdir:=MAINDIR;
         retval:=FCMDOK;
       End;
       OPENFILE:Begin
           if getfilename then
               getfreefilestream;  //RETVAL IS THE POSITION
       End;
       CLOSEFILE:Begin
          fs:=opfiles[strgcmd[1]];
          opfiles[strgcmd[1]]:=nil;
          try
           if assigned(fs) then
            fs.free;
          except
          end;
       End;
       READBLOCK:Begin
          fs:=opfiles[strgcmd[1]];
          if not assigned(fs) then
            raise exception.Create('Filestream not opened');
          totsend:=strgcmd[2]*256+strgcmd[3];
          if (totsend=0) or
              (totsend>(fs.Size-fs.Position)) then
                 totsend:=fs.Size-fs.Position;
          State:=1;
       End;
       WRITEBLOCK:Begin
         fs:=opfiles[strgcmd[1]];
         if not assigned(fs) then
            raise exception.Create('Filestream not opened');
         if State=0 then
         Begin
          totrecv:=strgcmd[2]*256+strgcmd[3];
          State:=1;
         End
         else
         Begin
           //receive totrecv bytes and save them to fs
           fs.Write(v,1);
           dec(totrecv);
           if totrecv=0 then
             retval:=FCMDOK;
         End;
       End;
       LISTDIR:Begin
           sendbuf:=TmemoryStream.Create;
           DirtoStream(curdir,sendbuf);
           //sendbuf.LoadFromFile('d:\teststorage.txt');
       End;
       CHANGEDIR:Begin
           if getfilename then
           Begin
             if directoryexists(maindir+filename) then
             Begin
              try
               curdir:=maindir+filename+'\';
               retval:=FCMDOK;
              except
                retval:=FNOTDIR
              end;
             End;
           end;
       End;
       POSITIONS:Begin
         fs:=opfiles[strgcmd[1]];
         newpos:=strgcmd[2]*256+strgcmd[3];
         fs.Position:=newpos;
         retval:=FCMDOK;
       end;
       POSITIONG: Begin
          state:=1;
       end;
       FILESIZE:Begin
          state:=1;
       end;
       ENDOFFILE:Begin
         fs:=opfiles[strgcmd[1]];
         if fs.Position>=fs.Size then
          retval:=255     //-1
         else
          retval:= FCMDOK;
       end;
   end;
End;

function TNBInOutSupport.DoPort48In(Value: Byte): Byte;
var cmd:byte;
    fs:TFileStream;

    procedure SetCommandEnd;
    Begin
      result:=retval;
      strgcmd[0]:=0;
      strgcmd[1]:=0;
      strgcmd[2]:=0;
      strgcmd[3]:=0;
      comd_k:=0;
    End;

Begin
   cmd:=strgcmd[0];
   result:=0;
 //this is the serial input to storage
 case cmd of
       OPENCARD:Begin
           SetCommandEnd;
       End;
       OPENFILE:Begin
          SetCommandEnd;
       End;
       CLOSEFILE:Begin
          SetCommandEnd;
       End;
       LISTDIR:Begin
         if assigned(sendbuf) then
         Begin
          if sendbuf.Read(result,1)=0 then
          Begin
             sendbuf.Free;
             sendbuf:=nil;
             result:=255;//signals end of directory listing
             retval:=FCMDOK;
          End;
         End
         else
          SetCommandEnd;
       End;
       CHANGEDIR:Begin
          SetCommandEnd;
       End;
       READBLOCK:Begin
         if state=1 then
         Begin
           result:=totsend div 256;       //hi byte
           inc(state);
         End
         ELSE
         if state=2  then
         Begin
           result:=totsend mod 256;       //low byte
           inc(state);
         End
         ELSE
         if state=3 then //send the bytes
         Begin
           fs:=opfiles[strgcmd[1]];
           fs.Read(result,1);
           dec(totsend);
           if totsend=0 then
           Begin
             inc(state);
             retval:=FCMDOK;
           End;
         End
         ELSE
         if state=4 then //ret status
          SetCommandEnd;
       End;
       WRITEBLOCK:begin
          SetCommandEnd;
       end;
       POSITIONs: Begin
          SetCommandEnd;
       end;
       POSITIONG: Begin
          if State=1 then
          Begin
            inc(state);
            fs:=opfiles[strgcmd[1]];
            result:=fs.Position div 256;
          End
          else
          if State=2 then
          Begin
            inc(state);
            fs:=opfiles[strgcmd[1]];
            result:=fs.Position mod 256;
          End
          else
          if State=3 then
          Begin
            retval:=FCMDOK;
            SetCommandEnd
          End;
       end;
       FILESIZE:Begin
          if State=1 then
          Begin
            inc(state);
            fs:=opfiles[strgcmd[1]];
            result:=fs.Size div 256;
          End
          else
          if State=2 then
          Begin
            inc(state);
            fs:=opfiles[strgcmd[1]];
            result:=fs.Size mod 256;
          End
          else
          if State=3 then
          Begin
            retval:=FCMDOK;
            SetCommandEnd
          End;
       end;
       ENDOFFILE:Begin
          SetCommandEnd;
       end;

 end;

End;


procedure TNBInOutSupport.DoPort48Out(Value:Byte);

Begin
 //this is the output for storage device
 //1st are 4 byte the command
 if comd_k<4 then
 Begin
   retval:=255;
   totsend:=0;
   totrecv:=0;
   state:=0;
   strgcmd[comd_k]:=Value;
   inc(comd_k);
 End;
 if comd_k=4 then exec_cmd(value);


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


initialization

end.
