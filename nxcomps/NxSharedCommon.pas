{$I NxSuite.inc}

unit NxSharedCommon;

interface

uses
	Types, Classes, Windows, Graphics, ExtCtrls, Dialogs, SysUtils, Math,
  NxClasses, NxConsts, NxThemesSupport;

const
  PixelCountMax = 32768;

type
  THtmlTag = (htNone, htA, htB, htBr, htFont, htI, htU);
  TTagParameter = (tpNone, tpColor, tpName, tpHref, tpSize);


  PRGBTripleArray = ^TRGBTripleArray; { Windows unit }
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array[0..PixelCountMax - 1] of TRGBQuad;

	TCalcProvider = class
		class function GetRatio(const Value, Max: Double): Double;
		class function PosInRect(Width, Height, Margin: Integer; ARect: TRect;
		  Alignment: TAlignment; VerticalAlignment: TVerticalAlignment): TPoint;
		class function ResizeRect(ARect: TRect; DeltaLeft, DeltaTop,
    	DeltaRight, DeltaBottom: Integer): TRect;
    class function IsRectInRect(GuestRect, HostRect: TRect): Boolean;
  end;

  TGraphicsProvider = class
  	class function BlendColor(Color1, Color2: TColor; Amount: Integer): TColor; overload;
  	class function BlendColor(Color1, Color2: TColor; Ratio: Double): TColor; overload;
		class procedure DrawBitmapFromRes(Canvas: TCanvas; X, Y: Integer; ResStr: string;
	    Transparent: Boolean = True);
  	class procedure DrawButton(Canvas: TCanvas; ARect: TRect; OldStyle: Boolean);
    class procedure DrawFocused(Canvas: TCanvas; R: TRect;
    	XPStyle: Boolean = False);
    class procedure DrawGradient(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
    class procedure DrawVertGradient(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
    class procedure DrawCheckBox(Handle: THandle; Canvas: TCanvas; ARect: TRect;
    	Alignment: TAlignment; VerticalAlignment: TVerticalAlignment;
      Checked, Grayed, Hover: Boolean);
		class procedure DrawImageFromRes(Canvas: TCanvas; X, Y: Integer;
    	ResStr: string);
		class procedure DrawTextRect(Canvas: TCanvas; ARect: TRect;
    	Alignment: TAlignment; Text: WideString; BiDiMode: TBiDiMode = bdLeftToRight);
		class procedure DrawWrapedTextRect(Canvas: TCanvas; ARect: TRect;
    	Alignment: TAlignment; VerticalAlignment: TVerticalAlignment;
      WordWrap: Boolean; Text: WideString; BidiMode: TBiDiMode);
		class procedure SetClipingPolygon(Canvas: TCanvas; Points: array of TPoint; Count: Integer = 0);
		class procedure SetClipingRect(Canvas: TCanvas; ARect: TRect);
  end;

  TMaskProvider = class
		class function GetColorLevel(C: TColor): Integer;
		class function MixColors(C1, C2: TColor; W1: Integer): TColor;
		class procedure DrawMaskedImage(Canvas: TCanvas; Left, Top: Integer;
			Image, Mask: TBitmap);
		class procedure GetRGB(C: TColor; out R, G, B: Byte);
  end;

  TDrawProvider = class
		class procedure ApplyBitmap(Canvas: TCanvas; X, Y: Integer;
    	Bitmap: TBitmap);
		class procedure DrawBitmap(Canvas: TCanvas; X, Y: Integer;
    	Bitmap: TBitmap; BackgroundColor: TColor);
    class procedure GrayscaleBitmap(Canvas: TCanvas; X, Y: Integer;
      Bitmap: TBitmap; BackgroundColor: TColor);
  end;

  TDisplayProvider = class
    class procedure DrawFontPreview(Canvas: TCanvas; const ARect: TRect; FontName: string);
  end;

  THtmlInfo = record
    TagValue: WideString;
    Size: TSize;
  end;

function ProcessHTML(Canvas: TCanvas; Rect: TRect; HTML: WideString;
  Pos: TPoint; Indent: TIndent; DrawOnly: Boolean): THtmlInfo;
function GetHTMLColorName(ColorName: string): string;
function GetColorFromHTML(HTMLColor: string): TColor;
function HTMLColorToString(Color: TColor): string;
function PointOffset(Point1, Point2: TPoint; Distance: Integer): Boolean;
procedure ApplyBitmap(Canvas: TCanvas; X, Y: Integer; Bitmap: TBitmap);
procedure DrawPolyline(Canvas: TCanvas; Points: array of TPoint; Rect: TRect; Flip: Boolean);
procedure DrawTextRect(Canvas: TCanvas; ARect: TRect; Alignment: TAlignment; Text: WideString; BiDiMode: TBiDiMode = bdLeftToRight);
procedure DrawVerticalText(Canvas: TCanvas; Rect: TRect; Text: string);
procedure FlipPointsVert(var Points: array of TPoint; Rect: TRect);
procedure SetClipPoly(Canvas: TCanvas; Points: array of TPoint);
procedure SetClipRect(Canvas: TCanvas; ClipRect: TRect);
procedure Save32BitBitmap(ABitmap: TBitmap; FileName: string);

var
  IsUnicodeSupported: Boolean;

implementation


type
  PStyle = ^TStyle;
  TStyle = record
    FontName: TFontName;
    Size: Integer;
    Color: TColor;
    Style: TFontStyles;
    Prev: PStyle;
  end;

procedure AddStyle(Font: TFont; var Last: PStyle);
var
  AStyle: PStyle;
begin
  New(AStyle);
  AStyle^.Color := Font.Color;
  AStyle^.FontName := Font.Name;
  AStyle^.Size := Font.Size;
  AStyle^.Style := Font.Style;
  AStyle^.Prev := Last;
  Last := AStyle;
end;

procedure ClearStyles(var Last: PStyle);
var
  APrev: PStyle;
begin
  while Assigned(Last) do
  begin
    APrev := Last^.Prev;
    Dispose(Last);
    Last := APrev;
  end;
end;

procedure DeleteLast(Font: TFont; var Last: PStyle);
var
  OldLast: PStyle;
begin
  if Last <> nil then
  begin
    Font.Color := Last^.Color;
    Font.Name := Last^.FontName;
    Font.Size := Last^.Size;
    Font.Style := Last^.Style;
    OldLast := Last;
    Last := Last^.Prev;
    Dispose(OldLast);
  end;
end;

function ProcessHTML(Canvas: TCanvas; Rect: TRect; HTML: WideString; Pos: TPoint;
  Indent: TIndent; DrawOnly: Boolean): THtmlInfo;
var
  LastStyle: PStyle;
  i, X, Y, VertSpace: Integer;
  TagBuffer, ParamNameBuffer, ParamValueBuffer, TextBuffer, c: WideString;
  OpenQuote, TagReading, ParamNameReading, ParamValueReading, Closing: Boolean;
  CurrentTag: THtmlTag;
  TagRect: TRect;

  procedure RemoveQuotes(var S: WideString);
  begin
    if Copy(S, 1, 1) = '"' then Delete(S, 1, 1);
    if Copy(S, Length(S), 1) = '"' then Delete(S, Length(S), 1);
  end;
  
  procedure DrawTextOut(X, Y: Integer; Text: WideString);
  var
    StrText: string;
  begin
    if IsUnicodeSupported then Windows.ExtTextOutW(Canvas.Handle, X, Y, 0, nil,
      PWideChar(Text), Length(Text), nil) else
    begin
      StrText := Text;
      Windows.ExtTextOut(Canvas.Handle, X, Y, 0, nil, PChar(StrText),
        Length(StrText), nil);
    end;
  end;

  function GetTag(const TagName: WideString): THtmlTag;
  begin
    if LowerCase(TagName) = 'a' then Result := htA
    else if LowerCase(TagName) = 'b' then Result := htB
    else if LowerCase(TagName) = 'br' then Result := htBr
    else if LowerCase(TagName) = 'font' then Result := htFont
    else if LowerCase(TagName) = 'i' then Result := htI
    else if LowerCase(TagName) = 'u' then Result := htU
    else Result := htNone;
  end;

  function GetParameter(const ParameterName: WideString): TTagParameter;
  begin
    if LowerCase(ParameterName) = 'color' then Result := tpColor
    else if LowerCase(ParameterName) = 'href' then Result := tpHref
    else if LowerCase(ParameterName) = 'name' then Result := tpName
    else if LowerCase(ParameterName) = 'size' then Result := tpSize
    else Result := tpNone;
  end;

  procedure ApplyParameter(Tag: THtmlTag; Parameter: TTagParameter;
    Value: WideString);
  begin
    RemoveQuotes(Value);
    case Tag of
      htFont:
      case Parameter of
        tpColor: Canvas.Font.Color := GetColorFromHTML(Value);
        tpName: Canvas.Font.Name := Value;
        tpSize: Canvas.Font.Size := StrToInt(Value);
      end;
    end;
  end;

  procedure ApplyTag(Tag: THtmlTag; Parameter: TTagParameter;
    Value: WideString; Remowe: Boolean);
  begin
    if Tag = htBr then
    begin
      Inc(Y, VertSpace);
      X := Rect.Left + Indent.Left;
    end else
    begin
      if not Remowe then
      begin
        AddStyle(Canvas.Font, LastStyle);
        case Tag of
          htA:
          begin
            Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
            Canvas.Font.Color := clBlue;
            TagRect.Left := X - Rect.Left;
            TagRect.Top := Y - Rect.Top;
          end;
          htB: Canvas.Font.Style := Canvas.Font.Style + [fsBold];
          htI: Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
          htU: Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
        end;
      end else DeleteLast(Canvas.Font, LastStyle);
    end;
  end;
begin
  Result.Size.cx := 0;
  LastStyle := nil;
  X := Rect.Left + Indent.Left{ + 2};
  Y := Rect.Top + Indent.Top{ + 1};
  OpenQuote := False;
  TagReading := False;
  Closing := False;
  VertSpace := 0; { html allow only 1 space }
  ParamValueReading := False;
  ParamNameReading := False;
  Canvas.Brush.Style := bsClear;
  for i := 1 to Length(HTML) do
  begin
    c := HTML[i];
    if TagReading then { reading tag }
    begin
      if c = '>' then
      begin
        CurrentTag := GetTag(TagBuffer);
        if ParamValueReading then
        begin
          ApplyParameter(CurrentTag, GetParameter(ParamNameBuffer), ParamValueBuffer);
        end else
        begin
          ApplyTag(CurrentTag, GetParameter(ParamNameBuffer), ParamValueBuffer, Closing);
        end;
        TagReading := False;
        ParamNameReading := False;
        ParamValueReading := False;
        Closing := False;
        if not DrawOnly and (CurrentTag = htA) then
        begin
          TagRect.Right := X - Rect.Left;
          TagRect.Bottom := Y + VertSpace - Rect.Top;
          if PtInRect(TagRect, Pos) then Result.TagValue := ParamValueBuffer;
          RemoveQuotes(Result.TagValue);
        end;
      end                                  
      else if (c = ' ') and not OpenQuote then
      begin
        CurrentTag := GetTag(TagBuffer);
        if ParamValueReading then
        begin
          ApplyParameter(CurrentTag, GetParameter(ParamNameBuffer), ParamValueBuffer);
        end else
        begin
          ApplyTag(CurrentTag, GetParameter(ParamNameBuffer), ParamValueBuffer, Closing);
        end;
        ParamNameBuffer := '';
        ParamValueBuffer := '';
        ParamValueReading := False;
        ParamNameReading := True;
      end else if (c = '=') and not OpenQuote then
      begin
        ParamValueReading := True;
        ParamNameReading := False;
        ParamValueBuffer := '';
      end
      else if (c = '/') and not OpenQuote then Closing := True
      else begin
        if c = '"' then OpenQuote := not OpenQuote;
        if ParamValueReading then ParamValueBuffer := ParamValueBuffer + c
        else if ParamNameReading then ParamNameBuffer := ParamNameBuffer + c
        else TagBuffer := TagBuffer + c;
      end;
    end else
    begin
      if (HTML[i] = '<') and not OpenQuote then
      begin
        TagReading := True;
        TagBuffer := '';
        if DrawOnly then DrawTextOut(X, Y, TextBuffer);
        Inc(X, GetTextWidth(Canvas, TextBuffer));
        if X > Result.Size.cx then Result.Size.cx := X;
        if GetTextHeight(Canvas, TextBuffer) > VertSpace
          then VertSpace := GetTextHeight(Canvas, TextBuffer);
        TextBuffer := '';
      end else TextBuffer := TextBuffer + HTML[i];
    end;
  end;
  if (TextBuffer <> '') and DrawOnly then DrawTextOut(X, Y, TextBuffer);

  Inc(X, GetTextWidth(Canvas, TextBuffer));
  if X > Result.Size.cx then Result.Size.cx := X;

  Canvas.Brush.Style := bsSolid;
  ClearStyles(LastStyle);
  if TextBuffer = '' then TextBuffer := TagBuffer;
  Result.Size.cy := Y - Rect.Top + GetTextHeight(Canvas, TextBuffer);
end;

{ TCalcProvider }

class function TCalcProvider.GetRatio(const Value, Max: Double): Double;
begin
  Result := (Value / Max) * 100;
end;

class function TCalcProvider.IsRectInRect(GuestRect,
  HostRect: TRect): Boolean;
begin
  Result := not((GuestRect.Right < HostRect.Left) or (GuestRect.Left > HostRect.Right)
		or (GuestRect.Bottom < HostRect.Top) or (GuestRect.Top > HostRect.Bottom));
end;

class function TCalcProvider.PosInRect(Width, Height, Margin: Integer;
  ARect: TRect; Alignment: TAlignment;
  VerticalAlignment: TVerticalAlignment): TPoint;
begin
  case Alignment of
    taLeftJustify: Result.X := Margin + ARect.Left;
    taRightJustify: Result.X := ARect.Right - (Width + Margin);
    taCenter: Result.X := CenterPoint(ARect).X - Width div 2;
  end;
  case VerticalAlignment of
    taAlignTop: Result.Y := Margin + ARect.Top;
    taAlignBottom: Result.Y := ARect.Bottom - (Height + Margin);
    taVerticalCenter: Result.Y := CenterPoint(ARect).Y - Height div 2;
  end;
end;

class function TCalcProvider.ResizeRect(ARect: TRect; DeltaLeft, DeltaTop,
  DeltaRight, DeltaBottom: Integer): TRect;
begin
  with ARect do Result := Rect(Left + DeltaLeft, Top + DeltaTop, Right + DeltaRight, Bottom + DeltaBottom);
end;

{ TGraphicsProvider }

class function TGraphicsProvider.BlendColor(Color1, Color2: TColor;
  Amount: Integer): TColor;
var
  Value: Cardinal;
begin
  Assert(Amount in [0..255]);
  Value := Amount xor 255;
  if Integer(Color1) < 0 then Color1 := GetSysColor(Color1 and $000000FF);
  if Integer(Color2) < 0 then Color2 := GetSysColor(Color2 and $000000FF);
  Result := Integer(
    ((Cardinal(Color1) and $FF00FF) * Cardinal(Amount) +
    (Cardinal(Color2) and $FF00FF) * Value) and $FF00FF00 +
    ((Cardinal(Color1) and $00FF00) * Cardinal(Amount) +
    (Cardinal(Color2) and $00FF00) * Value) and $00FF0000) shr 8;
end;

class function TGraphicsProvider.BlendColor(Color1, Color2: TColor;
  Ratio: Double): TColor;
var
	r, g, b, r0, g0, b0, r1, g1, b1: Integer;
begin
  if Integer(Color1) < 0 then Color1 := GetSysColor(Color1 and $000000FF);
  if Integer(Color2) < 0 then Color2 := GetSysColor(Color2 and $000000FF);
	r0 := GetRValue(Color1);
	g0 := GetGValue(Color1);
	b0 := GetBValue(Color1);
	r1 := GetRValue(Color2);
	g1 := GetGValue(Color2);
	b1 := GetBValue(Color2);
	r := round(Ratio * r1 + (1 - Ratio) * R0);
	g := round(Ratio * g1 + (1 - Ratio) * g0);
	b := round(Ratio * b1 + (1 - Ratio) * b0);
	Result := RGB(r, g, b);
end;

class procedure TGraphicsProvider.SetClipingPolygon(Canvas: TCanvas;
  Points: array of TPoint; Count: Integer = 0);
var
  CLPRGN: HRGN;
begin
  //if Count = 0 then CLPRGN := CreatePolygonRgn(Points, High(Points), WINDING)
  CLPRGN := CreatePolygonRgn(Points, High(Points), WINDING);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;

class procedure TGraphicsProvider.SetClipingRect(Canvas: TCanvas; ARect: TRect);
var
  CLPRGN: HRGN;
begin
  with ARect do CLPRGN := CreateRectRgn(Left, Top, Right, Bottom);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;

class procedure TGraphicsProvider.DrawBitmapFromRes(Canvas: TCanvas; X,
  Y: Integer; ResStr: string; Transparent: Boolean = True);
var
  bi: TBitmap;
begin
  bi := TBitmap.Create;
  try
    bi.LoadFromResourceName(HInstance, ResStr);
		if Transparent then
    begin
	    bi.Transparent := True;
	    bi.TransparentColor := bi.Canvas.Pixels[0, bi.Height - 1];
    end;
    Canvas.Draw(X, Y, bi);
  finally
    bi.Free;
  end;
end;

class procedure TGraphicsProvider.DrawButton(Canvas: TCanvas; ARect: TRect; OldStyle: Boolean);
var
  InRect: TRect;
begin
	InRect := ARect;
  InflateRect(InRect, -1, -1);
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(InRect);
    if not OldStyle then Frame3D(Canvas, ARect, clBtnHighlight, clBtnShadow, 1)
    	else Frame3D(Canvas, ARect, clBtnHighlight, clWindowFrame, 1);
  end;
end;

class procedure TGraphicsProvider.DrawFocused(Canvas: TCanvas; R: TRect;
	XPStyle: Boolean = False);
var
  PrevBkColor, PrevTextColor: TColorRef;
  DC: HDC;
begin
	if XPStyle then
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := clHighlight;
    Canvas.FrameRect(R);
  end else
  begin
    DC := Canvas.Handle;
    PrevBkColor := SetBkColor(DC, clBlack);
    PrevTextColor := SetTextColor(DC, clWhite);
    Windows.DrawFocusRect(DC, R);
    SetBkColor(DC, PrevBkColor);
    SetTextColor(DC, PrevTextColor);
  end;
end;

class procedure TGraphicsProvider.DrawImageFromRes(Canvas: TCanvas; X,
  Y: Integer; ResStr: string);
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

class procedure TGraphicsProvider.DrawCheckBox(Handle: THandle; Canvas: TCanvas; ARect: TRect;
	Alignment: TAlignment; VerticalAlignment: TVerticalAlignment; Checked, Grayed, Hover: Boolean);
var
  p: TPoint;
  Theme: THandle;
  Index: Integer;
  r: TRect;
begin
	if IsThemed then
  begin
	  p := TCalcProvider.PosInRect(13, 13, 2, ARect, Alignment, VerticalAlignment);
	  r := Rect(p.X, p.Y, p.X + 13, p.Y + 13);
    Index := 1;
    if Hover then
		begin
    	if Checked then
			begin
	      if Grayed then Index := 7 else Index := 6;
			end else
      begin
	      if Grayed then Index := 3 else Index := 2;
      end;
		end else if Checked then Index := 5;
	  Theme := OpenThemeData(Handle, 'Button');
	  DrawThemeBackground(Theme, Canvas.Handle, 3, Index, r, nil);
	  CloseThemeData(Theme);
  end else
  begin
	  p := TCalcProvider.PosInRect(11, 11, 2, ARect, Alignment, VerticalAlignment);
	  r := Rect(p.X, p.Y, p.X + 11, p.Y + 11);
    with Canvas, ARect, p do
    begin
      if Grayed then Brush.Color := clBtnFace else Brush.Color := clWindow;
      Pen.Color := clBtnShadow;
      Rectangle(r);
      Pen.Color := clWindowText;
      if Checked = true then
      begin
        Polyline([Point(X + 2, Y + 4), Point(X + 4, Y + 6), Point(X + 9, Y + 1)]);
        Polyline([Point(X + 2, Y + 5), Point(X + 4, Y + 7), Point(X + 9, Y + 2)]);
        Polyline([Point(X + 2, Y + 6), Point(X + 4, Y + 8), Point(X + 9, Y + 3)]);
      end;
    end;
  end;
end;

class procedure TGraphicsProvider.DrawGradient(Canvas: TCanvas; ARect: TRect;
  FromColor, ToColor: TColor);
var
	i, p, Distance: Integer;
begin
  Distance := ARect.Bottom - ARect.Top;
  if Distance = 0 then Exit;
  for i := ARect.Top to ARect.Bottom - 1 do
  begin
  	p := i - ARect.Top;
    Canvas.Pen.Color := BlendColor(FromColor, ToColor, p / Distance);
		Canvas.MoveTo(ARect.Left, i);
		Canvas.LineTo(ARect.Right, i);
		if p >= Distance then Exit;
  end;
end;

class procedure TGraphicsProvider.DrawTextRect(Canvas: TCanvas; ARect: TRect;
	Alignment: TAlignment; Text: WideString; BiDiMode: TBiDiMode = bdLeftToRight);
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_NOPREFIX or	DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_SINGLELINE;
  case Alignment of
    taLeftJustify: Flags := Flags or DT_LEFT;
    taRightJustify: Flags := Flags or DT_RIGHT;
    taCenter: Flags := Flags or DT_CENTER;
  end;
  if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
  with Canvas.Brush do
  begin
    Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), ARect, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), ARect, Flags);
              end;
    end;
    Style := bsSolid;
  end;
end;

class procedure TGraphicsProvider.DrawWrapedTextRect(Canvas: TCanvas;
  ARect: TRect; Alignment: TAlignment; VerticalAlignment: TVerticalAlignment;
  WordWrap: Boolean; Text: WideString; BidiMode: TBiDiMode);
var
  Flags: Integer;
  r, rr: TRect;
  StringText: string;
begin
  r := ARect;
  Flags := DT_NOPREFIX; { don't replace & char }
  with Canvas do
  begin
    case Alignment of
      taLeftJustify: Flags := Flags or DT_LEFT;
      taRightJustify: Flags := Flags or DT_RIGHT;
      taCenter: Flags := Flags or DT_CENTER;
    end;
    if WordWrap then
    begin
      Flags := Flags or DT_TOP;
      Flags := Flags or DT_WORDBREAK;
      rr := r;
      StringText := Text;
      if IsUnicodeSupported then
        DrawTextExW(Canvas.Handle, PWideChar(Text), -1, rr, Flags or DT_CALCRECT, nil)
          {$IFDEF DELPHI2009}
          else Windows.DrawTextEx(Canvas.Handle, PWideChar(Text), -1, rr, Flags or DT_CALCRECT, nil);
          {$ELSE}
          else Windows.DrawTextEx(Canvas.Handle, PAnsiChar(StringText), -1, rr, Flags or DT_CALCRECT, nil);
          {$ENDIF}
      case VerticalAlignment of
        taAlignTop: Flags := Flags or DT_TOP;
        taVerticalCenter: r.top := r.top + Round((r.bottom - rr.bottom ) / 2);
        taAlignBottom: r.top := r.Bottom - (rr.bottom - rr.top);
      end;
    end else begin
      case VerticalAlignment of
        taAlignTop: Flags := Flags or DT_TOP;
        taVerticalCenter: Flags := Flags or DT_VCENTER;
        taAlignBottom: Flags := Flags or DT_BOTTOM;
      end;
      Flags := Flags or DT_SINGLELINE;
    end;

    if BidiMode = bdRightToLeft then Flags := Flags or DT_RTLREADING;
    Brush.Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), r, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), r, Flags);
              end;
    end;
    Brush.Style := bsSolid;
  end;
end;

{class procedure TGraphicsProvider.DrawWrapedTextRect(Canvas: TCanvas;
  ARect: TRect; Alignment: TAlignment; VerticalAlignment: TVerticalAlignment;
  WordWrap: Boolean; Text: WideString; BidiMode: TBiDiMode);
var
  Flags: Integer;
  r: TRect;
  StringText: string;
begin
  r := ARect;
  Flags := DT_NOPREFIX;
  with Canvas do
  begin
    case Alignment of
      taLeftJustify: Flags := Flags or DT_LEFT;
      taRightJustify: Flags := Flags or DT_RIGHT;
      taCenter: Flags := Flags or DT_CENTER;
    end;
    case VerticalAlignment of
      taAlignTop: Flags := Flags or DT_TOP;
      taVerticalCenter: Flags := Flags or DT_VCENTER;
      taAlignBottom: Flags := Flags or DT_BOTTOM;
    end;
    if WordWrap then Flags := Flags or DT_WORDBREAK else Flags := Flags or DT_SINGLELINE;
    if BidiMode = bdRightToLeft then Flags := Flags or DT_RTLREADING;
    Brush.Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), r, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), r, Flags);
              end;
    end;
    Brush.Style := bsSolid;
  end;
end;                   }

class procedure TGraphicsProvider.DrawVertGradient(Canvas: TCanvas;
  ARect: TRect; FromColor, ToColor: TColor);
var
	i, p, Distance: Integer;
begin
  Distance := ARect.Right - ARect.Left;
  if Distance = 0 then Exit;
  for i := ARect.Left to ARect.Right - 1 do
  begin
  	p := i - ARect.Left;
    Canvas.Pen.Color := BlendColor(FromColor, ToColor, p / Distance);
		Canvas.MoveTo(i, ARect.Top);
		Canvas.LineTo(i, ARect.Bottom);
		if p >= Distance then Exit;
  end;
end;

{ TGraphicsProvider }

class function TMaskProvider.GetColorLevel(C: TColor): Integer;
begin
  if C < 0 then C := GetSysColor(C and $FF);
  Result := ((C shr 16 and $FF) * 28 + (C shr 8 and $FF) * 151 +
    (C and $FF) * 77) shr 8;
end;

class function TMaskProvider.MixColors(C1, C2: TColor; W1: Integer): TColor;
var
  W2: Cardinal;
begin
  Assert(W1 in [0..255]);
  W2 := W1 xor 255;
  if Integer(C1) < 0 then C1 := GetSysColor(C1 and $000000FF);
  if Integer(C2) < 0 then C2 := GetSysColor(C2 and $000000FF);
  Result := Integer(
    ((Cardinal(C1) and $FF00FF) * Cardinal(W1) +
    (Cardinal(C2) and $FF00FF) * W2) and $FF00FF00 +
    ((Cardinal(C1) and $00FF00) * Cardinal(W1) +
    (Cardinal(C2) and $00FF00) * W2) and $00FF0000) shr 8;
end;

class procedure TMaskProvider.DrawMaskedImage(Canvas: TCanvas; Left, Top: Integer;
	Image, Mask: TBitmap);
var
	x, y, level: Integer;
  c: TColor;
  P, Pa, Pb : PRGBTripleArray;
  Background: TBitmap;
  r1, r2: TRect;
begin
	if (Image.Width <> Mask.Width) or (Image.Height <> Mask.Height) then
  begin
		raise Exception.Create('Image and Mask size differ');
    Exit;    
  end;
  Background := TBitmap.Create;
  Background.Width := Image.Width;
  Background.Height := Image.Height;
  r1 := Rect(Left, Top, Left + Image.Width, Top + Image.Height);
  r2 := Rect(0, 0, Image.Width, Image.Height);
  Background.Canvas.CopyRect(r2, Canvas, r1);

  Image.PixelFormat := pf24bit;
  Mask.PixelFormat := pf24bit;
  Background.PixelFormat := pf24bit;
	for y := 0 to Image.Height - 1 do
  begin
  	P := Image.ScanLine[y];
  	Pa := Mask.ScanLine[y];
    Pb := Background.ScanLine[y];
		for x := 0 to Image.Width -1 do
		begin
	  	level := TMaskProvider.GetColorLevel(RGB(Pa[x].rgbtRed, Pa[x].rgbtGreen, Pa[x].rgbtBlue));
      with P[x] do
      begin
	    	c := TMaskProvider.MixColors(RGB(rgbtRed, rgbtGreen, rgbtBlue), RGB(Pb[x].rgbtRed, Pb[x].rgbtGreen, Pb[x].rgbtBlue), level);
        TMaskProvider.GetRGB(c, Pb[x].rgbtRed, Pb[x].rgbtGreen, Pb[x].rgbtBlue);
      end;
		end;
  end;
  Canvas.Draw(Left, Top, Background);
  Background.Free;
end;

class procedure TMaskProvider.GetRGB(C: TColor; out R, G, B: Byte);
begin
  if Integer(C) < 0 then C := GetSysColor(C and $000000FF);
  R := C and $FF;
  G := C shr 8 and $FF;
  B := C shr 16 and $FF;
end;

{ TDrawProvider }

class procedure TDrawProvider.ApplyBitmap(Canvas: TCanvas; X, Y: Integer;
  Bitmap: TBitmap);
	procedure SetColorValues24(var P: PByte; var r, g, b: Byte);
  begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
    Inc(P);
  end;

	procedure SetColorValues32(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
  end;

	procedure PutColorValues(var P: PByte; r, g, b: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    Inc(P); // skip alpha chanel
  end;

  procedure Draw24BitBitmap;
  var
    i, j: Integer;
    Back :TBitmap;
    BackRow: PRGBTripleArray;
    ForeRow: PRGBQuadArray;
    function DoCombine(F, B, A :byte) :byte;
    begin
      Result := EnsureRange((Round(F * A / 255) + Round(B * (1 - (A / 255)))), 0, 255);
    end;
  begin
    back := TBitmap.Create;
    back.Width := Bitmap.Width;
    back.Height := Bitmap.Height;
    back.PixelFormat := pf24bit;
    back.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(X, Y, X + Bitmap.Width, Y + Bitmap.Height));

    for i := 0 to Bitmap.Height -1 do
    begin
      BackRow := Back.ScanLine[i];
      ForeRow := Bitmap.ScanLine[i];
      for j := 0 to Bitmap.Width -1 do
      begin
        BackRow[j].rgbtRed := DoCombine(ForeRow[j].rgbRed, BackRow[j].rgbtRed, ForeRow[j].rgbReserved);
        BackRow[j].rgbtGreen := DoCombine(ForeRow[j].rgbGreen, BackRow[j].rgbtGreen, ForeRow[j].rgbReserved);
        BackRow[j].rgbtBlue := DoCombine(ForeRow[j].rgbBlue, BackRow[j].rgbtBlue, ForeRow[j].rgbReserved);
      end;
    end;
    Canvas.Draw(X, Y, Back);
    back.Free;
  end;

	procedure Draw32BitBitmap;
	var
		i, j: Integer;
	  c: TColor;
	  P, P2, P3: PByte;
    r, g, b, r2, g2, b2, level: Byte;
    bmp, back: TBitmap;
	begin
    bmp := TBitmap.Create;
    bmp.Width := Bitmap.Width;
    bmp.Height := Bitmap.Height;
    bmp.Assign(Bitmap);

    back := TBitmap.Create;
    back.Width := Bitmap.Width;
    back.Height := Bitmap.Height;
    back.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(X, Y, X + Bitmap.Width, Y + Bitmap.Height));

		for i := 0 to Bitmap.Height - 1 do
	  begin
	  	P := Bitmap.ScanLine[i];
      P2 := bmp.ScanLine[i];
      P3 := back.ScanLine[i];
			for j := 0 to Bitmap.Width -1 do
			begin
        SetColorValues32(P, r, g, b, level);
        SetColorValues24(P3, r2, g2, b2);
	    	c := TMaskProvider.MixColors(RGB(r, g, b), RGB(r2, g2, b2), level);
        PutColorValues(P2, GetRValue(c), GetGValue(c), GetBValue(c));
			end;
	  end;
	  Canvas.Draw(X, Y, bmp);
    bmp.Free;
    back.Free;
  end;
begin
	case Bitmap.PixelFormat of
    pf32bit: Draw24BitBitmap;
  	else Canvas.Draw(X, Y, Bitmap);
  end;
end;

class procedure TDrawProvider.DrawBitmap(Canvas: TCanvas; X, Y: Integer;
  Bitmap: TBitmap; BackgroundColor: TColor);
	procedure SetColorValues(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
  end;

	procedure PutColorValues(var P: PByte; r, g, b: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    Inc(P); // skip alpha chanel
  end;

	procedure Draw32BitBitmap;
	var
		i, j: Integer;
	  c: TColor;
	  P, P2: PByte;
    r, g, b, level: Byte;
    bmp: TBitmap;
	begin
    bmp := TBitmap.Create;
    bmp.Width := Bitmap.Width;
    bmp.Height := Bitmap.Height;
    bmp.Assign(Bitmap);

		for i := 0 to Bitmap.Height - 1 do
	  begin
	  	P := Bitmap.ScanLine[i];
      P2 := bmp.ScanLine[i];
			for j := 0 to Bitmap.Width - 1 do
			begin
        SetColorValues(P, r, g, b, level);
	    	c := TMaskProvider.MixColors(RGB(r, g, b), BackgroundColor, level);
        PutColorValues(P2, GetRValue(c), GetGValue(c), GetBValue(c));
			end;
	  end;
	  Canvas.Draw(X, Y, bmp);
    bmp.Free;
  end;
begin
	case Bitmap.PixelFormat of
    pf32bit: Draw32BitBitmap;
  	else Canvas.Draw(X, Y, Bitmap);
  end;
end;

class procedure TDrawProvider.GrayscaleBitmap(Canvas: TCanvas; X, Y: Integer;
  Bitmap: TBitmap; BackgroundColor: TColor);
  procedure GrayscaleBitmap;
  type
    TRGBArray = array[0..32767] of TRGBTriple;
    PRGBArray = ^TRGBArray;
  var
    x, y, Gray: Integer;
    Row: PRGBArray;
  begin
    Bitmap.PixelFormat := pf24Bit;
    for y := 0 to Bitmap.Height - 1 do
    begin
      Row := Bitmap.ScanLine[y];
      for x := 0 to Bitmap.Width - 1 do
      begin
        Gray := (Row[x].rgbtRed + Row[x].rgbtGreen + Row[x].rgbtBlue) div 3;
        Row[x].rgbtRed := Gray;
        Row[x].rgbtGreen := Gray;
        Row[x].rgbtBlue := Gray;
      end;
    end;
  end;

	procedure SetColorValues(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
  end;

  procedure PutColorValues32(var P: PByte; r, g, b: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    Inc(P); // skip alpha chanel
  end;

	procedure Grayscale32BitBitmap;
	var
		i, j: Integer;
	  c, gr: TColor;
	  P, P2: PByte;
    r, g, b, level: Byte;
    bmp: TBitmap;
	begin
    bmp := TBitmap.Create;
    bmp.Width := Bitmap.Width;
    bmp.Height := Bitmap.Height;
    bmp.Assign(Bitmap);

		for i := 0 to Bitmap.Height - 1 do
	  begin
	  	P := Bitmap.ScanLine[i];
      P2 := bmp.ScanLine[i];
			for j := 0 to Bitmap.Width - 1 do
			begin
        SetColorValues(P, r, g, b, level);
        gr := (r + g + b) div 3;
	    	c := TMaskProvider.MixColors(gr, BackgroundColor, level);
        PutColorValues32(P2, GetRValue(c), GetGValue(c), GetBValue(c));
			end;
	  end;
	  Canvas.Draw(X, Y, bmp);
    bmp.Free;
  end;

begin
	case Bitmap.PixelFormat of
    pf32bit: Grayscale32BitBitmap;
  	else GrayscaleBitmap;
  end;
end;

{ TDisplayProvider }

class procedure TDisplayProvider.DrawFontPreview(Canvas: TCanvas;
  const ARect: TRect; FontName: string);
begin
  with Canvas do
  begin
    Brush.Color := clHighlight;
    Font.Size := 8;
    Font.Color := clHighlightText;
    Font.Name := FontName;
    TextRect(ARect, ARect.Left, ARect.Top, 'ab');
  end;
end;

function GetHTMLColorName(ColorName: string): string;
var
  AColorName: TColorName;
  i : integer;
begin
  Result := ColorName;
  for i := 0 to 140 do
  begin
    AColorName := WebColorNames[i];
    if AColorName[cnColorName] = LowerCase(ColorName) then
    begin
      Result := AColorName[cnColorValue];
      Break;
    end;
  end;
end;

function GetColorFromHTML(HTMLColor: string): TColor;
var
  sc: string;
begin
  try
    sc := GetHTMLColorName(HTMLColor);
    Delete(sc, 1, 1); { delete # char }
    sc := '$00' + sc; { alpha chanel }
    Result := StringToColor(sc);
    Result := (((Result and $ff) shl 16) + (Result and $ff00) + (Result and $ff0000) shr 16);
  except
    Result := clNone;
  end;
end;

function HTMLColorToString(Color: TColor): string;
begin
  if Integer(Color) < 0 then Color := GetSysColor(Color and $000000FF);
  Result := '#' + IntToHex(((Color and $ff) shl 16) + (Color and $ff00) + (Color and $ff0000) shr 16, 6);
end;

function PointOffset(Point1, Point2: TPoint; Distance: Integer): Boolean;
begin
  Result := (Point1.X < Point2.X - Distance) or (Point1.X > Point2.X + Distance)
    or (Point1.Y < Point2.Y - Distance) or (Point1.Y > Point2.Y + Distance);
end;

procedure ApplyBitmap(Canvas: TCanvas; X, Y: Integer; Bitmap: TBitmap);
	procedure SetColorValues24(var P: PByte; var r, g, b: Byte);
  begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
    Inc(P);
  end;

	procedure SetColorValues32(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
  end;

	procedure PutColorValues(var P: PByte; r, g, b: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    Inc(P); // skip alpha chanel
  end;

	procedure Draw32BitBitmap;
	var
		i, j: Integer;
	  c: TColor;
	  P, P2, P3: PByte;
    r, g, b, r2, g2, b2, level: Byte;
    bmp, back: TBitmap;
    function DoCombine(F, B, A :byte) :byte;
    begin
      //(foreground_color * alpha) + (background_color * (100% - alpha)).
      Result := EnsureRange((Round(F*A/255) +Round(B*(1-(A/255)))), 0, 255);  //EnsureRange is implemented in Math unit
    end;

	begin
    bmp := TBitmap.Create;
    bmp.Width := Bitmap.Width;
    bmp.Height := Bitmap.Height;
    bmp.Assign(Bitmap);

    back := TBitmap.Create;
    back.Width := Bitmap.Width;
    back.Height := Bitmap.Height;
    back.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(X, Y, X + Bitmap.Width, Y + Bitmap.Height));

		for i := 0 to Bitmap.Height - 1 do
	  begin
	  	P := Bitmap.ScanLine[i];
      P2 := bmp.ScanLine[i];
      P3 := back.ScanLine[i];
			for j := 0 to Bitmap.Width -1 do
			begin
        SetColorValues32(P, r, g, b, level);
        SetColorValues24(P3, r2, g2, b2);
	    	c := TMaskProvider.MixColors(RGB(r, g, b), RGB(r2, g2, b2), level);
        PutColorValues(P2, GetRValue(c), GetGValue(c), GetBValue(c));
			end;
	  end;
	  Canvas.Draw(X, Y, bmp);
    bmp.Free;
    back.Free;
  end;
begin
	case Bitmap.PixelFormat of
    pf32bit: Draw32BitBitmap;
  	else Canvas.Draw(X, Y, Bitmap);
  end;
end;

procedure Save32BitBitmap(ABitmap: TBitmap; FileName: string);
	procedure PutColorValues(var P: PByte; r, g, b, alpha: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    P^ := alpha;
    Inc(P);
  end;

	procedure SetColorValues32(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
   end;
var
  Bitmap: TBitmap;
  i, j: Integer;
  Pa, Pb: PByte;
  r, g, b, alpha: byte;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := ABitmap.Width;
  Bitmap.Height := ABitmap.Height;
  for i := 0 to ABitmap.Height - 1 do
  begin
    for j := 0 to ABitmap.Width - 1 do
    begin
      Pa := ABitmap.ScanLine[j];
      SetColorValues32(Pa, r, g, b, alpha);
        ShowMessage(IntToStr(alpha));
      Pb := Bitmap.ScanLine[j];
      SetColorValues32(Pb, r, g, b, alpha);
    end;
  end;
  Bitmap.SaveToFile(FileName);
  FreeAndNil(Bitmap);
end;

procedure DrawVerticalText(Canvas: TCanvas; Rect: TRect; Text: string);
var
  LogRec: TLOGFONT;
  OldFont, NewFont: HFONT;
  Flags: Integer;
begin
  Flags := DT_NOPREFIX or DT_BOTTOM or DT_EXTERNALLEADING or DT_SINGLELINE;
  with Canvas do
  begin                              
    Brush.Style := bsClear;          
    GetObject(Font.Handle, SizeOf(LogRec), @LogRec);
    LogRec.lfEscapement := 900;
    LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;
    NewFont := CreateFontIndirect(LogRec);
    OldFont := SelectObject(Canvas.Handle, NewFont);
    DrawText(Canvas.Handle, PAnsiChar(Text), Length(Text), Rect, Flags);
    NewFont := SelectObject(Canvas.Handle,OldFont);
    DeleteObject(NewFont);
  end;
end;

procedure DrawPolyline(Canvas: TCanvas; Points: array of TPoint; Rect: TRect; Flip: Boolean);
begin
  if Flip then FlipPointsVert(Points, Rect);
  Canvas.Polyline(Points);
end;

procedure DrawTextRect(Canvas: TCanvas; ARect: TRect;
	Alignment: TAlignment; Text: WideString; BiDiMode: TBiDiMode = bdLeftToRight);
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_NOPREFIX or	DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_SINGLELINE;
  case Alignment of
    taLeftJustify: Flags := Flags or DT_LEFT;
    taRightJustify: Flags := Flags or DT_RIGHT;
    taCenter: Flags := Flags or DT_CENTER;
  end;
  if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
  with Canvas.Brush do
  begin
    Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), ARect, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), ARect, Flags);
              end;
    end;
    Style := bsSolid;
  end;
end;

procedure FlipPointsVert(var Points: array of TPoint; Rect: TRect);
var                   
  i, m: Integer;
begin
  m := Rect.Top + (Rect.Bottom - Rect.Top) div 2;
  for i := 0 to Length(Points) - 1 do
    Points[i].Y := m - (Points[i].Y - m);
end;

procedure SetClipPoly(Canvas: TCanvas; Points: array of TPoint);
var
  CLPRGN: HRGN;
begin
  CLPRGN := CreatePolygonRgn(Points, Length(Points), WINDING);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;                  

procedure SetClipRect(Canvas: TCanvas; ClipRect: TRect);
var
  CLPRGN: HRGN;
begin
  with ClipRect do CLPRGN := CreateRectRgn(Left, Top, Right, Bottom);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;

initialization
  IsUnicodeSupported := (Win32Platform = VER_PLATFORM_WIN32_NT);

end.
