unit uGuiScreen;

interface

uses Classes, SysUtils, Dialogs, Variants, ExtCtrls,
  Graphics, Forms, Controls, ComCtrls, StdCtrls, Windows, FileCtrl,
  ShellApi, Math, TypInfo;

type
  TScreenEx = class(TScreen)

  published
    property ActiveControl;
    property ActiveCustomForm;
    property ActiveForm;
    property CustomFormCount;
    property Cursor;
    property DataModuleCount;
    property MonitorCount;
    property DesktopRect;
    property DesktopHeight;
    property DesktopLeft;
    property DesktopTop;
    property DesktopWidth;
    property WorkAreaRect;
    property WorkAreaHeight;
    property WorkAreaLeft;
    property WorkAreaTop;
    property WorkAreaWidth;
    property HintFont;
    property IconFont;
    property MenuFont;
    property Fonts;
    property FormCount;
    property Imes;
    property DefaultIme;
    property DefaultKbLayout;
    property Height;
    property PixelsPerInch;
    property Width;
  end;

implementation

initialization
  Classes.RegisterClass(TScreenEx);

end.
