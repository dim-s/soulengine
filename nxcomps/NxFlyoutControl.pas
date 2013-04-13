unit NxFlyoutControl;

interface

uses
  Windows, Messages, Classes, Controls, Graphics, SysUtils, ExtCtrls, Forms;

type
  TNxFlyoutControl = class(TCustomControl)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TRollShadowKind = (rkBoth, rkVertical, rkHorizontal);

  TRollShadow = class(TNxFlyoutControl)
  private
    FPosition: TPoint;
    FKind: TRollShadowKind;
    procedure SetPosition(const Value: TPoint);
    procedure SetKind(const Value: TRollShadowKind);
  protected
    procedure Paint; override;
    procedure SetWindowShape; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property Kind: TRollShadowKind read FKind write SetKind;
  	property Position: TPoint read FPosition write SetPosition;
  end;

implementation

{ TNxFlyoutControl }

constructor TNxFlyoutControl.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csNoDesignVisible];
  BringToFront;
end;

procedure TNxFlyoutControl.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do begin
    Style := (Style and not (WS_CHILD or WS_GROUP or WS_TABSTOP)) or WS_POPUP;
    ExStyle := ExStyle or WS_EX_TOPMOST or WS_EX_TOOLWINDOW;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

procedure TNxFlyoutControl.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

{ TRollShadow }

constructor TRollShadow.Create(AOwner: TComponent);
begin
  inherited;
  SetWindowShape;
  FKind := rkVertical;
end;

procedure TRollShadow.SetKind(const Value: TRollShadowKind);
begin
  FKind := Value;
end;

procedure TRollShadow.SetPosition(const Value: TPoint);
begin
  SetWindowShape;
  FPosition := Value;
  SetBounds(Value.X - 7, Value.Y - 11, 32, 32);
end;

procedure TRollShadow.SetWindowShape;
var
  PointsUp: array[1..5] of TPoint;
  PointsDown: array[1..5] of TPoint;
  R1, R2, R3, R4: HRGN;
	function CreateEmptyRegion: HRGN;
	var
	  R: TRect;
	begin
	  SetRectEmpty(R);
	  Result := CreateRectRgnIndirect(R);
	end;
begin
  inherited;
  PointsUp[1] := Point(-1, 7);
  PointsUp[2] := Point(7, -1);
  PointsUp[3] := Point(8, 0);
  PointsUp[4] := Point(14, 7);
  PointsUp[5] := Point(0, 6);
  R1 := CreatePolygonRgn(PointsUp, 5, WINDING);

  PointsDown[1] := Point(-1, 15);
  PointsDown[2] := Point(14, 15);
  PointsDown[3] := Point(6, 22);
  PointsDown[4] := Point(6, 22);
  PointsDown[5] := Point(-1, 14);
  R2 := CreatePolygonRgn(PointsDown, 5, WINDING);

  R3 := CreateEllipticRgn(5, 9, 10, 14);
  R4 := CreateEmptyRegion;
  CombineRgn(R4, R1, R2, RGN_OR);
  CombineRgn(R4, R4, R3, RGN_OR);

  SetWindowRgn(Handle, R4, True);
  DeleteObject(R1);
  DeleteObject(R2);
  DeleteObject(R3);
  DeleteObject(R4);
end;

procedure TRollShadow.Paint;
begin
  inherited;
  Canvas.Brush.Color := clGrayText;
  Canvas.FillRect(ClientRect);
//  TGraphicsProvider.DrawImageFromRes(Canvas, 0, 0, 'ROLLSHADOW');
end;

end.









