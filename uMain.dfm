object __fMain: T__fMain
  Left = 397
  Top = 148
  Caption = 'Soul Engine'
  ClientHeight = 465
  ClientWidth = 576
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    576
    465)
  PixelsPerInch = 96
  TextHeight = 13
  object b_Run: TButton
    Left = 493
    Top = 433
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Run'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = b_RunClick
  end
  object Button1: TButton
    Left = 8
    Top = 433
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'About'
    TabOrder = 1
  end
  object b_Restart: TButton
    Left = 409
    Top = 433
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Restart'
    Enabled = False
    TabOrder = 2
    OnClick = b_RestartClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 561
    Height = 417
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 3
    WantTabs = True
    WordWrap = False
  end
  object MainMenu: TMainMenu
    Left = 528
    Top = 384
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object Save: TMenuItem
        Caption = 'Save'
        ShortCut = 16467
        OnClick = SaveClick
      end
      object Saveas1: TMenuItem
        Caption = 'Save as..'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
      end
    end
    object Script1: TMenuItem
      Caption = 'Script'
      object Run1: TMenuItem
        Caption = 'Run'
        ShortCut = 120
        OnClick = b_RunClick
      end
      object Restart: TMenuItem
        Caption = 'Restart'
        ShortCut = 116
        OnClick = b_RestartClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Examples1: TMenuItem
        Caption = 'Examples'
      end
    end
    object N3: TMenuItem
      Caption = '?'
      object About1: TMenuItem
        Caption = 'About'
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'PHP Scripts|*.php|All files (*.*)|*.*'
    Left = 528
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 528
    Top = 112
  end
  object PopupMenu1: TPopupMenu
    Left = 528
    Top = 192
    object lkjk1: TMenuItem
      Caption = 'lkjk'
    end
  end
  object ApplicationEvents: TApplicationEvents
    Left = 528
    Top = 152
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 528
    Top = 64
  end
  object Timer2: TTimer
    Interval = 3000
    OnTimer = Timer2Timer
    Left = 528
    Top = 240
  end
end
