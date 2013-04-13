{$I NxSuite.inc}

{$DEFINE NEW_EDITORCREATION}


unit NxPropertyItems;

interface

uses
  Classes, Types, Controls, Graphics, ComCtrls, ImgList, Dialogs, TypInfo,
  SysUtils, Forms, NxClasses, NxEdit;

type
  TNxPropertyItem = class;
  TNxPropertyItems = class;
  TNxItemDisplay = class;
  TItemDisplayClass = class of TNxItemDisplay;
  TNxItemClass = class of TNxPropertyItem;
  TAddPosition = (apFirst, apLast);
  TPropertiesStyle = (psDefault, psOffice2003, psOffice2007, psWhidbey);
  TPropertyItemPart = (ipAll, ipButton, ipCaption, ipMargin, ipPlus,
  	ipPreview, ipSplitter, ipSuffix, ipText, ipValue);
  TSubItemDataKind = (sidCount, sidItem, sidSelected);
  TItemOptions = set of (itoAutoApply, itoBoldNonDefault);
  TItemState = set of (isBtnDown1, isBtnDown2, isEditing, isHover, isSelected, isSuffixOpen, VCLRead);
  TChangeKind = (ckAdded, ckButton, ckCaption, ckDeleted, ckCollapse, ckDestroy, ckDisable, ckExpand,
    ckUndefined, ckValueRepaint, ckValueChanged, ckSilentValue,
    ckSuffixChanged, ckValueMember, ckToolButtonClick, ckToolButtonRedraw,
    ckRefresh, ckVisible);
  TItemAttributes = set of (iaButton, iaTextBox, iaToolbar);
  TSuffixStyle = (ssDropDown, ssDropDownList, ssReadOnly);
  TItemsArrange = (taCatagory, taName);
  TItemStyle = set of (tsCaptureMouse, tsWantReturns);
  TItemDataType = (idtBoolean, idtDateTime, idtFloat, idtInteger, idtString, idtLookup);

  TNxPropertyItem = class(TComponent)
  private
    FCaption: WideString;
    FColor: TColor;
    FCount: Integer;
    FDefaultValue: WideString;
    FDisplay: TNxItemDisplay;
    FEditor: TNxCustomEdit;
    FEmptyValue: WideString;
    FEnabled: Boolean;
    FExpanded: Boolean;
    FExpandLock: Boolean;
    FFieldName: WideString;
    FFont: TFont;
    FHelpContext: THelpContext;
    FHidden: Boolean;
    FHint: string;
    FImageIndex: TImageIndex;
    FIsAdded: Boolean;
    FItems: TNxPropertyItems;
    FItemState: TItemState;
    FItemStyle: TItemStyle;
    FLevel: Integer;
    FMapProperty: string;
    FMapXML: WideString;
    FObjectReference: TObject;
    FOptions: TItemOptions;
    FParentIndex: Integer;
    FParentItem: TNxPropertyItem;
    FReadOnly: Boolean;
    FShowHint: Boolean;
    FShowPreview: Boolean;
    FShowSuffix: Boolean;
    FSuffixCombo: TNxComboBox;
    FSuffixes: TStrings;
    FSuffixStyle: TSuffixStyle;
    FSuffixValue: WideString;
    FTagString: WideString;
    FValueFont: TFont;
    FVertDelta: Integer;
    FVisible: Boolean;
    FEmpty: Boolean;
    FTabStop: Boolean;
    FItemHeight: Integer;
    function GetAbsoluteIndex: Integer;
    function GetChildCount: Integer;
    function GetFontStored: Boolean;
    function GetFullText: WideString;
    function GetHasChildren: Boolean;
    function GetIndent: Integer;
    function GetIndex: Integer;
    function GetIsFirstItem: Boolean;
    function GetItem(Index: Integer): TNxPropertyItem;
    function GetItemByName(ItemName: string): TNxPropertyItem;
    function GetItemCount: Integer;
    function GetNodeIndex: Integer;
    function GetSortedIndex: Integer;
    function GetTop: Integer;
    function GetValueFontStored: Boolean;
    procedure SetCaption(const Value: WideString);
    procedure SetColor(const Value: TColor);
    procedure SetDefaultValue(const Value: WideString);
    procedure SetEmptyValue(const Value: WideString);
    procedure SetEnabled(const Value: Boolean);
    procedure SetExpanded(const Value: Boolean);
    procedure SetExpandLock(const Value: Boolean);
    procedure SetFieldName(const Value: WideString);
    procedure SetFont(const Value: TFont);
    procedure SetHelpContext(const Value: THelpContext);
    procedure SetHint(const Value: string);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetItemState(const Value: TItemState);
    procedure SetMapProperty(const Value: string);
    procedure SetMapXML(const Value: WideString);
    procedure SetObjectReference(const Value: TObject);
    procedure SetOptions(const Value: TItemOptions);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetShowPreview(const Value: Boolean);
    procedure SetShowSuffix(const Value: Boolean);
    procedure SetSuffixes(const Value: TStrings);
    procedure SetSuffixStyle(const Value: TSuffixStyle);
    procedure SetSuffixValue(const Value: WideString);
    procedure SetTagString(const Value: WideString);
    procedure SetValueFont(const Value: TFont);
    procedure SetVisible(const Value: Boolean);
    procedure SetEmpty(const Value: Boolean);
    procedure SetItemHeight(const Value: Integer);
  protected
    FItemDataType: TItemDataType;
    procedure CreateInplaceEditor; virtual;
    procedure DestroyInplaceEditor; virtual;
    function GetAsBoolean: Boolean; virtual;
    function GetAsDateTime: TDateTime; virtual;
    function GetAsFloat: Double; virtual;
    function GetAsInteger: Integer; virtual;
    function GetAsString: WideString; virtual;
    function GetDisplayText: WideString; virtual;
    function GetItemDisplayClass: TItemDisplayClass; virtual;
    function GetItemEditorClass: TCellEditorClass; virtual;
    function GetValue: WideString; virtual;
    function PreviewAvailable: Boolean; virtual;
    procedure Change(Kind: TChangeKind; Parameter: Integer = -1);
    procedure Changed;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoFontChange(Sender: TObject);
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure MapVCLProperty;
    procedure ReadParentIndex(Reader: TReader);
    procedure ResolveProperty(var AObject: TObject; var APropertyName: string);
    procedure SetAsBoolean(const Value: Boolean); virtual;
    procedure SetAsDateTime(const Value: TDateTime); virtual;
    procedure SetAsFloat(const Value: Double); virtual;
    procedure SetAsInteger(const Value: Integer); virtual;
    procedure SetAsString(const Value: WideString); virtual;
    procedure SetParentComponent(Value: TComponent); override;
    procedure SetValue(const Value: WideString); virtual;
    procedure UpdateVCLProperty;
    procedure WriteParentIndex(Writer: TWriter);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddChild(ItemClass: TNxItemClass; S: string = ''): TNxPropertyItem;
    function GetFirstSibling: TNxPropertyItem;
    function GetLastSibling: TNxPropertyItem;
    function GetNext: TNxPropertyItem;
    function GetNextSibling: TNxPropertyItem;
    function GetParentComponent: TComponent; override;
    function GetParentControl: TCustomControl;
		function GetPartRect(ItemPart: TPropertyItemPart): TRect;
    function GetPrev: TNxPropertyItem;
    function GetPrevSibling: TNxPropertyItem;
    function HasAsParent(Value: TNxPropertyItem): Boolean;
    function HasParent: Boolean; override;
    function IsDisplayed: Boolean;
    function IsEditable: Boolean; virtual;
    function IsTopLevel: Boolean;
    procedure Assign(Source: TPersistent); override;
    procedure AssignEditing; virtual;
    procedure BeginEditing; virtual;
    procedure BeginSuffixEditing; virtual;
    procedure Clear;
    procedure Collapse(Recurse: Boolean);
    procedure Delete;
    procedure DeleteChildren;
    procedure EndEditing; virtual;
    procedure Expand(Recurse: Boolean);
    procedure HideSuffix; virtual;
    procedure MoveTo(Destination: TNxPropertyItem; Mode: TNodeAttachMode); overload;
    procedure PrepareEditing; virtual;
    procedure Resync;
    procedure SetTopLevel;
    procedure Uncover;
    procedure UpdateEditor; virtual;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsString: WideString read GetAsString write SetAsString;
    property ChildCount: Integer read GetChildCount;
    property Count: Integer read FCount;
    property DataType: TItemDataType read FItemDataType;
    property Display: TNxItemDisplay read FDisplay;
    property DisplayText: WideString read GetDisplayText;
    property Editor: TNxCustomEdit read FEditor;
    property FieldName: WideString read FFieldName write SetFieldName;
    property HasChildren: Boolean read GetHasChildren;
    property Hidden: Boolean read FHidden;
    property Indent: Integer read GetIndent;
    property Index: Integer read GetIndex;
    property IsFirstItem: Boolean read GetIsFirstItem;
    property Item[Index: Integer]: TNxPropertyItem read GetItem;
    property ItemByName[ItemName: string]: TNxPropertyItem read GetItemByName;
    property ItemCount: Integer read GetItemCount;
    property Items: TNxPropertyItems read FItems;
    property ItemState: TItemState read FItemState write SetItemState;
    property ItemStyle: TItemStyle read FItemStyle write FItemStyle;
    property ObjectReference: TObject read FObjectReference write SetObjectReference;
    property ParentItem: TNxPropertyItem read FParentItem;
    property SuffixCombo: TNxComboBox read FSuffixCombo;
    property Top: Integer read GetTop;
  published
    property AbsoluteIndex: Integer read GetAbsoluteIndex;
    property Caption: WideString read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clWindow;
    property DefaultValue: WideString read FDefaultValue write SetDefaultValue;
    property EmptyValue: WideString read FEmptyValue write SetEmptyValue;
    property Empty: Boolean read FEmpty write SetEmpty default False;
		property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Expanded: Boolean read FExpanded write SetExpanded default True;
    property ExpandLock: Boolean read FExpandLock write SetExpandLock default False;
    property Font: TFont read FFont write SetFont stored GetFontStored;
    property FullText: WideString read GetFullText;
    property HelpContext: THelpContext read FHelpContext write SetHelpContext default 0;
    property Hint: string read FHint write SetHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 0;
    property Level: Integer read FLevel;
    property MapProperty: string read FMapProperty write SetMapProperty;
    property MapXML: WideString read FMapXML write SetMapXML;
    property NodeIndex: Integer read GetNodeIndex;
    property Options: TItemOptions read FOptions write SetOptions default [];
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property ShowHint: Boolean read FShowHint write FShowHint default False;
    property ShowPreview: Boolean read FShowPreview write SetShowPreview default False;
    property ShowSuffix: Boolean read FShowSuffix write SetShowSuffix default False;
    property SortedIndex: Integer read GetSortedIndex;
    property Suffixes: TStrings read FSuffixes write SetSuffixes;
    property SuffixStyle: TSuffixStyle read FSuffixStyle write SetSuffixStyle default ssDropDown;
    property SuffixValue: WideString read FSuffixValue write SetSuffixValue;
    property TabStop: Boolean read FTabStop write FTabStop default True;
    property TagString: WideString read FTagString write SetTagString;
    property Value: WideString read GetValue write SetValue;
    property ValueFont: TFont read FValueFont write SetValueFont stored GetValueFontStored;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TItemChangeEvent = procedure (Sender: TObject; AItem: TNxPropertyItem;
  	ChangeKind: TChangeKind; Parameter: Integer) of object;

  TNxPropertyItems = class(TComponent)
  private
    FItemsList: TList;
    FList: TList;
    FOwner: TComponent;
    FSortedList: TList;
    FOnChange: TNotifyEvent;
    FOnItemChange: TItemChangeEvent;
    function GetCount: Integer;
    function GetItem(Index: Integer): TNxPropertyItem;
    function GetItemByName(Name: string): TNxPropertyItem;
    function GetNode(Index: Integer): TNxPropertyItem;
    function GetNodesCount: Integer;
    function GetSortedItem(Index: Integer): TNxPropertyItem;
    procedure ClearChilds(Item: TNxPropertyItem);
    procedure MoveItem(List: TList; Destination, Item: TNxPropertyItem;
      CurIndex, NewIndex: Integer; Sibling: Boolean);
    procedure PutItem(Item: TNxPropertyItem);
    procedure SetChildsExpanded(Item: TNxPropertyItem; const Value: Boolean);
    procedure SetExpanded(Item: TNxPropertyItem; const Value: Boolean);
    procedure SetItem(Index: Integer; const Value: TNxPropertyItem);
    procedure SetParent(Item, Parent: TNxPropertyItem);
    function GetTopLevelCount: Integer;
  protected
    function GetChildCount(List: TList; Item: TNxPropertyItem): Integer;
    procedure DoChange; dynamic;
    procedure DoItemChange(Sender: TObject; AItem: TNxPropertyItem;
	  	ChangeKind: TChangeKind; Parameter: Integer); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddChild(Item: TNxPropertyItem; ItemClass: TNxItemClass; S: string = ''): TNxPropertyItem;
    function AddChildFirst(Item: TNxPropertyItem; ItemClass: TNxItemClass; S: string = ''): TNxPropertyItem;
    function IndexOf(Item: TNxPropertyItem): Integer;
    function Insert(Item: TNxPropertyItem; ItemClass: TNxItemClass; const S: WideString): TNxPropertyItem;
    procedure AddItem(Parent, Item: TNxPropertyItem; Position: TAddPosition = apLast);
		procedure Clear;
    procedure ClearValues;
    procedure Delete(Index: Integer);
    procedure Remove(Item: TNxPropertyItem);
    procedure SetItemsArrange(const Value: TItemsArrange);
    procedure ShowItems(Item: TNxPropertyItem; const Value: Boolean);

    property Count: Integer read GetCount;
    property Item[Index: Integer]: TNxPropertyItem read GetItem write SetItem; default;
    property ItemByName[ItemName: string]: TNxPropertyItem read GetItemByName;
    property Node[Index: Integer]: TNxPropertyItem read GetNode;
    property NodesCount: Integer read GetNodesCount;
    property SortedItem[Index: Integer]: TNxPropertyItem read GetSortedItem;
    property TopLevelCount: Integer read GetTopLevelCount;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnItemChange: TItemChangeEvent read FOnItemChange write FOnItemChange;
  end;

  TDisplayAttributes = set of (daStyleCategories, daVisualStyles);

  TNxItemDisplay = class
  private
    FAttributes: TDisplayAttributes;
    FBiDiMode: TBiDiMode;
    FBufferBitmap: TBitmap;
    FCanvas: TCanvas;
    FCategoriesColor: TColor;
    FClientRect: TRect;
    FGridCilor: TColor;
    FHighlightTextColor: TColor;
    FImages: TImageList;
    FItem: TNxPropertyItem;
    FItemPart: TPropertyItemPart;
    FMarginColor: TColor;
    FSelected: Boolean;
    FSelectionColor: TColor;
    FStyle: TPropertiesStyle;
    FInBounds: Boolean;
    function GetCanvas: TCanvas;
  protected
    procedure AdjustTextRect(var R: TRect; var Flags: Integer; Text: WideString;
      VerticalAlignment: TVerticalAlignment);
    procedure DrawText(const Value: WideString; Rect: TRect); virtual;
    procedure PaintBackground; virtual;
    procedure PaintPreview(PreviewRect: TRect); virtual;
    procedure PrepareDrawText(const Value: WideString; var Rect: TRect;
      var Flags: Integer; Modify: Boolean);
    property Attributes: TDisplayAttributes read FAttributes;
  public
    procedure BeginUpdate;
    procedure Changed; virtual;
    constructor Create(AItem: TNxPropertyItem); virtual;
    destructor Destroy; override;
    procedure EndUpdate;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseLeave; virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure PaintCaption; virtual;
    procedure PaintExpandButton; virtual;
    procedure PaintSuffix; virtual;
    procedure PaintValue; virtual;
    procedure SetDisplayAttributes(ASelectionColor, AHighlightTextColor, ACategoriesColor, AMarginColor, AGridColor: TColor;
      Attributes: TDisplayAttributes);
    property BiDiMode: TBiDiMode read FBiDiMode write FBiDiMode;
    property Canvas: TCanvas read GetCanvas write FCanvas;
    property ClientRect: TRect read FClientRect write FClientRect;
    property Images: TImageList read FImages write FImages;
    property InBounds: Boolean read FInBounds write FInBounds;
    property Item: TNxPropertyItem read FItem write FItem;
    property ItemPart: TPropertyItemPart read FItemPart write FItemPart;
    property Selected: Boolean read FSelected write FSelected;
    property Style: TPropertiesStyle read FStyle write FStyle;
  end;

implementation

uses
  NxInspector, Windows, NxInspectorCommon, NxPropertyItemClasses, NxSharedCommon,
  Math, NxThemesSupport, NxSharedDraw, ComObj;

{ TNxPropertyItem }

constructor TNxPropertyItem.Create(AOwner: TComponent);
begin
  inherited;
  FCaption := '';
  FColor := clWindow;
  FDefaultValue := '';
  FDisplay := GetItemDisplayClass.Create(Self);
  FEditor := nil;
  FEmpty := False;
  FEnabled := True;
  FExpanded := True;
  FExpandLock := False;
  FFont := TFont.Create;
  FFont.OnChange := DoFontChange;
  FImageIndex := -1;
  FIsAdded := False;
  FItemDataType := idtString;
  FItems := nil;
  FItemStyle := [];
  FLevel := 0;
  FObjectReference := nil;
  FOptions := [];
  FReadOnly := False;
  FItemHeight := 0;
  FShowHint := False;
  FShowPreview := False;
  FShowSuffix := False;
  FSuffixCombo := nil;
  FSuffixes := TStringList.Create;
  FSuffixStyle := ssDropDown;
  FTabStop := True;
  FValueFont := TFont.Create;
  FValueFont.OnChange := DoFontChange;
  FVertDelta := 0;
  FVisible := True;
{$IFNDEF NEW_EDITORCREATION}
  CreateInplaceEditor;
{$ENDIF}
end;

procedure TNxPropertyItem.CreateInplaceEditor;
begin
  if GetItemEditorClass <> nil then
  begin
    FEditor := GetItemEditorClass.Create(Self);
    FEditor.Hide;
    FEditor.AutoSize := False;
  end;
  FSuffixCombo := TNxComboBox.Create(Self);
  FSuffixCombo.Hide;
end;

procedure TNxPropertyItem.DestroyInplaceEditor;
begin
  FreeAndNil(FSuffixCombo);
  FreeAndNil(FEditor);
end;

destructor TNxPropertyItem.Destroy;
begin
  { note: item call Destroy when Owner (Form) is
          destroyed. }
  if FItems <> nil then
  begin
    FItems.ClearChilds(Self);
    FItems.Remove(Self);
    Change(ckDestroy);
  end;
  FreeAndNil(FDisplay);
  FreeAndNil(FFont);
  FreeAndNil(FSuffixes);
  FreeAndNil(FValueFont);
  DestroyInplaceEditor;
  inherited;
end;

procedure TNxPropertyItem.Assign(Source: TPersistent);
begin
  if Source is TNxPropertyItem then
  begin
    Caption := TNxPropertyItem(Source).Caption;
    EmptyValue := TNxPropertyItem(Source).EmptyValue;
    Enabled := TNxPropertyItem(Source).Enabled;
    Expanded := TNxPropertyItem(Source).Expanded;
    Font.Assign(TNxPropertyItem(Source).Font);
    ImageIndex := TNxPropertyItem(Source).ImageIndex;
    ReadOnly := TNxPropertyItem(Source).ReadOnly;
    Suffixes.Assign(TNxPropertyItem(Source).Suffixes);
    SuffixValue := TNxPropertyItem(Source).SuffixValue;
    Value := TNxPropertyItem(Source).Value;
    ValueFont.Assign(TNxPropertyItem(Source).ValueFont);
  end
  else inherited Assign(Source);
end;

procedure TNxPropertyItem.AssignEditing;
begin

end;

procedure TNxPropertyItem.Clear;
begin
  FItems.ClearChilds(Self);
end;

procedure TNxPropertyItem.Collapse(Recurse: Boolean);
begin
  if Recurse then FItems.SetChildsExpanded(Self, False);
  Expanded := False;
end;

procedure TNxPropertyItem.Delete;
begin
  FItems.Delete(AbsoluteIndex);
end;

procedure TNxPropertyItem.DeleteChildren;
begin
  FItems.ClearChilds(Self);
end;

function TNxPropertyItem.GetAbsoluteIndex: Integer;
begin
  Result := FItems.FItemsList.IndexOf(Self);
end;

function TNxPropertyItem.GetChildCount: Integer;
begin
  Result := FItems.GetChildCount(FItems.FItemsList, Self);
end;

function TNxPropertyItem.GetFontStored: Boolean;
begin
  with FItems.Owner as TNxCustomInspector do
    Result := (Self.Font.Charset <> Font.Charset)
      or (Self.Font.Color <> Font.Color)
      or (Self.Font.Height <> Font.Height)
      or (Self.Font.Name <> Font.Name)
      or (Self.Font.Pitch <> Font.Pitch)
      or (Self.Font.Size <> Font.Size)
      or (Self.Font.Style <> Font.Style);
end;

function TNxPropertyItem.GetFullText: WideString;
begin
  Result := Value + SuffixValue;
end;

function TNxPropertyItem.GetHasChildren: Boolean;
begin
  Result := FCount > 0;
end;

function TNxPropertyItem.GetIndent: Integer;
begin
  if Level < 2 then Result := 0 else Result := (Level - 1) * spaMargin;
end;

function TNxPropertyItem.GetIndex: Integer;
begin
  Result := FItems.IndexOf(Self);
end;

function TNxPropertyItem.GetIsFirstItem: Boolean;
begin
  Result := AbsoluteIndex = 0;
end;

function TNxPropertyItem.GetItem(Index: Integer): TNxPropertyItem;
var
  I, C, AbsIndex: Integer;
begin
  Result := nil;
  if not InRange(Index, 0, FCount - 1) then
    raise Exception.Create('Index out of bounds');
  AbsIndex := AbsoluteIndex;
  C := 0;
  for I := AbsIndex + 1 to FItems.Count - 1 do
    if FItems[I].Level = FLevel + 1 then
    begin
      if C = Index then begin
        Result := FItems[I];
        Exit;
      end;
      Inc(C);
    end;
end;

function TNxPropertyItem.GetItemByName(
  ItemName: string): TNxPropertyItem;
begin
  Result := FItems.GetItemByName(ItemName);
end;

function TNxPropertyItem.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TNxPropertyItem.GetTop: Integer;
var
  i, y, Step, grid, AFirstItem, rh: Integer;
  HideCategories: Boolean;
begin
  Result := -1;
  with FItems.Owner as TNextInspector do
  begin
  	if poGrid in Options then grid := 1 else grid := 0;
    rh := RowHeight;
		AFirstItem := FirstItem;
    HideCategories := HideTopLevel;
  end;
  y := 0;
  for i := AFirstItem to FItems.NodesCount - 1 do
  begin
    if FItems.Node[i].Hidden or (not FItems.Node[i].Visible)
      or (HideCategories and FItems.Node[i].IsTopLevel) then Continue;
    if FItems.Node[i] = Self then
    begin
      Result := Y;
      Exit;
    end;
    if FItems.Node[i].FItemHeight = 0
      then Step := rh
      else Step := FItems.Node[i].FItemHeight;
    Inc(y, Step + grid);
  end;
end;

function TNxPropertyItem.GetSortedIndex: Integer;
begin
  Result := FItems.FSortedList.IndexOf(Self); 
end;

function TNxPropertyItem.GetValueFontStored: Boolean;
begin
  with FItems.Owner as TNxCustomInspector do
    Result := (ValueFont.Charset <> Font.Charset)
      or (ValueFont.Color <> Font.Color)
      or (ValueFont.Height <> Font.Height)
      or (ValueFont.Name <> Font.Name)
      or (ValueFont.Pitch <> Font.Pitch)
      or (ValueFont.Size <> Font.Size)
      or (ValueFont.Style <> Font.Style);
end;

procedure TNxPropertyItem.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  if FLevel = 1 then FItems.PutItem(Self);
  Change(ckCaption);
end;

procedure TNxPropertyItem.SetEmptyValue(const Value: WideString);
begin
  FEmptyValue := Value;
  if Value = '' then Change(ckValueRepaint);
end;

procedure TNxPropertyItem.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  Change(ckDisable);
end;

procedure TNxPropertyItem.SetFieldName(const Value: WideString);
begin
  FFieldName := Value;
end;

procedure TNxPropertyItem.SetExpanded(const Value: Boolean);
begin
  if (FExpandLock) or (Value = FExpanded) then Exit;
  FExpanded := Value;
  FItems.SetExpanded(Self, FExpanded);
  if Count > 0 then
  begin
    if FExpanded then Change(ckExpand)
      else Change(ckCollapse);
  end;
end;

procedure TNxPropertyItem.SetExpandLock(const Value: Boolean);
begin
  FExpandLock := Value;
  Change(ckButton);
end;

procedure TNxPropertyItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Change(ckCaption);
end;

procedure TNxPropertyItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Change(ckCaption);
end;

procedure TNxPropertyItem.SetItemState(const Value: TItemState);
begin
  FItemState := Value;
end;

procedure TNxPropertyItem.SetMapProperty(const Value: string);
begin
  FMapProperty := Value;
  Resync;
end;

procedure TNxPropertyItem.SetMapXML(const Value: WideString);
begin
  FMapXML := Value;
end;

procedure TNxPropertyItem.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  Change(ckValueRepaint);
end;

procedure TNxPropertyItem.SetSuffixValue(const Value: WideString);
begin
  FSuffixValue := Value;
  Change(ckSuffixChanged);
end;

procedure TNxPropertyItem.SetValueFont(const Value: TFont);
begin
  FValueFont.Assign(Value);
  Change(ckValueRepaint);
end;

procedure TNxPropertyItem.SetVisible(const Value: Boolean);
begin
  if Value <> FVisible then
  begin
    FVisible := Value;
    FHidden := not FVisible;
    if Expanded then FItems.ShowItems(Self, Value);
    Change(ckVisible);
  end;
end;

function TNxPropertyItem.GetValue: WideString;
begin
  Result := AsString;
end;

procedure TNxPropertyItem.MapVCLProperty;
var
	AParentControl: TWinControl;
	PropInfo: PPropInfo;
  AObject: TObject;
  AProperty: string;
begin
  AParentControl := TWinControl(FItems.Owner);
  if Assigned(AParentControl) then
		with FItems.Owner as TNextInspector do
	    if (FMapProperty <> '') and Assigned(Associate) then
	    begin
        if Assigned(ObjectReference) then AObject := ObjectReference
          else AObject := Associate;

        AProperty := MapProperty;
        ResolveProperty(AObject, AProperty); { retreive real property for complex maps }
      	PropInfo := GetPropInfo(AObject, AProperty);
       	if Assigned(PropInfo) then
        begin
          Include(FItemState, VCLRead);
					case PropInfo^.PropType^.Kind of
            tkString, tkLString{$IFDEF DELPHI2009}, tkUString{$ENDIF}: AsString := GetStrProp(AObject, AProperty);
            tkInteger:
            begin
              if Self is TNxColorItem then AsString := ColorToString(GetOrdProp(AObject, AProperty))
                else AsInteger := GetOrdProp(AObject, AProperty);
            end;
            tkFloat: AsFloat := GetFloatProp(AObject, AProperty);
            tkWString: AsString := GetWideStrProp(AObject, AProperty);
            tkEnumeration:
            begin
              if Self is TNxCheckBoxItem then AsBoolean := GetEnumProp(AObject, AProperty) = DefaultTrueBoolStr
                else AsString := GetEnumProp(AObject, AProperty);
            end;
            tkSet: AsString := GetSetProp(AObject, AProperty);
          end;
          Exclude(FItemState, VCLRead);
        end;
	      if Self.Caption = '' then Self.Caption := AProperty;
	    end;
end;

procedure TNxPropertyItem.UpdateVCLProperty;
var
	AParentControl: TWinControl;
	PropInfo: PPropInfo;
  AObject: TObject;
  AProperty: string;
begin
  if FItems = nil then Exit;
  if VCLRead in ItemState then Exit;
  AParentControl := TWinControl(FItems.Owner);
  if Assigned(AParentControl) then
		with FItems.Owner as TNextInspector do
	    if (FMapProperty <> '') and (Assigned(Associate)) then
	    begin
        if Assigned(ObjectReference) then AObject := ObjectReference
          else AObject := Associate;
          
        AProperty := MapProperty;
        ResolveProperty(AObject, AProperty);
      	PropInfo := GetPropInfo(AObject, AProperty);
       	if Assigned(PropInfo) then
					case PropInfo^.PropType^.Kind of
            tkString, tkLString{$IFDEF DELPHI2009},tkUString{$ENDIF}: SetStrProp(AObject, AProperty, AsString);
            tkInteger:
            begin
              if Self is TNxColorItem then
              begin
                if AsString = '' then SetOrdProp(AObject, AProperty, clNone)
                  else SetOrdProp(AObject, AProperty, StringToColor(AsString))
              end else SetOrdProp(AObject, AProperty, AsInteger);
            end;
            tkFloat: SetFloatProp(AObject, AProperty, AsFloat);
            tkWString: SetWideStrProp(AObject, AProperty, AsString);
            tkEnumeration:
            begin
              if Self is TNxCheckBoxItem then SetEnumProp(AObject, AProperty, BoolToStr(AsBoolean, True))
                else SetEnumProp(AObject, AProperty, AsString);
            end;
            tkSet: SetSetProp(AObject, AProperty, AsString);
          end;
	    end;
end;

procedure TNxPropertyItem.SetValue(const Value: WideString);
begin
  AsString := Value;
end;

function TNxPropertyItem.GetAsBoolean: Boolean;
begin
  Result := False;
end;

function TNxPropertyItem.GetAsDateTime: TDateTime;
begin
  Result := 0;
end;

function TNxPropertyItem.GetAsFloat: Double;
begin
  Result := 0;
end;

function TNxPropertyItem.GetAsInteger: Integer;
begin
  Result := 0;
end;

function TNxPropertyItem.GetAsString: WideString;
begin
  Result := '';
end;

function TNxPropertyItem.GetDisplayText: WideString;
begin
  Result := Value;
end;

function TNxPropertyItem.GetItemDisplayClass: TItemDisplayClass;
begin
  Result := TNxItemDisplay;
end;

procedure TNxPropertyItem.SetAsBoolean(const Value: Boolean);
begin
  Changed;
end;
                   
procedure TNxPropertyItem.SetAsDateTime(const Value: TDateTime);
begin
  Changed;
end;

procedure TNxPropertyItem.SetAsFloat(const Value: Double);
begin
  Changed;
end;

procedure TNxPropertyItem.SetAsInteger(const Value: Integer);
begin
  Changed;
end;

procedure TNxPropertyItem.SetAsString(const Value: WideString);
begin
  Changed;
end;

procedure TNxPropertyItem.SetParentComponent(Value: TComponent);
var
  AParentItem: TNxPropertyItem;
begin
  if Value is TNxCustomInspector then
  begin
    (Value as TNxCustomInspector).Items.AddItem(nil, TNxPropertyItem(Self));
  end else
  begin
    AParentItem := TNxPropertyItem(Value);
    AParentItem.FItems.AddItem(Value as TNxPropertyItem, TNxPropertyItem(Self));
  end;
end;

function TNxPropertyItem.AddChild(
  ItemClass: TNxItemClass; S: string = ''): TNxPropertyItem;
begin
  Result := FItems.AddChild(Self, ItemClass, S);
end;

function TNxPropertyItem.GetFirstSibling: TNxPropertyItem;
var
  I: Integer;
begin
  { desc: Returns the first node at the same level as
          the calling node. }
  Result := Self;
  I := AbsoluteIndex;
  while (I > 0) and (FItems[I].FLevel >= FLevel) do
  begin
    if FItems[I].FLevel = FLevel then Result := FItems[I];
    Dec(I);
  end;
end;

function TNxPropertyItem.GetLastSibling: TNxPropertyItem;
var
  I: Integer;
begin
  { desc: Returns the last node at the same level as
          the calling node. }
  Result := Self;
  I := AbsoluteIndex + 1;
  while (I < FItems.Count) and (FItems[I].FLevel >= FLevel) do
  begin
    if FItems[I].FLevel = FLevel then Result := FItems[I];
    Inc(I);
  end;
end;

function TNxPropertyItem.GetNext: TNxPropertyItem;
begin
  Result := nil;
  if AbsoluteIndex + 1 < FItems.Count
    then Result := FItems[AbsoluteIndex + 1];
end;

function TNxPropertyItem.GetNextSibling: TNxPropertyItem;
var
  i: Integer;
begin
  Result := nil;
  for i := AbsoluteIndex + 1 to FItems.Count - 1 do
    if FItems[i].FLevel = FLevel then
    begin
      Result := FItems[i];
      Break;
    end;
end;

function TNxPropertyItem.GetParentComponent: TComponent;
begin
  if FParentItem = nil then Result := FItems.Owner
    else Result := FParentItem;
end;

function TNxPropertyItem.GetParentControl: TCustomControl;
begin
  Result := FItems.Owner as TCustomControl;
end;

procedure TNxPropertyItem.SetSuffixes(const Value: TStrings);
begin
  FSuffixes.Assign(Value);
end;

function TNxPropertyItem.GetPartRect(
  ItemPart: TPropertyItemPart): TRect;
var
	sp, rh, cw, pl, er, bl: Integer;
  HavePreview, HaveSuffix: Boolean;
begin
  HavePreview := False;
  HaveSuffix := False;
  with FItems.Owner as TNextInspector do
  begin
  	sp := SplitterPosition;
    if FItemHeight = 0 then rh := RowHeight else rh := FItemHeight;
  	cw := ClientWidth;
  end;
  bl := cw;
  { Left Edit Edge }
  pl := sp + 1; { Preview Left }
  er := bl;
  if Self is TNxTextItem then
    with Self as TNxTextItem do
    begin
      HavePreview := ShowPreview;
      HaveSuffix := ShowSuffix;
    end;
  { Right Edit Edge }
  if HavePreview then pl := pl + sizClientPreview + 3;
  if HaveSuffix then er := er - TNextInspector(FItems.Owner).SuffixWidth;
  { Result }
  Result := Rect(0, 0, 0, 0);
  case ItemPart of
  	ipAll: Result := Rect(0, Top, cw, Top + rh);
    ipCaption:
     {	if Self.Level = 0
	    	then }Result := Rect(spaMargin, Top, cw, Top + rh);
				 {	else Result := Rect(Indent + spaMargin, Top, sp, Top + rh); }
    ipMargin: Result := Rect(0, Top, Indent + spaMargin, Top + rh);
    ipPreview: if HavePreview then Result := Rect(sp + 1, Top, pl, Top + rh);
    ipSplitter: Result := Rect(sp, Top, sp + 1, Top + rh);
		ipSuffix: if HaveSuffix then Result := Rect(er, Top, bl, Top + rh);
    ipText: if Self is TNxTextItem then Result := Rect(pl, Top, er, Top + rh);
    ipValue: if Self.Level > 0 then Result := Rect(sp + 1, Top, cw, Top + rh);
  end;
end;

function TNxPropertyItem.GetPrev: TNxPropertyItem;
begin
  if not IsFirstItem then Result := FItems[AbsoluteIndex - 1]
    else Result := nil;
end;

function TNxPropertyItem.GetPrevSibling: TNxPropertyItem;
var
  i: Integer;         
begin
  Result := nil;
  for i := Pred(AbsoluteIndex) downto 0 do
    if FItems[i].FLevel = FLevel then
    begin
      Result := FItems[i];
      Break;
    end;
end;

function TNxPropertyItem.HasAsParent(Value: TNxPropertyItem): Boolean;
var
  I: Integer;
begin
  I := Value.AbsoluteIndex + 1;
  while (I < FItems.Count - 1)
    and (FItems[I].Level > Value.Level) do
  begin
    if FItems[I] = Self then
    begin
      Result := True;
      Exit;
    end;
    Inc(I);
  end;
  Result := False;
end;

function TNxPropertyItem.HasParent: Boolean;
begin
  Result := True;
end;

procedure TNxPropertyItem.Change(Kind: TChangeKind; Parameter: Integer);
begin
  { notify parent items }
  if FIsAdded and (not(csReading in ComponentState)) and Assigned(FItems)
    and (FItems.Owner <> nil) then FItems.DoItemChange(Self, Self, Kind, Parameter);
end;

procedure TNxPropertyItem.Changed;
begin
  if FItems = nil then Exit;
  Change(ckValueChanged);
  UpdateVCLProperty;
end;

procedure TNxPropertyItem.DoFontChange(Sender: TObject);
begin
  Change(ckCaption);
end;

procedure TNxPropertyItem.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
var
  I: Integer;
begin
	{ this will save child items as childrens into dfm }
  for I := AbsoluteIndex + 1 to FItems.Count - 1 do
    if FItems[I].FParentItem = Self then Proc(FItems[I]);
end;

function TNxPropertyItem.IsDisplayed: Boolean;
begin
  if ParentItem = nil then Result := True else
    Result := (ParentItem.Expanded) and (ParentItem.IsDisplayed);
end;

procedure TNxPropertyItem.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('ParentIndex', ReadParentIndex, WriteParentIndex, True);
end;

procedure TNxPropertyItem.ResolveProperty(var AObject: TObject;
  var APropertyName: string);
var
  APos: integer;
  AClass: TClass;
  AObjName: string;
begin
  if (Assigned(AObject)) and (APropertyName <> '') then
  begin
    APos := Pos('.', APropertyName);
    if APos = 0 then Exit;
    AObjName := Copy(APropertyName, 1, APos - 1);
    System.Delete(APropertyName, 1, APos);
    AClass := GetObjectPropClass(AObject, AObjName);
    AObject := GetObjectProp(AObject, AObjName, AClass);
    ResolveProperty(AObject, APropertyName);
  end;
end;

procedure TNxPropertyItem.WriteParentIndex(Writer: TWriter);
begin
  if ParentItem = nil then Writer.WriteInteger(-1)
    else Writer.WriteInteger(ParentItem.AbsoluteIndex);
end;

procedure TNxPropertyItem.ReadParentIndex(Reader: TReader);
begin
  FParentIndex := Reader.ReadInteger;
end;

procedure TNxPropertyItem.Resync;
begin
  MapVCLProperty;
end;

procedure TNxPropertyItem.SetTopLevel;
begin
  MoveTo(FItems[0], naAdd);
end;

procedure TNxPropertyItem.SetColor(const Value: TColor);
begin
  FColor := Value;
  Change(ckCaption);
  Change(ckValueRepaint);
end;

procedure TNxPropertyItem.SetDefaultValue(const Value: WideString);
begin
  FDefaultValue := Value;
  Change(ckValueRepaint);
end;

procedure TNxPropertyItem.SetShowPreview(const Value: Boolean);
begin
  FShowPreview := Value;
  Change(ckValueRepaint);
end;

function TNxPropertyItem.GetItemEditorClass: TCellEditorClass;
begin
  Result := nil;
end;

procedure TNxPropertyItem.BeginEditing;
begin
  FEditor.InplaceEditor := True;
  FEditor.BorderStyle := bsNone;
  FEditor.PreviewBorder := True;
  FEditor.Color := Color;
  FEditor.Font.Assign(ValueFont);
  FEditor.SelectAll;
end;

procedure TNxPropertyItem.BeginSuffixEditing;
begin
  FSuffixCombo.BorderStyle := bsNone;
  FSuffixCombo.Color := Color;
  FSuffixCombo.Font.Assign(ValueFont);
  FSuffixCombo.Items.Assign(Suffixes);
  FSuffixCombo.BorderWidth := 1;
  FSuffixCombo.EditMargins.Left := 1;
end;

procedure TNxPropertyItem.EndEditing;
begin                
{$IFDEF NEW_EDITORCREATION}
  if FEditor <> nil then
  begin
    if not(csDestroying in ComponentState) then
      ShowWindow(FEditor.Handle, SW_HIDE);
    DestroyInplaceEditor;
  end;
{$ELSE}
  if not(csDestroying in ComponentState) then
    ShowWindow(FEditor.Handle, SW_HIDE);
{$ENDIF}
end;

procedure TNxPropertyItem.Expand(Recurse: Boolean);
begin
  if Recurse then FItems.SetChildsExpanded(Self, True);
  Expanded := True;
end;

procedure TNxPropertyItem.HideSuffix;
begin                     
  if not(csDestroying in ComponentState)
    and Assigned(FSuffixCombo) then ShowWindow(FSuffixCombo.Handle, SW_HIDE);
end;

procedure TNxPropertyItem.MoveTo(Destination: TNxPropertyItem;
  Mode: TNodeAttachMode);
var
  NewIndex: Integer;
  Sibling: Boolean;
  AParent: TNxPropertyItem;
begin
  NewIndex := -1;
  Sibling := False;
  AParent := nil;
  case Mode of
    naAdd:
    begin
      AParent := Destination.GetLastSibling;
      NewIndex := AParent.AbsoluteIndex + AParent.GetChildCount + 1;
      Sibling := True;
    end;
    naAddFirst:
    begin
      AParent := Destination.GetFirstSibling;
      NewIndex := AParent.AbsoluteIndex;
      Sibling := True;
    end;
    naInsert:
    begin
      AParent := FItems[Destination.AbsoluteIndex];
      NewIndex := AParent.AbsoluteIndex;
      Sibling := True;
    end;
    naAddChild:
    begin
      AParent := Destination;
      NewIndex := Destination.AbsoluteIndex + Destination.ChildCount + 1;
    end;
    naAddChildFirst:
    begin
      AParent := Destination;
      NewIndex := Destination.AbsoluteIndex + 1;
    end;
  end;
  if NewIndex <> -1 then { Move Item }
  begin
    FItems.MoveItem(FItems.FItemsList, AParent, Self, AbsoluteIndex, NewIndex, Sibling);
  end;
  { ParentItem, Level & Count }
  case Mode of
    naAdd, naAddFirst:
    begin
      if Assigned(FParentItem) then Dec(FParentItem.FCount);
      if Assigned(AParent.ParentItem) then Inc(AParent.ParentItem.FCount);
      FParentItem := Destination.ParentItem;
    end;
    naInsert:
    begin
      FParentItem := Destination.FParentItem;
    end;
    naAddChild, naAddChildFirst:
    begin
      if Assigned(FParentItem) then Dec(FParentItem.FCount);
      FParentItem := AParent;
      Inc(Destination.FCount);
    end;
  end;
  Change(ckExpand);
end;

procedure TNxPropertyItem.PrepareEditing;
begin
{$IFDEF NEW_EDITORCREATION}
  if FEditor = nil then CreateInplaceEditor;
{$ENDIF}
end;

function TNxPropertyItem.IsEditable: Boolean;
begin
  Result := False;
end;

function TNxPropertyItem.IsTopLevel: Boolean;
begin
  Result := FLevel = 0;
end;

function TNxPropertyItem.GetNodeIndex: Integer;
begin
  Result := FItems.FList.IndexOf(Self);
end;

function TNxPropertyItem.PreviewAvailable: Boolean;
begin
  Result := False;
end;

procedure TNxPropertyItem.SetObjectReference(const Value: TObject);
begin
  FObjectReference := Value;
  Change(ckValueRepaint);
end;

procedure TNxPropertyItem.SetOptions(const Value: TItemOptions);
begin
  FOptions := Value;
  Change(ckUndefined);
end;

procedure TNxPropertyItem.SetTagString(const Value: WideString);
begin
  FTagString := Value;
end;

procedure TNxPropertyItem.SetShowSuffix(const Value: Boolean);
begin
  if Value <> FShowSuffix then
  begin
    FShowSuffix := Value;
    Change(ckValueRepaint);
  end;
end;

procedure TNxPropertyItem.SetSuffixStyle(const Value: TSuffixStyle);
begin
  FSuffixStyle := Value;
end;

procedure TNxPropertyItem.SetHelpContext(const Value: THelpContext);
begin
  FHelpContext := Value;
end;

procedure TNxPropertyItem.SetHint(const Value: string);
begin
  FHint := Value;
end;

procedure TNxPropertyItem.UpdateEditor;
begin

end;

procedure TNxPropertyItem.SetEmpty(const Value: Boolean);
begin
  FEmpty := Value;
  Changed;
end;
                         
procedure TNxPropertyItem.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
  Change(ckVisible);
end;

procedure TNxPropertyItem.Uncover;
  procedure UncoverParent(Item: TNxPropertyItem);
  begin
    Item.Expand(False);
    if Item.ParentItem <> nil then UncoverParent(Item.ParentItem);
  end;
begin
  if ParentItem <> nil then UncoverParent(ParentItem);
end;

{ TNxPropertyItems }

constructor TNxPropertyItems.Create(AOwner: TComponent);
begin
  inherited;
  FOwner := AOwner;
  FItemsList := TList.Create;
  FList := FItemsList;
  FSortedList := TList.Create;
end;

destructor TNxPropertyItems.Destroy;
begin
  Clear;
  FreeAndNil(FItemsList);
  FreeAndNil(FSortedList);
  inherited;
end;

procedure TNxPropertyItems.ClearChilds(Item: TNxPropertyItem);
var
  i, SortedIndex: Integer;
  AItem: TNxPropertyItem;
begin
  i := FItemsList.IndexOf(Item) + 1;
  while (I < FItemsList.Count)
    and (Self.Item[i].FLevel > Item.FLevel) do
  begin
    AItem := Self.Item[i];
    SortedIndex := FSortedList.IndexOf(AItem);
    AItem.FItems := nil;
    AItem.Free;
    FItemsList.Delete(i);
    if SortedIndex <> -1 then FSortedList.Delete(SortedIndex);
  end;
  Item.FCount := 0;
end;

procedure TNxPropertyItems.MoveItem(List: TList; Destination,
  Item: TNxPropertyItem; CurIndex, NewIndex: Integer; Sibling: Boolean);
var
  I, C, D: Integer;
  ALevel: Integer;
begin
  C := GetChildCount(List, Item);
  if Assigned(Destination) then ALevel := Destination.FLevel else ALevel := 0;
  D := ALevel - Item.FLevel;  
  if not Sibling then Inc(D);
  
  if NewIndex > CurIndex then
  begin
    for I := 0 to C do
    begin
      Inc(Self.Item[CurIndex].FLevel, D);
      List.Move(CurIndex, NewIndex - 1);
    end;
  end else
  begin
    for I := 0 to C do
    begin
      Inc(Self.Item[CurIndex + C].FLevel, D);
      List.Move(CurIndex + C, NewIndex);
    end;
  end;
end;

procedure TNxPropertyItems.PutItem(Item: TNxPropertyItem);
var
  I, Pc, P, C: Integer;
  S: string;
  Target: TNxPropertyItem;
begin
  Pc := FSortedList.IndexOf(Item);
  if (Pc = -1) or (Item.Level > 1) then Exit;
  S := Item.Caption;

  I := 0;
  P := 0;
  while I < FSortedList.Count do
  begin
    Target := TNxPropertyItem(FSortedList[I]);
    if (Target.Level = 1) and (S < Target.FCaption) then Break;
    if Item <> FSortedList[I] then Inc(P);
    Inc(I);
  end;

  if P <> Pc then { item will be moved }
  begin
    { we need to move all child items }
    C := GetChildCount(FSortedList, Item);
    if Pc < P then
    begin
      for i := 0 to C do FSortedList.Move(Pc, P);
    end else
    begin
      for i := 0 to C do FSortedList.Move(Pc + C, P);
    end;
  end;
end;

procedure TNxPropertyItems.SetChildsExpanded(Item: TNxPropertyItem;
  const Value: Boolean);
var
  i: Integer;
begin
  for i := Item.AbsoluteIndex + 1 to Count - 1 do
  begin
    if Self.Item[i].Level = Item.Level then Exit;
    Self.Item[i].Expanded := Value;
  end;
end;

procedure TNxPropertyItems.SetExpanded(Item: TNxPropertyItem;
  const Value: Boolean);
var
  i: Integer;
begin
  i := FItemsList.IndexOf(Item) + 1;
  while (i < FItemsList.Count)
    and (Self.Item[i].FLevel > Item.FLevel) do
  begin
    if Value then
    begin
      if Self.Item[i].Visible then Self.Item[i].FHidden := False;
      if not Self.Item[i].Expanded then
        Inc(i, GetChildCount(FList, Self.Item[i]));
    end else Self.Item[i].FHidden := True;
    Inc(i);
  end;
end;

procedure TNxPropertyItems.SetParent(Item, Parent: TNxPropertyItem);
begin
  Item.FParentItem := Parent;
  Item.FLevel := Parent.FLevel + 1;
  Item.FIsAdded := True;
  Item.FHidden := Parent.Hidden or not(Parent.Expanded);
  Inc(Parent.FCount);
end;

function TNxPropertyItems.GetCount: Integer;
begin
  Result := FItemsList.Count;
end;

function TNxPropertyItems.GetItem(Index: Integer): TNxPropertyItem;
begin
  Result := FItemsList[Index];
end;

function TNxPropertyItems.GetItemByName(Name: string): TNxPropertyItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if CompareText(Item[i].Name, Name) = 0 then
    begin
      Result := Item[i];
      Exit;
    end;
end;

function TNxPropertyItems.GetNode(Index: Integer): TNxPropertyItem;
begin
  Result := TNxPropertyItem(FList[Index]);
end;

function TNxPropertyItems.GetNodesCount: Integer;
begin
  Result := FList.Count;
end;

function TNxPropertyItems.GetSortedItem(Index: Integer): TNxPropertyItem;
begin
  Result := TNxPropertyItem(FSortedList[Index]);
end;

procedure TNxPropertyItems.SetItem(Index: Integer; const Value: TNxPropertyItem);
begin
  FItemsList[Index] := Value;
end;

function TNxPropertyItems.GetChildCount(List: TList; Item: TNxPropertyItem): Integer;
var
  i: Integer;
begin
  Result := 0;
  i := List.IndexOf(Item) + 1;
  while (i < List.Count)
    and (TNxPropertyItem(List[i]).FLevel > Item.FLevel) do
  begin
    Inc(Result);
    Inc(i);
  end;
end;

procedure TNxPropertyItems.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxPropertyItems.DoItemChange(Sender: TObject;
  AItem: TNxPropertyItem;	ChangeKind: TChangeKind; Parameter: Integer);
begin
  if csReading in AItem.ComponentState then Exit;
  if Assigned(FOnItemChange) then FOnItemChange(Self, AItem, ChangeKind, Parameter);
end;

procedure TNxPropertyItems.Clear;
var
	i: Integer;
begin
	for i := Count - 1 downto 0 do
    Item[i].Free;
  { note: no need to clear lists }
  DoChange;
end;

procedure TNxPropertyItems.Delete(Index: Integer);
begin
  { note: parent count will be set
          inside remowe proc. }
  Item[Index].Free;
end;

procedure TNxPropertyItems.Remove(Item: TNxPropertyItem);
var
  Index, SortedIndex: Integer;
begin
  Index := FItemsList.IndexOf(Item);
  if Index <> -1 then FItemsList.Delete(Index);
  { don't forget sorted list }
  SortedIndex := FSortedList.IndexOf(Item);
  if SortedIndex <> -1 then FSortedList.Delete(SortedIndex);
  Item.Change(ckDeleted);
  { decrease child count of parent }
  if Item.ParentItem <> nil then Dec(Item.ParentItem.FCount);
  DoChange;
end;

function TNxPropertyItems.AddChild(Item: TNxPropertyItem;
  ItemClass: TNxItemClass; S: string = ''): TNxPropertyItem;
begin
  try
    Result := ItemClass.Create(FOwner.Owner); { TNextInspector's Owner }
    Result.FCaption := S;
    if Item = nil then Result.ReadOnly := True;
    AddItem(Item, Result);
  except
    Result := nil;
  end;            
end;

function TNxPropertyItems.AddChildFirst(Item: TNxPropertyItem;
  ItemClass: TNxItemClass; S: string = ''): TNxPropertyItem;
begin
  try
    Result := ItemClass.Create(Item);
    Result.FCaption := S;
    if Item = nil then Result.ReadOnly := True;
    AddItem(Item, Result, apFirst);
  except
    Result := nil;
  end;
end;

function TNxPropertyItems.IndexOf(Item: TNxPropertyItem): Integer;
var
  i, ParentIndex, Level: Integer;
begin
  Result := 0;
  if Assigned(Item.ParentItem) then
  begin
    ParentIndex := Item.ParentItem.AbsoluteIndex;
    Level := Item.ParentItem.Level + 1;
  end else
  begin
    ParentIndex := 0;
    Level := 0;
  end;
  for i := ParentIndex to GetCount - 1 do
  begin
    if Self.Item[i].FLevel = Level then
    begin
      if Self.Item[i] = Item then Exit;
      Inc(Result);
    end;
  end;
end;

function TNxPropertyItems.Insert(Item: TNxPropertyItem;
  ItemClass: TNxItemClass; const S: WideString): TNxPropertyItem;
begin
  if Item = nil then Exit;
  try
    Result := ItemClass.Create(FOwner.Owner);
    Result.FItems := Self;
    SetParent(Result, Item.ParentItem);

    FItemsList.Insert(Item.AbsoluteIndex, Result); { non-sorted }
    FSortedList.Add(Result);
    PutItem(Result); { sorted }

    Result.Caption := S;
    Result.Change(ckAdded);
  except
    FreeAndNil(Result);
  end;
end;

procedure TNxPropertyItems.AddItem(Parent, Item: TNxPropertyItem;
  Position: TAddPosition);
var
  Pos: Integer;
begin
  Item.FItems := Self;
  if Parent <> nil then
  begin
    SetParent(Item, Parent);
    case Position of { Non-sorted }
      apFirst: Pos := FItemsList.IndexOf(Parent) + 1;
      else Pos := FItemsList.IndexOf(Parent) + GetChildCount(FItemsList, Parent) + 1;
    end;
    FItemsList.Insert(Pos, Item);
    case Position of { Sorted }
      apFirst: Pos := FSortedList.IndexOf(Parent) + 1;
      else Pos := FSortedList.IndexOf(Parent) + GetChildCount(FSortedList, Parent) + 1;
    end;
    FSortedList.Insert(Pos, Item);
    if Parent.FCount = 1 then Parent.Change(ckCaption);
  end else
  begin
    { TopLevel Items }
    Item.FLevel := 0;
    Item.FIsAdded := True;
    case Position of
      apFirst: FItemsList.Insert(0, Item);
      else FItemsList.Add(Item);
    end;
  end;
  Item.Font.Assign(TNxCustomInspector(FOwner).Font);
  Item.ValueFont.Assign(Item.Font);
  if not Item.Hidden then Item.Change(ckAdded);
end;

procedure TNxPropertyItems.SetItemsArrange(const Value: TItemsArrange);
begin
  case Value of
    taCatagory: FList := FItemsList;
    taName: FList := FSortedList;
  end;
end;

procedure TNxPropertyItems.ShowItems(Item: TNxPropertyItem;
  const Value: Boolean);
var
  i: Integer;
begin
  i := FItemsList.IndexOf(Item) + 1;
  while (i < FItemsList.Count)
    and (Self.Node[i].Level > Item.Level) do
  begin
    Self.Node[i].FHidden := not Value;
    Inc(i);
  end;
end;

procedure TNxPropertyItems.ClearValues;
var
  i: Integer;
begin
  for i := 0 to Pred(FItemsList.Count) do
    Item[i].Value := '';
end;

function TNxPropertyItems.GetTopLevelCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do if Item[i].Level = 0 then Inc(Result);
end;

{ TNxItemDisplay }

procedure TNxItemDisplay.AdjustTextRect(var R: TRect; var Flags: Integer;
  Text: WideString; VerticalAlignment: TVerticalAlignment);
var
  CR: TRect;
  StringText: string;
begin
  Flags := Flags or DT_TOP;
  CR := R;
  StringText := Text;
  if IsUnicodeSupported then
    DrawTextExW(Canvas.Handle, PWideChar(Text), -1, CR, Flags or DT_CALCRECT, nil)
      {$IFDEF DELPHI2009}
      else Windows.DrawTextEx(Canvas.Handle, PWideChar(Text), -1, CR, Flags or DT_CALCRECT, nil);
      {$ELSE}
      else Windows.DrawTextEx(Canvas.Handle, PAnsiChar(StringText), -1, CR, Flags or DT_CALCRECT, nil);
      {$ENDIF}
  case VerticalAlignment of
    taAlignTop: Flags := Flags or DT_TOP;
    taVerticalCenter: R.top := R.top + Round((R.bottom - CR.bottom ) / 2);
    taAlignBottom: R.top := R.Bottom - (CR.bottom - CR.top);
  end;
end;

constructor TNxItemDisplay.Create(AItem: TNxPropertyItem);
begin
  FBufferBitmap := Graphics.TBitmap.Create;
  FInBounds := False;
  FItem := AItem;
  FSelected := False;
end;

destructor TNxItemDisplay.Destroy;
begin
  FBufferBitmap.Free;
  inherited;
end;

function TNxItemDisplay.GetCanvas: TCanvas;
begin
  Result := FCanvas;//FBufferBitmap.Canvas;
end;

procedure TNxItemDisplay.BeginUpdate;
begin
  FBufferBitmap.Height := ClientRect.Bottom - ClientRect.Top;
  FBufferBitmap.Width := ClientRect.Right - ClientRect.Left;
end;

procedure TNxItemDisplay.Changed;
begin

end;

procedure TNxItemDisplay.DrawText(const Value: WideString;
  Rect: TRect);
var
  Flags: Integer;
  StringText: string;
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    PrepareDrawText(Value, Rect, Flags, True);
    case IsUnicodeSupported of
      True:   DrawTextExW(Canvas.Handle, PWideChar(Value), Length(Value), Rect, Flags, nil);
      False:  begin
                StringText := Value;
                {$IFDEF DELPHI2009}
                DrawTextEx(Canvas.Handle, PWideChar(StringText), Length(StringText), Rect, Flags, nil);
                {$ELSE}
                DrawTextEx(Canvas.Handle, PAnsiChar(StringText), Length(StringText), Rect, Flags, nil);
                {$ENDIF}
              end;
    end;
    Brush.Style := bsSolid;
  end;
end;

procedure TNxItemDisplay.EndUpdate;
begin

end;

procedure TNxItemDisplay.KeyDown(var Key: Word; Shift: TShiftState);
begin

end;

procedure TNxItemDisplay.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin

end;

procedure TNxItemDisplay.MouseLeave;
begin

end;

procedure TNxItemDisplay.MouseMove(Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TNxItemDisplay.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin

end;

procedure TNxItemDisplay.PaintBackground;
begin
  if Item.Level > 0 then
    with Canvas do
    begin
      Brush.Color := Item.Color;
      FillRect(ClientRect);
    end;       
end;

procedure TNxItemDisplay.PaintCaption;
var
  IsTop: Boolean;
  FocusRect, CaptionRect: TRect;
  CaptionLeft, ImageLeft, ImageTop: Integer;
  FromColor, ToColor: TColor;
begin
  IsTop := Item.Level = 0;
  with Canvas do
  begin
    Font.Assign(Item.Font);
    { Style Draw }
    case Style of
      psDefault:
      begin
        if IsTop then
        begin
          if (daVisualStyles in Attributes) and (daStyleCategories in Attributes) then
          begin
            ThemeRect(Item.GetParentControl.Handle, Canvas.Handle, ClientRect, teRebar, 0, 1);
          end else
          begin
            Brush.Color := FCategoriesColor;
            FillRect(ClientRect);
          end;
          if Selected then
          begin
            FocusRect := Rect(Item.Indent + spaMargin, ClientRect.Top, Item.Indent + spaMargin + TextWidth(Item.Caption) + 4, ClientRect.Bottom);
            if (Item.ImageIndex > -1) and (Assigned(Images)) then FocusRect.Right := FocusRect.Right + Images.Width + spaImageToText;
            TGraphicsProvider.DrawFocused(Canvas, FocusRect);
          end;
        end else
        begin
          if Selected then
          begin
            Brush.Color := FSelectionColor;
            Font.Color := FHighlightTextColor;
          end else
          begin
            Brush.Color := Item.Color;
            Font.Color := Item.Font.Color;
          end;
          FillRect(ClientRect);
        end; { not Top }
      end;
      
      psOffice2003:
      begin
        if IsTop then
        begin
          if Selected then
          begin
            FromColor := GetColor(ceTaskPaneHeadFromColor);
            ToColor := GetColor(ceTaskPaneHeadToColor);
          end else
          begin
            FromColor := GetColor(ceToolbarFromColor);
            ToColor := GetColor(ceToolbarToColor);
          end;
          TGraphicsProvider.DrawGradient(Canvas, ClientRect, FromColor, ToColor);
        end else
        begin
          if not Selected then
          begin
            Brush.Color := Item.Color;
            FillRect(ClientRect);
          end else
          begin
            Pen.Color := GetSysColor(COLOR_HOTLIGHT);
            Brush.Color := GetColor(ceMenuHighlight);
            Rectangle(ClientRect);
          end;
        end;
      end;

      psOffice2007:
      begin
        if IsTop then
        begin
          if Selected then
          begin
            FromColor := SchemeColor(seMenuSelectionBorder, ColorScheme);
            ToColor := SchemeColor(seMenuHighlight, ColorScheme);
          end else
          begin
            FromColor := SchemeColor(seBtnFaceDark, ColorScheme);
            ToColor := SchemeColor(seBtnFace, ColorScheme);
          end;
          DrawVertGlass(Canvas, ClientRect, FromColor, ToColor, (ClientRect.Bottom - ClientRect.Top) div 2);
        end else
        begin
          if not Selected then
          begin
            Brush.Color := Item.Color;
            FillRect(ClientRect);
          end else
          begin
            Pen.Color := SchemeColor(seMenuSelectionBorder, ColorScheme);
            Brush.Color := SchemeColor(seMenuHighlight, ColorScheme);
            Rectangle(ClientRect);
          end;
        end;
      end;

      psWhidbey:
      begin
        if IsTop then
        begin
          TGraphicsProvider.DrawGradient(Canvas, ClientRect, clWindow, clBtnFace);
          if Selected then
          begin
            FocusRect := Rect(Item.Indent + spaMargin, ClientRect.Top, Item.Indent + spaMargin + TextWidth(Item.Caption) + 4, ClientRect.Bottom);
            if (Item.ImageIndex > -1) and (Assigned(Images)) then FocusRect.Right := FocusRect.Right + Images.Width + spaImageToText;
            Brush.Color := clBlack;
            FrameRect(FocusRect);
          end;
        end else
        begin
          if not Selected then
          begin
            Brush.Color := Item.Color;
            FillRect(ClientRect);
          end else
          begin
            Pen.Color := clHighlight;
            Brush.Color := BlendColor(clHighlight, clWindow, 80);
            Rectangle(ClientRect);
          end;
        end;
      end;
    end; { case }

    if not Item.Enabled then Font.Color := clGrayText;
  end;

  if (Item.ImageIndex > -1) and (Assigned(Images)) then
  begin
    ImageLeft := ClientRect.Left + spaImageStart + Item.Indent;
    ImageTop := ClientRect.Top + ((ClientRect.Bottom - ClientRect.Top) div 2 - Images.Height div 2);
    Images.Draw(Canvas, ImageLeft, ImageTop, Item.ImageIndex);
    CaptionLeft := Item.Indent + spaMargin + spaImageStart + Images.Width + spaImageToText
  end else
  begin
    CaptionLeft := Item.Indent + spaMargin + spaTextStart;
  end;

  CaptionRect := Rect(CaptionLeft, ClientRect.Top, ClientRect.Right, ClientRect.Bottom);
  {$IFDEF NX_DEBUG}
  TGraphicsProvider.DrawTextRect(Canvas, CaptionRect, taLeftJustify, IntToStr(Item.AbsoluteIndex) + ' ' + Item.Caption);
  {$ELSE}
  TGraphicsProvider.DrawTextRect(Canvas, CaptionRect, taLeftJustify, Item.Caption);
  {$ENDIF}
end;

procedure TNxItemDisplay.PaintPreview(PreviewRect: TRect);
begin

end;

procedure TNxItemDisplay.PaintValue;
var
  BorderRect, PreviewRect: TRect;
begin
  with Canvas do
  begin
    PaintBackground;
    if Item.ShowPreview and Item.PreviewAvailable then
    begin
      BorderRect := ClientRect;
      Brush.Color := clGray;
      BorderRect.Left := BorderRect.Left + 1;
      BorderRect.Top := BorderRect.Top + 1;
      BorderRect.Bottom := BorderRect.Bottom - 1;
      BorderRect.Right := BorderRect.Left + sizPreview;
      FrameRect(BorderRect);
      PreviewRect := BorderRect;
      InflateRect(PreviewRect, -1, -1);
      PaintPreview(PreviewRect);
    end;
  end;
end;

procedure TNxItemDisplay.PrepareDrawText(const Value: WideString;
  var Rect: TRect; var Flags: Integer; Modify: Boolean);
begin
  Flags := DT_NOPREFIX; { don't replace & char }
  with Item as TNxCustomTextItem, Canvas do
  begin
    if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
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
    case WrapKind of
      wkEllipsis: if Modify then Flags := Flags or DT_END_ELLIPSIS;
      wkPathEllipsis: if Modify then Flags := Flags or DT_PATH_ELLIPSIS;
      wkWordWrap: Flags := Flags or DT_WORDBREAK;
    end;
    if WrapKind <> wkWordWrap then Flags := Flags or DT_SINGLELINE else
    begin
      { MultiLine text need to be manualy aligned verticaly }
      if VerticalAlignment <> taAlignTop then
        AdjustTextRect(Rect, Flags, Value, VerticalAlignment);
    end;
  end;
end;

procedure TNxItemDisplay.SetDisplayAttributes(ASelectionColor, AHighlightTextColor,
  ACategoriesColor, AMarginColor, AGridColor: TColor; Attributes: TDisplayAttributes);
begin
  FAttributes := Attributes;
  FCategoriesColor := ACategoriesColor;
  FSelectionColor := ASelectionColor;
  FHighlightTextColor := AHighlightTextColor;
  FMarginColor := AMarginColor;
  FGridCilor := AGridColor;
end;

procedure TNxItemDisplay.PaintExpandButton;
var
  ThemeItem, X, Y: Integer;
  BtnRect: TRect;
  Btn: Graphics.TBitmap;
  Inspector: TNxCustomInspector;
begin
  with ClientRect do
  begin
    Inspector := TNxCustomInspector(Item.FItems.Owner);
    case Inspector.ButtonsStyle of
      btCustom:
      begin
        if Item.Expanded then Btn := Inspector.CollapseGlyph else Btn := Inspector.ExpandGlyph;
        X := spaMargin div 2 - btn.Width div 2;
        Y := Top + (Bottom - Top) div 2 - btn.Height div 2;
        TDrawProvider.ApplyBitmap(Canvas, X, Y, Btn)
      end;
      btAuto:
      begin
        X := Item.Indent + spaMarginToPlusBtn;
        Y := (Top - 1) + (((Bottom - Top) div 2) - (sizPlusBtnHeight div 2));
        BtnRect := Rect(X, Y, X + 9, Y + 9);
        case Style of
          psDefault:
          begin
            if Item.Expanded then ThemeItem := tiExpanded else ThemeItem := tiCollapsed;
            if daVisualStyles in Attributes
              then ThemeRect(Item.GetParentControl.Handle, Canvas.Handle, BtnRect, teTreeView, tcExpandingButton, ThemeItem)
              else DrawExpandingButton(Canvas, Point(X, Y), Item.Expanded, Item.Level = 0, FMarginColor);
          end;
          psOffice2003, psWhidbey, psOffice2007:
          begin
            Btn := Graphics.TBitmap.Create;
            if Item.Expanded then Btn.LoadFromResourceName(HInstance, 'OFFICE2003COLLAPSE')
              else Btn.LoadFromResourceName(HInstance, 'OFFICE2003EXPAND');
            TDrawProvider.ApplyBitmap(Canvas, BtnRect.Left, BtnRect.Top, Btn);
            Btn.Free;
          end;
        end;
      end;
    end;
  end;
end;

procedure TNxItemDisplay.PaintSuffix;
var
  TxtRect: TRect;
begin
  with Canvas do
  begin
    Font.Assign(Item.ValueFont);
    Brush.Color := Item.Color;
    FillRect(Self.ClientRect);
    Pen.Color := FGridCilor;
    MoveTo(ClientRect.Left, ClipRect.Top);
    LineTo(ClientRect.Left, ClipRect.Bottom);
    TxtRect := ClientRect;
    TxtRect.Left := TxtRect.Left + 3;
    TGraphicsProvider.DrawTextRect(Canvas, TxtRect, taLeftJustify, Item.SuffixValue, BiDiMode);
  end;
end;

end.
