object fVGA: TfVGA
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'VGA 640x400'
  ClientHeight = 400
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dxvga: TDXDraw
    Left = 0
    Top = 0
    Width = 640
    Height = 400
    AutoInitialize = True
    AutoSize = True
    Color = clBlack
    Display.FixedBitCount = False
    Display.FixedRatio = True
    Display.FixedSize = True
    Options = [doAllowReboot, doWaitVBlank, doCenter, doFlip, do3D, doDirectX7Mode, doHardware, doSelectDriver]
    SurfaceHeight = 400
    Align = alClient
    TabOrder = 0
    Traces = <>
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 312
    Top = 208
  end
end
