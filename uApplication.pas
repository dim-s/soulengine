unit uApplication;

interface

uses
  Forms;

type

  TApplicationEx = class(TApplication)
  private
  published
    property Active;
    property AllowTesting;
    property AutoDragDocking;
    property HelpSystem;
    property CurrentHelpFile;
    property DialogHandle;
    property ExeName;
    property Handle;
    property HelpFile;
    property Hint;
    property HintColor;
    property HintHidePause;
    property HintPause;
    property HintShortCuts;
    property HintShortPause;
    property Icon;
    property MainForm;
    property BiDiMode;
    property BiDiKeyboard;
    property NonBiDiKeyboard;
    property ShowHint;
    property ShowMainForm;
    property Terminated;
    property Title;
    property UpdateFormatSettings;
    property UpdateMetricSettings;
    property OnActionExecute;
    property OnActionUpdate;
    property OnActivate;
    property OnDeactivate;
    property OnException;
    property OnIdle;
    property OnHelp;
    property OnHint;
    property OnMessage;
    property OnMinimize;
    property OnModalBegin;
    property OnModalEnd;
    property OnRestore;
    property OnShowHint;
    property OnShortCut;
    property OnSettingChange;
  end;


implementation

end.
