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

{ $Id: phpAbout.pas,v 7.2 10/2009 delphi32 Exp $ } 

unit phpAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  {$IFDEF VERSION6}
  DesignIntf,
  DesignEditors,
  {$ELSE}
  dsgnintf,
  {$ENDIF}
  math;

type
  TdlgAbout = class(TForm)
    pnlLeft: TPanel;
    pnlImage: TPanel;
    imgAbout: TImage;
    pnlBody: TPanel;
    bvlSpit: TBevel;
    labTitleShadow: TLabel;
    labTitle: TLabel;
    labDelphiShadow: TLabel;
    lblAuthor: TLabel;
    labDelphi: TLabel;
    labVersion: TLabel;
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
    protected
  end;

  TPHPVersionEditor = class(TPropertyEditor)
    function AllEqual: boolean; override;
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;


const php4DelphiVersion = '7.2';

implementation

{$R *.DFM}

function TPHPVersionEditor.AllEqual: boolean;
var
  componentIndex: integer;
  currentValue: string;
begin
  Result := False;
  if (PropCount > 1) then
   begin
    currentValue := GetStrValue;
    for componentIndex := 1 to PropCount - 1 do
     begin
        if (GetStrValueAt(componentIndex) <> currentValue) then
          exit;
     end;
    end;
   Result := True;
end;

procedure TPHPVersionEditor.Edit;
begin
  with TdlgAbout.Create(NIL) do
  begin
    try
      ShowModal;
    finally
      Free;  { Free dialog. }
    end;
  end;
end;

function TPHPVersionEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TPHPVersionEditor.GetValue: string;
begin
  Result := 'PHP4Delphi ' + php4DelphiVersion;
end;

procedure TPHPVersionEditor.SetValue(const Value: string);
begin
end;

procedure TdlgAbout.FormCreate(Sender: TObject);
begin
  labVersion.Caption := 'Version ' + php4DelphiVersion;
end;

end.
