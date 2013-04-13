object PageControlHost: TPageControlHost
  Left = 636
  Top = 402
  Width = 396
  Height = 264
  BorderStyle = bsSizeToolWin
  BorderWidth = 3
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 382
    Height = 231
    Align = alClient
    DockSite = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabHeight = 26
    TabOrder = 0
    TabWidth = 40
    OnChange = PageControlChange
    OnDockDrop = PageControlDockDrop
    OnDrawTab = PageControlDrawTab
    OnGetSiteInfo = PageControlGetSiteInfo
    OnUnDock = PageControlUnDock
  end
  object tmr: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmrTimer
    Left = 88
    Top = 32
  end
  object img: TImageList
    Left = 184
    Top = 128
  end
  object Timer1: TTimer
    Interval = 100
    Left = 152
    Top = 56
  end
end
