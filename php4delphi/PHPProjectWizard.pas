{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
{$I PHP.INC}

{ $Id: PHPProjectWizard.pas,v 7.2 10/2009 delphi32 Exp $ } 

unit PHPProjectWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolsAPI,
  {$IFDEF VERSION6}
  DesignIntf,
  DesignEditors,
  DMForm,
  {$ELSE}
  dsgnintf,
  dmdesigner,
  {$ENDIF}
  PHPModules;

type
  TPHPProjectWizard = class(TNotifierObject,  IOTAWizard,
   {$IFDEF VERSION10}IOTAREpositoryWizard, IOTARepositoryWizard60,
   IOTARepositoryWizard80, {$ELSE}IOTARepositoryWizard, {$ENDIF} IOTAProjectWizard)
  public
    // IOTAWizard
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
    // IOTARepositoryWizard
    function GetAuthor: string;
    function GetComment: string;
    function GetPage: string;
    {$IFDEF VERSION10}
    function GetGalleryCategory: IOTAGalleryCategory;
    function GetPersonality: string;
    function GetDesigner: string;
    {$ENDIF}
    {$IFDEF VERSION6}
    function GetGlyph : cardinal;
    {$ELSE}
    function GetGlyph: HICON;
    {$ENDIF}
  end;

  TPHPProjectCreator = class(TInterfacedObject, IOTACreator, IOTAProjectCreator {$IFDEF VERSION9},IOTAProjectCreator80{$ENDIF})
  public
    // IOTACreator
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
    // IOTAProjectCreator
    function GetFileName: string;
    function GetOptionFileName: string;
    function GetShowSource: Boolean;
    procedure NewDefaultModule;
    function NewOptionSource(const ProjectName: string): IOTAFile;
    procedure NewProjectResource(const Project: IOTAProject);
    function NewProjectSource(const ProjectName: string): IOTAFile;
    {$IFDEF VERSION9}
    function GetProjectPersonality: string;
    procedure NewDefaultProjectModule(const Project: IOTAProject);
    {$ENDIF}
  end;

  TPHPProjectSourceFile = class(TInterfacedObject, IOTAFile)
  private
    FSource: string;
    FProjectName : string;
  public
    function GetSource: string;
    function GetAge: TDateTime;
    constructor Create(const Source: string);
    constructor CreateNamedProject(AProjectName : string);
  end;


  TPHPModuleCreator = class(TInterfacedObject, IOTACreator, IOTAModuleCreator)
  public
    // IOTACreator
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
    // IOTAModuleCreator
    function GetAncestorName: string;
    function GetImplFileName: string;
    function GetIntfFileName: string;
    function GetFormName: string;
    function GetMainForm: Boolean;
    function GetShowForm: Boolean;
    function GetShowSource: Boolean;
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    procedure FormCreated(const FormEditor: IOTAFormEditor);
  end;


  TPHPExtensionSourceFile = class(TInterfacedObject, IOTAFile)
  private
    FSource: string;
  public
    function GetSource: string;
    function GetAge: TDateTime;
    constructor Create(const Source: string);
  end;

procedure Register;

implementation

{$R PHPProjectwizard.RES}

const
 CRLF = #13#10;

procedure Register;
begin
  RegisterPackageWizard(TPHPProjectWizard.Create);
end;


function GetActiveProjectGroup: IOTAProjectGroup;
var
  ModuleServices: IOTAModuleServices;
  i: Integer;

begin
  Result := nil;
  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  for i := 0 to ModuleServices.ModuleCount - 1 do
    if Succeeded(ModuleServices.Modules[i].QueryInterface(IOTAProjectGroup, Result)) then
      Break;
end;


{ TPHPProjectWizard }

{$IFDEF VERSION10}
function TPHPProjectWizard.GetGalleryCategory: IOTAGalleryCategory;
begin
  Result := (BorlandIDEServices as IOTAGalleryCategoryManager).FindCategory(sCategoryDelphiNew);
end;

function TPHPProjectWizard.GetPersonality: string;
begin
  Result := sDelphiPersonality;
end;

function TPHPProjectWizard.GetDesigner : string;
begin
  Result := dVCL;
end;

{$ENDIF}

procedure TPHPProjectWizard.Execute;

begin
  try
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TPHPProjectCreator.Create as {$IFDEF VERSION9}IOTAProjectCreator80{$ELSE}IOTAProjectCreator{$ENDIF});
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TPHPModuleCreator.Create as IOTAModuleCreator );
  except
    MessageDlg('PHP Project Wizard error while generate'+#13+#10+'project''s sources.', mtError, [mbOK], 0);
  end;
end;

function TPHPProjectWizard.GetAuthor: string;
begin
  Result := 'Perevoznyk';
end;

function TPHPProjectWizard.GetComment: string;
begin
  Result := 'PHP Project Creator';
end;

{$IFDEF VERSION6}
function TPHPProjectWizard.GetGlyph: cardinal;
{$ELSE}
function TPHPProjectWizard.GetGlyph: HICON;
{$ENDIF}
begin
  Result := LoadIcon(hInstance, 'PHPWIZARDICO');
end;

function TPHPProjectWizard.GetIDString: string;
begin
  Result := '{74D480FC-0608-4D34-AEA6-643728BD3CB9}';
end;

function TPHPProjectWizard.GetName: string;
begin
  Result := 'PHP Extension';
end;

function TPHPProjectWizard.GetPage: string;
begin
  {$IFDEF VERSION10}
  Result := 'Delphi Files';
  {$ELSE}
  Result := 'New';
  {$ENDIF}
end;

function TPHPProjectWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;



{ TPHPProjectCreator }

function TPHPProjectCreator.GetCreatorType: string;
begin
  Result := sLibrary; 
end;

function TPHPProjectCreator.GetExisting: Boolean;
begin
  Result := False; // Create a new project
end;

function TPHPProjectCreator.GetFileName: string;
{$IFNDEF VERSION9}
var
  i: Integer;
  j: Integer;
  ProjGroup: IOTAProjectGroup;
  Found: Boolean;
  TempFileName: string;
  TempFileName2: string;
{$ENDIF}
begin
{$IFDEF VERSION9}
  Result := '';
{$ELSE}


  Result := GetCurrentDir + '\' + 'Project%d' + '.dpr'; { do not localize }

  ProjGroup := GetActiveProjectGroup;

  if ProjGroup <> nil then
  begin
    for j := 0 to ProjGroup.ProjectCount-1 do
    begin
      Found := False;
      TempFileName2 := Format(Result, [j+1]);

      for i := 0 to ProjGroup.ProjectCount-1 do
      begin
        try
          TempFileName := ProjGroup.Projects[i].FileName;
          if AnsiCompareFileName(ExtractFileName(TempFileName), ExtractFileName(TempFileName2)) = 0 then
          begin
            Found := True;
            Break;
          end;
        except on E: Exception do
          if not (E is EIntfCastError) then
            raise;
        end;
      end;

      if not Found then
      begin
        Result := TempFileName2;
        Exit;
      end;
    end;
    Result := Format(Result, [ProjGroup.ProjectCount+1]);
  end
  else
    Result := Format(Result, [1]);
{$ENDIF}
end;

function TPHPProjectCreator.GetFileSystem: string;
begin
  Result := ''; // Default
end;

function TPHPProjectCreator.GetOptionFileName: string;
begin
  Result := ''; // Default
end;


function TPHPProjectCreator.GetOwner: IOTAModule;
begin
  Result := GetActiveProjectGroup;
end;


{$IFDEF VERSION9}
function TPHPProjectCreator.GetProjectPersonality: string;
begin
    Result := sDelphiPersonality;
end;
{$ENDIF}

function TPHPProjectCreator.GetShowSource: Boolean;
begin
  Result := True; // Show the source in the editor
end;

function TPHPProjectCreator.GetUnnamed: Boolean;
begin
  Result := True; // Project needs to be named/saved
end;

procedure TPHPProjectCreator.NewDefaultModule;
begin
end;


{$IFDEF VERSION9}
procedure TPHPProjectCreator.NewDefaultProjectModule(
  const Project: IOTAProject);
begin
  NewDefaultModule;
end;
{$ENDIF}

function TPHPProjectCreator.NewOptionSource(const ProjectName: string): IOTAFile;
begin
  Result := nil; // For BCB only
end;

procedure TPHPProjectCreator.NewProjectResource(const Project: IOTAProject);
begin
  // No resources needed
end;

function TPHPProjectCreator.NewProjectSource(const ProjectName: string): IOTAFile;
begin
   Result := TPHPProjectSourceFile.CreateNamedProject(ProjectName) as IOTAFile;
end;


{ TPHPProjectSourceFile }

constructor TPHPProjectSourceFile.Create(const Source: string);
begin
  FSource := Source;
end;

constructor TPHPProjectSourceFile.CreateNamedProject(AProjectName: string);
begin
  inherited Create;
  FProjectName := AProjectName;
end;

function TPHPProjectSourceFile.GetAge: TDateTime;
begin
  Result := -1;
end;

function TPHPProjectSourceFile.GetSource: string;
var
 ProjectSource : string;
begin
  ProjectSource :=
 'library '+FProjectName+';' + CRLF +
 CRLF +
 'uses' + CRLF +
 '  Windows,'+ CRLF +
 '  SysUtils,'+ CRLF +
 '  phpApp,'  + CRLF +
 '  phpModules;'+ CRLF;

 ProjectSource := ProjectSource +
 CRLF+
 '{$R *.RES}' + CRLF +
 CRLF +
 'begin' + CRLF +
 '  Application.Initialize;' + CRLF +
 '  Application.Run;' + CRLF +
 'end.';
 Result := ProjectSource;
end;

{ TPHPModuleCreator }

procedure TPHPModuleCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
  // Nothing
end;

function TPHPModuleCreator.GetAncestorName: string;
begin
   Result := 'PHPExtension';
end;

function TPHPModuleCreator.GetCreatorType: string;
begin
  // Return sUnit or sText as appropriate
  Result := sForm;
end;

function TPHPModuleCreator.GetExisting: Boolean;
begin
  Result := False;
end;

function TPHPModuleCreator.GetFileSystem: string;
begin
  Result := '';
end;

function TPHPModuleCreator.GetFormName: string;
begin
  Result := '';
end;

function TPHPModuleCreator.GetImplFileName: string;
begin
  Result := '';
end;

function TPHPModuleCreator.GetIntfFileName: string;
begin
  Result := '';
end;

function TPHPModuleCreator.GetMainForm: Boolean;
begin
  Result := False;
end;

function TPHPModuleCreator.GetOwner: IOTAModule;
{$IFNDEF VERSION9}
var
  ModuleServices: IOTAModuleServices;
  Module: IOTAModule;
  NewModule: IOTAModule;
{$ENDIF}
begin
{$IFDEF VERSION9}
  Result := nil;
{$ELSE}


  // You may prefer to return the project group's ActiveProject instead
  Result := nil;
  ModuleServices := (BorlandIDEServices as IOTAModuleServices);
  Module := ModuleServices.CurrentModule;

  if Module <> nil then
  begin
    if Module.QueryInterface(IOTAProject, NewModule) = S_OK then
      Result := NewModule

    {$IFDEF VERSION5ONLY} // Delphi 5
    else if Module.GetOwnerCount > 0 then
    begin
      NewModule := Module.GetOwner(0);
    {$ELSE} // Delphi 6+
    else if Module.OwnerModuleCount > 0 then
    begin
      NewModule := Module.OwnerModules[0];
    {$ENDIF}
      if NewModule <> nil then
        if NewModule.QueryInterface(IOTAProject, Result) <> S_OK then
          Result := nil;
    end;
  end;
{$ENDIF}
end;

function TPHPModuleCreator.GetShowForm: Boolean;
begin
  Result := True;
end;

function TPHPModuleCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

function TPHPModuleCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

function TPHPModuleCreator.NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

function TPHPModuleCreator.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
var
   Form,
   Ancestor : string;
   st : string;
begin
   Form := FormIdent;
   Ancestor := AncestorIdent;

   St:=      'unit ' + ModuleIdent + ';' + CRLF + CRLF +
             'interface' + CRLF + CRLF +
             'uses' + CRLF +
             '   Windows,'  + CRLF +
             '   Messages,' + CRLF +
             '   SysUtils,' + CRLF +
             '   Classes,'  + CRLF +
             '   Forms,'    + CRLF +
             '   zendTypes,'+ CRLF +
             '   zendAPI,'  + CRLF +
             '   phpTypes,' + CRLF +
             '   phpAPI,'   + CRLF +
             '   phpFunctions,' + CRLF +
             '   PHPModules;' + CRLF + CRLF +
             'type' + CRLF + CRLF +
             '  T' + Form + ' = class(T' + Ancestor + ')' + CRLF +
             '  private' + CRLF +
             '    { Private declarations }' + CRLF +
             '  public' + CRLF +
             '    { Public declarations }' + CRLF +
             '  end;' + CRLF + CRLF +
             'var' + CRLF +
             '  ' +Form + ': T' + Form + ';'+ CRLF + CRLF +
             'implementation'                                        + CRLF + CRLF +
             '{$R *.DFM}'                                            + CRLF + CRLF +
             'end.'  ;
   Result := TPHPExtensionSourceFile.Create(St);
end;

function TPHPModuleCreator.NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;


constructor TPHPExtensionSourceFile.Create(const Source: string);
begin
  FSource := Source;
end;

function TPHPExtensionSourceFile.GetAge: TDateTime;
begin
  Result := -1;
end;

function TPHPExtensionSourceFile.GetSource: string;
begin
  Result := FSource;
end;


{ RegisterContainerModule }
procedure RegisterContainerModule;
begin
  {$IFDEF VERSION5ONLY}
  RegisterCustomModule(TPHPExtension, TDataModuleDesignerCustomModule);
  {$ELSE}
  RegisterCustomModule(TPHPExtension, TDataModuleCustomModule);
  {$ENDIF}
end;

Initialization
   RegisterContainerModule();

Finalization

end.