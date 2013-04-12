{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{ http://delphi32.blogspot.com                          }
{*******************************************************}
{$I PHP.INC}

{ $Id: php4DelphiWeb.pas,v 7.2 10/2009 delphi32 Exp $ } 

unit php4DelphiWeb;

interface

uses
  Windows, ToolsAPI, Forms, Dialogs, SysUtils, Graphics, Classes, ShellAPI;

type
  Tphp4DelphiWeb = class(TNotifierObject, IOTAWIzard, IOTAMenuWizard)
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
  RegisterPackageWizard(Tphp4DelphiWeb.Create as IOTAWizard);
end;

procedure InitExpert;
begin
  { stubbed out }
end;

procedure DoneExpert;
begin
  { stubbed out }
end;

{ Tphp4DelphiWeb }

procedure Tphp4DelphiWeb.Execute;
begin
  ShellExecute(0, 'open', 'http://users.chello.be/ws36637', nil, nil, SW_SHOW);
end;

function Tphp4DelphiWeb.GetIDString: string;
begin
  Result := 'Perevoznyk.Tphp4DelphiWeb';
end;

function Tphp4DelphiWeb.GetMenuText: string;
begin
  Result := 'PHP4Delphi Home Page';
end;

function Tphp4DelphiWeb.GetName: string;
begin
  Result := 'Tphp4DelphiWeb';
end;

function Tphp4DelphiWeb.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

initialization
  InitExpert;

finalization
  DoneExpert;

end.
