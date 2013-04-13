unit uMainForm;

interface

{.$DEFINE LOAD_DS}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExeMod, EncdDecd, MD5, Utils;

function Base64_Decode(cStr: ansistring): ansistring;
function Base64_Encode(cStr: ansistring): ansistring;

type
  T__mainForm = class(TForm)
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure WMHotKey(var Msg: TMessage); message WM_HOTKEY;
    procedure ReceiveMessage(var Msg: TMessage); message WM_COPYDATA;
  end;

var
  __mainForm: T__mainForm;
  selfScript: string = '';
  selfMD5Hash: string;
  selfEnabled: boolean = False;
  dllPHPPath: string = '';

  selfModules: TStringList;
  selfModulesMD5: TStringList;
  selfModulesHash: string;

  selfPHP5tsMD5: string;
  selfPHP5tsSize: integer;

implementation

uses uMain, uPHPMod;

{$R *.dfm}


function Base64_Decode(cStr: ansistring): ansistring;
const
  Base64Table =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

var
  ResStr: ansistring;

  DecStr: ansistring;
  RecodeLine: array[1..76] of byte;
  f1: word;
  l: integer;
begin
  Result := DecodeString(cStr);
  exit;
  l := length(cStr);
  ResStr := '';
  for f1 := 1 to l do
    if cStr[f1] = '=' then
      RecodeLine[f1] := 0
    else
      RecodeLine[f1] := pos(cStr[f1], Base64Table) - 1;
  f1 := 1;
  while f1 < length(cStr) do
  begin
    DecStr := chr(byte(RecodeLine[f1] shl 2) + RecodeLine[f1 + 1] shr 4) +
      chr(byte(RecodeLine[f1 + 1] shl 4) + RecodeLine[f1 + 2] shr 2) +
      chr(byte(RecodeLine[f1 + 2] shl 6) + RecodeLine[f1 + 3]);
    ResStr := ResStr + DecStr;
    Inc(f1, 4);
  end;
  Result := ResStr;
end;

function Base64_Encode(cStr: ansistring): ansistring;
begin
  Result := EncodeString(cStr);
  __mainForm.BringToFront;
end;


procedure T__mainForm.FormActivate(Sender: TObject);
var
  f, s: string;
begin
  if appShow then
    exit;

  appShow := True;

  {$IFDEF LOAD_DS}
  f := ExtractFilePath(ParamStr(0)) + 'system\include.pse';
  {$ELSE}
  f := ParamStr(1);
  {$ENDIF}


  if selfEnabled then
  begin

    if (xMD5(selfScript) = selfMD5Hash) then
    begin
      __fMain.Button1.Destroy;
      __fMain.MainMenu.Destroy;
      __fMain.b_Restart.Destroy;
      __fMain.b_Run.Destroy;
      __fMain.Memo1.Destroy;
      __fMain.Width := 0;
      __fMain.Height := 0;
      __fMain.BorderStyle := bsNone;


      phpMOD.RunCode(selfScript);
      selfEnabled := True;

      appShow := True;
      //__fMain.Destroy;
    end;
  end
  else if ExtractFileExt(f) = '.pse' then
  begin
    s := File2String(f);
    phpMOD.RunCode(s);
  end
  else if ParamStr(1) <> '-run' then
  begin
    uPHPMod.SetAsMainForm(__fMain);
    Application.ShowMainForm := True;
    Application.MainFormOnTaskBar := True;
  end
  else
    phpMOD.RunFile(ParamStr(2));

  appShow := True;
end;

procedure T__mainForm.FormCreate(Sender: TObject);
var
  f: string;
  EM: TExeStream;
begin

  Self.Left := -999;
  {$IFDEF LOAD_DS}
  f := ExtractFilePath(ParamStr(0)) + 'system\include.pse';
  {$ELSE}
  f := ParamStr(1);
  {$ENDIF}

  selfScript := '';
  EM := TExeStream.Create(ParamStr(0));

  progDir := ExtractFilePath(Application.ExeName);
  moduleDir := progDir + 'ext\';
  engineDir := progDir + 'engine\';
  if DirectoryExists(progDir + 'core\') then
    engineDir := progDir + 'core\';


  selfScript := EM.ExtractToString('$PHPSOULENGINE\inc.php');
  selfMD5Hash := EM.ExtractToString('$PHPSOULENGINE\inc.php.hash');
  if (selfScript <> '') then
  begin
    //selfScript := myDecode(Base64_Decode(selfScript));
    selfModulesHash := EM.ExtractToString('$PHPSOULENGINE\mods.hash');

    if (xMD5(EM.ExtractToString('$PHPSOULENGINE\mods')) <>
      selfModulesHash) then
    begin
      selfMD5Hash := '';
      selfScript := '';
      selfEnabled := True;
      exit;
    end;


    selfModules := TStringList.Create;
    selfModules.Text :=
      StringReplace(EM.ExtractToString('$PHPSOULENGINE\mods'), ',',
      #13, [rfReplaceAll]);

    selfModulesMD5 := TStringList.Create;
    selfModulesMD5.Text :=
      StringReplace(EM.ExtractToString('$PHPSOULENGINE\mods_m'),
      ',', #13, [rfReplaceAll]);


    selfPHP5tsMD5 := EM.ExtractToString('$PHPSOULENGINE\phpts.hash');
    selfPHP5tsSize := StrToIntDef(EM.ExtractToString('$PHPSOULENGINE\phpts.size'), -1);

    selfEnabled := True;
    T__fMain.extractPHPEngine(EM);
  end;


  if (ExtractFileExt(f) = '.pse') and (selfScript = '') then
  begin
    if Pos(':', F) > 0 then
      progDir := ExtractFilePath(f)
    else
      progDir := progDir + ExtractFilePath(f);
  end
  else if selfScript <> '' then
    progDir := ExtractFilePath(ParamStr(0))
  else if f <> '' then
    progDir := ExtractFilePath(f);
end;

procedure T__mainForm.ReceiveMessage(var Msg: TMessage);
var
  pcd: PCopyDataStruct;
  s: ansistring;
begin
  pcd := PCopyDataStruct(Msg.LParam);
  s := PChar(pcd.lpData);

  phpMOD.RunCode('Receiver::event(' + IntToStr(Msg.WParam) + ',''' +
    AddSlashes(s) + ''');');
end;

procedure T__mainForm.WMHotKey(var Msg: TMessage);
var
  idHotKey: integer;
  fuModifiers: word;
  uVirtKey: word; 
begin
  idHotkey := Msg.wParam;
  fuModifiers := LOWORD(Msg.lParam);
  uVirtKey := HIWORD(Msg.lParam);

  phpMOD.RunCode('HotKey::event(' + IntToStr(fuModifiers) + ',' +
    IntToStr(uVirtKey) + ');');

  inherited;
end;


end.
