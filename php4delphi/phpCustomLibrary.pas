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

{ $Id: phpCustomLibrary.pas,v 7.2  10/2009 delphi32 Exp $ }

unit PHPCustomLibrary;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PHPCommon,
  ZendTypes, PHPTypes, PHPAPI, ZENDAPI,
  phpFunctions;

type

  IPHPEngine = interface (IUnknown)
  ['{484AE2CA-755A-437C-9B60-E3735973D0A9}']
    procedure HandleRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer);
    function GetEngineActive : boolean;
   end;


  TCustomPHPLibrary = class(TPHPComponent)
  private
    FLibraryName : AnsiString;
    FFunctions  : TPHPFunctions;
    FLocked: boolean;
    procedure SetFunctions(const Value : TPHPFunctions);
    procedure SetLibraryName(AValue : AnsiString);
  protected
    procedure RegisterLibrary; virtual;
    procedure UnregisterLibrary; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure Refresh; virtual;
    property LibraryName : AnsiString read FLibraryName write SetLibraryName;
    property Functions  : TPHPFunctions read FFunctions write SetFunctions;
    property Locked : boolean read FLocked write FLocked;
  end;

  TPHPLibrarian = class
  private
    FLibraries : TList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddLibrary(ALibrary : TCustomPHPLibrary);
    procedure RemoveLibrary(ALibrary : TCustomPHPLibrary);
    function Count : integer;
    function GetLibrary(Index : integer) : TCustomPHPLibrary;
    property Libraries : TList read FLibraries write FLibraries;
  end;

var
 Librarian : TPHPLibrarian = nil;
 
implementation

{ TCustomPHPLibrary }

constructor TCustomPHPLibrary.Create(AOwner: TComponent);
begin
  inherited;
  FFunctions := TPHPFunctions.Create(Self, TPHPFunction);
  RegisterLibrary;
end;

destructor TCustomPHPLibrary.Destroy;
begin
  UnregisterLibrary;
  FFunctions.Free;
  FFunctions := nil;
  inherited;
end;

procedure TCustomPHPLibrary.Refresh;
begin
end;


procedure TCustomPHPLibrary.RegisterLibrary;
begin
   if Assigned(Librarian) then
    Librarian.AddLibrary(Self);
end;



procedure TCustomPHPLibrary.SetFunctions(const Value: TPHPFunctions);
begin
  FFunctions.Assign(Value);
end;

procedure TCustomPHPLibrary.SetLibraryName(AValue: AnsiString);
begin
  if FLibraryName <> AValue then
   begin
     FLibraryName := AValue;
   end;  
end;

procedure TCustomPHPLibrary.UnregisterLibrary;
begin
  if Assigned(Librarian) then
   Librarian.RemoveLibrary(Self);
end;


procedure InitLibrarian;
begin
  Librarian := TPHPLibrarian.Create;
end;

procedure UninitLibrarian;
begin
  if Assigned(Librarian) then
   try
     Librarian.Free;
   finally
     Librarian := nil;
   end;
end;

{ TPHPLibrarian }

procedure TPHPLibrarian.AddLibrary(ALibrary: TCustomPHPLibrary);
begin
  if FLibraries.IndexOf(ALibrary) = -1 then
   FLibraries.Add(ALibrary);
end;

function TPHPLibrarian.Count: integer;
begin
  Result := FLibraries.Count;
end;

constructor TPHPLibrarian.Create;
begin
  inherited;
  FLibraries := TList.Create;
end;

destructor TPHPLibrarian.Destroy;
begin
  FLibraries.Free;
  inherited;
end;

function TPHPLibrarian.GetLibrary(Index: integer): TCustomPHPLibrary;
begin
  Result := TCustomPHPLibrary(FLibraries[Index]);
end;

procedure TPHPLibrarian.RemoveLibrary(ALibrary: TCustomPHPLibrary);
begin
  FLibraries.Remove(ALibrary);
end;

initialization
  InitLibrarian;

finalization
  UnInitLibrarian;

end.
