unit NxSharedDraw;

interface

uses
  Windows, Classes, Graphics, Controls, Messages, SysUtils,
  NxClasses, NxThemesSupport, NxSharedCommon;

const
  TextFlags = DT_VCENTER or DT_END_ELLIPSIS
    or DT_EXTERNALLEADING or DT_SINGLELINE;

type
  TColorElement = (
    ceMenuHighlight,
    ceTaskPaneHeadFromColor, ceTaskPaneHeadToColor,
    ceToolBtnBorder, ceToolBtnFromColor, ceToolBtnToColor,
    ceToolBtnHFromColor, ceToolBtnHToColor,
    ceToolBtnDFromColor, ceToolBtnDToColor,
    ceToolbarFromColor, ceToolbarToColor, ceWhidbeyTabBorder);

  TGrayscaleProc = procedure (var P: PByte);

  { Routines }

  function BlendColor(UpColor, DownColor: TColor; Amount: Integer): TColor; overload;
  function BlendColor(UpColor, DownColor: TColor; Ratio: Double): TColor; overload;
  function GetColor(Element: TColorElement): TColor;
  function Lighten(C: TColor; Amount: Integer): TColor;
  function MixBytes(FG, BG, TRANS: byte): byte;
//  function MixColors(FG, BG: TColor; T: byte): TColor;
  procedure ApplyBitmap(Canvas: TCanvas; X, Y: Integer; Bitmap: TBitmap);
  procedure DrawBitmap(Canvas: TCanvas; X, Y: Integer; Bitmap: TBitmap; BackgroundColor: TColor);
  procedure DrawBitmapRes(Canvas: TCanvas; X, Y: Integer; ResName: string; Transparent: Boolean = False);
  procedure DrawDisabledText(Canvas: TCanvas; R: TRect; Text: string; Alignment: TAlignment;
    NoPreffix: Boolean = False);
  procedure DrawHorzGradient(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
  procedure DrawHorzReflectGrad(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor); 
  procedure DrawVertGradient(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
  procedure DrawText(Canvas: TCanvas; Rect: TRect; Alignment: TAlignment; Text: WideString;
    NoPrefix: Boolean = False);
  procedure DrawTextRect(Canvas: TCanvas; ARect: TRect; Text: WideString;
    BidiMode: TBiDiMode = bdLeftToRight);
  procedure DrawPrefixText(Canvas: TCanvas; ARect: TRect; Text: WideString);
  procedure DrawVertGlass(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor; GlowHeight: Integer);
  procedure DrawVertFade(Canvas: TCanvas; ARect: TRect);
  procedure DrawVertShine(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor; GlowHeight: Integer);
  procedure DrawTransparent(Control: TCustomControl; Canvas: TCanvas);

  { Grayscale Routines }

  procedure GrayscaleBitmap(Bitmap: TBitmap);
  procedure GrayscaleSimpleBitmap(Bitmap: TBitmap);
  procedure GrayscaleValues24(var P: PByte);
  procedure GrayscaleValues32(var P: PByte);

  { Scanline Routines }

  procedure PutColorValues24(var P: PByte; r, g, b: Byte);
  procedure PutColorValues32(var P: PByte; r, g, b: Byte);
	procedure SetColorValues24(var P: PByte; var r, g, b: Byte); overload;
	procedure SetColorValues32(var P: PByte; var r, g, b, alpha: Byte); overload;
	procedure SetColorValues32(var P: PByte; var r, g, b: Byte); overload;
  procedure SetClipRect(Canvas: TCanvas; Rect: TRect);

implementation

uses Types, Dialogs;

const
  bias = $00800080;

var
  FullEdge: Boolean = True;

type
  TPointRec = record
    Pos: Integer;
    Weight: Cardinal;
  end;

TCluster = array of TPointRec;
TMappingTable = array of TCluster;

function BlendColor(UpColor, DownColor: TColor; Amount: Integer): TColor;
var
  Value: Cardinal;
begin
  Assert(Amount in [0..255]);
  Value := Amount xor 255;
  if Integer(UpColor) < 0 then UpColor := GetSysColor(UpColor and $000000FF);
  if Integer(DownColor) < 0 then DownColor := GetSysColor(DownColor and $000000FF);
  Result := Integer(
    ((Cardinal(UpColor) and $FF00FF) * Cardinal(Amount) +
    (Cardinal(DownColor) and $FF00FF) * Value) and $FF00FF00 +
    ((Cardinal(UpColor) and $00FF00) * Cardinal(Amount) +
    (Cardinal(DownColor) and $00FF00) * Value) and $00FF0000) shr 8;
end;

function BlendColor(UpColor, DownColor: TColor; Ratio: Double): TColor; overload;
var
	r, g, b, r0, g0, b0, r1, g1, b1: Integer;
begin
  if Integer(UpColor) < 0 then UpColor := GetSysColor(UpColor and $000000FF);
  if Integer(DownColor) < 0 then DownColor := GetSysColor(DownColor and $000000FF);
	r0 := GetRValue(UpColor);
	g0 := GetGValue(UpColor);
	b0 := GetBValue(UpColor);
	r1 := GetRValue(DownColor);
	g1 := GetGValue(DownColor);
	b1 := GetBValue(DownColor);
	r := round(Ratio * r1 + (1 - Ratio) * R0);
	g := round(Ratio * g1 + (1 - Ratio) * g0);
	b := round(Ratio * b1 + (1 - Ratio) * b0);
	Result := RGB(r, g, b);
end;

function MixBytes(FG, BG, TRANS: byte): byte;
asm
  push bx  // push some regs
  push cx
  push dx
  mov DH,TRANS // remembering Transparency value (or Opacity - as you like)
  mov BL,FG    // filling registers with our values
  mov AL,DH    // BL = ForeGround (FG)
  mov CL,BG    // CL = BackGround (BG)
  xor AH,AH    // Clear High-order parts of regs
  xor BH,BH
  xor CH,CH
  mul BL       // AL=AL*BL
  mov BX,AX    // BX=AX
  xor AH,AH
  mov AL,DH
  xor AL,$FF   // AX=(255-TRANS)
  mul CL       // AL=AL*CL
  add AX,BX    // AX=AX+BX
  shr AX,8     // Fine! Here we have mixed value in AL
  pop dx       // Hm... No rubbish after us, ok?
  pop cx
  pop bx       // Bye, dear Assembler - we go home to Delphi!
end;

function GetColor(Element: TColorElement): TColor;
begin
  case IsThemed of
    True: case Element of
            ceMenuHighlight: Result := RGB(255, 238, 194);
            ceTaskPaneHeadFromColor: Result := RGB(255, 213, 140);
            ceTaskPaneHeadToColor: Result := RGB(255, 166, 76);
            ceToolBtnBorder: Result := GetSysColor(COLOR_HOTLIGHT);
            ceToolBtnFromColor: Result := RGB(255, 213, 140);
            ceToolBtnToColor: Result := RGB(255, 173, 85);
            ceToolBtnHFromColor: Result := RGB(255, 244, 204);
            ceToolBtnHToColor: Result := RGB(255, 208, 145);
            ceToolBtnDFromColor: Result := RGB(254, 145, 78);
            ceToolBtnDToColor: Result := RGB(255, 211, 142);
            ceToolbarFromColor: Result := clInactiveCaptionText;
            ceToolbarToColor: Result := BlendColor(clHighlight, clInactiveCaptionText, 132);
            ceWhidbeyTabBorder: Result := RGB(127, 157, 185);
            else Result := clNone;
          end;
    False:  case Element of
              ceMenuHighlight: Result := BlendColor(clHighlight, clWindow, 80);
              ceTaskPaneHeadFromColor: Result := cl3DLight;
              ceTaskPaneHeadToColor: Result := cl3DLight;
              ceToolBtnBorder: Result := GetSysColor(COLOR_HOTLIGHT);
              ceToolBtnFromColor: Result := RGB(255, 213, 140);
              ceToolBtnToColor: Result := RGB(255, 173, 85);
              ceToolBtnHFromColor: Result := RGB(255, 244, 204);
              ceToolBtnHToColor: Result := RGB(255, 208, 145);
              ceToolBtnDFromColor: Result := RGB(254, 145, 178);
              ceToolBtnDToColor: Result := RGB(255, 211, 142);
              ceToolbarFromColor: Result := clWindow;
              ceToolbarToColor: Result := clBtnFace;
              ceWhidbeyTabBorder: Result := clGrayText;
              else Result := clNone;
            end;
    else Result := clNone;
  end;
end;

procedure ApplyBitmap(Canvas: TCanvas; X, Y: Integer; Bitmap: TBitmap);
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
        SetColorValues32(P3, r2, g2, b2);
	    	c := TMaskProvider.MixColors(RGB(r, g, b), RGB(r2, g2, b2), level);
        PutColorValues32(P2, GetRValue(c), GetGValue(c), GetBValue(c));
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

procedure DrawBitmap(Canvas: TCanvas; X, Y: Integer; Bitmap: TBitmap; BackgroundColor: TColor);
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
        SetColorValues32(P, r, g, b, level);
	    	c := TMaskProvider.MixColors(RGB(r, g, b), BackgroundColor, level);
        PutColorValues32(P2, GetRValue(c), GetGValue(c), GetBValue(c));
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

procedure DrawBitmapRes(Canvas: TCanvas; X, Y: Integer; ResName: string;
  Transparent: Boolean = False);
var
  ABitmap: TBitmap;
begin
  ABitmap := TBitmap.Create;
  try
    ABitmap.LoadFromResourceName(HInstance, ResName);
    if Transparent then
    begin
      ABitmap.Transparent := True;
      ABitmap.TransparentColor := ABitmap.Canvas.Pixels[0, ABitmap.Height - 1];
    end;
    Canvas.Draw(X, Y, ABitmap);
  finally
    ABitmap.Free;
  end;
end;

procedure DrawDisabledText(Canvas: TCanvas; R: TRect; Text: string;
  Alignment: TAlignment; NoPreffix: Boolean);
var
  Flags: Integer;
begin
  Flags := TextFlags;
  case Alignment of
    taLeftJustify: Flags := TextFlags or DT_LEFT;
    taRightJustify: Flags := TextFlags or DT_RIGHT;
    taCenter: Flags := TextFlags or DT_CENTER;
  end;
  if NoPreffix then Flags := Flags or DT_NOPREFIX;
  with Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clBtnHighlight;
    OffsetRect(R, 1, 1);
    Windows.DrawText(Canvas.Handle, PChar(Text), Length(Text), R, Flags);
    Font.Color := clBtnShadow;
    OffsetRect(R, -1, -1);
    Windows.DrawText(Canvas.Handle, PChar(Text), Length(Text), R, Flags);
    Canvas.Brush.Style := bsSolid;
  end;
end;

procedure DrawHorzGradient(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
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

procedure DrawHorzReflectGrad(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
var
	i, p, m, Distance: Integer;
begin
  Distance := ARect.Right - ARect.Left;
  m := ARect.Left + Distance div 2;
  if Distance = 0 then Exit;
  for i := ARect.Left to ARect.Right - 1 do
  begin
  	p := -Abs(i - m);
    Canvas.Pen.Color := BlendColor(FromColor, ToColor, p / Distance);
		Canvas.MoveTo(i, ARect.Top);
		Canvas.LineTo(i, ARect.Bottom);
		if p >= Distance then Exit;
  end;
end;

procedure DrawVertGradient(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
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

procedure DrawText(Canvas: TCanvas; Rect: TRect; Alignment: TAlignment; Text: WideString;
  NoPrefix: Boolean);
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_SINGLELINE;
  case Alignment of
    taLeftJustify: Flags := Flags or DT_LEFT;
    taRightJustify: Flags := Flags or DT_RIGHT;
    taCenter: Flags := Flags or DT_CENTER;
  end;
  if NoPrefix then Flags := Flags or DT_NOPREFIX;
  with Canvas.Brush do
  begin
    Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), Rect, Flags);
      False:  begin
                StringText := Text;
                Windows.DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), Rect, Flags);
              end;
    end;
    Style := bsSolid;
  end;
end;

procedure DrawTextRect(Canvas: TCanvas; ARect: TRect; Text: WideString;
  BidiMode: TBiDiMode = bdLeftToRight);
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_NOPREFIX or	DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_SINGLELINE or DT_LEFT;
  if BidiMode = bdRightToLeft then Flags := Flags or DT_RTLREADING;
  with Canvas.Brush do
  begin
    Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), ARect, Flags);
      False:  begin
                StringText := Text;
                Windows.DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), ARect, Flags);
              end;
    end;
    Style := bsSolid;
  end;
end;

procedure DrawPrefixText(Canvas: TCanvas; ARect: TRect; Text: WideString);
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_SINGLELINE or DT_LEFT;
  with Canvas.Brush do
  begin
    Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), ARect, Flags);
      False:  begin
                StringText := Text;
                Windows.DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), ARect, Flags);
              end;
    end;
    Style := bsSolid;
  end;
end;

procedure DrawVertGlass(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor;
  GlowHeight: Integer);
var
  Bitmap: TBitmap;
  i, j: Integer;
  c: TColor;
  P: PByte;
  am, am2: Integer;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := ARect.Right - ARect.Left;
  Bitmap.Height := ARect.Bottom - ARect.Top;
  Bitmap.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom));
  Bitmap.PixelFormat := pf24bit;

  for i := 0 to Bitmap.Height - 1 do
  begin
    am := Round(255 * (i / Bitmap.Height));
    C := BlendColor(ToColor, FromColor, am);

    if i < GlowHeight then
    begin
      am2 := Round(255 * (i / (GlowHeight * 2)));
      C := BlendColor(C, clWhite, am2);
    end;

  	P := Bitmap.ScanLine[i];
    for j := 0 to Bitmap.Width -1 do
    begin
      PutColorValues24(P, GetRValue(c), GetGValue(c), GetBValue(c));
	  end;
  end;
  Canvas.Draw(ARect.Left, ARect.Top, Bitmap);
  FreeAndNil(Bitmap);
end;

procedure DrawVertFade(Canvas: TCanvas; ARect: TRect);
var
  Bitmap: TBitmap;
  i, j, a, m: Integer;
  c: TColor;
  P, P2: PByte;
  r, g, b: Byte;
begin
  m := (ARect.Top + ARect.Bottom - ARect.Top) div 2;

  Bitmap := TBitmap.Create;
  Bitmap.Width := ARect.Right - ARect.Left;
  Bitmap.Height := M;
  Bitmap.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Top + M));
  Bitmap.PixelFormat := pf24bit;

  a := 150;
  for i := 0 to Bitmap.Height - 1 do
  begin
  	P := Bitmap.ScanLine[i];
    P2 := P;
    for j := 0 to Bitmap.Width -1 do
    begin
      { Get Values }
      SetColorValues24(P, r, g, b);
      C := BlendColor($00FFFFFF, RGB(r, g, b), a);
      { Set Values }
      PutColorValues24(P2, GetRValue(c), GetGValue(c), GetBValue(c));
	  end;
    Dec(a, 7);
    if a < 0 then Break;
  end;
  Canvas.Draw(ARect.Left, ARect.Top, Bitmap);
  FreeAndNil(Bitmap);
end;

procedure DrawVertShine(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor; GlowHeight: Integer);
var
  Bitmap: TBitmap;
  i, j: Integer;
  c1, c2: TColor;
  P: PByte;
  am, am2, am3: Integer;
  mw: Integer;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := ARect.Right - ARect.Left;
  Bitmap.Height := ARect.Bottom - ARect.Top;
  Bitmap.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom));
  Bitmap.PixelFormat := pf24bit;

  mw := (ARect.Right - ARect.Left) div 2;
  for i := 0 to Bitmap.Height - 1 do
  begin
    am := Round(255 * (i / Bitmap.Height));
    c1 := BlendColor(ToColor, FromColor, am);

    if i < GlowHeight then
    begin
      am2 := Round(255 * (i / (GlowHeight * 2)));
      c1 := BlendColor(c1, clWhite, am2);
    end;

  	P := Bitmap.ScanLine[i];
    for j := 0 to Bitmap.Width -1 do
    begin
      am3 := (Abs(mw - j) * 2) + 100;
      SetRange(am3, 0, 255);
      c2 := BlendColor(c1, clWhite, am3);
      PutColorValues24(P, GetRValue(c2), GetGValue(c2), GetBValue(c2));
	  end;
  end;
  Canvas.Draw(ARect.Left, ARect.Top, Bitmap);
  FreeAndNil(Bitmap);
end;

procedure DrawTransparent(Control: TCustomControl; Canvas: TCanvas);
var
  Shift, Pt: TPoint;
  DC: HDC;
begin
  if Control.Parent = nil then Exit;
  if Control.Parent.HandleAllocated then
  begin
    DC := Canvas.Handle;
    Shift.X := 0;
    Shift.Y := 0;
    Shift := Control.Parent.ScreenToClient(Control.ClientToScreen(Shift));
    SaveDC(DC);
    try
      OffsetWindowOrgEx(DC, Shift.X, Shift.Y, nil);
      GetBrushOrgEx(DC, Pt);
      SetBrushOrgEx(DC, Pt.X + Shift.X, Pt.Y + Shift.Y, nil);
      Control.Parent.Perform(WM_ERASEBKGND, Integer(DC), 0);
      Control.Parent.Perform(WM_PAINT, Integer(DC), 0);
    finally
      RestoreDC(DC, -1);
    end;
  end;
end;

procedure GrayscaleBitmap(Bitmap: TBitmap);
var
  i, j: Integer;
  P: PByte;
  Proc: TGrayscaleProc;
begin
  Proc := nil;
  case Bitmap.PixelFormat of
    pf32bit: Proc := GrayscaleValues32;
    pf24bit: Proc := GrayscaleValues24;
    pf4bit: GrayscaleSimpleBitmap(Bitmap);
  end;
  if Assigned(Proc) then
    for i := 0 to Bitmap.Height - 1 do
    begin
      P := Bitmap.ScanLine[i];
      for j := 0 to Bitmap.Width - 1 do Proc(P);
    end;
end;

procedure GrayscaleSimpleBitmap(Bitmap: TBitmap);
const
  ROP_DSPDxax = $00E20746;
var
  MonoBmp: TBitmap;
  w, h: Integer;
  r: TRect;
begin
  Bitmap.TransparentColor := Bitmap.Canvas.Pixels[0, Bitmap.Height - 1];
  Bitmap.Transparent := True;
  w := Bitmap.Width;
  h := Bitmap.Height;
  MonoBmp := TBitmap.Create;
  try
    with MonoBmp do
    begin
      Assign(Bitmap);
      HandleType := bmDDB;
      Canvas.Brush.Color := clBlack;
      Width := Bitmap.Width;
      if Monochrome then
      begin
        Canvas.Font.Color := clWhite;
        Monochrome := False;
        Canvas.Brush.Color := clWhite;
      end;
      Monochrome := True;
    end;
    with Bitmap.Canvas do
    begin
      Brush.Color := clBtnFace;
      FillRect(r);
      Brush.Color := clBtnHighlight;
      SetTextColor(Handle, clBlack);
      SetBkColor(Handle, clWhite);
      BitBlt(Handle, 1, 1, w, h, MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
      Brush.Color := clBtnShadow;
      SetTextColor(Handle, clBlack);
      SetBkColor(Handle, clWhite);
      BitBlt(Handle, 0, 0, w, h, MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
    end;
  finally
    MonoBmp.Free;
  end;
end;

procedure GrayscaleValues24(var P: PByte);
var
  r, g, b, c: Byte;
  Pr, Pb, Pg: PByte;
begin
  b := PByte(P)^;
  Pb := P;
  Inc(P);
  g := PByte(P)^;
  Pg := P;
  Inc(P);
  r := PByte(P)^;
  Pr := P;
  Inc(P);
  c := (b + g + r) div 3;
  Pb^ := c;
  Pg^ := c;
  Pr^ := c;
end;

procedure GrayscaleValues32(var P: PByte);
var
  r, g, b, c: Byte;
  Pr, Pb, Pg: PByte;
begin
  b := PByte(P)^;
  Pb := P;
  Inc(P);
  g := PByte(P)^;
  Pg := P;
  Inc(P);
  r := PByte(P)^;
  Pr := P;
  Inc(P);
  Inc(P); // skip alpha channel
  c := (b + g + r) div 3;
  Pb^ := c;
  Pg^ := c;
  Pr^ := c;
end;

function Lighten(C: TColor; Amount: Integer): TColor;
var
  R, G, B: Integer;
begin
  if C < 0 then C := GetSysColor(C and $000000FF);
  R := C and $FF + Amount;
  G := C shr 8 and $FF + Amount;
  B := C shr 16 and $FF + Amount;
  if R < 0 then R := 0 else if R > 255 then R := 255;
  if G < 0 then G := 0 else if G > 255 then G := 255;
  if B < 0 then B := 0 else if B > 255 then B := 255;
  Result := R or (G shl 8) or (B shl 16);
end;

procedure PutColorValues24(var P: PByte; r, g, b: Byte);
begin
  P^ := b;
  Inc(P);
  P^ := g;
  Inc(P);
  P^ := r;
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
  Inc(P); // skip alpha channel
end;

procedure SetColorValues24(var P: PByte; var r, g, b: Byte);
begin
  b := PByte(P)^;
  Inc(P);
  g := PByte(P)^;
  Inc(P);
  r := PByte(P)^;
  Inc(P);
end;

procedure SetColorValues32(var P: PByte; var r, g, b, alpha: Byte); overload;
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

procedure SetColorValues32(var P: PByte; var r, g, b: Byte); overload;
begin
  b := PByte(P)^;
  Inc(P);
  g := PByte(P)^;
  Inc(P);
  r := PByte(P)^;
  Inc(P);
  Inc(P);
end;

procedure SetClipRect(Canvas: TCanvas; Rect: TRect);
var
  CLPRGN: HRGN;
begin
  with Rect do CLPRGN := CreateRectRgn(Left, Top, Right, Bottom);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;

end.
