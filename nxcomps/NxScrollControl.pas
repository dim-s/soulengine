{$R NxCommonRes.res}

unit NxScrollControl;

interface

uses
  Windows, Messages, Classes, Controls, Graphics, SysUtils, ExtCtrls, Forms,
  NxFlyoutControl, NxThemesSupport;

const
  crRoll = 4003;
  crRollUp = 4004;
  crRollDown = 4005;
  siBorderSize = 2;
  inDelayTimer = 300;
  inIncrementTimer = 50;

type
  TButtonState = set of (tsHover, tsPushed);
  TScrollBarKind = (skHorizontal, skVertical);
  TScrollBarPart = (spBackground, spThumb);
  TScrollBarState = set of (bsNormal, bsPushed);
  TScrollKind = (rkIdle, rkLine, rkPage, rkThumb, rkTopBottom);
  TRollDirection = set of (rdUp, rdDown);
  TNxScrollStyle = set of (rsRoll);
  TViewState = set of (vsRolling);

  TScrollEvent = procedure (Sender: TObject; Position: Integer) of object;

  TNxCustomScrollControl = class;
  TNxScrollControl = class;

  TContainerControl = class(TWinControl);

  TNxCustomScrollBar = class(TPersistent)
  private
    FAutoHide: Boolean;
    FManualScroll: Boolean;
    FBarFlag: Integer;
    FCanvas: TCanvas;
    FEnabled: Boolean;
    FKind: TScrollBarKind;
    FLargeChange: Integer;
    FMax: Integer;
    FMin: Integer;
    FOldPosition: Integer;
    FOwner: TNxCustomScrollControl;
    FPageSize: Integer;
    FPosition: Integer;
    FSmallChange: Integer;
    FScrollKind: TScrollKind;
    FUpdateCount: Integer;
    FVisible: Boolean;
    IsUpdating: Boolean;
    procedure SetAutoHide(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetKind(const Value: TScrollBarKind);
    procedure SetMax(const Value: Integer);
    procedure SetMin(const Value: Integer);
    procedure SetPageSize(const Value: Integer);
    procedure SetPosition(const Value: Integer);
    procedure SetManualScroll(const Value: Boolean);
  protected
    procedure SetVisible(const Value: Boolean); virtual;
    procedure UpdateScrollBar; virtual;
  public
    constructor Create(AOwnerScrollView: TNxCustomScrollControl;
      ACanvas: TCanvas); virtual;
    destructor Destroy; override;
    function IsFirst: Boolean;
    function IsLast: Boolean;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Expand(Shrink: Boolean = False);
    procedure First;
    procedure Last;
    procedure MoveBy(Distance: Integer);
    procedure Next;
    procedure Prior;
    procedure PageDown; virtual;
    procedure PageUp; virtual;
    property AutoHide: Boolean read FAutoHide write SetAutoHide;
    property BarFlag: Integer read FBarFlag;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Kind: TScrollBarKind read FKind write SetKind;
    property LargeChange: Integer read FLargeChange write FLargeChange;
    property ManualScroll: Boolean read FManualScroll write SetManualScroll;
    property Max: Integer read FMax write SetMax;
    property Min: Integer read FMin write SetMin;
		property OldPosition: Integer read FOldPosition;
    property PageSize: Integer read FPageSize write SetPageSize;
    property Position: Integer read FPosition write SetPosition;
    property ScrollKind: TScrollKind read FScrollKind;
    property SmallChange: Integer read FSmallChange write FSmallChange;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TScrollButtonKind = (bkBack, bkForward);
  TScrollBarArea = (saBackBtn, saThumb, saForwardBtn);
  TScrollingStep = (spLineUp, spLineDown, spPageUp, spPageDown);

  TNxVertScrollBar = class(TNxCustomScrollBar)
  private
    FBackBtnState: TButtonState;
    FClientRect: TRect;
    FForwardBtnState: TButtonState;
    FHeight: Integer;
    FLeft: Integer;
    FThumbState: TButtonState;
    FTop: Integer;
    FWidth: Integer;
    function GetButtonRect(Kind: TScrollButtonKind): TRect;
    function GetPageDownRect: TRect;
    function GetPageUpRect: TRect;
    function GetThumbRect: TRect;
    function GetInnerHeight: Integer;
    function GetThumbMoving: Boolean;
  protected
    procedure MouseLeave;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure Paint; virtual;
    procedure PaintBackground(ARect: TRect; Pushed: Boolean); virtual;
    procedure PaintButton(Rect: TRect; Kind: TScrollButtonKind); virtual;
    procedure PaintThumb; virtual;
    procedure Refresh(Area: TScrollBarArea);
    procedure GetPosition(X, Y: Integer);
    procedure UpdateScrollBar; override;
  public
    constructor Create(AOwner: TNxCustomScrollControl;
      ACanvas: TCanvas); override;
    function GetButtonSize: Integer; virtual;
    function GetBoundsRect: TRect; virtual;
    function GetClientRect: TRect; virtual;
    procedure PageDown; override;
    procedure PageUp; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); virtual;
    property ClientRect: TRect read FClientRect;
    property InnerHeight: Integer read GetInnerHeight;
    property ThumbMoving: Boolean read GetThumbMoving;
  end;

  TNxScrollBar = class(TNxCustomScrollBar)
  protected
    procedure SetVisible(const Value: Boolean); override;
  public
    procedure UpdateScrollBar; override;
  end;

  TNxCustomScrollControl = class(TCustomControl)
  private
    FHorzScrollClipRect: TRect;
    FMouseEnteredControl: Boolean;
    FVertScrollClipRect: TRect;
  protected
    function GetHorzOffset(FromPos, ToPos: Integer): Integer; virtual;
    function GetVertOffset(FromPos, ToPos: Integer): Integer; virtual;
  	procedure AfterScroll(ScrollBarKind: TScrollBarKind); virtual;
  	procedure BeforeScroll(ScrollBarKind: TScrollBarKind); virtual;
    procedure TryFocus;
    procedure SelectNextControl;
    procedure SelectPrevControl; 
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ScrollContent(Bar: TNxCustomScrollBar; DeltaX, DeltaY: Integer); virtual;
    property HorzScrollClipRect: TRect read FHorzScrollClipRect write FHorzScrollClipRect;
    property VertScrollClipRect: TRect read FVertScrollClipRect write FVertScrollClipRect;
  end;

  TScrollDirection = (sdIdle, sdLineUp, sdLineDown, sdPageUp, sdPageDown);

  TNxControl = class(TNxCustomScrollControl)
  private
    FDelayTimer: TTimer;
    FHorzScrollBar: TNxVertScrollBar;
    FIncrementTimer: TTimer;
    FVertScrollBar: TNxVertScrollBar;
    FVertScrollDirection: TScrollDirection;
    FVertThumbDown: Boolean;
    function GetControlRect: TRect;
    function GetControlHeight: Integer;
    function GetControlWidth: Integer;
    procedure SetVertScrollBar(const Value: TNxVertScrollBar);
  protected
    function GetVertScrollBarRect: TRect;
    procedure DrawBorder; virtual;                    
    procedure DoDelayTimer(Sender: TObject); dynamic;
    procedure DoIncrementTimer(Sender: TObject); dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
	  procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public                
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ControlHeight: Integer read GetControlHeight;
    property ControlRect: TRect read GetControlRect;
    property ControlWidth: Integer read GetControlWidth;
    property VertScrollBar: TNxVertScrollBar read FVertScrollBar write SetVertScrollBar;
  end;

  TNxScrollControl = class(TNxCustomScrollControl)
  private
    FHorzScrollBar: TNxScrollBar;
    FMouseWheelEnabled: Boolean;
    FOnHorizontalScroll: TScrollEvent;
    FOnVerticalScroll: TScrollEvent;
    FRollDirection: TRollDirection;
    FRollPoint: TPoint;
    FRollShadow: TRollShadow;
    FRollTimer: TTimer;
    FScrollStyle: TNxScrollStyle;
    FVertScrollBar: TNxScrollBar;
    FViewState: TViewState;
    procedure SetHorzScrollBar(Value: TNxScrollBar);
    procedure SetVertScrollBar(Value: TNxScrollBar);
    procedure SetViewState(const Value: TViewState);
    procedure SetRollDirection(const Value: TRollDirection);
    procedure SetScrollStyle(const Value: TNxScrollStyle);
  protected
    function GetRealScrollPosition(ScrollBar: TNxCustomScrollBar): Integer;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DoRollTimer(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    property ViewState: TViewState read FViewState write SetViewState;
    property RollDirection: TRollDirection read FRollDirection write SetRollDirection;
    property ScrollStyle: TNxScrollStyle read FScrollStyle write SetScrollStyle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Color;
    property HorzScrollBar: TNxScrollBar read FHorzScrollBar write SetHorzScrollBar;
    property HorzScrollClipRect;
    property VertScrollClipRect;
    property VertScrollBar: TNxScrollBar read FVertScrollBar write SetVertScrollBar;
    property OnHorizontalScroll: TScrollEvent read FOnHorizontalScroll write FOnHorizontalScroll;
    property OnVerticalScroll: TScrollEvent read FOnVerticalScroll write FOnVerticalScroll;
  published
    property MouseWheelEnabled: Boolean read FMouseWheelEnabled write FMouseWheelEnabled default True;
  end;

implementation

uses
  Dialogs, Types, Math;

const
  MM_MOUSEENTER = WM_USER + 1;
  MM_MOUSELEAVE = WM_USER + 2;
  TME_NONCLIENT = $10;

{ TNxCustomScrollBar }

constructor TNxCustomScrollBar.Create(AOwnerScrollView: TNxCustomScrollControl;
  ACanvas: TCanvas);
begin
  FAutoHide := True;
  FBarFlag := -1; { SB_HORZ or SB_VERT }
  FOwner := AOwnerScrollView;
  FCanvas := ACanvas;
  FEnabled := True;
  FLargeChange := 1;
  FManualScroll := False;
  FMax := 0;
  FMin := 0;
  FPosition := 0;
  FSmallChange := 1;
  FUpdateCount := 0;
  FVisible := False;
  IsUpdating := False;
end;

destructor TNxCustomScrollBar.Destroy;
begin
  inherited;
end;

procedure TNxCustomScrollBar.SetAutoHide(const Value: Boolean);
begin
  FAutoHide := Value;
  Visible := not(Max = 0) or not AutoHide;
  UpdateScrollBar;
end;

procedure TNxCustomScrollBar.SetEnabled(const Value: Boolean);
const
  Flags: array[Boolean] of DWORD = (ESB_DISABLE_BOTH, ESB_ENABLE_BOTH);
begin
  FEnabled := Value;
  EnableScrollBar(FOwner.Handle, BarFlag, Flags[FEnabled]);
  UpdateScrollBar;
end;

procedure TNxCustomScrollBar.SetKind(const Value: TScrollBarKind);
begin
  FKind := Value;
  case FKind of
    skHorizontal: FBarFlag := SB_HORZ;
    skVertical: FBarFlag := SB_VERT;
  end;
end;

procedure TNxCustomScrollBar.SetManualScroll(const Value: Boolean);
begin
  FManualScroll := Value;
end;

procedure TNxCustomScrollBar.SetMax(const Value: Integer);
begin
  if FMax = Value then Exit;
  FMax := Value;
  if FMax < 0 then FMax := 0;
  Visible := (FMax > FPageSize) or not AutoHide;
  UpdateScrollBar;
  { 3/11/07:  when Max is decreased, Position need update and
              control need to be scrolled }
  if FPosition > FMax then Position := FMax;
end;

procedure TNxCustomScrollBar.SetMin(const Value: Integer);
begin
  FMin := Value;
  if FMin < 0 then FMin := 0;
  UpdateScrollBar;
end;

procedure TNxCustomScrollBar.SetPageSize(const Value: Integer);
begin
  if FPageSize <> Value then
  begin
    FPageSize := Value;
    if FPageSize < 1 then FPageSize := 1;
    UpdateScrollBar;
  end;
end;

procedure TNxCustomScrollBar.SetPosition(const Value: Integer);
var
  Delta, Pos: Integer;
begin
  FOldPosition := FPosition;
  Pos := Value;
  if Value > FMax then Pos := FMax;
  if Value < FMin then Pos := FMin;
  if Pos < 0 then Pos := 0; 
  FPosition := Pos;
  UpdateScrollBar;

  { 3/11/07:  Cause a problem when Max is 0 }
  //if FMax = 0 then Exit;
  if FUpdateCount > 0 then Exit;

  if not ManualScroll then
    if Self.Kind = skHorizontal then
    begin
      Delta := TNxCustomScrollControl(FOwner).GetHorzOffset(FOldPosition, FPosition);
      TNxCustomScrollControl(FOwner).ScrollContent(Self, Delta, 0);
    end else
    begin
      Delta := TNxCustomScrollControl(FOwner).GetVertOffset(FOldPosition, FPosition);
      TNxCustomScrollControl(FOwner).ScrollContent(Self, 0, Delta);
    end;
end;

procedure TNxCustomScrollBar.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

procedure TNxCustomScrollBar.Assign(Source: TPersistent);
begin
  if Source is TNxCustomScrollBar then
  begin

  end else inherited Assign(Source);
end;

procedure TNxCustomScrollBar.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TNxCustomScrollBar.EndUpdate;
begin
  Dec(FUpdateCount);
end;

procedure TNxCustomScrollBar.First;
begin
  Position := 0;
end;

procedure TNxCustomScrollBar.Last;
begin
  Position := Max - PageSize + 1;
end;

procedure TNxCustomScrollBar.MoveBy(Distance: Integer);
begin
  Position := Position + Distance;
end;

procedure TNxCustomScrollBar.Next;
begin
	if Max > 0 then
		case Kind of
  	  skHorizontal: SendMessage(FOwner.Handle, WM_HSCROLL, SB_LINERIGHT, 0);
	    skVertical: SendMessage(FOwner.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
	  end;
end;

procedure TNxCustomScrollBar.Prior;
begin
	if Max > 0 then
		case Kind of
	    skHorizontal: SendMessage(FOwner.Handle, WM_HSCROLL, SB_LINELEFT, 0);
	    skVertical: SendMessage(FOwner.Handle, WM_VSCROLL, SB_LINEUP, 0);
	  end;
end;

procedure TNxCustomScrollBar.PageDown;
begin
	if Max > 0 then
		case Kind of
	    skHorizontal: SendMessage(FOwner.Handle, WM_HSCROLL, SB_PAGERIGHT, 0);
	    skVertical: SendMessage(FOwner.Handle, WM_VSCROLL, SB_PAGEDOWN, 0);
	  end;
end;

procedure TNxCustomScrollBar.PageUp;
begin
	if Max > 0 then
		case Kind of
	    skHorizontal: SendMessage(FOwner.Handle, WM_HSCROLL, SB_PAGELEFT, 0);
	    skVertical: SendMessage(FOwner.Handle, WM_VSCROLL, SB_PAGEUP, 0);
	  end;
end;

procedure TNxCustomScrollBar.UpdateScrollBar;
begin

end;

function TNxCustomScrollBar.IsLast: Boolean;
begin
  Result := Position + PageSize >= Max;
end;

function TNxCustomScrollBar.IsFirst: Boolean;
begin
  Result := Position = 0;
end;

procedure TNxCustomScrollBar.Expand;
begin
  if Shrink then Max := Max - 1 else Max := Max + 1;
end;

{ TNxVertScrollBar }

constructor TNxVertScrollBar.Create(AOwner: TNxCustomScrollControl; ACanvas: TCanvas);
begin
  inherited;
  FPageSize := 8;
  FBackBtnState := [];
  FForwardBtnState := [];
end;

function TNxVertScrollBar.GetBoundsRect: TRect;
begin
  Result := Rect(FLeft, FTop, FLeft + FWidth, FTop + FHeight);
end;

function TNxVertScrollBar.GetButtonRect(Kind: TScrollButtonKind): TRect;
begin
  case Kind of
    bkBack: Result := Rect(FLeft, FTop, GetBoundsRect.Right, FTop + GetButtonSize);
    bkForward: Result := Rect(FLeft, GetBoundsRect.Bottom - GetButtonSize, GetBoundsRect.Right, GetBoundsRect.Bottom);
  end;
end;

function TNxVertScrollBar.GetButtonSize: Integer;
begin
  Result := GetSystemMetrics(SM_CXVSCROLL);
end;

function TNxVertScrollBar.GetClientRect: TRect;
begin
  Result := Rect(0, 0, FWidth, FHeight);
end;

function TNxVertScrollBar.GetInnerHeight: Integer;
begin
  Result := FHeight - GetButtonSize * 2;
//  Dec(Result, 2);
end;

{function TNxVertScrollBar.GetInnerRect: TRect;
begin
  Result := FClientRect;
  InflateRect(Result, 0, -GetButtonSize);
end;}

function TNxVertScrollBar.GetPageDownRect: TRect;
begin
  with Result do
  begin
    Top := GetThumbRect.Bottom;
    Left := FLeft;
    Right := FLeft + FWidth;
    Bottom := GetButtonRect(bkForward).Top;
  end;
end;

function TNxVertScrollBar.GetPageUpRect: TRect;
begin
  with Result do
  begin
    Top := GetButtonRect(bkBack).Bottom;
    Left := FLeft;
    Right := FLeft + FWidth;
    Bottom := GetThumbRect.Top;
  end;
end;

function TNxVertScrollBar.GetThumbRect: TRect;
var
  Pos: Integer;
  Step: Double;
begin
  if Max > 0 then
  begin
    Step := (InnerHeight - PageSize) / Max;
    Pos := Round(Step * Position);
    Inc(Pos, GetButtonSize);
    Inc(Pos, 2);
    Result := Rect(FLeft, Pos, FLeft + FWidth, Pos + PageSize);
  end;
end;

function TNxVertScrollBar.GetThumbMoving: Boolean;
begin
  Result := tsPushed in FThumbState;
end;

procedure TNxVertScrollBar.MouseLeave;
begin
  if tsHover in FBackBtnState then
  begin
    Exclude(FBackBtnState, tsHover);
    Refresh(saBackBtn);
  end;
  if tsHover in FForwardBtnState then
  begin
    Exclude(FForwardBtnState, tsHover);
    Refresh(saForwardBtn);
  end;
  if tsHover in FThumbState then
  begin
    Exclude(FThumbState, tsHover);
    Refresh(saThumb);
  end;
end;

procedure TNxVertScrollBar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if PtInRect(GetButtonRect(bkBack), Point(X, Y)) then
  begin
    if not(tsHover in FBackBtnState) then
    begin
      Include(FBackBtnState, tsHover);
      Refresh(saBackBtn);
    end;
  end else
  begin
    if tsHover in FBackBtnState then
    begin
      Exclude(FBackBtnState, tsHover);
      Refresh(saBackBtn);
    end;
  end;

  if PtInRect(GetButtonRect(bkForward), Point(X, Y)) then
  begin
    if not(tsHover in FForwardBtnState) then
    begin
      Include(FForwardBtnState, tsHover);
      Refresh(saForwardBtn);
    end;
  end else
  begin
    if tsHover in FForwardBtnState then
    begin
      Exclude(FForwardBtnState, tsHover);
      Refresh(saForwardBtn);
    end;
  end;

  if PtInRect(GetThumbRect, Point(X, Y)) then
  begin
    if not(tsHover in FThumbState) then
    begin
      Include(FThumbState, tsHover);
      Refresh(saThumb);
    end;
  end else
  begin
    if tsHover in FThumbState then
    begin
      Exclude(FThumbState, tsHover);
      Refresh(saThumb);
    end;
  end;

  if tsPushed in FThumbState then
  begin
    GetPosition(X, Y - (2 + GetButtonSize));
  end;
end;

procedure TNxVertScrollBar.Paint;
var
  ThumbRect, BckgRect: TRect;
begin
  if Max > 0 then
  begin
    ThumbRect := GetThumbRect;
    BckgRect := Rect(FLeft, FTop + GetButtonSize, FLeft + FWidth, ThumbRect.Top);
    PaintBackground(BckgRect, False);
    PaintThumb;
    BckgRect := Rect(FLeft, ThumbRect.Bottom, FLeft + FWidth, GetBoundsRect.Bottom - GetButtonSize);
    PaintBackground(BckgRect, False);
  end else
  begin
    PaintBackground(GetBoundsRect, False);
  end;
  PaintButton(GetButtonRect(bkBack), bkBack);
  PaintButton(GetButtonRect(bkForward), bkForward);
end;

procedure TNxVertScrollBar.PaintBackground(ARect: TRect; Pushed: Boolean);
begin
  if IsThemed then
  begin
    ThemeRect(FOwner.Handle, FCanvas.Handle, ARect, teScrollBar, 6, 1);
  end else
  begin
    if Pushed then FCanvas.Brush.Color := cl3DDkShadow
      else FCanvas.Brush.Bitmap := AllocPatternBitmap(clBtnHighlight, clScrollBar);
    FCanvas.FillRect(ARect);
  end;
end;

procedure TNxVertScrollBar.PaintButton(Rect: TRect;
  Kind: TScrollButtonKind);
var
  DrawFlags, State: Integer;
begin
  State := 1;
  DrawFlags := 0;
  if IsThemed then
  begin
    case Kind of
      bkBack:
      begin
        DrawFlags := 1;
        if tsPushed in FBackBtnState then Inc(DrawFlags, 2) else
        if tsHover in FBackBtnState then Inc(DrawFlags);
      end;
      bkForward:
      begin
        DrawFlags := 5;
        if tsPushed in FForwardBtnState then Inc(DrawFlags, 2) else
        if tsHover in FForwardBtnState then Inc(DrawFlags);
      end;
    end;
    ThemeRect(FOwner.Handle, FCanvas.Handle, Rect, teScrollBar, State, DrawFlags);
  end else
  begin
    DrawFlags := DFCS_ADJUSTRECT;
    case Kind of
      bkBack:
      begin
        DrawFlags := DrawFlags or DFCS_SCROLLUP;
        if tsPushed in FBackBtnState then DrawFlags := DrawFlags or DFCS_FLAT;
      end;
      bkForward:
      begin
        DrawFlags := DrawFlags or DFCS_SCROLLDOWN;
        if tsPushed in FForwardBtnState then DrawFlags := DrawFlags or DFCS_FLAT;
      end;
    end;
    if Enabled = False then DrawFlags := DrawFlags or DFCS_INACTIVE;
    DrawFrameControl(FCanvas.Handle, Rect, DFC_SCROLL, DrawFlags);
  end;
end;

procedure TNxVertScrollBar.PaintThumb;
var
  ARect: TRect;
  DrawFlags: Integer;
begin
  ARect := GetThumbRect; 
  if IsThemed then
  begin
    DrawFlags := 1;
    if tsHover in FThumbState then
    begin
      Inc(DrawFlags);
      if tsPushed in FThumbState then Inc(DrawFlags);
    end else
    begin
      if tsPushed in FThumbState then Inc(DrawFlags, 2);
    end;
    ThemeRect(FOwner.Handle, FCanvas.Handle, ARect, teScrollBar, 3, DrawFlags);
    if ARect.Bottom - ARect.Top > 16 then
      ThemeRect(FOwner.Handle, FCanvas.Handle, ARect, teScrollBar, tcHorzGrip, 2);
  end else
  begin
    DrawEdge(FCanvas.Handle, ARect, EDGE_RAISED, BF_RECT or BF_ADJUST);
    FCanvas.Brush.Color := clBtnFace;
    FCanvas.FillRect(ARect);
  end;
end;

procedure TNxVertScrollBar.Refresh(Area: TScrollBarArea);
var
  R: TRect;
begin
  case Area of
    saBackBtn: R := GetButtonRect(bkBack);
    saForwardBtn: R := GetButtonRect(bkForward);
    saThumb: R := GetThumbRect;
  end;
  InvalidateRect(FOwner.Handle, @R, False);
end;

procedure TNxVertScrollBar.GetPosition(X, Y: Integer);
var
  Peak: Double;
begin
  Peak := GetInnerHeight / Max;
  Position := Round(Y / Peak);
end;

procedure TNxVertScrollBar.UpdateScrollBar;
begin
//  Refresh(saThumb);
  FOwner.Invalidate;
end;

procedure TNxVertScrollBar.PageDown;
begin
  Position := Position + LargeChange;
end;

procedure TNxVertScrollBar.PageUp;
begin
  Position := Position - LargeChange;
end;

procedure TNxVertScrollBar.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
end;

{ TNxScrollBar }

procedure TNxScrollBar.SetVisible(const Value: Boolean);
begin
  //to-do: may be done better
  inherited SetVisible(Value);
  Windows.ShowScrollBar(FOwner.Handle, BarFlag, Value);
end;

procedure TNxScrollBar.UpdateScrollBar;
const
  EnableBar: array[Boolean] of DWORD = (ESB_DISABLE_BOTH, ESB_ENABLE_BOTH);
var
  ScrollInfo: TScrollInfo;
  Flags: Integer;
begin
  { Note: While processing a scroll bar message,
    an application should not call ShowScrollBar
    function to hide a scroll bar. }
  if IsUpdating then Exit;
  IsUpdating := True;
  if FOwner.HandleAllocated then
  begin
    ScrollInfo.cbSize := SizeOf(ScrollInfo);
    Flags := SIF_PAGE or SIF_POS or SIF_RANGE;
    if not AutoHide then Flags := Flags or SIF_DISABLENOSCROLL;
    ScrollInfo.nMin := FMin;
    ScrollInfo.nPage := FPageSize;
    ScrollInfo.nMax := FMax;
    ScrollInfo.nPos := FPosition;
    ScrollInfo.nTrackPos := 0;
    ScrollInfo.fMask := Flags;
    { 6/20/07:  Disable scrollbar when control is not enabled. If scrollbar is already
                disabled, it will not be enabled. }
    if FMax > 0 then EnableScrollBar(FOwner.Handle, BarFlag, EnableBar[FOwner.Enabled and FEnabled]);
    SetScrollInfo(FOwner.Handle, BarFlag, ScrollInfo, True);
  end;
  IsUpdating := False;
end;

{ TNxCustomScrollControl }

constructor TNxCustomScrollControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMouseEnteredControl := False;
end;

destructor TNxCustomScrollControl.Destroy;
begin
  inherited Destroy;
end;

procedure TNxCustomScrollControl.AfterScroll(
  ScrollBarKind: TScrollBarKind);
begin

end;

procedure TNxCustomScrollControl.BeforeScroll(
  ScrollBarKind: TScrollBarKind);
begin

end;

function TNxCustomScrollControl.GetHorzOffset(FromPos, ToPos: Integer): Integer;
begin
  Result := 0;
end;

function TNxCustomScrollControl.GetVertOffset(FromPos, ToPos: Integer): Integer;
begin
  Result := 0;
end;

procedure TNxCustomScrollControl.ScrollContent(Bar: TNxCustomScrollBar; DeltaX, DeltaY: Integer);
var
  RepaintRect: TRect;
begin
  BeforeScroll(Bar.Kind);
  if DeltaX <> 0 then
  begin 
    RepaintRect := FHorzScrollClipRect;
    ScrollWindowEx(Handle, DeltaX, DeltaY, nil, @FHorzScrollClipRect, 0, @RepaintRect, SW_INVALIDATE);
  end else
  begin
    RepaintRect := FVertScrollClipRect;
    ScrollWindowEx(Handle, DeltaX, DeltaY, nil, @FVertScrollClipRect, 0, @RepaintRect, SW_INVALIDATE);
  end;
  AfterScroll(Bar.Kind);
end;

procedure TNxCustomScrollControl.TryFocus;
var
  Parent: TCustomForm;
begin
  Parent := GetParentForm(Self);
  if Parent <> nil then Windows.SetFocus(Handle);
end;

procedure TNxCustomScrollControl.SelectNextControl;
begin
  if (Parent is TWinControl) then  
    PostMessage((Parent as TWinControl).Handle, WM_KEYDOWN, VK_TAB, 0);
end;

procedure TNxCustomScrollControl.SelectPrevControl;
begin
  if (Parent is TWinControl) then
  begin
    PostMessage((Parent as TWinControl).Handle, WM_KEYDOWN, VK_SHIFT, 0);
    PostMessage((Parent as TWinControl).Handle, WM_KEYDOWN, VK_TAB, 0);
  end;
end;

{ TNxScrollControl }

constructor TNxScrollControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMouseWheelEnabled := True;
  FHorzScrollBar := TNxScrollBar.Create(Self, nil);
  FVertScrollBar := TNxScrollBar.Create(Self, nil);
  FRollShadow := TRollShadow.Create(Self);
  FRollShadow.Parent := Self;
  FRollShadow.Visible := False;
  FRollTimer := TTimer.Create(Self);
  FRollTimer.Enabled := False;
  FRollTimer.OnTimer := DoRollTimer;
  FRollTimer.Interval := 1;
  FScrollStyle := [rsRoll];
  FHorzScrollBar.Kind := skHorizontal;
  FVertScrollBar.Kind := skVertical;
  FViewState := [];
  Screen.Cursors[crRoll] := LoadCursor(HInstance, 'ROLL');
  Screen.Cursors[crRollUp] := LoadCursor(HInstance, 'ROLLUP');
  Screen.Cursors[crRollDown] := LoadCursor(HInstance, 'ROLLDOWN');
end;

destructor TNxScrollControl.Destroy;
begin
  FRollShadow.Free;
  FRollTimer.Free;
  FHorzScrollBar.Free;
  FVertScrollBar.Free;
  inherited Destroy;
end;

procedure TNxScrollControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style + WS_HSCROLL + WS_VSCROLL + WS_CLIPCHILDREN;
  end;
end;

procedure TNxScrollControl.CreateWnd;
begin
  inherited CreateWnd;
  HorzScrollBar.UpdateScrollBar;
  VertScrollBar.UpdateScrollBar;
end;

procedure TNxScrollControl.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
  FHorzScrollBar.UpdateScrollBar;
  FVertScrollBar.UpdateScrollBar;
end;

procedure TNxScrollControl.DoRollTimer(Sender: TObject);
var
  CursorPoint: TPoint;
  Interval: Integer;
begin
  GetCursorPos(CursorPoint);
  CursorPoint := ScreenToClient(CursorPoint);
  Interval := 100 - Abs(CursorPoint.Y - FRollPoint.Y);
  if Interval > 0 then FRollTimer.Interval := Interval else FRollTimer.Interval := 1; 
  if rdUp in FRollDirection then FVertScrollBar.Prior;
  if rdDown in FRollDirection then FVertScrollBar.Next;
end;

function TNxScrollControl.GetRealScrollPosition(ScrollBar: TNxCustomScrollBar): Integer;
var
  SI: TScrollInfo;
  Code: Integer;
begin
  SI.cbSize := SizeOf(TScrollInfo);
  SI.fMask := SIF_TRACKPOS;
  if ScrollBar.Kind = skVertical then Code := SB_VERT else Code := SB_HORZ;
  GetScrollInfo(Handle, Code, SI);
  Result := SI.nTrackPos;
end;

procedure TNxScrollControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if (Button = mbMiddle) and (rsRoll in ScrollStyle) then
  begin
    Include(FViewState, vsRolling);
		FRollShadow.Cursor := crRoll;
    FRollPoint := Point(X, Y);
    FRollShadow.Position := ClientToScreen(FRollPoint);
    FRollShadow.Visible := True;
		FRollTimer.Enabled := True;
    FRollTimer.Interval := 1;
    SetCaptureControl(Self);
  end;
end;

procedure TNxScrollControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if vsRolling in FViewState then { Do Rolling }
  begin
    FRollDirection := [];
    if Y - FRollPoint.Y < -5 then
		begin
      Screen.Cursor := crRollUp;
      Include(FRollDirection, rdUp);
		end
    else if Y - FRollPoint.Y > 5 then
    begin
      Screen.Cursor := crRollDown;
      Include(FRollDirection, rdDown);
    end else
    begin
      Screen.Cursor := crRoll;
    end;
    FRollShadow.Cursor := Screen.Cursor;
  end;
end;

procedure TNxScrollControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FRollTimer.Enabled := False;
  Exclude(FViewState, vsRolling);
  FRollShadow.Visible := False;
  Screen.Cursor := crDefault;
  ReleaseCapture;
end;

procedure TNxScrollControl.SetHorzScrollBar(Value: TNxScrollBar);
begin
  FHorzScrollBar.Assign(Value);
end;

procedure TNxScrollControl.SetRollDirection(const Value: TRollDirection);
begin
  FRollDirection := Value;
end;

procedure TNxScrollControl.SetScrollStyle(const Value: TNxScrollStyle);
begin
  FScrollStyle := Value;
end;

procedure TNxScrollControl.SetVertScrollBar(Value: TNxScrollBar);
begin
  FVertScrollBar.Assign(Value);
end;

procedure TNxScrollControl.SetViewState(const Value: TViewState);
begin
  FViewState := Value;
end;

procedure TNxScrollControl.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxScrollControl.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TNxScrollControl.WMHScroll(var Message: TWMHScroll);
var
  nScrollPos: integer; // chg-am
begin
	inherited;
  nScrollPos := -MaxInt; // chg-am
  with Message do
  begin
    case ScrollCode of
      SB_LINERIGHT, SB_LINELEFT : FHorzScrollBar.FScrollKind := rkLine;
      SB_PAGELEFT, SB_PAGERIGHT : FHorzScrollBar.FScrollKind := rkPage;
      SB_THUMBPOSITION, SB_THUMBTRACK: FHorzScrollBar.FScrollKind := rkThumb;
      SB_TOP, SB_BOTTOM: FHorzScrollBar.FScrollKind := rkTopBottom;
    end;
    case ScrollCode of
      SB_LINERIGHT: nScrollPos := FHorzScrollBar.Position + FHorzScrollBar.SmallChange;
      SB_LINELEFT: nScrollPos := FHorzScrollBar.Position - FHorzScrollBar.SmallChange;
      SB_PAGELEFT: nScrollPos := FHorzScrollBar.Position - FHorzScrollBar.LargeChange;
      SB_PAGERIGHT: nScrollPos := FHorzScrollBar.Position + FHorzScrollBar.LargeChange;
      SB_THUMBPOSITION: nScrollPos := GetRealScrollPosition(FHorzScrollBar);
      SB_THUMBTRACK: nScrollPos := GetRealScrollPosition(FHorzScrollBar);
      SB_TOP: nScrollPos := 0;
      SB_BOTTOM: nScrollPos := FHorzScrollBar.Max;
    end;
  end;

  if nScrollPos <> -MaxInt then // chg-am: if-then block added
  begin
    if nScrollPos < 1 then nScrollPos := 0;

    if nScrollPos > FHorzScrollBar.Max - FHorzScrollBar.PageSize then
      nScrollPos := FHorzScrollBar.Max - FHorzScrollBar.PageSize + 1;
    FHorzScrollBar.Position := nScrollPos;
  end;

  if Assigned(FOnHorizontalScroll) { event }
    then FOnHorizontalScroll(Self, FHorzScrollBar.Position);
end;

procedure TNxScrollControl.WMVScroll(var Message: TWMVScroll);
var
  nScrollPos: integer; // chg-am
begin
	inherited;
  nScrollPos := -MaxInt; // chg-am
  with Message do
  begin
    case ScrollCode of
      SB_LINEDOWN, SB_LINEUP : FVertScrollBar.FScrollKind := rkLine;
      SB_PAGEUP, SB_PAGEDOWN : FVertScrollBar.FScrollKind := rkPage;
      SB_THUMBPOSITION, SB_THUMBTRACK: FVertScrollBar.FScrollKind := rkThumb;
      SB_TOP, SB_BOTTOM: FVertScrollBar.FScrollKind := rkTopBottom;
    end;
    case ScrollCode of
      SB_LINEDOWN: nScrollPos := VertScrollBar.Position + VertScrollBar.SmallChange;
      SB_LINEUP: nScrollPos := VertScrollBar.Position - VertScrollBar.SmallChange;
      SB_PAGEUP: nScrollPos := VertScrollBar.Position - VertScrollBar.LargeChange;
      SB_PAGEDOWN: nScrollPos := VertScrollBar.Position + VertScrollBar.LargeChange;
      SB_THUMBPOSITION: nScrollPos := GetRealScrollPosition(FVertScrollBar); { Pos is a SmallInt }
      SB_THUMBTRACK: nScrollPos := GetRealScrollPosition(FVertScrollBar);
      SB_TOP: nScrollPos := 0;
      SB_BOTTOM: nScrollPos := VertScrollBar.Max;
    end;
  end;

  if nScrollPos <> -MaxInt then // chg-am: if-then block added
  begin
    if nScrollPos < 1 then nScrollPos := 0;
    if nScrollPos > VertScrollBar.Max - VertScrollBar.PageSize
      then nScrollPos := VertScrollBar.Max - VertScrollBar.PageSize + 1;
    VertScrollBar.Position := nScrollPos;
  end;

  if Assigned(FOnVerticalScroll) { event }
    then FOnVerticalScroll(Self, FVertScrollBar.Position);
end;

function TNxScrollControl.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if FMouseWheelEnabled then Result := True
    else Result := inherited DoMouseWheelDown(Shift, MousePos)
end;

function TNxScrollControl.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if FMouseWheelEnabled then Result := True
    else Result := inherited DoMouseWheelUp(Shift, MousePos)
end;

{ TNxControl }

constructor TNxControl.Create(AOwner: TComponent);
begin
  inherited;
  FDelayTimer := TTimer.Create(Self);
  FDelayTimer.Enabled := False;
  FDelayTimer.Interval := inDelayTimer;
  FDelayTimer.OnTimer := DoDelayTimer;
  FHorzScrollBar := TNxVertScrollBar.Create(Self, Canvas);
  FHorzScrollBar.Kind := skHorizontal;
  FIncrementTimer := TTimer.Create(nil);
  FIncrementTimer.Enabled := False;
  FIncrementTimer.Interval := inIncrementTimer;
  FIncrementTimer.OnTimer := DoIncrementTimer;
  FVertScrollBar := TNxVertScrollBar.Create(Self, Canvas);
  FVertScrollBar.Kind := skVertical;
  FVertScrollDirection := sdIdle;
  FVertThumbDown := False;
end;

destructor TNxControl.Destroy;
begin
  FreeAndNil(FDelayTimer);
  FreeAndNil(FHorzScrollBar);
  FreeAndNil(FIncrementTimer);
  FreeAndNil(FVertScrollBar);
  inherited;
end;

procedure TNxControl.SetVertScrollBar(const Value: TNxVertScrollBar);
begin
  FVertScrollBar.Assign(Value);
end;

function TNxControl.GetControlHeight: Integer;
begin
  Result := ClientHeight;
  Dec(Result, siBorderSize * 2);
end;

function TNxControl.GetControlRect: TRect;
begin
  Result := Rect(siBorderSize, siBorderSize, siBorderSize + ControlWidth, siBorderSize + ControlHeight);
end;

function TNxControl.GetControlWidth: Integer;
begin
  if VertScrollBar.FVisible
    then Result := ClientWidth - GetSystemMetrics(SM_CXVSCROLL)
    else Result := ClientWidth;
  Dec(Result, siBorderSize * 2);
end;

procedure TNxControl.DrawBorder;
var
  Frame: TRect;
begin
  with Canvas do
  begin
    Frame := ClientRect;
    Brush.Color := clBlack;
    FrameRect(Frame);
    InflateRect(Frame, -1, -1);
    Brush.Color := Self.Color;
    FrameRect(Frame);
  end;
end;

procedure TNxControl.DoDelayTimer(Sender: TObject);
begin
  FIncrementTimer.Enabled := True;
end;

procedure TNxControl.DoIncrementTimer(Sender: TObject);
begin
  case FVertScrollDirection of
    sdLineUp: VertScrollBar.Position := VertScrollBar.Position - 1;
    sdLineDown: VertScrollBar.Position := VertScrollBar.Position + 1;
    sdPageUp: VertScrollBar.PageUp;
    sdPageDown: VertScrollBar.PageDown;
  end;
end;

function TNxControl.GetVertScrollBarRect: TRect;
var
  Right: Integer;
begin
  Right := GetControlRect.Right;
  Result := Rect(Right, GetControlRect.Top, Right
  + VertScrollBar.GetButtonSize, ControlHeight + siBorderSize);
end;

procedure TNxControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if PtInRect(VertScrollBar.GetButtonRect(bkForward), Point(X, Y)) then
  begin
    Include(VertScrollBar.FForwardBtnState, tsPushed);
    VertScrollBar.Position := VertScrollBar.Position + 1;
    VertScrollBar.Refresh(saForwardBtn);
    FVertScrollDirection := sdLineDown;
    FDelayTimer.Enabled := True;
  end;

  if PtInRect(VertScrollBar.GetButtonRect(bkBack), Point(X, Y)) then
  begin
    Include(VertScrollBar.FBackBtnState, tsPushed);
    VertScrollBar.Position := VertScrollBar.Position - 1;
    VertScrollBar.Refresh(saBackBtn);
    FVertScrollDirection := sdLineUp;
    FDelayTimer.Enabled := True;
  end;

  if PtInRect(VertScrollBar.GetPageDownRect, Point(X, Y)) then
  begin
    VertScrollBar.PageDown;
    FVertScrollDirection := sdPageDown;
    FDelayTimer.Enabled := True;
  end;

  if PtInRect(VertScrollBar.GetPageUpRect, Point(X, Y)) then
  begin
    VertScrollBar.PageUp;
    FVertScrollDirection := sdPageUp;
    FDelayTimer.Enabled := True;
  end;

  if VertScrollBar.Max > 0 then
  if PtInRect(VertScrollBar.GetThumbRect, Point(X, Y)) then
  begin
    Include(VertScrollBar.FThumbState, tsPushed);
  end;
end;

procedure TNxControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if PtInRect(GetVertScrollBarRect, Point(X, Y)) or VertScrollBar.ThumbMoving then
    VertScrollBar.MouseMove(Shift, X, Y) else VertScrollBar.MouseLeave;
end;

procedure TNxControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  Exclude(VertScrollBar.FBackBtnState, tsPushed);
  Exclude(VertScrollBar.FForwardBtnState, tsPushed);
  Exclude(VertScrollBar.FThumbState, tsPushed);
  FVertScrollDirection := sdIdle;

  FVertThumbDown := False;
  FDelayTimer.Enabled := False;
  FIncrementTimer.Enabled := False;
  Invalidate;
end;

procedure TNxControl.Paint;
begin
  inherited;
  DrawBorder;
  if VertScrollBar.FVisible then VertScrollBar.Paint;
end;

procedure TNxControl.CMMouseLeave(var Message: TMessage);
begin
  VertScrollBar.MouseLeave;
end;

end.
