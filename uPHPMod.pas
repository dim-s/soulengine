unit uPHPMod;

{$I 'sDef.inc'}

interface

uses
  SysUtils, Classes, TypInfo,
  PHPCustomLibrary,
  phpLibrary,
  PHPCommon,
  php4delphi,
  ZendTypes,
  ZendAPI,
  PHPTypes,
  PHPAPI,
  DelphiFunctions,
  PHPFunctions,
  coolTrayIcon, libSysTray,
  Graphics, Dialogs, Forms, Variants, uGuiScreen, ComCtrls,
  Controls, Windows, FileCtrl, Buttons, SizeControl, ExtCtrls, Menus,
  StdCtrls, ExeMod, ShellApi, RyMenus, CheckLst, TlHelp32, Utils,
  Messages, MImage, GifImage, Jpeg, Grids, CaptionedDockTree, Clipbrd,


  {$IFDEF MSWINDOWS}
  ActiveX, ShlObj, WinInet,
  {$ENDIF}

  regGui, uApplication, Registry, PNGImage


  {$IFDEF ADD_CHROMIUM}
  , ceflib, cefvcl
  {$ENDIF}

  {$IFDEF VS_EDITOR}
  , NxPropertyItems, NxPropertyItemClasses, NxScrollControl,
  NxInspector,
  SynCompletionProposal, SynEdit, SynEditHighlighter
  {$ENDIF}  ;

procedure addVar(aName, aValue: variant; PSV: TpsvPHP = nil);
//procedure createPHPProcess(S: AnsiString; BW: TBackgroundWorker);
function ToObj(V: variant): TObject; overload;
function ToObj(Parameters: TFunctionParams; I: integer): TObject; overload;
function ToComp(V: variant): TComponent;
function ToCntrl(V: variant): TControl;
function ToPChar(V: variant): PAnsiChar;
procedure SetAsMainForm(aForm: TForm);


type
  TphpMOD = class(TDataModule)
    psvPHP: TpsvPHP;
    PHPLibrary: TPHPLibrary;
    gui: TPHPLibrary;
    libForms: TPHPLibrary;
    libScreen: TPHPLibrary;
    libApplication: TPHPLibrary;
    libDialogs: TPHPLibrary;
    winApi: TPHPLibrary;
    _TStringsLib: TPHPLibrary;
    _TStreamLib: TPHPLibrary;
    _TPictureLib: TPHPLibrary;
    _TSizeCtrl: TPHPLibrary;
    _TImageList: TPHPLibrary;
    PHPEngine: TPHPEngine;
    _Registry: TPHPLibrary;
    OSApi: TPHPLibrary;
    _Menus: TPHPLibrary;
    _ExeMod: TPHPLibrary;
    _TLists: TPHPLibrary;
    _TSynEdit: TPHPLibrary;
    _Canvas: TPHPLibrary;
    _BackWorker: TPHPLibrary;
    _Skins: TPHPLibrary;
    _Docking: TPHPLibrary;
    __WinUtils: TPHPLibrary;
    _Chromium: TPHPLibrary;
    procedure PHPLibraryFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure DataModuleDestroy(Sender: TObject);
    procedure PHPLibraryFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure DataModuleCreate(Sender: TObject);
    procedure guiFunctions4Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions3Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions5Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libScreenFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libScreenFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions7Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libDialogsFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions8Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions9Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure winApiFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure winApiFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStringsLibFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStringsLibFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStringsLibFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure winApiFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TSizeCtrlFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TSizeCtrlFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TSizeCtrlFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TSizeCtrlFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPEngineScriptError(Sender: TObject; AText: string;
      AType: integer; AFileName: string; ALineNo: integer);
    procedure libScreenFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TImageListFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TImageListFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TImageListFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TImageListFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TPictureLibFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions14Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions15Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions16Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions17Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TStreamLibFunctions18Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure TImageListFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions6Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _RegistryFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _RegistryFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions0Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions1Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions2Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions3Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions5Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions6Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure winApiFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions14Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions15Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions16Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libScreenFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libScreenFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions17Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions7Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions8Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions18Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions19Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions20Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions21Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions22Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions23Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions24Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStreamLibFunctions19Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions9Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TListsFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TListsFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions28Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions29Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions30Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TListsFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TImageListFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions31Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TListsFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TListsFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TImageListFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TImageListFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TImageListFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TImageListFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TImageListFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TListsFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TListsFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions14Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions15Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions33Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions35Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions16Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions17Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions36Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions37Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions38Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions39Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions14Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions15Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions16Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions40Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions41Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions18Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions19Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions20Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions21Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libDialogsFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions17Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions42Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions43Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions44Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions22Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStreamLibFunctions20Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions18Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions45Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions46Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions23Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions24Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions14Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions15Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions16Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions17Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions18Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions19Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _CanvasFunctions20Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions47Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions48Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions50Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions51Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions52Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions53Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions11Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions12Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions54Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions55Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions56Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions57Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions14Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions15Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure winApiFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure winApiFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions16Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions17Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions18Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions19Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions20Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions21Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions22Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions23Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions14Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions15Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions16Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _MenusFunctions17Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions19Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStreamLibFunctions21Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStreamLibFunctions22Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStreamLibFunctions23Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStreamLibFunctions24Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions58Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libDialogsFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions14Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions15Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions16Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions17Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions18Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions19Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions20Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions21Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions59Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSizeCtrlFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions60Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions61Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringsLibFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringsLibFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringsLibFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libApplicationFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions26Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions22Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions27Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure libFormsFunctions9Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions11Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions12Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions20Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions28Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _DockingFunctions13Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions64Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions65Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions29Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions30Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions31Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions32Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure OSApiFunctions33Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions16Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure guiFunctions17Execute(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions24Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TSynEditFunctions25Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions66Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions67Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TListsFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions7Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TStringGridFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions23Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ExeModFunctions10Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions21Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions22Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions23Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions24Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions25Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ChromiumFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ChromiumFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions26Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TPictureLibFunctions27Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _BackWorkerFunctions24Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibraryFunctions68Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure __WinUtilsFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure __WinUtilsFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _TTreeFunctions8Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
    varsStr: string;
    modules: TStrings;
    variables: TPHPVariables;
    IdleEnable: boolean;
    threadEngineFile: string;
    psvXList: TList;
    isTermited: boolean;
    lastErr: string;
    bw1Code: string;

    threadCount: integer;

    procedure RunFile(FName: string);
    procedure RunModuleFile(FName: string);
    procedure RunCode(S: string);

    procedure setVar(aName: string; aVal: variant);
    function getVar(aName: ansistring): ansistring;
    procedure ThreadEval(const Name: ansistring; PHP: TpsvPHP = nil;
      TSRMLS_DC: Pointer = nil);
  end;

type
  HashItem = record
    Val: variant;
    Key: string;
  end;

type
  pFontStyles = ^TFontStyles;
  pComponentState = ^TComponentState;
  pComponentStyle = ^TComponentStyle;
  pInteger = ^integer;
  PHashItem = ^HashItem;

  TArrayString = array of string;
  TArrayVariant = array of variant;
  TPHPArray = array of HashItem;

var
  phpMOD: TphpMOD;
  tmpAR: TArrayVariant;
  tmpAR2: TArrayString;
  tmpST: TStream;

  progDir: string;
  moduleDir: string;
  engineDir: string;
  iniDir: string;

  MyHotKey: integer = 0;

  // ApplicationEx: TApplicationEx;
  psvX: TpsvPHP;

const
  aNil = -1;

implementation

uses uMain, uMainForm, ImgList, Math, IniFiles, Types,
  uNonVisual, uPhpEvents;

{$R *.dfm}

function checkPHPSyntax(S: ansistring): ansistring;
var
  pengine: TPHPEngine;
  psvX: TpsvPHP;
begin

  pengine := TPHPEngine.Create(Application);
  pengine.DLLFolder := phpMOD.PHPEngine.DLLFolder;
  pengine.IniPath := phpMOD.PHPEngine.IniPath;

  phpMOD.lastErr := '';
  pengine.OnScriptError := phpMOD.PHPEngineScriptError;

  pengine.StartupEngine;

  psvX := TpsvPHP.Create(Application);
  psvX.RunCode('return; ' + s);

  psvX.Free;
  pengine.Free;

  Result := phpMOD.lastErr;
end;


procedure SetAsMainForm(aForm: TForm);
var
  P: Pointer;
begin
  P := @Application.Mainform;
  Pointer(P^) := aForm;
end;

function File2String(FName: string): ansistring;
var
  MyStream: TMemoryStream;
  MyString: ansistring;
begin
  MyStream := TMemoryStream.Create;
  try
    MyStream.LoadFromFile(FName);
    MyStream.Position := 0;
    SetLength(MyString, MyStream.Size);
    MyStream.ReadBuffer(Pointer(MyString)^, MyStream.Size);
  finally
    MyStream.Free;
  end;
  Result := MyString;
end;

function ToInt(V: variant): integer;
begin
  if v <> Null then
    Result := V
  else
    Result := 0;
end;

function ToStr(V: variant): string;
begin
  Result := V;
end;

function ToPChar(V: variant): PAnsiChar;
begin
  Result := PAnsiChar(ToStr(V));
end;

function ToStrA(V: variant): ansistring;
begin
  Result := V;
end;

function ToPCharA(V: variant): PAnsiChar;
begin
  Result := PAnsiChar(ToStrA(V));
end;


function ZendToVariant(const Value: pppzval): variant;
var
  S: string;
begin
  case Value^^^._type of
    1: Result := Value^^^.Value.lval;
    2: Result := Value^^^.Value.dval;
    6:
    begin
      S := Value^^^.Value.str.val;
      Result := S;
    end;
    4, 5: Result := Unassigned;
  end;
end;

{procedure HashToArray(HT: PHashTable; var AR: TArrayString); overload;
  Var
  Len,I: Integer;
  tmp : pppzval;
begin
 len := zend_hash_num_elements(HT);
 SetLength(AR,len);
 for i:=0 to len-1 do
  begin
    new(tmp);
    zend_hash_index_find(ht,i,tmp);
     AR[i] := ZendToVariant(tmp);
    freemem(tmp);
  end;
end; }

procedure HashToArray(HT: PHashTable; var AR: TArrayVariant); overload;
var
  Len, I: integer;
  tmp: pppzval;
begin
  len := zend_hash_num_elements(HT);
  SetLength(AR, len);
  for i := 0 to len - 1 do
  begin
    new(tmp);
    zend_hash_index_find(ht, i, tmp);
    AR[i] := ZendToVariant(tmp);
    freemem(tmp);
  end;
end;

procedure HashToArray(ZV: TZendVariable; var AR: TArrayVariant); overload;
begin
  if ZV.AsZendVariable._type = IS_ARRAY then
    HashToArray(ZV.AsZendVariable.Value.ht, AR)
  else
    SetLength(AR, 0);
end;

function HashToRect(ZV: TZendVariable): TRect;
begin
  HashToArray(ZV, tmpAR);
  Result.Left := tmpAR[0];
  Result.Top := tmpAR[1];
  Result.Right := tmpAR[2];
  Result.Bottom := tmpAR[3];
  // Result.TopLeft.X := tmpAR[4];
  // Result.TopLeft.Y := tmpAR[5];
  // Result.BottomRight.X := tmpAR[6];
  // Result.BottomRight.Y := tmpAR[7];
end;

function HashToPoint(ZN: TZendVariable): TPoint;
begin
  HashToArray(ZN, tmpAR);
  Result.X := tmpAR[0];
  Result.Y := tmpAR[1];
end;

procedure ArrayToHash(AR: array of variant; var HT: pzval); overload;
var
  I, Len: integer;
begin
  _array_init(ht, nil, 1);
  len := Length(AR);
  for i := 0 to len - 1 do
  begin
    case VarType(AR[i]) of
      varInteger, varSmallint, varLongWord, 17: add_index_long(ht, i, AR[i]);
      varDouble, varSingle: add_index_double(ht, i, AR[i]);
      varBoolean: add_index_bool(ht, i, AR[I]);
      varEmpty: add_index_null(ht, i);
      varString: add_index_string(ht, i, PAnsiChar(ToStr(AR[I])), 1);
      258: add_index_string(ht, i, PAnsiChar(ansistring(ToStr(AR[I]))), 1);
    end;
  end;
end;

procedure ArrayToHash(Keys, AR: array of variant; var HT: pzval); overload;
var
  I, Len: integer;
  v: variant;
  key: PAnsiChar;
  s: PAnsiChar;
begin
  _array_init(ht, nil, 1);
  len := Length(AR);
  for i := 0 to len - 1 do
  begin
    v := AR[I];
    key := PAnsiChar(ToStrA(keys[i]));
    s := PAnsiChar(ToStrA(v));
    case VarType(AR[i]) of
      varInteger, varSmallint, varLongWord, 17: add_assoc_long_ex(
          ht, ToPChar(Keys[i]), strlen(ToPChar(Keys[i])) + 1, AR[i]);
      varDouble, varSingle: add_assoc_double_ex(ht, ToPChar(Keys[i]),
          strlen(ToPChar(Keys[i])) + 1, AR[i]);
      varBoolean: add_assoc_bool_ex(ht, ToPChar(Keys[i]), strlen(ToPChar(Keys[i])) + 1, AR[I]);
      varEmpty: add_assoc_null_ex(ht, ToPChar(Keys[i]), strlen(ToPChar(Keys[i])) + 1);
      varString, 258: add_assoc_string_ex(ht, key, strlen(key) + 1, s, 1);
    end;
  end;
end;

procedure addVar(aName, aValue: variant; PSV: TpsvPHP = nil);
begin
  aValue := StringReplace(aValue, '\', '\\', [rfReplaceAll]);
  if PSV = nil then
    phpMOD.RunCode('$GLOBALS["' + aName + '"]= ''' + AddSlashes(aValue) + '''; ?>')
  else
    psv.RunCode('$GLOBALS["' + aName + '"]= ''' + AddSlashes(aValue) + '''; ?>');
end;

function ToObj(V: variant): TObject; overload;
begin
  if v = null then
    Result := nil
  else
    Result := TObject(integer(ToInt(V)));
end;

function ToObj(Parameters: TFunctionParams; I: integer): TObject; overload;
begin
  if Parameters[i].Value = null then
    Result := nil
  else
    Result := ToObj(Parameters[i].Value);
end;

function ToComp(V: variant): TComponent;
begin
  if v = null then
    Result := nil
  else
    Result := TComponent(integer(ToInt(V)));
end;

function ToCntrl(V: variant): TControl;
begin
  if v = null then
    Result := nil
  else
    Result := TControl(integer(ToInt(V)));
end;

function FontStylesToInteger(const Value: TFontStyles): integer;
begin
  Result := PInteger(@Value)^;
end;

function IntegerToFontStyles(const Value: integer): TFontStyles;
begin
  Result := PFontStyles(@Value)^;
end;

function CompStateToInt(const Value: TComponentState): integer;
begin
  Result := PInteger(@Value)^;
end;

function IntToCompState(const Value: integer): TComponentState;
begin
  Result := pComponentState(@Value)^;
end;

function CompStyleToInt(const Value: TComponentStyle): integer;
begin
  Result := PInteger(@Value)^;
end;

function IntToCompStyle(const Value: integer): TComponentStyle;
begin
  Result := pComponentStyle(@Value)^;
end;

(* -------------------- Non-standart results for functions -------------- *)
procedure SetResultAsHash(Keys, AR: array of variant; arr: pzval); overload;
begin
  ArrayToHash(Keys, AR, arr);
end;

procedure SetResultAsHash(AR: array of variant; arr: pzval); overload;
begin
  ArrayToHash(AR, arr);
end;

procedure SetResultAsPoint(Pt: TPoint; arr: pzval); overload;
begin
  ArrayToHash(['x', 'y'], [Pt.X, Pt.Y], arr);
end;

procedure SetResultAsPoint(X, Y: longint; arr: pzval); overload;
begin
  ArrayToHash(['x', 'y'], [X, Y], arr);
end;

procedure SetResultAsRect(R: TRect; arr: pzval); overload;
begin
  ArrayToHash(['left', 'top', 'right', 'bottom', 'topleft_x', 'topleft_y',
    'bottomright_x', 'bottomright_y'],
    [R.Left, R.Top, R.Right, R.Bottom, R.TopLeft.X, R.TopLeft.Y, R.BottomRight.X,
    R.BottomRight.Y], arr);
end;

{ TphpMOD }

procedure TphpMOD.RunCode(S: string);
begin
  if not psvPHP.UseDelimiters then
    S := '<? ' + S;

  psvPHP.RunCode(S);
  S := '';
end;

procedure TphpMOD.RunFile(FName: string);
begin
  if not FileExists(FName) then
    exit;
  psvPHP.FileName := FName;
  psvPHP.RunCode(File2String(FName));
end;

procedure TphpMOD.RunModuleFile(FName: string);
begin
  if modules.IndexOf(FName) = -1 then
  begin
    RunFile(FName);
    modules.Add(FName);
  end;
end;

procedure TphpMOD.setVar(aName: string; aVal: variant);
begin
  if psvPHP.Variables.IndexOf(Name) > -1 then
    psvPHP.VariableByName(Name).AsString := aVal
  else
    with psvPHP.Variables.Add do
    begin
      Name := aName;
      Value := aVal;
    end;
end;

///////////////////////////////////////////////////////////////////////////////
///                             TStreamLib                                  ///
///////////////////////////////////////////////////////////////////////////////
procedure initStream(Parameters: TFunctionParams);
begin
  tmpST := TStream(ToObj(Parameters, 0));
end;

////////// ----------------- TImageList -------------------------------- ///////
var
  im_li: TImageList;

function initImageList(Parameters: TFunctionParams): TImageList;
begin
  im_li := TImageList(ToObj(Parameters, 0));
  Result := im_li;
end;

procedure TphpMOD.TImageListFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initImageList(Parameters).
    Add(Graphics.TBitmap(ToObj(Parameters, 1)), Graphics.TBitmap(ToObj(Parameters, 2)));
end;

procedure TphpMOD.TImageListFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    initImageList(Parameters).
      AddMasked(Graphics.TBitmap(ToObj(Parameters, 1)), Parameters[2].Value);
  except
     { on E : Exception do
      ShowMessage(E.ClassName+' ошибка с сообщением : '+E.Message); }
    //ReturnValue := false;
  end;
end;

procedure TphpMOD.TImageListFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initImageList(Parameters).Delete(Parameters[1].Value);
end;

procedure TphpMOD.TImageListFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  tmp: Graphics.TBitmap;
begin
  tmp := Graphics.TBitmap(ToObj(Parameters, 2));
  ReturnValue := initImageList(Parameters).GetBitmap(Parameters[1].Value, tmp);
end;

procedure TphpMOD.TPictureLibFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  p: TPicture;
  //png: TPNGObject;
begin
  P := TPicture(ToObj(Parameters, 0));

  { if LowerCase(ExtractFileExt(Parameters[1].Value))='.png' then
   begin
        PNG := TPNGObject.Create;
        PNG.LoadFromFile(Parameters[1].Value);
        P.Bitmap.Assign(b);
        P.Assign(PNG);
        PNG.Free;
   end else  }
  P.LoadFromFile(Parameters[1].Value);

  // P.LoadFromFile(Parameters[1].Value);
end;

procedure TphpMOD.TPictureLibFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TPicture(ToObj(Parameters, 0)).SaveToFile(Parameters[1].Value);
end;

procedure TphpMOD.TPictureLibFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := IntToStr(integer(Graphics.TBitmap.Create));
end;

procedure TphpMOD.TPictureLibFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if FileExists(Parameters[1].Value) then
    Graphics.TBitmap(ToObj(Parameters, 0)).LoadFromFile(Parameters[1].Value);
end;

procedure TphpMOD.TPictureLibFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Graphics.TBitmap(ToObj(Parameters, 0)).SaveToFile(Parameters[1].Value);
end;

procedure TphpMOD.TPictureLibFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[1].Value = Null then
    Graphics.TBitmap(ToObj(Parameters, 0)).Assign(nil)
  else
  begin
    Graphics.TBitmap(ToObj(Parameters, 0)).Assign(TPersistent(ToObj(Parameters, 1)));
  end;
end;


procedure TphpMOD.TPictureLibFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TIcon.Create);
end;

procedure TphpMOD.TPictureLibFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  ic: TIcon;
  p: TPicture;
  b: Graphics.TBitmap;
begin
  if (LowerCase(ExtractFileExt(Parameters[1].Value)) = '.ico') then
    TIcon(ToObj(Parameters, 0)).LoadFromFile(Parameters[1].Value)
  else
  begin
    p := TPicture.Create;
    p.LoadFromFile(Parameters[1].Value);
    b := Graphics.TBitmap.Create;
    b.PixelFormat := pf32bit;
    b.TransparentMode := tmAuto;
    b.Width := p.Graphic.Width;
    b.Height := p.Graphic.Height;

    ic := TIcon.Create;
    ic.Width := b.Width;
    ic.Height := b.Height;
    ic.Transparent := True;
    ic.Assign(b);

    b.Free;
    p.Free;

  end;
end;

procedure TphpMOD.TPictureLibFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TIcon(ToObj(Parameters, 0)).SaveToFile(Parameters[1].Value);
end;

procedure TphpMOD.TPictureLibFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin

end;

{ ------------------------ TSize Ctrl -----------------------------------------}
var
  sctrl: TSizeCtrl;

function sizectrl_Self(Parametrs: TFunctionParams): TSizeCtrl;
begin
  sctrl := TSizeCtrl(ToObj(Parametrs, 0));
  Result := sctrl;
end;

procedure TphpMOD.TSizeCtrlFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    sizectrl_Self(Parameters);
    ReturnValue := sctrl.AddTarget(ToCntrl(Parameters[1].Value));
  except
       { on E : Exception do
        ShowMessage(E.ClassName+': '+E.Message); }
  end;
end;


procedure TphpMOD.TSizeCtrlFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  sizectrl_Self(Parameters);
  sctrl.DeleteTarget(ToCntrl(Parameters[1].Value));
end;

procedure TphpMOD.TSizeCtrlFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  sizectrl_Self(Parameters);

  if Parameters[1].Value = null then
    ReturnValue := sctrl.Enabled
  else
    sctrl.Enabled := Parameters[1].Value;
end;

procedure TphpMOD.TSizeCtrlFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  sizectrl_Self(Parameters).Update;
end;

{ ------------------------ /TSize Ctrl ----------------------------------------}

procedure TphpMOD.TStreamLibFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TMemoryStream.Create);
end;

procedure TphpMOD.TStreamLibFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initStream(Parameters);
  tmpST.Position := Parameters[1].Value;
end;

procedure TphpMOD.TStreamLibFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initStream(Parameters);
  ReturnValue := tmpST.Size;
end;

procedure TphpMOD.TStreamLibFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initStream(Parameters);
  tmpST.Size := Parameters[1].Value;
end;

procedure TphpMOD.TStreamLibFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TMemoryStream.Create);
end;

procedure TphpMOD.TStreamLibFunctions14Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    ReturnValue := integer(TFileStream.Create(Parameters[0].Value, Parameters[1].Value));
  except
     { on E: Exception do
        ShowMessage(e.Message);}
  end;
end;

procedure TphpMOD.TStreamLibFunctions15Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    ReturnValue := True;
    ObjectTextToResource(TStream(ToObj(Parameters, 0)), TStream(ToObj(Parameters, 1)));
  except
    ReturnValue := False;
      {on E: Exception do
        ShowMessage(e.Message);}
  end;
end;

procedure TphpMOD.TStreamLibFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TStream(ToObj(Parameters, 0)).ReadComponentRes(
    TComponent(ToObj(Parameters, 1))));
end;

procedure TphpMOD.TStreamLibFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TStream(ToObj(Parameters, 0)).WriteComponentRes(Parameters[1].Value,
    TComponent(ToObj(Parameters, 2)));
end;

procedure TphpMOD.TStreamLibFunctions18Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ObjectResourceToText(TStream(ToObj(Parameters, 0)), TStream(ToObj(Parameters, 1)));
end;

procedure TphpMOD.TStreamLibFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
  r: integer;
begin
  initStream(Parameters);
  r := tmpST.Read(s, Parameters[1].ZendVariable.AsInteger);
  SetResultAsHash(['b', 'r'], [s, r], ZendVar.AsZendVariable);
end;

procedure TphpMOD.TStreamLibFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
begin
  initStream(Parameters);
  s := Parameters[1].Value;

  ReturnValue := tmpST.Write(s, Parameters[2].ZendVariable.AsInteger);
end;

procedure TphpMOD.TStreamLibFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  tmpST := TStream(ToObj(Parameters, 0));
  ReturnValue := tmpST.Seek(Parameters[1].Value, Parameters[2].Value);
end;

procedure TphpMOD.TStreamLibFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
begin
  initStream(Parameters);

  tmpST.Read(s, Parameters[1].ZendVariable.AsInteger);
  ZendVar.AsString := s;
end;

procedure TphpMOD.TStreamLibFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
begin
  initStream(Parameters);
  s := Parameters[1].Value;
  tmpST.WriteBuffer(s, Parameters[2].ZendVariable.AsInteger);
end;

procedure TphpMOD.TStreamLibFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  tmp: TStream;
begin
  initStream(Parameters);
  tmp := TStream(ToObj(Parameters, 1));
  tmpST.CopyFrom(tmp, Parameters[2].Value);
end;

procedure TphpMOD.TStreamLibFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initStream(Parameters);
  ReturnValue := integer(tmpST.ReadComponent(TComponent(ToObj(Parameters, 1))));
end;

procedure TphpMOD.TStreamLibFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initStream(Parameters);
  tmpST.WriteComponent(TComponent(ToObj(Parameters, 1)));
end;

procedure TphpMOD.TStreamLibFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initStream(Parameters);
  ReturnValue := tmpST.Position;
end;

procedure TphpMOD.TStringsLibFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: ansistring;
begin
  s := Parameters[1].ZendVariable.AsString;
  TStringList(ToObj(Parameters, 0)).Text := s;
end;

procedure TphpMOD.TStringsLibFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TStringList(ToObj(Parameters, 0)).Text;
end;

procedure TphpMOD.TStringsLibFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  O: TObject;
begin
  if (Parameters[1].Value = Null) then
  begin
    if Parameters[0].Value = aNil then
      ReturnValue := Null
    else
    begin
      o := ToObj(Parameters, 0);
      if o is TCustomListControl then
        ReturnValue := TCustomListControl(O).ItemIndex
      else
        ReturnValue := Null;
    end;

  end
  else
  begin
    O := ToObj(Parameters, 0);
    if o is TCustomListControl then
      TCustomListControl(O).ItemIndex := Parameters[1].Value;
  end;
end;

procedure TphpMOD.winApiFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := FindWindow(PChar(ToStr(Parameters[0].Value)), PChar(
    ToStr(Parameters[1].Value)));
end;

procedure TphpMOD.winApiFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ShowWindow(Parameters[0].Value, Parameters[1].Value);
end;

procedure TphpMOD.winApiFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := GetKeyState(Parameters[0].Value);
end;

function TphpMOD.getVar(aName: ansistring): ansistring;
begin
  if psvPHP.Variables.IndexOf(aName) > -1 then
    Result := psvPHP.VariableByName(aName).Value
  else
    Result := '';
  //Screen.FocusedForm
end;


procedure TphpMOD.DataModuleCreate(Sender: TObject);
begin
  Randomize;
  threadCount := 0;
  isTermited := False;
  psvXList := TList.Create;
  //ApplicationEx := TApplicationEx.Create(nil);
  RegisterHotKey(__fMain.Handle, MyHotKey, 0, MyHotKey);
  IdleEnable := False;

  PHPEngine.OnScriptError := phpMOD.PHPEngineScriptError;
end;

procedure TphpMOD.DataModuleDestroy(Sender: TObject);
var
  i: integer;
begin
  isTermited := True;

  psvPHP.RunCode('if (class_exists("TApplication")) TApplication::doTerminate();');

  if Assigned(Application.MainForm) then
    Application.MainForm.Hide;

  __fMain.Left := -9999;
  __mainForm.Hide;
  UnRegisterHotKey(__fMain.Handle, MyHotKey);

  Application.MainFormOnTaskBar := False;
  Application.ShowMainForm := False;
  Application.Free;
  psvPHP.ShutdownRequest;
  //  PHPEngine.Free;
  try
    PHPEngine.ShutdownEngine;
  except

  end;

  for i := 0 to phpMOD.psvXList.Count - 1 do
  begin
    //TpsvPHP(TBackgroundWorker(phpMOD.psvXList[i]).AttachObject).ShutdownRequest;
    //   TBackgroundWorker(phpMOD.psvXList[i]).Free;
  end;


  //Application.Free;

  {$IFDEF ADD_CHROMIUM}
  cefvcl.CefFinalization;
  CeflibFinalization;
  {$ENDIF}
  TrayIconFinal;
  Exitprocess(0);
end;

function GetFormFromName(S: string): TForm;
var
  I, Len: integer;
begin
  Result := nil;
  Len := Screen.FormCount - 1;
  for i := 0 to Len do
    if SameText(Screen.Forms[I].Name, S) then
    begin
      Result := Screen.Forms[i];
      exit;
    end;
end;

function FindGlobalComponent(Onwer: TComponent; Name: string): TComponent;
begin
  Result := Onwer.FindComponent(Name);
end;

procedure TphpMOD.guiFunctions3Execute(Sender: TObject; Parameters: TFunctionParams;
  var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(FindGlobalComponent(GetFormFromName(
    Parameters[0].Value), Parameters[1].Value));
end;

procedure TphpMOD.guiFunctions4Execute(Sender: TObject; Parameters: TFunctionParams;
  var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
begin

  ReturnValue := integer(TComponent(ToObj(Parameters, 0)).FindComponent(
    Parameters[1].Value));
end;

procedure TphpMOD.guiFunctions5Execute(Sender: TObject; Parameters: TFunctionParams;
  var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
begin
  SetAsMainForm(TForm(ToObj(Parameters, 0)));
end;

procedure TphpMOD.guiFunctions7Execute(Sender: TObject; Parameters: TFunctionParams;
  var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
begin
  try
    ReturnValue := ToComp(Parameters[0].Value).ComponentCount;
  except
    ReturnValue := False;
      {on e: exception do
        ShowMessage(e.Message);}
  end;
end;

procedure TphpMOD.guiFunctions8Execute(Sender: TObject; Parameters: TFunctionParams;
  var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
begin
  try
    ReturnValue := integer(ToComp(Parameters[0].Value).Components[Parameters[1].Value]);
  except
    ReturnValue := False;
      {on e: exception do
        ShowMessage(e.Message);}
  end;
end;

procedure TphpMOD.guiFunctions9Execute(Sender: TObject; Parameters: TFunctionParams;
  var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
begin
  if ToObj(Parameters, 0) is TWinControl then
    TWinControl(ToObj(Parameters, 0)).SetFocus;
end;



// ---------------------------- lib FORMS ----------------------------------- //
procedure SetFontProp(Obj: TObject; Prop, Value: string);
var
  FNT: TFont;
begin
  try
    FNT := TFont.Create;
    FNT.Assign(TFont(integer(GetPropValue(Obj, 'Font'))));
    if UpperCase(Prop) = 'COLOR' then
      FNT.Color := StrToInt(Value)
    else
      SetPropValue(FNT, Prop, Value);
    TFont(integer(GetPropValue(Obj, 'Font'))).Assign(FNT);
    FNT.Free;
  except
  {
      on E: Exception do
        ShowMessage(E.Message);  }
  end;
end;

procedure TphpMOD.libApplicationFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Application.Terminate;
end;

procedure TphpMOD.libApplicationFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Application.Title;
end;

procedure TphpMOD.libApplicationFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  prop: string;
  v: variant;
begin
  prop := LowerCase(Parameters[0].ZendVariable.AsString);
  v := Parameters[1].Value;

  with Application do
  begin

    if v = Null then
    begin
      if prop = 'showmainform' then
        ReturnValue := ShowMainForm;
      if prop = 'active' then
        ReturnValue := Active;
      if prop = 'title' then
        ReturnValue := Title;
      if prop = 'hint.pause' then
        ReturnValue := HintPause;
      if prop = 'hint.hidepause' then
        ReturnValue := HintHidePause;
      if prop = 'hint.shortpause' then
        ReturnValue := Application.HintShortPause;
      if prop = 'handle' then
        ZendVar.AsInteger := integer(Application.Handle);
      if prop = 'hint.color' then
        ReturnValue := Application.HintColor;
      if prop = 'modallevel' then
        ReturnValue := Application.ModalLevel;
      if prop = 'mainformontaskbar' then
        ReturnValue := Application.MainFormOnTaskBar;

    end
    else
    begin

      if prop = 'title' then
        Title := v;
      if prop = 'hint.pause' then
        HintPause := v;
      if prop = 'hint.hidepause' then
        HintHidePause := v;
      if prop = 'hint.shortpause' then
        HintShortPause := v;
      if prop = 'hint.color' then
        HintColor := v;
      if prop = 'mainformontaskbar' then
        MainFormOnTaskBar := v;
      if prop = 'showmainform' then
        ShowMainForm := v;
    end;

  end;

end;

procedure TphpMOD.libApplicationFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Application.Minimize;
end;

procedure TphpMOD.libApplicationFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Application.ProcessMessages;
end;

procedure TphpMOD.libApplicationFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Application.Restore;
end;

procedure TphpMOD.libApplicationFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Application.MessageBox(PChar(ToStr(Parameters[0].Value)),
    PChar(ToStr(Parameters[1].Value)),
    Parameters[2].Value);
end;

procedure TphpMOD.libApplicationFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  cm: TComponent;
begin
  cm := Application.FindComponent(Parameters[0].Value);
  {if not Assigned(cm) then
    cm := ApplicationEx.FindComponent(Parameters[0].Value); }
  ReturnValue := integer(cm);
end;

procedure TphpMOD.libApplicationFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  MessageBeep(Parameters[0].Value);
end;

procedure TphpMOD.libApplicationFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  BTNS: TMsgDlgButtons;
  tmp: cardinal;
begin
  tmp := Parameters[2].Value;
  case tmp of
    MB_OK: BTNS := [mbOK];
    MB_OKCANCEL: BTNS := [mbOK, mbCancel];
    MB_ABORTRETRYIGNORE: BTNS := [mbAbort, mbRetry, mbIgnore];
    MB_YESNOCANCEL: BTNS := [mbYes, mbNo, mbCancel];
    MB_YESNO: BTNS := [mbYes, mbNo];
    MB_RETRYCANCEL: BTNS := [mbRetry, mbCancel];
  end;

  ReturnValue := MessageDlg(Parameters[0].Value, Parameters[1].Value, BTNS, 0);
end;

procedure TphpMOD.libDialogsFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TCommonDialog(ToObj(Parameters, 0)).Execute;
end;

procedure TphpMOD.libFormsFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    ReturnValue := TForm(ToObj(Parameters, 0)).ShowModal;
  except
    ReturnValue := False;
     { on E : Exception do
      ShowMessage(E.ClassName+' ошибка с сообщением : '+E.Message);  }
  end;
end;

procedure TphpMOD.libFormsFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Parameters[0].Value;
end;

procedure TphpMOD.libFormsFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  SetFontProp(ToObj(Parameters, 0), Parameters[1].Value, Parameters[2].Value);
end;

procedure TphpMOD.libFormsFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TForm(ToObj(Parameters, 0)).Close;
end;

procedure TphpMOD.libScreenFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Screen.FormCount;
end;

procedure TphpMOD.libScreenFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(Screen.Forms[Parameters[0].Value]);
end;

procedure TphpMOD.libScreenFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(Screen.ActiveForm);
end;

// --------------------------------------------------------------------------- //
var
  fatal_handler_php: ansistring;

procedure TphpMOD.PHPEngineScriptError(Sender: TObject; AText: string;
  AType: integer; AFileName: string; ALineNo: integer);
var
  s: string;
  PHP: TpsvPHP;
begin
  if fatal_handler_php <> '' then
  begin

    PHP := TpsvPHP(Sender);

    if Assigned(PHP.Thread) then
    begin
      PHP.RunCode(fatal_handler_php + '(' + IntToStr(integer(AType)) + ',' +
        '''' + AddSlashes(AText) + ''', ''' + AddSlashes(AFileName) +
        ''', ' + IntToStr(ALineNo) + ');');
    end
    else
      RunCode(fatal_handler_php + '(' + IntToStr(integer(AType)) + ',' +
        '''' + AddSlashes(AText) + ''', ''' + AddSlashes(AFileName) +
        ''', ' + IntToStr(ALineNo) + ');');
  end
  else
  begin
    s := AFileName + ': line ' + IntToStr(ALineNo) + #13;
    s := s + AText;

    self.lastErr := s;
    ShowMessage(S);
  end;
end;

procedure TphpMOD.PHPLibraryFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ShowMessage(Parameters[0].ZendVariable.AsString);
end;

procedure TphpMOD.PHPLibraryFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    TypInfo.SetPropValue(ToObj(Parameters, 0), Parameters[1].Value, Parameters[2].Value);
  except
  end;
end;

procedure TphpMOD.PHPLibraryFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  Obj, Owner: TComponent;
  P: TComponentClass;
begin
  try
    if Parameters[1].Value = aNil then
      Owner := Application
    else
      Owner := ToComp(Parameters[1].Value);

    p := TComponentClass(GetClass(Parameters[0].Value));

    if (p <> nil) then
    begin

      OBJ := TComponentClass(p).Create(Owner);
      ReturnValue := integer(OBJ);
    end
    else
    begin
      ReturnValue := 0;
    end;

  except
    ReturnValue := 0;
  end;
end;

procedure TphpMOD.PHPLibraryFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if (Parameters[1].Value <> Null) then
  begin
    ToCntrl(Parameters[0].Value).Parent :=
      ToCntrl(Parameters[1].Value) as TWinControl;
  end
  else
  begin
    ReturnValue := integer(ToCntrl(Parameters[0].Value).Parent);
  end;
end;

procedure TphpMOD.PHPLibraryFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  try
    o := ToObj(Parameters[0].Value);
    o.Free;
  except
   {on e: Exception do
    ShowMessage(e.Message);}
  end;
end;

procedure TphpMOD.PHPLibraryFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try

    TypInfo.SetPropValue(ToObj(Parameters, 0), Parameters[1].Value, Parameters[2].Value);
  except
  end;
end;

procedure TphpMOD.PHPLibraryFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    if ToObj(Parameters, 0) is TObject then
      if (GetPropInfo(ToObj(Parameters, 0), Parameters[1].Value) <> nil) then
        ReturnValue := TypInfo.GetPropValue(ToObj(Parameters, 0), Parameters[1].Value);
  except
    //on E: Exception do
    //Application.MainForm.Caption := E.Message;

  end;
end;

procedure TphpMOD.PHPLibraryFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  PI: PPropInfo;
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o = nil then
  begin
    ReturnValue := False;
    exit;
  end;

  PI := TypInfo.GetPropInfo(o, Parameters[1].Value);
  if PI = nil then
  begin
    ReturnValue := False;
    exit;
  end;

  ReturnValue := PI^.PropType^.Kind <> tkClass;
end;

procedure TphpMOD.PHPLibraryFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(ToComp(Parameters[0].Value).Owner);
end;

procedure TphpMOD.PHPLibraryFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(ToObj(TypInfo.GetPropValue(
    ToObj(Parameters, 0), Parameters[1].Value)));
end;

procedure TphpMOD.PHPLibraryFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o = nil then
  begin
    ReturnValue := Null;
    exit;
  end;

  if o is TForm then
    ReturnValue := 'TForm'
  else
    ReturnValue := o.ClassName;

  ReturnValue := Trim(ReturnValue);
end;

procedure TphpMOD.TImageListFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  ob: TObject;
  im: TImageList;
begin
  ob := ToObj(Parameters, 0);
  im := (ToObj(Parameters, 1) as TImageList);
  if (ob is TMainMenu) then
    TMainMenu(ob).Images := im
  else if (ob is TPopupMenu) then
    TPopupMenu(ob).Images := im
  else if (ob is TTabControl) then
    TTabControl(ob).Images := im
  else if (ob is TPageControl) then
    TPageControl(ob).Images := im
  else if (ob is TTreeView) then
    TTreeView(ob).Images := im
  else if (ob is TListView) then
  begin
    TListView(ob).SmallImages := im;
    TListView(ob).LargeImages := im;
    TListView(ob).StateImages := im;
  end
  else if (ob is THeaderControl) then
    THeaderControl(ob).Images := im
  else if (ob is TToolBar) then
    TToolBar(ob).Images := im;

end;

procedure TphpMOD.libFormsFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);

begin
  ReturnValue :=
    GetPropValue(TFont(integer(
    GetPropValue(ToObj(Parameters, 0), 'Font'))),
    Parameters[1].Value);
end;

procedure TphpMOD._TSizeCtrlFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TSizeCtrl(ToObj(Parameters, 0)).ClearTargets;
end;

procedure TphpMOD.PHPLibraryFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ToObj(Parameters, 0) is TClass(GetClass(Parameters[1].Value));
end;

procedure TphpMOD._TSizeCtrlFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  sizectrl_Self(Parameters);
  sctrl.RegisterControl(ToCntrl(Parameters[1].Value));
end;

procedure TphpMOD._TSizeCtrlFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  sizectrl_Self(Parameters);
  sctrl.UnRegisterControl(ToCntrl(Parameters[1].Value));
end;

procedure TphpMOD._TSizeCtrlFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  sizectrl_Self(Parameters);
  sctrl.UnRegisterAll;
end;

procedure TphpMOD.guiFunctions6Execute(Sender: TObject; Parameters: TFunctionParams;
  var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(Application);
end;

procedure TphpMOD._RegistryFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TRegistry.Create);
end;

procedure TphpMOD._RegistryFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  command: string;
  reg: TRegistry;
begin

  reg := TRegistry(ToObj(Parameters, 0));

  command := Parameters[1].Value;

  //ShowMessage(command);

  if (command = 'createkey') then
  begin
    ReturnValue := reg.CreateKey(Parameters[2].Value);
    exit;
  end;

  if (command = 'closekey') then
  begin
    reg.CloseKey;
    exit;
  end;

  if (command = 'deletekey') then
  begin
    ReturnValue := reg.DeleteKey(Parameters[2].Value);
    exit;
  end;

  if (command = 'deletevalue') then
  begin
    ReturnValue := reg.DeleteValue(Parameters[2].Value);
    exit;
  end;

  if (command = 'getdatasize') then
  begin
    ReturnValue := reg.GetDataSize(Parameters[2].Value);
    exit;
  end;

  if (command = 'hassubkeys') then
  begin
    ReturnValue := reg.HasSubKeys();
    exit;
  end;

  if (command = 'loadkey') then
  begin
    ReturnValue := reg.LoadKey(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'keyexists') then
  begin
    ReturnValue := reg.KeyExists(Parameters[2].Value);
    exit;
  end;

  if (command = 'openkey') then
  begin
    ReturnValue := reg.OpenKey(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'openkeyreadonly') then
  begin
    ReturnValue := reg.OpenKeyReadOnly(Parameters[2].Value);
    exit;
  end;

  if (command = 'readcurrency') then
  begin
    ReturnValue := reg.ReadCurrency(Parameters[2].Value);
    exit;
  end;

  if (command = 'readbool') then
  begin
    ReturnValue := reg.ReadBool(Parameters[2].Value);
    exit;
  end;

  if (command = 'readfloat') then
  begin
    ReturnValue := reg.ReadFloat(Parameters[2].Value);
    exit;
  end;

  if (command = 'readdate') then
  begin
    ReturnValue := reg.ReadDateTime(Parameters[2].Value);
    exit;
  end;

  if (command = 'readinteger') then
  begin
    ReturnValue := reg.ReadInteger(Parameters[2].Value);
    exit;
  end;

  if (command = 'readstring') then
  begin
    ReturnValue := reg.ReadString(Parameters[2].Value);
    exit;
  end;

  if (command = 'restorekey') then
  begin
    ReturnValue := reg.RestoreKey(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'savekey') then
  begin
    ReturnValue := reg.SaveKey(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'unloadkey') then
  begin
    ReturnValue := reg.UnLoadKey(Parameters[2].Value);
    exit;
  end;

  if (command = 'valueexists') then
  begin
    ReturnValue := reg.ValueExists(Parameters[2].Value);
    exit;
  end;

  if (command = 'currentkey') then
  begin
    ReturnValue := reg.CurrentKey;
    exit;
  end;

  if (command = 'currentpath') then
  begin
    ReturnValue := reg.CurrentPath;
    exit;
  end;

  if (command = 'lazywrite') then
  begin
    reg.LazyWrite := Parameters[2].Value;
    exit;
  end;

  if (command = 'rootkey') then
  begin
    reg.RootKey := Parameters[2].Value;
    exit;
  end;

  if (command = 'access') then
  begin
    reg.Access := Parameters[2].Value;
    exit;
  end;

  if (command = 'writecurrency') then
  begin
    reg.WriteCurrency(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'writebool') then
  begin
    reg.WriteBool(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'writefloat') then
  begin
    reg.WriteFloat(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'writedate') then
  begin
    reg.WriteDateTime(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'writestring') then
  begin
    reg.WriteString(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;

  if (command = 'writeinteger') then
  begin
    reg.WriteInteger(Parameters[2].Value, Parameters[3].Value);
    exit;
  end;
end;

function SetPrivilege(aPrivilegeName: string; aEnabled: boolean): boolean;
var
  TPPrev, TP: TTokenPrivileges;
  Token: cardinal;
  dwRetLen: DWord;
begin
  Result := False;
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, Token);
  TP.PrivilegeCount := 1;
  if LookupPrivilegeValue(nil, PChar(aPrivilegeName), TP.Privileges[0].LUID) then
  begin
    if aEnabled then
      TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else
      TP.Privileges[0].Attributes := 0;
    dwRetLen := 0;
    Result := AdjustTokenPrivileges(Token, False, TP, SizeOf(TPPrev), TPPrev, dwRetLen);
  end;
  CloseHandle(Token);
end;


procedure TphpMOD.OSApiFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  SetPrivilege(Parameters[0].Value, Parameters[1].Value);
end;

procedure TphpMOD.OSApiFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ExitWindowsEx(Parameters[0].Value, Parameters[1].Value);
end;

procedure WindowsSleep;
var
  hToken: THandle;
  tkp: TTokenPrivileges;
  ReturnLength: cardinal;
begin
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or
    TOKEN_QUERY, hToken) then
  begin
    LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
    tkp.PrivilegeCount := 1; // one privelege to set
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if AdjustTokenPrivileges(hToken, False, tkp, 0, nil, ReturnLength) then
      SetSystemPowerState(True, True);
  end;
end;

procedure TphpMOD.OSApiFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  WindowsSleep;
end;

function GetLocalPath(LOCALDIR: integer): string;
var
  shellMalloc: IMalloc;
  ppidl: PItemIdList;
begin
  ppidl := nil;
  try
    if SHGetMalloc(shellMalloc) = NOERROR then
    begin
      SHGetSpecialFolderLocation(0, LOCALDIR, ppidl);
      SetLength(Result, MAX_PATH);
      if not SHGetPathFromIDList(ppidl, PChar(Result)) then
        exit;
      //raise exception.create('SHGetPathFromIDList failed : invalid pidl');
      SetLength(Result, lStrLen(PChar(Result)));
    end;
  finally
    if ppidl <> nil then
      shellMalloc.Free(ppidl);
  end;
end;



function SetClipboardText(Wnd: HWND; Value: string): boolean;
var
  hData: HGlobal;
  pData: pointer;
  Len: integer;
begin
  Result := True;
  if OpenClipboard(Wnd) then
  begin
    try
      Len := Length(Value) + 1;
      hData := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Len);
      try
        pData := GlobalLock(hData);
        try
          Move(PChar(Value)^, pData^, Len);
          EmptyClipboard;
          SetClipboardData(CF_Text, hData);
        finally
          GlobalUnlock(hData);
        end;
      except
        GlobalFree(hData);
        raise
      end;
    finally
      CloseClipboard;
    end;
  end
  else
    Result := False;
end;

function GetClipboardText(Wnd: HWND; var Str: string): boolean;
var
  hData: HGlobal;
begin
  Result := True;
  if OpenClipboard(Wnd) then
  begin
    try
      hData := GetClipboardData(CF_TEXT);
      if hData <> 0 then
      begin
        try
          SetString(Str, PChar(GlobalLock(hData)), GlobalSize(hData));
        finally
          GlobalUnlock(hData);
        end;
      end
      else
        Result := False;
      Str := PChar(@Str[1]);
    finally
      CloseClipboard;
    end;
  end
  else
    Result := False;
end;

procedure TphpMOD.OSApiFunctions30Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
begin
  GetClipboardText(Application.Handle, s);
  ReturnValue := s;
end;

procedure TphpMOD.OSApiFunctions31Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  res: TPoint;
begin
  ClientToScreen(Parameters[0].Value, res);
  ReturnValue := RES.X;
end;

procedure TphpMOD.OSApiFunctions32Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  res: TPoint;
begin
  ClientToScreen(Parameters[0].Value, res);
  ReturnValue := RES.Y;
end;



procedure TphpMOD.OSApiFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := getlocalpath(Parameters[0].Value);
end;

procedure TphpMOD.OSApiFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := AddFontResource(ToPChar(Parameters[0].Value));
end;

procedure TphpMOD.OSApiFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := RemoveFontResource(ToPChar(Parameters[0].Value));
end;

procedure TphpMOD.libFormsFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[1].Value <> 0 then
    TTabSheet(ToObj(Parameters, 0)).PageControl := TPageControl(ToObj(Parameters, 1))
  else
    ReturnValue := integer(TTabSheet(ToObj(Parameters, 0)).PageControl);
end;

procedure TphpMOD.PHPLibraryFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ToCntrl(Parameters[0].Value).Repaint;
  ToCntrl(Parameters[0].Value).Refresh;

end;

procedure TphpMOD.PHPLibraryFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin

  if Parameters[1].Value <> Null then
  begin
    TWinControl(ToObj(Parameters[0].Value)).DoubleBuffered := Parameters[1].Value;
  end
  else
  begin
    ReturnValue := TWinControl(ToObj(Parameters[0].Value)).DoubleBuffered;
  end;
end;

procedure TphpMOD.winApiFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin

  RegisterHotKey(__mainForm.Handle, Parameters[0].Value, Parameters[1].Value,
    Parameters[2].Value);
end;

procedure TphpMOD._TSizeCtrlFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TSizeCtrl(ToObj(Parameters, 0)).TargetCount;
end;

procedure TphpMOD._TSizeCtrlFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TSizeCtrl(ToObj(Parameters, 0)).Targets[Parameters[1].Value]);
end;

procedure TphpMOD.PHPLibraryFunctions14Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  p: TPicture;
  // png: TPNGObject;
  b: Graphics.TBitmap;
begin
  P := TPicture.Create;
  b := Graphics.TBitmap(ToObj(Parameters, 1));
  b.Transparent := True;
  try

  {if (LowerCase(ExtractFileExt(Parameters[0].Value))='.png') then
      begin
         PNG := TPNGObject.Create;
         PNG.LoadFromFile(Parameters[0].Value);
         p.Assign(PNG);
         png.Free;
      end
  else}
    P.LoadFromFile(Parameters[0].Value);
    b.Width := P.Graphic.Width;
    b.Height := P.Graphic.Height;
    b.Canvas.Draw(0, 0, P.Graphic);
    // end;
  except
    {on e: Exception do
        ShowMessage(e.Message); }
  end;
  FreeAndNil(P);
end;

procedure TphpMOD.PHPLibraryFunctions15Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ToObj(Parameters, 0) = nil;
end;

procedure TphpMOD._MenusFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  obj: TObject;
  p: TPopupMenu;
begin
  obj := ToObj(Parameters, 1);

  if (Parameters[0].Value = Null) then
    p := nil
  else
    p := TPopupMenu(ToObj(Parameters, 0));

  if (obj is TCustomForm) then
    TForm(obj).PopupMenu := p
  else if (obj is TPanel) then
    TPanel(obj).PopupMenu := p
  else if (obj is TButton) then
    TButton(obj).PopupMenu := p
  else if (obj is TGroupBox) then
    TGroupBox(obj).PopupMenu := p
  else if (obj is TMemo) then
    TMemo(obj).PopupMenu := p
  else if (obj is TLabel) then
    TLabel(obj).PopupMenu := p
  else if (obj is TEdit) then
    TEdit(obj).PopupMenu := p
  else if (obj is TRadioGroup) then
    TRadioGroup(obj).PopupMenu := p
  else if (obj is TBitBtn) then
    TBitBtn(obj).PopupMenu := p
  else if (obj is TSpeedButton) then
    TSpeedButton(obj).PopupMenu := p
  else if (obj is TListBox) then
    TListBox(obj).PopupMenu := p
  else if (obj is TRichEdit) then
    TRichEdit(obj).PopupMenu := p
  else if (obj is TScrollBox) then
    TScrollBox(obj).PopupMenu := p
  else if (obj is TImage) then
    TImage(obj).PopupMenu := p
  else if (obj is TTrackBar) then
    TTrackBar(obj).PopupMenu := p
  else if (obj is TUpDown) then
    TUpDown(obj).PopupMenu := p
  else if (obj is TListView) then
    TListView(obj).PopupMenu := p
  else if (obj is TTreeView) then
    TTreeView(obj).PopupMenu := p
  else if (obj is TTabControl) then
    TTabControl(obj).PopupMenu := p
  else if (obj is TPageControl) then
    TPageControl(obj).PopupMenu := p
  else if (obj is TStatusBar) then
    TStatusBar(obj).PopupMenu := p
  else if (obj is THotKey) then
    THotKey(obj).PopupMenu := p
  else if (obj is TCoolTrayIcon) then
    TCoolTrayIcon(obj).PopupMenu := p

  else if (obj is TSizeCtrl) then
  begin
    TSizeCtrl(obj).PopupMenu := p;
  end;
end;

procedure TphpMOD._MenusFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TPopupMenu(ToObj(Parameters, 0)).Popup(Parameters[1].Value, Parameters[2].Value);

end;

procedure TphpMOD._MenusFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TPopupMenu(ToObj(Parameters, 0)).Items.Add(TMenuItem(ToObj(Parameters, 1)));
end;

procedure TphpMOD._MenusFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TPopupMenu(ToObj(Parameters, 0)).Items[Parameters[1].Value]);
end;

procedure TphpMOD._MenusFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TPopupMenu(ToObj(Parameters, 0)).Items.Count;
end;

procedure TphpMOD._MenusFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ShortCutToText(Parameters[0].Value);
end;

procedure TphpMOD._MenusFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TextToShortCut(Parameters[0].Value));
end;

procedure TphpMOD.libFormsFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  f1, f2: TFont;
begin
  f1 := TFont(integer(GetPropValue(ToObj(Parameters, 0), 'font')));
  f2 := TFont(integer(GetPropValue(ToObj(Parameters, 1), 'font')));

  f1.Assign(f2);
end;

procedure TphpMOD.PHPLibraryFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := not Graphics.TBitmap(ToObj(Parameters, 0)).Empty;
end;

procedure TphpMOD.libScreenFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Mouse.CursorPos.X;
end;

procedure TphpMOD.libScreenFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Mouse.CursorPos.Y;
end;

procedure TphpMOD._MenusFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TMenuItem(ToObj(Parameters, 0)).Add(TMenuItem(ToObj(Parameters, 1)));
end;

procedure TphpMOD.PHPLibraryFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ToComp(Parameters[0].Value).ComponentIndex;
end;

procedure TphpMOD.libFormsFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin

  if (Parameters[1].Value = Null) then
    ReturnValue := TForm(ToObj(Parameters, 0)).ModalResult
  else
    TForm(ToObj(Parameters, 0)).ModalResult := Parameters[1].Value;

end;

var
  ExeM: TExeStream;

procedure TphpMOD._ExeModFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Parameters[0].Value := StringReplace(Parameters[0].Value, '/', '\', [rfReplaceAll]);
  ExeM := TExeStream.Create(Parameters[0].Value);
end;

procedure TphpMOD._ExeModFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ExeM.IndexOf(Parameters[0].ZendVariable.AsString) > -1;
end;

procedure TphpMOD._ExeModFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ExeM.AddStringToExe(Parameters[0].ZendVariable.AsString,
    Parameters[1].ZendVariable.AsString);
end;

procedure TphpMOD._ExeModFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ZendVar.AsString := ExeM.ExtractToString(Parameters[0].Value);
  //ReturnValue := ExeM.ExtractToString(Parameters[0].Value);
end;

procedure TphpMOD._ExeModFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ExeM.EraseAlias(Parameters[0].Value);
end;

procedure TphpMOD._ExeModFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ExeM.SaveAsExe(Parameters[0].Value);
end;

procedure TphpMOD._ExeModFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ExeM.Free;
end;

function TempDir: string;
var
  Buffer: array[0..1023] of char;
begin
  SetString(Result, Buffer, GetTempPath(Sizeof(Buffer) - 1, Buffer));
end;

procedure TphpMOD.OSApiFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TempDir;
end;

procedure TphpMOD.OSApiFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ParamStr(Parameters[0].Value);
end;

procedure TphpMOD.PHPLibraryFunctions18Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
  //p: integer;
  //x: string;
begin
  o := ToObj(Parameters, 0);
  //p := integer(o);

{
if o is TPanel then
if TComponent(o).Name <> '' then
  x := TComponent(o).Name; }


{if (p < 999) then begin
  ZVAL_NULL(ZendVar.AsZendVariable);
  exit;
end;  }

  if o = nil then
  begin
    ZVAL_NULL(ZendVar.AsZendVariable);
    // := Null;
    exit;
  end;


  if not (o is TControl) then
  begin
    ReturnValue := Null;
    exit;
  end;

  try
    if (Parameters[1].ZendVariable.IsNull) then
      ZendVar.AsString := TControl(o).HelpKeyword
    //ReturnValue := TControl(o).HelpKeyword
    else
      TControl(o).HelpKeyword := Parameters[1].ZendVariable.AsString;
  except
    //ShowMessage(o.ClassName);
  end;
end;

procedure TphpMOD.PHPLibraryFunctions19Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if not (ToObj(Parameters, 0) is TControl) then
  begin
    ReturnValue := Null;
    exit;
  end;

  if (Parameters[1].Value = Null) then
    ReturnValue := TControl(ToObj(Parameters, 0)).Visible
  else
    TControl(ToObj(Parameters, 0)).Visible := Parameters[1].Value;
end;

procedure TphpMOD.PHPLibraryFunctions20Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if not (ToObj(Parameters, 0) is TControl) then
  begin
    ReturnValue := Null;
    exit;
  end;

  if (Parameters[1].Value = Null) then
    ReturnValue := TControl(ToObj(Parameters, 0)).Width
  else
    TControl(ToObj(Parameters, 0)).Width := Parameters[1].Value;
end;

procedure TphpMOD.PHPLibraryFunctions21Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if not (ToObj(Parameters, 0) is TControl) then
  begin
    ReturnValue := Null;
    exit;
  end;

  if (Parameters[1].Value = Null) then
    ReturnValue := TControl(ToObj(Parameters, 0)).Height
  else
    TControl(ToObj(Parameters, 0)).Height := Parameters[1].Value;
end;

procedure TphpMOD.PHPLibraryFunctions22Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if not (o is TControl) then
  begin
    ReturnValue := Null;
    exit;
  end;

  if (Parameters[1].Value = Null) then
    ReturnValue := TControl(ToObj(Parameters, 0)).Left
  else
    TControl(ToObj(Parameters, 0)).Left := Parameters[1].Value;
end;

procedure TphpMOD.PHPLibraryFunctions23Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if not (ToObj(Parameters, 0) is TControl) then
  begin
    ReturnValue := Null;
    exit;
  end;

  if (Parameters[1].Value = Null) then
    ReturnValue := TControl(ToObj(Parameters, 0)).Top
  else
    TControl(ToObj(Parameters, 0)).Top := Parameters[1].Value;
end;

procedure TphpMOD.PHPLibraryFunctions24Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if not (ToObj(Parameters, 0) is TControl) then
  begin
    ReturnValue := Null;
    exit;
  end;

  if (Parameters[1].Value = Null) then
    ReturnValue := TControl(ToObj(Parameters, 0)).Hint
  else
    TControl(ToObj(Parameters, 0)).Hint := Parameters[1].Value;
end;

procedure TphpMOD._TStreamLibFunctions19Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initStream(Parameters);

  String2Stream(Parameters[1].ZendVariable.AsString, TMemoryStream(tmpST));
end;

procedure TphpMOD._ExeModFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Parameters[1].Value := StringReplace(Parameters[1].Value, '/', '\', [rfReplaceAll]);
  ExeM.AddFromFile(Parameters[0].Value, Parameters[1].Value);
end;

procedure TphpMOD._ExeModFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Parameters[1].Value := StringReplace(Parameters[1].Value, '/', '\', [rfReplaceAll]);
  ExeM.ExtractToFile(Parameters[0].Value, Parameters[1].Value);
end;

procedure TphpMOD.OSApiFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ShellExecute(Parameters[0].Value,

    ToPChar(Parameters[1].Value),
    ToPChar(Parameters[2].Value),
    ToPChar(Parameters[3].Value),
    ToPChar(Parameters[4].Value),
    Parameters[5].Value

    );
end;


procedure TphpMOD._TPictureLibFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[0].Value = null then
    ReturnValue := False
  else
  begin
    if TPicture(ToObj(Parameters, 0)).Graphic = nil then
      ReturnValue := False
    else
      ReturnValue := not TPicture(ToObj(Parameters, 0)).Graphic.Empty;
  end;
end;



procedure TphpMOD._TListsFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  l: TListItem;
  c: string;
begin
  l := TListItem(ToObj(Parameters, 0));
  if not (l is TListItem) then
    exit;

  c := Parameters[1].Value;

  if c = 'delete' then
    l.Delete
  else if c = 'canceledit' then
    l.CancelEdit
  else if c = 'update' then
    l.Update
  else if c = 'editcaption' then
    ReturnValue := l.EditCaption;
end;

procedure TphpMOD._TListsFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  l: TListItems;
  i: integer;
  c: string;
  v, v2: variant;
begin
  l := TListItems(ToObj(Parameters, 0));

  if not (l is TListItems) then
    exit;
  //TListView
  c := Parameters[1].Value;
  v := Parameters[2].Value;
  v2 := Parameters[3].Value;

  if c = 'add' then
  begin
    ReturnValue := integer(l.Add);
  end
  else if c = 'additem' then
    ReturnValue := integer(l.AddItem(TListItem(ToObj(v)), v2))
  else if c = 'clear' then
  begin
    l.Clear;
  end
  else if c = 'beginupdate' then
    l.BeginUpdate
  else if c = 'endupdate' then
    l.EndUpdate
  else if c = 'delete' then
    l.Delete(v)
  else if c = 'indexof' then
    ReturnValue := l.IndexOf(TListItem(ToObj(v)))
  else if c = 'insert' then
    ReturnValue := integer(l.Insert(v))
  else if c = 'count' then
  begin
    ReturnValue := l.Count;
  end
  else if c = 'get' then
    ReturnValue := integer(l.Item[v])
  else if c = 'selected' then
  begin
    with l do
      for i := 0 to Count - 1 do
        if Item[i].Selected then
          ReturnValue := ReturnValue + IntToStr(i) + ',';
  end;
end;

procedure TphpMOD.PHPLibraryFunctions28Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
begin
  Parameters[0].Value := StringReplace(Parameters[0].Value, '/', '\', [rfReplaceAll]);

  s := File2String(Parameters[0].Value);
end;

procedure TphpMOD.PHPLibraryFunctions29Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ToCntrl(Parameters[0].Value).BringToFront;
end;

procedure TphpMOD.PHPLibraryFunctions30Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ToCntrl(Parameters[0].Value).SendToBack;
end;

procedure TphpMOD._TListsFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  l: TListItem;
  c: string;
  v: variant;
begin
  l := TListItem(ToObj(Parameters, 0));
  if not (l is TListItem) then
    exit;

  c := LowerCase(Parameters[1].Value);
  v := Parameters[2].Value;

  if v = Null then
  begin
    c := StringReplace(c, 'get_', '', [rfReplaceAll]);
    if c = 'caption' then
      ReturnValue := l.Caption
    else if c = 'checked' then
      ReturnValue := l.Checked
    else if c = 'focused' then
      ReturnValue := l.Focused
    else if c = 'index' then
      ReturnValue := l.Index
    else if c = 'imageindex' then
      ReturnValue := l.ImageIndex
    else if c = 'stateindex' then
      ReturnValue := l.StateIndex
    else if c = 'selected' then
      ReturnValue := l.Selected
    else if c = 'indent' then
      ReturnValue := l.Indent
    else if c = 'subitems' then
      ReturnValue := l.SubItems.Text;

  end
  else
  begin
    c := StringReplace(c, 'set_', '', [rfReplaceAll]);

    if c = 'caption' then
      l.Caption := v
    else if c = 'checked' then
      l.Checked := v
    else if c = 'focused' then
      l.Focused := v
    else if c = 'imageindex' then
      l.ImageIndex := v
    else if c = 'stateindex' then
      l.StateIndex := v
    else if c = 'indent' then
      l.Indent := v
    else if c = 'subitems' then
      l.SubItems.Text := v;
  end;

end;

procedure TphpMOD._TImageListFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  Temp, Bitmap: Graphics.TBitmap;
  imageList: TImageList;
begin
  try
    ReturnValue := True;
    imageList := TImageList(ToObj(Parameters, 0));
    Bitmap := Graphics.TBitmap(ToObj(Parameters[1].Value));
    Bitmap.TransparentColor := clWhite;
    Bitmap.Transparent := True;
    with ImageList do
      if (Bitmap.Width <> Width) or (Bitmap.Height <> Height) then
      begin
        Temp := Graphics.TBitmap.Create;
        try
          Temp.Width := Width;
          Temp.Height := Height;
          Temp.Canvas.Brush.Color := Parameters[2].Value;
          Temp.Canvas.FillRect(Temp.Canvas.ClipRect);
          // здесь оставишь только одноу нужную строку
          //1 вариант с искажением
          //Temp.Canvas.StretchDraw(Bitmap.Canvas.ClipRect, Bitmap);
          //2 вариант с центрированием
          Temp.Canvas.Draw((Temp.Width - Bitmap.Width) div 2,
            (Temp.Height - Bitmap.Height) div 2, Bitmap);
          AddMasked(Temp, Parameters[2].Value);

        except
          ReturnValue := False;
              {  on E : Exception do
                ShowMessage(E.ClassName+' ошибка с сообщением : '+E.Message);  }
        end;
        Temp.Free;

      end
      else
        ImageList.AddMasked(Bitmap, Parameters[2].Value);

  except
      {on E : Exception do
      ShowMessage(E.ClassName+' ошибка с сообщением : '+E.Message);  }
    ReturnValue := False;
  end;
end;

procedure TphpMOD._MenusFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  c: string;
  v: variant;
  M: TMenu;
begin
  M := TMenu(ToObj(Parameters, 0));
  c := Parameters[1].Value;
  v := Parameters[2].Value;

  if c = 'add' then
  begin
    RyMenu.Add(M);
    exit;
  end;
  if c = 'additem' then
  begin
    RyMenu.Add(TMenuItem(ToObj(Parameters, 0)));
    exit;
  end;
  if v = Null then
  begin
    if c = 'menucolor' then
      ReturnValue := RyMenu.MenuColor
    else if c = 'guttercolor' then
      ReturnValue := RyMenu.GutterColor
    else if c = 'selectedcolor' then
      ReturnValue := RyMenu.SelectedColor
    else if c = 'minheight' then
      ReturnValue := RyMenu.MinHeight
    else if c = 'minwidth' then
      ReturnValue := RyMenu.MinWidth;
  end
  else
  begin
    if c = 'menucolor' then
      RyMenu.MenuColor := v
    else if c = 'guttercolor' then
      RyMenu.GutterColor := v
    else if c = 'selectedcolor' then
      RyMenu.SelectedColor := v
    else if c = 'minheight' then
      RyMenu.MinHeight := v
    else if c = 'minwidth' then
      RyMenu.MinWidth := v;

  end;

end;

procedure TphpMOD._TPictureLibFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  p: TPicture;
  b: Graphics.TBitmap;
begin
  b := Graphics.TBitmap.Create;
  p := TPicture(ToObj(Parameters, 0));
  //p.Bitmap.Canvas.MoveTo(0,0);
  //b := p.Bitmap;
  try
    b.Width := P.Width;
    b.Height := P.Height;
    b.Canvas.Draw(0, 0, P.Graphic);
  finally
    ReturnValue := integer(b);
  end;
end;

procedure TphpMOD.PHPLibraryFunctions31Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TTabControl(ToObj(Parameters, 0)).IndexOfTabAt(
    Parameters[1].Value, Parameters[2].Value);
end;

procedure TphpMOD._TListsFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TCheckListBox(ToObj(Parameters, 0)).Checked[Parameters[1].Value];
end;

procedure TphpMOD._TListsFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TCheckListBox(ToObj(Parameters, 0)).Checked[Parameters[1].Value] := Parameters[2].Value;
end;

procedure TphpMOD._TImageListFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TImageList(ToObj(Parameters, 0)).Count;
end;

procedure TphpMOD._TImageListFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TImageList(ToObj(Parameters, 0)).Clear;
end;

procedure TphpMOD._TImageListFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TImageList(ToObj(Parameters, 0)).Insert(Parameters[1].Value,
    Graphics.TBitmap(ToObj(Parameters, 2)), Graphics.TBitmap(ToObj(Parameters, 3)));
end;

procedure TphpMOD._TImageListFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TImageList(ToObj(Parameters, 0)).InsertMasked(Parameters[1].Value,
    Graphics.TBitmap(ToObj(Parameters, 2)), Parameters[3].Value);
end;

procedure TphpMOD._TImageListFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TImageList(ToObj(Parameters, 0)).Move(Parameters[1].Value, Parameters[2].Value);
end;

procedure TphpMOD._MenusFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TMainMenu(ToObj(Parameters, 0)).Items.Add(TMenuItem(ToObj(Parameters, 1)));
end;

procedure TphpMOD.libApplicationFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  // ApplicationEx.Title := Parameters[0].Value;
  Application.Title := Parameters[0].Value;
end;

procedure TphpMOD.OSApiFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  LockWindowUpdate(Parameters[0].Value);
end;

procedure TphpMOD.OSApiFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TWinControl(ToObj(Parameters, 0)).Handle;
end;

procedure TphpMOD.OSApiFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue :=

    ToCntrl(Parameters[0].Value).Perform(Parameters[1].Value,
    Parameters[2].Value, Parameters[3].Value);
end;

procedure TphpMOD._TListsFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  i: integer;
  l: TListItems;
begin
  l := TListItems(ToObj(Parameters, 0));
  //l.Owner.SelectAll;
  l.Item[Parameters[1].Value].Selected := Parameters[2].Value;
  //l.Item[Parameters[1].Value].Focused  := Parameters[2].Value;
end;

function ExecuteAndWait(FileName: string; HideApplication: boolean;
  Mode: integer = SW_SHOW): boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  exitc: cardinal;
begin
  FillChar(StartupInfo, sizeof(StartupInfo), 0);
  with StartupInfo do
  begin
    cb := Sizeof(StartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := Mode;
  end;
  if not CreateProcess(nil, PChar(FileName), nil, nil, False,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo,
    ProcessInfo) then
    Result := False
  else
  begin
    if HideApplication then
    begin
      Application.Minimize;
      ShowWindow(Application.Handle, SW_HIDE);
      WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    end
    else
      while WaitforSingleObject(ProcessInfo.hProcess, 100) = WAIT_TIMEOUT do
      begin
        Application.ProcessMessages;
        if Application.Terminated then
          TerminateProcess(ProcessInfo.hProcess, 0);
      end;
    GetExitCodeProcess(ProcessInfo.hProcess, exitc);
    Result := (exitc = 0);
    if HideApplication then
    begin
      ShowWindow(Application.Handle, SW_HIDE);
      Application.Restore;
      Application.BringToFront;
    end;
  end;
end;

function ShellExecAndWait2(const FileName: string; const Parameters: string;
  const Verb: string; CmdShow: integer): boolean;
var
  Sei: TShellExecuteInfo;
  Res: longbool;
  Msg: tagMSG;

  function PCharOrNil(const S: ansistring): PAnsiChar;
  begin
    if Length(S) = 0 then
      Result := nil
    else
      Result := PAnsiChar(S);
  end;

begin
  FillChar(Sei, SizeOf(Sei), #0);
  Sei.cbSize := SizeOf(Sei);
  Sei.fMask := SEE_MASK_DOENVSUBST or SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS or
    SEE_MASK_FLAG_DDEWAIT;
  Sei.lpFile := PChar(FileName);
  Sei.lpParameters := PCharOrNil(Parameters);
  Sei.lpVerb := PCharOrNil(Verb);
  Sei.nShow := CmdShow;
  Result := ShellExecuteEx(@Sei);
  if Result then
  begin
    WaitForInputIdle(Sei.hProcess, INFINITE);
    while (WaitForSingleObject(Sei.hProcess, 10) = WAIT_TIMEOUT) do
    begin
      repeat
        Res := PeekMessage(Msg, Sei.Wnd, 0, 0, PM_REMOVE);
        if Res then
        begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
      until (Res = False);
    end;
    CloseHandle(Sei.hProcess);
  end;
end;

procedure ShellExecAndWait(dateiname: string; Parameter: string);
var
  executeInfo: TShellExecuteInfo;
  dw: DWORD;
begin
  FillChar(executeInfo, SizeOf(executeInfo), 0);
  with executeInfo do
  begin
    cbSize := SizeOf(executeInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    executeInfo.lpVerb := 'open';
    executeInfo.lpParameters := PChar(Parameter);
    lpFile := PChar(dateiname);
    nShow := SW_SHOWNORMAL;
  end;
  if ShellExecuteEx(@executeInfo) then
    dw := executeInfo.HProcess
  else
  begin
  {        ShowMessage('Fehler: ' + SysErrorMessage(GetLastError));
          Exit;
  }end;
  while WaitForSingleObject(executeInfo.hProcess, 50) <> WAIT_OBJECT_0 do
    Application.ProcessMessages;
  CloseHandle(dw);
end;

function ExecAndWait3(sExe, sCommandLine: string): boolean;
var
  tsi: TStartupInfo;
  tpi: TProcessInformation;
  dw: DWord;
begin
  Result := False;
  FillChar(tsi, SizeOf(TStartupInfo), 0);
  tsi.cb := SizeOf(TStartupInfo);
  if CreateProcess(nil, { Pointer to Application }
    PChar('"' + sExe + '" ' + sCommandLine), { Pointer to Application mit
Parameter }
    nil, { pointer to process security attributes }
    nil, { pointer to thread security attributes }
    False, { handle inheritance flag }
    CREATE_NEW_CONSOLE, { creation flags }
    nil, { pointer to new environment block }
    nil, { pointer to current directory name }
    tsi, { pointer to STARTUPINFO }
    tpi) { pointer to PROCESS_INF } then
  begin
    if WAIT_OBJECT_0 = WaitForSingleObject(tpi.hProcess, INFINITE) then
    begin
      if GetExitCodeProcess(tpi.hProcess, dw) then
      begin
        if dw = 0 then
        begin
          Result := True;
        end
        else
        begin
          SetLastError(dw + $2000);
        end;
      end;
    end;
    dw := GetLastError;
    CloseHandle(tpi.hProcess);
    CloseHandle(tpi.hThread);
    SetLastError(dw);
  end;
end;



procedure TphpMOD.OSApiFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Parameters[0].Value := StringReplace(Parameters[0].Value, '/', '\', [rfReplaceAll]);
  ExecuteAndWait(Parameters[0].Value, Parameters[1].Value, Parameters[2].Value);
end;

procedure TphpMOD.OSApiFunctions33Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Parameters[0].Value := StringReplace(Parameters[0].Value, '/', '\', [rfReplaceAll]);
  ExecAndWait3
  (Parameters[0].Value,
    Parameters[1].Value);
end;

procedure TphpMOD._TSynEditFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  if Parameters[1].Value = Null then
    ReturnValue := TSynEdit(ToObj(Parameters, 0)).CaretX
  else
    TSynEdit(ToObj(Parameters, 0)).CaretX := Parameters[1].Value;
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  if Parameters[1].Value = Null then
    ReturnValue := TSynEdit(ToObj(Parameters, 0)).CaretY
  else
    TSynEdit(ToObj(Parameters, 0)).CaretY := Parameters[1].Value;
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  if Parameters[1].Value = Null then
    ReturnValue := TSynEdit(ToObj(Parameters, 0)).SelStart
  else
    TSynEdit(ToObj(Parameters, 0)).SelStart := Parameters[1].Value;
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  if Parameters[1].Value = Null then
    ReturnValue := TSynEdit(ToObj(Parameters, 0)).SelEnd
  else
    TSynEdit(ToObj(Parameters, 0)).SelEnd := Parameters[1].Value;
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  if Parameters[1].Value = Null then
    ReturnValue := TSynEdit(ToObj(Parameters, 0)).LineText
  else
    TSynEdit(ToObj(Parameters, 0)).LineText := Parameters[1].Value;
{$ENDIF}
end;

procedure TphpMOD._TListsFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[2].Value = Null then
    ReturnValue := TListBox(ToObj(Parameters, 0)).Selected[Parameters[1].Value]
  else
    TListBox(ToObj(Parameters, 0)).Selected[Parameters[1].Value] := Parameters[2].Value;
end;

procedure TphpMOD._TListsFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  TStringList(o)[Parameters[1].Value] := Parameters[2].Value;
end;

function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := integer(TerminateProcess(OpenProcess(
        PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function ExistsTask(ExeFileName: string): boolean;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
      exit;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;


procedure TphpMOD.OSApiFunctions14Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  KillTask(StringReplace(StringReplace(Parameters[0].Value, '/', '\', []),
    '\\', '\', [rfReplaceAll])
    );
end;

procedure TphpMOD.OSApiFunctions15Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
begin
  ReturnValue := Null;
  if SelectDirectory(Parameters[0].Value, Parameters[1].Value, s) then
    ReturnValue := s;
end;

procedure TphpMOD.PHPLibraryFunctions33Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
begin
  Parameters[0].Value := StringReplace(Parameters[0].Value, '/', '\', [rfReplaceAll]);
  s := File2String(Parameters[0].Value);
  RunCode(s);
end;

procedure TphpMOD.libFormsFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TForm(ToObj(Parameters, 0)).ScrollBy(Parameters[1].Value, Parameters[2].Value);
end;

procedure TphpMOD.libFormsFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TForm(ToObj(Parameters, 0)).Parent := TWinControl(ToObj(Parameters, 1));
end;

procedure TphpMOD.PHPLibraryFunctions35Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    ReturnValue := integer(ToComp(Parameters[0].Value).Owner) = 0;
  except
    ReturnValue := False;
  end;
end;

procedure TphpMOD.OSApiFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  cd: TCopyDataStruct;
  s: ansistring;
begin
  s := Parameters[1].Value;
  cd.cbData := Length(s) + 1;
  cd.lpData := PChar(s);
  SendMessage(Parameters[0].Value,
    WM_COPYDATA,
    0,
    LParam(@cd));

end;

procedure TphpMOD.OSApiFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ZendVar.AsInteger := __mainForm.Handle;
  // ReturnValue := __mainForm.Handle;
end;

procedure TphpMOD.libApplicationFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Application.BringToFront;
end;

procedure TphpMOD._TSizeCtrlFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  list: TList;
  i: integer;
  pz: pzval;
begin
  list := TSizeCtrl(ToObj(Parameters, 0)).getSelected;
  SetLength(tmpAr, list.Count);

  for i := 0 to list.Count - 1 do
    tmpAR[i] := integer(list[i]);

  pz := ZendVar.AsZendVariable;
  ArrayToHash(tmpAR, pz);
end;

procedure TphpMOD.PHPLibraryFunctions36Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ToCntrl(Parameters[0].Value).Invalidate;
end;

procedure TphpMOD._TPictureLibFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  ic: TIcon;
  b: Graphics.TBitmap;
begin
  ic := TIcon(ToObj(Parameters, 0));
  b := Graphics.TBitmap(ToObj(Parameters, 1));

  b.PixelFormat := pf32bit;
  b.TransparentMode := tmAuto;

  ic.Width := b.Width;
  ic.Height := b.Height;
  ic.Transparent := True;
  ic.Assign(b);
end;

procedure TphpMOD._TPictureLibFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := not TIcon(ToObj(Parameters, 0)).Empty;
end;

procedure TphpMOD.PHPLibraryFunctions37Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Sleep(Parameters[0].ZendVariable.AsInteger);
end;

procedure TphpMOD._MenusFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TMenuItem(ToObj(Parameters, 0)).Clear;
end;

procedure TphpMOD._MenusFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TMenuItem(ToObj(Parameters, 0)).Delete(Parameters[1].Value);
end;

procedure TphpMOD.PHPLibraryFunctions38Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := FileExists(Parameters[0].Value);
end;

procedure TphpMOD.PHPLibraryFunctions39Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Application.CancelHint;
  Application.Hint := Parameters[0].Value;
  Application.ActivateHint(Point(Parameters[1].Value, Parameters[2].Value));
  Application.ShowHint := True;
end;

procedure TphpMOD._CanvasFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TCanvas(ToObj(Parameters, 0)).MoveTo(Parameters[1].Value, Parameters[2].Value);
end;

procedure TphpMOD._CanvasFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TCanvas(ToObj(Parameters, 0)).LineTo(Parameters[1].Value, Parameters[2].Value);
end;

procedure TphpMOD._CanvasFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  x: TObject;
begin
  x := ToObj(Parameters, 0);
  if x is TForm then
    ReturnValue := integer(TForm(x).Canvas)
  else if x is TPaintBox then
    ReturnValue := integer(TPaintBox(x).Canvas)
  else if x is TImage then
    ReturnValue := integer(TImage(x).Canvas)
  else if x is TMImage then
    ReturnValue := integer(TMImage(x).Canvas)
  else
    ReturnValue := False;
end;

procedure TphpMOD._TPictureLibFunctions14Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  Obj: TObject;
begin
  Obj := ToObj(Parameters, 1);
  if Obj is TClipboard then
    TPicture(ToObj(Parameters, 0)).Assign(TClipboard(Obj))
  else
    TPicture(ToObj(Parameters, 0)).Assign(TPicture(Obj).Graphic);
end;

procedure TphpMOD._TPictureLibFunctions15Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TPicture(ToObj(Parameters, 0)).Graphic := nil;
end;

procedure TphpMOD._TPictureLibFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TPicture(ToObj(Parameters, 0)).Bitmap.Assign(
    Graphics.TBitmap(ToObj(Parameters, 1))
    );
end;

procedure TphpMOD.PHPLibraryFunctions40Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := DateToStr(Parameters[0].Value);
end;

procedure TphpMOD.PHPLibraryFunctions41Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := StrToDateTime(Parameters[0].Value);
end;

procedure TphpMOD.OSApiFunctions18Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := GetSystemMetrics(Parameters[0].Value);
end;

procedure TphpMOD.OSApiFunctions19Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Windows.SetCursorPos(Parameters[0].Value, Parameters[1].Value);
end;

procedure TphpMOD.OSApiFunctions20Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Windows.SetCursor(screen.Cursors[Parameters[0].Value]);
end;

procedure TphpMOD.OSApiFunctions21Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin

  ReturnValue := Windows.SetCaretPos(Parameters[0].Value, Parameters[1].Value);
end;

procedure TphpMOD.libDialogsFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  obj: TCommonDialog;
begin
  obj := TCommonDialog(ToObj(Parameters, 0));

  if (obj is TOpenDialog) then
    ReturnValue := TOpenDialog(obj).Files.Text
  else if (obj is TSaveDialog) then
    ReturnValue := TSaveDialog(obj).Files.Text;
end;

procedure TphpMOD._TPictureLibFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TIcon(ToObj(Parameters, 0)).Assign(TIcon(ToObj(Parameters, 1)));
end;

procedure TphpMOD.PHPLibraryFunctions42Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    if Parameters[1].Value = Null then
      ReturnValue := integer(TPageControl(ToObj(Parameters, 0)).ActivePage)
    else
      TPageControl(ToObj(Parameters, 0)).ActivePage :=
        TTabSheet(ToObj(Parameters, 1));
  except

  end;
end;

procedure TphpMOD.PHPLibraryFunctions43Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TPageControl(ToObj(Parameters, 0)).PageCount;
end;

procedure TphpMOD.PHPLibraryFunctions44Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue :=
    integer(TPageControl(ToObj(Parameters, 0)).Pages[Parameters[1].Value]);
end;

procedure TphpMOD.OSApiFunctions22Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  mouse_event(Parameters[0].Value, Parameters[1].Value,
    Parameters[2].Value, Parameters[3].Value,
    Parameters[4].Value);
end;

procedure TphpMOD._TStreamLibFunctions20Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  initStream(Parameters);

  ZendVar.AsString := Stream2String(tmpST);
end;

procedure TphpMOD._TPictureLibFunctions18Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
  m: TStream;
begin
  o := ToObj(Parameters, 0);
  m := TStream(ToObj(Parameters, 1));

  if (o is TPicture) then
    TPicture(o).Graphic.LoadFromStream(m)
  else if (o is Graphics.TBitmap) then
    Graphics.TBitmap(o).LoadFromStream(m)
  else if (o is TIcon) then
    TIcon(o).LoadFromStream(m);
end;

procedure TphpMOD.PHPLibraryFunctions45Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := getAbsoluteX(ToCntrl(Parameters[0].Value),
    ToCntrl(Parameters[1].Value));
end;

procedure TphpMOD.PHPLibraryFunctions46Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := getAbsoluteY(ToCntrl(Parameters[0].Value),
    ToCntrl(Parameters[1].Value));
end;

procedure TphpMOD.OSApiFunctions23Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  res: TPoint;
  ht: pzval;
begin
  ClientToScreen(Parameters[0].Value, res);
  new(ht);
  ArrayToHash(['x', 'y'], [res.X, res.Y], ht);

  ZendVar.AsZendVariable^ := ht^;
  freemem(ht);
end;

procedure TphpMOD.OSApiFunctions24Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  res: TPoint;
  ht: pzval;
begin
  ClientToScreen(Parameters[0].Value, res);
  new(ht);
  ArrayToHash(['x', 'y'], [res.X, res.Y], ht);

  ZendVar.AsZendVariable^ := ht^;
  freemem(ht);
end;

procedure TphpMOD._TSizeCtrlFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  sizectrl_Self(Parameters);
  // sctrl.toFront(ToCntrl(Parameters[1].Value));
end;

procedure TphpMOD._TSizeCtrlFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  sizectrl_Self(Parameters);
  //sctrl.toBack(ToCntrl(Parameters[1].Value));
end;



procedure TphpMOD._TStringGridFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[3].Value = Null then
    ReturnValue := TStringGrid(ToObj(Parameters, 0)).Cells[Parameters[1].Value,
      Parameters[2].Value]
  else
    TStringGrid(ToObj(Parameters, 0)).Cells[Parameters[1].Value, Parameters[2].Value] :=
      Parameters[3].Value;
end;

procedure TphpMOD._TStringGridFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[1].Value = Null then
    ReturnValue := TStringGrid(ToObj(Parameters, 0)).Col
  else
    TStringGrid(ToObj(Parameters, 0)).Col := Parameters[1].Value;
end;

procedure TphpMOD._TStringGridFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[1].Value = Null then
    ReturnValue := TStringGrid(ToObj(Parameters, 0)).Row
  else
    TStringGrid(ToObj(Parameters, 0)).Row := Parameters[1].Value;
end;

procedure TphpMOD._TStringGridFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[2].Value = Null then
    ReturnValue := TStringGrid(ToObj(Parameters, 0)).Rows[Parameters[1].Value].Text
  else
    TStringGrid(ToObj(Parameters, 0)).Rows[Parameters[1].Value].Text := Parameters[2].Value;
end;

procedure TphpMOD._TStringGridFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[2].Value = Null then
    ReturnValue := TStringGrid(ToObj(Parameters, 0)).Cols[Parameters[1].Value].Text
  else
    TStringGrid(ToObj(Parameters, 0)).Cols[Parameters[1].Value].Text := Parameters[2].Value;
end;

procedure TphpMOD._TStringGridFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  r: TGridCoord;
  ht: pzval;
begin
  r := TStringGrid(ToObj(Parameters, 0)).MouseCoord(Parameters[1].Value,
    Parameters[2].Value);
  new(ht);
  ArrayToHash(['x', 'y'], [r.X, r.Y], ht);

  ZendVar.AsZendVariable^ := ht^;
  freemem(ht);
end;

procedure TphpMOD._TStringGridFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  row, col: integer;
  ht: pzval;
begin
  TStringGrid(ToObj(Parameters, 0)).MouseToCell
  (Parameters[1].Value, Parameters[2].Value, col, row);

  new(ht);
  ArrayToHash(['col', 'row'], [col, row], ht);

  ZendVar.AsZendVariable^ := ht^;
  freemem(ht);
end;

procedure TphpMOD._TStringGridFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[2].Value = Null then
    ReturnValue := TStringGrid(ToObj(Parameters, 0)).ColWidths[Parameters[1].Value]
  else
    TStringGrid(ToObj(Parameters, 0)).ColWidths[Parameters[1].Value] :=
      Parameters[2].Value;
end;

procedure TphpMOD._TStringGridFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[2].Value = Null then
    ReturnValue := TStringGrid(ToObj(Parameters, 0)).RowHeights[Parameters[1].Value]
  else
    TStringGrid(ToObj(Parameters, 0)).RowHeights[Parameters[1].Value] :=
      Parameters[2].Value;
end;

procedure TphpMOD._CanvasFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TControlCanvas.Create);
end;

procedure TphpMOD._CanvasFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[1].Value = Null then
    ReturnValue := integer(TControlCanvas(ToObj(Parameters, 0)).Control)
  else
    TControlCanvas(ToObj(Parameters, 0)).Control := ToCntrl(Parameters[1].Value);

end;

procedure TphpMOD._CanvasFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TCanvas(ToObj(Parameters, 0)).TextHeight(Parameters[1].Value);
end;

procedure TphpMOD._CanvasFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TCanvas(ToObj(Parameters, 0)).Refresh;
end;

procedure TphpMOD._CanvasFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TCanvas(ToObj(Parameters, 0)).TextWidth(Parameters[1].Value);
end;

procedure TphpMOD._CanvasFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[3].Value = Null then
    ReturnValue := TCanvas(ToObj(Parameters, 0)).Pixels[Parameters[1].Value,
      Parameters[2].Value]
  else
    TCanvas(ToObj(Parameters, 0)).Pixels[Parameters[1].Value, Parameters[2].Value] :=
      Parameters[3].Value;
end;

procedure TphpMOD._CanvasFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TCanvas(ToObj(Parameters, 0)).TextOut(Parameters[1].Value, Parameters[2].Value,
    Parameters[3].Value);
end;

procedure TphpMOD._ChromiumFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  ARR: TArrayVariant;
  {$IFDEF ADD_CHROMIUM}
  Req: ICefRequest;
  Header: ICefStringMap;
  {$ENDIF}
begin
{$IFDEF ADD_CHROMIUM}
  with TChromium(ToObj(Parameters, 0)) do
  begin
    HashToArray(Parameters[2].ZendVariable, ARR);

    case Parameters[1].ZendVariable.AsInteger of
      1: Browser.Reload;
      2: Browser.GoBack;
      3: ZendVar.AsBoolean := Browser.CanGoBack;
      4: Browser.GoForward;
      5: ZendVar.AsBoolean := Browser.CanGoForward;
      6: Browser.ShowDevTools;
      7: Browser.CloseDevTools;
      8: Browser.HidePopup;
      9:
      begin
        if Length(ARR) > 0 then
          Browser.SetFocus(ARR[0])
        else
          Browser.SetFocus(True);
      end;
      10: Browser.ReloadIgnoreCache;
      11: Browser.StopLoad;
      12: if Length(Arr) > 0 then
          Browser.SendFocusEvent(arr[0]);
      13: if Length(Arr) > 4 then
          Browser.SendKeyEvent(TCefKeyType(arr[0]), arr[1], arr[2], arr[3], arr[4]);
      14: if Length(Arr) > 4 then
          Browser.SendMouseClickEvent(arr[0], arr[1],
            TCefMouseButtonType(arr[2]), arr[3], arr[4]);
      15: if Length(arr) > 0 then
          Load(arr[0]);
      16: if Length(arr) > 1 then
          ScrollBy(arr[0], arr[1]);
      17: Browser.ClearHistory;
      18: ;
      19: ;
      20: ;
      21: ;
      22: Browser.MainFrame.Undo;
      23: Browser.MainFrame.Redo;
      24: Browser.MainFrame.Cut;
      25: Browser.MainFrame.Copy;
      26: Browser.MainFrame.Paste;
      27: Browser.MainFrame.Del;
      28: Browser.MainFrame.SelectAll;
      29: Browser.MainFrame.Print;
      30: Browser.MainFrame.ViewSource;
      31: if Length(arr) > 0 then
          Browser.MainFrame.LoadUrl(arr[0]);
      32: if Length(arr) > 1 then
          Browser.MainFrame.LoadString(arr[0], arr[1]);
      33: if Length(arr) > 1 then
          Browser.MainFrame.LoadFile(arr[0], arr[1]);
      34: if Length(arr) > 2 then
          Browser.MainFrame.ExecuteJavaScript(arr[0], arr[1], arr[2]);
      35:
      begin
        Req := TCefRequestRef.Create(nil);
        Header := TCefStringMapOwn.Create;

        Req.Url := arr[0];
        Req.Method := arr[1];
        //Req.SetHeaderMap();
        //Browser.MainFrame.LoadRequest();
      end;
      36:
      begin
        if length(arr) > 0 then
          UserStyleSheetLocation := arr[0]
        else
          ZendVar.AsString := UserStyleSheetLocation;
      end;
      37:
      begin
        if length(arr) > 0 then
          DefaultEncoding := arr[0]
        else
          ZendVar.AsString := UserStyleSheetLocation;
      end;
      38:
      begin
        if Browser.MainFrame <> nil then
          ZendVar.AsString := Browser.MainFrame.Source;
      end;
      39:
      begin
        if Browser.MainFrame <> nil then

          zendVar.AsString := Browser.MainFrame.Url;
      end;
    end;
  end;
{$ENDIF}
end;

procedure TphpMOD._ChromiumFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  isGet: boolean;
begin
{$IFDEF ADD_CHROMIUM}
  isGet := Parameters[2].Value = Null;
  with TChromium(ToObj(Parameters, 0)) do
  begin
    case Parameters[1].ZendVariable.AsInteger of
      1: if isGet then
          ReturnValue := Browser.ZoomLevel
        else
          Browser.ZoomLevel := Parameters[2].ZendVariable.AsFloat;

      2: if isGet then
        else
          ZendVar.AsString := Browser.MainFrame.Url;

      3: if isGet then
          ZendVar.AsString := Browser.MainFrame.Source;

      4: if isGet then
          ZendVar.AsString := Browser.MainFrame.Text
    end;
  end;
{$ENDIF}
end;

procedure TphpMOD._DockingFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ToCntrl(Parameters[0].Value).ManualDock(
    TWinControl(ToObj(Parameters, 1)), nil,
    Parameters[2].Value);
end;

procedure TphpMOD._DockingFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  r: TRect;
begin
  Windows.GetWindowRect(TWinControl(ToObj(Parameters, 0)).Handle, r);
  ReturnValue := r.Top;
end;


procedure TphpMOD._DockingFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  r: TRect;
begin
  Windows.GetWindowRect(TWinControl(ToObj(Parameters, 0)).Handle, r);
  ReturnValue := r.Right - r.Left;
end;

procedure TphpMOD._DockingFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  r: TRect;
begin
  Windows.GetWindowRect(TWinControl(ToObj(Parameters, 0)).Handle, r);
  ReturnValue := r.Bottom - r.Top;
end;

procedure TphpMOD._DockingFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TDragDockObject(TDragDockObjectCep.Create(
    TControl(ToObj(Parameters, 0)))));
end;

procedure TphpMOD._DockingFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ToCntrl(Parameters[0].Value).ManualFloat(
    Rect(Parameters[1].Value, Parameters[2].Value, Parameters[3].Value,
    Parameters[4].Value));
end;

procedure TphpMOD._DockingFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TWinControl(ToObj(Parameters, 0)).DockClientCount;
end;

procedure TphpMOD._DockingFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TWinControl(ToObj(Parameters, 0)).DockClients[Parameters[1].Value]);
end;

procedure TphpMOD._DockingFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TWinControl(ToObj(Parameters, 0)).DockOrientation);
end;

procedure TphpMOD._DockingFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  TWinControl(ToObj(Parameters, 0)).DockManager.SaveToStream(m);
  m.SaveToFile(StringReplace(Parameters[1].Value, '/', '\', []));
  m.Free;
end;

procedure TphpMOD._DockingFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  m.LoadFromFile(StringReplace(Parameters[1].Value, '/', '\', []));
  TWinControl(ToObj(Parameters, 0)).DockManager.LoadFromStream(m);
  m.Free;
end;

procedure TphpMOD._DockingFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TWinControl(ToObj(Parameters, 0)).FloatingDockSiteClass := DefaultDockFormClass;
end;

procedure TphpMOD._DockingFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TWinControl(ToObj(Parameters, 0)).Dock(TWinControl(ToObj(Parameters, 1)),
    Rect(Parameters[2].Value, Parameters[3].Value, Parameters[4].Value,
    Parameters[5].Value)

    );
end;

procedure TphpMOD._DockingFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  r: TRect;
begin
  Windows.GetWindowRect(TWinControl(ToObj(Parameters, 0)).Handle, r);
  ReturnValue := r.Left;
end;

procedure TphpMOD._CanvasFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TCanvas(ToObj(Parameters, 0)).Font);
end;

procedure TphpMOD._CanvasFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TCanvas(ToObj(Parameters, 0)).Brush);
end;

procedure TphpMOD._CanvasFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TCanvas(ToObj(Parameters, 0)).Pen);
end;

procedure TphpMOD._CanvasFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TCanvas(ToObj(Parameters, 0)).Rectangle(
    Parameters[1].Value,
    Parameters[2].Value,
    Parameters[3].Value,
    Parameters[4].Value);
end;

procedure TphpMOD._CanvasFunctions14Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TControlCanvas(ToObj(Parameters, 0)).Ellipse(
    Parameters[1].Value,
    Parameters[2].Value,
    Parameters[3].Value,
    Parameters[4].Value);
end;

procedure TphpMOD._CanvasFunctions15Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TControlCanvas(ToObj(Parameters, 0)).Lock();
end;

procedure TphpMOD._CanvasFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TControlCanvas(ToObj(Parameters, 0)).Unlock();
end;

procedure TphpMOD._CanvasFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TControlCanvas(ToObj(Parameters, 0)).Draw(Parameters[2].Value, Parameters[3].Value,
    Graphics.TBitmap(ToObj(Parameters, 1)));
end;



procedure TphpMOD._CanvasFunctions18Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TControlCanvas(ToObj(Parameters, 0)).FillRect(
    TControlCanvas(ToObj(Parameters, 0)).ClipRect);
end;


procedure CanvasSetTextAngle(c: TCanvas; d: single);
var
  LogRec: TLOGFONT; { Информация о шрифте }
begin
  {Читаем текущюю инф. о шрифте }
  GetObject(c.Font.Handle, SizeOf(LogRec), Addr(LogRec));
  { Изменяем угол }
  LogRec.lfEscapement := round(d * 10);
  { Устанавливаем новые параметры }
  c.Font.Handle := CreateFontIndirect(LogRec);
end;

procedure TphpMOD._CanvasFunctions19Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  CanvasSetTextAngle(TCanvas(ToObj(Parameters, 0)), Parameters[1].Value);
end;

procedure TphpMOD._CanvasFunctions20Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  b: Graphics.TBitmap;
  cv: TCanvas;
begin
  b := Graphics.TBitmap(ToObj(Parameters, 1));
  cv := TCanvas(ToObj(Parameters, 0));
  b.Width := cv.ClipRect.Right - cv.ClipRect.Left;
  b.Height := cv.ClipRect.Bottom - cv.ClipRect.Top;

  b.Canvas.CopyRect(cv.ClipRect, cv, b.Canvas.ClipRect);
end;

procedure TphpMOD._MenusFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TPopupMenu(ToObj(Parameters, 0)).PopupPoint.X > -1;
end;

procedure TphpMOD.PHPLibraryFunctions47Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TWinControl(ToObj(Parameters, 0)).Focused;
end;

procedure TphpMOD.PHPLibraryFunctions48Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  IdleEnable := Parameters[0].Value;
end;

procedure TphpMOD._BackWorkerFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  //TBackgroundWorker(ToObj(Parameters,0)).Stop;
end;

procedure TphpMOD._BackWorkerFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
 {if Parameters[0].Value = Null then
  ReturnValue := integer( TBackgroundWorker.Create(Application.MainForm) )
 else begin
  ReturnValue := integer( TBackgroundWorker.Create(ToComp(Parameters[0].Value)) );
 end;}

end;

procedure TphpMOD._BackWorkerFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[0].Value = null then
    ReturnValue := varsStr
  else
    varsStr := Parameters[0].Value;
end;

procedure TphpMOD._BackWorkerFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  //TBackgroundWorker(ToObj(Parameters,0)).Execute;
end;

procedure TphpMOD._BackWorkerFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  threadEngineFile := Parameters[0].Value;
end;

procedure TphpMOD._BackWorkerFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := isTermited;
end;

procedure TphpMOD._BackWorkerFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  x: integer;
begin
  x := Parameters[0].Value;
  ReturnValue := Random(x);
end;

procedure TphpMOD._TSynEditFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  if Parameters[1].Value = True then
    TSynCompletionProposal(ToObj(Parameters, 0)).ActivateCompletion
  else
    TSynCompletionProposal(ToObj(Parameters, 0)).CancelCompletion;
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  if Parameters[1].Value = Null then
    ReturnValue := integer(TSynCompletionProposal(ToObj(Parameters, 0)).Editor)
  else
    TSynCompletionProposal(ToObj(Parameters, 0)).Editor :=
      TSynEdit(ToObj(Parameters, 1));
{$ENDIF}
end;

procedure TphpMOD.PHPLibraryFunctions50Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[1].Value = 2012 then
    ZendVar.AsString := (Parameters[0].ZendVariable.AsString)
  else
    ZendVar.AsString := Base64_Encode(Parameters[0].ZendVariable.AsString);
end;


procedure TphpMOD.__WinUtilsFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := libSysTray.showBalloonTip(
    TCoolTrayIcon(ToObj(Parameters[0].Value)), Parameters[1].Value,
    Parameters[2].Value, Parameters[3].Value, Parameters[4].Value);
end;

procedure TphpMOD.__WinUtilsFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := libSysTray.hideBalloonTip(TCoolTrayIcon(ToObj(Parameters[0].Value)));
end;

procedure TphpMOD._TSynEditFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);

  if o is TRichEdit then
    TRichEdit(ToObj(Parameters, 0)).Lines.LoadFromFile(Parameters[1].Value);
end;

procedure TphpMOD._TSynEditFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);

  if o is TRichEdit then
    TRichEdit(o).Lines.SaveToFile(Parameters[0].Value);
end;

procedure TphpMOD._TSynEditFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  m: TMemoryStream;
begin

  if Parameters[1].Value = Null then
  begin
    m := TMemoryStream.Create;
    TRichEdit(ToObj(Parameters, 0)).Lines.SaveToStream(m);
    ReturnValue := Stream2String(m);
    m.Free;
  end
  else
  begin
    m := nil;
    String2Stream(Parameters[1].Value, m);
    TRichEdit(ToObj(Parameters, 0)).Lines.LoadFromStream(m);
    m.Free;
  end;

end;

procedure TphpMOD._TSynEditFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  r: TRichEdit;
  c: string;
begin
  r := TRichEdit(ToObj(Parameters, 0));
  c := LowerCase(Parameters[1].Value);

  if Parameters[2].Value = Null then
  begin
    if c = 'name' then
      ReturnValue := r.SelAttributes.Name
    else if c = 'size' then
      ReturnValue := r.SelAttributes.Size
    else if c = 'color' then
      ReturnValue := r.SelAttributes.Color
    else if c = 'charset' then
      ReturnValue := r.SelAttributes.Charset
    else if c = 'bold' then
      ReturnValue := fsBold in r.SelAttributes.Style
    else if c = 'italic' then
      ReturnValue := fsItalic in r.SelAttributes.Style
    else if c = 'underline' then
      ReturnValue := fsUnderline in r.SelAttributes.Style
    else if c = 'strikeout' then
      ReturnValue := fsStrikeOut in r.SelAttributes.Style;

  end
  else
  begin

    if c = 'name' then
      r.SelAttributes.Name := Parameters[2].Value
    else if c = 'size' then
      r.SelAttributes.Size := Parameters[2].Value
    else if c = 'color' then
      r.SelAttributes.Color := Parameters[2].Value
    else if c = 'charset' then
      r.SelAttributes.Charset := Parameters[2].Value

    else if c = 'bold' then
    begin
      if Parameters[2].Value = True then
        r.SelAttributes.Style := r.SelAttributes.Style + [fsBold]
      else
        r.SelAttributes.Style := r.SelAttributes.Style - [fsBold];
    end

    else if c = 'italic' then
    begin
      if Parameters[2].Value = True then
        r.SelAttributes.Style := r.SelAttributes.Style + [fsItalic]
      else
        r.SelAttributes.Style := r.SelAttributes.Style - [fsItalic];
    end

    else if c = 'underline' then
    begin
      if Parameters[2].Value = True then
        r.SelAttributes.Style := r.SelAttributes.Style + [fsUnderline]
      else
        r.SelAttributes.Style := r.SelAttributes.Style - [fsUnderline];
    end

    else if c = 'strikeout' then
    begin
      if Parameters[2].Value = True then
        r.SelAttributes.Style := r.SelAttributes.Style + [fsStrikeOut]
      else
        r.SelAttributes.Style := r.SelAttributes.Style - [fsStrikeOut];
    end;
  end;

end;

procedure TphpMOD.PHPLibraryFunctions51Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TScrollBox(ToObj(Parameters, 0)).VertScrollBar.IsScrollBarVisible;
end;

procedure TphpMOD.PHPLibraryFunctions52Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TScrollBox(ToObj(Parameters, 0)).HorzScrollBar.IsScrollBarVisible;
end;

procedure TphpMOD.PHPLibraryFunctions53Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TScrollBox(ToObj(Parameters, 0)).VertScrollBar.Size;

end;

procedure TphpMOD._TSynEditFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  ReturnValue := TSynCompletionProposal(ToObj(Parameters, 0)).Form.Visible;
{$ENDIF}
end;

procedure TphpMOD.guiFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if ToObj(Parameters, 0) is TWinControl then
    ReturnValue := TWinControl(ToObj(Parameters, 0)).ControlCount
  else
    ReturnValue := 0;
end;

procedure TphpMOD.guiFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if ToObj(Parameters, 0) is TWinControl then
    ReturnValue := integer(TWinControl(ToObj(Parameters, 0)).Controls[Parameters[1].Value])
  else
    ReturnValue := Null;
end;

procedure TphpMOD.guiFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := GetScrollPos(TWinControl(ToObj(Parameters, 0)).Handle,
    Parameters[1].Value);
end;

procedure TphpMOD.guiFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  SetScrollPos(TWinControl(ToObj(Parameters, 0)).Handle, Parameters[1].Value,
    Parameters[2].Value, Parameters[1].Value);
end;

procedure TphpMOD.PHPLibraryFunctions54Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  RunCode(Parameters[0].Value);
end;

procedure TphpMOD.PHPLibraryFunctions55Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ToComp(Parameters[0].Value).Name;
end;

procedure TphpMOD.PHPLibraryFunctions56Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
  v: variant;
begin
  o := ToObj(Parameters[0].Value);
  v := Parameters[1].Value;

  if v = Null then
  begin

    if o is TCustomEdit then
      ReturnValue := TCustomEdit(o).Text
    else if o is TListBox then
      ReturnValue := TListBox(o).Items.Text
    else if o is TComboBox then
      ReturnValue := TComboBox(o).Items.Text
    else if o is TSpeedButton then
      ReturnValue := TSpeedButton(o).Caption
    else if o is TButton then
      ReturnValue := TButton(o).Caption
    else if o is TCheckBox then
      ReturnValue := TCheckBox(o).Caption
    else if o is TRadioButton then
      ReturnValue := TRadioButton(o).Caption
    else if o is TGroupBox then
      ReturnValue := TGroupBox(o).Caption
    else if o is TRadioGroup then
      ReturnValue := TRadioGroup(o).Caption
    else if o is TPanel then
      ReturnValue := TPanel(o).Caption
    else if o is TLabel then
      ReturnValue := TLabel(o).Caption
    else if o is TMenuItem then
      ReturnValue := TMenuItem(o).Caption
    else if o is TListItem then
      ReturnValue := TListItem(o).Caption
    else
    if GetPropInfo(o, 'Caption') <> nil then
      ReturnValue := GetPropValue(o, 'Caption')
    else
      ReturnValue := Null;

  end
  else
  begin

    if o is TCustomEdit then
      TCustomEdit(o).Text := v
    else if o is TListBox then
      TListBox(o).Items.Text := v
    else if o is TComboBox then
      TComboBox(o).Items.Text := v
    else if o is TSpeedButton then
      TSpeedButton(o).Caption := v
    else if o is TButton then
      TButton(o).Caption := v
    else if o is TCheckBox then
      TCheckBox(o).Caption := v
    else if o is TRadioButton then
      TRadioButton(o).Caption := v
    else if o is TGroupBox then
      TGroupBox(o).Caption := v
    else if o is TRadioGroup then
      TRadioGroup(o).Caption := v
    else if o is TPanel then
      TPanel(o).Caption := v
    else if o is TLabel then
      TLabel(o).Caption := v
    else if o is TMenuItem then
      TMenuItem(o).Caption := v
    else if o is TListItem then
      TListItem(o).Caption := v
    else
    if GetPropInfo(o, 'Caption') <> nil then
      SetPropValue(o, 'Caption', v);

  end;
end;

procedure TphpMOD.PHPLibraryFunctions57Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  String2Stream(Parameters[1].Value, TMemoryStream(ToObj(Parameters, 0)));
end;

procedure TphpMOD._TSynEditFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
  v: variant;
begin
  o := ToObj(Parameters, 0);
  v := Parameters[1].Value;

  if v = Null then
  begin

    if o is TEdit then
      ReturnValue := TEdit(o).SelStart
    else if o is TMemo then
      ReturnValue := TMemo(o).SelStart
    else if o is TRichEdit then
      ReturnValue := TRichEdit(o).SelStart
      {$IFDEF VS_EDITOR}
    else if o is TSynEdit then
      ReturnValue := TSynEdit(o).SelStart
      {$ENDIF}
    else
      ReturnValue := Null;

  end
  else
  begin

    if o is TEdit then
      TEdit(o).SelStart := v
    else if o is TMemo then
      TMemo(o).SelStart := v
    else if o is TRichEdit then
      TRichEdit(o).SelStart := v
      {$IFDEF VS_EDITOR}
    else if o is TSynEdit then
      TSynEdit(o).SelStart := v
      {$ENDIF}
    ;
  end;

end;

procedure TphpMOD._TSynEditFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
  v: variant;
begin
  o := ToObj(Parameters, 0);
  v := Parameters[1].Value;

  if v = Null then
  begin

    if o is TEdit then
      ReturnValue := TEdit(o).SelLength
    else if o is TMemo then
      ReturnValue := TMemo(o).SelLength
    else if o is TRichEdit then
      ReturnValue := TRichEdit(o).SelLength
      {$IFDEF VS_EDITOR}
    else if o is TSynEdit then
      ReturnValue := TSynEdit(o).SelLength
      {$ENDIF}
    else
      ReturnValue := Null;

  end
  else
  begin

    if o is TEdit then
      TEdit(o).SelLength := v
    else if o is TMemo then
      TMemo(o).SelLength := v
    else if o is TRichEdit then
      TRichEdit(o).SelLength := v
      {$IFDEF VS_EDITOR}
    else if o is TSynEdit then
      TSynEdit(o).SelLength := v
      {$ENDIF}
    ;

  end;

end;

procedure TphpMOD._TSynEditFunctions14Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
  v: variant;
begin
  o := ToObj(Parameters, 0);
  v := Parameters[1].Value;

  if v = Null then
  begin

    if o is TEdit then
      ReturnValue := TEdit(o).SelText
    else if o is TMemo then
      ReturnValue := TMemo(o).SelText
    else if o is TRichEdit then
      ReturnValue := TRichEdit(o).SelText
      {$IFDEF VS_EDITOR}
    else if o is TSynEdit then
      ReturnValue := TSynEdit(o).SelText
      {$ENDIF}
    else
      ReturnValue := Null;

  end
  else
  begin

    if o is TEdit then
      TEdit(o).SelText := v
    else if o is TMemo then
      TMemo(o).SelText := v
    else if o is TRichEdit then
      TRichEdit(o).SelText := v
      {$IFDEF VS_EDITOR}
    else if o is TSynEdit then
      TSynEdit(o).SelText := v
      {$ENDIF}
    ;

  end;

end;

procedure TphpMOD._TSynEditFunctions15Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TEdit then
    TEdit(o).SelectAll
  else if o is TMemo then
    TMemo(o).SelectAll
  else if o is TRichEdit then
    TRichEdit(o).SelectAll
      {$IFDEF VS_EDITOR}
  else if o is TSynEdit then
    TSynEdit(o).SelectAll;
      {$ENDIF}
end;

procedure TphpMOD.winApiFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  keybd_event(Parameters[0].Value, Parameters[1].Value, Parameters[2].Value,
    Parameters[3].Value);
end;

procedure SimulateKeyDown(Key: byte);
begin
  keybd_event(Key, 0, 0, 0);
end;

procedure SimulateKeyUp(Key: byte);
begin
  keybd_event(Key, 0, KEYEVENTF_KEYUP, 0);
end;

procedure SimulateKeystroke(Key: byte; extra: DWORD);
begin
  keybd_event(Key, extra, 0, 0);
  keybd_event(Key, extra, KEYEVENTF_KEYUP, 0);
end;

procedure SendKeys(s: string);
var
  i: integer;
  flag: bool;
  w: word;
begin
  {Get the state of the caps lock key}
  flag := not GetKeyState(VK_CAPITAL) and 1 = 0;
  {If the caps lock key is on then turn it off}
  if flag then
    SimulateKeystroke(VK_CAPITAL, 0);
  for i := 1 to Length(s) do
  begin
    w := VkKeyScan(s[i]);
    {If there is not an error in the key translation}
    if ((HiByte(w) <> $FF) and (LoByte(w) <> $FF)) then
    begin
      {If the key requires the shift key down - hold it down}
      if HiByte(w) and 1 = 1 then
        SimulateKeyDown(VK_SHIFT);
      {Send the VK_KEY}
      SimulateKeystroke(LoByte(w), 0);
      {If the key required the shift key down - release it}
      if HiByte(w) and 1 = 1 then
        SimulateKeyUp(VK_SHIFT);
    end;
  end;
  {if the caps lock key was on at start, turn it back on}
  if flag then
    SimulateKeystroke(VK_CAPITAL, 0);
end;

procedure TphpMOD.winApiFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  SendKeys(Parameters[0].Value);
end;

procedure TphpMOD._TSynEditFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  ReturnValue := TSynCompletionProposal(ToObj(Parameters, 0)).CurrentString;
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  ReturnValue := TSynCompletionProposal(ToObj(Parameters, 0)).Form.AssignedList.Text = '';
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions18Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TEdit then
    TEdit(o).CutToClipboard
  else if o is TMemo then
    TMemo(o).CutToClipboard
  else if o is TRichEdit then
    TRichEdit(o).CutToClipboard
      {$IFDEF VS_EDITOR}
  else if o is TSynEdit then
    TSynEdit(o).CutToClipboard
      {$ENDIF}
  ;
end;

procedure TphpMOD._TSynEditFunctions19Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TEdit then
    TEdit(o).CopyToClipboard
  else if o is TMemo then
    TMemo(o).CopyToClipboard
  else if o is TRichEdit then
    TRichEdit(o).CopyToClipboard
      {$IFDEF VS_EDITOR}
  else if o is TSynEdit then
    TSynEdit(o).CopyToClipboard
      {$ENDIF}
  ;
end;

procedure TphpMOD._TSynEditFunctions20Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TEdit then
    TEdit(o).PasteFromClipboard
  else if o is TMemo then
    TMemo(o).PasteFromClipboard
  else if o is TRichEdit then
    TRichEdit(o).PasteFromClipboard
      {$IFDEF VS_EDITOR}
  else if o is TSynEdit then
    TSynEdit(o).PasteFromClipboard
      {$ENDIF}
  ;
end;

procedure TphpMOD._TSynEditFunctions21Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TEdit then
    TEdit(o).ClearSelection
  else if o is TMemo then
    TMemo(o).ClearSelection
  else if o is TRichEdit then
    TRichEdit(o).ClearSelection
      {$IFDEF VS_EDITOR}
  else if o is TSynEdit then
    TSynEdit(o).ClearSelection
      {$ENDIF}
  ;
end;

procedure TphpMOD._TSynEditFunctions22Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TEdit then
    TEdit(o).Undo
  else if o is TMemo then
    TMemo(o).Undo
  else if o is TRichEdit then
    TRichEdit(o).Undo
      {$IFDEF VS_EDITOR}
  else if o is TSynEdit then
    TSynEdit(o).Undo
      {$ENDIF}
  ;
end;

procedure TphpMOD._TSynEditFunctions23Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
{$IFDEF VS_EDITOR}
  o := ToObj(Parameters, 0);
  if o is TSynEdit then
    TSynEdit(o).Redo;
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions24Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  TSynEdit(ToObj(Parameters, 0)).Highlighter :=
    TSynCustomHighlighter(ToObj(Parameters, 0));
{$ENDIF}
end;

procedure TphpMOD._TSynEditFunctions25Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  TSynCompletionProposal(ToObj(Parameters, 0)).Editor :=
    TSynEdit(ToObj(Parameters, 0));
{$ENDIF}
end;

procedure TphpMOD._MenusFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TMainMenu then
    ReturnValue := integer(TMainMenu(o).Items.Find(Parameters[1].Value))
  else if o is TPopupMenu then
    ReturnValue := integer(TPopupMenu(o).Items.Find(Parameters[1].Value))
  else if o is TMenuItem then
    ReturnValue := integer(TMenuItem(o).Find(Parameters[1].Value));
end;

procedure TphpMOD._MenusFunctions14Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);

  if o is TMainMenu then
    TMainMenu(o).Items.Insert(Parameters[1].Value, TMenuItem(ToObj(Parameters, 2)))
  else if o is TPopupMenu then
    TPopupMenu(o).Items.Insert(Parameters[1].Value, TMenuItem(ToObj(Parameters, 2)))
  else if o is TMenuItem then
    TMenuItem(o).Insert(Parameters[1].Value, TMenuItem(ToObj(Parameters, 2)));

end;

procedure TphpMOD._MenusFunctions15Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TMenuItem then
    ReturnValue := TMenuItem(o).MenuIndex;
end;

procedure TphpMOD._MenusFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TMainMenu then
    ReturnValue := (TMainMenu(o).Items.IndexOf(TMenuItem(ToObj(Parameters, 1))))
  else if o is TPopupMenu then
    ReturnValue := TPopupMenu(o).Items.IndexOf(TMenuItem(ToObj(Parameters, 1)))
  else if o is TMenuItem then
    ReturnValue := TMenuItem(o).IndexOf(TMenuItem(ToObj(Parameters, 1)));
end;

procedure TphpMOD._MenusFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if o is TMenuItem then
    ReturnValue := integer(TMenuItem(o).Parent);

end;

procedure TphpMOD._ExeModFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  m: TMemoryStream;
begin
  m := TMemoryStream(ToObj(Parameters, 1));
  ExeM.ExtractToStream(Parameters[0].Value, m);
end;

procedure TphpMOD._ExeModFunctions9Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  m: TMemoryStream;
begin
  m := TMemoryStream(ToObj(Parameters, 1));
  ExeM.AddFromStream(Parameters[0].Value, m);
end;

procedure TphpMOD._TPictureLibFunctions19Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
  m: TStream;
begin
  o := ToObj(Parameters, 0);
  m := TStream(ToObj(Parameters, 1));

  if (o is TPicture) then
    TPicture(o).Graphic.SaveToStream(m)
  else if (o is Graphics.TBitmap) then
    Graphics.TBitmap(o).SaveToStream(m)
  else if (o is TIcon) then
    TIcon(o).SaveToStream(m);
end;

procedure TphpMOD._TPictureLibFunctions20Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  p: TPicture;
  b: Graphics.TBitmap;
begin
  P := TPicture.Create;
  b := Graphics.TBitmap(ToObj(Parameters, 1));
  b.Transparent := True;
  try
    P.LoadFromFile(Parameters[0].Value);

    b.Width := P.Graphic.Width + Parameters[2].Value * 2;
    ;
    b.Height := P.Graphic.Height + Parameters[2].Value * 2;
    ;
    b.Canvas.Draw(Parameters[2].Value, Parameters[2].Value, P.Graphic);

    // end;
  except
    {on e: Exception do
        ShowMessage(e.Message); }
  end;
  FreeAndNil(P);
end;

procedure TphpMOD._TPictureLibFunctions21Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  B: Graphics.TBitmap;
  S: TMemoryStream;
begin
  B := Graphics.TBitmap(ToObj(Parameters, 0));
  S := TMemoryStream.Create;
  try
    String2Stream(Parameters[1].ZendVariable.AsString, S);
    B.LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TphpMOD._TPictureLibFunctions22Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  B: Graphics.TBitmap;
  S: TMemoryStream;
  My: ansistring;
begin
  B := Graphics.TBitmap(ToObj(Parameters, 0));
  S := TMemoryStream.Create;
  try
    B.SaveToStream(S);
    Stream2String(S, My);
    ZendVar.AsString := My;
  finally
    S.Free;
  end;
end;

procedure TphpMOD._TPictureLibFunctions23Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  B: Graphics.TBitmap;
begin
  B := Graphics.TBitmap(ToObj(Parameters, 0));
  ReturnValue := integer(B.Canvas);
end;

procedure TphpMOD._TPictureLibFunctions24Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  B: Graphics.TBitmap;
begin
  B := Graphics.TBitmap(ToObj(Parameters, 0));
  B.SetSize(Parameters[1].ZendVariable.AsInteger, Parameters[2].ZendVariable.AsInteger);

end;

procedure TphpMOD._TPictureLibFunctions25Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  P: TPicture;
  format: ShortString;
  M: TMemoryStream;
  PNG: TPNGObject;
  JPG: TJPEGImage;
  GIF: TGIFImage;
begin
  P := TPicture(ToObj(Parameters, 0));
  M := TMemoryStream.Create;
  String2Stream(Parameters[1].ZendVariable.AsString, M);
  format := AnsiLowerCase(Parameters[2].ZendVariable.AsString);

  if (format = 'png') then
  begin
    PNG := TPNGObject.Create;
    with PNG do
    begin
      LoadFromStream(M);
      P.Assign(PNG);
    end;
    PNG.Free;
  end
  else if ((format = 'jpeg') or (format = 'jpg')) then
  begin
    JPG := TJPEGImage.Create;
    with JPG do
    begin
      LoadFromStream(M);
      P.Assign(JPG);
    end;
    JPG.Free;
  end
  else if (format = 'gif') then
  begin
    GIF := TGIFImage.Create;
    with GIF do
    begin
      LoadFromStream(M);
      P.Assign(GIF);
    end;
    GIF.Free;
  end
  else if (format = 'ico') then
    P.Icon.LoadFromStream(M)
  else if (format = 'bmp') then
    P.Bitmap.LoadFromStream(M);

  M.Free;
end;

procedure TphpMOD._TPictureLibFunctions26Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  bmp: Graphics.TBitmap;
  DC: HDC;
  M: TMemoryStream;
begin
  bmp := Graphics.TBitmap.Create;
  bmp.Height := Parameters[2].ZendVariable.AsInteger;
  bmp.Width := Parameters[3].ZendVariable.AsInteger;

  DC := GetDC(0);  //дескриптор экрана
  BitBlt(bmp.Canvas.Handle, Parameters[0].ZendVariable.AsInteger,
    Parameters[1].ZendVariable.AsInteger,
    Parameters[2].ZendVariable.AsInteger,
    Parameters[3].ZendVariable.AsInteger,
    DC, 0, 0, SRCCOPY);

  M := TMemoryStream.Create;
  bmp.SaveToStream(M);
  ZendVar.AsString := Stream2String(M);

  M.Free;
  bmp.Free;
  ReleaseDC(0, DC);
end;

procedure TphpMOD._TPictureLibFunctions27Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  jpg: TJPEGImage;
  bmp: Graphics.TBitmap;
  M: TMemoryStream;
begin
  bmp := Graphics.TBitmap.Create;
  M := TMemoryStream.Create;
  String2Stream(Parameters[0].ZendVariable.AsString, M);

  jpg := TJPEGImage.Create;
  case Parameters[1].ZendVariable.AsInteger of
    0: jpg.PixelFormat := jf8Bit;
    1: jpg.PixelFormat := jf24Bit;
  end;


  jpg.CompressionQuality := Parameters[2].ZendVariable.AsInteger;
  jpg.Assign(bmp);

  M.Clear;
  bmp.Free;
  M.Position := 0;
  JPG.SaveToStream(M);
  M.Position := 0;
  ZendVar.AsString := Stream2String(M);
  M.Free;
  JPG.Free;
end;

procedure TphpMOD._TStreamLibFunctions21Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TMemoryStream(ToObj(Parameters, 0)).LoadFromFile(Parameters[1].Value);
end;

procedure TphpMOD._TStreamLibFunctions22Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TMemoryStream(ToObj(Parameters, 0)).SaveToFile(Parameters[1].Value);
end;

procedure TphpMOD._TStreamLibFunctions23Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  m: TStream;
begin
  m := TStream(ToObj(Parameters, 1));
  TMemoryStream(ToObj(Parameters, 0)).LoadFromStream(m);
end;

procedure TphpMOD._TStreamLibFunctions24Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  m: TStream;
begin
  m := TStream(ToObj(Parameters, 1));
  TMemoryStream(ToObj(Parameters, 0)).SaveToStream(m);
end;


procedure TphpMOD._TTreeFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  b: TMemoryStream;
begin
  b := TMemoryStream.Create;
  String2Stream(Parameters[1].Value, b);
  TTreeView(ToObj(Parameters, 0)).LoadFromStream(b);
  b.Free;
end;

procedure TphpMOD._TTreeFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  b: TMemoryStream;
begin
  b := TMemoryStream.Create;
  TTreeView(ToObj(Parameters, 0)).SaveToStream(b);
  ReturnValue := Stream2String(b);
  b.Free;
end;

procedure TphpMOD._TTreeFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if TTreeView(ToObj(Parameters, 0)).Selected = nil then
    ReturnValue := null
  else
    ReturnValue := integer(TTreeView(ToObj(Parameters, 0)).Selected);
end;

procedure TphpMOD._TTreeFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TTreeView(ToObj(Parameters, 0)).Select(TTreeNode(ToObj(Parameters, 1)));
end;

procedure TphpMOD.PHPLibraryFunctions58Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);

begin
  if Parameters[0].Value = 'DevelStudio' then
    ShowMessage('Все авторские права на программу DevelStudio'
      + #13 + 'пренадлежат:' + #13 + #13 +
      'Ф.И.О.: Зайцев Дмитрий Геннадьевич' + #13 +
      'Год рождения: 19 сентября 1989 год' + #13 +
      'Город рождения: Ташкент (Узбекистан)'
      )
  else if Parameters[0].Value = 'SoulEngine' then
    ShowMessage('Все авторские права на программу SoulEngine'
      + #13 + 'пренадлежат:' + #13 + #13 +
      'Ф.И.О.: Зайцев Дмитрий Геннадьевич' + #13 +
      'Год рождения: 19 сентября 1989 год' + #13 +
      'Город рождения: Ташкент (Узбекистан)'
      );
end;

procedure TphpMOD._TTreeFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TTreeNode(ToObj(Parameters, 0)).AbsoluteIndex;
end;

procedure TphpMOD._TTreeFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TTreeView(ToObj(Parameters, 0)).FullExpand;
end;

procedure TphpMOD._TTreeFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TTreeView(ToObj(Parameters, 0)).FullCollapse;
end;

procedure TphpMOD._TTreeFunctions7Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  t: TTreeView;
  i: integer;
begin
  t := TTreeView(ToObj(Parameters, 0));

  for i := 0 to t.Items.Count - 1 do
    if (t.Items[i].AbsoluteIndex = Parameters[1].Value) then
    begin
      t.Select(t.Items[i]);
      ReturnValue := True;
      exit;
    end;

  ReturnValue := False;
end;

procedure TphpMOD._TTreeFunctions8Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  t: TTreeView;
begin
  t := TTreeView(ToObj(Parameters, 0));
  ZendVar.AsInteger := integer(t.Items);
end;

procedure TphpMOD.OSApiFunctions26Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := SendMessage(Parameters[0].Value, Parameters[1].Value,
    Parameters[2].Value, Parameters[3].Value);
end;

procedure TphpMOD.OSApiFunctions27Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := SetCurrentDir(StringReplace('/', '\', Parameters[0].Value, []));
end;

procedure TphpMOD.OSApiFunctions28Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ExistsTask(Parameters[0].Value);
end;

procedure TphpMOD.OSApiFunctions29Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  SetClipboardText(Application.Handle, Parameters[0].Value);
end;

procedure TphpMOD.libDialogsFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  if (o is TFindDialog) then
    TFindDialog(o).CloseDialog
  else if (o is TReplaceDialog) then
    TReplaceDialog(o).CloseDialog;
end;

procedure TphpMOD._BackWorkerFunctions10Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  //ReturnValue := phpThreads.runCode(Parameters[0].ZendVariable.AsString);
end;

procedure TphpMOD._BackWorkerFunctions11Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  try
    ReturnValue := True;
    //TPHPThread( Parameters[0].ZendVariable.AsInteger ).Start;
  except
    ReturnValue := False;
    {  on e: Exception do
        ShowMessage(e.Message);}
  end;
end;

procedure TphpMOD._BackWorkerFunctions12Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
    {TPHPThread( Parameters[0].ZendVariable.AsInteger ).Code :=
        Parameters[1].ZendVariable.AsString;   }
end;

procedure TphpMOD._BackWorkerFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  // TPHPThread( Parameters[0].ZendVariable.AsInteger ).Stop;
end;

procedure TphpMOD._BackWorkerFunctions14Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  // TPHPThread( Parameters[0].ZendVariable.AsInteger ).Terminate;
end;

procedure TphpMOD._BackWorkerFunctions15Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
 {if Parameters[1].Value = Null then
    ReturnValue := TPHPThread( Parameters[0].ZendVariable.AsInteger ).Priority
  else
    TPHPThread( Parameters[0].ZendVariable.AsInteger ).Priority :=
        Parameters[1].ZendVariable.AsVariant;   }
end;

procedure TphpMOD._BackWorkerFunctions16Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  //TPHPThread( Parameters[0].ZendVariable.AsInteger ).Run;
end;


procedure TphpMOD._BackWorkerFunctions17Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  // ReturnValue := TPHPThread( Parameters[0].ZendVariable.AsInteger ).working;
end;

procedure TphpMOD._BackWorkerFunctions18Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  {  TPHPThread( Parameters[0].ZendVariable.AsInteger ).Suspend;
    TPHPThread( Parameters[0].ZendVariable.AsInteger ).working := false; }
end;

procedure TphpMOD._BackWorkerFunctions19Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
   { TPHPThread( Parameters[0].ZendVariable.AsInteger ).Resume;
    TPHPThread( Parameters[0].ZendVariable.AsInteger ).working := true;}
end;

procedure TphpMOD._BackWorkerFunctions20Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  // TPHPThread( Parameters[0].ZendVariable.AsInteger ).TerminateAndWaitFor;
end;

procedure TphpMOD._BackWorkerFunctions21Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  // TPHPThread( Parameters[0].ZendVariable.AsInteger ).Free;
end;

var
  ThreadList: TStringList;
  ThreadValue: TStringList;

procedure TphpMOD._BackWorkerFunctions22Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  id: integer;
  Name: string;
  Value: string;
begin

  if ThreadList = nil then
  begin
    ThreadList := TStringList.Create;
    ThreadValue := TStringList.Create;
  end;

  Name := Parameters[0].ZendVariable.AsString;
  id := ThreadList.IndexOf(Name);

  if Parameters[1].Value = null then
  begin

    if id = -1 then
    begin
      ReturnValue := null;
    end
    else
    begin
      ZendVar.AsString := ThreadValue[id];
    end;
  end
  else
  begin
    Value := Parameters[1].ZendVariable.AsString;
    if id = -1 then
    begin

      ThreadList.Add(Name);
      ThreadValue.Add(Value);
    end
    else
      ThreadValue[id] := Value;
  end;

end;

procedure TphpMOD.ThreadEval(const Name: ansistring; PHP: TpsvPHP = nil;
  TSRMLS_DC: Pointer = nil);
var
  id: integer;
  Value: string;
begin
  if ThreadList = nil then
  begin
    ThreadList := TStringList.Create;
    ThreadValue := TStringList.Create;
  end;

  id := ThreadList.IndexOf(Name);

  if id = -1 then

  else
  begin
    Value := ThreadValue[id];
    Value := (Value);

    if PHP <> nil then
    begin
      PHP.RunCode(Value);
    end
    else
    begin

      if Pos('<?', Value) = 1 then
        Value := Copy(Value, 3, Length(Value) - 2);

      zend_eval_string(PAnsiChar(Value), nil, '', TSRMLS_DC);
      //RunCode( myDecode( value ) );
    end;
    Value := '';
  end;
end;

procedure TphpMOD._BackWorkerFunctions23Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  Name: string;
begin
  Name := Parameters[0].ZendVariable.AsString;
  threadEval(Name, nil, TSRMLS_DC);
end;

procedure TphpMOD._BackWorkerFunctions24Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  //TUniPHPThread.Create( Parameters[0].ZendVariable.AsString, TSRMLS_DC  );
end;

procedure TphpMOD.PHPLibraryFunctions59Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  s: string;
begin
  Parameters[0].Value := StringReplace(Parameters[0].Value, '/', '\', [rfReplaceAll]);
  s := (Base64_Decode(File2String(Parameters[0].Value)));
  RunCode(s);
end;

procedure TphpMOD._TSizeCtrlFunctions13Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TSizeCtrl(ToObj(Parameters, 0)).UpdateBtns;
end;

procedure TphpMOD.PHPLibraryFunctions60Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TNonVisual(ToObj(Parameters, 0)).loadFromFile(Parameters[1].Value);
end;

procedure TphpMOD.PHPLibraryFunctions61Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TNonVisual(ToObj(Parameters, 0)).Clear;
end;

procedure TphpMOD.PHPLibraryFunctions64Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[1].Value = '!#$@$23' then
    ReturnValue := Base64_Encode(Parameters[0].Value)
  else
    ReturnValue := Parameters[0].Value;
end;

procedure TphpMOD.PHPLibraryFunctions65Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  if Parameters[1].Value = '!$$@!#!5' then
    ReturnValue := Base64_Decode(Parameters[0].Value)
  else
    ReturnValue := Parameters[0].Value;
end;

procedure TphpMOD.PHPLibraryFunctions66Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := TimeToStr(Parameters[0].Value);
end;

procedure TphpMOD.PHPLibraryFunctions67Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := StrToDateTime(Parameters[0].Value);
end;

procedure TphpMOD.PHPLibraryFunctions68Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  fatal_handler_php := Parameters[0].ZendVariable.AsString;
end;

procedure TphpMOD._TStringsLibFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TStringList(ToObj(Parameters, 0)).Clear;
end;

procedure TphpMOD._TStringsLibFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TStringList(ToObj(Parameters, 0)).LoadFromFile(Parameters[1].Value);
end;

procedure TphpMOD._TStringsLibFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
var
  o: TObject;
begin
  o := ToObj(Parameters, 0);
  TStringList(o)[Parameters[1].Value] := Parameters[2].Value;
end;

end.
