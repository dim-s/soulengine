{*******************************************************}
{                     PHP4Delphi                        }
{         Custom PHP extension application              }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
{$I PHP.INC}

{ $Id: phpApp.pas,v 7.2 10/2009 delphi32 Exp $ }


{$DENYPACKAGEUNIT}

unit phpAPP;

interface

uses
  Windows, SysUtils, PHPAPI, phpModules;

implementation

{ InitApplication }
procedure InitApplication;
begin
  Application := TPHPApplication.Create(nil);
end;

{ DoneApplication }
procedure DoneApplication;
begin
  try
    if Assigned(Application) then
     begin
       Application.CacheConnections := false;
       Application.Free;
       Application := nil;
     end;
  except
  end;
end;

initialization
  if not PHPLoaded then
   LoadPHP;

  InitApplication;

finalization
  DoneApplication;

end.

