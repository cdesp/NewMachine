unit frmVGA;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DXDraws, DXClass, Vcl.ExtCtrls;

type
  TfVGA = class(TDXForm)
    dxvga: TDXDraw;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure DoMyPaint;

    { Private declarations }
  public
    { Public declarations }
    procedure DoResize1;
  end;

var
  fVGA: TfVGA;
  isGraph:boolean;
  isHires:boolean;

implementation

{$R *.dfm}

uses New,unbmemory,math,unbscreen,jcllogic;

procedure TfVGA.DoResize1;
begin
 left:=fNewBrain.left-width-3;
 top:=fNewBrain.top;
end;

procedure TfVGA.DoMyPaint;
var
  x,y: Integer;
  addr,staddr:Integer;
  bt,btl,bth:byte;
  bt8:byte;
  col:tcolor;


  function getBit(v,b:Byte):Byte;
  begin
   b:=trunc(system.math.Power(2,b));
   if v and b=b then result:=1 else result:=0;
  end;

  function get4bitcolor(bt:byte):TColor;
  var r,g,b,i:Byte;
  Begin
    i:=getBit(bt,3);
    if (i=0) then
    Begin
      b:=getBit(bt,0) * 127;
      g:=getBit(bt,1) * 127;
      r:=getBit(bt,2) * 127;
    end
    else
    begin
      b:=getBit(bt,0) * 255;
      g:=getBit(bt,1) * 255;
      r:=getBit(bt,2) * 255;
    end;
    result:=RGB(r,g,b);
  End;

var xpix,ypix,clr:byte;
    forecol,backcol:tcolor;
    screenMode:Byte;

Begin
   if not dxvga.candraw then exit;


   screenMode:=nbmem.GetDirectMem(8,32760);
   ishiRes:= (screenMode and 2=2);
   isGraph:= not (screenMode and 1=1);
   //00=graph low res    F5
   //01=text low res     F6
   //10=graph hires      F7
   //11=text hires       F8
   forecol:=clGreen;
   backCol:=clBlack;

   staddr:=$0000;
   dxvga.BeginScene;
   dxvga.Surface.Fill(clgreen);
   dxvga.Surface.lock();
   //4bits per pixel
   //


   if ishires then
   Begin
   for y := 0 to 400-1 do
     for x:=0 to 640-1 do
     Begin
      if isgraph then //640x400 b/w
      Begin
       addr:=y*(640 div 8)+(x div 8);
       bt:=nbmem.GetDirectMem(8,addr); //auto advances to other pages if addr>8000
       xpix:=x mod 8;
       if getbit(bt,xpix)=1 then
         col:=forecol
       else
         col:=backcol;
       end
       else
       Begin
          //80x40 chars of 8x10 each b/w

          addr:=(y div 10)*80  +(x div 8);
          bt:=nbmem.GetDirectMem(8,addr);
          //bt:=nbmem.ROM[addr];
          xpix:=x  mod 8;
          ypix:=y  mod 10;
          bt:=ReverseBits(Chararr[bt+ypix*256]);//get line pattern for char
          //clr:=nbmem.GetDirectMem(8,addr+1024);
          if getbit(bt,xpix)=1 then
           col:=forecol
          else
           col:=backcol;
       End;
       dxvga.Surface.Pixel[x,y]:=col;
     End;

   end
   else    //lowres
   Begin
   for y := 0 to 400-1 do
     for x:=0 to 640-1 do
     Begin
      if isgraph then
      Begin
       addr:=(y div 2)*160+(x div 2) div 2;
       bt:=nbmem.GetDirectMem(8,addr); //auto advances to other pages if addr>8000
       //bt:=nbmem.ROM[addr];
       btl:=bt and $0f;
       bth:=(bt and $f0) shr 4;
       if x mod 4<2 then
         col:=get4bitcolor(btH)
       else
         col:=get4bitcolor(btL);
       end
       else
       Begin
          //40x20 chars of 8x10 each

          addr:=(y div 20)*40  +(x div 8 div 2);
          bt:=nbmem.GetDirectMem(8,addr);
          //bt:=nbmem.ROM[addr];
          xpix:=(x div 2) mod 8;
          ypix:=(y div 2) mod 10;
          bt:=ReverseBits(Chararr[bt+ypix*256]);//get line pattern for char
          clr:=nbmem.GetDirectMem(8,addr+1024);
          //clr:=nbmem.ROM[addr+1024];

          if getbit(bt,xpix)=1 then
           col:=get4bitcolor(clr and $0f)
          else
           col:=get4bitcolor((clr and $f0) shr 4);
       End;
       dxvga.Surface.Pixel[x,y]:=col;
     End;
    end;

   dxvga.Surface.Canvas.Release;
   {Flip the buffer}
   try
    dxvga.surface.unlock;
    dxvga.Flip;
   except

   end;
      //code here
   dxvga.EndScene;

End;

procedure TfVGA.FormHide(Sender: TObject);
begin
  Timer1.Enabled:=false;
end;

procedure TfVGA.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=true;
  dxvga.Finalize;
  fvga.Refresh;
end;

procedure TfVGA.Timer1Timer(Sender: TObject);
begin
 DoMyPaint;
end;

end.
