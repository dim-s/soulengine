unit uMain;

{$I 'sDef.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PHPCustomLibrary, phpLibrary, php4delphi, PHPCommon,
  phpFunctions, ZENDTypes, zendAPI, uPhpEvents,
  ExtCtrls, Menus, ComCtrls, Buttons, ToolWin, SizeControl, ExeMod,
  AppEvnts, MD5, XPMan, phpAPI, Clipbrd,
  core;

function TempDir: string;

type
  T__fMain = class(TForm)
    b_Run: TButton;
    Button1: TButton;
    b_Restart: TButton;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Script1: TMenuItem;
    Open1: TMenuItem;
    Save: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Run1: TMenuItem;
    N2: TMenuItem;
    Examples1: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    Restart: TMenuItem;
    OpenDialog: TOpenDialog;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    lkjk1: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    Memo1: TMemo;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure b_RunClick(Sender: TObject);
    procedure PHPLibraryFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure FormShow(Sender: TObject);
    procedure b_RestartClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Open1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure loadEngine(DLLFolder: string = '');
    class procedure extractPHPEngine(EM: TExeStream);
  end;

var
  __fMain: T__fMain;
  appShow: boolean;

implementation

uses uPHPMod, uMainForm;

{$R *.dfm}

procedure T__fMain.b_RestartClick(Sender: TObject);
begin
  if not selfEnabled then
  begin
    phpMOD.psvPHP.ShutdownRequest;
    phpMOD.PHPEngine.ShutdownEngine;
    T__fMain.loadEngine();
  end;
end;

procedure T__fMain.b_RunClick(Sender: TObject);
begin
  if not selfEnabled then
  begin
    phpMOD.psvPHP.UseDelimiters := False;
    phpMOD.RunCode(Memo1.Lines.Text);
    phpMOD.psvPHP.UseDelimiters := True;
  end;
end;

procedure T__fMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //  SaveClick(nil);
end;

procedure T__fMain.FormShow(Sender: TObject);
begin
  if not selfEnabled and FileExists('code.php') then
    Memo1.Lines.LoadFromFile('code.php');
end;

function myMD5(selfScript: string): string;
begin
  Result := xMD5(selfScript);
end;


class procedure T__fMain.loadEngine(DLLFolder: string = '');

  function FindFileSize(Filename: string): integer;
  var
    sr: TSearchRec;
  begin
    if FindFirst(filename, faAnyFile - faDirectory, sr) = 0 then
      Result := sr.Size
    else
      Result := -1;
    FindClose(sr);
  end;

begin
  // PHPEngine.AddFunction('my_call', @ex_dec);
  // InitializeEventSystem( PHPEngine );

  if (ParamStr(2) = '-errors') then
  begin
    PHPEngine.HandleErrors := True;
  end
  else
    PHPEngine.HandleErrors := True;

  //phpMOD.RunFile(engineDir+'include.php');
  if (DLLFolder = '') then
    DLLFolder := ExtractFilePath(ParamStr(0));

  PHPEngine.DLLFolder := DLLFolder;

  if FileExists(engineDir + '\php.ini') then
    PHPEngine.IniPath := engineDir + '\php.ini'
  else if FileExists(iniDir + '\php.ini') then
    PHPEngine.IniPath := iniDir
  else if FileExists(progDir + '\php.ini') then
    PHPEngine.IniPath := progDir
  else
    PHPEngine.IniPath := PHPEngine.DLLFolder;

  //  FS := TFileStream.Create(PHPEngine.IniPath, fmOpenRead, fmShareDenyWrite);

  if selfEnabled and (selfPHP5tsSize <> Trunc((FindFileSize('php5ts.dll') * 3) / 4)) then
  begin
    Application.Terminate;
    exit;
  end;


  core_Init(PHPEngine, phpMOD.psvPHP);
  //PHPEngine.StartupEngine;

  addVar('progDir', progDir);
  addVar('moduleDir', moduleDir);
  addVar('engineDir', engineDir);

  if (FileExists(engineDir + 'include.php')) and (not selfEnabled) then
    phpMOD.RunFile(engineDir + 'include.php');
end;

function TempDir: string;
var
  Buffer: array[0..1023] of char;
begin
  SetString(Result, Buffer, GetTempPath(Sizeof(Buffer) - 1, Buffer));
end;

class procedure T__fMain.extractPHPEngine(EM: TExeStream);

var
  dir, INI, HASH: string;
  PHP5tsExists: boolean;
  t: integer;
label
  1;
begin
  INI := EM.ExtractToString('$PHPSOULENGINE\phpini');
  HASH := EM.ExtractToString('$PHPSOULENGINE\phpini.hash');

  if (INI <> '') then
  begin
    if (myMD5(INI) <> HASH) then
      halt;

    dir := TempDir + '\PSE30\';
    iniDir := dir + xMD5(exe) + '\';

    if FileExists(iniDir + 'php.ini') then
    begin
      if (File2String(iniDir + 'php.ini') = INI) then
        goto 1;
    end;

    ForceDirectories(iniDir);
    String2File(INI, iniDir + 'php.ini');
    //TFileStream.Create(iniDir + 'php.ini', fmOpenRead, fmShareDenyWrite);
  end;

  1: ;
   (*EM.ExtractToList('$PHPENGINE',l);
   mDir := EM.ExtractToString('$PHP_MODULEDIR');

   PHP5tsExists := false;
   mDir := StringReplace(mDir,'{pse}',dir,[rfIgnoreCase]);
   mDir := StringReplace(mDir,'{progdir}',progDir,[rfIgnoreCase]);
   mDir := StringReplace(mDir,'{temp}',TempDir,[rfIgnoreCase]);

   if L.Count = 0 then begin
        dllPHPPath := progDir;
        //dllPHPPath := dir + '';
        moduleDir  := progDir + '\php\modules\';
   end else begin
        dllPHPPath := dir + '';
        moduleDir  := dir + 'php\modules\';

        for i:=0 to l.Count-1 do begin
                f := l[i];
                f := StringReplace(f,'/','\',[rfReplaceAll]);

                if f = '\php5ts.dll' then
                  PHP5tsExists := true;


                if (not FileExists(dir + 'php\' + f)) or (f='\php.ini') then
                begin

                   if f = '\php.ini' then begin

                     String2File(  StringReplace(EM.ExtractToString('$PSE'+l[i]),
                                        '.\php\modules\', mDir, [rfReplaceAll]),
                                    iniDir + f   );
                   end else
                   begin
                    EM.ExtractToFile('$PSE' + l[i],
                       StringReplace(dir + 'php\' + f,'\\','\',[rfReplaceAll]));
                   end;
                end;
        end;

        if not PHP5tsExists then
          dllPHPPath := '';
   end;      *)

  //ShowMessage(IntToStr(GetTickCount-t));
end;

procedure T__fMain.Open1Click(Sender: TObject);
begin
  if not OpenDialog.Execute then
    exit;

  Memo1.Lines.LoadFromFile(OpenDialog.FileName);
end;

procedure T__fMain.PHPLibraryFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  with phpMod.Variables.Add do
  begin
    Name := Parameters[0].Value;
    Value := Parameters[1].Value;
  end;
end;

procedure T__fMain.SaveClick(Sender: TObject);
begin
  Memo1.Lines.SaveToFile('code.php');
end;

procedure T__fMain.Timer1Timer(Sender: TObject);
begin
  Application.Terminate;
end;


function DebuggerPresent: boolean;
type
  TDebugProc = function: boolean; stdcall;
var
  Kernel32: HMODULE;
  DebugProc: TDebugProc;
begin
  Result := False;
  Kernel32 := GetModuleHandle('kernel32.dll');
  if Kernel32 <> 0 then
  begin
    @DebugProc := GetProcAddress(Kernel32, 'IsDebuggerPresent');
    if Assigned(DebugProc) then
      Result := DebugProc;
  end;
end;

procedure T__fMain.Timer2Timer(Sender: TObject);
begin
{$IFDEF NO_DEBUG}
  if DebuggerPresent then
  begin
    Timer1.interval := random(10000) + 3000;
    Timer1.Enabled := True;
  end;
{$ENDIF}
end;


{
initialization
  ReportMemoryLeaksOnShutdown := True; }

end.
