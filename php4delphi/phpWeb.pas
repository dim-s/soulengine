{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{*******************************************************}
{$I PHP.INC}

{ $Id: phpWeb.pas,v 7.2 10/2009 delphi32 Exp $ } 

unit phpWeb;

interface

uses
  Windows, ToolsAPI, Forms, Dialogs, SysUtils, Graphics, Classes, ShellAPI;

type
  TphpWebWizard = class(TNotifierObject, IOTAWIzard, IOTAMenuWizard)
  public
    function GetMenuText: string;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
  end;


  TphpForumWizard = class(TNotifierObject, IOTAWIzard, IOTAMenuWizard)
  public
    function GetMenuText: string;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterPackageWizard(TphpWebWizard.Create as IOTAWizard);
  RegisterPackageWizard(TphpForumWizard.Create as IOTAWizard);
end;

procedure InitExpert;
begin
  { stubbed out }
end;

procedure DoneExpert;
begin
  { stubbed out }
end;

{ TphpWebWizard }

procedure TphpWebWizard.Execute;
begin
  ShellExecute(0, 'open', 'http://www.php.net', nil, nil, SW_SHOW);
end;

function TphpWebWizard.GetIDString: string;
begin
  Result := 'Perevoznyk.TphpWebWizard';
end;

function TphpWebWizard.GetMenuText: string;
begin
  Result := 'PHP Home Page';
end;

function TphpWebWizard.GetName: string;
begin
  Result := 'TphpWebWizard';
end;

function TphpWebWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;



{ TphpForumWizard }

procedure TphpForumWizard.Execute;
begin
  ShellExecute(0, 'open', 'http://sourceforge.net/forum/forum.php?forum_id=324242', nil, nil, SW_SHOW);
end;

function TphpForumWizard.GetIDString: string;
begin
  Result := 'Perevoznyk.TphpForumWizard';
end;

function TphpForumWizard.GetMenuText: string;
begin
  Result := 'PHP4Delphi Forum';
end;

function TphpForumWizard.GetName: string;
begin
  Result := 'TphpForumWizard';
end;

function TphpForumWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

initialization
  InitExpert;

finalization
  DoneExpert;

end.
