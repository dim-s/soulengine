{$I 'NxSuite.inc'}
{$R NxInspectorRes.res}
{$R NxOffice2K7.res}

unit NxInspector;

interface

uses
  Classes, Types, Controls, Windows, Graphics, Messages, SysUtils, Forms, ExtCtrls, TypInfo,
  NxPropertyItemDisplay, NxInspectorCommon, NxPropertyItems, NxScrollControl;

type
  TNxCustomInspector = class;
  TButtonsStyle = (btAuto, btCustom);
  TInspectorAppearanceOptions = set of (iaLockedButtons, iaHideSelection, iaStyleCategories, iaStyleColors);
  TInspectorPropertyOptions = set of (poGrid, poEnterSelectNext,
    poImages, poSplitterMoving, poUniformSelect);
  TItemArea = (iaAll, iaCaption, iaButton, iaValue);
  TPropertiesState = set of (pvsSplitterMove);
  TItemNotifyEvent = procedure (Sender: TObject; Item: TNxPropertyItem) of object;
  TChangeEvent = procedure (Sender: TObject; Item: TNxPropertyItem; Value: WideString) of object;
  TCustomDrawItemEvent = procedure (Sender: TObject; Item: TNxPropertyItem; ValueRect: TRect) of object;
  TCustomDrawPreviewEvent = procedure (Sender: TObject; ARect: TRect) of object;
  TEditEvent = procedure (Sender: TObject; Item: TNxPropertyItem; Value: WideString; var Accept: Boolean) of object;
  TToolbarClickEvent = procedure (Sender: TObject; Item: TNxPropertyItem; ButtonIndex: Integer) of object;
  TUnselectItemEvent = procedure (Sender: TObject; Item: TNxPropertyItem) of object;

  TNxCustomInspector = class(TNxScrollControl)
  private
    FAppearanceOptions: TInspectorAppearanceOptions;
    FAssociate: TPersistent;
    FBorderStyle: TBorderStyle;
    FButtonsStyle: TButtonsStyle;
    FCapturedItem: TNxPropertyItem;
    FCategoriesColor: TColor;
    FCollapseGlyph: TBitmap;
    FDownItem: TNxPropertyItem;
    FEditingItem: TNxPropertyItem;
    FEnableVisualStyles: Boolean;
    FEscapePressed: Boolean;
    FExpandGlyph: TBitmap;
    FFirstItem: Integer;
    FGridColor: TColor;
    FHideTopLevel: Boolean;
    FHighlightTextColor: TColor;
    FHintHideTimer: TTimer;
    FHintItem: TNxPropertyItem;
    FHintTimer: TTimer;
    FHintWindow: THintWindow;
    FHoverItem: TNxPropertyItem;
    FImages: TImageList;
    FIsMouseDown: Boolean;
    FItems: TNxPropertyItems;
    FItemsArrange: TItemsArrange;
    FMarginColor: TColor;
    FOldHeight: Integer;
    FOldWidth: Integer;
    FOnChange: TChangeEvent;
    FOnCustomDrawItem: TCustomDrawItemEvent;
    FOnCustomDrawPreview: TCustomDrawPreviewEvent;
    FOnEdit: TEditEvent;
    FOnEditDblClick: TNotifyEvent;
    FOnExecute: TItemNotifyEvent;
    FOnExpand: TItemNotifyEvent;
    FOnSelectItem: TItemNotifyEvent;
    FOnSuffixEdit: TChangeEvent;
    FOnToolbarClick: TToolbarClickEvent;
    FOnUnselectItem: TUnselectItemEvent;
    FOptions: TInspectorPropertyOptions;
    FPropertiesState: TPropertiesState;
    FRowHeight: Integer;
    FSelectedItem: TNxPropertyItem;
    FSelectionColor: TColor;
    FSplitterPosition: Integer;
    FStyle: TPropertiesStyle;
    FSuffixEditingItem: TNxPropertyItem;
    FSuffixWidth: Integer;
    FUpdateCount: Integer;
    FVersion: string;
    FWantTabs: Boolean;
    function GetItemCount: Integer;
    function GetLastItem: Integer;
    function GetSelectedIndex: Integer;
    function GetSplitterRect: TRect;
    procedure SetAppearanceOptions(const Value: TInspectorAppearanceOptions);
    procedure SetAssociate(const Value: TPersistent);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetButtonsStyle(const Value: TButtonsStyle);
    procedure SetCategoriesColor(const Value: TColor);
    procedure SetCollapseGlyph(const Value: TBitmap);
    procedure SetDownItem(const Value: TNxPropertyItem);
    procedure SetEnableVisualStyles(const Value: Boolean);
    procedure SetExpandGlyph(const Value: TBitmap);
    procedure SetGridColor(const Value: TColor);
    procedure SetHideTopLevel(const Value: Boolean);
    procedure SetHighlightTextColor(const Value: TColor);
    procedure SetHoverItem(const Value: TNxPropertyItem);
    procedure SetImages(const Value: TImageList);
    procedure SetItemsArrange(const Value: TItemsArrange);
    procedure SetMarginColor(const Value: TColor);
    procedure SetOptions(const Value: TInspectorPropertyOptions);
    procedure SetRowHeight(const Value: Integer);
    procedure SetSelectedIndex(const Value: Integer);
    procedure SetSelectedItem(const Value: TNxPropertyItem);
    procedure SetSelectionColor(const Value: TColor);
    procedure SetSplitterPosition(const Value: Integer);
    procedure SetStyle(const Value: TPropertiesStyle);
    procedure SetSuffixWidth(const Value: Integer);
    procedure SetVersion(const Value: string);
  protected
    function DrawItem(AItem: TNxPropertyItem): Boolean; virtual;
    function GetChildOwner: TComponent; override;
    function GetGridColor: TColor;
    function GetGridSpace: Integer;
    function GetMarginColor: TColor;
    function GetToolbarButtonWidth: Integer;
    function GetItemSuffixRect(Item: TNxPropertyItem): TRect;
    function GetItemVisible(Item: Integer): Boolean;
    function GetVertOffset(FromPos, ToPos: Integer): Integer; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function IsFirstSelected: Boolean;
    function IsFocused: Boolean;
    function IsLastSelected: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DblClick; override;
    procedure EditSuffix(Item: TNxPropertyItem);
    procedure ExpandItem(Item: TNxPropertyItem; Collapse: Boolean); virtual;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure HideItemHint;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeaveItem(X, Y: Integer); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoHintHideTimer(Sender: TObject);
    procedure DoHintTimer(Sender: TObject);
    procedure DoItemChange(Sender: TObject; AItem: TNxPropertyItem; ChangeKind: TChangeKind; Parameter: Integer);
    procedure DoItemEditorButtonClick(Sender: TObject);
    procedure DoItemEditorEdit(Sender: TObject);
    procedure DoItemEditorExit(Sender: TObject);
    procedure DoItemEditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoItemsChange(Sender: TObject);
    procedure DoSuffixComboEdit(Sender: TObject);
    procedure DoChange(Item: TNxPropertyItem; Value: WideString); dynamic;
    procedure DoCustomDraw(Item: TNxPropertyItem; ValueRect: TRect); dynamic;
    procedure DoEdit(Item: TNxPropertyItem; Value: WideString; var Accept: Boolean); dynamic;
    procedure DoEnter; override;
		procedure DoExecute(Item: TNxPropertyItem); dynamic;
    procedure DoExit; override;
		procedure DoExpand(Item: TNxPropertyItem); dynamic;
    procedure DoSelectItem(Item: TNxPropertyItem); dynamic;
    procedure DoSuffixEdit(Item: TNxPropertyItem; Value: WideString); dynamic;
    procedure DoUnselectItem(Item: TNxPropertyItem); dynamic;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure DoToolbarClick(Item: TNxPropertyItem; ButtonIndex: Integer); dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure PushItem(Item: TNxPropertyItem; const Value: Boolean);
    procedure RecreateHintWnd; virtual;
    procedure RedrawBorder;
    procedure RefreshEditingItem;
    procedure RefreshItem(Item: TNxPropertyItem; ItemPart: TPropertyItemPart = ipAll);
    procedure RefreshItemCaption(Item: TNxPropertyItem);
    procedure RefreshSelectedItem;
    procedure RefreshToolbarButton(AItem: TNxPropertyItem; ButtonIndex: Integer);
    procedure RefreshToolbarText(AItem: TNxPropertyItem);
    procedure ShowItemHint(Item: TNxPropertyItem);
    procedure UpdateScrollBar;
    procedure ValueChanged(Item: TNxPropertyItem; const Value: WideString); virtual;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    property DownItem: TNxPropertyItem read FDownItem write SetDownItem;
    property HoverItem: TNxPropertyItem read FHoverItem write SetHoverItem;
  public
    procedure ApplyTextBox(Cancel: Boolean = True);
    procedure BeginUpdate;
    procedure CollapseAll;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetItemAtPos(APoint: TPoint): TNxPropertyItem;
    function GetItemHeight(AItem: TNxPropertyItem): Integer;
    procedure EndUpdate;
    procedure ExpandAll;
    function GetViewCount: Integer;
    function GetVisibleCount: Integer;
    function FindNextItem(Item: TNxPropertyItem): TNxPropertyItem;
    function FindPrevItem(Item: TNxPropertyItem): TNxPropertyItem;
    procedure EditItem(Item: TNxPropertyItem; Focus: Boolean = False);
    procedure EndEditing;
    procedure InvalidateItem(Item: TNxPropertyItem; Grid: Boolean);
    procedure LoadProperties(ParentItem: TNxPropertyItem);
    procedure PaintItems;
    procedure SaveToXML(const FileName: string);
    procedure ScrollTo(const Index: Integer);
    procedure SelectFirst;
    procedure SelectLast;
    procedure SelectNext;
    procedure SelectPrev;
    property AppearanceOptions: TInspectorAppearanceOptions read FAppearanceOptions write SetAppearanceOptions default [iaStyleCategories, iaStyleColors];
    property Associate: TPersistent read FAssociate write SetAssociate;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property ButtonsStyle: TButtonsStyle read FButtonsStyle write SetButtonsStyle default btAuto;
    property Canvas;
    property CategoriesColor: TColor read FCategoriesColor write SetCategoriesColor default clBtnFace;
    property CollapseGlyph: TBitmap read FCollapseGlyph write SetCollapseGlyph;
    property EditingItem: TNxPropertyItem read FEditingItem;
    property EnableVisualStyles: Boolean read FEnableVisualStyles write SetEnableVisualStyles default False;
    property ExpandGlyph: TBitmap read FExpandGlyph write SetExpandGlyph;
    property FirstItem: Integer read FFirstItem;
    property Font;
    property GridColor: TColor read FGridColor write SetGridColor default clBtnFace;
    property HideTopLevel: Boolean read FHideTopLevel write SetHideTopLevel default False;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
    property Images: TImageList read FImages write SetImages;
    property ItemCount: Integer read GetItemCount;
    property Items: TNxPropertyItems read FItems;
    property ItemsArrange: TItemsArrange read FItemsArrange write SetItemsArrange default taCatagory;
    property LastItem: Integer read GetLastItem;
    property MarginColor: TColor read FMarginColor write SetMarginColor default clBtnFace;
    property Options: TInspectorPropertyOptions read FOptions write SetOptions default [poGrid, poEnterSelectNext, poSplitterMoving, poUniformSelect];
    property PropertiesState: TPropertiesState read FPropertiesState;
    property RowHeight: Integer read FRowHeight write SetRowHeight default 16;
    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;
    property SelectedItem: TNxPropertyItem read FSelectedItem write SetSelectedItem;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clHighlight;
    property SplitterPosition: Integer read FSplitterPosition write SetSplitterPosition default 100;
    property Style: TPropertiesStyle read FStyle write SetStyle default psDefault;
    property SuffixWidth: Integer read FSuffixWidth write SetSuffixWidth default 60;
    property Version: string read FVersion write SetVersion stored False;
    property WantTabs: Boolean read FWantTabs write FWantTabs default False;

    property OnChange: TChangeEvent read FOnChange write FOnChange;
    property OnCustomDrawItem: TCustomDrawItemEvent read FOnCustomDrawItem write FOnCustomDrawItem;
    property OnCustomDrawPreview: TCustomDrawPreviewEvent read FOnCustomDrawPreview write FOnCustomDrawPreview;
    property OnEdit: TEditEvent read FOnEdit write FOnEdit;
    property OnEditDblClick: TNotifyEvent read FOnEditDblClick write FOnEditDblClick;
    property OnExecute: TItemNotifyEvent read FOnExecute write FOnExecute;
    property OnExpand: TItemNotifyEvent read FOnExpand write FOnExpand;
    property OnSelectItem: TItemNotifyEvent read FOnSelectItem write FOnSelectItem;
    property OnSuffixEdit: TChangeEvent read FOnSuffixEdit write FOnSuffixEdit;
    property OnToolbarClick: TToolbarClickEvent read FOnToolbarClick write FOnToolbarClick;
    property OnUnselectItem: TUnselectItemEvent read FOnUnselectItem write FOnUnselectItem;
  end;

  TNextInspector = class(TNxCustomInspector)
  published
    property Align;
    property Anchors;
    property AppearanceOptions;
    property Associate;
    property BiDiMode;
    property BorderStyle;
    property ButtonsStyle;
		property CategoriesColor;
    property CollapseGlyph;
    property Constraints;
    property Color;
    property Ctl3D;
    property GridColor;
    property Enabled;
    property EnableVisualStyles;
    property ExpandGlyph;
    property Font;
    property HideTopLevel;
    property HighlightTextColor;
    property Hint;
    property Images;
    property Items;
    property ItemsArrange;
    property MarginColor;
    property Options;
    property RowHeight;
    property ParentColor default False;
    property ParentFont;
    property PopupMenu;
    property ShowHint;
    property SelectionColor;
    property SplitterPosition;
		property Style;
    property SuffixWidth;
    property TabOrder;
    property TabStop default True;
    property Version;
    property WantTabs;

    property OnChange;	
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEdit;
    property OnEditDblClick;
    property OnEndDrag;
    property OnEnter;
		property OnExecute;
    property OnExit;
    property OnExpand;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnMouseUp;
    property OnSelectItem;
    property OnStartDrag;
    property OnSuffixEdit;
    property OnToolbarClick;
    property OnVerticalScroll;
    property OnUnselectItem;
  end;

implementation

uses
  Dialogs, NxPropertyItemClasses, NxThemesSupport,
  NxEdit, NxSharedCommon, Math;

{ TNxCustomInspector }

procedure TNxCustomInspector.ApplyTextBox(Cancel: Boolean);
var
  Accept: Boolean;
  ItemIndex: Integer;
begin
  if Assigned(FSuffixEditingItem) then
  begin
    case FSuffixEditingItem.SuffixStyle of
      ssDropDownList:
        begin
          ItemIndex := FSuffixEditingItem.SuffixCombo.ItemIndex;
          if InRange(ItemIndex, 0, FSuffixEditingItem.ItemCount - 1) then
            FSuffixEditingItem.SuffixValue := FSuffixEditingItem.SuffixCombo.Items[ItemIndex];
        end;
      else FSuffixEditingItem.SuffixValue := FSuffixEditingItem.SuffixCombo.Text;
    end;
  end;

  if Assigned(FEditingItem) then
  begin
    if FEditingItem.AsString <> FEditingItem.Editor.AsString then
    begin
      Accept := True;
      DoEdit(FEditingItem, FEditingItem.Editor.AsString, Accept);
      if Accept then FEditingItem.Value := FEditingItem.Editor.AsString else
      begin
        FIsMouseDown := False;
        FEditingItem.Editor.AsString := FEditingItem.Value;
        FEditingItem.AssignEditing; { Assign additional properties from editor to item }
        if Cancel then EndEditing;
      end;
    end;
    if not Cancel then FEditingItem.Editor.SelectAll;
  end;
end;

procedure TNxCustomInspector.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TNxCustomInspector.CollapseAll;
var
  i: Integer;
begin
  for i := 0 to Items.Count - 1 do
    Items[i].Collapse(True);
end;

constructor TNxCustomInspector.Create(AOwner: TComponent);
begin
  inherited;
  ParentColor := False;
  Color := clWindow;
  FAppearanceOptions := [iaStyleCategories, iaStyleColors];
  FBorderStyle := bsSingle;
  FButtonsStyle := btAuto;
  FEditingItem := nil;
  FGridColor := clBtnFace;
  FIsMouseDown := False;
  FCategoriesColor := clBtnFace;
  FCollapseGlyph := TBitmap.Create;
  FEnableVisualStyles := False;
  FExpandGlyph := TBitmap.Create;
  FEscapePressed := False;
  FHighlightTextColor := clHighlightText;
  FHintHideTimer := TTimer.Create(Self);
  FHintHideTimer.Interval := Application.HintHidePause;
  FHintHideTimer.Enabled := False;
  FHintHideTimer.OnTimer := DoHintHideTimer;
  FHintWindow := nil;
  RecreateHintWnd;
  FHintTimer := TTimer.Create(Self);
  FHintTimer.Interval := Application.HintPause;
  FHintTimer.Enabled := False;      
  FHintTimer.OnTimer := DoHintTimer;
  FItems := TNxPropertyItems.Create(Self);
  FItems.OnItemChange := DoItemChange; { catch when single item is changed }
  FItems.OnChange := DoItemsChange; { catch when Items are changed }
  FItemsArrange := taCatagory;
  FMarginColor := clBtnFace;
  FOptions := [poGrid, poEnterSelectNext, poSplitterMoving, poUniformSelect];
  FRowHeight := 16;
  FSelectedItem := nil;
  FSelectionColor := clHighlight;
  FSplitterPosition := 100;
  FStyle := psDefault;
  FSuffixEditingItem := nil;
  FSuffixWidth := 60;
  FPropertiesState := [];
  FUpdateCount := 0;
  FWantTabs := False;
  Width := 245;
  Height := 200;
  TabStop := True;
  SchemeNotification(Self);
end;

procedure TNxCustomInspector.CreateWnd;
begin
  inherited;
  ShowScrollBar(Handle, SB_HORZ, False);
  ShowScrollBar(Handle, SB_VERT, False);
  VertScrollClipRect := ClientRect;
  VertScrollBar.LargeChange := 4;
end;

destructor TNxCustomInspector.Destroy;
begin
  FreeAndNil(FCollapseGlyph);
  FreeAndNil(FExpandGlyph);
  FreeAndNil(FHintHideTimer);
  FreeAndNil(FHintTimer);
  FreeAndNil(FHintWindow);
  FreeAndNil(FItems);
  RemoveSchemeNotification(Self);
  inherited;
end;

procedure TNxCustomInspector.EndUpdate;
begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
  if FUpdateCount = 0 then Invalidate;
end;

procedure TNxCustomInspector.ExpandAll;
var
  i: Integer;
begin
  for i := 0 to Items.Count - 1 do
    Items[i].Expand(True);
end;

function TNxCustomInspector.GetVertOffset(FromPos, ToPos: Integer): Integer;
var
  C, i: Integer;
begin
  Result := 0;

  if ToPos > FromPos then { scroll-down }
  begin
    C := 0;
    while FFirstItem < FItems.NodesCount do
    begin
      if GetItemVisible(FFirstItem) then
      begin
        Inc(C);
        if C > (ToPos - FromPos) then Break;
        Dec(Result, GetItemHeight(FItems.Node[FFirstItem]) + GetGridSpace);
      end;
      Inc(FFirstItem);
    end;
  end;

  if FromPos > ToPos then { scroll-up }
  begin
    i := FFirstItem - 1;
    C := 0;
    while (i >= 0) and (C < FromPos - ToPos) do
    begin
      Dec(FFirstItem);
      if GetItemVisible(i) then
      begin
        Inc(C);
        Inc(Result, GetItemHeight(FItems.Node[i]) + GetGridSpace);
      end;
      Dec(i);
    end;
  end;
end;

procedure TNxCustomInspector.DblClick;
var
  CursorPoint: TPoint;
  AItem: TNxPropertyItem;
begin
  inherited;
  GetCursorPos(CursorPoint);
  CursorPoint := ScreenToClient(CursorPoint);
  AItem := GetItemAtPos(CursorPoint);
  if (Assigned(AItem)) and (AItem.ItemCount > 0) then
  begin
	  if (CursorPoint.X > AItem.Indent + spaMargin)
      then AItem.Expanded := not AItem.Expanded;
  end;
end;

procedure TNxCustomInspector.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    case BorderStyle of
      bsNone: ExStyle := ExStyle and not WS_EX_STATICEDGE;
      bsSingle: ExStyle := ExStyle or WS_EX_STATICEDGE;
    end;
		with WindowClass do Style := Style and not(CS_VREDRAW);
	end;
end;

procedure TNxCustomInspector.CMMouseLeave(var Message: TMessage);
begin
  if Assigned(HoverItem) then
  begin
    HoverItem.Display.MouseLeave;
    HoverItem := nil;
  end;
  HideItemHint;
end;

function TNxCustomInspector.GetViewCount: Integer;
var
  i, Y: Integer;
begin
  Result := 0;
  Y := 0;
  for i := FirstItem to Pred(FItems.NodesCount) do
  begin
    if GetItemVisible(i) then
    begin
      Inc(Y, GetItemHeight(FItems.Node[i]) + GetGridSpace);
      if Y > ClientHeight then Exit;
      Inc(Result);
    end;
  end;
end;
          
function TNxCustomInspector.GetVisibleCount: Integer;
var
  i: Integer;
begin          
  Result := 0;              
  for i := 0 to FItems.NodesCount - 1 do
    if not FItems.Node[i].Hidden and
      not(HideTopLevel and FItems.Node[i].IsTopLevel)
        then Inc(Result);
end;

function TNxCustomInspector.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TNxCustomInspector.GetLastItem: Integer;
var
  i, j: Integer;
begin
  Result := FFirstItem;
  j := 0;
  for i := FFirstItem to Items.NodesCount - 1 do
  begin
    if GetItemVisible(i) then Inc(j, GetItemHeight(Items.Node[i]) + GetGridSpace);
    if j > ClientHeight then Exit;
    Result := i;
  end;
end;

(*
function TNxCustomInspector.GetFirstItem: Integer;
var
  i, count: Integer;
begin
  count := 0;
  for i := 0 to Items.NodesCount - 1 do
  begin
    if not Items.Node[i].Hidden then
    begin
      Inc(count);
      if count > VertScrollBar.Position then Break;
    end;
  end;
  Result := i;
end;
*)

function TNxCustomInspector.GetSelectedIndex: Integer;
begin
  Result := FSelectedItem.AbsoluteIndex;
end;

function TNxCustomInspector.GetSplitterRect: TRect;
begin
  Result := Rect(SplitterPosition - spaSplitterSpace, 0,
                  SplitterPosition + spaSplitterSpace + 1, ClientHeight);
end;

procedure TNxCustomInspector.DoChange(Item: TNxPropertyItem;
  Value: WideString);
begin
  if Assigned(FOnChange) then FOnChange(Self, Item, Value);
end;

procedure TNxCustomInspector.DoCustomDraw(Item: TNxPropertyItem;
  ValueRect: TRect);
begin
  if Assigned(FOnCustomDrawItem) then FOnCustomDrawItem(Self, Item, ValueRect);
end;

procedure TNxCustomInspector.DoEdit(Item: TNxPropertyItem;
	Value: WideString; var Accept: Boolean);
begin
  if Assigned(FOnEdit) then FOnEdit(Self, Item, Value, Accept);
end;

procedure TNxCustomInspector.DoExecute(Item: TNxPropertyItem);
begin
  if Assigned(FOnExecute) then FOnExecute(Self, Item);
end;

procedure TNxCustomInspector.DoExpand(Item: TNxPropertyItem);
begin
  if Assigned(FOnExpand) then FOnExpand(Self, Item);
end;

procedure TNxCustomInspector.DoHintHideTimer(Sender: TObject);
begin
  FHintHideTimer.Enabled := False;
  FHintWindow.ReleaseHandle;
end;

procedure TNxCustomInspector.DoHintTimer(Sender: TObject);
begin
  FHintItem := FHoverItem;
  ShowItemHint(FHoverItem);
end;

procedure TNxCustomInspector.DoItemChange(Sender: TObject;
  AItem: TNxPropertyItem;	ChangeKind: TChangeKind; Parameter: Integer);
begin
  if (ChangeKind = ckDestroy) then
  begin
    if (AItem = FEditingItem) or (AItem = FSuffixEditingItem) then
    begin
      EndEditing;
    end;
    if AItem = FSelectedItem then FSelectedItem := nil;
    if AItem = FHoverItem then FHoverItem := nil;
    if AItem = FDownItem then FDownItem := nil;
  end;

	if (ChangeKind = ckUndefined) or (ChangeKind = ckValueRepaint)
    or (ChangeKind = ckValueMember) or (ChangeKind = ckValueChanged)
      then RefreshItem(AItem, ipValue);

  { toolbar }
  if (ChangeKind = ckToolButtonClick) or (ChangeKind = ckToolButtonRedraw)
    then RefreshToolbarButton(AItem, Parameter);

  if (ChangeKind = ckCaption) or (ChangeKind = ckDisable) then RefreshItem(AItem);
  if (ChangeKind = ckDisable) then EndEditing;

  if (ChangeKind = ckCollapse) or (ChangeKind = ckExpand) then
  begin
    EndEditing;
    DoExpand(AItem);
    ExpandItem(AItem, ChangeKind = ckCollapse);
  end;

  if (ChangeKind = ckVisible) then
  begin
    if AItem = EditingItem then EndEditing;
    RefreshEditingItem;
    Invalidate;
  end;

  if ChangeKind = ckValueChanged then
  begin
    DoChange(AItem, AItem.Value);
    if FEditingItem = AItem then FEditingItem.Editor.AsString := AItem.Value;
    ValueChanged(AItem, AItem.Value);
  end;

  if (ChangeKind = ckToolButtonClick) then
  begin
    RefreshToolbarText(AItem);
    DoToolbarClick(AItem, Parameter);
  end;

  if ChangeKind = ckSilentValue then begin end;

  if ChangeKind = ckRefresh then
  begin
    RefreshItem(AItem, ipValue);
  end;

  if ChangeKind = ckSuffixChanged
    then RefreshItem(AItem, ipSuffix);

  if ChangeKind = ckSuffixChanged
    then DoSuffixEdit(AItem, AItem.SuffixValue);

  if ChangeKind = ckAdded then PushItem(AItem, True);

  if ChangeKind = ckButton then RefreshItem(AItem, ipButton);

  case ChangeKind of
    ckAdded, ckDeleted, ckCollapse, ckDestroy, ckExpand, ckVisible: UpdateScrollBar;
  end;
end;

procedure TNxCustomInspector.DoItemEditorButtonClick(Sender: TObject);
begin
  DoExecute(TNxPropertyItem(Sender));
end;

procedure TNxCustomInspector.DoSuffixComboEdit(Sender: TObject);
begin
  if FSuffixEditingItem <> nil then
  begin
    FSuffixEditingItem.SuffixValue := FSuffixEditingItem.SuffixCombo.Text;
  end;
end;

procedure TNxCustomInspector.DoItemsChange(Sender: TObject);
begin
  Invalidate;
  UpdateScrollBar;
end;

function TNxCustomInspector.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if Result then
  begin
    EndEditing;
    if ssCtrl in Shift then VertScrollBar.PageDown else VertScrollBar.Next;
    Result := True;
  end;
end;

function TNxCustomInspector.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if Result then
  begin
    EndEditing;
    if ssCtrl in Shift then VertScrollBar.PageUp else VertScrollBar.Prior;
    Result := True;
  end;
end;

function TNxCustomInspector.IsFirstSelected: Boolean;
var
  i: Integer;
  AItem: TNxPropertyItem;
begin
  AItem := nil;
  for i := 0 to FItems.NodesCount - 1 do
  begin
    if (not FItems.Node[i].Hidden) and (FItems.Node[i].Visible)
      and ((not HideTopLevel) or (not FItems.Node[i].IsTopLevel))
      and FItems.Node[i].Enabled and FItems.Node[i].TabStop then
    begin
      AItem := FItems.Node[i];
      Break;
    end;
  end;
  Result := SelectedItem = AItem;
end;

function TNxCustomInspector.IsFocused: Boolean;
begin
  Result := Focused or (Assigned(EditingItem)
    and Assigned(EditingItem.Editor) and EditingItem.Editor.Focused);
end;

function TNxCustomInspector.IsLastSelected: Boolean;
var
  i: Integer;
  AItem: TNxPropertyItem;
begin
  AItem := nil;
  for i := FItems.NodesCount - 1 downto 0 do
  begin
    if (not FItems.Node[i].Hidden) and (FItems.Node[i].Visible)
      and ((not HideTopLevel) or (not FItems.Node[i].IsTopLevel))
      and FItems.Node[i].Enabled and FItems.Node[i].TabStop then
    begin
      AItem := FItems.Node[i];
      Break;
    end;
  end;
  Result := SelectedItem = AItem;
end;

procedure TNxCustomInspector.DoSelectItem(Item: TNxPropertyItem);
begin
  if Assigned(FOnSelectItem) then FOnSelectItem(Self, Item);
end;

procedure TNxCustomInspector.DoItemEditorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
	case Key of
  	VK_RETURN:
    begin
      if Assigned(FEditingItem) and (FEditingItem.Editor.Editing)
          or (tsWantReturns in FEditingItem.ItemStyle) then Exit;
      ApplyTextBox(poEnterSelectNext in Options);
      if poEnterSelectNext in Options then SelectNext;
    end;
    VK_ESCAPE:
      begin
        FEscapePressed := True;
        EndEditing;
        EditItem(FEditingItem);
        FEscapePressed := False;
      end;
    VK_HOME: if ssCtrl in Shift then SelectFirst;
    VK_END: if ssCtrl in Shift then SelectLast;
    else KeyDown(Key, Shift);
  end;
end;

procedure TNxCustomInspector.DoSuffixEdit(Item: TNxPropertyItem;
  Value: WideString);
begin
  if Assigned(FOnSuffixEdit) then FOnSuffixEdit(Self, Item, Value);
end;

procedure TNxCustomInspector.DoUnselectItem(Item: TNxPropertyItem);
begin
  if Assigned(FOnUnselectItem) then FOnUnselectItem(Self, Item);
end;

procedure TNxCustomInspector.DoToolbarClick(Item: TNxPropertyItem;
  ButtonIndex: Integer);
begin
  if Assigned(FOnToolbarClick) then FOnToolbarClick(Self, Item, ButtonIndex);
end;

function TNxCustomInspector.DrawItem(AItem: TNxPropertyItem): Boolean;
var
  ItemTop: Integer;
  ItemRect, UpdRect, MarginRect: TRect;
  AMarginColor, AGridColor: TColor;
  Attributes: TDisplayAttributes;
begin
  ItemTop := AItem.Top;
  Result := True;

  GetClipBox(Canvas.Handle, UpdRect);
  ItemRect := Rect(0, ItemTop, ClientWidth, ItemTop + GetItemHeight(AItem));
  if (ItemRect.Bottom < UpdRect.Top) or (ItemRect.Top > UpdRect.Bottom) then Exit;

	if not Result then Exit; { if item is not inside client rect then skip drawing }
  with AItem do
  begin
    { Notice: Next line may be obsolete }
    SetClipingRect(Canvas, ItemRect);
    with Canvas do
    begin
      AMarginColor := GetMarginColor;
      AGridColor := GetGridColor;

      Brush.Color := AGridColor;
      FillRect(GetPartRect(ipSplitter));

      MarginRect := Rect(0, ItemTop, spaMargin, ItemTop + GetItemHeight(AItem));
      Brush.Color := AMarginColor;
      FillRect(MarginRect);
    end;
    Display.BiDiMode := BiDiMode;
    Attributes := [];
    if IsThemed and EnableVisualStyles then Include(Attributes, daVisualStyles);
    if iaStyleCategories in FAppearanceOptions then Include(Attributes, daStyleCategories);

    Display.SetDisplayAttributes(SelectionColor, HighlightTextColor, CategoriesColor, AMarginColor,
      AGridColor, Attributes);

    Display.Selected := (AItem = SelectedItem) and (IsFocused or not(iaHideSelection in AppearanceOptions));

    Display.Canvas := Self.Canvas;
    Display.Images := Self.Images;
    Display.Style := Self.Style;

    if AItem.Level = 0 then
    begin
      ItemRect := Rect(spaMargin, ItemTop, ClientWidth, ItemTop + GetItemHeight(AItem));
    end else ItemRect := Rect(spaMargin, ItemTop, SplitterPosition, ItemTop + GetItemHeight(AItem));

    Display.ClientRect := ItemRect;
    Display.PaintCaption;

    if AItem.HasChildren and
      not((iaLockedButtons in FAppearanceOptions) or AItem.ExpandLock)
        then Display.PaintExpandButton;

    if AItem.ShowSuffix then
    begin
      ItemRect := Rect(SplitterPosition + 1, ItemTop, ClientWidth - SuffixWidth, ItemTop + GetItemHeight(AItem));
      Display.ClientRect := GetItemSuffixRect(AItem);
      Display.PaintSuffix;
    end else
    begin
      ItemRect := Rect(SplitterPosition + 1, ItemTop, ClientWidth, ItemTop + GetItemHeight(AItem));
    end;

    if AItem <> FEditingItem then
    begin
      Display.ClientRect := ItemRect;
      Display.PaintValue;
    end;

    DoCustomDraw(AItem, Display.ClientRect);
    SetClipingRect(Canvas, Self.ClientRect);
  end;
end;

procedure TNxCustomInspector.EditSuffix(Item: TNxPropertyItem);
var
  SuffixLeft, SuffixItemIndex: Integer;
begin
  if (csDesigning in ComponentState) or
    (Item.SuffixStyle = ssReadOnly) then Exit;

  if FSuffixEditingItem = Item then Exit;

  if Assigned(FSuffixEditingItem) then
  begin
    ApplyTextBox;
    FSuffixEditingItem.HideSuffix;
    FSuffixEditingItem := nil;
  end;

  if Item.ShowSuffix then
  begin
    FSuffixEditingItem := Item;
    with Item.SuffixCombo do
    begin
      Parent := Self;
      InplaceEditor := True;
      HideFocus := True;
      case Item.SuffixStyle of
        ssDropDown: Style := dsDropDown;
        ssDropDownList: Style := dsDropDownList;
      end;
      SuffixLeft := GetItemSuffixRect(Item).Left + 1;

      Item.BeginSuffixEditing;

      case Item.SuffixStyle of
        ssDropDownList:
        begin
          SuffixItemIndex := Item.Suffixes.IndexOf(Item.SuffixValue);
          ItemIndex := SuffixItemIndex;
        end
        else Item.SuffixCombo.Text := Item.SuffixValue;
      end;

      OnChange := DoSuffixComboEdit;

      SetWindowPos(Handle, HWND_TOP, SuffixLeft, Item.Top, Self.ClientWidth - SuffixLeft, GetItemHeight(Item),
        SWP_SHOWWINDOW or SWP_NOREDRAW);
    end;
  end;
end;

procedure TNxCustomInspector.ExpandItem(Item: TNxPropertyItem;
  Collapse: Boolean);
begin
  Invalidate;
end;

function TNxCustomInspector.GetGridColor: TColor;
begin
  if iaStyleColors in FAppearanceOptions then
  begin
    case FStyle of
      psDefault: Result := clBtnFace;
      psOffice2003: Result := clBtnFace;
      psOffice2007: Result := SchemeColor(seBtnFace);
      else Result := clBtnFace;
    end;
  end else Result := GridColor;
end;

function TNxCustomInspector.GetGridSpace: Integer;
begin
	if poGrid in Options then Result := 1 else Result := 0;
end;

function TNxCustomInspector.GetMarginColor: TColor;
begin
  if iaStyleColors in FAppearanceOptions then
  begin
    case FStyle of
      psDefault: Result := clBtnFace;
      psOffice2003: Result := clHighlight;
      psOffice2007: Result := SchemeColor(seBtnFaceDark);
      else Result := clBtnShadow;
    end;
  end else Result := MarginColor;
end;

function TNxCustomInspector.GetItemSuffixRect(
  Item: TNxPropertyItem): TRect;
begin
  Result := Rect(ClientWidth - SuffixWidth, Item.Top, ClientWidth, Item.Top + GetItemHeight(Item));
end;

function TNxCustomInspector.GetItemVisible(Item: Integer): Boolean;
begin
  Result := not FItems.Node[Item].Hidden and not(HideTopLevel and FItems.Node[Item].IsTopLevel);
end;

procedure TNxCustomInspector.SetAppearanceOptions(
  const Value: TInspectorAppearanceOptions);
begin
  FAppearanceOptions := Value;
  Invalidate;
end;

procedure TNxCustomInspector.SetAssociate(const Value: TPersistent);
var
	i: Integer;
begin
  FAssociate := Value;
  if Assigned(Value) then
  begin
		for i := 0 to GetItemCount - 1 do
    	with FItems[i] do if (MapProperty <> '') and Enabled then Resync;
    FreeNotification(Self);
  end;
end;

procedure TNxCustomInspector.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
  RecreateWnd;
end;

procedure TNxCustomInspector.SetButtonsStyle(const Value: TButtonsStyle);
begin
  FButtonsStyle := Value;
  Invalidate;
end;

procedure TNxCustomInspector.SetDownItem(
  const Value: TNxPropertyItem);
begin
  if Value = FDownItem then Exit;

  { Update old HoverItem }
  if (FDownItem <> Value) and Assigned(DownItem) then
  begin
    FDownItem.ItemState := FDownItem.ItemState - [isBtnDown1, isBtnDown2];
    RefreshItem(FDownItem, ipValue);
  end;

  FDownItem := Value;

  if Assigned(FDownItem) then
  begin
    FDownItem.ItemState := FDownItem.ItemState + [isBtnDown1, isBtnDown2];
    RefreshItem(FDownItem, ipValue);
  end;
end;

procedure TNxCustomInspector.SetEnableVisualStyles(
  const Value: Boolean);
begin
  FEnableVisualStyles := Value;
  Invalidate;
end;

procedure TNxCustomInspector.SetExpandGlyph(const Value: TBitmap);
begin
  FExpandGlyph.Assign(Value);
  FExpandGlyph.Transparent := True;
  FExpandGlyph.TransparentColor := FExpandGlyph.Canvas.Pixels[0, FExpandGlyph.Height - 1];
  Invalidate;
end;

procedure TNxCustomInspector.SetGridColor(const Value: TColor);
begin
  FGridColor := Value;
  Invalidate;
end;

procedure TNxCustomInspector.SetHideTopLevel(const Value: Boolean);
begin
  FHideTopLevel := Value;
  Invalidate;
end;

procedure TNxCustomInspector.SetHighlightTextColor(const Value: TColor);
begin
  FHighlightTextColor := Value;
  RefreshSelectedItem;
end;

procedure TNxCustomInspector.SetHoverItem(
  const Value: TNxPropertyItem);
begin
  if Value = FHoverItem then Exit;

  { Update old HoverItem }
  if (FHoverItem <> Value) and Assigned(HoverItem) then
  begin
    FHoverItem.ItemState := FHoverItem.ItemState - [isHover];
    RefreshItem(FHoverItem, ipValue);
  end;

  FHoverItem := Value;

  if Assigned(FHoverItem) then
  begin
    FHoverItem.ItemState := FHoverItem.ItemState + [isHover];
    RefreshItem(FHoverItem, ipValue);
  end;
end;

procedure TNxCustomInspector.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    if Assigned(FImages) then FreeNotification(Self);
    Refresh;
  end;
end;

procedure TNxCustomInspector.SetItemsArrange(const Value: TItemsArrange);
begin
  FItemsArrange := Value;
  FItems.SetItemsArrange(Value);
  Invalidate;
end;

procedure TNxCustomInspector.SetCategoriesColor(const Value: TColor);
begin
  FCategoriesColor := Value;
  Invalidate;
end;

procedure TNxCustomInspector.SetCollapseGlyph(const Value: TBitmap);
begin
  FCollapseGlyph.Assign(Value);
  FCollapseGlyph.Transparent := True;
  FCollapseGlyph.TransparentColor := FCollapseGlyph.Canvas.Pixels[0, FCollapseGlyph.Height - 1];
  Invalidate;
end;

procedure TNxCustomInspector.SetMarginColor(const Value: TColor);
begin
  FMarginColor := Value;
  Invalidate;
end;

procedure TNxCustomInspector.SetOptions(const Value: TInspectorPropertyOptions);
begin
  FOptions := Value;
  EndEditing;
  Invalidate;
end;

procedure TNxCustomInspector.SetRowHeight(const Value: Integer);
begin
  FRowHeight := Value;
  EndEditing;
  Invalidate;
end;

procedure TNxCustomInspector.SetSelectedIndex(const Value: Integer);
begin
  if Value < 0 then
    SelectedItem := nil
  else
    SelectedItem := FItems[Value];
end;

procedure TNxCustomInspector.SetSelectedItem(
  const Value: TNxPropertyItem);
var
  OldSelectedItem: TNxPropertyItem;
begin
  OldSelectedItem := FSelectedItem;
  if Assigned(OldSelectedItem) then DoUnselectItem(OldSelectedItem);
  FSelectedItem := Value;

  RefreshItemCaption(OldSelectedItem);

  if FSelectedItem <> nil then
  begin
    { Expand path to the item }
    FSelectedItem.Uncover;
    ScrollTo(FSelectedItem.NodeIndex);
    RefreshItemCaption(FSelectedItem);
    DoSelectItem(FSelectedItem);
    if not(isEditing in FSelectedItem.ItemState) then
    begin
      EditItem(FSelectedItem, True);
      EditSuffix(FSelectedItem);
    end;
  end;
end;

procedure TNxCustomInspector.SetSelectionColor(const Value: TColor);
begin
  FSelectionColor := Value;
end;

procedure TNxCustomInspector.SetSplitterPosition(const Value: Integer);
var
	OldValue: Integer;
begin
  OldValue := FSplitterPosition;
	if Value > spaMargin then FSplitterPosition := Value
	  else FSplitterPosition := spaMargin;
  RefreshEditingItem;
  if OldValue <> FSplitterPosition then Invalidate;
end;

procedure TNxCustomInspector.SetStyle(const Value: TPropertiesStyle);
begin
  FStyle := Value;
  Invalidate;
end;

procedure TNxCustomInspector.SetSuffixWidth(const Value: Integer);
begin
  FSuffixWidth := Value;
  EndEditing;
  Invalidate;
end;

procedure TNxCustomInspector.KeyDown(var Key: Word; Shift: TShiftState);
var
	AItem: TNxPropertyItem;
begin
  inherited;
  case Key of
    189: if Assigned(SelectedItem) and not Assigned(FEditingItem) then SelectedItem.Expanded := False;
    187: if Assigned(SelectedItem) and not Assigned(FEditingItem) then SelectedItem.Expanded := True;
  	VK_HOME: SelectFirst;
  	VK_END:	SelectLast;
    VK_TAB:
      begin
        if (Shift = [ssShift]) then
        begin
          if IsFirstSelected then
          begin
            Key := 0;
            SelectPrevControl;
          end else SelectPrev;
        end else
        if (Shift = []) then begin
          if IsLastSelected then
          begin
            Key := 0;
            SelectNextControl;
          end else SelectNext;
        end;
      end;
  	VK_DOWN:
      if not(ssAlt in Shift) then
      begin
        if Assigned(FEditingItem) and ((FEditingItem.Editor.Editing)
          or (tsWantReturns in FEditingItem.ItemStyle)) then Exit;
        AItem := FindNextItem(SelectedItem);
        if Assigned(AItem) then
        begin
          if AItem.Top + GetItemHeight(AItem) + GetGridSpace > ClientHeight then VertScrollBar.Next;
          ApplyTextBox;
          SelectedItem := AItem;
        end;
      end;
    VK_UP:
      if not(ssAlt in Shift) then
      begin
        if Assigned(FEditingItem) and ((FEditingItem.Editor.Editing)
          or (tsWantReturns in FEditingItem.ItemStyle)) then Exit;
        AItem := FindPrevItem(SelectedItem);
        if AItem <> nil then
        begin
          if AItem.Top < 0 then VertScrollBar.Prior;
          ApplyTextBox;
          SelectedItem := AItem;
        end;
      end;
    VK_RETURN:      
    begin
      if Assigned(FEditingItem) and (tsWantReturns in FEditingItem.ItemStyle) then Exit;
      ApplyTextBox;
      if poEnterSelectNext in Options then
      begin
        AItem := FindNextItem(SelectedItem);
        if Assigned(AItem) then SelectedItem := AItem;
      end;
    end;
    else if Assigned(SelectedItem) and SelectedItem.Enabled
      and (not SelectedItem.ReadOnly) then SelectedItem.Display.KeyDown(Key, Shift);
  end;
end;

procedure TNxCustomInspector.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ItemLeft, ItemTop, ItemSuffixWidth: Integer;
begin
  inherited;
  if not(csDesigning in ComponentState) then
  begin
    { prob: second click on item, cancel edit }
    if not(Button = mbMiddle) then FIsMouseDown := True;
    FHintWindow.ReleaseHandle;
  end;
  if (poSplitterMoving in Options) and PtInRect(GetSplitterRect, Point(X, Y)) then
	begin
	  Include(FPropertiesState, pvsSplitterMove);
	  Exit;
	end;
  ApplyTextBox(True);
  DownItem := GetItemAtPos(Point(X, Y));

  if Assigned(DownItem) then
  begin
    if (DownItem.Count > 0) and (Button = mbLeft) then
    begin
      if (X > DownItem.Indent)
 	      and (X < DownItem.Indent + spaMargin)
          then DownItem.Expanded := not DownItem.Expanded;
    end;
    if not DownItem.Enabled then Exit;
    SelectedItem := DownItem;
    if SelectedItem.ReadOnly then Exit;

    ItemLeft := SplitterPosition + 1;
    ItemTop := DownItem.Top;
    ItemSuffixWidth := 0;
    if DownItem.ShowSuffix then ItemSuffixWidth := SuffixWidth;
    if PtInRect(Rect(SplitterPosition + 1, ItemTop, ClientWidth - ItemSuffixWidth, ItemTop + GetItemHeight(DownItem)), Point(X, Y)) then
    begin
      if not(SelectedItem.ReadOnly) and (SelectedItem.Enabled) then
      begin
        DownItem.Display.MouseDown(Button, Shift, X - ItemLeft, Y - ItemTop);
        if tsCaptureMouse in DownItem.ItemStyle then
        begin
          FCapturedItem := SelectedItem;
        end;
      end;
    end;
  end;
end;

procedure TNxCustomInspector.MouseLeaveItem(X, Y: Integer);
var
  AHoverItem: TNxPropertyItem;
begin
	AHoverItem := GetItemAtPos(Point(X, Y));
  if Assigned(HoverItem) and not Assigned(FCapturedItem) then
  begin
    if (HoverItem <> AHoverItem) or (X < SplitterPosition)
      then HoverItem.Display.MouseLeave;
  end;
  HoverItem := AHoverItem;
end;

procedure TNxCustomInspector.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  AHoverItem: TNxPropertyItem;
  ItemLeft, ItemTop, ItemHeight, ItemSuffixWidth: Integer;
begin
  inherited;
  if ItemCount = 0 then Exit;
  if vsRolling in ViewState then Exit;

  ItemSuffixWidth := 0;

  if (poSplitterMoving in FOptions) and PtInRect(GetSplitterRect, Point(X, Y))
    then Cursor := crHSplit else Cursor := crDefault;

  if pvsSplitterMove in FPropertiesState then
	begin
	  SplitterPosition := SplitterPosition + (X - SplitterPosition);
    Exit;
	end;

	AHoverItem := GetItemAtPos(Point(X, Y));
  if Assigned(HoverItem) and not Assigned(FCapturedItem) then
  begin
    if (HoverItem <> AHoverItem) or (X < SplitterPosition)
      then HoverItem.Display.MouseLeave;
  end;

  HoverItem := AHoverItem;

  if Assigned(FCapturedItem) then AHoverItem := FCapturedItem;
      
  if Assigned(FHoverItem) then
  begin
    ItemHeight := GetItemHeight(FHoverItem);
    if FHintItem <> AHoverItem then
    begin
      if (AHoverItem.ShowHint) and (Length(AHoverItem.Hint) > 0) then
      begin
        if Assigned(FHintItem) then
        begin
          FHintHideTimer.Enabled := False;
          FHintItem := FHoverItem;
          ShowItemHint(FHoverItem);
        end else
        begin
          FHintTimer.Enabled := True;
        end;
      end else HideItemHint;
    end;
  	if (FIsMouseDown) and (not(poUniformSelect in Options))
      then SelectedItem := AHoverItem;
  end else Exit;

  { Hover effect }
  ItemLeft := SplitterPosition + 1;
  ItemTop := AHoverItem.Top;

  if FCapturedItem <> nil then
  begin
    ItemTop := FCapturedItem.Top;
    ItemHeight := GetItemHeight(FCapturedItem);
    AHoverItem := FCapturedItem;
  end;

  { Bounds check }
  if PtInRect(Rect(SplitterPosition + 1, ItemTop, ClientWidth, ItemTop + ItemHeight), Point(X, Y))
    or Assigned(FCapturedItem) then
  begin
    if AHoverItem.ShowSuffix then ItemSuffixWidth := SuffixWidth;
    AHoverItem.Display.ClientRect := Rect(ItemLeft, ItemTop, ClientWidth - ItemSuffixWidth, ItemTop + ItemHeight);

    if not(AHoverItem.ReadOnly) and (AHoverItem.Enabled)
      then AHoverItem.Display.MouseMove(Shift, X - ItemLeft, Y - ItemTop);
  end;
end;

procedure TNxCustomInspector.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  AUpItem: TNxPropertyItem;
  ItemLeft, ItemTop: Integer;
begin
  inherited;
  if pvsSplitterMove in FPropertiesState then Exclude(FPropertiesState, pvsSplitterMove);
  FIsMouseDown := False;

  if Assigned(FCapturedItem)
    then AUpItem := FCapturedItem
    else AUpItem := GetItemAtPos(Point(X, Y));

  if Assigned(AUpItem) and (AUpItem = DownItem) then
  begin
    ItemLeft := SplitterPosition + 1;
    ItemTop := AUpItem.Top;
    if PtInRect(Rect(SplitterPosition + 1, ItemTop, ClientWidth, ItemTop + GetItemHeight(AUpItem)), Point(X, Y))
      or Assigned(FCapturedItem) then
    begin
      if Assigned(AUpItem) and not(AUpItem.ReadOnly) and (AUpItem.Enabled) then
      begin
        AUpItem.Display.InBounds := True;
        AUpItem.Display.MouseUp(Button, Shift, X - ItemLeft, Y - ItemTop);
      end;
    end;
  end else
  begin
    if DownItem <> nil then
    begin
      DownItem.ItemState := DownItem.ItemState - [isBtnDown1, isBtnDown2];
      DownItem.Display.InBounds := False;
      DownItem.Display.MouseUp(Button, Shift, X, Y);
    end;
  end;

  FCapturedItem := nil;
  DownItem := nil;
end;

procedure TNxCustomInspector.Paint;
var
  Indent, ItemTop: Integer;

  procedure DrawGrid;
  begin
    with Canvas do
    begin
    	Pen.Color := GetMarginColor;
      MoveTo(0, ItemTop);
      LineTo(spaMargin, ItemTop);
    	Pen.Color :=  GetGridColor;
      MoveTo(spaMargin, ItemTop);
      LineTo(ClientWidth, ItemTop);
    end;
  end;

  procedure DrawItems;
  var
    i: Integer;
  begin
    with Canvas do
    begin   
      for i := FirstItem to Items.NodesCount - 1 do
      begin
        if Items.Node[i].Hidden or (not Items.Node[i].Visible)
          or (HideTopLevel and Items.Node[i].IsTopLevel) then Continue;

        DrawItem(Items.Node[i]);

        Inc(ItemTop, GetItemHeight(Items.Node[i]));

        if poGrid in Options then
        begin
          DrawGrid;
          Inc(ItemTop);
        end;

        if Items.Node[i].Level > 1 then Inc(Indent, spaMargin);
        if ItemTop >= ClientHeight then Exit;
      end;
    end;
  end;

begin
  inherited;
  if FUpdateCount > 0 then Exit;
  if csReading in ComponentState then Exit;
  Indent := 0;

  Canvas.Font.Assign(Self.Font);

  ItemTop := 0;

  Inc(Indent, spaMargin);
  with Canvas do
  begin
    DrawItems;
    Brush.Color := Self.Color;
    FillRect(Rect(0, ItemTop, ClientWidth, ClientHeight));
  end;
end;

procedure TNxCustomInspector.PushItem(Item: TNxPropertyItem;
  const Value: Boolean);
var
  DeltaY: Integer;
  ScrollRect, RedrawRect: TRect;
begin
  ScrollRect := Rect(0, Item.Top, ClientWidth, ClientHeight);
  RedrawRect := ScrollRect;
  Inc(RedrawRect.Top, GetItemHeight(Item) + GetGridSpace);
  DeltaY := GetItemHeight(Item) + GetGridSpace;
  if not Value then DeltaY := -DeltaY;
  ScrollWindowEx(Handle, 0, DeltaY, nil, @ScrollRect, 0, @RedrawRect, SW_INVALIDATE);
end;

procedure TNxCustomInspector.RedrawBorder;
const
  DataName: PWideChar = 'listview';
var
  Theme: THandle;
  DC: HDC;
  R, R1: TRect;
begin
  if IsThemed and (BorderStyle <> bsNone) then
	begin
	  DC := GetWindowDC(Handle);
    GetWindowRect(Handle, R);
	  OffsetRect(R, -R.Left, -R.Top);
	  Theme := OpenThemeData(Handle, DataName);
    R1 := R;
	  InflateRect(R1, -1, -1);
	  ExcludeClipRect(DC, R1.Left, R1.Top, R1.Right, R1.Bottom);
	  DrawThemeBackground(Theme, DC, 1, 0, R, @R);
	  ReleaseDC(Handle, DC);
	end;
end;

function TNxCustomInspector.GetItemAtPos(
  APoint: TPoint): TNxPropertyItem;
var
  Y, i, ItemHeight: Integer;
begin
//to-do implement scrolling
  Y := 0;
  for i := FirstItem to FItems.NodesCount - 1 do
  begin
    ItemHeight := GetItemHeight(FItems.Node[i]);
    Result := FItems.Node[i];
    if (not Result.Hidden) and Result.Visible
      and ((not HideTopLevel) or (not Result.IsTopLevel)) then
    begin
      if (APoint.Y >= Y) and (APoint.Y < Y + ItemHeight + GetGridSpace)
        then Exit;
      Inc(Y, ItemHeight + GetGridSpace);
    end;
  end;
  Result := nil;
end;

function TNxCustomInspector.GetItemHeight(AItem: TNxPropertyItem): Integer;
begin
  if AItem.ItemHeight = 0 then Result := FRowHeight else Result := AItem.ItemHeight;
end;

procedure TNxCustomInspector.RefreshEditingItem;
var
  EditRect: TRect;
begin
  if Assigned(EditingItem) and Assigned(EditingItem.Editor) then
  begin
    EditRect := Rect(SplitterPosition + 1, EditingItem.Top, ClientWidth, EditingItem.Top + GetItemHeight(EditingItem));
    if EditingItem.ShowSuffix then EditRect.Right := GetItemSuffixRect(EditingItem).Left;    
    EditingItem.Editor.SetBounds(EditRect.Left, EditRect.Top, EditRect.Right - EditRect.Left, GetItemHeight(EditingItem));
  end;
end;

procedure TNxCustomInspector.RefreshItem(Item: TNxPropertyItem;
  ItemPart: TPropertyItemPart);
var
  ARect: TRect;
  ItemTop, ItemHeight: Integer;
begin
  if Assigned(Item) and Item.Visible then
  begin
    ItemTop := Item.Top;
    ItemHeight := GetItemHeight(Item);
    case ItemPart of
      ipAll: ARect := Rect(0, ItemTop, ClientWidth, ItemTop + ItemHeight);
      ipButton: ARect := Rect(Item.Indent, ItemTop, Item.Indent + spaMargin, ItemTop + ItemHeight);
      ipCaption: ARect := Rect(spaMargin, ItemTop, SplitterPosition, ItemTop + ItemHeight);
      ipValue: ARect := Rect(SplitterPosition + 1, ItemTop, ClientWidth, ItemTop + ItemHeight);
      ipSuffix: ARect := Rect(ClientWidth - SuffixWidth, ItemTop, ClientWidth, ItemTop + ItemHeight);
    end;
    InvalidateRect(Handle, @ARect, False);
  end;
end;

procedure TNxCustomInspector.RefreshItemCaption(Item: TNxPropertyItem);
begin
  if Assigned(Item) then
  begin
    if Item.IsTopLevel then RefreshItem(Item)
      else RefreshItem(Item, ipCaption);
  end;
end;

procedure TNxCustomInspector.RefreshSelectedItem;
var
  ItemTop: Integer;
  ItemRect: TRect;
begin
  if Assigned(FSelectedItem) then
  begin
    ItemTop := FSelectedItem.Top;
    ItemRect := Rect(spaMargin, ItemTop, SplitterPosition,
      ItemTop + GetItemHeight(FSelectedItem));
    InvalidateRect(Handle, @ItemRect, False);
  end;
end;

procedure TNxCustomInspector.RefreshToolbarButton(
  AItem: TNxPropertyItem; ButtonIndex: Integer);
var
  BtnRect: TRect;
  BtnLeft, BtnTop: Integer;
begin
  with AItem as TNxToolbarItem do
  begin
    BtnLeft := 0;
    BtnTop := AItem.Top;
    case Alignment of
      baLeftJustify: BtnLeft := SplitterPosition + 1 + ButtonIndex * ButtonWidth;
      baRightJustify: BtnLeft := ClientWidth - ButtonWidth - (((Count - 1) - ButtonIndex) * ButtonWidth);
    end;
    BtnRect := Rect(BtnLeft, BtnTop, BtnLeft + ButtonWidth, BtnTop + GetItemHeight(AItem));
  end;
  InvalidateRect(Handle, @BtnRect, False);
end;

procedure TNxCustomInspector.RefreshToolbarText(
  AItem: TNxPropertyItem);
var
  TxtRect: TRect;
begin
  with AItem as TNxToolbarItem do
    if ShowText then
    begin
      TxtRect := Rect(Count * GetToolbarButtonWidth + 2, AItem.Top, ClientWidth, AItem.Top + GetItemHeight(AItem));
      InvalidateRect(Handle, @TxtRect, False);
    end;
end;

procedure TNxCustomInspector.ShowItemHint(Item: TNxPropertyItem);
var
  HintRect: TRect;
  MousePoint: TPoint;
begin
  RecreateHintWnd;
  if Assigned(Item) and Item.ShowHint and (Length(Item.Hint) > 0) then
  begin
    FHintTimer.Enabled := False;
    HintRect := FHintWindow.CalcHintRect(ClientWidth, Item.Hint, nil);
    GetCursorPos(MousePoint);
    OffsetRect(HintRect, MousePoint.X, MousePoint.Y);
    FHintWindow.ActivateHint(HintRect, Item.Hint);
    FHintHideTimer.Enabled := True;
  end;
end;

procedure TNxCustomInspector.UpdateScrollBar;
var
  ScrollMax, PageSize: Integer;

  function GetFirstVisibleRowNumber:integer;
  var
   i: Integer;
  begin
    Result := 0;
    for i := 0 to FFirstItem - 1 do
    begin
      if GetItemVisible(i) then Inc(result);
    end;
  end;
begin
  if csDestroying in ComponentState then Exit;
  ScrollMax := GetVisibleCount;
  PageSize := GetViewCount;

  if ScrollMax > PageSize then
  begin
    VertScrollBar.Max := ScrollMax;
    VertScrollBar.PageSize := PageSize + 1;
    VertScrollBar.LargeChange := VertScrollBar.PageSize;
  end else VertScrollBar.Max := 0;

  if ScrollMax <= PageSize + 1 then
     VertScrollbar.Position := GetFirstVisibleRowNumber;
end;

procedure TNxCustomInspector.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages)
    then Images := nil;
  if (Operation = opRemove) and (AComponent = FAssociate)
    then Associate := nil;
end;

procedure TNxCustomInspector.ValueChanged(Item: TNxPropertyItem;
  const Value: WideString);
begin

end;

procedure TNxCustomInspector.CMDesignHitTest(
  var Message: TCMDesignHitTest);
var
  CursorPoint: TPoint;
  AItem: TNxPropertyItem;
begin
  Message.Result := 0;
  GetCursorPos(CursorPoint);
  CursorPoint := ScreenToClient(CursorPoint);
  AItem := GetItemAtPos(CursorPoint);
  if (AItem = nil) or (AItem.Count = 0) then Exit;
  if (CursorPoint.X > AItem.Indent) and (CursorPoint.X < AItem.Indent + spaMargin)
	  then Message.Result := 1;
end;

procedure TNxCustomInspector.CMFontChanged(var Message: TMessage);
begin
  inherited;
end;

procedure TNxCustomInspector.WMSize(var Message: TWMSize);
var
	r: TRect;
begin
	inherited;
  if FOldHeight <> Height then
  begin
    r := Rect(0, ClientHeight - (ClientHeight - FOldHeight), ClientWidth, ClientHeight);
    InvalidateRect(Handle, @r, False);
    FOldHeight := ClientHeight;
  end;
	if FOldWidth <> Width then
  begin
    r := Rect(ClientWidth - (ClientWidth - FOldWidth), 0, ClientWidth, ClientHeight);
    InvalidateRect(Handle, @r, False);
    FOldWidth := ClientWidth;
  end;
  RefreshEditingItem;
  UpdateScrollBar;
  VertScrollClipRect := ClientRect;
end;

procedure TNxCustomInspector.WMVScroll(var Message: TWMVScroll);
var
  CursorPoint: TPoint;
begin
  EndEditing;

	inherited;

  { Update HoverItem AFTER scrolling }
  GetCursorPos(CursorPoint);
  CursorPoint := ScreenToClient(CursorPoint);
  MouseMove([], CursorPoint.X, CursorPoint.Y);

  { Update vert scrollbar }
  UpdateScrollBar;

  Invalidate;
end;

function TNxCustomInspector.FindNextItem(
  Item: TNxPropertyItem): TNxPropertyItem;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(Item) then
  begin
    for i := Item.NodeIndex + 1 to FItems.NodesCount - 1 do
    begin
      if (not FItems.Node[i].Hidden) and (FItems.Node[i].Visible)
        and ((not HideTopLevel) or (not FItems.Node[i].IsTopLevel))
        and (FItems.Node[i].Enabled) and FItems.Node[i].TabStop  then
      begin
        Result := FItems.Node[i];
        Break;
      end;
    end;
  end;
end;

function TNxCustomInspector.FindPrevItem(
  Item: TNxPropertyItem): TNxPropertyItem;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(Item) then
  begin
    for i := Item.NodeIndex - 1 downto 0 do
    begin
      if (not FItems.Node[i].Hidden) and (FItems.Node[i].Visible)
        and ((not HideTopLevel) or (not FItems.Node[i].IsTopLevel))
        and Fitems.Node[i].Enabled and FItems.Node[i].TabStop then
      begin
        Result := FItems.Node[i];
        Break;
      end;
    end;
  end;
end;

procedure TNxCustomInspector.EditItem(Item: TNxPropertyItem; Focus: Boolean);
var
  EditWidth, EditTop: Integer;
begin
  if csDesigning in ComponentState then Exit;
  if Item <> FEditingItem then
  begin
    if Assigned(FEditingItem) then
    begin
      if FEditingItem = Item then Exit;
      if Assigned(FEditingItem.Editor) then
      begin
        FEditingItem.Editor.OnDblClick := nil;
        FEditingItem.Editor.OnChange := nil;
        FEditingItem.Editor.OnKeyDown := nil;
        FEditingItem.Editor.OnKeyUp := nil;
        FEditingItem.Editor.OnKeyPress := nil;
      end;
      FEditingItem.EndEditing;
    end;

    Item.PrepareEditing;

    if Assigned(Item.Editor) and Item.Enabled and Item.Visible
      and not Item.ReadOnly and Item.IsEditable and Item.IsDisplayed then
    begin
      FEditingItem := Item;
      FHintWindow.ReleaseHandle;
      EditWidth := ClientWidth - SplitterPosition - 1;
      if Item.ShowSuffix then Dec(EditWidth, SuffixWidth);
      with Item.Editor do
      begin
        AutoSize := True;
        Parent := Self;
        BorderStyle := bsNone;
        EditMargins.Left := 2;
        BorderWidth := 1;

        EditorUpdating := True; { do not fire inplace edit events }

        ShowWindow(Handle, SW_HIDE);
        EditTop := Item.Top;

    		SetWindowPos(Handle, HWND_TOP, SplitterPosition + 1, EditTop, EditWidth, GetItemHeight(Item),
          SWP_SHOWWINDOW or SWP_NOREDRAW);

        Item.BeginEditing;
        Item.UpdateEditor;
      end;
      with Item.Editor do
      begin
        OnDblClick := FOnEditDblClick;
        OnChange := DoItemEditorEdit;
        OnKeyDown := DoItemEditorKeyDown;
        OnKeyPress := Self.OnKeyPress;
        OnKeyUp := Self.OnKeyUp;
        OnExit := DoItemEditorExit;
        WantTabs := Self.WantTabs;
      end;
      Item.Editor.EditorUpdating := False;
      Windows.SetFocus(Item.Editor.Handle);
    end else
    begin
      if Assigned(FEditingItem) then
      begin
        FEditingItem.EndEditing;
        FEditingItem := nil;
      end;
      Windows.SetFocus(Self.Handle);
    end;
  end;
end;

procedure TNxCustomInspector.EndEditing;
begin
  if Assigned(FEditingItem) then
  begin
    FEditingItem.EndEditing;
    FEditingItem := nil;
  end;
  if Assigned(FSuffixEditingItem) then
  begin
    FSuffixEditingItem.HideSuffix;
    FSuffixEditingItem := nil;
  end;
end;

procedure TNxCustomInspector.InvalidateItem(Item: TNxPropertyItem;
  Grid: Boolean);
var
  R: TRect;
  Y: Integer;
begin
  Y := Item.Top;
  R := Rect(0, Y, ClientWidth, Y + GetItemHeight(Item));
  if Grid then Inc(R.Bottom, GetGridSpace);
  InvalidateRect(Handle, @R, False);
end;

function TNxCustomInspector.GetChildOwner: TComponent;
begin
  Result := nil;
end;

procedure TNxCustomInspector.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
var
  i: Integer;
begin
  inherited;
	{ this will save items as childrens into dfm }
  for i := 0 to FItems.Count - 1 do
    if FItems[i].ParentItem = nil then Proc(FItems[i]);
end;

procedure TNxCustomInspector.HideItemHint;
begin
  FHintWindow.ReleaseHandle;
  FHintTimer.Enabled := False;
  FHintHideTimer.Enabled := False;
  FHintItem := nil;
end;

function TNxCustomInspector.GetToolbarButtonWidth: Integer;
begin
  Result := FRowHeight + 1;
end;

procedure TNxCustomInspector.DoEnter;
begin
  inherited;
  RefreshItem(SelectedItem, ipMargin);
  RefreshItem(SelectedItem, ipCaption);
end;

procedure TNxCustomInspector.DoExit;
begin
  inherited;
  if not FEscapePressed then ApplyTextBox;
  RefreshItem(SelectedItem, ipCaption);
  RefreshItem(SelectedItem, ipMargin);
end;

procedure TNxCustomInspector.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
  if WantTabs then Message.Result := Message.Result or DLGC_WANTTAB
  else Message.Result := Message.Result and not DLGC_WANTTAB;
end;

procedure TNxCustomInspector.WMKillFocus(var Message: TWMSetFocus);
begin
	inherited;
  RefreshSelectedItem;
  HideItemHint;
end;

procedure TNxCustomInspector.WMNCPaint(var Message: TMessage);
begin
  inherited;
  RedrawBorder;
end;

procedure TNxCustomInspector.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if FSelectedItem = nil then SelectFirst;
end;

procedure TNxCustomInspector.DoItemEditorEdit(Sender: TObject);
var
  Accept: Boolean;
begin
  if not Assigned(FEditingItem) then Exit;
  with Sender as TNxCustomEdit do
  begin
    if itoAutoApply in FEditingItem.Options then
      FEditingItem.Value := Text;
    DoEdit(FEditingItem, AsString, Accept);
  end;
end;

procedure TNxCustomInspector.DoItemEditorExit(Sender: TObject);
begin
  DoExit;
end;

procedure TNxCustomInspector.ScrollTo(const Index: Integer);
var
  Delta, ATop, ItemHeight, i: Integer;
begin
  ATop := Items.Node[Index].Top;
  ItemHeight := GetItemHeight(Items.Node[Index]);

  { Check if item is already in view }
  if InRange(ATop, 0, ClientHeight) then
  begin
    if ATop + ItemHeight + GetGridSpace > ClientHeight then VertScrollBar.Next;
    Exit;
  end;

  Delta := 0;

  if Index >= GetLastItem then
  begin
    i := GetLastItem;
    while (i < Index - 1) and (i < Items.NodesCount) do
    begin
      if GetItemVisible(i) then Inc(Delta);
      Inc(i);
    end;
    VertScrollBar.MoveBy(Delta);
  end
  else if Index < FirstItem then
  begin
    for i := FirstItem downto Index + 1 do
    begin
      if GetItemVisible(i) then Dec(Delta);
    end;
    VertScrollBar.MoveBy(Delta);
  end;
end;

procedure TNxCustomInspector.SelectNext;
var
  AItem: TNxPropertyItem;
begin
  AItem := FindNextItem(SelectedItem);
  if Assigned(AItem) then SelectedItem := AItem;
end;

procedure TNxCustomInspector.SelectFirst;
var
  i: Integer;
begin
  for i := 0 to FItems.NodesCount - 1 do
  begin
    if (not FItems.Node[i].Hidden) and (FItems.Node[i].Visible)
      and ((not HideTopLevel) or (not FItems.Node[i].IsTopLevel)) then
    begin
      SelectedItem := FItems.Node[i];
      Break;
    end;
  end;
end;

procedure TNxCustomInspector.SelectLast;
var
  i: Integer;
begin
  for i := FItems.NodesCount - 1 downto 0 do
  begin
    if (not FItems.Node[i].Hidden) and (FItems.Node[i].Visible)
      and ((not HideTopLevel) or (not FItems.Node[i].IsTopLevel)) then
    begin
      SelectedItem := FItems.Node[i];
      Break;
    end;
  end;
end;

procedure TNxCustomInspector.SelectPrev;
var
  AItem: TNxPropertyItem;
begin
  AItem := FindPrevItem(SelectedItem);
  if Assigned(AItem) then SelectedItem := AItem;
end;

procedure TNxCustomInspector.LoadProperties(ParentItem: TNxPropertyItem);
  procedure RollProperties(RollObject: TObject; AItem: TNxPropertyItem);
  var
    PropCount, i: Integer;
    TempList: PPropList;
    AClass: TClass;
    AObj: TObject;
    ClassItem: TNxPropertyItem;
    AItemClass: TNxItemClass;
  begin
    PropCount := GetPropList(RollObject.ClassInfo, [tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
      tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
        tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray], nil);

    GetMem(TempList, PropCount * SizeOf(Pointer));

    GetPropList(RollObject.ClassInfo, [tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
      tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
        tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray], TempList);

    for i := 0 to PropCount - 1 do
    begin
      case PropType(RollObject, TempList[i]^.Name) of
        tkClass:  begin
                    AClass := GetObjectPropClass(RollObject, TempList[i]);
                    AObj := GetObjectProp(RollObject, TempList[i], AClass);
                    if Assigned(AObj) then
                    begin
                      ClassItem := FItems.AddChild(AItem, TNxTextItem, TempList[i]^.Name);
                      if AItem.MapProperty <> '' then ClassItem.MapProperty := AItem.MapProperty + '.';
                      ClassItem.MapProperty := ClassItem.MapProperty + TempList[i]^.Name; 
                      RollProperties(AObj, ClassItem);
                    end;
                    AItemClass := nil;
                  end;
        tkString, tkWString, tkLString,
        tkWChar, tkChar, tkVariant: AItemClass := TNxTextItem;
        tkInteger, tkFloat, tkInt64: AItemClass := TNxSpinItem;
        tkEnumeration: AItemClass := TNxComboBoxItem;
        tkSet: AItemClass := TNxToolbarItem;
        else AItemClass := TNxTextItem;
      end;
      if AItemClass <> nil then
      begin
        with FItems.AddChild(AItem, AItemClass, TempList[i]^.Name) do
        begin
          Value := GetPropValue(RollObject, TempList[i]^.Name, True);
          if AItem.MapProperty <> '' then MapProperty := AItem.MapProperty + '.';
          MapProperty := MapProperty + TempList[i]^.Name;
        end;
      end;
    end;       
    FreeMem(TempList);
  end;
begin
  if Assigned(FAssociate) then RollProperties(FAssociate, ParentItem);
end;

procedure TNxCustomInspector.PaintItems;
var
  i,y: Integer;
  r: TRect;
begin
  y :=0;
  for i := 0 to FItems.Count - 1 do
  begin
    r := rect(0, y, ClientWidth, y + 20);
    Canvas.TextRect(r, 0,y,IntToStr(FItems.Item[i].Top));
    inc(y,20);
  end;
end;

procedure TNxCustomInspector.SaveToXML(const FileName: string);
var
  Strings: TStringList;
  i, Level: Integer;

  function Tab(Level: Integer): string;
  var
    i: Integer;
  begin
    for i := 0 to Level do
    begin
      Result := Result + #9;
    end;
  end;

  procedure SaveItems;
  var
    s: string;
  begin
    while i < Items.Count do
    begin
      s := '';
      s := Tab(Items[i].Level);
      if i < Items.Count then
        if (Items[i].Level < Level) then
        begin
          Level := Items[i].Level;
          Exit;       
        end;
      if Items[i].Count > 0 then
      begin
        Strings.Add(s + '<Item Caption="' + Items[i].Caption + '" Value="' + Items[i].Value + '"' + ' ItemType="' + Items[i].ClassName + '">');
        Inc(i);
        Level := Items[i].Level;
        SaveItems;
        Strings.Add(s + '</Item>');
      end else
      begin
        Strings.Add(s + '<Item Caption="' + Items[i].Caption + '" Value="' + Items[i].Value + '"' + ' ItemType="' + Items[i].ClassName + '" />');
        Inc(i);
      end;
    end;
  end;

begin
  Strings := TStringList.Create;
  Strings.Add('<?xml version="1.0" encoding="UTF-8"?>');
  Strings.Add('<PropertyItems>');
  i := 0;
  Level := 0;
  SaveItems;
  Strings.Add('</PropertyItems>');
  ShowMessage(Strings.Text);
  Strings.SaveToFile(FileName);
  FreeAndNil(Strings);
end;

procedure TNxCustomInspector.SetVersion(const Value: string);
begin
  FVersion := value;
end;

procedure TNxCustomInspector.RecreateHintWnd;
begin
  if FHintWindow <> nil then
  begin
    if FHintWindow is HintWindowClass then Exit;
    FHintWindow.Free;
  end;
  FHintWindow := HintWindowClass.Create(Self);
  FHintWindow.Color := Application.HintColor;
end;

end.
