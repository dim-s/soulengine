{*******************************************************}
{                     PHP4Delphi                        }
{           PHP4Delphi components registration          }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{*******************************************************}
{$I PHP.INC}

{ $Id: php4DelphiReg.pas,v 7.2 10/2009 delphi32 Exp $ }

unit php4DelphiReg;

interface
uses
  Windows, SysUtils, Classes, Dialogs, Forms,
  PHPCommon,
  {$IFDEF VERSION6}
  DesignIntf,
  DesignEditors,
  ToolsAPI,
  {$ELSE}
  dsgnintf,
  {$ENDIF}
  Graphics,
  ShlObj,
  ZendAPI, PHPAPI,
  PHP4Delphi, phpAbout, phpModules, phpLibrary, ShellAPI,
  phpClass,
  phpCustomLibrary;

type
  TScriptFileProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TINIFolderProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TpsvPHPEditor = class(TDefaultEditor)
  public
   {$IFDEF VERSION6}
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    {$ELSE}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: boolean); override;
    {$ENDIF}
    procedure ExecuteVerb(Index: integer); override;
    function GetVerb(Index: integer): string; override;
    function GetVerbCount: integer; override;
    procedure Edit; override;
  end;

{$IFDEF VERSION10}
procedure RegisterSplashScreen;
{$ENDIF}

procedure Register;

implementation

{$R php4DelphiSplash.res}

{$IFDEF VERSION11}
{$R php4delphi.dcr}
{$ENDIF}

{$IFDEF VERSION10}
procedure RegisterSplashScreen;
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  Bmp.LoadFromResourceName( HInstance, 'PHPDELPHIL' );
  try
    SplashScreenServices.AddPluginBitmap('php4Delphi version 7.2',
                                          Bmp.Handle, False, 'Registered', '' );
  finally
    Bmp.Free;
  end;

end;

{$ENDIF}

procedure Register;
begin
  {$IFDEF VERSION10}
  RegisterSplashScreen;
  {$ENDIF}
  RegisterComponents('PHP', [TPHPEngine]);
  RegisterComponents('PHP', [TpsvPHP]);
  RegisterComponents('PHP', [TPHPLibrary]);
  RegisterComponents('PHP', [TPHPClass]);
  RegisterComponents('PHP', [TPHPSystemLibrary]);
  RegisterPropertyEditor(TypeInfo(String), TpsvPHP, 'FileName', TScriptFileProperty);
  RegisterPropertyEditor(TypeInfo(TPHPAboutInfo), TPHPComponent, 'About', TPHPVersionEditor);
  RegisterPropertyEditor(TypeInfo(TPHPAboutInfo), TCustomPHPExtension, 'About', TphpVersionEditor);
  RegisterComponentEditor(TPHPExtension, TpsvPHPEditor);
  RegisterComponentEditor(TPHPLibrary, TpsvPHPEditor);
end;


procedure TScriptFileProperty.Edit;
var
  MPFileOpen: TOpenDialog;
begin
  MPFileOpen := TOpenDialog.Create(Application);
  MPFileOpen.Filename := GetValue;
  MPFileOpen.Filter := 'PHP Script (*.php)|*.php';
  MPFileOpen.Options := MPFileOpen.Options + [ofPathMustExist,
    ofFileMustExist];
  try
    if MPFileOpen.Execute then SetValue(MPFileOpen.Filename);
  finally
    MPFileOpen.Free;
  end;
end;

function TScriptFileProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

{$IFDEF VERSION6}
procedure TpsvPHPEditor.EditProperty(const Prop: IProperty; var Continue: Boolean);
var
  PropName: string;
begin
  PropName := Prop.GetName;
  if (CompareText(PropName, 'FUNCTIONS') = 0) then
  begin
    Prop.Edit;
    Continue := False;
  end;
end;

{$ELSE}
procedure TpsvPHPEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue,
  FreeEditor: boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'FUNCTIONS') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;
{$ENDIF}

procedure TpsvPHPEditor.Edit;
begin
  inherited;
end;

procedure TpsvPHPEditor.ExecuteVerb(Index: integer);
begin
    case Index of
      0:
        begin
          Edit;
          Designer.Modified;
        end;
      1: ShellExecute(0, 'open', 'http://www.php.net', nil, nil, SW_SHOW);
      2: ShellExecute(0, 'open', 'http://users.telenet.be/ws36637', nil, nil, SW_SHOW);
    end;
end;

function TpsvPHPEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Edit PHP Functions...';
    1: Result := 'PHP Home Page';
    2: Result := 'PHP4Delphi Home Page';
  end;
end;

function TpsvPHPEditor.GetVerbCount: integer;
begin
  Result := 3;
end;

{ TINIFolderProperty }

procedure TINIFolderProperty.Edit;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ItemSelected : PItemIDList;
  NameBuffer: array[0..MAX_PATH] of Char;
  WindowList: Pointer;
begin
  itemIDList := nil;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  BrowseInfo.hwndOwner := Forms.Application.Handle;
  BrowseInfo.pidlRoot := ItemIDList;
  BrowseInfo.pszDisplayName := NameBuffer;
  BrowseInfo.lpszTitle := 'Select folder';
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  WindowList := DisableTaskWindows(0);
  try
    ItemSelected := SHBrowseForFolder(BrowseInfo);
  finally
    EnableTaskWindows(WindowList);
  end;
  if (ItemSelected <> nil) then
   begin
    SHGetPathFromIDList(ItemSelected,NameBuffer);
    SetValue(NameBuffer);
   end;
end;

function TINIFolderProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

end.