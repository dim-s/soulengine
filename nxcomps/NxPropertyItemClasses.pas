{$I 'NxSuite.inc'}

unit NxPropertyItemClasses;
                                 
interface

uses
  Types, Graphics, Classes, Controls, Messages, NxPropertyItems, NxInspector,
  StdCtrls, ExtCtrls, ImgList, NxClasses, NxStdCtrls, NxEdit, Dialogs, NxSharedCommon;

type
  TButtonsAlignment = (baLeftJustify, baRightJustify);
  TComboBoxStyle = (cbDropDown, cbDropDownList);
  TColorKind = (ckDelphi, ckWeb);
	TCheckBoxTextKind = (tkTrueFalse, tkYesNo, tkEnabledDisabled, tkCustom);
  TCheckBoxStyle = (bsButton, bsCheckMark);
  TProgressBarStyle = (pbSolid, pbBoxes, pbGradient, pbCylinder);

  TNxItemNotifyEvent = procedure (Sender: TNxPropertyItem) of object;
  TNxToolButtonClickEvent = procedure (Sender: TNxPropertyItem; ButtonIndex: Integer) of object;

  TNxCustomTextItem = class(TNxPropertyItem)
  private
    FMaxLength: Integer;
    FAlignment: TAlignment;
    FVerticalAlignment: TVerticalAlignment;
    FPasswordChar: TChar;
    FWrapKind: TWrapKind;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetVerticalAlignment(const Value: TVerticalAlignment);
    procedure SetPasswordChar(const Value: TChar);
    procedure SetWrapKind(const Value: TWrapKind);
  protected
    function GetItemEditorClass: TCellEditorClass; override;
    function PreviewAvailable: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    function IsEditable: Boolean; override;
    procedure BeginEditing; override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property MaxLength: Integer read FMaxLength write FMaxLength default 0;
    property PasswordChar: TChar read FPasswordChar write SetPasswordChar default #0;
    property VerticalAlignment: TVerticalAlignment read FVerticalAlignment write SetVerticalAlignment default taVerticalCenter;
    property WrapKind: TWrapKind read FWrapKind write SetWrapKind default wkEllipsis;
  end;

  TNxTextItem = class(TNxCustomTextItem)
  private
    FValue: WideString;
  protected
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    function GetItemDisplayClass: TItemDisplayClass; override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TNxTimeItem = class(TNxTextItem)
  private
    FTime: TTime;
  protected
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetItemEditorClass: TCellEditorClass; override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure EndEditing; override;
  end;

  TNxPopupItem = class(TNxTextItem)
  private
    FOnCloseUp: TNxItemNotifyEvent;
    FOnSelect: TNxItemNotifyEvent;
  protected
    procedure DoCloseUp(Sender: TObject); dynamic;
    procedure DoSelect(Sender: TObject); dynamic;
  public
    procedure PrepareEditing; override;
  published
    property OnCloseUp: TNxItemNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnSelect: TNxItemNotifyEvent read FOnSelect write FOnSelect;
  end;

  TNxToolbarItem = class;
  TNxToolbarItemButtons = class;

  TNxToolbarItemButton = class(TCollectionItem)
  private
    FAutoCheck: Boolean;
    FChecked: Boolean;
    FCollection: TNxToolbarItemButtons;
    FDivider: Boolean;
    FGlyph: TBitmap;
    FText: WideString;
    procedure SetAutoCheck(const Value: Boolean);
    procedure SetChecked(const Value: Boolean);
    procedure SetDivider(const Value: Boolean);
    procedure SetGlyph(const Value: TBitmap);
  protected
    procedure DoGlyphChange(Sender: TObject);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property AutoCheck: Boolean read FAutoCheck write SetAutoCheck default True;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Divider: Boolean read FDivider write SetDivider default False;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property Text: WideString read FText write FText;
  end;

  TNxToolbarItemButtons = class(TCollection)
  private
    FCheckedCount: Integer;
    FOwner: TNxToolbarItem;
    function GetItem(Index: Integer): TNxToolbarItemButton;
    procedure SetItem(Index: Integer; const Value: TNxToolbarItemButton);
    procedure CheckButton(Button: TNxToolbarItemButton; Value: Boolean);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TNxToolbarItem);
    function Add: TNxToolbarItemButton;
    property Items[Index: Integer]: TNxToolbarItemButton read GetItem write SetItem; default;
  end;

  TNxToolbarItem = class(TNxPropertyItem)
  private
    FAlignment: TButtonsAlignment;
    FAllowAllUp: Boolean;
    FButtons: TNxToolbarItemButtons;
    FButtonWidth: Integer;
    FDrawBackground: Boolean;
    FGrouped: Boolean;
    FHint: string;
    FOnToolButtonClick: TNxToolButtonClickEvent;
    FShowText: Boolean;
    function GetCount: Integer;
    function GetChecked(Index: Integer): Boolean;
    procedure SetAlignment(const Value: TButtonsAlignment);
    procedure SetButtons(const Value: TNxToolbarItemButtons);
    procedure SetButtonWidth(const Value: Integer);
    procedure SetDrawBackground(const Value: Boolean);
    procedure SetShowText(const Value: Boolean);
  protected
    function GetAsString: WideString; override;
    function GetItemDisplayClass: TItemDisplayClass; override;
    procedure CreateButtons; virtual;
    procedure DoToolButtonClick(ButtonIndex: Integer); dynamic;
    procedure SetAsString(const Value: WideString); override;
    procedure SetChecked(Index: Integer; const Value: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddButton(Text: WideString; AutoCheck: Boolean = True): TNxToolbarItemButton;
    procedure ButtonClick(Index: Integer);
    procedure RefreshButton(Index: Integer);
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    property Count: Integer read GetCount;
  published
    property Alignment: TButtonsAlignment read FAlignment write SetAlignment default baLeftJustify;
    property AllowAllUp: Boolean read FAllowAllUp write FAllowAllUp default False;
    property Buttons: TNxToolbarItemButtons read FButtons write SetButtons;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth default 17;
    property Grouped: Boolean read FGrouped write FGrouped default False;
    property DrawBackground: Boolean read FDrawBackground write SetDrawBackground default False;
    property ShowText: Boolean read FShowText write SetShowText default False;
    property OnToolButtonClick: TNxToolButtonClickEvent read FOnToolButtonClick write FOnToolButtonClick;
  end;

  TNxCheckBoxItem = class(TNxToolbarItem)
  private
    FFalseText: WideString;
    FFlatStyle: Boolean;
    FStyle: TCheckBoxStyle;
    FTextKind: TCheckBoxTextKind;
    FTrueText: WideString;
    procedure SetTextKind(const Value: TCheckBoxTextKind);
    procedure SetFalseText(const Value: WideString);
    procedure SetTrueText(const Value: WideString);
    procedure SetStyle(const Value: TCheckBoxStyle);
    procedure SetFlatStyle(const Value: Boolean);
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsString: WideString; override;
    function GetItemDisplayClass: TItemDisplayClass; override;
    procedure SetAsBoolean(const Value: Boolean); override;
    procedure SetAsString(const Value: WideString); override;
    procedure SetChecked(Index: Integer; const Value: Boolean); override;
    procedure CreateButtons; override;
  public
    constructor Create(AOwner: TComponent); override;
	published
    property FalseText: WideString read FFalseText write SetFalseText;
    property FlatStyle: Boolean read FFlatStyle write SetFlatStyle default False;
    property Style: TCheckBoxStyle read FStyle write SetStyle default bsCheckMark;
    property TextKind: TCheckBoxTextKind read FTextKind write SetTextKind default tkTrueFalse;
    property TrueText: WideString read FTrueText write SetTrueText;
  end;

  TNxButtonItem = class(TNxTextItem)
  private
    FEditOptions: TNxEditOptions;
    FGlyph: TBitmap;
    FOnButtonClick: TNxItemNotifyEvent;
    FTransparentColor: TColor;
    FButtonWidth: Integer;
    procedure SetGlyph(const Value: TBitmap);
    procedure SetTransparentColor(const Value: TColor);
  protected
    function GetItemEditorClass: TCellEditorClass; override;
    procedure DoEditorButtonClick(Sender: TObject);
    procedure DoButtonClick; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginEditing; override;
  published
    property ButtonWidth: Integer read FButtonWidth write FButtonWidth default 21;
    property EditOptions: TNxEditOptions read FEditOptions write FEditOptions default [];
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor;
    property OnButtonClick: TNxItemNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;

  TNxImagePathItem = class(TNxButtonItem)
  protected
    function GetItemEditorClass: TCellEditorClass; override;
  end;

  TNxMemoItem = class(TNxButtonItem)
  private
    FLines: TStrings;
    FMultiLineSymbol: Boolean;
    FShowButton: Boolean;
    procedure SetLines(const Value: TStrings);
    procedure SetMultiLineSymbol(const Value: Boolean);
  protected
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    function GetItemDisplayClass: TItemDisplayClass; override;
    function GetItemEditorClass: TCellEditorClass; override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Lines: TStrings read FLines write SetLines;
    property MultiLineSymbol: Boolean read FMultiLineSymbol write SetMultiLineSymbol default True;
    property ShowButton: Boolean read FShowButton write FShowButton default False;
  end;

  TNxAlignmentItem = class(TNxToolbarItem)
  protected
    procedure CreateButtons; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TNxVertAlignmentItem = class(TNxToolbarItem)
  protected
    procedure CreateButtons; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TNxComboBoxItem = class(TNxPopupItem)
  private
    FDisplayMode: TItemsDisplayMode;
    FDropDownCount: Integer;
    FImages: TCustomImageList;
    FItemIndex: Integer;
    FLines: TStrings;
    FStyle: TComboBoxStyle;
    procedure SetLines(const Value: TStrings);
    procedure SetStyle(const Value: TComboBoxStyle);
    procedure SetItemIndex(const Value: Integer);
    procedure SetDropDownCount(const Value: Integer);
    procedure SetImages(const Value: TCustomImageList);
    function GetItemName: string;
    function GetItemValue: string;
  protected
    function GetItemEditorClass: TCellEditorClass; override;
    function GetValueFromIndex(const Index: Integer): string;
    procedure DoCloseUp(Sender: TObject); override;
  public
    procedure AssignEditing; override;
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EndEditing; override;
    property ItemName: string read GetItemName;
    property ItemValue: string read GetItemValue;
  published
    property DisplayMode: TItemsDisplayMode read FDisplayMode write FDisplayMode default dmDefault;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property Images: TCustomImageList read FImages write SetImages;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
  	property Lines: TStrings read FLines write SetLines;
    property Style: TComboBoxStyle read FStyle write SetStyle default cbDropDown;
  end;

  TNxFontNameItem = class(TNxComboBoxItem)
  protected
    function GetItemDisplayClass: TItemDisplayClass; override;
    function GetItemEditorClass: TCellEditorClass; override;
  public
    procedure BeginEditing; override;
  end;

  TNxColorItem = class(TNxPopupItem)
  private
    FColorKind: TColorKind;
    FUseColorNames: Boolean;
    procedure SetColorKind(const Value: TColorKind);
    procedure SetUseColorNames(const Value: Boolean);
  protected
    function GetItemDisplayClass: TItemDisplayClass; override;
    function GetItemEditorClass: TCellEditorClass; override;
    { values }
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginEditing; override;
  published
  	property ColorKind: TColorKind read FColorKind write SetColorKind default ckDelphi;
    property UseColorNames: Boolean read FUseColorNames write SetUseColorNames default False;
  end;

  TNxDateItem = class(TNxPopupItem)
  private
    FStartDay: TStartDayOfWeek;
    FShowNoneButton: Boolean;
    FMonthNames: TStrings;
    FDayNames: TStrings;
    FNoneCaption: WideString;
    FTodayCaption: WideString;
    procedure SetDayNames(const Value: TStrings);
    procedure SetMonthNames(const Value: TStrings);
    procedure SetNoneCaption(const Value: WideString);
    procedure SetShowNoneButton(const Value: Boolean);
    procedure SetTodayCaption(const Value: WideString);
  protected
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetItemEditorClass: TCellEditorClass; override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginEditing; override;
  published
    property DayNames: TStrings read FDayNames write SetDayNames;
    property MonthNames: TStrings read FMonthNames write SetMonthNames;
    property NoneCaption: WideString read FNoneCaption write SetNoneCaption;
    property ShowNoneButton: Boolean read FShowNoneButton write SetShowNoneButton default True;
    property StartDay: TStartDayOfWeek read FStartDay write FStartDay default dwSunday;
    property TodayCaption: WideString read FTodayCaption write SetTodayCaption;
  end;

  TNxCustomNumberItem = class(TNxTextItem)
  private
    FEditOptions: TNxNumberEditOptions;
    FFormatMask: string;
    FMax: Double;
    FMin: Double;
    FValue: Double;
    procedure SetFormatMask(const Value: string);
    procedure SetMax(const Value: Double);
    procedure SetMin(const Value: Double);
  protected
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
    constructor Create(AOwner: TComponent); override;
  published                                      
    property EditOptions: TNxNumberEditOptions read FEditOptions write FEditOptions default [eoAllowFloat, eoAllowSigns];
    property FormatMask: string read FFormatMask write SetFormatMask;
    property Max: Double read FMax write SetMax;
    property Min: Double read FMin write SetMin;
  end;

  TNxSpinItem = class(TNxCustomNumberItem)
  private
    FIncrement: Double;
    FSpinButtons: Boolean;
    procedure SetIncrement(const Value: Double);
    procedure SetSpinButtons(const Value: Boolean);
  protected
    function GetItemEditorClass: TCellEditorClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginEditing; override;
  published
    property Increment: Double read FIncrement write SetIncrement;
    property SpinButtons: Boolean read FSpinButtons write SetSpinButtons default True;
  end;

  TNxCalcItem = class(TNxCustomNumberItem)
  private
    FAutoClose: Boolean;
  protected
    function GetItemEditorClass: TCellEditorClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginEditing; override;
  published
    property AutoClose: Boolean read FAutoClose write FAutoClose default False;
  end;

  TNxTrackBarItem = class(TNxPropertyItem)
  private
    FMargin: Integer;
    FMin: Integer;
    FPosition: Integer;
    FMax: Integer;
    FShowText: Boolean;
    FTextAfter: WideString;
    procedure SetMargin(const Value: Integer);
    procedure SetMax(const Value: Integer);
    procedure SetMin(const Value: Integer);
    procedure SetPosition(const Value: Integer);
    procedure SetShowText(const Value: Boolean);
    procedure SetTextAfter(const Value: WideString);
  protected
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    function GetItemDisplayClass: TItemDisplayClass; override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Margin: Integer read FMargin write SetMargin;
    property Max: Integer read FMax write SetMax default 100;
    property Min: Integer read FMin write SetMin default 0;
    property Position: Integer read FPosition write SetPosition default 0;
    property ShowText: Boolean read FShowText write SetShowText default True;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
  end;

  TNxFontStyleItem = class(TNxToolbarItem)
  protected
    procedure CreateButtons; override;
	public
    constructor Create(AOwner: TComponent); override;
    function FontStylesToString(const Value: TFontStyles): WideString;
    function StringToFontStyles(const Value: WideString): TFontStyles;
  end;

  TNxProgressItem = class(TNxPropertyItem)
  private
    FRoundCorners: Boolean;
    FShowText: Boolean;
    FHideWhenEmpty: Boolean;
    FTransparent: Boolean;
    FMax: Integer;
    FProgressHeight: Integer;
    FMargin: Integer;
    FBorderColor: TColor;
    FProgressColor: TColor;
    FProgressStyle: TProgressBarStyle;
    FPosition: Integer;
    FHeight: Integer;
    procedure SetBorderColor(const Value: TColor);
    procedure SetHideWhenEmpty(const Value: Boolean);
    procedure SetMargin(const Value: Integer);
    procedure SetMax(const Value: Integer);
    procedure SetProgressColor(const Value: TColor);
    procedure SetProgressHeight(const Value: Integer);
    procedure SetProgressStyle(const Value: TProgressBarStyle);
    procedure SetRoundCorners(const Value: Boolean);
    procedure SetShowText(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure SetPosition(const Value: Integer);
    procedure SetHeight(const Value: Integer);
  protected
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    function GetItemDisplayClass: TItemDisplayClass; override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property BorderColor: TColor read FBorderColor write SetBorderColor default clGrayText;
    property Height: Integer read FHeight write SetHeight default 0;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty default False;
    property Margin: Integer read FMargin write SetMargin default 2;
    property Max: Integer read FMax write SetMax default 100;
    property Position: Integer read FPosition write SetPosition default 0;
    property ProgressColor: TColor read FProgressColor write SetProgressColor default clHighlight;
    property ProgressHeight: Integer read FProgressHeight write SetProgressHeight default 0;
    property ProgressStyle: TProgressBarStyle read FProgressStyle write SetProgressStyle default pbSolid;
    property RoundCorners: Boolean read FRoundCorners write SetRoundCorners default False;
    property ShowText: Boolean read FShowText write SetShowText default False;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
  end;

  TNxRadioItem = class(TNxPropertyItem)
  private
    FAlignment: TAlignment;
    FChecked: Boolean;
    FFlatStyle: Boolean;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetChecked(const Value: Boolean);
    procedure SetFlatStyle(const Value: Boolean);
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsString: WideString; override;
    function GetItemDisplayClass: TItemDisplayClass; override;
    procedure SetAsBoolean(const Value: Boolean); override;
    procedure SetAsString(const Value: WideString); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property Checked: Boolean read FChecked write SetChecked default False;
    property FlatStyle: Boolean read FFlatStyle write SetFlatStyle default False;
  end;

  TNxFolderItem = class(TNxButtonItem)
  private
    FDialogCaption: WideString;
    FOnFolderSelect: TNotifyEvent;
    FRoot: WideString;
    procedure SetDialogCaption(const Value: WideString);
  protected
    function GetItemEditorClass: TCellEditorClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property DialogCaption: WideString read FDialogCaption write SetDialogCaption;
    property Root: WideString read FRoot write FRoot;
    property OnFolderSelect: TNotifyEvent read FOnFolderSelect write FOnFolderSelect;
  end;

implementation

uses
  Forms, ExtDlgs, SysUtils, NxPropertyItemDisplay, Math,
  {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON};

{ TNxCustomTextItem }

procedure TNxCustomTextItem.BeginEditing;
begin
  with Editor as TNxCustomEdit do
  begin
    AsString := Self.AsString;
    ShowPreview := Self.ShowPreview;
    MaxLength := Self.MaxLength;
  end;
  inherited BeginEditing;
end;

constructor TNxCustomTextItem.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taLeftJustify;
  FVerticalAlignment := taVerticalCenter;
  FWrapKind := wkEllipsis;
end;

function TNxCustomTextItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxEdit;
end;

function TNxCustomTextItem.IsEditable: Boolean;
begin
  Result := True;
end;

function TNxCustomTextItem.PreviewAvailable: Boolean;
begin
  Result := True;
end;

procedure TNxCustomTextItem.SetAlignment(
  const Value: TAlignment);
begin
  FAlignment := Value;
  Changed;
end;

procedure TNxCustomTextItem.SetVerticalAlignment(
  const Value: TVerticalAlignment);
begin
  FVerticalAlignment := Value;
  Changed;
end;

procedure TNxCustomTextItem.SetPasswordChar(const Value:
  {$IFDEF TNTUNICODE}WideChar{$ELSE}Char{$ENDIF});
begin
  FPasswordChar := Value;
  TNxEdit(Editor).PasswordChar := FPasswordChar;
end;

procedure TNxCustomTextItem.SetWrapKind(const Value: TWrapKind);
begin
  FWrapKind := Value;
  Changed;
end;

{ TNxToolbarItemButton }

constructor TNxToolbarItemButton.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FAutoCheck := True;
  FChecked := False;
  FDivider := False;
  FCollection := TNxToolbarItemButtons(Collection);
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
end;

destructor TNxToolbarItemButton.Destroy;
begin
  FGlyph.Free;
  inherited;
end;

procedure TNxToolbarItemButton.DoGlyphChange(Sender: TObject);
begin
  FCollection.FOwner.Change(ckToolButtonRedraw, Index);
end;

procedure TNxToolbarItemButton.SetAutoCheck(const Value: Boolean);
begin
  FAutoCheck := Value;
end;

procedure TNxToolbarItemButton.SetChecked(const Value: Boolean);
begin
  FCollection.CheckButton(Self, Value);
  FCollection.FOwner.Change(ckToolButtonRedraw, Index);
end;

procedure TNxToolbarItemButton.SetDivider(const Value: Boolean);
begin
  FDivider := Value;
  FCollection.FOwner.Change(ckToolButtonRedraw, Index);
end;

procedure TNxToolbarItemButton.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
end;

{ TNxToolbarItem }

constructor TNxToolbarItem.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := baLeftJustify;
  FAllowAllUp := False;
  FButtons := TNxToolbarItemButtons.Create(Self);
  FButtonWidth := 17;
  FDrawBackground := False;
  FGrouped := False;
  FHint := '';
  FShowText := False;
  CreateButtons; { need to be overrided }
end;

destructor TNxToolbarItem.Destroy;
begin
  FButtons.Clear;
  FButtons.Free;
  FButtons := nil;
  inherited;
end;

procedure TNxToolbarItem.CreateButtons;
begin

end;

procedure TNxToolbarItem.DoToolButtonClick(ButtonIndex: Integer);
begin
  if Assigned(FOnToolButtonClick) then FOnToolButtonClick(Self, ButtonIndex);
end;

function TNxToolbarItem.GetCount: Integer;
begin
  Result := FButtons.Count;
end;

function TNxToolbarItem.GetChecked(Index: Integer): Boolean;
begin
  Result := FButtons[Index].Checked;
end;

procedure TNxToolbarItem.SetChecked(Index: Integer; const Value: Boolean);
begin
  FButtons[Index].Checked := Value;
  if Items = nil then Exit;
  UpdateVCLProperty;
  Change(ckValueChanged);
end;

procedure TNxToolbarItem.SetShowText(const Value: Boolean);
begin
  FShowText := Value;
  Change(ckValueMember);
end;

function TNxToolbarItem.AddButton(Text: WideString; AutoCheck: Boolean): TNxToolbarItemButton;
begin
  Result := FButtons.Add;
  Result.AutoCheck := AutoCheck;
  Result.Text := Text;
end;

function TNxToolbarItem.GetAsString: WideString;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to FButtons.Count - 1 do
    if Checked[i] then
    begin
      if Result <> '' then Result := Result + ',';
      Result := Result + Buttons[i].Text;
    end;
end;

procedure TNxToolbarItem.SetAsString(const Value: WideString);
var
  i: Integer;
begin
  for i := 0 to FButtons.Count - 1 do Checked[i] := Pos(Buttons[i].Text, Value) > 0;
  inherited SetAsString(Value);
end;

function TNxToolbarItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxToolbarItemDisplay;
end;

procedure TNxToolbarItem.SetButtons(const Value: TNxToolbarItemButtons);
begin
  FButtons.Assign(Value);
end;

procedure TNxToolbarItem.RefreshButton(Index: Integer);
begin
  Change(ckToolButtonRedraw, Index);
end;

procedure TNxToolbarItem.ButtonClick(Index: Integer);
begin
  Change(ckToolButtonClick, Index);
  DoToolButtonClick(Index);
end;

procedure TNxToolbarItem.SetAlignment(const Value: TButtonsAlignment);
begin
  FAlignment := Value;
  Change(ckValueRepaint);
end;

procedure TNxToolbarItem.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;
  Change(ckValueRepaint);
end;

procedure TNxToolbarItem.SetDrawBackground(const Value: Boolean);
begin
  FDrawBackground := Value;
  Change(ckValueRepaint);
end;

{procedure TNxToolbarItem.SetHint(const Value: string);
begin
  FHint := Value;
end;}

{ TNxCheckBoxItem }

constructor TNxCheckBoxItem.Create(AOwner: TComponent);
begin
  inherited;
  AllowAllUp := True;
  FFlatStyle := False;
  FStyle := bsCheckMark;
  FTextKind := tkTrueFalse;
end;

procedure TNxCheckBoxItem.CreateButtons;
begin
  inherited;
  with AddButton('true') do Glyph.LoadFromResourceName(HInstance, 'CHECKMARK');
end;

function TNxCheckBoxItem.GetAsBoolean: Boolean;
begin
  Result := Checked[0];
end;

function TNxCheckBoxItem.GetAsString: WideString;
begin                                        
	case FTextKind of
    tkTrueFalse: if Checked[0] then Result := 'true' else Result := 'false';
    tkYesNo: if Checked[0] then Result := 'yes' else Result := 'no';
    tkEnabledDisabled: if Checked[0] then Result := 'enabled' else Result := 'disabled';
    tkCustom:	if Checked[0] then
	      			begin
				        if (FTrueText <> '') then Result := FTrueText else Result := 'true';
				      end else
				      begin
				        if (FFalseText <> '') then Result := FFalseText else Result := 'false';
			        end
  end;
end;

function TNxCheckBoxItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxCheckBoxItemDisplay;
end;

procedure TNxCheckBoxItem.SetAsBoolean(const Value: Boolean);
begin
  Checked[0] := Value;
//  inherited; // { TODO 3 -oBoki -cDeleted : Trigger OnChange twice }
end;

procedure TNxCheckBoxItem.SetAsString(const Value: WideString);
begin
  inherited;
  case TextKind of
    tkCustom: if Value = TrueText then Checked[0] := True else Checked[0] := False;
    tkTrueFalse: if Value = 'true' then Checked[0] := True else Checked[0] := False;
    tkYesNo: if Value = 'yes' then Checked[0] := True else Checked[0] := False;
    tkEnabledDisabled: if Value = 'enabled' then Checked[0] := True else Checked[0] := False;
  end;
end;

procedure TNxCheckBoxItem.SetChecked(Index: Integer; const Value: Boolean);
begin
  inherited;
  Change(ckValueRepaint);
  if not (csReading in ComponentState) then UpdateVCLProperty;
end;

procedure TNxCheckBoxItem.SetFalseText(const Value: WideString);
begin
  FFalseText := Value;
  Change(ckValueRepaint);
end;

procedure TNxCheckBoxItem.SetFlatStyle(const Value: Boolean);
begin
  FFlatStyle := Value;
  Change(ckValueRepaint);
end;

procedure TNxCheckBoxItem.SetStyle(const Value: TCheckBoxStyle);
begin
  FStyle := Value;
  Change(ckValueRepaint);
end;

procedure TNxCheckBoxItem.SetTextKind(const Value: TCheckBoxTextKind);
begin
  FTextKind := Value;
  Change(ckValueRepaint);
end;

procedure TNxCheckBoxItem.SetTrueText(const Value: WideString);
begin
  FTrueText := Value;
  Change(ckValueRepaint);
end;

{ TNxColorItem }

constructor TNxColorItem.Create(AOwner: TComponent);
begin
  inherited;
  FColorKind := ckDelphi;
  FUseColorNames := False;
end;

function TNxColorItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxColorItemDisplay;
end;

function TNxColorItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxColorPicker;
end;

procedure TNxColorItem.SetColorKind(const Value: TColorKind);
begin
  FColorKind := Value;
end;

procedure TNxColorItem.BeginEditing;
begin
  TNxColorPicker(Editor).WebColorFormat := ColorKind = ckWeb;
  TNxColorPicker(Editor).PreviewBorder := True;
  with Editor as TNxColorPicker do
  begin
    if FUseColorNames then Options := Options + [coAllowColorNames]
      else Options := Options - [coAllowColorNames];
    SetTextToColor(AsString);
  end;
  inherited;
end;

procedure TNxColorItem.SetUseColorNames(const Value: Boolean);
begin
  FUseColorNames := Value;
end;

{ TNxTrackBarItem }

constructor TNxTrackBarItem.Create(AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle + [tsCaptureMouse];
  FMargin := 6;
  FMax := 100;
  FMin := 0;
  FPosition := 0;
  FShowText := True;
  FTextAfter := '';
end;

function TNxTrackBarItem.GetAsFloat: Double;
begin
  Result := Position;
end;

function TNxTrackBarItem.GetAsInteger: Integer;
begin
  Result := Position;
end;

function TNxTrackBarItem.GetAsString: WideString;
begin
  Result := IntToStr(Position);
end;

procedure TNxTrackBarItem.SetAsFloat(const Value: Double);
begin
  AsInteger := Round(Value);
end;

procedure TNxTrackBarItem.SetAsInteger(const Value: Integer);
var
  Pos: Integer;
begin
  if Value < Min then Pos := Min
  else if Value > Max then Pos := Max
  else Pos := Value;
  if Pos <> FPosition then
  begin
    FPosition := Pos;
    inherited;
  end;
end;

procedure TNxTrackBarItem.SetAsString(const Value: WideString);
begin
  AsInteger := StrToInt(Value);
end;

procedure TNxTrackBarItem.SetMargin(const Value: Integer);
begin
  FMargin := Value;
end;

procedure TNxTrackBarItem.SetMax(const Value: Integer);
begin
  FMax := Value;
  if FPosition < FMax then FPosition := FMax;
end;

procedure TNxTrackBarItem.SetMin(const Value: Integer);
begin
  if (Value >= 0) and (Value < FMax) then FMin := Value;
  if FPosition < FMin then FPosition := FMin;
end;

procedure TNxTrackBarItem.SetPosition(const Value: Integer);
begin
  AsInteger := Value;
  Change(ckValueRepaint);
end;

procedure TNxTrackBarItem.SetShowText(const Value: Boolean);
begin
  FShowText := Value;
  Change(ckValueRepaint);
end;

procedure TNxTrackBarItem.SetTextAfter(const Value: WideString);
begin
  FTextAfter := Value;
  Change(ckValueRepaint);
end;

function TNxTrackBarItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxTrackBarItemDisplay;
end;

{ TAlignmentPropertyItem }

constructor TNxAlignmentItem.Create(AOwner: TComponent);
begin
  inherited;
  Grouped := True;
  AllowAllUp := True;
end;

procedure TNxAlignmentItem.CreateButtons;
begin
  inherited;
  with AddButton('left') do Glyph.LoadFromResourceName(HInstance, 'ALIGNMENTLEFT');
  with AddButton('center') do Glyph.LoadFromResourceName(HInstance, 'ALIGNMENTCENTER');
  with AddButton('right') do Glyph.LoadFromResourceName(HInstance, 'ALIGNMENTRIGHT');
  with AddButton('justify') do Glyph.LoadFromResourceName(HInstance, 'ALIGNMENTJUSTIFY');
end;

{ TNxVertAlignmentItem }

constructor TNxVertAlignmentItem.Create(AOwner: TComponent);
begin
  inherited;
  Grouped := True;
  AllowAllUp := True;
end;

procedure TNxVertAlignmentItem.CreateButtons;
begin
  inherited;
  with AddButton('top') do Glyph.LoadFromResourceName(HInstance, 'ALIGNMENTTOP');
  with AddButton('middle') do Glyph.LoadFromResourceName(HInstance, 'ALIGNMENTMIDDLE');
  with AddButton('bottom') do Glyph.LoadFromResourceName(HInstance, 'ALIGNMENTBOTTOM');
end;

{ TNxFontStyleItem }

constructor TNxFontStyleItem.Create(AOwner: TComponent);
begin
  inherited;
  AllowAllUp := True;
end;

procedure TNxFontStyleItem.CreateButtons;
begin
  inherited;
  with AddButton('bold') do Glyph.LoadFromResourceName(HInstance, 'FONTSTYLEBOLD');
  with AddButton('italic') do Glyph.LoadFromResourceName(HInstance, 'FONTSTYLEITALIC');
  with AddButton('underline') do Glyph.LoadFromResourceName(HInstance, 'FONTSTYLEUNDERLINE');
end;

function TNxFontStyleItem.FontStylesToString(
  const Value: TFontStyles): WideString;
begin
  Result := '';
  if fsBold in Value then Result := Result + 'bold';
  if fsItalic in Value then
  begin
    if Result <> '' then Result := Result + ',';
    Result := Result + 'italic';
  end;
  if fsUnderline in Value then
  begin
    if Result <> '' then Result := Result + ',';
    Result := Result + 'underline';
  end;
end;

function TNxFontStyleItem.StringToFontStyles(
  const Value: WideString): TFontStyles;
var
  stBold, stItalic, stUnderline: WideString;
begin
  Result := [];
  stBold:='bold';
  stItalic:='italic';
  stUnderline:='underline';
  if Pos(stBold, Value) > 0 then Result := Result + [fsBold];
  if Pos(stItalic, Value) > 0 then Result := Result + [fsItalic];
  if Pos(stUnderline, Value) > 0 then Result := Result + [fsUnderline];
end;

{ TNxComboBoxItem }

procedure TNxComboBoxItem.AssignEditing;
begin
  ItemIndex := TNxComboBox(Editor).ItemIndex;
end;

constructor TNxComboBoxItem.Create(AOwner: TComponent);
begin
  inherited;
  FDropDownCount := 8;
  FItemIndex := -1;
  FLines := TStringList.Create;
  FStyle := cbDropDown;
end;

destructor TNxComboBoxItem.Destroy;
begin
  FreeAndNil(FLines);
  inherited;
end;

procedure TNxComboBoxItem.BeginEditing;
begin
  inherited;
  with Editor as TNxComboBox do
  begin
    Items.Assign(FLines);
    case FStyle of
      cbDropDown: Style := dsDropDown;
      cbDropDownList: Style := dsDropDownList;
    end;
    HideFocus := True;
    DisplayMode := FDisplayMode;
    DropDownCount := FDropDownCount;
    Images := FImages;
    
    if FItemIndex > -1 then ItemIndex := FItemIndex;
  end;
end;

function TNxComboBoxItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxComboBox;
end;

function TNxComboBoxItem.GetValueFromIndex(const Index: Integer): string;
begin
  if Index >= 0 then
    Result := Copy(FLines[Index], Length(FLines.Names[Index]) + 1, MaxInt) else
    Result := '';
end;

procedure TNxComboBoxItem.SetDropDownCount(const Value: Integer);
begin
  FDropDownCount := Value;
end;

procedure TNxComboBoxItem.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TNxComboBoxItem.SetItemIndex(const Value: Integer);
begin
  FItemIndex := Value;
  if InRange(Value, 0, Lines.Count - 1) then
  begin
    case FDisplayMode of
      dmDefault: Self.Value := FLines[FItemIndex];
      dmValueList: Self.Value := GetValueFromIndex(FItemIndex);
      dmNameList: Self.Value := FLines.Names[FItemIndex];
      dmIndentList: Self.Value := GetValueFromIndex(FItemIndex);
    end;
  end;
end;

procedure TNxComboBoxItem.SetLines(const Value: TStrings);
begin
  FLines.Assign(Value);
end;

procedure TNxComboBoxItem.SetStyle(const Value: TComboBoxStyle);
begin
  FStyle := Value;
end;

procedure TNxComboBoxItem.DoCloseUp(Sender: TObject);
begin
  FItemIndex := TNxComboBox(Sender).ItemIndex;
  inherited;
end;

procedure TNxComboBoxItem.EndEditing;
begin
  { note: if text is manyaly typed into combobox and doesn't exist in FLines,
          we need to set ItemIndex to -1 otherwise it will be back to previous
          ItemIndex. }
  inherited;
  if (FStyle = cbDropDown) and Assigned(FLines)
    and (FLines.IndexOf(Editor.Text) = -1) then FItemIndex := -1;
end;

function TNxComboBoxItem.GetItemName: string;
begin
  if (Items.Count > 0) and InRange(ItemIndex, 0, Pred(Lines.Count)) then
    Result := Lines.Names[ItemIndex] else Result := '';
end;

function TNxComboBoxItem.GetItemValue: string;
begin
  if (Lines.Count > 0) and InRange(ItemIndex, 0, Pred(Lines.Count)) then
    Result := GetValueFromIndex(ItemIndex) else Result := '';
end;

{ TNxCustomNumberItem }

constructor TNxCustomNumberItem.Create(AOwner: TComponent);
begin
  inherited;
  FEditOptions := [eoAllowFloat, eoAllowSigns];
  FFormatMask := '';
  FMax := 0;
  FMin := 0;
  FItemDataType := idtFloat;
end;

procedure TNxCustomNumberItem.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
  Change(ckValueRepaint);
end;

procedure TNxCustomNumberItem.SetMax(const Value: Double);
begin
  FMax := Value;
end;

procedure TNxCustomNumberItem.SetMin(const Value: Double);
begin
  FMin := Value;
end;

function TNxCustomNumberItem.GetAsFloat: Double;
begin
  Result := FValue;
end;

function TNxCustomNumberItem.GetAsInteger: Integer;
begin
  Result := Round(FValue);
end;

function TNxCustomNumberItem.GetAsString: WideString;
begin
  Result := FormatFloat(FormatMask, FValue);
end;

procedure TNxCustomNumberItem.SetAsFloat(const Value: Double);
begin
  FValue := Value;
  inherited;
end;

procedure TNxCustomNumberItem.SetAsInteger(const Value: Integer);
begin
  FValue := Value;
  inherited;
end;

procedure TNxCustomNumberItem.SetAsString(const Value: WideString);
begin
  if Value = '' then FValue := 0 else
    FValue := GetValidNumber(Value, eoAllowFloat in EditOptions, eoAllowSigns in EditOptions, Min, Max);
  inherited;
end;

{ TNxFontNameItem }

procedure TNxFontNameItem.BeginEditing;
begin
  Lines.Assign(Screen.Fonts);
  inherited;
end;

function TNxFontNameItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxFontNameItemDisplay;
end;

function TNxFontNameItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxFontComboBox;
end;

{ TNxButtonItem }

constructor TNxButtonItem.Create(AOwner: TComponent);
begin
  inherited;
  FButtonWidth := 21;
  FEditOptions := [];
  FGlyph := TBitmap.Create;
  FTransparentColor := clNone;
end;

destructor TNxButtonItem.Destroy;
begin
  FGlyph.Free;
  FGlyph := nil;
  inherited;
end;

procedure TNxButtonItem.BeginEditing;
begin
  with Editor as TNxButtonEdit do
  begin
    ButtonWidth := FButtonWidth;
    Options := FEditOptions;
    ButtonGlyph := FGlyph;
    ButtonGlyph := FGlyph;
    TransparentColor := FTransparentColor;
    OnButtonClick := DoEditorButtonClick;
  end;
  inherited;
end;

function TNxButtonItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxButtonEdit;
end;

procedure TNxButtonItem.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
end;

procedure TNxButtonItem.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
end;

procedure TNxButtonItem.DoEditorButtonClick(Sender: TObject);
begin
  DoButtonClick;
end;

procedure TNxButtonItem.DoButtonClick;
begin
  if Assigned(FOnButtonClick) then FOnButtonClick(Self);
end;

{ TNxDateItem }

procedure TNxDateItem.BeginEditing;
begin
  inherited;
  with Editor as TNxDatePicker do
  begin
    DayNames := Self.DayNames;
    MonthNames :=  Self.MonthNames;
    NoneCaption := Self.NoneCaption;
    ShowNoneButton := Self.ShowNoneButton;
    StartDay := Self.StartDay;
    TodayCaption := Self.TodayCaption;
  end;
end;

constructor TNxDateItem.Create(AOwner: TComponent);
begin
  inherited;
  FDayNames := TStringList.Create;
  FItemDataType := idtDateTime; // GJK
  FMonthNames := TStringList.Create;
  FNoneCaption := 'None';
  FShowNoneButton := True;
  FStartDay := dwSunday;
  FTodayCaption := 'Today';
end;

destructor TNxDateItem.Destroy;
begin
  FreeAndNil(FDayNames);
  FreeAndNil(FMonthNames);
  inherited;
end;

function TNxDateItem.GetAsDateTime: TDateTime;
begin
  try
    Result := StrToDateTime(Value);
  except
    Result := 0;
  end;
end;

function TNxDateItem.GetAsFloat: Double;
var
  d: TDateTime;
begin
  try
    d := StrToDateTime(Value);
    Result := d;
  except
    Result := 0;
  end;
end;

function TNxDateItem.GetAsInteger: Integer;
var
  d: TDateTime;
begin
  try
    d := StrToDateTime(Value);
    Result := Round(d);
  except
    Result := 0;
  end;
end;

function TNxDateItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxDatePicker;
end;

procedure TNxDateItem.SetAsDateTime(const Value: TDateTime);
begin
  try
    AsString := DateToStr(Value);
  except
    AsString := ''; 
  end;
  Changed;
end;

procedure TNxDateItem.SetAsFloat(const Value: Double);
begin
  try
    AsString := DateToStr(Value);
  except
    AsString := '';
  end;
  Changed;
end;

procedure TNxDateItem.SetAsInteger(const Value: Integer);
begin
  try
    AsString := DateToStr(Value);    
  except
    AsString := '';
  end;
  Changed;
end;

procedure TNxDateItem.SetDayNames(const Value: TStrings);
begin
  FDayNames.Assign(Value);
end;

procedure TNxDateItem.SetMonthNames(const Value: TStrings);
begin
  FMonthNames.Assign(Value);
end;

procedure TNxDateItem.SetNoneCaption(const Value: WideString);
begin
  FNoneCaption := Value;
end;

procedure TNxDateItem.SetShowNoneButton(const Value: Boolean);
begin
  FShowNoneButton := Value;
end;

procedure TNxDateItem.SetTodayCaption(const Value: WideString);
begin
  FTodayCaption := Value;
end;

{ TNxImagePathItem }

function TNxImagePathItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxImagePathEdit;
end;

{ TNxToolbarItemButtons }

constructor TNxToolbarItemButtons.Create(AOwner: TNxToolbarItem);
begin
  inherited Create(TNxToolbarItemButton);
  FCheckedCount := 0;
  FOwner := AOwner;
end;

function TNxToolbarItemButtons.Add: TNxToolbarItemButton;
begin                                  
  Result := TNxToolbarItemButton(inherited Add);
end;

function TNxToolbarItemButtons.GetItem(Index: Integer): TNxToolbarItemButton;
begin
  Result := TNxToolbarItemButton(inherited GetItem(Index));
end;                                         

function TNxToolbarItemButtons.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TNxToolbarItemButtons.SetItem(Index: Integer;
  const Value: TNxToolbarItemButton);
begin
  inherited SetItem(Index, Value);
end;

procedure TNxToolbarItemButtons.CheckButton(Button: TNxToolbarItemButton;
  Value: Boolean);
var
  i: Integer;
begin
  if Value = Button.Checked then Exit;
  if Value
    then Inc(FCheckedCount)
      else if (not FOwner.FAllowAllUp) and (FCheckedCount = 1) then Exit else Dec(FCheckedCount);
  Button.FChecked := Value;
  if (FOwner.Grouped) and (Value) then
  begin
    for i := 0 to Count - 1 do if Button <> Items[i] then
      if Items[i].FChecked then
      begin
        Items[i].FChecked := False;
        Dec(FCheckedCount);
        FOwner.Change(ckToolButtonRedraw, i);
      end;
  end;
  FOwner.ButtonClick(Button.Index);
end;

{ TNxRadioItem }

constructor TNxRadioItem.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taCenter;
  FChecked := False;
  FFlatStyle := False;
end;

function TNxRadioItem.GetAsBoolean: Boolean;
begin
  Result := Checked;
end;

function TNxRadioItem.GetAsString: WideString;
begin
  if Checked then Result := 'true' else Result := 'false';
end;

function TNxRadioItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxRadioItemDisplay;
end;

procedure TNxRadioItem.SetAsBoolean(const Value: Boolean);
begin
  Checked := Value;
  inherited;
end;

procedure TNxRadioItem.SetAsString(const Value: WideString);
begin
  Checked := LowerCase(Value) = 'true';
  inherited;
end;

procedure TNxRadioItem.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Changed;
end;

procedure TNxRadioItem.SetChecked(const Value: Boolean);
var
  i: Integer;
begin
  if FChecked = Value then Exit;
  FChecked := Value;
  AsString := BoolToStr(FChecked, True);
  i := ParentItem.AbsoluteIndex + 1;
  while (i < Items.Count) and (Items[i].Level >= Level) do
  begin
    if (Items[i] is TNxRadioItem) and (Items[i] <> Self) then
    begin
      with Items[i] as TNxRadioItem do
      begin
        FChecked := False;
        AsString := BoolToStr(FChecked, True);
        Changed; { refresh item }
      end;
    end;
    Inc(I);
  end;
end;

procedure TNxRadioItem.SetFlatStyle(const Value: Boolean);
begin
  FFlatStyle := Value;
  Change(ckSilentValue);
end;

{ TNxMemoItem }

procedure TNxMemoItem.BeginEditing;
begin
  inherited;
  with Editor as TNxMemoInplaceEdit do
  begin
    ShowButton := Self.ShowButton;
  end;
end;

constructor TNxMemoItem.Create(AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle + [tsWantReturns];
  FLines := TStringList.Create;
  FMultiLineSymbol := True;
  FShowButton := False;
end;

destructor TNxMemoItem.Destroy;
begin
  FLines.Clear;
  FLines.Free;
  inherited;
end;

function TNxMemoItem.GetAsFloat: Double;
begin
  Result := StrToFloat(FLines.Text);
end;

function TNxMemoItem.GetAsInteger: Integer;
begin
  Result := StrToInt(FLines.Text);
end;

function TNxMemoItem.GetAsString: WideString;
begin
  Result := FLines.Text;
end;

function TNxMemoItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxMemoItemDisplay;
end;

function TNxMemoItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxMemoInplaceEdit;
end;               

procedure TNxMemoItem.SetAsFloat(const Value: Double);
begin
  FLines.Text := FloatToStr(Value);
  inherited;
end;

procedure TNxMemoItem.SetAsInteger(const Value: Integer);
begin
  FLines.Text := IntToStr(Value);
  inherited;
end;

procedure TNxMemoItem.SetAsString(const Value: WideString);
begin
  FLines.Text := Value;
  inherited;
end;

procedure TNxMemoItem.SetLines(const Value: TStrings);
begin
  FLines.Assign(Value);
end;

procedure TNxMemoItem.SetMultiLineSymbol(const Value: Boolean);
begin
  FMultiLineSymbol := Value;
  Change(ckValueRepaint);
end;

{ TNxTextItem }

constructor TNxTextItem.Create(AOwner: TComponent);
begin
  inherited;
  FMaxLength := 0;
  FPasswordChar := #0;
  FValue := '';
end;

function TNxTextItem.GetAsFloat: Double;
begin
  try Result := StrToFloat(FValue) except Result := 0 end;
end;

function TNxTextItem.GetAsInteger: Integer;
begin
  try Result := StrToInt(FValue) except Result := 0 end;
end;

function TNxTextItem.GetAsString: WideString;
begin
  Result := FValue;
end;

function TNxTextItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxTextItemDisplay;
end;

procedure TNxTextItem.SetAsFloat(const Value: Double);
begin
  FValue := FloatToStr(Value);
  inherited;
end;

procedure TNxTextItem.SetAsInteger(const Value: Integer);
begin
  FValue := IntToStr(Value);
  inherited;
end;

procedure TNxTextItem.SetAsString(const Value: WideString);
begin
  FValue := Value;
  inherited;
end;

{ TNxPopupItem }

procedure TNxPopupItem.DoCloseUp;
begin
  if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;

procedure TNxPopupItem.DoSelect;
begin
  if Assigned(FOnSelect) then FOnSelect(Self);
end;

procedure TNxPopupItem.PrepareEditing;
begin
  inherited;
  with Editor as TNxPopupEdit do
  begin
    OnCloseUp := DoCloseUp;
    OnSelect := DoSelect;
  end;
end;

{ TNxProgressItem }

constructor TNxProgressItem.Create(AOwner: TComponent);
begin
  inherited;
  FBorderColor := clGrayText;
  FHeight := 0;
  FHideWhenEmpty := False;
  FMargin := 2;
  FMax := 100;
  FPosition := 0;
  FProgressColor := clHighlight;
  FProgressStyle := pbSolid;
  FRoundCorners := False;
  FTransparent := False;  
end;

function TNxProgressItem.GetAsFloat: Double;
begin
  Result := Position;
end;

function TNxProgressItem.GetAsInteger: Integer;
begin
  Result := Position;
end;

function TNxProgressItem.GetAsString: WideString;
begin
  Result := IntToStr(Position);
end;

function TNxProgressItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxProgressItemDisplay;
end;

procedure TNxProgressItem.SetAsFloat(const Value: Double);
begin
  AsInteger := Round(Value);
end;

procedure TNxProgressItem.SetAsInteger(const Value: Integer);
var
  Pos: Integer;
begin
  if Value < 0 then Pos := 0
  else if Value > Max then Pos := Max
  else Pos := Value;
  if Pos <> FPosition then
  begin
    FPosition := Pos;
    inherited;
  end;
end;

procedure TNxProgressItem.SetAsString(const Value: WideString);
begin
  AsInteger := StrToInt(Value);
end;

procedure TNxProgressItem.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetHeight(const Value: Integer);
begin
  FHeight := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetMax(const Value: Integer);
begin
  FMax := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetPosition(const Value: Integer);
begin
  AsInteger := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetProgressColor(const Value: TColor);
begin
  FProgressColor := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetProgressHeight(const Value: Integer);
begin
  FProgressHeight := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetProgressStyle(const Value: TProgressBarStyle);
begin
  FProgressStyle := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetRoundCorners(const Value: Boolean);
begin
  FRoundCorners := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetShowText(const Value: Boolean);
begin
  FShowText := Value;
  Change(ckValueRepaint);
end;

procedure TNxProgressItem.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  Change(ckValueRepaint);
end;

{ TNxSpinItem }

constructor TNxSpinItem.Create(AOwner: TComponent);
begin
  inherited;
  FIncrement := 1;
  FSpinButtons := True;
end;

procedure TNxSpinItem.BeginEditing;
begin
  with Editor as TNxSpinEdit do
  begin
    Increment := Self.Increment;
    Max := Self.Max;
    Min := Self.Min;
    Options := EditOptions;
    SpinButtons := Self.SpinButtons;
  end;
  inherited;
end;

function TNxSpinItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxSpinEdit;
end;

procedure TNxSpinItem.SetIncrement(const Value: Double);
begin
  FIncrement := Value;
end;

procedure TNxSpinItem.SetSpinButtons(const Value: Boolean);
begin
  FSpinButtons := Value;
end;

{ TNxCalcItem }

constructor TNxCalcItem.Create(AOwner: TComponent);
begin
  inherited;
  FAutoClose := False;
end;

procedure TNxCalcItem.BeginEditing;
begin
  with Editor as TNxCalcEdit do
  begin
    AutoClose := Self.AutoClose;
    Max := Self.Max;
    Min := Self.Min;
    FormatMask := Self.FormatMask;
    Options := Self.EditOptions;
  end;
  inherited;
end;

function TNxCalcItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxCalcEdit;
end;

{ TNxFolderItem }

constructor TNxFolderItem.Create(AOwner: TComponent);
begin
  inherited;
  FRoot := '';
  FDialogCaption := 'Browse for Folder';
end;

function TNxFolderItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxFolderEdit;
end;

procedure TNxFolderItem.SetDialogCaption(const Value: WideString);
begin
  FDialogCaption := Value;
end;

{ TNxTimeItem }

constructor TNxTimeItem.Create(AOwner: TComponent);
begin
  inherited;
  FTime := Now;
end;

procedure TNxTimeItem.EndEditing;
var
  ValidTime: TTime;
begin
  inherited;
  if not(csDestroying in ComponentState) then
  begin
    ValidTime := AsDateTime;
    AsString := TimeToStr(ValidTime);
    FTime := ValidTime;
  end;
end;

function TNxTimeItem.GetAsDateTime: TDateTime;
begin
  Result := StrToTimeDef(Value, FTime);
end;

function TNxTimeItem.GetAsFloat: Double;
begin
  Result := StrToTime(Value);
end;

function TNxTimeItem.GetAsInteger: Integer;
begin
  Result := Round(StrToTime(Value));
end;

function TNxTimeItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := TNxTimeEdit;
end;

procedure TNxTimeItem.SetAsDateTime(const Value: TDateTime);
begin
  try
    AsString := TimeToStr(Value);
  except
    AsString := '';
  end;
  Changed;
end;

procedure TNxTimeItem.SetAsFloat(const Value: Double);
begin
  try
    AsString := TimeToStr(Value);
  except
    AsString := '';
  end;
  Changed;
end;

procedure TNxTimeItem.SetAsInteger(const Value: Integer);
begin
  try
    AsString := TimeToStr(Value);
  except
    AsString := '';
  end;
  Changed;
end;

end.

