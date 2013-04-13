unit Utils;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, ImgList, CommCtrl;

function Min(A, B: longint): longint;
function Max(A, B: longint): longint;

function BtnHighlight: TColor;
function GetLightColor(Color: TColor; Light: byte): TColor;
function GetShadeColor(Color: TColor; Shade: byte): TColor;
procedure GetBmpFromImgList(ABmp: TBitmap; AImgList: TCustomImageList;
  ImageIndex: integer);
procedure DrawMonoBmp(ACanvas: TCanvas; MonoBmp: TBitmap;
  AMonoColor: TColor; ALeft, ATop: integer);
procedure DoDrawMonoBmp(ACanvas: TCanvas; AMonoColor: TColor;
  ALeft, ATop: integer);
function AddSlashes(const S: string): string;


var
  FMonoBitmap: TBitmap;

implementation

type

  TRGB = packed record
    R, G, B: byte;
  end;

function AddSlashes(const S: string): string;
begin
  Result := StringReplace(S, chr(8), '8', [rfReplaceAll]);
  Result := StringReplace(S, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, '''', '\''', [rfReplaceAll]);
  Result := StringReplace(Result, '<?', '''."<".chr(' + IntToStr(Ord('?')) +
    ').''', [rfReplaceAll]);
end;

function Min(A, B: longint): longint;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(A, B: longint): longint;
begin
  if A < B then
    Result := B
  else
    Result := A;
end;

function GetRGB(Color: TColor): TRGB;
var
  iColor: TColor;
begin
  iColor := ColorToRGB(Color);
  Result.R := GetRValue(iColor);
  Result.G := GetGValue(iColor);
  Result.B := GetBValue(iColor);
end;

function BtnHighlight: TColor;
begin
  Result := GetLightColor(clBtnFace, 50);
end;

function GetLightColor(Color: TColor; Light: byte): TColor;
var
  fFrom: TRGB;
begin
  FFrom := GetRGB(Color);

  Result := RGB(Round(FFrom.R + (255 - FFrom.R) * (Light / 100)),
    Round(FFrom.G + (255 - FFrom.G) * (Light / 100)),
    Round(FFrom.B + (255 - FFrom.B) * (Light / 100)));
end;

function GetShadeColor(Color: TColor; Shade: byte): TColor;
var
  fFrom: TRGB;
begin
  FFrom := GetRGB(Color);

  Result := RGB(Max(0, FFrom.R - Shade), Max(0, FFrom.G - Shade),
    Max(0, FFrom.B - Shade));
end;

procedure GetBmpFromImgList(ABmp: TBitmap; AImgList: TCustomImageList;
  ImageIndex: integer);
begin
  with ABmp do
  begin
    Width := AImgList.Width;
    Height := AImgList.Height;
    Canvas.Brush.Color := clWhite;
    Canvas.FillRect(Rect(0, 0, Width, Height));
    ImageList_DrawEx(AImgList.Handle, ImageIndex,
      Canvas.Handle, 0, 0, 0, 0, CLR_DEFAULT, 0, ILD_NORMAL);
  end;
end;

procedure DrawMonoBmp(ACanvas: TCanvas; MonoBmp: TBitmap;
  AMonoColor: TColor; ALeft, ATop: integer);
const
  ROP_DSPDxax = $00E20746;
  {<-- скопировано из ImgList.TCustomImageList.DoDraw()}
var
  crBack, crText: TColorRef;
begin
  with ACanvas do
  begin
    Brush.Color := AMonoColor;
    crText := Windows.SetTextColor(Handle, clWhite);
    crBack := Windows.SetBkColor(Handle, clBlack);
    BitBlt(Handle, ALeft, ATop, MonoBmp.Width, MonoBmp.Height,
      MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
    Windows.SetTextColor(Handle, crText);
    Windows.SetBkColor(Handle, crBack);
  end;
end;

procedure DoDrawMonoBmp(ACanvas: TCanvas; AMonoColor: TColor;
  ALeft, ATop: integer);
begin
  DrawMonoBmp(ACanvas, FMonoBitmap, AMonoColor, ALeft, ATop);
end;

initialization
  FMonoBitmap := TBitmap.Create;
  FMonoBitmap.Monochrome := True;

finalization
  FMonoBitmap.Free;

end.
