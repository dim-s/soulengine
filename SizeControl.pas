unit SizeControl;

(* ---------------------------------------------------------------------------
Component Name:  TSizeCtrl
Module:          SizeControl
Description:     Enables both moving and resizing of controls at runtime.
Version:         8.0 DS
Date:            19-SEP-2012
Author:          Dmitriy Zayceff, Angus Johnson, angusj-AT-myrealbox-DOT-com
Copyright:       © 1997-2006 Angus Johnson, 2009-2013 Dmitriy Zayceff
 --------------------------------------------------------------------------- *)

interface

//{$R SIZECONTROL}

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls,
  Graphics, Forms, TypInfo, Menus, StdCtrls, ComCtrls, Dialogs;

function getAbsoluteX(cntrl: TControl; LastControl: TControl): integer;
function getAbsoluteY(cntrl: TControl; LastControl: TControl): integer;

type
  TSizeCtrl = class;
  TTargetObj = class;

  TBtnPos = (bpLeft, bpTopLeft, bpTop, bpTopRight,
    bpRight, bpBottomRight, bpBottom, bpBottomLeft);
  TBtnPosSet = set of TBtnPos;

  TSCState = (scsReady, scsMoving, scsSizing);

  TStartEndEvent = procedure(Sender: TObject; State: TSCState) of object;
  TDuringEvent = procedure(Sender: TObject; dx, dy: integer; State: TSCState) of object;
  TMouseDownEvent = procedure(Sender: TObject; Target: TControl;
    TargetPt: TPoint; var handled: boolean) of object;
  TSetCursorEvent = procedure(Sender: TObject; Target: TControl;
    TargetPt: TPoint; var handled: boolean) of object;

  TContextPopupEvent = procedure(Sender: TObject; MousePos: TPoint;
    var Handled: boolean) of object;

  //TSizeBtn is used internally by TSizeCtrl.
  //There are 8 TSizeBtns for each target which are the target's resize handles.
  TSizeBtn = class(TCustomControl)
  private
    fTargetObj: TTargetObj;
    fPos: TBtnPos;
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateBtnCursorAndColor;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
  public
    constructor Create(TargetObj: TTargetObj; BtnPos: TBtnPos);
 {$IFNDEF VER100} reintroduce; {$ENDIF}
  end;

  TMovePanel = class(TCustomControl)
  private
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


  //TRegisteredObj is used internally by TSizeCtrl. Each TRegisteredObj
  //contains info about a possible target control.
  TRegisteredObj = class
    fSizeCtrl: TSizeCtrl; //the owner of TRegisteredObj
    fControl: TControl;
    fHooked: boolean;
    fOldWindowProc: TWndMethod;
    fOldClickMethod: TMethod;
    procedure Hook;
    procedure UnHook;
    procedure NewWindowProc(var Msg: TMessage);
  public
    constructor Create(aSizeCtrl: TSizeCtrl; aControl: TControl);
 {$IFNDEF VER100} reintroduce; {$ENDIF}
    destructor Destroy; override;
  end;

  //TTargetObj is the container for each current target, and contains the 8
  //TSizeBtn objects. Any number of TTargetObj's can be contained by TSizeCtrl.
  TTargetObj = class
  private
    fSizeCtrl: TSizeCtrl; //the owner of TTargetObj
    fTarget: TControl;
    fPanels: TList;
    fPanelsNames: TStrings;
    fBtns: array [TBtnPos] of TSizeBtn;
    fFocusRect: TRect;
    fLastRect: TRect;
    fStartRec: TRect;
    procedure Hide;
    procedure Show;
    procedure Update;
    procedure StartFocus();
    function MoveFocus(dx, dy: integer): boolean;
    function SizeFocus(dx, dy: integer; BtnPos: TBtnPos): boolean;
    procedure EndFocus;
    procedure DrawRect(dc: hDC; obj: TControl);
  public
    constructor Create(aSizeCtrl: TSizeCtrl; aTarget: TControl);
 {$IFNDEF VER100} reintroduce; {$ENDIF}
    destructor Destroy; override;
  end;

  TSizeCtrl = class(TComponent)
  private
    fTargetList: TList; //list of TTargetObj (current targets)
    fRegList: TList;    //list of TRegisteredObj (possible targets)
    fState: TSCState;
    fMoveOnly: boolean;
    fClipRec: TRect;
    fStartPt: TPoint;
    fEnabledBtnColor: TColor;
    fDisabledBtnColor: TColor;
    fValidBtns: TBtnPosSet;
    fMultiResize: boolean;
    fEnabled: boolean;
    fCapturedCtrl: TControl;
    fCapturedBtnPos: TBtnPos;
    fGridSize: integer;
    fOldWindowProc: TWndMethod;
    fEscCancelled: boolean;
    fParentForm: TCustomForm;
    fHandle: THandle;
    fPopupMenu: TPopupMenu;
    fOnContextPopup: TContextPopupEvent;
    fLMouseDownPending: boolean;
    fForm: TWinControl;

    fStartEvent: TStartEndEvent;
    fDuringEvent: TDuringEvent;
    fEndEvent: TStartEndEvent;
    fTargetChangeEvent: TNotifyEvent;
    fOnMouseDown: TMouseDownEvent;
    fOnMouseEnter: TMouseDownEvent;
    fOnSetCursor: TSetCursorEvent;
    fOnKeyDown: TKeyEvent;
    FShowGrid: boolean;
    FgetSelected: TList;

    function GetTargets(index: integer): TControl;
    function GetTargetCount: integer;

    procedure SetEnabled(Value: boolean);
    procedure WinProc(var Msg: TMessage);
    procedure FormWindowProc(var Msg: TMessage);
    procedure DoWindowProc(DefaultProc: TWndMethod; var Msg: TMessage);

    procedure DrawRect;
    procedure SetMoveOnly(Value: boolean);
    function IsValidSizeBtn(BtnPos: TBtnPos): boolean;
    function IsValidMove: boolean;
    procedure SetMultiResize(Value: boolean);
    procedure SetPopupMenu(Value: TPopupMenu);
    procedure DoPopupMenuStuff;
    procedure SetEnabledBtnColor(aColor: TColor);
    procedure SetDisabledBtnColor(aColor: TColor);

    function RegisteredCtrlFromPt(screenPt: TPoint;
      ParentX: TWinControl = nil): TControl;

    procedure DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState);
    procedure DoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState);
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState);
    procedure SetShowGrid(const Value: boolean);
    procedure SetgetSelected(const Value: TList);
  protected
    fGrid: TBitmap; // сетка
    fImage: TImage;
    lastW: integer;
    lastH: integer; // последн€€ ширина и высота формы
    lastColor: TColor; // последний цвет формы
    procedure Hide;
    procedure Show;
    procedure UpdateBtnCursors;
    procedure MoveTargets(dx, dy: integer);
    procedure SizeTargets(dx, dy: integer);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function DoKeyDown(var Message: TWMKey): boolean;

    procedure formPaint(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //Update: it is the responsibility of the component user to call Update
    //if the target(s) are moved or resized independently of this control
    //(eg if the form is resized and targets are aligned with it.)
    procedure Update;
    procedure UpdateBtns;

    procedure toFront(CNTR: TControl);
    procedure toBack(CNTR: TControl);

    //RegisterControl: Register potential target controls with TSizeCtrl
    function RegisterControl(Control: TControl): integer;
    procedure UnRegisterControl(Control: TControl);
    procedure UnRegisterAll;
    function RegisteredIndex(Control: TControl): integer;

    function getRegObj(C: TComponent): TRegisteredObj;

    //AddTarget: Add any number of targets to TSizeCtrl so they can be
    //resized or moved together.
    //(nb: The programmer doesn't normally need to call this method directly
    //since TSizeCtrl will call it whenever a target is clicked.)
    function AddTarget(Control: TControl): integer;
    function getSelected(): TList;

    procedure DeleteTarget(Control: TControl);
    procedure ClearTargets;
    function TargetIndex(Control: TControl): integer;
    function TargetCtrlFromPt(screenPt: TPoint): TControl;

    //Enabled: This key property should be self-explanatory.
    property Enabled: boolean read fEnabled write SetEnabled;

    //Targets: used to access individual targets (read-only)
    property Targets[index: integer]: TControl read GetTargets;
    property TargetCount: integer read GetTargetCount;

  published
    //MoveOnly: ie prevents resizing
    property MoveOnly: boolean read fMoveOnly write SetMoveOnly;
    //BtnColor: Color of grab-handle buttons
    property BtnColor: TColor read fEnabledBtnColor write SetEnabledBtnColor;
    //BtnColorDisabled: eg grab buttons along aligned edges of target controls
    property BtnColorDisabled: TColor read fDisabledBtnColor write SetDisabledBtnColor;

    property ShowGrid: boolean read FShowGrid write SetShowGrid;
    //GridSize: aligns mouse moved/resized controls to nearest grid dimensions
    property GridSize: integer read fGridSize write fGridSize;
    //MultiTargetResize: Resizing of multiple targets is allowed by default
    //as long as this isn't impeded by specific Target control alignments
    property MultiTargetResize: boolean read fMultiResize write SetMultiResize;

    property PopupMenu: TPopupMenu read fPopupMenu write SetPopupMenu;
    //Self-explanatory Events ...
    property OnStartSizeMove: TStartEndEvent read fStartEvent write fStartEvent;
    property OnDuringSizeMove: TDuringEvent read fDuringEvent write fDuringEvent;
    property OnEndSizeMove: TStartEndEvent read fEndEvent write fEndEvent;
    property OnTargetChange: TNotifyEvent read fTargetChangeEvent
      write fTargetChangeEvent;
    property OnKeyDown: TKeyEvent read fOnKeyDown write fOnKeyDown;
    property OnMouseDown: TMouseDownEvent read fOnMouseDown write fOnMouseDown;
    property OnMouseEnter: TMouseDownEvent read fOnMouseEnter write fOnMouseEnter;
    property OnSetCursor: TSetCursorEvent read fOnSetCursor write fOnSetCursor;
    property OnContextPopup: TContextPopupEvent
      read fOnContextPopup write fOnContextPopup;
  end;

const
  BTNSIZE = 5;
  MINWIDTH = 0;   //minimum target width   (could make this a property later)
  MINHEIGHT = 0;   //minimum target height

  CM_LMOUSEDOWN = WM_USER + $1;
  CM_RMOUSEDOWN = WM_USER + $2;

procedure Register;

implementation

uses Types;

type
  THackedControl = class(TControl);
  THackedWinControl = class(TWinControl);

procedure Register;
begin
  RegisterComponents('Samples', [TSizeCtrl]);
end;

{$IFDEF VER100} type
  TAlignSet = set of TAlign; {$ENDIF}


//turn warnings off concerning unsafe typecasts since we know they're safe...
{$WARNINGS OFF}


//------------------------------------------------------------------------------
// Miscellaneous functions
//------------------------------------------------------------------------------

function getAbsoluteX(cntrl: TControl; LastControl: TControl): integer;
begin
  Result := cntrl.Left;

  if integer(cntrl.Parent) <> integer(LastControl) then
    Result := Result + getAbsoluteX(cntrl.Parent, LastControl);
end;

function getAbsoluteY(cntrl: TControl; LastControl: TControl): integer;
begin
  Result := cntrl.top;

  if integer(cntrl.Parent) <> integer(LastControl) then
    Result := Result + getAbsoluteY(cntrl.Parent, LastControl);
end;

function max(int1, int2: integer): integer;
begin
  if int1 > int2 then
    Result := int1
  else
    Result := int2;
end;
//------------------------------------------------------------------------------

function IsVisible(Control: TControl): boolean;
begin
  Result := True;
  while assigned(Control) do
    if Control is TCustomForm then
      exit
    else if not Control.Visible then
      break
    else
      Control := Control.Parent;
  Result := False;
end;
//------------------------------------------------------------------------------

function GetBoundsAsScreenRect(Control: TControl): TRect;
begin
  //GetBoundsAsScreenRect() assumes 'Control' is both assigned and has a parent.
  //Not all TControls have handles (ie only TWinControls) so ...
  with Control do
  begin
    Result.TopLeft := parent.ClientToScreen(BoundsRect.TopLeft);
    Result.Right := Result.Left + Width;
    Result.Bottom := Result.Top + Height;
  end;
end;
//------------------------------------------------------------------------------

function PointIsInControl(screenPt: TPoint; Control: TControl): boolean;
begin
  //PointIsInControl() assumes 'Control' is both assigned and has a parent.
  Result := PtInRect(GetBoundsAsScreenRect(Control), screenPt);
end;
//------------------------------------------------------------------------------

//-----------------------------------------------------------------------

function ShiftKeyIsPressed: boolean;
begin
  Result := GetKeyState(VK_SHIFT) < 0;
end;
//-----------------------------------------------------------------------

function CtrlKeyIsPressed: boolean;
begin
  Result := GetKeyState(VK_CONTROL) < 0;
end;


function AltKeyIsPressed: boolean;
begin
  Result := GetKeyState(VK_MENU) < 0;
end;


procedure AlignToGrid(Ctrl: TControl; ProposedBoundsRect: TRect; GridSize: integer);
begin
  //AlignToGrid() assumes 'Control' is assigned.
  if (GridSize > 1) and (not AltKeyIsPressed) then
  begin
    //simplify rounding ...
    //OffsetRect(ProposedBoundsRect,GridSize div 2, GridSize div 2);
    {dec(ProposedBoundsRect.Left, abs(ProposedBoundsRect.Left mod GridSize));
    dec(ProposedBoundsRect.Top, abs(ProposedBoundsRect.Top mod GridSize));
    dec(ProposedBoundsRect.Right, ProposedBoundsRect.Right mod GridSize);
    dec(ProposedBoundsRect.Bottom, ProposedBoundsRect.Bottom mod GridSize);}
  end;

  with ProposedBoundsRect do
    Ctrl.SetBounds(left, top, right, bottom);
end;

//------------------------------------------------------------------------------
// TRegisteredObj functions
//------------------------------------------------------------------------------

constructor TRegisteredObj.Create(aSizeCtrl: TSizeCtrl; aControl: TControl);
begin
  inherited Create;
  fSizeCtrl := aSizeCtrl;
  fControl := aControl;


  if fSizeCtrl.Enabled then
    Hook;
end;
//------------------------------------------------------------------------------

destructor TRegisteredObj.Destroy;
begin
  UnHook;
  inherited Destroy;
end;
//------------------------------------------------------------------------------

procedure TRegisteredObj.Hook;
var
  meth: TMethod;
begin
  if fHooked then
    exit;

  if fControl is TTabSheet then
    exit;

  fOldWindowProc := fControl.WindowProc;
  fControl.WindowProc := NewWindowProc;

  //The following is needed to block OnClick events when TSizeCtrl is enabled.
  //(If compiling with Delphi 3, you'll need to block OnClick events manually.)
  {$IFNDEF VER100}
  if IsPublishedProp(fControl, 'OnClick') then
  begin
    meth := GetMethodProp(fControl, 'OnClick');
    fOldClickMethod.Code := meth.Code;
    fOldClickMethod.Data := meth.Data;

    meth.Code := nil;
    meth.Data := nil;
    SetMethodProp(fControl, 'OnClick', meth);
  end;
  {$ENDIF}

  fHooked := True;
end;
//------------------------------------------------------------------------------

procedure TRegisteredObj.UnHook;
var
  meth: TMethod;
begin
  if not fHooked then
    exit;
  if fControl is TTabSheet then
    exit;

  fControl.WindowProc := fOldWindowProc;

  {$IFNDEF VER100}
  try
    if IsPublishedProp(fControl, 'OnClick') then
    begin
      meth.Code := fOldClickMethod.Code;
      meth.Data := fOldClickMethod.Data;
      SetMethodProp(fControl, 'OnClick', meth);
    end;
  except
  end;
  {$ENDIF}

  fHooked := False;
end;
//------------------------------------------------------------------------------

procedure TRegisteredObj.NewWindowProc(var Msg: TMessage);
begin
  fSizeCtrl.DoWindowProc(fOldWindowProc, Msg);
end;

//------------------------------------------------------------------------------
// TSizeBtn methods
//------------------------------------------------------------------------------

constructor TSizeBtn.Create(TargetObj: TTargetObj; BtnPos: TBtnPos);
begin
  inherited Create(nil);
  fTargetObj := TargetObj;
  //Parent := TargetObj.fTarget.Parent;
  fPos := BtnPos;
  Width := BTNSIZE;
  Height := BTNSIZE;
  Visible := False;
  UpdateBtnCursorAndColor;
end;
//------------------------------------------------------------------------------

procedure TSizeBtn.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST;
end;
//------------------------------------------------------------------------------

procedure TSizeBtn.UpdateBtnCursorAndColor;
begin
  if not (fPos in fTargetObj.fSizeCtrl.fValidBtns) or
    fTargetObj.fSizeCtrl.fMoveOnly or (fTargetObj.fTarget.Tag = 2012) then
  begin
    Cursor := crDefault;
    Color := fTargetObj.fSizeCtrl.fDisabledBtnColor;
  end
  else
  begin
    case fPos of
      bpLeft, bpRight: Cursor := crSizeWE;
      bpTop, bpBottom: Cursor := crSizeNS;
      bpTopLeft, bpBottomRight: Cursor := crSizeNWSE;
      bpTopRight, bpBottomLeft: Cursor := crSizeNESW;
    end;
    Color := fTargetObj.fSizeCtrl.fEnabledBtnColor;
  end;
end;
//------------------------------------------------------------------------------

procedure TSizeBtn.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbLeft then
    fTargetObj.fSizeCtrl.DoMouseDown(self, Button, Shift);
end;

procedure TSizeBtn.Paint;
begin
  inherited Paint;
end;

//------------------------------------------------------------------------------
//  TTargetObj methods
//------------------------------------------------------------------------------

constructor TTargetObj.Create(aSizeCtrl: TSizeCtrl; aTarget: TControl);
var
  i: TBtnPos;
begin
  inherited Create;
  fSizeCtrl := aSizeCtrl;
  fTarget := aTarget;
  fPanels := TList.Create;
  fPanelsNames := TStringList.Create;
  for i := low(TBtnPos) to high(TBtnPos) do
    fBtns[i] := TSizeBtn.Create(self, i);
end;
//------------------------------------------------------------------------------

destructor TTargetObj.Destroy;
var
  i: TBtnPos;
  k: integer;
begin
  fPanelsNames.Clear;
  for k := 0 to fPanels.Count - 1 do
    TObject(fPanels[k]).Free();
  fPanels.Clear;

  fPanels.Free;
  fPanelsNames.Free;

  for i := low(TBtnPos) to high(TBtnPos) do
  begin
    if fBtns[i] <> nil then
      fBtns[i].Free;
  end;
  inherited Destroy;
end;
//------------------------------------------------------------------------------

procedure TTargetObj.Hide;
var
  i: TBtnPos;
begin
  for i := low(TBtnPos) to high(TBtnPos) do
    fBtns[i].Visible := False;
  //to avoid the buttons messing up the Size-Move Rect ...
  //if fTarget is TWinControl then fTarget.Refresh
  // else fTarget.Parent.Repaint;
end;
//------------------------------------------------------------------------------

procedure TTargetObj.Show;
var
  i: TBtnPos;
begin
  for i := low(TBtnPos) to high(TBtnPos) do
    fBtns[i].Visible := True;
end;
//------------------------------------------------------------------------------

procedure TTargetObj.Update;
var
  i: TBtnPos;
  parentForm: TCustomForm;
  tl: TPoint;
  bsDiv2: integer;
begin
  parentForm := fSizeCtrl.fParentForm;
  if not assigned(parentForm) then
    exit;

  //get tl of Target relative to parentForm ...
  tl := GetBoundsAsScreenRect(fTarget).TopLeft;
  //tl := fTarget.BoundsRect.TopLeft;
  tl := parentForm.ScreenToClient(tl);
  bsDiv2 := (BTNSIZE div 2);

  for i := low(TBtnPos) to high(TBtnPos) do
  begin
    fBtns[i].ParentWindow := parentForm.Handle; //ie keep btns separate !!!
    fBtns[i].Left := tl.X - bsDiv2;
    case i of
      bpTop, bpBottom:
        fBtns[i].Left := fBtns[i].Left + (fTarget.Width div 2);
      bpRight, bpTopRight, bpBottomRight:
        fBtns[i].Left := fBtns[i].Left + fTarget.Width - 1;
    end;
    fBtns[i].Top := tl.Y - bsDiv2;
    case i of
      bpLeft, bpRight:
        fBtns[i].Top := fBtns[i].Top + (fTarget.Height div 2);
      bpBottomLeft, bpBottom, bpBottomRight:
        fBtns[i].Top := fBtns[i].Top + fTarget.Height - 1;
    end;
    //force btns to the top ...

    SetWindowPos(fBtns[i].Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end;
end;
//------------------------------------------------------------------------------

procedure TTargetObj.StartFocus();
begin

  fFocusRect := fTarget.BoundsRect;

  {fFocusRect.Left := TWinControl(fTarget.owner).Left + getAbsoluteX(fTarget, TWinControl(fTarget.owner));
  fFocusRect.Top  := TWinControl(fTarget.owner).Top  + getAbsoluteY(fTarget,TWinControl(fTarget.Owner));
  fFocusRect.Right := fFocusRect.Left + fTarget.Width;
  fFocusRect.Bottom := fFocusRect.Top + fTarget.Height;

  fFocusRect := GetBoundsAsScreenRect(fTarget);}
  fStartRec := fFocusRect;
end;
//------------------------------------------------------------------------------

function TTargetObj.MoveFocus(dx, dy: integer): boolean;
var
  L, T: integer;
begin
  if fTarget.Tag = 2012 then
    exit;

  L := fFocusRect.Left;
  T := fFocusRect.Top;
  fFocusRect := fStartRec;
  offsetRect(fFocusRect, dx, dy);
  Result := (L <> fFocusRect.Left) or (T <> fFocusRect.Top);
  //Result := False;
end;
//------------------------------------------------------------------------------

function TTargetObj.SizeFocus(dx, dy: integer; BtnPos: TBtnPos): boolean;
var
  L, T, R, B: integer;
begin
  if fTarget.Tag = 2012 then
    exit;

  L := fFocusRect.Left;
  T := fFocusRect.Top;
  R := fFocusRect.Right;
  B := fFocusRect.Bottom;

  fFocusRect := fStartRec;
  case BtnPos of
    bpLeft: Inc(fFocusRect.Left, dx);
    bpTopLeft:
    begin
      Inc(fFocusRect.Left, dx);
      Inc(fFocusRect.Top, dy);
    end;
    bpTop: Inc(fFocusRect.Top, dy);
    bpTopRight:
    begin
      Inc(fFocusRect.Right, dx);
      Inc(fFocusRect.Top, dy);
    end;
    bpRight: Inc(fFocusRect.Right, dx);
    bpBottomRight:
    begin
      Inc(fFocusRect.Right, dx);
      Inc(fFocusRect.Bottom, dy);
    end;
    bpBottom: Inc(fFocusRect.Bottom, dy);
    bpBottomLeft:
    begin
      Inc(fFocusRect.Left, dx);
      Inc(fFocusRect.Bottom, dy);
    end;
  end;
  Result := (L <> fFocusRect.Left) or (R <> fFocusRect.Right) or
    (T <> fFocusRect.Top) or (B <> fFocusRect.Bottom);
  //Result := False;
end;
//------------------------------------------------------------------------------

procedure TTargetObj.EndFocus;
var
  w, h: integer;
begin
  //update target position ...
  //fFocusRect.TopLeft := fTarget.Parent.ScreenToClient(fFocusRect.TopLeft);
  // fFocusRect.BottomRight := fTarget.Parent.ScreenToClient(fFocusRect.BottomRight);

  w := fFocusRect.Right - fFocusRect.Left;
  h := fFocusRect.Bottom - fFocusRect.Top;
  fFocusRect.Left := fTarget.Left - (fStartRec.Left - fFocusRect.Left);
  fFocusRect.Top := fTarget.Top - (fStartRec.Top - fFocusRect.Top);
  fFocusRect.Right := fFocusRect.Left + w;
  fFocusRect.Bottom := fFocusRect.Top + h;

  with fFocusRect do
    AlignToGrid(fTarget, Rect(Left, top, max(MINWIDTH, right - left),
      max(MINHEIGHT, bottom - top)), fSizeCtrl.fGridSize);
  Update;
  fTarget.Invalidate;
end;
//------------------------------------------------------------------------------

procedure TTargetObj.DrawRect(dc: hDC; obj: TControl);
var
  pr: TWinControl;
  //panel: TForm;
  panel: TMovePanel;
  s: string;
  k: integer;
  ts: boolean;
begin
  if fTarget.Tag = 2012 then
    exit;

  fLastRect := fFocusRect;
  pr := obj.Parent;

  s := IntToStr(integer(obj));
  k := Self.fPanelsNames.IndexOf(s);
  ts := False;
  if k > -1 then
    panel := TMovePanel(fPanels[k])
  else
  begin

    panel := TMovePanel.Create(pr);
    panel.Visible := False;
    panel.ParentColor := False;
    panel.Parent := pr;

    {panel.BorderStyle := bsNone;
    panel.ParentColor := false;
    panel.BevelOuter := bvRaised;
    panel.BevelKind := bkFlat;
    panel.BevelInner := bvNone;
    }panel.Color := clBtnFace;

    {panel.AlphaBlend := true;
    panel.FormStyle := fsStayOnTop;
    panel.AlphaBlendValue := 190;
    panel.BorderStyle := bsNone; }

    fPanelsNames.Add(IntToStr(integer(obj)));
    fPanels.Add(panel);
    panel.BringToFront;
    ts := True;
  end;

  panel.Width := fFocusRect.Right - fFocusRect.Left;
  panel.Height := fFocusRect.Bottom - fFocusRect.Top;

  panel.Left := fFocusRect.Left;
  panel.Top := fFocusRect.Top;

  if (ts) then
    panel.Show();

{  if pr is TCustomForm then
    TCustomForm(pr).Canvas.DrawFocusRect(fFocusRect);}
  //  DrawRect(get);
  //frm.Canvas.DrawFocusRect(fFocusRect);
end;

//------------------------------------------------------------------------------
//  TSizeCtrl methods
//------------------------------------------------------------------------------

constructor TSizeCtrl.Create(AOwner: TComponent);
begin
  if not (aOwner is TWinControl) then
    raise Exception.Create('TSizeCtrl.Create: Owner must be a TWinControl');
  inherited Create(AOwner);
  fTargetList := TList.Create;
  fRegList := TList.Create;
  fEnabledBtnColor := clNavy;
  fDisabledBtnColor := clGray;
  fMultiResize := True;
  fValidBtns := [bpLeft, bpTopLeft, bpTop, bpTopRight, bpRight,
    bpBottomRight, bpBottom, bpBottomLeft];
  fHandle := AllocateHWnd(WinProc);
  fForm := TWinControl(AOwner);
  if fForm is TForm then
    TForm(fForm).OnPaint := Self.formPaint;
{$IFDEF VER100}
  screen.Cursors[crSize] := loadcursor(hInstance, 'NSEW');
{$ENDIF}
end;
//------------------------------------------------------------------------------

destructor TSizeCtrl.Destroy;
begin
  if assigned(fTargetList) then
  begin
    DeallocateHWnd(fHandle);
    UnRegisterAll;
    fTargetList.Free;
    fRegList.Free;
  end;
  inherited Destroy;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.SetEnabled(Value: boolean);
var
  i: integer;
begin
  if Value = fEnabled then
    exit;

  fParentForm := GetParentForm(TWinControl(owner));
  if fParentForm = nil then
    exit;

  fEnabled := Value;
  ClearTargets;

  if fEnabled then
  begin
    //hook all registered controls and disable their OnClick events ...
    for i := 0 to fRegList.Count - 1 do
      TRegisteredObj(fRegList[i]).Hook;
    //hook the parent form too ...
    fOldWindowProc := fParentForm.WindowProc;
    {fParentForm.WindowProc := FormWindowProc; }
  end
  else
  begin
    //unhook all registered controls and reenable their OnClick events ...
    for i := 0 to fRegList.Count - 1 do
      TRegisteredObj(fRegList[i]).UnHook;
    //unhook the parent form too ...
    { fParentForm.WindowProc := fOldWindowProc;  }
  end;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.FormWindowProc(var Msg: TMessage);
begin
  DoWindowProc(fOldWindowProc, Msg);
end;
//------------------------------------------------------------------------------

//TSizeCtrl's own message handler to process CM_CUSTOM_MSE_DOWN message
procedure TSizeCtrl.WinProc(var Msg: TMessage);
var
  Button: TMouseButton;
  ShiftState: TShiftState;
begin
  with Msg do
    if Msg = CM_LMOUSEDOWN then
      try
        fLMouseDownPending := False;
        if bool(WParam) then
          Button := mbLeft
        else
          Button := mbRight;
        if bool(LParam) then
          ShiftState := [ssShift]
        else
          ShiftState := [];
        DoMouseDown(nil, Button, ShiftState);
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(fHandle, Msg, wParam, lParam);
end;
//------------------------------------------------------------------------------

//WindowProc for the 'hooked' form and all 'hooked' controls
procedure TSizeCtrl.DoWindowProc(DefaultProc: TWndMethod; var Msg: TMessage);
var
  i: integer;
  ShiftState: TShiftState;
  controlPt, screenPt: TPoint;
  regCtrl: TControl;
  handled: boolean;

  //this seems the only reasonably simple way of managing both 'owned' and
  //'notified' WM_LBUTTONDOWN messages ...
  procedure PostMouseDownMessage(isLeftBtn, shiftKeyPressed: boolean);
  begin
    if fLMouseDownPending then
      exit;

    if assigned(fOnMouseDown) then
    begin
      getCursorPos(screenPt);
      regCtrl := RegisteredCtrlFromPt(screenPt);
      if assigned(regCtrl) then
      begin
        handled := False;
        controlPt := regCtrl.ScreenToClient(screenPt);
        fOnMouseDown(self, regCtrl, controlPt, handled);
        if handled then
          exit;
      end;
    end;

    fLMouseDownPending := True;
    PostMessage(fHandle, CM_LMOUSEDOWN, Ord(isLeftBtn), Ord(shiftKeyPressed));
  end;

begin
  case Msg.Msg of

    WM_MOUSEFIRST .. WM_MOUSELAST:
    begin
      ShiftState := KeysToShiftState(word(TWMMouse(Msg).Keys));
      case Msg.Msg of
        WM_LBUTTONDOWN: PostMouseDownMessage(True, ssShift in ShiftState);
        WM_RBUTTONDOWN: DoPopupMenuStuff;
        WM_MOUSEMOVE: DoMouseMove(nil, ShiftState);
        WM_LBUTTONUP: DoMouseUp(nil, mbLeft, ShiftState);
        //Could also add event handlers for right click events here.
      end;
      Msg.Result := 0;
    end;

    WM_PARENTNOTIFY:
      if not (TWMParentNotify(Msg).Event in [WM_CREATE, WM_DESTROY]) then
      begin
        if ShiftKeyIsPressed then
          ShiftState := [ssShift]
        else
          ShiftState := [];
        case TWMParentNotify(Msg).Event of
          WM_LBUTTONDOWN: PostMouseDownMessage(True, ssShift in ShiftState);
        end;
        Msg.Result := 0;
      end;

    WM_SETCURSOR:
      if (HIWORD(Msg.lParam) <> 0) then
      begin
        Msg.Result := 1;
        getCursorPos(screenPt);
        regCtrl := RegisteredCtrlFromPt(screenPt);

        handled := False;
        if assigned(fOnSetCursor) and assigned(regCtrl) then
        begin
          controlPt := regCtrl.ScreenToClient(screenPt);
          fOnSetCursor(self, RegisteredCtrlFromPt(screenPt), controlPt, handled);
        end;

        if handled then //do nothing
        else if TargetIndex(regCtrl) >= 0 then
        begin

          if not IsValidMove then
            DefaultProc(Msg)
          else
            Windows.SetCursor(screen.Cursors[crSize]);

        end
        else if assigned(regCtrl) then
          Windows.SetCursor(screen.Cursors[crHandPoint])
        else
          DefaultProc(Msg);
      end
      else
        DefaultProc(Msg);

    WM_GETDLGCODE: Msg.Result := DLGC_WANTTAB;

    WM_KEYDOWN:
    begin
      Msg.Result := 0;
      if DoKeyDown(TWMKey(Msg)) then
        exit;
      case Msg.WParam of
        VK_UP:
          if ShiftKeyIsPressed then
          begin
            SizeTargets(0, -1);
            if assigned(fEndEvent) then
              fEndEvent(self, scsSizing);
          end
          else
          begin
            MoveTargets(0, -1);
            if assigned(fEndEvent) then
              fEndEvent(self, scsMoving);
          end;
        VK_DOWN:
          if ShiftKeyIsPressed then
          begin
            SizeTargets(0, +1);
            if assigned(fEndEvent) then
              fEndEvent(self, scsSizing);
          end
          else
          begin
            MoveTargets(0, +1);
            if assigned(fEndEvent) then
              fEndEvent(self, scsMoving);
          end;
        VK_LEFT:
          if ShiftKeyIsPressed then
          begin
            SizeTargets(-1, 0);
            if assigned(fEndEvent) then
              fEndEvent(self, scsSizing);
          end
          else
          begin
            MoveTargets(-1, 0);
            if assigned(fEndEvent) then
              fEndEvent(self, scsMoving);
          end;
        VK_RIGHT:
          if ShiftKeyIsPressed then
          begin
            SizeTargets(+1, 0);
            if assigned(fEndEvent) then
              fEndEvent(self, scsSizing);
          end
          else
          begin
            MoveTargets(+1, 0);
            if assigned(fEndEvent) then
              fEndEvent(self, scsMoving);
          end;
        VK_TAB:
        begin
          if fRegList.Count = 0 then
            exit
          else if targetCount = 0 then
            AddTarget(TRegisteredObj(fRegList[0]).fControl)
          else
          begin
            i := RegisteredIndex(Targets[0]);
            if ShiftKeyIsPressed then
              Dec(i)
            else
              Inc(i);
            if i < 0 then
              i := fRegList.Count - 1
            else if i = fRegList.Count then
              i := 0;
            ClearTargets;
            AddTarget(TRegisteredObj(fRegList[i]).fControl);
          end;
        end;
        VK_ESCAPE:
          //ESCAPE is used for both -
          //  1. cancelling a mouse move/resize operation, and
          //  2. selecting the parent of the currenctly selected target
          if fState <> scsReady then
          begin
            fEscCancelled := True;
            DoMouseUp(nil, mbLeft, []);
          end
          else
          begin
            if (targetCount = 0) then
              exit;
            i := RegisteredIndex(Targets[0].Parent);
            ClearTargets;
            if i >= 0 then
              AddTarget(TRegisteredObj(fRegList[i]).fControl);
          end;
      end;
    end;

    WM_KEYUP: Msg.Result := 0;
    WM_CHAR: Msg.Result := 0;

    else
      DefaultProc(Msg);
  end;
end;
//------------------------------------------------------------------------------

function TSizeCtrl.DoKeyDown(var Message: TWMKey): boolean;
var
  ShiftState: TShiftState;
begin
  Result := True;
  if fParentForm.KeyPreview and THackedWinControl(fParentForm).DoKeyDown(Message) then
    Exit;
  if Assigned(fOnKeyDown) then
    with Message do
    begin
      ShiftState := KeyDataToShiftState(KeyData);
      fOnKeyDown(Self, CharCode, ShiftState);
      if CharCode = 0 then
        Exit;
    end;
  Result := False;
end;
//------------------------------------------------------------------------------

function TSizeCtrl.GetTargets(index: integer): TControl;
begin
  if (index < 0) or (index >= TargetCount) then
    Result := nil
  else
    Result := TTargetObj(fTargetList[index]).fTarget;
end;
//------------------------------------------------------------------------------

function TSizeCtrl.TargetIndex(Control: TControl): integer;
var
  i: integer;
begin

  Result := -1;
  if assigned(Control) then
    for i := 0 to fTargetList.Count - 1 do
      if TTargetObj(fTargetList[i]).fTarget = Control then
      begin
        Result := i;
        break;
      end;
end;
//------------------------------------------------------------------------------

function TSizeCtrl.AddTarget(Control: TControl): integer;
var
  TargetObj: TTargetObj;
begin

  Result := -1;
  if (csDestroying in ComponentState) or (fState <> scsReady) then
    exit;

  Result := TargetIndex(Control);
  if not assigned(Control) or not Control.Visible or (Control is TCustomForm) or
    (Result >= 0) then
    exit;
  Result := fTargetList.Count;
  TargetObj := TTargetObj.Create(self, Control);
  fTargetList.Add(TargetObj);

  UpdateBtnCursors;
  TargetObj.Update;
  TargetObj.Show;
  RegisterControl(Control);
  fParentForm.ActiveControl := nil;
  if assigned(fTargetChangeEvent) then
    fTargetChangeEvent(self);

  {for i := 0 to fTargetList.Count -1 do
      MessageBox(0,pchar(TTargetObj(fTargetList[i]).fTarget.Name),'',mb_ok);  }
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.DeleteTarget(Control: TControl);
var
  i: integer;
begin
  i := TargetIndex(Control);
  if i < 0 then
    exit;
  TTargetObj(fTargetList[i]).Free;
  fTargetList.Delete(i);
  UpdateBtnCursors;
  if assigned(fTargetChangeEvent) then
    fTargetChangeEvent(self);
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.ClearTargets;
var
  i: integer;
begin
  if fTargetList.Count = 0 then
    exit;
  for i := 0 to fTargetList.Count - 1 do
  begin
    if fTargetList[i] <> nil then
      TTargetObj(fTargetList[i]).Free;
  end;

  fTargetList.Clear;
  if (csDestroying in ComponentState) then
    exit;
  UpdateBtnCursors;
  if assigned(fTargetChangeEvent) then
    fTargetChangeEvent(self);
end;
//------------------------------------------------------------------------------

function TSizeCtrl.RegisterControl(Control: TControl): integer;
var
  RegisteredObj: TRegisteredObj;
begin
 { if not IsVisible(Control) then
  begin
    result := -1;
    exit;
  end;}

  Result := RegisteredIndex(Control);
  if Result >= 0 then
    exit;

  Result := fRegList.Count;
  RegisteredObj := TRegisteredObj.Create(self, Control);
  fRegList.Add(RegisteredObj);
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.UnRegisterControl(Control: TControl);
var
  i: integer;
begin
  //first, make sure it's not a current target ...
  DeleteTarget(Control);
  //now unregister it ...
  i := RegisteredIndex(Control);
  if i < 0 then
    exit;
  TRegisteredObj(fRegList[i]).Free;
  fRegList.Delete(i);
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.UnRegisterAll;
var
  i: integer;
begin
  //first, clear any targets
  ClearTargets;
  //now, clear all registered controls ...
  for i := 0 to fRegList.Count - 1 do
  begin
    if Assigned(fRegList[i]) then
      TRegisteredObj(fRegList[i]).Free;
  end;
  fRegList.Clear;
end;
//------------------------------------------------------------------------------

function TSizeCtrl.RegisteredIndex(Control: TControl): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to fRegList.Count - 1 do
    if TRegisteredObj(fRegList[i]).fControl = Control then
    begin
      Result := i;
      break;
    end;
end;
//------------------------------------------------------------------------------

function TSizeCtrl.TargetCtrlFromPt(screenPt: TPoint): TControl;
var
  i: integer;
  tmpCtrl: TWinControl;
begin
  //nb: If controls overlap at screenPt, then the (top-most) child control
  //is selected if there is a parent-child relationship. Otherwise, simply
  //the first control under screenPt is returned.
  Result := nil;
  for i := fTargetList.Count - 1 downto 0 do
    with TTargetObj(fTargetList[i]) do
    begin
      if not PointIsInControl(screenPt, fTarget) then
        continue;
      if not (fTarget is TWinControl) then
      begin
        Result := fTarget;
        exit; //ie assume this is top-most since it can't be a parent.
      end
      else if not assigned(Result) then
        Result := fTarget
      else
      begin
        tmpCtrl := TWinControl(fTarget).Parent;
        while assigned(tmpCtrl) and (tmpCtrl <> Result) do
          tmpCtrl := tmpCtrl.Parent;
        if assigned(tmpCtrl) then
          Result := fTarget;
      end;
    end;
end;
//------------------------------------------------------------------------------


function TSizeCtrl.getRegObj(C: TComponent): TRegisteredObj;
var
  i: integer;
begin
  for i := fRegList.Count - 1 downto 0 do
  begin
    Result := TRegisteredObj(fRegList[i]);
    if (integer(Result.fControl) = integer(C)) then
      exit;
  end;
  Result := nil;
end;

function TSizeCtrl.RegisteredCtrlFromPt(screenPt: TPoint;
  ParentX: TWinControl = nil): TControl;
var
  i: integer;
  rO: TRegisteredObj;
  tmp: TControl;
begin
  //nb: If controls overlap at screenPt, then the (top-most) child control
  //is selected if there is a parent-child relationship. Otherwise, simply
  //the first control under screenPt is returned.
  Result := nil;
  if (ParentX = nil) then
    ParentX := fForm;

  // for i := fRegList.Count -1 downto 0 do
  for i := ParentX.ControlCount - 1 downto 0 do
  begin

    rO := self.getRegObj(ParentX.Controls[i]);

    if rO = nil then
      continue;

{   if ParentX is TTabSheet then
   Application.MainForm.Caption := Application.MainForm.Caption +','+
        IntToStr(TTabSheet(ParentX).tabIndex);
 }

    if rO.fControl.Parent is TTabSheet then
    begin
      if not rO.fControl.Parent.Visible then
        continue;
    end;

    with rO do
    begin

      if not PointIsInControl(screenPt, fControl) then
        continue;

      Result := fControl;

      if (Result is TPageControl) then
      begin

        tmp := RegisteredCtrlFromPt(screenPt, TPageControl(Result).ActivePage);

        if (tmp <> nil) then
        begin

          Result := tmp;
        end;
      end;

      if (Result is TWinControl) then
      begin
        tmp := RegisteredCtrlFromPt(screenPt, (Result as TWinControl));
        if (tmp <> nil) then
          Result := tmp;
      end;

      exit;
    end;
  end;

  Result := nil;
  //Application.MainForm.Caption := Result.ClassName;
end;
//------------------------------------------------------------------------------

function TSizeCtrl.GetTargetCount: integer;
begin
  Result := fTargetList.Count;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.MoveTargets(dx, dy: integer);
var
  i, q, r: integer;
begin
  if not IsValidMove then
    exit;
  for i := 0 to fTargetList.Count - 1 do
    with TTargetObj(fTargetList[i]) do
    begin
      q := (fTarget.Left + dx) mod GridSize;
      r := (fTarget.Top + dy) mod GridSize;
      with fTarget do
        SetBounds(Left + dx - q, Top + dy - r, Width, Height);
      Update;
    end;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.SizeTargets(dx, dy: integer);
var
  i, q, r: integer;
begin
  if MoveOnly then
    exit;
  if (dx <> 0) and not (IsValidSizeBtn(bpLeft) or IsValidSizeBtn(bpRight)) then
    exit;
  if (dy <> 0) and not (IsValidSizeBtn(bpBottom) or IsValidSizeBtn(bpTop)) then
    exit;

  for i := 0 to fTargetList.Count - 1 do
    with TTargetObj(fTargetList[i]) do
    begin

      q := (fTarget.Width + dx) mod GridSize;
      r := (fTarget.Height + dy) mod GridSize;

      with fTarget do
        SetBounds(Left, Top,
          max(MINWIDTH, Width + dx) - q, max(MINHEIGHT, Height + dy) - r);
      Update;
    end;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.Update;
var
  i: integer;
begin
  for i := 0 to fTargetList.Count - 1 do
    TTargetObj(fTargetList[i]).Update;
end;

procedure TSizeCtrl.UpdateBtns;
var
  i: integer;
  x: TBtnPos;
begin
  for i := 0 to fTargetList.Count - 1 do
    for x := low(TBtnPos) to high(TBtnPos) do
      TTargetObj(fTargetList[i]).fBtns[x].UpdateBtnCursorAndColor;
end;

//------------------------------------------------------------------------------

procedure TSizeCtrl.DrawRect;
var
  i: integer;
  dc: hDC;
  //  MaxX,MaxY,MinX,MinY: Integer;
begin
  if TargetCount = 0 then
    exit;
  dc := GetDC(0);
  try
    for i := 0 to TargetCount - 1 do
      // DrawFocusRect(dc,Rect(MinX,MinY,MaxX,MaxY));
      TTargetObj(fTargetList[i]).DrawRect(dc, TTargetObj(fTargetList[i]).fTarget);
  finally
    ReleaseDC(0, dc);
  end;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.DoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState);
var
  i, targetIdx: integer;
  p: TWinControl;
  parentClientRec: TRect;
  targetObj: TTargetObj;
begin
  fEscCancelled := False;
  GetCursorPos(fStartPt);



  if (Sender is TSizeBtn) then
  begin
    if fMoveOnly then
      exit; //should never happen
    targetObj := TSizeBtn(Sender).fTargetObj;
    fCapturedCtrl := targetObj.fTarget;
    fCapturedBtnPos := TSizeBtn(Sender).fPos;
    //make sure we're allowed to size these targets with this button ...
    if not IsValidSizeBtn(fCapturedBtnPos) then
      exit;
    fState := scsSizing;
  end
  else
  begin
    //First find the top-most control that's clicked ...
    //nb: It's so much simpler to do this here than try and work it out from
    //the WindowProc owner (because of disabled controls & non-TWinControls.)

    fCapturedCtrl := RegisteredCtrlFromPt(fStartPt);

    targetIdx := TargetIndex(fCapturedCtrl);
    if not (ssShift in Shift) and (targetIdx < 0) then
      ClearTargets;
    if not assigned(fCapturedCtrl) then
      exit;

    //if the control isn't a target then add it ...
    if targetIdx < 0 then
    begin

      AddTarget(fCapturedCtrl);
      exit;
      //if the control's already a target but the Shift key's pressed then delete it ...
    end
    else if (ssShift in Shift) then
    begin
      DeleteTarget(fCapturedCtrl);
      fCapturedCtrl := nil;
      exit;
    end;
    fParentForm.ActiveControl := nil;
    if not IsValidMove then
      exit;
    targetObj := TTargetObj(fTargetList[targetIdx]);
    fState := scsMoving;
  end;


  for i := 0 to TargetCount - 1 do
  begin
    //TTargetObj(fTargetList[i]).fTarget.Hide;
    TTargetObj(fTargetList[i]).StartFocus();
  end;

  if assigned(fStartEvent) then
    fStartEvent(self, fState);

  //now calculate and set the clipping region in screen coords ...
  p := targetObj.fTarget.Parent;
  parentClientRec := p.ClientRect;
  parentClientRec.TopLeft := p.ClientToScreen(parentClientRec.TopLeft);
  parentClientRec.BottomRight := p.ClientToScreen(parentClientRec.BottomRight);
  if fState = scsMoving then
  begin
    fClipRec := parentClientRec;
  end
  else
    with targetObj do //ie sizing
    begin
      fClipRec := fFocusRect;
      case TSizeBtn(Sender).fPos of
        bpLeft: fClipRec.Left := parentClientRec.Left;
        bpTopLeft:
        begin
          fClipRec.Left := parentClientRec.Left;
          fClipRec.Top := parentClientRec.Top;
        end;
        bpTop: fClipRec.Top := parentClientRec.Top;
        bpTopRight:
        begin
          fClipRec.Right := parentClientRec.Right;
          fClipRec.Top := parentClientRec.Top;
        end;
        bpRight: fClipRec.Right := parentClientRec.Right;
        bpBottomRight:
        begin
          fClipRec.Right := parentClientRec.Right;
          fClipRec.Bottom := parentClientRec.Bottom;
        end;
        bpBottom: fClipRec.Bottom := parentClientRec.Bottom;
        bpBottomLeft:
        begin
          fClipRec.Left := parentClientRec.Left;
          fClipRec.Bottom := parentClientRec.Bottom;
        end;
      end;
    end;
  //ClipCursor(@fClipRec);

  Hide;
  DrawRect;
  THackedControl(fCapturedCtrl).MouseCapture := True;
end;
//------------------------------------------------------------------------------

function WinVer: double;
var
  WinV: word;
begin
  WinV := GetVersion and $0000FFFF;
  Result := StrToFloat(IntToStr(Lo(WinV)) + DecimalSeparator + IntToStr(Hi(WinV)));
end;

procedure TSizeCtrl.DoMouseMove(Sender: TObject; Shift: TShiftState);
var
  i, dx, dy: integer;
  newPt: TPoint;
  Q, R: integer;
begin

  if (fState = scsReady) or not assigned(fCapturedCtrl) then
    exit;
  DrawRect;

  GetCursorPos(newPt);

  dx := newPt.X - fStartPt.X;
  dy := newPt.Y - fStartPt.Y;
  Q := 0;
  R := 0;

  if (fState = scsSizing) then
  begin
    case fCapturedBtnPos of
      bpLeft, bpRight: dy := 0;
      bpTop, bpBottom: dx := 0;
    end;

    if (not AltKeyIsPressed) then
    begin
      Q := Dx mod GridSize;
      R := Dy mod GridSize;
    end;

    for i := 0 to TargetCount - 1 do
      TTargetObj(fTargetList[i]).SizeFocus(dx - q, dy - r, fCapturedBtnPos);
    if assigned(fDuringEvent) then
      fDuringEvent(self, dx - q, dy - r, fState);
  end
  else
  begin

    if (not AltKeyIsPressed) then
    begin
      Q := Dx mod GridSize;
      R := Dy mod GridSize;
    end;

    for i := 0 to TargetCount - 1 do
      TTargetObj(fTargetList[i]).MoveFocus(dx - q, dy - r);
    if assigned(fDuringEvent) then
      fDuringEvent(self, dx - q, dy - r, fState);
  end;
  //windows.SetCursor(screen.Cursors[crHandPoint]);
  DrawRect;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.DoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState);
var
  i, k: integer;
  list: TList;
  //  t: Integer;
begin
  if fState = scsReady then
    exit;
  DrawRect;
  ClipCursor(nil);
  THackedControl(fCapturedCtrl).MouseCapture := False;
  fCapturedCtrl := nil;
  if not fEscCancelled then
    for i := 0 to TargetCount - 1 do
    begin
      //TTargetObj(fTargetList[i]).fTarget.Show;
      TTargetObj(fTargetList[i]).EndFocus;
      TTargetObj(fTargetList[i]).fPanelsNames.Clear;
      list := TTargetObj(fTargetList[i]).fPanels;
      for k := 0 to list.Count - 1 do
        TObject(list[k]).Free();
      list.Clear;
    end;

  //  t := GetTickCount;

  fEscCancelled := False;
  if assigned(fEndEvent) then
    fEndEvent(self, fState);

  Show;
  fState := scsReady;

  // windows.SetCursor(screen.Cursors[crDefault]);
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.Hide;
{var
  i: integer;
}begin
  // for i := 0 to TargetCount -1 do TTargetObj(fTargetList[i]).Hide;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.Show;
{var
  i: integer;
}begin
  // for i := 0 to TargetCount -1 do TTargetObj(fTargetList[i]).Show;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.UpdateBtnCursors;
var
  i: integer;
  j: TBtnPos;
begin

  if fMultiResize or (TargetCount = 1) then
  begin
    fValidBtns := [bpLeft, bpTopLeft, bpTop, bpTopRight, bpRight,
      bpBottomRight, bpBottom, bpBottomLeft];
    for i := 0 to TargetCount - 1 do
      case TTargetObj(fTargetList[i]).fTarget.Align of
        alTop: fValidBtns := fValidBtns - [bpLeft, bpTopLeft, bpTop,
            bpTopRight, bpRight, bpBottomRight, bpBottomLeft];
        alBottom: fValidBtns :=
            fValidBtns - [bpLeft, bpTopLeft, bpTopRight, bpRight,
            bpBottomRight, bpBottom, bpBottomLeft];
        alLeft: fValidBtns := fValidBtns - [bpLeft, bpTopLeft, bpTop,
            bpTopRight, bpBottomRight, bpBottom, bpBottomLeft];
        alRight: fValidBtns :=
            fValidBtns - [bpTopLeft, bpTop, bpTopRight, bpRight,
            bpBottomRight, bpBottom, bpBottomLeft];
        alClient: fValidBtns := [];
        {$IFNDEF VER100}
        alCustom: fValidBtns := [];
{$ENDIF}
      end;
  end
  else
    fValidBtns := [];

  for i := 0 to TargetCount - 1 do
    with TTargetObj(fTargetList[i]) do
      for j := low(TBtnPos) to high(TBtnPos) do
        fBtns[j].UpdateBtnCursorAndColor;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.SetMoveOnly(Value: boolean);
begin
  if fMoveOnly = Value then
    exit;
  fMoveOnly := Value;
  UpdateBtnCursors;
end;
//------------------------------------------------------------------------------

function TSizeCtrl.IsValidSizeBtn(BtnPos: TBtnPos): boolean;
begin
  Result := (TargetCount > 0) and (TTargetObj(fTargetList[0]).fBtns[BtnPos].Cursor <>
    crDefault);
end;
//------------------------------------------------------------------------------

function TSizeCtrl.IsValidMove: boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to TargetCount - 1 do
    if (TTargetObj(fTargetList[i]).fTarget.Align <> alNone) then
      exit;
  Result := True;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.SetMultiResize(Value: boolean);
begin
  if Value = fMultiResize then
    exit;
  fMultiResize := Value;
  UpdateBtnCursors;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.SetEnabledBtnColor(aColor: TColor);
begin
  if fEnabledBtnColor = aColor then
    exit;
  fEnabledBtnColor := aColor;
  UpdateBtnCursors;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.SetDisabledBtnColor(aColor: TColor);
begin
  if fDisabledBtnColor = aColor then
    exit;
  fDisabledBtnColor := aColor;
  UpdateBtnCursors;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.SetPopupMenu(Value: TPopupMenu);
begin
  fPopupMenu := Value;
  if Value = nil then
    exit;
  Value.FreeNotification(Self);
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = PopupMenu) then
    PopupMenu := nil;
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.DoPopupMenuStuff;
var
  Handled: boolean;
  pt: TPoint;
  targetCtrl: TControl;
begin
  if not assigned(fPopupMenu) then
    exit;
  GetCursorPos(pt);
  targetCtrl := TargetCtrlFromPt(pt);
  if not assigned(targetCtrl) then
    exit;
  Handled := False;
  if Assigned(FOnContextPopup) then
    fOnContextPopup(Self, pt, Handled);
  if Handled then
    exit;
  THackedControl(owner).SendCancelMode(nil);
  fPopupMenu.PopupComponent := targetCtrl;
  PopupMenu.Popup(Pt.X, Pt.Y);
end;
//------------------------------------------------------------------------------

procedure TSizeCtrl.formPaint(Sender: TObject);
var
  i, j, w, h: integer;
  c, g: TColor;
begin
  if not Assigned(Self) then
    exit;

  if not ShowGrid then
    exit;
  if GridSize < 5 then
    exit;

  w := TControl(Sender).Width;
  h := TControl(Sender).Height;
  c := TForm(Sender).Color;

  if (fGrid <> nil) and (lastW = w) and (lastH = h) and (lastColor = c) then
  begin
    //  exit;
  end;

  if not Assigned(fForm) then
    exit;

  lastW := w;
  lastH := h;
  lastColor := c;
  g := GetGValue(TForm(fForm).Color);

  if fGrid = nil then
    fGrid := TBitmap.Create;

  fGrid.Width := w;
  fGrid.Height := h;
  fGrid.Canvas.Brush.Color := c;
  fGrid.Canvas.Pen.Style := psClear;
  fGrid.Canvas.Rectangle(0, 0, w + 1, h + 1);
  for i := 0 to w div GridSize do
    for j := 0 to h div GridSize do
    begin
      if g < 180 then
        fGrid.Canvas.Pixels[I * GridSize, J * GridSize] := clWhite
      else
        fGrid.Canvas.Pixels[I * GridSize, J * GridSize] := clGray;
    end;

  {if fImage = nil then
  begin
    fImage := TImage.Create(Application);
    fImage.Parent := TWinControl(Sender);
    fImage.Align := alClient;
    fImage.OnDblClick := TForm(Sender).OnDblClick;
    fImage.OnMouseDown := TForm(Sender).OnMouseDown;
    //fImage.OnMouseMove := TForm(Sender).OnMouseMove;
    fImage.OnMouseUp   := TForm(Sender).OnMouseUp;
    fImage.OnClick := TForm(Sender).OnClick;
  end;

  fImage.Width := w;
  fImage.Height := h;
  fImage.Picture.Bitmap.Width := w;
  fImage.Picture.Bitmap.Height := h;
  fImage.Picture.Bitmap.Canvas.Draw(0,0,fGrid);
   }
  TForm(Sender).Canvas.Draw(0, 0, fGrid);

  //fGrid.Canvas.CopyRect(Rect(0,0,w,h), TForm(Sender).Canvas, Rect(0,0,w,h));

end;

procedure TSizeCtrl.SetShowGrid(const Value: boolean);
begin
  FShowGrid := Value;
end;

procedure TSizeCtrl.SetgetSelected(const Value: TList);
begin
  FgetSelected := Value;
end;

function TSizeCtrl.getSelected: TList;
var
  i: integer;
begin
  Result := TList.Create;
  for i := 0 to fTargetList.Count - 1 do
  begin
    Result.Add(TTargetObj(fTargetList[i]).fTarget);
  end;
end;

procedure TSizeCtrl.toBack(CNTR: TControl);
var
  i, x: integer;
  res: TRegisteredObj;
  newList: TList;
begin
  newList := TList.Create;
  for i := 0 to fRegList.Count - 1 do
  begin
    res := TRegisteredObj(fRegList[i]);
    if (integer(res.fControl) = integer(CNTR)) then
    begin
      x := i;
      break;
    end;
  end;

  for i := 0 to fRegList.Count - 1 do
  begin
    if i = x then
      continue;
    newList.Add(fRegList[i]);
  end;


  newList.Add(fRegList[x]);

  fRegList.Free;
  fRegList := newList;
end;

procedure TSizeCtrl.toFront(CNTR: TControl);
var
  i, x: integer;
  res: TRegisteredObj;
  newList: TList;
begin
  newList := TList.Create;
  for i := fRegList.Count - 1 downto 0 do
  begin
    res := TRegisteredObj(fRegList[i]);
    if (integer(res.fControl) = integer(CNTR)) then
    begin
      x := i;
    end;
  end;

  for i := fRegList.Count - 1 downto 0 do
  begin
    if i = x then
      continue;
    newList.Add(fRegList[i]);
  end;

  newList.Add(fRegList[x]);

  fRegList.Free;
  fRegList := newList;
end;

{ TMovePanel }

constructor TMovePanel.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMovePanel.Destroy;
begin

  inherited;
end;

procedure TMovePanel.Paint;
begin
  Canvas.Pen.Style := psDot;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(0, 0, Width, Height);
  //inherited;
end;




end.
