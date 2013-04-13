unit NxStdCtrls;

interface

uses
	Types, Classes, Windows, Controls, Graphics, Messages, Forms, Dialogs,
  ImgList, ExtCtrls, SysUtils, NxClasses, NxThemesSupport;

const
  sizTabMargin = 12; { 6 + 6 }

type
  TNxGlyphSettings = class(TPersistent)
  private
    FNormalGlyph: TBitmap;
    FTransparentColor: TColor;
    FTransparent: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetNormalGlyph(const Value: TBitmap);
  protected
    procedure DoChange; dynamic;
    procedure DoGlyphChange(Sender: TObject);
    procedure SetTransparentColor(const Value: TColor); virtual;
    procedure SetTransparent(const Value: Boolean); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  published
    property NormalGlyph: TBitmap read FNormalGlyph write SetNormalGlyph;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor default clNone;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TNxActiveGlyphSettings = class(TNxGlyphSettings)
  private
    FHoverGlyph: TBitmap;
    procedure SetHoverGlyph(const Value: TBitmap);
  protected
    procedure SetTransparentColor(const Value: TColor); override;
    procedure SetTransparent(const Value: Boolean); override;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property HoverGlyph: TBitmap read FHoverGlyph write SetHoverGlyph;
  end;

  TNxTabButtons = class;

  TNxPalleteButton = class
  private
    FOwner: TNxTabButtons;
    FHint: string;
    FImageIndex: TImageIndex;
    FReferenceType: TComponentClass;
    FShowHint: Boolean;
    function GetIndex: Integer;
  public
    constructor Create(AOwner: TNxTabButtons);
    property ReferenceType: TComponentClass read FReferenceType write FReferenceType;
    property ImageIndex: TImageIndex read FImageIndex write FImageIndex;
    property Index: Integer read GetIndex;
    property Hint: string read FHint write FHint;
    property ShowHint: Boolean read FShowHint write FShowHint default False;
  end;

  TNxTabButtons = class
  private
    FButtons: TList;
    FCaption: TCaption;
    function GetCount: Integer;
    function GetButton(Index: Integer): TNxPalleteButton;
  public
    constructor Create(Caption: TCaption);
    destructor Destroy; override;
    function AddButton(ReferenceType: TComponentClass; ImageIndex: TImageIndex): TNxPalleteButton;
  public
    property Button[Index: Integer]: TNxPalleteButton read GetButton;
    property Caption: TCaption read FCaption write FCaption;
    property Count: Integer read GetCount;
  end;

  TButtonClickEvent = procedure (Sender: TObject; const Index: Integer) of object;

  TNxButtonHint = class(THintWindow)
  private
    FButton: TNxPalleteButton;
  public
    property Button: TNxPalleteButton read FButton write FButton;
  end;

  TTabsBackgroundStyle = (tbsSolid, tbsVertGradient);

  TNxTabControl = class(TCustomControl)
  private
    FActiveIndex: Integer;
    FButtonWidth: Integer;
    FButtonHeight: Integer;
    FDownButton: Integer;
    FHintHideTimer: TTimer;
    FHintTimer: TTimer;
    FHintWindow: TNxButtonHint;
    FHoverButton: Integer;
    FImages: TImageList;
    FLeftIndent: Integer;
    FMargin: Integer;
    FPalettes: TList;
    FTopIndent: Integer;
    FTabHeight: Integer;
    FOnButtonClick: TButtonClickEvent;
    FBackgroundStyle: TTabsBackgroundStyle;
    function GetCount: Integer;
    function GetButton(Index: Integer): TNxPalleteButton;
    function GetTabButtons(Index: Integer): TNxTabButtons;
    procedure SetActiveIndex(const Value: Integer);
    procedure SetButtonHeight(const Value: Integer);
    procedure SetButtonWidth(const Value: Integer);
    procedure SetImages(const Value: TImageList);
    procedure SetLeftIndent(const Value: Integer);
    procedure SetTabHeight(const Value: Integer);
    procedure SetTopIndent(const Value: Integer);
    procedure SetMargin(const Value: Integer);
    procedure SetBackgroundStyle(const Value: TTabsBackgroundStyle);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure DoButtonClick(const Index: Integer); dynamic;
    procedure DoHintHideTimer(Sender: TObject);
    procedure DoHintTimer(Sender: TObject);
    procedure HideButtonHint;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
    procedure PaintButton(ButtonRect: TRect; ImageIndex: Integer; State: TButtonState);
    procedure PaintButtons;
    procedure PaintPage(PageRect: TRect);
    procedure PaintTab(const Index: Integer; TabRect: TRect);
    procedure PaintTabBorder(TabRect: TRect; Active: Boolean);
    procedure RefreshButton(const Index: Integer);
    procedure ShowButtonHint(Button: TNxPalleteButton);
	  procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    function Add(const Caption: string): TNxTabButtons;
    function AddButton(PaletteName: string; ReferenceType: TComponentClass;
      ImageIndex: Integer): TNxPalleteButton;
    function ButtonExist(const Index: Integer): Boolean;
    function GetButtonRect(const Index: Integer): TRect;
    function GetButtonsRect: TRect;
    function GetButtonAtPos(X, Y: Integer): Integer;
    function GetPaletteByName(const Name: string): TNxTabButtons;
    function GetTabAtPos(X, Y: Integer): Integer;
    function GetTabsRect: TRect;
    function TabExist(const Index: Integer): Boolean;
    property Button[Index: Integer]: TNxPalleteButton read GetButton;
    property TabButtons[Index: Integer]: TNxTabButtons read GetTabButtons;
  published
    property ActiveIndex: Integer read FActiveIndex write SetActiveIndex;
    property Align;
    property AutoSize;
    property ButtonHeight: Integer read FButtonHeight write SetButtonHeight;
    property BackgroundStyle: TTabsBackgroundStyle read FBackgroundStyle write SetBackgroundStyle;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth;
    property Color;
    property Count: Integer read GetCount;
    property Font;
    property Images: TImageList read FImages write SetImages;
    property LeftIndent: Integer read FLeftIndent write SetLeftIndent default 2;
    property Margin: Integer read FMargin write SetMargin;
    property ParentColor;
    property ParentFont;
    property TabHeight: Integer read FTabHeight write SetTabHeight default 21;
    property TopIndent: Integer read FTopIndent write SetTopIndent default 2;
    property OnButtonClick: TButtonClickEvent read FOnButtonClick write FOnButtonClick;
  end;

implementation

uses Math, NxSharedCommon, NxSharedDraw;

{ TNxGlyphSettings }

constructor TNxGlyphSettings.Create;
begin
  FNormalGlyph := TBitmap.Create;
  FNormalGlyph.OnChange := DoGlyphChange;
  FTransparent := False;
  FTransparentColor := clNone;
end;

destructor TNxGlyphSettings.Destroy;
begin
  FNormalGlyph.Free;
  inherited;
end;

procedure TNxGlyphSettings.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxGlyphSettings.DoGlyphChange(Sender: TObject);
begin
  DoChange;
end;

procedure TNxGlyphSettings.SetNormalGlyph(const Value: TBitmap);
begin
  FNormalGlyph.Assign(Value);
end;

procedure TNxGlyphSettings.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  FNormalGlyph.Transparent := Value;
end;

procedure TNxGlyphSettings.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  FNormalGlyph.TransparentColor := Value;
end;

{ TNxActiveGlyphSettings }

constructor TNxActiveGlyphSettings.Create;
begin
  inherited;
  FHoverGlyph := TBitmap.Create;
  FHoverGlyph.OnChange := DoGlyphChange;
end;

destructor TNxActiveGlyphSettings.Destroy;
begin
  FHoverGlyph.Free;
  inherited;
end;

procedure TNxActiveGlyphSettings.SetHoverGlyph(const Value: TBitmap);
begin
  FHoverGlyph.Assign(Value);
end;

procedure TNxActiveGlyphSettings.SetTransparent(const Value: Boolean);
begin
  inherited;
  FHoverGlyph.Transparent := Value;
end;

procedure TNxActiveGlyphSettings.SetTransparentColor(const Value: TColor);
begin
  inherited;
  FHoverGlyph.TransparentColor := Value;
end;

{ TNxPalleteButton }

constructor TNxPalleteButton.Create(AOwner: TNxTabButtons);
begin
  FOwner := AOwner;
end;

function TNxPalleteButton.GetIndex: Integer;
begin
  Result := FOwner.FButtons.IndexOf(Self);
end;

{ TNxTabButtons }

function TNxTabButtons.AddButton(ReferenceType: TComponentClass;
  ImageIndex: TImageIndex): TNxPalleteButton;
begin
  try
    Result := TNxPalleteButton.Create(Self);
    Result.ReferenceType := ReferenceType;
    Result.ImageIndex := ImageIndex;
    FButtons.Add(Result);
  except
    Result := nil;
  end;
end;

constructor TNxTabButtons.Create(Caption: TCaption);
begin
  FButtons := TList.Create;
  FCaption := Caption;
end;

destructor TNxTabButtons.Destroy;
begin
  FButtons.Free;
  inherited;
end;

function TNxTabButtons.GetButton(Index: Integer): TNxPalleteButton;
begin
  Result := TNxPalleteButton(FButtons[Index]);
end;

function TNxTabButtons.GetCount: Integer;
begin
  Result := FButtons.Count;
end;

{ TNxTabControl }

function TNxTabControl.Add(const Caption: string): TNxTabButtons;
begin
  Result := nil;
  try
    Result := TNxTabButtons.Create(Caption);
    FPalettes.Add(Result);
  except

  end;
end;

function TNxTabControl.AddButton(PaletteName: string; ReferenceType: TComponentClass;
  ImageIndex: Integer): TNxPalleteButton;
var
  APalette: TNxTabButtons;
begin
  APalette := GetPaletteByName(PaletteName);
  if APalette = nil then APalette := Add(PaletteName);
  Result := APalette.AddButton(ReferenceType, ImageIndex);
  Invalidate;
end;

function TNxTabControl.ButtonExist(const Index: Integer): Boolean;
begin
  Result := (TabButtons[FActiveIndex].Count > 0) and InRange(Index, 0, Pred(TabButtons[FActiveIndex].Count));
end;

function TNxTabControl.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
begin
  Result := True;
  NewHeight := FTopIndent + FTabHeight + FMargin + FButtonHeight + FMargin;
end;

procedure TNxTabControl.CMMouseLeave(var Message: TMessage);
var
  FOldHoverButton: Integer;
begin
  inherited;
  if Count = 0 then Exit;
  FOldHoverButton := FHoverButton;
  FHoverButton := -1;
  if ButtonExist(FOldHoverButton) then RefreshButton(FOldHoverButton);
  HideButtonHint;
end;

constructor TNxTabControl.Create(AOwner: TComponent);
begin
  inherited;
  FActiveIndex := 0;
  FBackgroundStyle := tbsSolid;
  FDownButton := -1;
  FButtonHeight := 22;
  FButtonWidth := 23;
  FHintHideTimer := TTimer.Create(Self);
  FHintHideTimer.Interval := Application.HintHidePause;
  FHintHideTimer.Enabled := False;
  FHintHideTimer.OnTimer := DoHintHideTimer;
  FHintTimer := TTimer.Create(Self);
  FHintTimer.Interval := Application.HintPause;
  FHintTimer.Enabled := False;
  FHintTimer.OnTimer := DoHintTimer;
  FHintWindow := TNxButtonHint.Create(Self);
  FHintWindow.Color := clInfoBk;
  FHoverButton := -1;
  FImages := nil;
  FLeftIndent := 2;
  FMargin := 2;
  FPalettes := TList.Create;
  FTabHeight := 21;
  FTopIndent := 2;
  Height := 47;
  Width := 200;
end;

destructor TNxTabControl.Destroy;
begin
  FreeAndNil(FHintHideTimer);
  FreeAndNil(FHintTimer);
  FreeAndNil(FHintWindow);
  FreeAndNil(FPalettes);
  inherited;
end;

procedure TNxTabControl.DoButtonClick(const Index: Integer);
begin
  if Assigned(FOnButtonClick) then FOnButtonClick(Self, Index);
end;

procedure TNxTabControl.DoHintHideTimer(Sender: TObject);
begin
  FHintHideTimer.Enabled := False;
  FHintWindow.ReleaseHandle;
end;

procedure TNxTabControl.DoHintTimer(Sender: TObject);
begin
  if ButtonExist(FHoverButton) then
  begin
    FHintWindow.Button := Button[FHoverButton];
    ShowButtonHint(Button[FHoverButton]);
  end;
end;

function TNxTabControl.GetButton(Index: Integer): TNxPalleteButton;
begin
  Result := TabButtons[FActiveIndex].Button[Index];
end;

function TNxTabControl.GetButtonAtPos(X, Y: Integer): Integer;
begin
  Result := (X + FMargin) div FButtonWidth;
end;

function TNxTabControl.GetButtonRect(const Index: Integer): TRect;
begin
  with Result do
  begin
    Left := FMargin + Index * FButtonWidth;
    Top := FMargin + FTopIndent + FTabHeight;
    Right := Left + FButtonWidth;
    Bottom := Top + FButtonHeight;
  end;
end;

function TNxTabControl.GetButtonsRect: TRect;
begin
  with Result do
  begin
    Left := FMargin;
    Top := FTopIndent + FTabHeight + FMargin;
    Right := ClientWidth - 2;
    Bottom := Top + FButtonHeight;
  end;
end;

function TNxTabControl.GetCount: Integer;
begin
  Result := FPalettes.Count;
end;

function TNxTabControl.GetTabButtons(Index: Integer): TNxTabButtons;
begin
  Result := TNxTabButtons(FPalettes[Index]);
end;

function TNxTabControl.GetPaletteByName(const Name: string): TNxTabButtons;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(Count) do
    if TabButtons[I].Caption = Name then
    begin
      Result := TabButtons[I];
      Exit;
    end;
end;

function TNxTabControl.GetTabAtPos(X, Y: Integer): Integer;
var
  I, Pos, TextWidth: Integer;
begin
  Result := -1;
  Pos := FLeftIndent;
  for I := 0 to Pred(Count) do
  begin
    TextWidth := Canvas.TextWidth(TabButtons[I].Caption) + sizTabMargin;
    if PtInRect(Rect(Pos, FTopIndent, Pos + TextWidth, FTopIndent + FTabHeight), Point(X, Y)) then
    begin
      Result := I;
      Exit;
    end;
    Inc(Pos, TextWidth);
  end;
end;

function TNxTabControl.GetTabsRect: TRect;
begin
  Result := Rect(0, 0, ClientWidth, FTopIndent + FTabHeight);
end;

procedure TNxTabControl.HideButtonHint;
begin
  FHintTimer.Enabled := False;
  FHintHideTimer.Enabled := False;
  FHintWindow.Button := nil;
  FHintWindow.ReleaseHandle;
end;

procedure TNxTabControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  FDownTab: Integer;
begin
  inherited;
  if PtInRect(GetTabsRect, Point(X, Y)) then
  begin
    FDownTab := GetTabAtPos(X, Y);
    if TabExist(FDownTab) then
    begin
      FActiveIndex := FDownTab;
      Invalidate;
    end;
  end;
  if PtInRect(GetButtonsRect, Point(X, Y)) then
  begin
    FDownButton := GetButtonAtPos(X, Y);
    if ButtonExist(FDownButton) then RefreshButton(FDownButton);
  end;
end;

procedure TNxTabControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  AHoverButton: TNxPalleteButton;
  FOldHoverButton: Integer;
begin
  inherited;
  if (Count = 0) or (TabButtons[FActiveIndex].Count = 0) then Exit;
  if PtInRect(GetButtonsRect, Point(X, Y)) then
  begin
    FOldHoverButton := FHoverButton;
    FHoverButton := GetButtonAtPos(X, Y);
    if FHoverButton <> FOldHoverButton then
    begin
      if InRange(FHoverButton, 0, TabButtons[FActiveIndex].Count) then RefreshButton(FHoverButton);
      if InRange(FOldHoverButton, 0, TabButtons[FActiveIndex].Count) then RefreshButton(FOldHoverButton);
      if ButtonExist(FHoverButton) then
      begin
        AHoverButton := Button[FHoverButton];
        if FHintWindow.Button <> AHoverButton then
        begin
          if AHoverButton.ShowHint and (Length(AHoverButton.Hint) > 0) then
          begin
            if Assigned(FHintWindow.Button) then
            begin
              FHintHideTimer.Enabled := False;
              FHintWindow.Button := AHoverButton;
              ShowButtonHint(AHoverButton);
            end else
            begin
              FHintTimer.Enabled := True;
            end;
          end else HideButtonHint;
        end;
      end else HideButtonHint;
    end;
  end else
  begin
    HideButtonHint;
    FOldHoverButton := FHoverButton;
    FHoverButton := -1;
    if ButtonExist(FOldHoverButton) then RefreshButton(FOldHoverButton);
  end;
end;

procedure TNxTabControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  FUpButton, FOldDownButton: Integer;
begin
  inherited;
  if PtInRect(GetButtonsRect, Point(X, Y)) then
  begin
    FUpButton := GetButtonAtPos(X, Y);
    if ButtonExist(FUpButton) then
    begin
      if FUpButton = FDownButton then DoButtonClick(FUpButton);
    end;
    FOldDownButton := FDownButton;
    if ButtonExist(FOldDownButton) then RefreshButton(FOldDownButton);
  end;
  FDownButton := -1;
end;

procedure TNxTabControl.Paint;
var
  I, PosX, PosY, TextWidth: Integer;
  ActiveRect, TabRect: TRect;
begin
  inherited;
  PosX := FLeftIndent;                                          
  PosY := FTopIndent;
  Canvas.Font.Assign(Font);
  Canvas.Brush.Color := clBtnFace;
  case FBackgroundStyle of
    tbsSolid: Canvas.FillRect(GetTabsRect);
    tbsVertGradient: DrawVertGradient(Canvas, GetTabsRect, cl3DLight, clBtnFace);
  end;
  for i := 0 to Pred(Count) do
  begin
    TextWidth := Canvas.TextWidth(TabButtons[I].Caption) + sizTabMargin;
    TabRect := Rect(PosX, PosY, PosX + TextWidth, PosY + FTabHeight);
    if I = ActiveIndex then
    begin
      ActiveRect := TabRect;
      InflateRect(ActiveRect, 2, 0);
      Inc(PosX, TextWidth);
    end else
    begin
      PaintTab(I, TabRect);
      Inc(PosX, TextWidth);
    end;
  end;
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(Rect(0, FTopIndent + FTabHeight, ClientWidth, ClientHeight));
  if csDesigning in ComponentState then
  begin
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clGrayText;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(GetButtonsRect);
    Canvas.Pen.Style := psSolid;
    Canvas.Brush.Style := bsSolid;
  end;
  if TabExist(FActiveIndex) then
  begin
    PosY := FTopIndent + FTabHeight - 1;
    PaintTab(ActiveIndex, ActiveRect);
    Canvas.Font.Color := clWindowText;
    Canvas.Pen.Color := clGrayText;
    Canvas.Polyline([
      Point(0, PosY),
      Point(ActiveRect.Left + 1, PosY)]);
    Canvas.Polyline([
      Point(ActiveRect.Right - 1, PosY),
      Point(ClientWidth, PosY)]);
    PaintButtons;
  end;
end;

procedure TNxTabControl.PaintButton(ButtonRect: TRect;
  ImageIndex: Integer; State: TButtonState);
var
  X, Y: Integer;
begin
  if btHover in State then
  begin
    if btDown in State then Frame3D(Canvas, ButtonRect, clBtnShadow, clBtnHighlight, 1) else
      Frame3D(Canvas, ButtonRect, clBtnHighlight, clBtnShadow, 1);
  end;
  if Assigned(FImages) and InRange(ImageIndex, 0, FImages.Count) then
  begin
    X := ButtonRect.Left + ((ButtonRect.Right - ButtonRect.Left) div 2 - FImages.Width div 2);
    Y := ButtonRect.Top + ((ButtonRect.Bottom - ButtonRect.Top) div 2 - FImages.Height div 2);
    if State = [btHover, btDown] then
    begin
      Inc(X);
      Inc(Y);
    end;
    Images.Draw(Canvas, X, Y, ImageIndex);
  end;
end;

procedure TNxTabControl.PaintButtons;
var
  I, X, Y: Integer;
  ButtonRect: TRect;
  State: TButtonState;
begin
  X := FMargin;
  Y := FMargin + FTopIndent + FTabHeight;
  for I := 0 to Pred(TabButtons[FActiveIndex].Count) do
  begin
    ButtonRect := Rect(X, Y, X + FButtonWidth, Y + FButtonHeight);
    Inc(X, FButtonWidth);
    State := [];
    if I = FHoverButton then Include(State, btHover);
    if I = FDownButton then Include(State, btDown);
    PaintButton(ButtonRect, TabButtons[FActiveIndex].Button[I].ImageIndex, State);
  end;
end;

procedure TNxTabControl.PaintPage(PageRect: TRect);
begin
  Canvas.Brush.Color := clGrayText;
  Canvas.FillRect(PageRect);
end;

procedure TNxTabControl.PaintTab(const Index: Integer; TabRect: TRect);
begin
  with Canvas do
  begin
    PaintTabBorder(TabRect, Index = ActiveIndex);
    if Index = ActiveIndex then
      OffsetRect(TabRect, 0, -1) else OffsetRect(TabRect, 0, 1);
    NxSharedCommon.DrawTextRect(Canvas, TabRect, taCenter, TabButtons[Index].Caption);
  end;
end;

procedure TNxTabControl.PaintTabBorder(TabRect: TRect;
  Active: Boolean);
begin
  if IsThemed then
  begin
    if Active then
    begin
      ThemeRect(Handle, Canvas.Handle, TabRect, teTab, 1, 3);
    end else
    begin
      Inc(TabRect.Top, 2);
      ThemeRect(Handle, Canvas.Handle, TabRect, teTab, 1, 1);
    end;
  end else
  begin
    if Active then
    begin
      Canvas.Pen.Color := clGrayText;
      Canvas.Brush.Color := clWindow;
      Canvas.Polyline([
        Point(TabRect.Left, TabRect.Bottom - 1),
        Point(TabRect.Left, TabRect.Top + 2),
        Point(TabRect.Left + 2, TabRect.Top),
        Point(TabRect.Right - 3, TabRect.Top),
        Point(TabRect.Right - 1, TabRect.Top + 2),
        Point(TabRect.Right - 1, TabRect.Bottom - 1)
      ]);
      Canvas.Pen.Color := clWindow;
      Canvas.Polygon([
        Point(TabRect.Left + 1, TabRect.Bottom - 1),
        Point(TabRect.Left + 1, TabRect.Top + 2),
        Point(TabRect.Left + 3, TabRect.Top + 1),
        Point(TabRect.Right - 4, TabRect.Top + 1),
        Point(TabRect.Right - 2, TabRect.Top + 2),
        Point(TabRect.Right - 2, TabRect.Bottom - 1)
      ]);
    end;
  end;
end;

procedure TNxTabControl.RefreshButton(const Index: Integer);
var
  ButtonRect: TRect;
begin
  ButtonRect := GetButtonRect(Index);
  InvalidateRect(Handle, @ButtonRect, True);
end;

procedure TNxTabControl.ShowButtonHint(Button: TNxPalleteButton);
var
  X, Y: Integer;
  HintRect: TRect;
  MousePoint: TPoint;
begin
  if Assigned(Button) and (Button.ShowHint) and (Length(Button.Hint) > 0) then
  begin
    FHintTimer.Enabled := False;
    HintRect := FHintWindow.CalcHintRect(ClientWidth, Button.Hint, nil);
    with GetButtonRect(Button.Index) do
    begin
      X := Left;
      Y := Bottom;
    end;
    MousePoint := ClientToScreen(Point(X, Y));
    OffsetRect(HintRect, MousePoint.X, MousePoint.Y);
    FHintWindow.ActivateHint(HintRect, Button.Hint);
    FHintHideTimer.Enabled := True;
  end;
end;

procedure TNxTabControl.SetActiveIndex(const Value: Integer);
begin
  FActiveIndex := Value;
end;

procedure TNxTabControl.SetBackgroundStyle(const Value: TTabsBackgroundStyle);
begin
  FBackgroundStyle := Value;
  Invalidate;
end;

procedure TNxTabControl.SetButtonHeight(const Value: Integer);
begin
  FButtonHeight := Value;
  Invalidate;
end;

procedure TNxTabControl.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;
end;

procedure TNxTabControl.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

procedure TNxTabControl.SetLeftIndent(const Value: Integer);
begin
  FLeftIndent := Value;
  Invalidate;
end;

procedure TNxTabControl.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Invalidate;
end;

procedure TNxTabControl.SetTabHeight(const Value: Integer);
begin
  FTabHeight := Value;
  Invalidate;
end;

procedure TNxTabControl.SetTopIndent(const Value: Integer);
begin
  FTopIndent := Value;
  Invalidate;
end;

function TNxTabControl.TabExist(const Index: Integer): Boolean;
begin
  Result := (Count > 0) and InRange(Index, 0, Pred(Count));
end;

procedure TNxTabControl.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

end.
