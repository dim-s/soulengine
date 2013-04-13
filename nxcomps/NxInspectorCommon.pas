unit NxInspectorCommon;

interface

uses
  Types, Windows, Graphics, NxPropertyItems;

const
  spaImageStart = 3;
  spaImageToText = 8;
  spaMargin = 14;
  spaMarginToPlusBtn = 2;
  spaPreviewStart = 2;
  spaPreviewToText = 8;
  spaSplitterSpace = 2;
  spaTextStart = 3;

  sizButtonWidth = 14;                      { including small line on left side }
  sizPlusBtnHeight = 9;
  sizPlusBtnWidth = 9;
	sizPreview = 20;
  sizClientPreview = sizPreview + 2 + 4;

type
  TPropertyValuePart = (vpButton, vpPreview, vpSuffix, vpText, vpToolbar);
  TPropertyValueMembers = set of (vmButton, vmPreview, vmSuffix, vmText, vmToolbar);

function GetValuePartRect(Item: TNxPropertyItem; ValueRect:TRect; ValuePart: TPropertyValuePart): TRect;
procedure DrawArrow(Canvas: TCanvas; X, Y: Integer; Down: Boolean; AColor: TColor);
procedure DrawDots(Canvas: TCanvas; X, Y: Integer; AColor: TColor);
procedure DrawExpandingButton(Canvas: TCanvas; APoint: TPoint; Expanded, Root: Boolean; MarginColor: TColor);
procedure DrawImageFromRes(Canvas: TCanvas; X, Y: Integer; ResStr: WideString);
procedure DrawImageInRect(Canvas: TCanvas; ARect: TRect; FileName: WideString);
procedure DrawTextRect(Canvas: TCanvas; ARect: TRect; Text: WideString);
procedure SetClipingRect(Canvas: TCanvas; ARect: TRect);

implementation

uses
  NxPropertyItemClasses, ExtCtrls;

procedure DrawImageFromRes(Canvas: TCanvas; X, Y: Integer; ResStr: WideString);
var
  bi: TBitmap;
begin
  bi := TBitmap.Create;
  try
    bi.Transparent := True;
    bi.LoadFromResourceName(HInstance, ResStr);
    bi.TransparentColor := bi.Canvas.Pixels[0, bi.Height - 1];
    Canvas.Draw(X, Y, bi);
  finally
    bi.Free;
  end;
end;

function GetValuePartRect(Item: TNxPropertyItem;
  ValueRect: TRect; ValuePart: TPropertyValuePart): TRect;
  function GetButtonRect: TRect;
  begin
    Result := Rect(ValueRect.Right - sizButtonWidth, ValueRect.Top,
                    ValueRect.Right, ValueRect.Bottom)
  end;

  function GetPreviewRect: TRect;
  begin
    Result := Rect(ValueRect.Left, ValueRect.Top,
                    ValueRect.Left + sizClientPreview, ValueRect.Bottom)
  end;

  function GetSuffixRect: TRect;
  var
    m: Integer;
  begin
    m := ValueRect.Left + ((ValueRect.Right - ValueRect.Left) div 2);
    Result := Rect(m, ValueRect.Top, ValueRect.Right, ValueRect.Bottom);
  end;

  function GetTextRect: TRect;
  var
    vm: TPropertyValueMembers;
  begin
    Result := ValueRect;
    if vmPreview in vm then Result.Left := GetPreviewRect.Right;
    if vmButton in vm then Result.Right := GetButtonRect.Left;
    if vmSuffix in vm then Result.Right := GetSuffixRect.Left;
  end;

begin
  case ValuePart of
    vpButton: Result := GetButtonRect;
    vpText: Result := GetTextRect;
    vpSuffix: Result := GetSuffixRect;
    vpPreview: Result := GetPreviewRect;
    vpToolbar: Result := ValueRect;
  end;
end;

procedure DrawArrow(Canvas: TCanvas; X, Y: Integer; Down: Boolean; AColor: TColor);
begin
  with Canvas do
  begin
    Brush.Color := AColor;
    Pen.Color := AColor;
    if not Down
      then Polygon([Point(X, Y + 2), Point(X + 2, Y), Point(X + 4, Y + 2)])
        else Polygon([Point(X, Y), Point(X + 2, Y + 2), Point(X + 4, Y)]);
  end;
end;

procedure DrawDots(Canvas: TCanvas; X, Y: Integer; AColor: TColor);
begin
  with Canvas do
  begin
    Brush.Color := AColor;
    FillRect(Rect(X, Y, X + 2, Y + 2));
    FillRect(Rect(X + 3, Y, X + 5, Y + 2));
    FillRect(Rect(X + 6, Y, X + 8, Y + 2));
  end;
end;

procedure DrawExpandingButton(Canvas: TCanvas; APoint: TPoint;
	Expanded, Root: Boolean; MarginColor: TColor);
begin
  with Canvas, APoint do
  begin
    if Root then
		begin
	    Brush.Color := MarginColor;
	    if MarginColor <> clBlack then Pen.Color := clWindowText else Pen.Color := clWindow;
		end else
		begin
	    Brush.Color := clWindow;
	    if MarginColor <> clBlack then
			begin
	      Pen.Color := clWindowText;
			end else
      begin
 				Pen.Color := clWindow;
		    Brush.Color := MarginColor;
      end;
		end;
    Rectangle(Rect(X, Y, X + sizPlusBtnWidth, Y + sizPlusBtnWidth));
    MoveTo(X + 2, Y + 4);
    LineTo(X + 7, Y + 4);
    if not Expanded then         
    begin
      MoveTo(X + 4, Y + 2);
      LineTo(X + 4, Y + 7);
    end;
  end;
end;

procedure DrawImageInRect(Canvas: TCanvas; ARect: TRect; FileName: WideString);
var
  bi: TBitmap;
begin
  bi := TBitmap.Create;
  try
    bi.LoadFromFile(FileName);
    Canvas.StretchDraw(ARect, bi);
  finally
    bi.Free;
  end;
end;

procedure DrawTextRect(Canvas: TCanvas; ARect: TRect; Text: WideString);
var
  Flags: Integer;
begin
  Flags := DT_LEFT or DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_SINGLELINE;
  with Canvas.Brush do
  begin
    Style := bsClear;
    DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), ARect, Flags);
    Style := bsSolid;
  end;
end;

procedure SetClipingRect(Canvas: TCanvas; ARect: TRect);
var
  CLPRGN: HRGN;
begin
  with ARect do CLPRGN := CreateRectRgn(Left, Top, Right, Bottom);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;

end.
