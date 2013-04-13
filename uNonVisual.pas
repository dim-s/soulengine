unit uNonVisual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TNonVisual = class(TScrollBox)
  private
    { Private declarations }
    FLabel: TLabel;
    FPanel: TScrollBox;
    FImage: TImage;
    FCaption: string;

    procedure updatePos;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;

    procedure SetCaption(const Value: string);

  public
    { Public declarations }
    constructor Create(AComponent: TComponent);
    procedure loadFromFile(fName: string);
    procedure Clear();

  published
    property Caption: string read FCaption write SetCaption;
  end;

implementation


{ TNonVisual }

procedure TNonVisual.Clear;
begin
  FImage.Picture.Bitmap := nil;
end;

constructor TNonVisual.Create(AComponent: TComponent);
begin
  inherited;
  BevelKind := bkFlat;
  BorderStyle := bsNone;
  Width := 25;
  Height := 25;
  Constraints.MaxHeight := 25;
  Constraints.MaxWidth := 25;
  Constraints.MinHeight := 25;
  Constraints.MinWidth := 25;

  BevelWidth := 2;

  FImage := TImage.Create(AComponent);
  FImage.Transparent := True;
  FImage.Parent := Self;

  FPanel := TScrollBox.Create(AComponent);
  FPanel.Parent := TWinControl(AComponent);
  FPanel.BevelKind := bkFlat;
  FPanel.BorderStyle := bsNone;
  FPanel.BevelWidth := 2;

  FLabel := TLabel.Create(AComponent);
  FLabel.Font.Name := 'Tahoma';
  FLabel.Font.Size := 8;
  FLabel.ParentFont := False;
  FLabel.Alignment := taCenter;
  FLabel.Parent := FPanel;

  Caption := 'SkinManager';

  FPanel.AutoSize := True;

  updatePos();
end;

procedure TNonVisual.loadFromFile(fName: string);
begin
  FImage.Picture.LoadFromFile(fName);
end;

procedure TNonVisual.SetCaption(const Value: string);
begin
  FCaption := Value;
  if Length(Value) > 15 then
    FCaption := copy(Value, 1, 15) + #13 + copy(Value, 16, length(Value) - 15);

  FLabel.Caption := FCaption;
  updatePos();
end;

procedure TNonVisual.updatePos;
begin
  FPanel.Top := Self.Top + Self.Height + 5;
  FPanel.Left := Self.Left - trunc(FLabel.Width / 2) + 9;
end;

procedure TNonVisual.WMMove(var Message: TWMMove);
begin
  updatePos();
end;

procedure TNonVisual.WMSize(var Message: TWMSize);
begin
  updatePos();
end;

end.

