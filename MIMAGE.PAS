{
  TMImage - delivered from TImage to create backgrounds in mosaic style
  Created by RSC <rsctm@freemail.hu>

  Addtional property:
  Mosaic: set it true if you wanna use the mosaic style

  The new component will be created into the Samples group!!
}
unit MImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics;

type
  TMImage = class(TGraphicControl)
  private
    FPicture: TPicture;
    FOnProgress: TProgressEvent;
    FStretch: boolean;
    FCenter: boolean;
    FIncrementalDisplay: boolean;
    FTransparent: boolean;
    FDrawing: boolean;
    FProportional: boolean;
    fMosaic: boolean;
    function GetCanvas: TCanvas;
    procedure PictureChanged(Sender: TObject);
    procedure SetCenter(Value: boolean);
    procedure SetPicture(Value: TPicture);
    procedure SetStretch(Value: boolean);
    procedure SetTransparent(Value: boolean);
    procedure SetProportional(Value: boolean);
  protected
    function CanAutoSize(var NewWidth, NewHeight: integer): boolean; override;
    function DestRect: TRect;
    function DoPaletteChange: boolean;
    function GetPalette: HPALETTE; override;
    procedure Paint; override;
    procedure Progress(Sender: TObject; Stage: TProgressStage;
      PercentDone: byte; RedrawNow: boolean; const R: TRect; const Msg: string); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read GetCanvas;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property Center: boolean read FCenter write SetCenter default False;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property IncrementalDisplay: boolean read FIncrementalDisplay
      write FIncrementalDisplay default False;
    property Mosaic: boolean read fMosaic write fMosaic default False;
    property ParentShowHint;
    property Picture: TPicture read FPicture write SetPicture;
    property PopupMenu;
    property Proportional: boolean
      read FProportional write SetProportional default False;
    property ShowHint;
    property Stretch: boolean read FStretch write SetStretch default False;
    property Transparent: boolean read FTransparent write SetTransparent default False;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation

uses Forms, Consts;

constructor TMImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FPicture.OnProgress := Progress;
  Height := 105;
  Width := 105;
end;

destructor TMImage.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

function TMImage.GetPalette: HPALETTE;
begin
  Result := 0;
  if FPicture.Graphic <> nil then
    Result := FPicture.Graphic.Palette;
end;

function TMImage.DestRect: TRect;
var
  w, h, cw, ch: integer;
  xyaspect: double;
begin
  w := Picture.Width;
  h := Picture.Height;
  cw := ClientWidth;
  ch := ClientHeight;
  if Stretch or (Proportional and ((w > cw) or (h > ch))) then
  begin
    if Proportional and (w > 0) and (h > 0) then
    begin
      xyaspect := w / h;
      if w > h then
      begin
        w := cw;
        h := Trunc(cw / xyaspect);
        if h > ch then  // woops, too big
        begin
          h := ch;
          w := Trunc(ch * xyaspect);
        end;
      end
      else
      begin
        h := ch;
        w := Trunc(ch * xyaspect);
        if w > cw then  // woops, too big
        begin
          w := cw;
          h := Trunc(cw / xyaspect);
        end;
      end;
    end
    else
    begin
      w := cw;
      h := ch;
    end;
  end;

  with Result do
  begin
    Left := 0;
    Top := 0;
    Right := w;
    Bottom := h;
  end;

  if Center then
    OffsetRect(Result, (cw - w) div 2, (ch - h) div 2);
end;

procedure TMImage.Paint;
var
  Save: boolean;
  x, y: integer;
begin
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
  Save := FDrawing;
  FDrawing := True;
  try
    if (fMosaic) and (Picture.Width > 0) and (Picture.Height > 0) then
    begin
      y := 0;
      while y < Height do
      begin
        x := 0;
        while x < Width do
        begin
          inherited Canvas.Draw(x, y, Picture.Graphic);
          x := x + Picture.Width;
        end;
        y := y + Picture.Height;
      end;
    end
    else
    begin
      with inherited Canvas do
        StretchDraw(DestRect, Picture.Graphic);
    end;
  finally
    FDrawing := Save;
  end;
end;

function TMImage.DoPaletteChange: boolean;
var
  ParentForm: TCustomForm;
  Tmp: TGraphic;
begin
  Result := False;
  Tmp := Picture.Graphic;
  if Visible and (not (csLoading in ComponentState)) and (Tmp <> nil) and
    (Tmp.PaletteModified) then
  begin
    if (Tmp.Palette = 0) then
      Tmp.PaletteModified := False
    else
    begin
      ParentForm := GetParentForm(Self);
      if Assigned(ParentForm) and ParentForm.Active and Parentform.HandleAllocated then
      begin
        if FDrawing then
          ParentForm.Perform(wm_QueryNewPalette, 0, 0)
        else
          PostMessage(ParentForm.Handle, wm_QueryNewPalette, 0, 0);
        Result := True;
        Tmp.PaletteModified := False;
      end;
    end;
  end;
end;

procedure TMImage.Progress(Sender: TObject; Stage: TProgressStage;
  PercentDone: byte; RedrawNow: boolean; const R: TRect; const Msg: string);
begin
  if FIncrementalDisplay and RedrawNow then
  begin
    if DoPaletteChange then
      Update
    else
      Paint;
  end;
  if Assigned(FOnProgress) then
    FOnProgress(Sender, Stage, PercentDone, RedrawNow, R, Msg);
end;

function TMImage.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if Picture.Graphic = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      Picture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  if Picture.Graphic is TBitmap then
    Result := TBitmap(Picture.Graphic).Canvas
  else
    raise EInvalidOperation.Create(SImageCanvasNeedsBitmap);
end;

procedure TMImage.SetCenter(Value: boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    PictureChanged(Self);
  end;
end;

procedure TMImage.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TMImage.SetStretch(Value: boolean);
begin
  if Value <> FStretch then
  begin
    FStretch := Value;
    PictureChanged(Self);
  end;
end;

procedure TMImage.SetTransparent(Value: boolean);
begin
  if Value <> FTransparent then
  begin
    FTransparent := Value;
    PictureChanged(Self);
  end;
end;

procedure TMImage.SetProportional(Value: boolean);
begin
  if FProportional <> Value then
  begin
    FProportional := Value;
    PictureChanged(Self);
  end;
end;

procedure TMImage.PictureChanged(Sender: TObject);
var
  G: TGraphic;
begin
  if AutoSize and (Picture.Width > 0) and (Picture.Height > 0) then
    SetBounds(Left, Top, Picture.Width, Picture.Height);
  G := Picture.Graphic;
  if G <> nil then
  begin
    if not ((G is TMetaFile) or (G is TIcon)) then
      G.Transparent := FTransparent;
    if (not G.Transparent) and Stretch and not Proportional then
      ControlStyle := ControlStyle + [csOpaque]
    else  // picture might not cover entire clientrect
      ControlStyle := ControlStyle - [csOpaque];
    if DoPaletteChange and FDrawing then
      Update;
  end
  else
    ControlStyle := ControlStyle - [csOpaque];
  if not FDrawing then
    Invalidate;
end;

function TMImage.CanAutoSize(var NewWidth, NewHeight: integer): boolean;
begin
  Result := True;
  if not (csDesigning in ComponentState) or (Picture.Width > 0) and
    (Picture.Height > 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      NewWidth := Picture.Width;
    if Align in [alNone, alTop, alBottom] then
      NewHeight := Picture.Height;
  end;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TMImage]);
end;

end.
