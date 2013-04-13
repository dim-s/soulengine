unit NxThemesSupport;

{$HPPEMIT ''}
{$HPPEMIT '#include "uxtheme.h"'}
{$HPPEMIT ''}

interface

uses
  Windows, SysUtils, Graphics, Classes, Controls, NxConsts;

const
  teButton = 'button';
  teComboBox = 'combobox';
  teHeader = 'header';
  teEdit = 'edit';
  teExplorerBar = 'explorerbar';
  teListView = 'listview';
  teTab = 'tab';
  teToolbar = 'toolbar';
  teTrackBar = 'trackbar';
  teTreeView = 'treeview';
  teRebar = 'rebar';
  teScrollBar = 'scrollbar';
  teSpin = 'spin';

  { teTreeView }
  tcExpandingButton = 2;

  { teToolbar }
  tcToolbarButton = 1;

  tcToolbarButtonHover = 2;
  tcToolbarButtonDown = 3;

  { teButton }
  tcCheckBox = 3;
  tcRadioButton = 2;

  { teButton & tcRadioButton }
  tiRadioCheckedDisabled = 8;
  tiRadioCheckedDown = 7;
  tiRadioCheckedHover = 6;
  tiRadioChecked = 5;
  tiRadioDisabled = 4;

  tiCollapsed = 1;
  tiExpanded = 2;

  { teHeader }
  tcHeader = 1;
  tiHeaderNormal = 1;
  tiHeaderHover = 2;
  tiHeaderPasive = 7;

  { teScrollBar }
  tcHorzGrip = 9;

  { teSpin }
  tcSpinUp = 1;
  tcSpinDown = 2;

  { teTab }
  tcTab = 1;
  tcTabPage = 9;

  { tcTab }
  tiTab = 1;
  tiTabActive = 3;

type
  HIMAGELIST = THandle;
  HTHEME = THandle;
  {$EXTERNALSYM HTHEME}

var
  { External DLL's }
  OpenThemeData: function(hwnd: HWND; pszClassList: LPCWSTR): HTHEME; stdcall;
  {$EXTERNALSYM OpenThemeData}
  CloseThemeData: function(hTheme: HTHEME): HRESULT; stdcall;
  {$EXTERNALSYM CloseThemeData}
  DrawThemeBackground: function(hTheme: HTHEME; hdc: HDC; iPartId, iStateId: Integer;
    const Rect: TRect; pClipRect: PRect): HRESULT; stdcall;
  {$EXTERNALSYM DrawThemeBackground}
  DrawThemeEdge: function(hTheme: HTHEME; hdc: HDC; iPartId, iStateId: Integer;
	  const pDestRect: TRect; uEdge, uFlags: UINT; pContentRect: PRECT): HRESULT; stdcall;
  {$EXTERNALSYM DrawThemeEdge}
  GetThemeSysSize: function(hTheme: HTHEME; iSizeId: Integer): Integer; stdcall;
  {$EXTERNALSYM GetThemeSysSize}
  IsThemeActive: function: BOOL; stdcall;
  {$EXTERNALSYM IsThemeActive}
  IsAppThemed: function: BOOL; stdcall;
  {$EXTERNALSYM IsAppThemed}

  function IsThemed: Boolean;
  procedure InitThemes;
  procedure ReleaseThemes;
  { Custom procedures }
  procedure ThemeRect(Handle: HWND; DC: HDC; ARect: TRect; Element: PWideChar;
    Category, Item: Integer);

type
  TColorScheme = (csDefault, csBlack, csBlue, csSilver);
  TColorSchemes = csBlack..csSilver;

  TColorSchemeElement = (
    seBackgroundGradientStart,
    seBackgroundGradientEnd,
    seBorder,
    seBtnFace,
    seBtnFaceDark,
    seDown,
    seGroupHeader,
    seHeaderFont,
    seHeaderGradientEnd,
    seHeaderGradientStart,
    seHeaderShadow,
    seHighlight,
    seHover,
    seHighlightHoverFore,
    seHighlightDownFore,
    seInactiveDockCaption,
    seMenuHighlight,
    seMenuSelectionBorder,
    seMenuSelectionBorderDown,
    seSplitterGradientStart,
    seSplitterGradientEnd);

  TSchemeColors = array[TColorScheme, TColorSchemeElement] of TColor;

  TNxColorScheme = class(TComponent)
  private
    FColorScheme: TColorSchemes;
    FOnChange: TNotifyEvent;
    procedure SetColorScheme(const Value: TColorSchemes);
  protected
    procedure DoChange; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ColorScheme: TColorSchemes read FColorScheme write SetColorScheme default csBlue;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

var
  ShemeColors: TSchemeColors;
  ColorScheme: TColorSchemes = csBlue;
  ControlsList: TList;

  { Remove AControl from ControlsList } 
  procedure RemoveSchemeNotification(AControl: TControl);

  { Return scheme color based on element } 
  function SchemeColor(Element: TColorSchemeElement; Scheme: TColorScheme = csDefault): TColor; overload;

  { Add AControl into ControlsList (TList) }
  procedure SchemeNotification(AControl: TControl);

implementation

uses
  Forms, Math;

const
  dllUxTheme = 'uxtheme.dll';

var
	FDllHandle: THandle;

{ Windows XP/Vista Themes }

procedure InitThemes;
begin
  if FDllHandle = 0 then
  begin
    FDllHandle := LoadLibrary(dllUxTheme);
    if FDllHandle > 0 then
    begin
      CloseThemeData := GetProcAddress(FDllHandle, 'CloseThemeData');
      DrawThemeBackground := GetProcAddress(FDllHandle, 'DrawThemeBackground');
      DrawThemeEdge := GetProcAddress(FDllHandle, 'DrawThemeEdge');
      GetThemeSysSize := GetProcAddress(FDllHandle, 'GetThemeSysSize');
      IsThemeActive := GetProcAddress(FDllHandle, 'IsThemeActive');
      IsAppThemed := GetProcAddress(FDllHandle, 'IsAppThemed');
      OpenThemeData := GetProcAddress(FDllHandle, 'OpenThemeData');
    end;
  end;
end;

function IsThemed: Boolean;
begin
	try
	  Result := (FDllHandle > 0) and IsAppThemed and IsThemeActive;
    { note: uncomment for debug }
//    Result := False;
  except
    raise Exception.Create('Error in Themes');
  end;
end;

procedure ReleaseThemes;
begin
  if FDllHandle <> 0 then
  begin
    FreeLibrary(FDllHandle);
    FDllHandle := 0;
    CloseThemeData := nil;
    DrawThemeBackground := nil;
    DrawThemeEdge := nil;
    GetThemeSysSize := nil;
    IsThemeActive := nil;
    IsAppThemed := nil;
    OpenThemeData := nil;
  end;
end;

procedure ThemeRect(Handle: HWND; DC: HDC; ARect: TRect; Element: PWideChar;
  Category, Item: Integer);
var
  Theme: THandle;
begin
  Theme := OpenThemeData(Handle, Element);
  DrawThemeBackground(Theme, DC, Category, Item, ARect, nil);
  CloseThemeData(Theme);
end;

{ ColorScheme }

procedure RemoveSchemeNotification(AControl: TControl);
var
  Index: Integer;
begin
  if Assigned(ControlsList) then
  begin
    Index := ControlsList.IndexOf(AControl);
    if InRange(Index, 0, Pred(ControlsList.Count))
      then ControlsList.Delete(Index);
  end;
end;

function SchemeColor(Element: TColorSchemeElement; Scheme: TColorScheme = csDefault): TColor;
begin
  if Scheme = csDefault then Scheme := ColorScheme;
  Result := ShemeColors[Scheme, Element];
end;

procedure SchemeNotification(AControl: TControl);
begin
  if Assigned(ControlsList) then ControlsList.Add(AControl);
end;

{ TNxColorCheme }

constructor TNxColorScheme.Create(AOwner: TComponent);
begin
  inherited;
  FColorScheme := NxThemesSupport.ColorScheme;
end;

procedure TNxColorScheme.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxColorScheme.SetColorScheme(const Value: TColorSchemes);
var
  i: Integer;
  R: TRect;
  AControl: TControl;
begin
  FColorScheme := Value;
  if FColorScheme <> NxThemesSupport.ColorScheme then
  begin
    NxThemesSupport.ColorScheme := FColorScheme;
    DoChange;
  end;
  for i := 0 to Pred(ControlsList.Count) do
  begin
    AControl := ControlsList[i];
    if AControl is TWinControl then
    begin
      R := AControl.ClientRect;
      RedrawWindow(TWinControl(AControl).Handle, @R, 0, RDW_FRAME or RDW_INVALIDATE or RDW_NOCHILDREN);
    end else AControl.Invalidate;
  end;
end;

initialization
  { Blue }
  ShemeColors[csBlue, seBackgroundGradientEnd] := $00CE9266;
  ShemeColors[csBlue, seBorder] := $00CF9365;
  ShemeColors[csBlue, seBtnFace] := $00FFEFE3;
  ShemeColors[csBlue, seBtnFaceDark] := $00F0D9C2; // info panel

  ShemeColors[csBlue, seGroupHeader] := $00EEE7DD;

  ShemeColors[csBlue, seHeaderFont] := $008B4215;
  ShemeColors[csBlue, seHeaderGradientEnd] := $00FFD2AF;
  ShemeColors[csBlue, seHeaderGradientStart] := $00FFEFE3;
  ShemeColors[csBlue, seHeaderShadow] := ShemeColors[csBlue, seBorder];

  ShemeColors[csBlue, seInactiveDockCaption] := $00E9CFB8;

  ShemeColors[csBlue, seMenuHighlight] := $00A2E7FF;
  ShemeColors[csBlue, seMenuSelectionBorder] := $0069BDFF; //info panel hover
  ShemeColors[csBlue, seMenuSelectionBorderDown] := $003C8CFB; //info panel down

  ShemeColors[csBlue, seSplitterGradientStart] := $00FFEFE3;
  ShemeColors[csBlue, seSplitterGradientEnd] := $00FFD6B6;

  { Silver }
  ShemeColors[csSilver, seBackgroundGradientEnd] := $00A69F9B;
  ShemeColors[csSilver, seBorder] := $0074706F;
  ShemeColors[csSilver, seBtnFace] := $00F2F1F0;
  ShemeColors[csSilver, seBtnFaceDark] := $00E1D6D2; // info panel

  ShemeColors[csSilver, seGroupHeader] := $00EBEBEB;

  ShemeColors[csSilver, seHeaderFont] := $008B4215;
  ShemeColors[csSilver, seHeaderGradientEnd] := $00E7DFDA;
  ShemeColors[csSilver, seHeaderGradientStart] := $00F8F7F6;
  ShemeColors[csSilver, seHeaderShadow] := ShemeColors[csSilver, seBorder];

  ShemeColors[csSilver, seInactiveDockCaption] := $00C2B7B2;

  ShemeColors[csSilver, seMenuHighlight] := $00C2EEFF;
  ShemeColors[csSilver, seMenuSelectionBorder] := $006FC0FF; //info panel hover
  ShemeColors[csSilver, seMenuSelectionBorderDown] := $003E80FE; //info panel down

  ShemeColors[csSilver, seSplitterGradientStart] := $00BFA7A8;
  ShemeColors[csSilver, seSplitterGradientEnd] := $00977778;

  { Black }
  ShemeColors[csBlack, seBackgroundGradientEnd] := $000A0A0A;
  ShemeColors[csBlack, seBorder] := $005C534C;
  ShemeColors[csBlack, seBtnFace] := $00F2F1F0;
  ShemeColors[csBlack, seBtnFaceDark] := $00E1D6D2; // info panel

  ShemeColors[csBlack, seDown] := $003C8CFB;

  ShemeColors[csBlack, seGroupHeader] := $00EBEBEB; // menu groups header

  ShemeColors[csBlack, seHeaderFont] := $00000000;
  ShemeColors[csBlack, seHeaderGradientEnd] := $00C9C2BD;
  ShemeColors[csBlack, seHeaderGradientStart] := $00F2F1F0;
  ShemeColors[csBlack, seHeaderShadow] := $00B6ADA7;

  ShemeColors[csBlack, seInactiveDockCaption] := $00A0A09E;

  ShemeColors[csBlack, seMenuHighlight] := $00A2E7FF;
  ShemeColors[csBlack, seMenuSelectionBorder] := $0069BDFF; //info panel hover
  ShemeColors[csBlack, seMenuSelectionBorderDown] := $003C8CFB; //info panel down

  ShemeColors[csBlack, seSplitterGradientStart] := $00F2F1F0;
  ShemeColors[csBlack, seSplitterGradientEnd] := $00CEC8C4;

  InitThemes;

  ControlsList := TList.Create;

finalization
  FreeAndNil(ControlsList);

end.



