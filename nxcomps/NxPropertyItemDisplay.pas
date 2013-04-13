{$I 'NxSuite.inc'}

unit NxPropertyItemDisplay;

interface

uses
  Types, Classes, Graphics, Controls, Math, Dialogs, SysUtils, ExtCtrls,
  NxClasses, NxThemesSupport, NxSharedCommon, NxInspectorCommon, NxPropertyItems;

type
  TColorMember = (cmBorderDown, cmButtonNormal, cmButtonChecked, cmButtonDown, cmButtonHover);
	TButtonState = (bsDown, bsNormal);

  TNxTextItemDisplay = class(TNxItemDisplay)
  protected
    function GetTextRect: TRect; virtual;
    procedure PaintValueData; virtual;
  public
    procedure PaintValue; override;
  end;

  TNxMemoItemDisplay = class(TNxTextItemDisplay)
  protected
    procedure PaintValueData; override;
  end;

  TNxColorItemDisplay = class(TNxTextItemDisplay)
  protected
    procedure PaintPreview(PreviewRect: TRect); override;
  end;

  TNxFontNameItemDisplay = class(TNxTextItemDisplay)
  protected
    procedure PaintPreview(PreviewRect: TRect); override;
  end;

  TNxToolbarItemDisplay = class(TNxItemDisplay)
  private
    FDownIndex: Integer;
    FHoverIndex: Integer;
    FSelectedIndex: Integer;
  protected
    function GetButtonAtPos(X, Y: Integer): Integer;
    function GetButtonRect(ButtonIndex: Integer): TRect;
    procedure DrawButton(const ARect: TRect; Checked, Hover, Down: Boolean;
      ButtonIndex: Integer); virtual;
    procedure DrawToolbar; virtual;
    procedure PaintBackground; override;
    procedure ShowHint(ButtonIndex: Integer);
  public
    constructor Create(AItem: TNxPropertyItem); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintValue; override;
  end;

  TNxCheckBoxItemDisplay = class(TNxToolbarItemDisplay)
  protected
    procedure DrawButton(const ARect: TRect; Checked, Hover, Down: Boolean;
      ButtonIndex: Integer); override;
  public
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  end;

  TNxTrackBarItemDisplay = class(TNxItemDisplay)
  private
    FDown: Boolean;
    FHover: Boolean;
    function GetTextWidth: Integer;
    function GetTrackWidth: Integer;
  protected
    function GetPositionAtPos(X, Y: Integer): Integer;
    procedure DrawClassicTrackBar(ARect: TRect);
    procedure DrawTrackBar(ARect: TRect; Position, Max, Min, Margin: Integer);
  public
    constructor Create(AItem: TNxPropertyItem); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintValue; override;
  end;

  TNxProgressItemDisplay = class(TNxItemDisplay)
  protected
    procedure DrawBoxes(R: TRect; Color: TColor);
    procedure DrawProgressBar;
  public
    procedure PaintValue; override;
  end;

  TNxRadioItemDisplay = class(TNxItemDisplay)
  private
    FDown: Boolean;
    FHover: Boolean;
  public
    constructor Create(AItem: TNxPropertyItem); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintValue; override;
  end;

  TNxComboBoxDisplay = class(TNxItemDisplay)
  protected
    procedure PaintPreview(PreviewRect: TRect); override;
  end;

implementation

uses
  Windows, NxInspector, NxPropertyItemClasses, NxSharedDraw,
  DateUtils;

procedure DrawNewStyleButton(Canvas: TCanvas; ButtonRect: TRect; Down: Boolean = False);
begin
  with Canvas, ButtonRect do
  begin
    if Down then
    begin
      Brush.Style := bsClear;
      Pen.Color := $0055829E;
      RoundRect(Left, Top, Right, Bottom, 2, 2);
      InflateRect(ButtonRect, -1, -1);
      DrawVertGlass(Canvas, ButtonRect, $00398AFB, $0060BBFE, (Bottom - Top) div 2);
      Brush.Style := bsSolid;
    end else
    begin
      Brush.Style := bsClear;
      Pen.Color := $0099CEDB;
      RoundRect(Left, Top, Right, Bottom, 2, 2);
      InflateRect(ButtonRect, -1, -1);
      Pen.Color := $00C8F2FF;
      Brush.Color := Pen.Color;
      RoundRect(Left, Top, Right, Bottom, 2, 2);
      InflateRect(ButtonRect, -1, -1);
      DrawVertGlass(Canvas, ButtonRect, $0033CCFF, $0084E6FF, (Bottom - Top) div 2);
      Brush.Style := bsSolid;
    end;
  end;
end;

{ TNxTextItemDisplay }

function TNxTextItemDisplay.GetTextRect: TRect;
begin
  Result := ClientRect;
  with Item as TNxCustomTextItem do
  begin
    if ShowPreview
      then Result.Left := Result.Left + spaPreviewStart + sizPreview + spaPreviewToText
      else Result.Left := Result.Left + spaTextStart;
  end;
end;

procedure TNxTextItemDisplay.PaintValue;
begin
  inherited;
  PaintValueData;
end;

procedure TNxTextItemDisplay.PaintValueData;
var
  Text: WideString;
begin
  with Canvas do
  begin
    Font.Assign(Item.ValueFont);
    with Item as TNxCustomTextItem do
    begin
      { If item is empty }
      if (Value = '') or Empty then
      begin
        { Draw EmptyValue in gray }
        Canvas.Font.Color := clGrayText;
        DrawText(EmptyValue, GetTextRect);
      end else
      begin
        { Draw in bold non-default values }
        if itoBoldNonDefault in Options then
          if LowerCase(Value) <> LowerCase(DefaultValue) then Canvas.Font.Style := Canvas.Font.Style + [fsBold];

        { Draw in gray if item is not enabled }
        if not Self.Item.Enabled then Canvas.Font.Color := clGrayText;

        { Draw password char }
        if PasswordChar = #0 then Text := DisplayText else Text := StringOfChar(PasswordChar, Length(DisplayText));

        DrawText(Text, GetTextRect);
      end;
    end;
  end;
end;

{ TNxColorItemDisplay }

procedure TNxColorItemDisplay.PaintPreview(PreviewRect: TRect);
begin
  with Canvas do
  begin
    if Item.AsString <> '' then
    begin
      case TNxColorItem(Item).ColorKind of
        ckDelphi: Brush.Color := StringToColor(Item.Value);
        ckWeb: Brush.Color := GetColorFromHTML(Item.Value);
      end;
      FillRect(PreviewRect);
    end else
    begin
      Brush.Color := clWhite;
      FillRect(PreviewRect);
      Pen.Color := clRed;
      MoveTo(PreviewRect.Left, PreviewRect.Top);
      LineTo(PreviewRect.Right, PreviewRect.Bottom);
      MoveTo(PreviewRect.Left, PreviewRect.Bottom - 1);
      LineTo(PreviewRect.Right, PreviewRect.Top - 1);
    end;
  end;
end;

{ TNxFontNameItemDisplay }

procedure TNxFontNameItemDisplay.PaintPreview(PreviewRect: TRect);
begin
  Canvas.Font.Assign(Item.ValueFont);
  TDisplayProvider.DrawFontPreview(Canvas, PreviewRect, Item.Value);
end;

{ TNxToolbarItemDisplay }

constructor TNxToolbarItemDisplay.Create(AItem: TNxPropertyItem);
begin
  inherited;
  FDownIndex := -1;
  FHoverIndex := -1;
  FSelectedIndex := 0;
end;

function TNxToolbarItemDisplay.GetButtonAtPos(X, Y: Integer): Integer;
var
  Plus: Integer;
begin
  Result := -1;
  with Item as TNxToolbarItem do case Alignment of
    baLeftJustify: Result := X div ButtonWidth;
    else
      begin
        Plus := (ClientRect.Right - ClientRect.Left) - (Count * ButtonWidth);
        if X < Plus then Exit;
        Result := (X - Plus) div ButtonWidth;
      end;
  end;
end;

function TNxToolbarItemDisplay.GetButtonRect(ButtonIndex: Integer): TRect;
var
  ButtonLeft: Integer;
begin
  ButtonLeft := 0;
  with Item as TNxToolbarItem do
  begin
    case Alignment of
      baLeftJustify: ButtonLeft := ClientRect.Left + ButtonIndex * ButtonWidth;
      baRightJustify: ButtonLeft := (ClientRect.Right - ButtonWidth) - ((Count - 1 - ButtonIndex) * ButtonWidth);
    end;
    Result := Rect(ButtonLeft, ClientRect.Top, ButtonLeft + ButtonWidth, ClientRect.Bottom);
  end;
end;

procedure TNxToolbarItemDisplay.DrawButton(const ARect: TRect; Checked, Hover, Down: Boolean;
  ButtonIndex: Integer);
var
  X, Y: Integer;
	procedure DrawClassicButton;
  var
    FrRect: TRect;
	begin
    FrRect := ARect;
    if Hover then
    begin
      if Checked or Down then
      begin
        Canvas.Brush.Color := clBtnFace;
        Canvas.FillRect(ARect);
        Frame3D(Canvas, FrRect, clBtnShadow, clBtnHighlight, 1);
      end else
      begin
        Canvas.Brush.Color := clBtnFace;
        Canvas.FillRect(ARect);
        Frame3D(Canvas, FrRect, clBtnHighlight, clBtnShadow, 1);
      end;
    end else
    begin
      if Checked or Down then
      begin
        Canvas.Brush.Color := cl3DLight;
        Canvas.FillRect(ARect);
        Frame3D(Canvas, FrRect, clBtnShadow, clBtnHighlight, 1);
      end;
    end;
	end;

  procedure DrawThemedButton;
  var
    Index: Integer;
  begin
    Index := 0;
    if Hover then Index := 2;
    if Checked then if Hover then Index := 6 else Index := 5;
    if Down then Index := 3;
    ThemeRect(Item.GetParentControl.Handle, Canvas.Handle, ARect, teToolbar, tcToolbarButton, Index);
  end;

  procedure DrawOffice2003Button;
  begin
    if Hover then
    begin
      if Down or Checked then
      begin
        TGraphicsProvider.DrawGradient(Canvas, ARect, GetColor(ceToolBtnDFromColor), GetColor(ceToolBtnDToColor));
      end else
      begin
        TGraphicsProvider.DrawGradient(Canvas, ARect, GetColor(ceToolBtnHFromColor), GetColor(ceToolBtnHToColor));
      end;
      Canvas.Brush.Color := GetColor(ceToolBtnBorder);
      Canvas.FrameRect(ARect);
    end else
    begin
      if Checked then
      begin
        TGraphicsProvider.DrawGradient(Canvas, ARect, GetColor(ceToolBtnFromColor), GetColor(ceToolBtnToColor));
      end;
      Canvas.Brush.Color := GetColor(ceToolBtnBorder);
      Canvas.FrameRect(ARect);
    end;
  end;

  procedure DrawOffice2007Button;
  begin
    if Hover then
    begin
      if Down or Checked then
      begin
        DrawNewStyleButton(Canvas, ARect, True);
      end else
      begin
        DrawNewStyleButton(Canvas, ARect);
      end;
    end else
    begin
      if Checked then
        DrawNewStyleButton(Canvas, ARect, True);
    end;
  end;
  
  procedure DrawWhidbeyButton;
  begin
    Canvas.Pen.Color := clHighlight;
    if Hover then
    begin
      if Down or Checked then
      begin
        Canvas.Brush.Color := BlendColor(clHighlight, clWindow, 160);
      end else
      begin
        Canvas.Brush.Color := BlendColor(clHighlight, clWindow, 80);
      end;
      Canvas.Rectangle(ARect);
    end else
    begin
      if Checked then Canvas.Brush.Color := BlendColor(clHighlight, clWindow, 35);
      Canvas.Rectangle(ARect);
    end;
  end;

begin
  if Checked or Hover then
    case (Item.GetParentControl as TNextInspector).Style of
      psDefault: if daVisualStyles in Attributes then DrawThemedButton else DrawClassicButton;
      psOffice2003: DrawOffice2003Button;
      psOffice2007: DrawOffice2007Button;
      psWhidbey: DrawWhidbeyButton;
    end;
  with Item as TNxToolbarItem do
  begin
    Buttons[ButtonIndex].Glyph.Transparent := True;
    Buttons[ButtonIndex].Glyph.TransparentColor := Buttons[ButtonIndex].Glyph.Canvas.Pixels[0, Buttons[ButtonIndex].Glyph.Height - 1];
    X := ARect.Left + ((ButtonWidth div 2) - (Buttons[ButtonIndex].Glyph.Width div 2));
    Y := ARect.Top + (((ClientRect.Bottom - ClientRect.Top) div 2) - (Buttons[ButtonIndex].Glyph.Height div 2));
    ApplyBitmap(Canvas, X, Y, Buttons[ButtonIndex].Glyph);
  end;
end;

procedure TNxToolbarItemDisplay.DrawToolbar;
var
  i: Integer;
  r: TRect;
begin
  with Item as TNxToolbarItem, Canvas do
  begin
    for i := 0 to Count - 1 do
    begin
      Brush.Color := clHighlight;
      if Buttons[i].Divider then
      begin
        r := GetButtonRect(i);
        Pen.Color := clGrayText;
        MoveTo(r.Left + (r.Right - r.Left) div 2, r.Top + 2);
        LineTo(r.Left + (r.Right - r.Left) div 2, r.Bottom - 2);
      end else DrawButton(GetButtonRect(i), Buttons[i].Checked, i = FHoverIndex, i = FDownIndex, i);
    end;
    Canvas.Font.Assign(Self.Item.ValueFont);
	  if ShowText then
    begin
      case Alignment of
        baLeftJustify: DrawTextRect(Canvas, Rect(2 + ClientRect.Left + Count * ButtonWidth, ClientRect.Top, ClientRect.Right, ClientRect.Bottom), AsString);
        baRightJustify: DrawTextRect(Canvas, Rect(2 + ClientRect.Left, ClientRect.Top, ClientRect.Right - Count * ButtonWidth, ClientRect.Bottom), AsString);
      end;
		end;
  end;
end;

procedure TNxToolbarItemDisplay.PaintValue;
begin
  inherited PaintValue;
  DrawToolbar;
end;

procedure TNxToolbarItemDisplay.PaintBackground;
begin
  if TNxToolbarItem(Item).DrawBackground then
  begin
    case Style of
      psDefault:
      if IsThemed then ThemeRect(Item.GetParentControl.Handle, Canvas.Handle, ClientRect, teRebar, 0, 1) else
      begin
        Canvas.Brush.Color := clBtnFace;
        Canvas.FillRect(ClientRect);
      end;
      psOffice2003: TGraphicsProvider.DrawGradient(Canvas, ClientRect, GetColor(ceToolbarFromColor), GetColor(ceToolbarToColor));
    end;
  end else inherited;
end;                                       

procedure TNxToolbarItemDisplay.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ButtonIndex: Integer;
begin
  with Item as TNxToolbarItem do
  begin
    ButtonIndex := GetButtonAtPos(X, Y);
    if (ButtonIndex < Count) and (ButtonIndex >= 0) then
    begin
      FDownIndex := ButtonIndex;
      RefreshButton(FDownIndex);
    end;
  end;
end;

procedure TNxToolbarItemDisplay.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ButtonIndex, FOldHoverIndex: Integer;
begin
  with Item as TNxToolbarItem do
  begin
    ButtonIndex := GetButtonAtPos(X, Y);
    if ButtonIndex <> FHoverIndex then
    begin
      FOldHoverIndex := FHoverIndex;
      FHoverIndex := ButtonIndex;
      if (ButtonIndex < Count) and (ButtonIndex >= 0) then
      begin
        RefreshButton(FHoverIndex);
        RefreshButton(FOldHoverIndex);
      end else RefreshButton(FOldHoverIndex);
    end;
  end;
end;

procedure TNxToolbarItemDisplay.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ButtonIndex: Integer;
begin
  with Item as TNxToolbarItem do
  begin
    if FDownIndex > -1 then
    begin
      RefreshButton(FDownIndex);
      FDownIndex := -1;
    end;
    ButtonIndex := GetButtonAtPos(X, Y);
    if (ButtonIndex < Count) and (ButtonIndex >= 0) then
    begin
      if Buttons[ButtonIndex].AutoCheck then Checked[ButtonIndex] := not Checked[ButtonIndex] else
      begin { simple click }
        ButtonClick(ButtonIndex);
      end;
    end;
  end;
end;

procedure TNxToolbarItemDisplay.MouseLeave;
begin
  with Item as TNxToolbarItem do
    if (FHoverIndex < Count) and (FHoverIndex >= 0) then
    begin
      RefreshButton(FHoverIndex);
      FHoverIndex := -1;
    end;
end;

procedure TNxToolbarItemDisplay.ShowHint(ButtonIndex: Integer);
begin

end;

procedure TNxToolbarItemDisplay.KeyDown(var Key: Word; Shift: TShiftState);
var
  KeyIndex: Integer;
  function FindButton(AKeyIndex: Integer): Integer;
  var
    i, c: Integer;
  begin
    Result := 0;
    c := 0;
    with Item as TNxToolbarItem do
      for i := 0 to Buttons.Count - 1 do
      begin
        if not Buttons[i].Divider then
        begin
          if c = AKeyIndex then
          begin
            Result := i;
            Break;
          end;
          Inc(c);
        end;
      end;
  end;
begin
  if (Key < 49) or (Key > 59) then Exit;
  KeyIndex := FindButton(Key - 48 - 1);
  with Item as TNxToolbarItem do
  begin
    if Buttons[KeyIndex].AutoCheck then Buttons[KeyIndex].Checked := not Buttons[KeyIndex].Checked;
  end;
end;

{ TNxTrackBarItemDisplay }

constructor TNxTrackBarItemDisplay.Create(AItem: TNxPropertyItem);
begin
  inherited;
  FDown := False;
  FHover := False;
end;

procedure TNxTrackBarItemDisplay.DrawClassicTrackBar(ARect: TRect);
var
  w: Integer;
begin
  with Canvas, ARect do
  begin
    w := Right - Left;
    Brush.Color := clBtnFace;
    Pen.Color := clBtnFace;
    Polygon([Point(Left, Top),
      Point(Right, Top), Point(Right, Bottom - w div 2),
      Point(Left + w div 2, Bottom), Point(Left, Bottom - w div 2),
      Point(Left, Top)]);
    Pen.Color := clBtnHighlight;
    MoveTo(Right - 1, Top);
    LineTo(Left, Top);
    LineTo(Left, Bottom - w div 2);
    LineTo(Left + w div 2, Bottom);
    Pen.Color := cl3DDkShadow;
    LineTo(Right, Bottom - w div 2);
    LineTo(Right, Top - 1);
    Pen.Color := cl3DLight;
    MoveTo(Right - 2, Top + 1);
    LineTo(Left + 1, Top + 1);
    LineTo(Left + 1, Bottom - w div 2);
    LineTo(Left + w div 2, Bottom - 1);
    Pen.Color := clBtnShadow;
    LineTo(Right - 1, Bottom - w div 2);
    LineTo(Right - 1, Top);
  end;
end;

procedure TNxTrackBarItemDisplay.DrawTrackBar(ARect: TRect; Position, Max,
  Min, Margin: Integer);
var
  TrackRect, GripRect: TRect;
  GripWidth, GripHeight, Distance, ElIndex: Integer;
begin
  TrackRect := ARect;
  TrackRect.Left := TrackRect.Left + GetTextWidth;                                    
  InflateRect(TrackRect, -Margin, -Margin);
  { calculate position }
  Distance := Round(GetTrackWidth * ((Position - Min) / (Max - Min)));
  Inc(Distance, TrackRect.Left);
  GripHeight := (TrackRect.Bottom - TrackRect.Top) + 10;
  GripWidth := GripHeight - 4;
  with GripRect do
  begin
    Left := Distance - (GripWidth div 2);
    Top := ((TrackRect.Bottom - TrackRect.Top) div 2 - GripHeight div 2) + TrackRect.Top;
    Right := Left + GripWidth;
    Bottom := Top + GripHeight;
  end;
  case daVisualStyles in Attributes of
    True:
    begin
      ElIndex := 1;
      if FHover then ElIndex := 2;
      if FDown then ElIndex := 3;
      if not Item.Enabled then ElIndex := 5;
      ThemeRect(Item.GetParentControl.Handle, Canvas.Handle, TrackRect, teTrackBar, 1, 1);
      ThemeRect(Item.GetParentControl.Handle, Canvas.Handle, GripRect, teTrackBar, 4, ElIndex);
    end;
    False:
    begin
      Canvas.Brush.Color := clBtnFace;
      Canvas.FillRect(TrackRect);
      Frame3D(Canvas, TrackRect, cl3DDkShadow, clBtnHighlight, 1);
      InflateRect(GripRect, -1, -1);
      DrawClassicTrackBar(GripRect);
    end;
  end;
end;

function TNxTrackBarItemDisplay.GetPositionAtPos(X, Y: Integer): Integer;
var
  AreaRect: TRect;
  Spot: Integer;
begin
  with Item as TNxTrackBarItem do
  begin
    AreaRect := ClientRect;
    OffsetRect(AreaRect, -AreaRect.Left, -AreaRect.Top);
    InflateRect(AreaRect, -Margin, 0);

    X := X - GetTextWidth;
    Spot := X - Margin;
    Result := Round((Spot / GetTrackWidth) * ((Max + 1) - Min)) + Min;
  end;
end;

function TNxTrackBarItemDisplay.GetTextWidth: Integer;
begin
  with Item as TNxTrackBarItem do
  begin
    if ShowText then
    begin
      Canvas.Font.Assign(ValueFont);
      Result := Canvas.TextWidth(IntToStr(Max) + TextAfter) + 2;
    end else Result := 0;
  end;
end;

function TNxTrackBarItemDisplay.GetTrackWidth: Integer;
begin
  with Item as TNxTrackBarItem do
  begin
    Result := (ClientRect.Right - ClientRect.Left) - (Margin * 2);
    Dec(Result, GetTextWidth);
  end;
end;

procedure TNxTrackBarItemDisplay.KeyDown(var Key: Word; Shift: TShiftState);
var
  Offset: Integer;
begin
  Offset := 1;
  if ssShift in Shift then Offset := 5;
  if ssCtrl in Shift then Offset := 10;
  with Item as TNxTrackBarItem do
    case Key of
      VK_LEFT: Position := Position - Offset;
      VK_RIGHT: Position := Position + Offset;
    end;
end;

procedure TNxTrackBarItemDisplay.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FDown := True;
end;

procedure TNxTrackBarItemDisplay.MouseLeave;
begin
  inherited;
  FDown := False;
  if FHover then
  begin
    FHover := False;
    PaintValue;
  end;
end;

procedure TNxTrackBarItemDisplay.MouseMove(Shift: TShiftState; X,
  Y: Integer);
begin
  if not FHover then
  begin
    FHover := True;
    PaintValue;
  end;
  with Item as TNxTrackBarItem do
    if FDown then
    begin
      Position := GetPositionAtPos(X, Y);
      PaintValue;
    end;
end;

procedure TNxTrackBarItemDisplay.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  with Item as TNxTrackBarItem do
    if FDown then
    begin
      Position := GetPositionAtPos(X, Y);
      FDown := False;
      PaintValue;
    end;
end;

procedure TNxTrackBarItemDisplay.PaintValue;
var
  TxtRect: TRect;
begin
  inherited;
  with Item as TNxTrackBarItem do
  begin
    DrawTrackBar(ClientRect, Position, Max, Min, Margin);
    if ShowText then
    begin
      TxtRect := ClientRect;
      TxtRect.Left := TxtRect.Left + 2;
      TGraphicsProvider.DrawTextRect(Canvas, TxtRect, taLeftJustify, AsString + TextAfter);
    end;
  end;
end;

{ TNxRadioItemDisplay }

constructor TNxRadioItemDisplay.Create(AItem: TNxPropertyItem);
begin
  inherited;
  FDown := False;
  FHover := False;
end;

procedure TNxRadioItemDisplay.KeyDown(var Key: Word; Shift: TShiftState);
begin
  { Item can not be unchecked }
  with Item as TNxRadioItem do AsBoolean := True;//not AsBoolean;
end;

procedure TNxRadioItemDisplay.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FDown then
  begin
    FDown := True;
    PaintValue;
  end;
end;

procedure TNxRadioItemDisplay.MouseLeave;
begin
  FHover := False;
  PaintValue;
end;

procedure TNxRadioItemDisplay.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if not FHover then
  begin
    FHover := True;
    PaintValue;
  end;
end;

procedure TNxRadioItemDisplay.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FDown then
  begin
    FDown := False;
    PaintValue;
  end;
  with Item as TNxRadioItem do
  begin
    if InBounds then if not Checked then Checked := True;
  end;
end;

procedure TNxRadioItemDisplay.PaintValue;
var
  RadioRect: TRect;
  RadioSize: Integer;
  
  procedure DrawThemedRadioButton;
  var
    ElIndex: Integer;
  begin
    with Item as TNxRadioItem do
    begin
      if not Enabled then
      begin
        if Checked then ElIndex := tiRadioCheckedDisabled else ElIndex := tiRadioDisabled;
        ThemeRect(GetParentControl.Handle, Canvas.Handle, RadioRect, teButton, tcRadioButton, ElIndex);
      end else
      if Checked then
      begin
        if FHover then ElIndex := tiRadioCheckedHover else ElIndex := tiRadioChecked;
        if FDown then ElIndex := tiRadioCheckedDown;
        ThemeRect(GetParentControl.Handle, Canvas.Handle, RadioRect, teButton, tcRadioButton, ElIndex);
      end else
      begin
        if FHover then ElIndex := 2 else ElIndex := 1;
        if FDown then ElIndex := 3;
        ThemeRect(GetParentControl.Handle, Canvas.Handle, RadioRect, teButton, tcRadioButton, ElIndex);
      end;
    end;
  end;
  
  procedure DrawClassicRadioButon;
  var
    Flags: Integer;
  begin
    InflateRect(RadioRect, -1, -1);
    Flags := DFCS_BUTTONRADIO;
    with Item as TNxRadioItem do
    begin
      if FDown then Flags := Flags or DFCS_PUSHED;
      if Checked then Flags := Flags or DFCS_CHECKED;
      if not Self.Item.Enabled then Flags := Flags or DFCS_INACTIVE;
      if FlatStyle then Flags := Flags or DFCS_MONO;
      DrawFrameControl(Canvas.Handle, RadioRect, DFC_BUTTON, Flags);
    end;
  end;
begin
  inherited PaintValue;
  RadioSize := ClientRect.Bottom - ClientRect.Top;
  case TNxRadioItem(Item).Alignment of
    taLeftJustify: RadioRect := Rect(ClientRect.Left, ClientRect.Top, ClientRect.Left + RadioSize, ClientRect.Bottom);
    taCenter: RadioRect := ClientRect;
    taRightJustify: RadioRect := Rect(ClientRect.Right - RadioSize, ClientRect.Top, ClientRect.Right, ClientRect.Bottom);
  end;
  case daVisualStyles in Attributes of
    True: DrawThemedRadioButton;
    False: DrawClassicRadioButon;
  end;
end;

{ TNxCheckBoxItemDisplay }

procedure TNxCheckBoxItemDisplay.DrawButton(const ARect: TRect; Checked,
  Hover, Down: Boolean; ButtonIndex: Integer);
  procedure DrawThemedMark;
  var
    Index: Integer;
  begin
    Index := 0;
    if Hover then Index := 2;
    if Checked then if Hover then Index := 6 else Index := 5;
    if Down then Index := 3;
    ThemeRect(Item.GetParentControl.Handle, Canvas.Handle, ARect, teButton, tcCheckBox, Index);
  end;
  
  procedure DrawClassicMark;
  var
    Flags: Integer;
    r: TRect;
  begin
    r := ARect;
    InflateRect(r, -1, -1);
    Flags := DFCS_BUTTONCHECK;
    if Down then Flags := Flags or DFCS_PUSHED;
    if Checked then Flags := Flags or DFCS_CHECKED;
    if not Item.Enabled then Flags := Flags or DFCS_INACTIVE;
    if TNxCheckBoxItem(Item).FlatStyle then Flags := Flags or DFCS_MONO;
    DrawFrameControl(Canvas.Handle, r, DFC_BUTTON, Flags);
  end;

  procedure DrawOffice2003Mark;
  var
    ABitmap: Graphics.TBitmap;
  begin
    ABitmap := Graphics.TBitmap.Create;
    if Checked then ABitmap.LoadFromResourceName(HInstance, 'CHECKED')
      else ABitmap.LoadFromResourceName(HInstance, 'UNCHECKED');
    TDrawProvider.ApplyBitmap(Canvas, ARect.Left, ARect.Top, ABitmap);
    ABitmap.Free;
  end;

  procedure DrawOffice2007Mark;
  var
    ABitmap: Graphics.TBitmap;
    X, Y, Index: Integer;
    ResName: string;
  begin
    Index := 0;
    if Checked then Inc(Index, 4);
    if Item.Enabled then
    begin
      Inc(Index);
      if Hover then
      begin
        Inc(Index);
        if Down then Inc(Index);
      end;
    end;
    ABitmap := Graphics.TBitmap.Create;
    ResName := 'CHECKBOX_' + IntToStr(Index);
    case ColorScheme of
      csSilver: ResName := ResName + '1';
      csBlue: ResName := ResName + '0';
      csBlack: ResName := ResName + '2';
    end;
    ABitmap.LoadFromResourceName(HInstance, ResName);
    X := ARect.Left + (ARect.Right - ARect.Left) div 2 - ABitmap.Width div 2;
    Y := ARect.Top + (ARect.Bottom - ARect.Top) div 2 - ABitmap.Height div 2;
    Canvas.Draw(X, Y, ABitmap);
    ABitmap.Free;
  end;

begin
  case TNxCheckBoxItem(Item).Style of
    bsButton: inherited;
    bsCheckMark:
    begin
      case Style of
        psDefault: if daVisualStyles in Attributes then DrawThemedMark else DrawClassicMark;
        psOffice2003, psWhidbey: DrawOffice2003Mark;
        psOffice2007: DrawOffice2007Mark;
      end;
    end;
  end;
end;

procedure TNxCheckBoxItemDisplay.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_SPACE) and (Shift = []) then
    with Item as TNxCheckBoxItem do AsBoolean := not AsBoolean;
end;

{ TNxMemoItemDisplay }

procedure TNxMemoItemDisplay.PaintValueData;
  procedure DrawLines;
  var
    i: Integer;
    r: TRect;
    B: Graphics.TBitmap;
  begin
    r := GetTextRect;
    B := Graphics.TBitmap.Create;
    B.LoadFromResourceName(HInstance, 'NEWROW');
    B.TransparentColor := clLime;
    B.Transparent := True;
    with Item as TNxMemoItem do
    begin
      for i := 0 to Lines.Count - 1 do
      begin
        DrawTextRect(Canvas, r, Lines[i]);
        r.Left := r.Left + Canvas.TextWidth(Lines[i]);
        if MultiLineSymbol and (i < Lines.Count - 1) then
        begin
          Canvas.Draw(r.Left, (r.Top + (r.Bottom - r.Top) div 2) - B.Height div 2, B);
          r.Left := r.Left + B.Width;
        end;
        r.Left := r.Left + 4;
        if r.Left > ClientRect.Right then Exit;
      end;
    end;
    B.Free;
  end;
begin
  inherited;
  exit;
  with Canvas do
  begin
    Font.Assign(Item.ValueFont);
    if Item.Value = '' then
    begin
      Font.Color := clGrayText;
      TGraphicsProvider.DrawTextRect(Canvas, GetTextRect, taLeftJustify, Item.EmptyValue, BiDiMode);
    end else DrawLines;
  end;
end;

{ TNxProgressItemDisplay }

procedure TNxProgressItemDisplay.DrawBoxes(R: TRect; Color: TColor);
var
  Pos, S: Integer;
begin
  if R.Bottom - R.Top <= 0 then Exit;
  Pos := R.Left;
  S := Round((R.Bottom - R.Top) / 1.5);
  while Pos + S < R.Right do
  begin                               
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(Rect(Pos, R.Top, Pos + S, R.Bottom));
    end;
    Inc(Pos, S + 2);
  end;
end;

procedure TNxProgressItemDisplay.DrawProgressBar;
const
  spaTextToBar = 35;
var
  Ratio: Double;
  TxtRect, BorderRect, BoxRect, ProgressRect: TRect;
  Distance: Integer;
  FillColor: TColor;
begin
  with Canvas, Item as TNxProgressItem do
  begin
    Ratio := TCalcProvider.GetRatio(Position, Max);
    BorderRect := Self.ClientRect;
    InflateRect(BorderRect, -Margin, -Margin); { margin }

    if Height > 0 then
    begin
      BorderRect.Top := BorderRect.Top + (BorderRect.Bottom - BorderRect.Top) div 2 - Height div 2;
      BorderRect.Bottom := BorderRect.Top + Height;
    end;

    if ShowText then
    begin
      Canvas.Font.Assign(ValueFont);
      TxtRect := ClientRect;
      TxtRect.Left := TxtRect.Left + 2;
      TGraphicsProvider.DrawTextRect(Canvas, TxtRect, taLeftJustify, IntToStr(Position) + '%');
      BorderRect.Left := BorderRect.Left + spaTextToBar;
    end;
    
    Brush.Color := BorderColor;
    if Transparent then FrameRect(BorderRect) else
    begin
      Brush.Color := Color;
      Pen.Color := BorderColor;
      if RoundCorners
        then RoundRect(BorderRect.Left, BorderRect.Top, BorderRect.Right, BorderRect.Bottom, 4, 4)
          else Rectangle(BorderRect);
    end;

    BoxRect := BorderRect;
    InflateRect(BoxRect, -2, -2);

    Distance := Round((BoxRect.Right - BoxRect.Left) * (Ratio / 100));
    with ProgressRect do
    begin
      Left := BoxRect.Left;
      Right := BoxRect.Left + Distance;
      if Right >= BorderRect.Right - 2 then Right := BorderRect.Right - 2;
      Top := BoxRect.Top;
      Bottom := BoxRect.Bottom;
    end;
    
    FillColor := ProgressColor;

    Brush.Color := FillColor; { fill }
    case ProgressStyle of
      pbSolid: FillRect(ProgressRect);
      pbBoxes: DrawBoxes(ProgressRect, FillColor);
      pbGradient: TGraphicsProvider.DrawVertGradient(Canvas, ProgressRect, Color, FillColor);
      pbCylinder: TGraphicsProvider.DrawGradient(Canvas, ProgressRect, Color, FillColor);
    end;
  end;
end;

procedure TNxProgressItemDisplay.PaintValue;
begin
  inherited;
  DrawProgressBar;
end;

{ TNxComboBoxColumn }

procedure TNxComboBoxDisplay.PaintPreview(PreviewRect: TRect);
begin
  inherited;
  Canvas.Brush.Color := clred;
  with Item as TNxComboBoxItem do
  begin
    Images.Draw(Canvas, PreviewRect.Left, PreviewRect.Top, Index);
  end;
end;

end.
