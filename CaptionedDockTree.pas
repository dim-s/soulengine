{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{           Copyright (c) 1995-2007 CodeGear            }
{                                                       }
{*******************************************************}

unit CaptionedDockTree;

interface

uses Windows, Controls, Graphics, Messages, SysUtils, TypInfo, Forms, Classes;

type
  /// <summary>
  /// TParentFormState: stores information about the parent dock form for
  /// use in drawing the dock site
  /// </summary>
  TParentFormState = record
    Caption: string;
    StartColor, EndColor, FontColor: TColor;
    Focused: Boolean;
    Icon: TIcon;
  end;

type
  TDockFormClass = class of TCustomDockForm;

  TDockCaptionOrientation = (dcoHorizontal, dcoVertical);

  /// <summary>
  /// Hit tests for the caption. Note: The custom values allow you
  /// to return your own hit test results for your own drawer.
  /// </summary>
  TDockCaptionHitTest = Cardinal;
  /// <summary>
  /// The pin button style to draw, if any.
  /// </summary>
  TDockCaptionPinButton = (dcpbNone, dcpbUp, dcpbDown);

  TDockCaptionDrawer = class(TObject)
  private
    FDockCaptionOrientation: TDockCaptionOrientation;
    FDockCaptionPinButton: TDockCaptionPinButton;
    function GetCloseRect(const CaptionRect: TRect): TRect;
    function GetPinRect(const CaptionRect: TRect): TRect;
    function CalcButtonSize(const CaptionRect: TRect): Integer;
  public
    procedure DrawDockCaption(const Canvas: TCanvas;
      CaptionRect: TRect; State: TParentFormState); virtual;
    function DockCaptionHitTest(const CaptionRect: TRect;
      const MousePos: TPoint): TDockCaptionHitTest; virtual;
    /// <summary>
    /// Creates an instance of the TDockCaptionDrawer. It is virtual so the
    /// call to TCaptionedDockTree.GetDockCaptionDrawer.Create(..) will
    /// be called on the correct type.
    /// </summary>
    constructor Create(DockCaptionOrientation: TDockCaptionOrientation); virtual;

    property DockCaptionPinButton: TDockCaptionPinButton read FDockCaptionPinButton write FDockCaptionPinButton;
  end;

  TDockCaptionDrawerClass = class of TDockCaptionDrawer;

  TCaptionedDockTree = class(TDockTree)
  private
    FGrabberSize: Integer;
    FDockCaptionOrientation: TDockCaptionOrientation;
    FDockCaptionDrawer: TDockCaptionDrawer;
    procedure InvalidateDockSite(const Client: TControl);
  protected
    function AdjustCaptionRect(const ARect: TRect): TRect; virtual;
    procedure AdjustDockRect(Control: TControl; var ARect: TRect); override;
    function InternalCaptionHitTest(const Zone: TDockZone;
      const MousePos: TPoint): TDockCaptionHitTest;
    procedure PaintDockFrame(Canvas: TCanvas; Control: TControl;
      const ARect: TRect); override;
    function ZoneCaptionHitTest(const Zone: TDockZone;
      const MousePos: TPoint; var HTFlag: Integer): Boolean; override;
    property DockCaptionOrientation: TDockCaptionOrientation read FDockCaptionOrientation;
    property DockCaptionDrawer: TDockCaptionDrawer read FDockCaptionDrawer;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(DockSite: TWinControl); overload; override;
    constructor Create(DockSite: TWinControl;
      ADockCaptionOrientation: TDockCaptionOrientation); reintroduce; overload;
    destructor Destroy; override;
    class function GetParentFormState(const Control: TControl): TParentFormState; virtual;
    class function GetDockCaptionDrawer: TDockCaptionDrawerClass; virtual;
  end;

    // Класс TFloatTreeCep управляет расположением форм-носителей
const
  SignStreamFloatTreeCep:integer = 3;
type
  TCoordsFloat =record
     csSize:integer;
     R: TRect;
     Visible: boolean;
  end;

  TFloatTreeCep = class
  private
    fList: TStringList;
    fCoords:array of TCoordsFloat;
    fEnabled: boolean;
    function GetCount: integer;
    procedure DoAdd(const Names: String; const Coord: TCoordsFloat);
    procedure SetEnabled(const Value: boolean);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SaveControl(Control:TControl; R:TRect; Visible:boolean);
    function CoordsByControl(Control:TControl; var Coord: TCoordsFloat):boolean;
    function RestoreForm(Form: TCustomDockForm):boolean;
    procedure SaveForm(Form: TCustomDockForm);
    property Count:integer read GetCount;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure RestoreAllForm;
    procedure SaveAllForm;
    property Enabled:boolean read fEnabled write SetEnabled;
  end;


  TCustomDockFormEx = class (TCustomDockForm)
  private
    fTimerVisible: boolean;
    fCaption: String;
    procedure CMVISIBLECHANGED(var Message:TMessage); message CM_VISIBLECHANGED;
    procedure WMACTIVATEAPP(var Message: TWMACTIVATEAPP); message WM_ACTIVATEAPP;
    procedure SetTimerVisible(const Value: boolean);
  protected
    procedure DoAddDockClient(Client: TControl; const ARect: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
    //Если TimerVisible не равно Visible, то через короткий промежуток времени
    //будет установелно соответствующее значение свойства Visible
    property TimerVisible:boolean read fTimerVisible write SetTimerVisible;
    procedure DoShow; override;
    procedure DoHide; override;
    destructor Destroy; override;
  end;

    // Это класс окна носителя, с поддержкой Ctl3d=false;
  // (используется собственная отрисовка неклиентской области)
  TCustomDockFormCep = class (TCustomDockFormEx)
  private
    fInClose: boolean;
    fCloseDown: boolean;
    procedure WMACTIVATE(var Message: TWMACTIVATE); message WM_ACTIVATE;
    procedure WMNCPAINT(var Message: TWMNCPAINT); message WM_NCPAINT;
    procedure WMNCHITTEST(var Message: TWMNCHITTEST); message WM_NCHITTEST;
    procedure WMNCLBUTTONDOWN(var Message: TWMNCLBUTTONDOWN); message WM_NCLBUTTONDOWN;
    procedure WMNCLBUTTONUP(var Message: TWMNCLBUTTONUP); message WM_NCLBUTTONUP;
    procedure WM_SETTEXT(var Message: TWMSETTEXT); message WM_SETTEXT;
    procedure CalcRect(var WindowRect, ClientRect, CaptionRect, CloseRect:TRect; var Pt: TPoint);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


  //Этот класс управляет изображением во время перемещения контрола
  TDragDockObjectCep = class {$IFDEF VER130}(TDragDockObject){$ELSE}(TDragDockObjectEx){$ENDIF}
  private
    fDockOvered: boolean;
    fOveredTimer: boolean;
    procedure SetDockOvered(const Value: boolean);
  protected
    procedure AdjustDockRect(ARect: TRect); override;
    procedure DrawDragDockImage; override;
    procedure EraseDragDockImage; override;
  published
  public
    destructor Destroy; override;
    //Если установлено это свойство, то при сбросе DockOvered, происходит
    //отложенное сокрытие формы-носителя.
    property OveredTimer:boolean read fOveredTimer write fOveredTimer;
    //Это свойство указывает на то, что перетаскиваемый объект находится внутри
    //объекта к которому может быть пристыкован и изображается полупрозрачная
    //рамка. В противном случае объект перемещается по свободному экрану
    //и изображается полупрозрачная форма.
    property DockOvered:boolean read fDockOvered write SetDockOvered;
  end;




  TCaptionedDockTreeClass = class of TCaptionedDockTree;

var TmpBitmap: TBitmap;
    CountUsedBMP: integer;
    _FloatTreeCep: TFloatTreeCep;
    RestoredDockForm:boolean;
    IdTimer:THandle;
    DefaultDockFormClass: TDockFormClass;

const
  /// <summary>
  /// TDockCaptionHitTest constant values used. You can use your own values,
  /// but start at the dchtCustom value. Items 4-9 are reserved for future
  /// VCL use, and the value of dchtCustom may change.
  /// </summary>
  dchtNone = 0;
  dchtCaption = 1;
  dchtClose = 2;
  dchtPin = 3;
  dchtCustom = 10;

  // Возвращает экземпляр класса управляющего положением форм-носителей
function FloatTreeCep: TFloatTreeCep;

//Находит орган управления с именем AControlName, который рекурсивно
//принадлежит любому компоненту внутри AOwn
//function findComponentEx(const AControlName: string; AOwn:TComponent):TControl;
//Возвращает полное названия и типы органа управления и всех его владельцев,
//разделенных точкой.
procedure GetFullName(Control: TControl; var Types: string; var Names: string); overload;
function GetFullName(Control:TControl):string; overload;

implementation

uses Types, GraphUtil;

{ TCaptionedDockTree }

procedure TCaptionedDockTree.AdjustDockRect(Control: TControl;
  var ARect: TRect);
begin
  if FDockCaptionOrientation = dcoHorizontal then
    Inc(ARect.Top, FGrabberSize)
  else
    Inc(ARect.Left, FGrabberSize)
end;

constructor TCaptionedDockTree.Create(DockSite: TWinControl);
begin
  inherited;

  FGrabberSize := GetSystemMetrics(SM_CYMENUSIZE) + 4;
  FDockCaptionDrawer := GetDockCaptionDrawer.Create(FDockCaptionOrientation);
  
end;

constructor TCaptionedDockTree.Create(DockSite: TWinControl;
  ADockCaptionOrientation: TDockCaptionOrientation);
begin
  FDockCaptionOrientation := ADockCaptionOrientation;
  Create(DockSite);
end;

class function TCaptionedDockTree.GetParentFormState(const Control: TControl): TParentFormState;
begin
  if Control is TCustomForm then
  begin
    Result.Caption := TCustomForm(Control).Caption;
    Result.Focused := (Screen.ActiveControl <> nil) and
      Screen.ActiveControl.Focused and
      (TWinControl(Control).ContainsControl(Screen.ActiveControl));
    if Control is TForm then
      Result.Icon := TForm(Control).Icon
    else
      Result.Icon := nil;
  end
  else
  begin

    Result.Caption := Control.Hint;
    Result.Focused := False;
    Result.Icon := nil;
  end;
  if Result.Focused then
  begin
    Result.StartColor := clActiveBorder;
    Result.EndColor := GetHighlightColor(clActiveBorder, 22);
    Result.FontColor := clBtnText;
  end
  else
  begin
    Result.StartColor := GetHighlightColor(clBtnFace, 5);
    Result.EndColor := GetHighlightColor(clBtnFace, 15);
    Result.FontColor := clBtnText;
  end;
end;

procedure TCaptionedDockTree.InvalidateDockSite(const Client: TControl);
var
  ParentForm: TCustomForm;
  Rect: TRect;
begin
  ParentForm := GetParentForm(Client, False);
  { Just invalidate the parent form's rect in the HostDockSite
    so that we can "follow focus" on docked items. }
  if (ParentForm <> nil) and (ParentForm.HostDockSite <> nil) then
  begin
    with ParentForm.HostDockSite do
      if UseDockManager and (DockManager <> nil) then
      begin
        DockManager.GetControlBounds(ParentForm, Rect);
        InvalidateRect(Handle, @Rect, False);
      end;
  end;
end;

function TCaptionedDockTree.AdjustCaptionRect(const ARect: TRect): TRect;
begin
  Result := ARect;
  if FDockCaptionOrientation = dcoHorizontal then
  begin
    Result.Bottom := Result.Top + FGrabberSize - 1;
    Result.Top := Result.Top + 1;
    Result.Right := Result.Right - 3; { Shrink the rect a little }
  end
  else
  begin
    Result.Right := Result.Left + FGrabberSize - 1;
    Result.Left := Result.Left + 1;
    Result.Bottom := Result.Bottom - 3;
  end;
end;

procedure TCaptionedDockTree.PaintDockFrame(Canvas: TCanvas;
  Control: TControl; const ARect: TRect);
begin
  FDockCaptionDrawer.DrawDockCaption(Canvas,
    AdjustCaptionRect(ARect),
    GetParentFormState(Control));
end;

procedure TCaptionedDockTree.WndProc(var Message: TMessage);
begin
  if Message.Msg = CM_DOCKNOTIFICATION then
  begin
    with TCMDockNotification(Message) do
    begin
      if NotifyRec.ClientMsg = CM_INVALIDATEDOCKHOST then
        InvalidateDockSite(TControl(NotifyRec.MsgWParam))
      else
        inherited;
    end;
  end
  else
    inherited;
end;

function TCaptionedDockTree.InternalCaptionHitTest(const Zone: TDockZone;
  const MousePos: TPoint): TDockCaptionHitTest;
var
  FrameRect, CaptionRect: TRect;
begin
  FrameRect := Zone.ChildControl.BoundsRect;
  AdjustDockRect(Zone.ChildControl, FrameRect);
  AdjustFrameRect(Zone.ChildControl, FrameRect);
  CaptionRect := AdjustCaptionRect(FrameRect);
  Result := FDockCaptionDrawer.DockCaptionHitTest(CaptionRect, MousePos);
end;

function TCaptionedDockTree.ZoneCaptionHitTest(const Zone: TDockZone;
  const MousePos: TPoint; var HTFlag: Integer): Boolean;
var
  HitTest: TDockCaptionHitTest;
begin
  HitTest := InternalCaptionHitTest(Zone, MousePos);
  if HitTest = dchtNone then
    Result := False
  else
  begin
    Result := True;
    if HitTest = dchtClose then
      HTFlag := HTCLOSE
    else if HitTest = dchtCaption then
      HTFlag := HTCAPTION;
  end;
end;

destructor TCaptionedDockTree.Destroy;
begin
  FDockCaptionDrawer.Free;
  inherited;
end;

class function TCaptionedDockTree.GetDockCaptionDrawer: TDockCaptionDrawerClass;
begin
  Result := TDockCaptionDrawer;
end;

{ TDockCaptionDrawer }

function TDockCaptionDrawer.CalcButtonSize(
  const CaptionRect: TRect): Integer;
const
  cButtonBuffer = 8;
begin
  if FDockCaptionOrientation = dcoHorizontal then
    Result := CaptionRect.Bottom - CaptionRect.Top - cButtonBuffer
  else
    Result := CaptionRect.Right - CaptionRect.Left - cButtonBuffer;
end;

constructor TDockCaptionDrawer.Create(
  DockCaptionOrientation: TDockCaptionOrientation);
begin
  FDockCaptionOrientation := DockCaptionOrientation;
end;

function TDockCaptionDrawer.DockCaptionHitTest(const CaptionRect: TRect;
  const MousePos: TPoint): TDockCaptionHitTest;
var
  CloseRect, PinRect: TRect;
begin
  if PtInRect(CaptionRect, MousePos) then
  begin
    CloseRect := GetCloseRect(CaptionRect);
    { Make the rect vertically the same size as the captionrect }
    if FDockCaptionOrientation = dcoHorizontal then
    begin
      CloseRect.Top := CaptionRect.Top;
      CloseRect.Bottom := CaptionRect.Bottom;
      Inc(CloseRect.Right);
    end
    else
    begin
      CloseRect.Left := CaptionRect.Left;
      CloseRect.Right := CaptionRect.Right;
      Inc(CloseRect.Bottom);
    end;
    if PtInRect(CloseRect, MousePos) then
      Result := dchtClose
    else if FDockCaptionPinButton <> dcpbNone then
    begin
      { did it hit the pin? }
      if FDockCaptionOrientation = dcoHorizontal then
      begin
        PinRect := GetPinRect(CaptionRect);
        PinRect.Top := CaptionRect.Top;
        PinRect.Bottom := CaptionRect.Bottom;
        Inc(PinRect.Right);
      end
      else
      begin
        PinRect := GetPinRect(CaptionRect);
        PinRect.Left := CaptionRect.Left;
        PinRect.Right := CaptionRect.Right;
        Inc(PinRect.Bottom);
      end;

      if PtInRect(PinRect, MousePos) then
        Result := dchtPin
      else
        Result := dchtCaption;
    end
    else
      Result := dchtCaption
  end
  else
    Result := dchtNone;
end;

procedure TDockCaptionDrawer.DrawDockCaption(const Canvas: TCanvas;
  CaptionRect: TRect; State: TParentFormState);

  procedure DrawCloseButton(const ARect: TRect);
  begin
    with ARect do
    begin
      Canvas.Pen.Color := Canvas.Font.Color;
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Width := 2;
      Canvas.MoveTo(Left+1, Top+1);
      Canvas.LineTo(Right-1, Bottom-1);
      Canvas.MoveTo(Left+1, Bottom-1);
      Canvas.LineTo(Right-1, Top+1);
    end;
  end;

  procedure DrawPinButton(const ARect: TRect);
  var
    Left, Top: Integer;
  begin
    Left := ARect.Left;
    Top := ARect.Top;

    Canvas.Pen.Color := Canvas.Font.Color;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 1;

    if FDockCaptionPinButton = dcpbDown then
    begin
      Inc(Top);
      { Draw the top box }
      Canvas.MoveTo(Left + 1, Top + 4);
      Canvas.LineTo(Left + 1, Top);
      Canvas.LineTo(Left + 5, Top);
      Canvas.LineTo(Left + 5, Top + 5);
      { Draw the middle line }
      Canvas.MoveTo(Left, Top + 5);
      Canvas.LineTo(Left + 7, Top + 5);
      { Draw a depth line }
      Canvas.MoveTo(Left + 4, Top + 1);
      Canvas.LineTo(Left + 4, Top + 5);
      Canvas.MoveTo(Left + 3, Top + 6);
      Canvas.LineTo(Left + 3, Top + 6 + 4);
    end
    else
    begin
      { Draw the right box }
      Canvas.MoveTo(Left + 4, Top + 1);
      Canvas.LineTo(Left + 9, Top + 1);
      Canvas.LineTo(Left + 9, Top + 5);
      Canvas.LineTo(Left + 3, Top + 5);
      { Draw the middle line }
      Canvas.MoveTo(Left + 3, Top);
      Canvas.LineTo(Left + 3, Top + 7);
      { Draw a depth line }
      Canvas.MoveTo(Left + 4, Top + 4);
      Canvas.LineTo(Left + 9, Top + 4);
      Canvas.MoveTo(Left, Top + 3);
      Canvas.LineTo(Left + 3, Top + 3);
    end;
  end;

  function RectWidth(const Rect: TRect): Integer;
  begin
    Result := Rect.Right - Rect.Left;
  end;

  procedure DrawIcon;
  var
    FormBitmap: TBitmap;
    DestBitmap: TBitmap;
    ImageSize: Integer;
    X, Y: Integer;
  begin
    if (State.Icon <> nil) and (State.Icon.HandleAllocated) then
    begin
      if FDockCaptionOrientation = dcoHorizontal then
      begin
        ImageSize := CaptionRect.Bottom - CaptionRect.Top - 3;
        X := CaptionRect.Left;
        Y := CaptionRect.Top + 2;
      end
      else
      begin
        ImageSize := CaptionRect.Right - CaptionRect.Left - 3;
        X := CaptionRect.Left + 1;
        Y := CaptionRect.Top;
      end;

      FormBitmap := nil;
      DestBitmap := TBitmap.Create;
      try
        FormBitmap := TBitmap.Create;
        DestBitmap.Width :=  ImageSize;
        DestBitmap.Height := ImageSize;
        DestBitmap.Canvas.Brush.Color := clFuchsia;
        DestBitmap.Canvas.FillRect(Rect(0, 0, DestBitmap.Width, DestBitmap.Height));
        FormBitmap.Width := State.Icon.Width;
        FormBitmap.Height := State.Icon.Height;
        FormBitmap.Canvas.Draw(0, 0, State.Icon);
        ScaleImage(FormBitmap, DestBitmap, DestBitmap.Width / FormBitmap.Width);

        DestBitmap.TransparentColor := DestBitmap.Canvas.Pixels[0, DestBitmap.Height - 1];
        DestBitmap.Transparent := True;

        Canvas.Draw(X, Y, DestBitmap);
      finally
        FormBitmap.Free;
        DestBitmap.Free;
      end;

      if FDockCaptionOrientation = dcoHorizontal then
        CaptionRect.Left := CaptionRect.Left + 6 + ImageSize
      else
        CaptionRect.Top := CaptionRect.Top + 6 + ImageSize;
    end;
  end;

var
  ShouldDrawClose: Boolean;
  CloseRect, PinRect: TRect;
begin
  Canvas.Font.Color := State.FontColor;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := State.StartColor;

  if FDockCaptionOrientation = dcoHorizontal then
  begin
    CaptionRect.Top := CaptionRect.Top + 1;

    { Give a rounded effect, draw a slightly smaller line on the left }
    Canvas.MoveTo(CaptionRect.Left + 2, CaptionRect.Top + 2);
    Canvas.LineTo(CaptionRect.Left + 2, CaptionRect.Bottom - 1);

    { Fill the middle with a gradient }
    GradientFillCanvas(Canvas, State.StartColor, State.EndColor,
      Rect(CaptionRect.Left+3, CaptionRect.Top, CaptionRect.Right,
      CaptionRect.Bottom), gdVertical);

    { Draw a slight outline }
    Canvas.Pen.Color := GetShadowColor(Canvas.Pen.Color, -20);
    with CaptionRect do
      Canvas.Polyline([Point(Left + 3, Top),
        Point(Right - 2, Top), { Top line }
        Point(Right, Top + 2), { Top right curve }
        Point(Right, Bottom - 2), { Right side line }
        Point(Right - 2, Bottom), { Bottom right curve }
        Point(Left + 3, Bottom), { Bottom line }
        Point(Left+1, Bottom - 2), { Bottom left curve }
        Point(Left+1, Top + 2), { Left side line }
        Point(Left + 3, Top)]); { Top left curve }


    { Get the close rect size/position }
    CloseRect := GetCloseRect(CaptionRect);
    { Does it have the pin button? Make some room for it, and draw it. }
    if FDockCaptionPinButton <> dcpbNone then
    begin
      PinRect := GetPinRect(CaptionRect);
      if FDockCaptionPinButton = dcpbUp then
        Inc(PinRect.Top); { Down a little further - better looks }
      DrawPinButton(PinRect);
      CaptionRect.Right := PinRect.Right - 2;
    end
    else
      { Shrink the rect to consider the close button on the right, and
        not draw text in it. }
      CaptionRect.Right := CloseRect.Right - 2;
    { Move away from the left edge a little before drawing text }
    CaptionRect.Left := CaptionRect.Left + 6;
    { Draw the icon, if found. }
    DrawIcon;
    ShouldDrawClose := CloseRect.Left >= CaptionRect.Left;
  end
  else
  begin
    { Give a rounded effect }
    Canvas.MoveTo(CaptionRect.Left + 1, CaptionRect.Top + 1);
    Canvas.LineTo(CaptionRect.Right - 1, CaptionRect.Top + 1);

    GradientFillCanvas(Canvas, State.StartColor, State.EndColor,
      Rect(CaptionRect.Left, CaptionRect.Top+2, CaptionRect.Right,
      CaptionRect.Bottom), gdVertical);

    Canvas.Pen.Color := State.EndColor;
    Canvas.MoveTo(CaptionRect.Left + 1, CaptionRect.Bottom);
    Canvas.LineTo(CaptionRect.Right - 1, CaptionRect.Bottom);

    Canvas.Font.Orientation := 900; { 90 degrees upwards }
    { Get the close rect size/position }
    CloseRect := GetCloseRect(CaptionRect);

    { Does it have the pin button? Make some room for it, and draw it. }
    if FDockCaptionPinButton <> dcpbNone then
    begin
      PinRect := GetPinRect(CaptionRect);
      DrawPinButton(PinRect);
      CaptionRect.Top := PinRect.Bottom + 2;
    end
    else
      { Add a little spacing between the close button and the text }
      CaptionRect.Top := CloseRect.Bottom + 2;

    ShouldDrawClose := CaptionRect.Top < CaptionRect.Bottom;
    { Make the captionrect horizontal for proper clipping }
    CaptionRect.Right := CaptionRect.Left + (CaptionRect.Bottom - CaptionRect.Top - 2);
    { Position the caption starting position at most at the bottom of the
      rectangle }
    CaptionRect.Top := CaptionRect.Top + Canvas.TextWidth(State.Caption) + 2;

    if CaptionRect.Top > CaptionRect.Bottom then
      CaptionRect.Top := CaptionRect.Bottom;
  end;

  Canvas.Brush.Style := bsClear; { For drawing the font }
  if State.Caption <> '' then
  begin
    if State.Focused then
      Canvas.Font.Style := Canvas.Font.Style + [fsBold]
    else
      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

   if ShouldDrawClose then
     CaptionRect.Right := CaptionRect.Right - (CloseRect.Right - CloseRect.Left) - 4;

    Canvas.TextRect(CaptionRect, State.Caption,
      [tfEndEllipsis, tfVerticalCenter, tfSingleLine]);
  end;

  if ShouldDrawClose then
    DrawCloseButton(CloseRect);
end;

const
  cSideBuffer = 4;

function TDockCaptionDrawer.GetCloseRect(const CaptionRect: TRect): TRect;
var
  CloseSize: Integer;
begin
  CloseSize := CalcButtonSize(CaptionRect);
  if FDockCaptionOrientation = dcoHorizontal then
  begin
    Result.Left := CaptionRect.Right - CloseSize - cSideBuffer;
    Result.Top := CaptionRect.Top + ((CaptionRect.Bottom - CaptionRect.Top) - CloseSize) div 2;
  end
  else
  begin
    Result.Left := CaptionRect.Left + ((CaptionRect.Right - CaptionRect.Left) - CloseSize) div 2;
    Result.Top := CaptionRect.Top + 2*cSideBuffer;
  end;
  Result.Right := Result.Left + CloseSize;
  Result.Bottom := Result.Top + CloseSize;
end;

function TDockCaptionDrawer.GetPinRect(const CaptionRect: TRect): TRect;
var
  PinSize: Integer;
begin
  PinSize := CalcButtonSize(CaptionRect);
  if FDockCaptionOrientation = dcoHorizontal then
  begin
    Result.Left := CaptionRect.Right - 2*PinSize - 2*cSideBuffer;
    Result.Top := CaptionRect.Top + ((CaptionRect.Bottom - CaptionRect.Top) - PinSize) div 2;
  end
  else
  begin
    Result.Left := CaptionRect.Left + ((CaptionRect.Right - CaptionRect.Left) - PinSize) div 2;
    Result.Top := CaptionRect.Top + 2*cSideBuffer + 2*PinSize;
  end;
  Result.Right := Result.Left + PinSize + 2;
  Result.Bottom := Result.Top + PinSize;
end;


{ TFloatTreeCep }
//Чтобы исключить мерцание форм-носителей, устанавливаем свойство Visible
//равным TimerVisible по таймеру. Т.е. сначала производится загрузка всех
//фреймов, а потом отображаются только те формы-носители, у которых
//контролы ни к чему не пристыкованы.
procedure StopVisibleChanged;
begin
  if IdTimer<>0 then
    if not KillTimer(0,IdTimer) then raise Exception.Create(SysErrorMessage(GetLastError))
                                 else IdTimer := 0;
end;

procedure VisibleChangedFunc(Wnd: HWND;
                             Msg: UINT;
                             idEvent: PINTEGER;
                             dwTime: DWORD);stdcall;
var i: integer;
begin
  if Application<>nil then
  begin
    for I := 0 to Application.ComponentCount - 1 do
      if Application.Components[i] is TCustomDockFormEx then
        with TCustomDockFormEx(Application.Components[i]) do
        begin
          if TimerVisible<>Visible then Visible := TimerVisible;
       end;
  end;
  StopVisibleChanged;
end;

procedure StartVisibleChanged;
begin
  if IdTimer=0 then
  begin
    IdTimer := SetTimer(0,98790,100,@VisibleChangedFunc);
  end;
end;

//Меняем прямоугольник, так чтобы он влезал в экран
procedure UpdateRectFromScreen(var ARect: TRect);
var W,H: integer;
begin
  with ARect do
  begin
    W := Right-Left;
    H := Bottom-Top;
    if Right<(W)div(2) then OffsetRect(ARect,-Left-(W)div(2),0);
    if Bottom<(H)div(2) then OffsetRect(ARect,0,-Top-(H)div(2));
    if Right-(W)div(2)>Screen.Width then OffsetRect(ARect,Screen.Width-Right+(W)div(2),0);
    if Bottom-(H)div(2)>Screen.Height then OffsetRect(ARect,0,Screen.Height-Bottom+(H)div(2));
  end;
end;

// Изображаем кравивый прямоугольник, с обрубленными краями
procedure DrawCapRect(DC:HDC; R:TRect; Size:Byte; StartColor,EndColor,BorderColor:TColor; Hor:boolean);
type
  COLOR16 = Word;
  PTriVertex = ^TTriVertex;
  _TRIVERTEX = packed record
    x: Longint;
    y: Longint;
    Red: COLOR16;
    Green: COLOR16;
    Blue: COLOR16;
    Alpha: COLOR16;
  end;
  TTriVertex = _TRIVERTEX;
  procedure RtoArrayPoint(R:TRect; Size:Byte; var A:Array of TPoint);
  begin
    if High(A)<8 then exit;
    A[0].x := R.Left+Size;     A[0].y := R.Top;
    A[1].x := R.Right-Size-1;  A[1].y := R.Top;
    A[2].x := R.Right-1;       A[2].y := R.Top+Size;
    A[3].x := R.Right-1;       A[3].y := R.Bottom-Size-1;
    A[4].x := R.Right-Size-1;  A[4].y := R.Bottom-1;
    A[5].x := R.Left+Size;     A[5].y := R.Bottom-1;
    A[6].x := R.Left;          A[6].y := R.Bottom-Size-1;
    A[7].x := R.Left;          A[7].y := R.Top+Size;
    A[8].x := R.Left+Size;     A[8].y := R.Top;
  end;
var
    P: array [0..8] of TPoint;
    Br: HBrush;
    Pen,OldPen:HPen;
    Vertexes: array[0..1] of TTriVertex;
    GradientRect: TGradientRect;
    p2: Windows.TTriVertex absolute Vertexes;
begin
  RtoArrayPoint(R,Size,P);
  StartColor := ColorToRGB(StartColor);
  EndColor := ColorToRGB(EndColor);
  if GetDeviceCaps(DC,BITSPIXEL)<16 then EndColor := StartColor;
  InflateRect(R,-1,-1);
  if StartColor<>EndColor then
  begin
    Vertexes[0].Red := Word(GetRValue(StartColor)) shl 8;
    Vertexes[0].Blue := Word(GetBValue(StartColor)) shl 8;
    Vertexes[0].Green := Word(GetGValue(StartColor)) shl 8;
    Vertexes[0].Alpha := 0;
    Vertexes[0].x := R.Left;
    Vertexes[0].y := R.Top;
    Vertexes[1].Red := Word(GetRValue(EndColor)) shl 8;
    Vertexes[1].Blue := Word(GetBValue(EndColor)) shl 8;
    Vertexes[1].Green := Word(GetGValue(EndColor)) shl 8;
    Vertexes[1].Alpha := 0;
    Vertexes[1].x := R.Right;
    Vertexes[1].y := R.Bottom;
    GradientRect.UpperLeft := 0;
    GradientRect.LowerRight := 1;
    if Hor then
      GradientFill(DC, {$IFDEF VER130}P2{$ELSE}@P2{$ENDIF}, 2, @GradientRect, 1, GRADIENT_FILL_RECT_V)
    else
      GradientFill(DC, {$IFDEF VER130}P2{$ELSE}@P2{$ENDIF}, 2, @GradientRect, 1, GRADIENT_FILL_RECT_H);
  end else
  begin
    Br := CreateSolidBrush(ColorToRGB(StartColor));
    FillRect(DC,R,Br);
    DeleteObject(Br);
  end;
  if BorderColor<>clNone then
  begin
    if BorderColor=clDefault then
    begin
      BorderColor :=  ((Word(GetRValue(StartColor))+Word(GetRValue(EndColor)))div(3))shl(0) +
                      ((Word(GetGValue(StartColor))+Word(GetGValue(EndColor)))div(3))shl(8) +
                      ((Word(GetBValue(StartColor))+Word(GetBValue(EndColor)))div(3))shl(16);
    end;
    Pen := CreatePen(ps_Solid,1,ColorToRGB(BorderColor));
    OldPen := SelectObject(DC,Pen);
    try
      Windows.Polyline(DC,P,9);
    finally
      SelectObject(DC,OldPen);
      DeleteObject(Pen);
    end;
  end;
end;


function FloatTreeCep: TFloatTreeCep;
begin
  if _FloatTreeCep=nil then _FloatTreeCep := TFloatTreeCep.Create;
  result := _FloatTreeCep;
end;

function TFloatTreeCep.CoordsByControl(Control: TControl;
  var Coord: TCoordsFloat): boolean;
var Names:String;
    i:integer;
begin
  result := false;
  Names:='';
  Names := GetFullName(Control);
  if Names<>'' then
  begin
    i := fList.IndexOf(Names);
    result := i>=0;
    if result then
    begin
      i := integer(fList.Objects[i]);
      Coord := fCoords[i]
    end;
  end;
end;

procedure TFloatTreeCep.DoAdd(const Names:String; const Coord:TCoordsFloat);
var i:integer;
begin
  with Coord do
  begin
    i := fList.IndexOf(Names);
    if i=-1 then
    begin
      i := Length(fCoords);
      setlength(fCoords,i+1);
      try
        fCoords[i].csSize := SizeOf(fCoords[i]);
        fCoords[i].R := R;
        fCoords[i].Visible := Visible;
        fList.AddObject(Names,TObject(i));
      except
        setlength(fCoords,i);
        raise;
      end;
      fList.Sort;
    end else
    begin
      i := integer(fList.Objects[i]);
      fCoords[i].csSize := SizeOf(fCoords[i]);
      fCoords[i].R := R;
      fCoords[i].Visible := Visible;
    end;
  end;
end;

procedure TFloatTreeCep.SaveControl(Control: TControl; R: TRect; Visible:boolean);
var Names,Types:String;
    Coord: TCoordsFloat;
begin
  if not Enabled then Exit;  
  Names:='';
  Types:='';
  GetFullName(Control, Types, Names);
  if Names<>'' then
  begin
    Names := Names+';'+Types;
    Coord.csSize := SizeOf(Coord);
    Coord.R := R;
    Coord.Visible := Visible;
    DoAdd(Names,Coord);
  end;
end;

procedure TFloatTreeCep.SaveForm(Form: TCustomDockForm);
begin
  if (Form<>nil) and (Form.ControlCount>0) then
  begin
    SaveControl(Form.Controls[0],Form.BoundsRect,Form.Controls[0].Visible);
  end;
end;

function TFloatTreeCep.RestoreForm(Form: TCustomDockForm): boolean;
var Coord:TCoordsFloat;
begin
  result := false;

  if (Form<>nil) and (Form.ControlCount>0) then
  begin
    result := CoordsByControl(Form.Controls[0],Coord);
    if result then
    with Coord.R do begin
      UpdateRectFromScreen(Coord.R);

          
    
      Form.SetBounds(Left,Top,Right-Left,Bottom-Top);

      
      if Form IS TCustomDockFormEx then
        TCustomDockFormEx(Form).TimerVisible := Coord.Visible
      else
        Form.Visible := Coord.Visible;
    end;
  end;
end;

procedure TFloatTreeCep.RestoreAllForm;
var i: integer;
    OldRestoredDockForm: boolean;
begin
  OldRestoredDockForm := RestoredDockForm;
  try
    for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i] is TCustomDockForm then
      RestoreForm(TCustomDockForm(Application.Components[i]));
  finally
    RestoredDockForm := OldRestoredDockForm;
  end;
end;

procedure TFloatTreeCep.SaveAllForm;
var i: integer;
begin
  for i := 0 to Application.ComponentCount - 1 do
    if Application.Components[i] is TCustomDockForm then
      SaveForm(TCustomDockForm(Application.Components[i]));
end;

//Возвращает полное названия и типы органа управления и всех его владельцев,
//разделенных точкой.
procedure GetFullName(Control: TControl; var Types: string; var Names: string);
var
  Own: TComponent;
begin
  Own := Control;
  while Own <> nil do
  begin
    if Names <> '' then
      Names := '.' + Names;
    if Types <> '' then
      Types := '.' + Types;
    Names := UpperCase(Own.Name) + Names;
    Types := UpperCase(Own.ClassType.ClassName) + Types;
    Own := Own.Owner;
  end;
end;

function GetFullName(Control:TControl):string;
var Names, Types: String;
begin
  result := '';
  if Control<>nil then
  begin
    GetFullName(Control, Types, Names);
    if Names<>'' then
    begin
      result := Names+';'+Types;
    end;
  end;
end;

constructor TFloatTreeCep.Create;
begin
  fList := TStringList.Create;
  fList.Sorted := true;
  fEnabled := true;
end;

destructor TFloatTreeCep.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TFloatTreeCep.GetCount: integer;
begin
  result := fList.Count;
end;

procedure TFloatTreeCep.SaveToStream(Stream: TStream);
var i,Siz: integer;
    S:string;
begin
  for i := 0 to Application.ComponentCount-1 do
  begin
    if Application.Components[i] is TCustomDockForm then
    begin
      SaveForm(TCustomDockForm(Application.Components[i]));
    end;
  end;
  Stream.Write(SignStreamFloatTreeCep,SizeOf(SignStreamFloatTreeCep));
  for i := 0 to fList.Count-1 do
  begin
    Stream.Write(fCoords[integer(fList.Objects[i])],fCoords[integer(fList.Objects[i])].csSize);
    S := fList[i];
    if S<>'' then
    begin
      Siz := Length(fList[i]);
      Stream.Write(Siz,SizeOf(Siz));
      Stream.Write(S[1],Siz);
    end else
    begin
      Siz := 0;
      Stream.Write(Siz,SizeOf(Siz));
    end;
  end;
  Siz := -1;
  Stream.Write(Siz,SizeOf(Siz));
end;

procedure TFloatTreeCep.SetEnabled(const Value: boolean);
begin
  if fEnabled<>Value then
  begin
    fEnabled := Value;
  end;
end;

procedure TFloatTreeCep.LoadFromStream(Stream: TStream);
var Siz: integer;
    OldPos:int64;
    Coord:TCoordsFloat;
    P:PChar;
begin
  if (Stream=nil) or (Stream.Size=0) then Exit;
  OldPos := Stream.Position;
  try
    Stream.Read(Siz,SizeOf(Siz));
    Siz := (Siz and ($0000FFFF));
    if Siz>(SignStreamFloatTreeCep  and ($0000FFFF)) then
      raise Exception.CreateFmt('',[Siz]);
  except
    Stream.Position := OldPos;
    raise;
  end;
  repeat
    OldPos := Stream.Position;
    try
      Stream.Read(Siz,SizeOf(Siz));
      if Siz = -1 then break;
      if Siz = SizeOf(TCoordsFloat) then
      begin
        Coord.csSize := Siz;
        P := @Coord;
        inc(integer(P),SizeOf(Coord.csSize));
        Stream.Read(P^,Coord.csSize-SizeOf(Coord.csSize));
      end else raise Exception.CreateFmt('Error Size',[Siz]);
      Stream.Read(Siz,SizeOf(Siz));
      if Siz>0 then
      begin
        P := nil;
        ReallocMem(P,Siz+1);
        try
          Fillchar(P^,Siz+1,0);
          Stream.Read(P^,Siz);
          DoAdd(String(P),Coord);
        finally
          ReallocMem(P,0);
        end;
      end;
    except
      Stream.Position := OldPos;
      raise;
    end;
  until Siz=-1;
end;


{ TCustomDockFormEx }

procedure TCustomDockFormEx.WMACTIVATEAPP(var Message: TWMACTIVATEAPP);
begin
  if Message.Active then
  begin
    // Когда приложение активизируется, форма располагается "всегда сверху"
    SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
  end else
  begin
    // Когда приложение становится пассивным, форма помещается под верхнее
    // окно и перестает быть всегда сверху
    SetWindowPos(Handle,GetForegroundWindow,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
    SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
  end;
  inherited;
end;

// Положение окна носителя определяется не системой, а программно (для BDS 2005)
constructor TCustomDockFormEx.Create(AOwner: TComponent);
begin
  inherited;
  //DragKind := dkDock;
  
  Position := poDesigned;
end;

// Перед уничтожением запоминаем координаты
destructor TCustomDockFormEx.Destroy;
begin
  FloatTreeCep.SaveForm(self);
  inherited;
end;

// Этот метод выполняется при добавлении контрола к форме
// У предка всегда устанавливается Visible=true, а в этом классе — НЕТ
procedure TCustomDockFormEx.DoAddDockClient(Client: TControl;
  const ARect: TRect);
var
  S: string;
  I: Integer;
begin
  if DockClientCount = 1 then
  begin
    { Use first docked control }
    with Client do
    begin
      fCaption := GetPropValue(Client,'Hint');

    end;
    Caption :=  fCaption; // S;
  end;
  Client.Parent := Self; // Вместо inherited DoAddDockClient(Client, ARect);
  Client.Align := alClient;
  if RestoredDockForm then
  begin                  // Если находимся в состоянии восстановления, устанавливаем координаты
      Position := poDesigned;
    if not FloatTreeCep.RestoreForm(self) and
      (not (csLoading in ComponentState)) then
    begin
      Visible := True;
      TimerVisible := true;
    end;
    Client.Visible := TimerVisible;
  end else               // Иначе сохраняем координаты
  begin
    if not (csLoading in ComponentState) then
      Visible := True;

    FloatTreeCep.SaveControl(Client,BoundsRect,true);
  end;
end;

procedure TCustomDockFormEx.DoHide;
begin
  inherited;
  fTimerVisible := False;
end;

procedure TCustomDockFormEx.DoShow;
begin
  inherited;
  fTimerVisible := true;
end;

procedure TCustomDockFormEx.SetTimerVisible(const Value: boolean);
begin
  fTimerVisible := Value;
  if fTimerVisible<>Visible then
  begin
    StartVisibleChanged;
  end;
end;

procedure TCustomDockFormEx.CMVISIBLECHANGED(var Message: TMessage);
begin
  inherited;
  if (ControlCount>0) and (ComponentState*[csDestroying, csLoading]=[]) then
  begin
    if (Message.WParam=0) then
      FloatTreeCep.SaveControl(Controls[0],BoundsRect,false)
    else if not RestoredDockForm then
               FloatTreeCep.SaveControl(Controls[0],BoundsRect,true);
  end;
end;


{ TCustomDockFormCep }

constructor TCustomDockFormCep.Create(AOwner: TComponent);
begin
  inherited;
  Ctl3D := False;
  Color := clBtnFace;
  inc(CountUsedBMP);
end;

destructor TCustomDockFormCep.Destroy;
begin
  inherited;
  if CountUsedBMP>0 then dec(CountUsedBMP);
  if CountUsedBMP=0 then
   FreeAndNil(TmpBitmap);
end;

// При смене активности надо перерисовать заголовок
procedure TCustomDockFormCep.WMACTIVATE(var Message: TWMACTIVATE);
begin
  inherited;
  Perform(WM_NCPAINT,0,0);
end;

// В зависимости от координат мыши возвращаем результат
procedure TCustomDockFormCep.WMNCHITTEST(var Message: TWMNCHITTEST);
var RR, R, CapRect, CloseRect: TRect;
    Pt: TPoint;
    InClose: Boolean;
begin
 if ctl3d then inherited
 else begin
   inherited;
   CalcRect(RR, R, CapRect, CloseRect, Pt);
   Pt.X := Message.XPos;
   Pt.Y := Message.YPos;
   Windows.ScreenToClient(Handle,Pt);
   inc(Pt.X,R.Left);
   inc(Pt.Y,R.Top);
   InClose := PtInRect(CloseRect, Pt);
   if PtInRect(CapRect,Pt) then
   begin
     Message.Result := HTCAPTION;
     if InClose then
       Message.Result := HTSYSMENU;
   end;
   if fInClose<>InClose then
   begin
      fInClose := InClose;
      Perform(WM_NCPAINT,0,0);
   end;
 end;
end;

procedure TCustomDockFormCep.CalcRect(var WindowRect, ClientRect, CaptionRect, CloseRect:TRect; var Pt: TPoint);
var B,T,DW:integer;
begin
  Windows.GetClientRect(Handle,ClientRect);
  Windows.GetWindowRect(Handle,WindowRect);
  Windows.GetCursorPos(Pt);
  Dec(Pt.X, WindowRect.Left);
  Dec(Pt.Y, WindowRect.Top);
  OffsetRect(WindowRect,-WindowRect.Left,-WindowRect.Top);
  B := (WindowRect.Right-ClientRect.Right)div(2);
  T := (WindowRect.Bottom-ClientRect.Bottom)-B;
  OffsetRect(ClientRect,B,T);
  CaptionRect := Rect(B,B,WindowRect.Right-B,T-1);
  DW := Windows.GetWindowLong(Handle, GWL_STYLE);
  T := CaptionRect.Bottom-CaptionRect.Top;
  if (DW and WS_SYSMENU)=WS_SYSMENU then
  begin
    CloseRect := Rect(CaptionRect.Right-2-T,CaptionRect.Bottom-T,CaptionRect.Right-2,CaptionRect.Bottom);
    if CloseRect.Left < CaptionRect.Left then CloseRect.Left := CaptionRect.Left;
  end else
  begin
    FillChar(CaptionRect,SizeOf(CaptionRect),$FF);
  end;
end;

//Выполняем отрисовку неклиентской области
procedure TCustomDockFormCep.WMNCPAINT(var Message: TWMNCPAINT);
var DC,BDC:HDC;
    R,RR,CapRect,CloseRect:TRect;
    Pt: TPoint;
    SDC,Siz,X,Y,W,H:integer;
    OldPen,Pen: HPen;
    OldBrush, Brush: HBrush;
    OldFont,Font:HFont;
    P:PWideChar;
    A:Array [0..512] of WideChar;
    NonClientMetrics: TNonClientMetrics;
    FontInfo: tagLOGFONTA;
begin
 if ctl3d then inherited
 else begin
  DC := 0;
  CalcRect(RR, R, CapRect, CloseRect, Pt);
  try
    DC := GetWindowDC(Handle);
    SDC := SaveDC(DC);
    Windows.ExcludeClipRect(DC,R.Left,R.Top,R.Right,R.Bottom);
    Windows.ExcludeClipRect(DC,CapRect.Left,CapRect.Top,CapRect.Right,CapRect.Bottom);
    if Active then
      Pen := CreatePen(ps_Solid,1,ColorToRGB(clHighlight))
    else
      Pen := CreatePen(ps_Solid,1,ColorToRGB(clWindowFrame));
    //Изображаем рамку
    Brush := CreateSolidBrush(ColorToRGB(Color));
    OldPen := SelectObject(DC,Pen);
    OldBrush := SelectObject(DC,Brush);
    try
      Rectangle(DC,RR.Left,RR.Top,RR.Right,RR.Bottom);
    finally
      SelectObject(DC,OldBrush);
      DeleteObject(Brush);
      SelectObject(DC, OldPen);
      DeleteObject(Pen);
    end;
    RestoreDC(DC,SDC);
    if CapRect.Bottom>CapRect.Top then begin
      X := CapRect.Left;
      Y := CapRect.Top;
      OffsetRect(CapRect,-X,-Y);
      OffsetRect(CloseRect,-X,-Y);
      W := CapRect.Right;
      H := CapRect.Bottom;
      Dec(Pt.X,X);
      Dec(Pt.Y,Y);
      if TmpBitmap = nil then TmpBitmap := TBitmap.Create;
      if TmpBitmap.Width<W then TmpBitmap.Width := W;
      if TmpBitmap.Height<H then TmpBitmap.Height := H;
      TmpBitmap.Canvas.Brush.Color := Color;
      TmpBitmap.Canvas.FillRect(Rect(0,0,W,H));
      TmpBitmap.Canvas.Lock;
      try
      BDC := TmpBitmap.Canvas.Handle;
      // Изображаем фон заголовка
      if Active then
        SetTextColor(BDC,ColorToRGB(clCaptionText))
      else
        SetTextColor(BDC,ColorToRGB(clInActiveCaptionText));
      SetBkMode(BDC,TRANSPARENT);
      if Active then
      begin
        DrawCapRect(BDC,CapRect,2,clActiveCaption,TColor($FF000000 or COLOR_GRADIENTACTIVECAPTION),clDefault,true);
      end else
      begin
        DrawCapRect(BDC,CapRect,2,clInActiveCaption,TColor($FF000000 or COLOR_GRADIENTINACTIVECAPTION),clDefault,true);
      end;
      //Изображаем крестик
      if CloseRect.Left<>CloseRect.Right then
      begin
        if PtInRect(CloseRect,Pt) then
        begin
          Pen := CreatePen(ps_Solid,2,{GetTextColor(BDC)}clWhite);
          if fCloseDown then
            OffsetRect(CloseRect,1,1);
        end else
        begin
          Pen := CreatePen(ps_Solid,2,ColorToRGB(clWhite));
        end;
        OldPen := SelectObject(BDC,Pen);
        try
          MoveToEx(BDC,CloseRect.Left+4, CloseRect.Top+4, @Pt);
          LineTo(BDC,CloseRect.Right-4, CloseRect.Bottom-4);
          MoveToEx(BDC,CloseRect.Right-4, CloseRect.Top+4, @Pt);
          LineTo(BDC,CloseRect.Left+4, CloseRect.Bottom-4);
        finally
          SelectObject(BDC, OldPen);
          DeleteObject(Pen);
        end;
        CapRect.Right := CloseRect.Left;
      end;
      //Изображаем тектст
      FillChar(A,SizeOf(A),0);
      P := @A;
      windows.GetWindowTextW(Handle,P,High(A));
      if P<>'' then
      begin
        OffsetRect(CapRect,3,0);
        Siz:=SizeOf(NonClientMetrics);
        FillChar(NonClientMetrics,Siz,0);
        NonClientMetrics.cbSize := Siz;
        if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
        with NonClientMetrics do FontInfo := lfSmCaptionFont;
        Font := CreateFontIndirect(FontInfo);
        OldFont := SelectObject(BDC,Font);
        try
          DrawTextW(BDC,P,-1,CapRect, DT_END_ELLIPSIS or DT_PATH_ELLIPSIS);
        finally
          SelectObject(BDC,OldFont);
          DeleteObject(Font);
        end;
      end;
      BitBlt(DC,X,Y,W,H,
             BDC,0,0,SRCCOPY);
      finally
       TmpBitmap.Canvas.UnLock;
      end;
    end;
  finally
    ReleaseDC(Handle,DC);
  end;
 end;
end;

procedure TCustomDockFormCep.WMNCLBUTTONDOWN(var Message: TWMNCLBUTTONDOWN);
begin
  inherited;
  if not ctl3d then
  begin
    if Message.HitTest = HTSYSMENU then
    begin
      fCloseDown := true;
      Perform(WM_NCPAINT,0,0);
    end;
  end;
end;

procedure TCustomDockFormCep.WMNCLBUTTONUP(var Message: TWMNCLBUTTONUP);
begin
  inherited;
  if not ctl3d then
  begin
    if (Message.HitTest = HTSYSMENU) and (fCloseDown) then
    begin
      fCloseDown := false;
      Perform(WM_NCPAINT,0,0);
      PostMessage(Handle,WM_SYSCOMMAND,SC_CLOSE, (Message.YCursor shl 16) or Message.XCursor);
    end;
    fCloseDown := false;
  end;
end;

procedure TCustomDockFormCep.WM_SETTEXT(var Message: TWMSETTEXT);
begin
  inherited;
  if (not ctl3d) and Visible then
  begin
    Perform(WM_NCPAINT,0,0);
  end;
end;


{ TDragDockObjectCep }

procedure TDragDockObjectCep.AdjustDockRect(ARect: TRect);
begin
 // inherited;
 // Если кому-то не нравится, что при нажатии на заголовок формы-носителя
 // меняются координаты перетаскиваемого объекта, здесь отключается
 // такое поведение.
end;

destructor TDragDockObjectCep.Destroy;
  {$IFDEF VER130}
  {$ELSE}
     {$IFDEF VER140}
     {$ELSE}
        var
           Form: TCustomForm;
     {$ENDIF}
  {$ENDIF}
begin
  {$IFDEF VER130}
  {$ELSE}
     {$IFDEF VER140}
     {$ELSE}
        Form := GetParentForm(Control);
        if Form is TCustomDockFormEx then TCustomDockFormEx(Form).AlphaBlend := false;
     {$ENDIF}
  {$ENDIF}
  inherited;
end;

procedure TDragDockObjectCep.DrawDragDockImage;
var
  P: TPoint;
  Form: TCustomForm;
begin
  if (not Control.Floating) or DockOvered then
    inherited DrawDragDockImage
  else
  begin
    Form := GetParentForm(Control);
    if Form <> nil then
    begin
      P := Point(Control.Left, Control.Top);
      if Control <> Form then
        MapWindowPoints(Form.Handle, 0, P, 1);
      Form.BoundsRect := Bounds(DockRect.Left + Form.Left - P.X,
        DockRect.Top + Form.Top - P.Y,
        DockRect.Right - DockRect.Left + Form.Width - Control.Width,
        DockRect.Bottom - DockRect.Top + Form.Height - Control.Height);
        {$IFDEF VER130}
        {$ELSE}
          {$IFDEF VER140}
          {$ELSE}
            if Form is TCustomDockFormEx then
            begin
              TCustomDockFormEx(Form).AlphaBlendValue := 128;
              TCustomDockFormEx(Form).AlphaBlend := true;
            end;
          {$ENDIF}
        {$ENDIF}
    end;
  end;
end;

procedure TDragDockObjectCep.EraseDragDockImage;
begin
  if (not Control.Floating) or DockOvered then
    inherited EraseDragDockImage
end;


procedure TDragDockObjectCep.SetDockOvered(const Value: boolean);
var OldEnabled:boolean;
begin
  if (Control.Parent is TCustomDockFormEx) and (Value<>fDockOvered) then
  begin
    OldEnabled := FloatTreeCep.Enabled;
    FloatTreeCep.Enabled := false;
    try
      if Value then
      begin
        Control.Parent.Hide;
        fDockOvered := Value;
        EraseDragDockImage;
      end else
      begin
        EraseDragDockImage;
        fDockOvered := Value;
        if (Control.Parent is TCustomDockFormEx) and fOveredTimer then
        begin
          TCustomDockFormEx(Control.Parent).TimerVisible := true;
          Control.Visible := true;
        end else
          Control.Parent.Show;
      end;
    finally
      FloatTreeCep.Enabled := OldEnabled;
    end;
  end;
end;


initialization
  DefaultDockTreeClass := TCaptionedDockTree;
  DefaultDockFormClass := {TCustomDockFormEx}TCustomDockFormCep;
end.
