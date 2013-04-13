{$I NxSuite.inc}

unit NxClasses;

interface

uses
  Classes, Types, Windows, Controls, Graphics, StdCtrls, ComCtrls
  {$IFDEF TNTUNICODE}, TntClasses, TntControls, TntStdCtrls{$ENDIF};

const
  exIndexOutOfBounds = 'Index out of bounds (%d) for %s.';

type
  TAddPosition = (apFirst, apLast);
  TButtonEdge = (beClient, beLeft, beRight);
  TButtonState = set of (btHover, btDown);
  TDataKind = (dkString, dkFloat, dkInteger);
  TDirection = (diLeftToRight, diRightToLeft);
  //type used in SaveToXML method of NxGrid { supported unicode encodings }
  TUniEncoding = (enUnspecified, enISO_8859_1, enUTF_16, enUTF_8);
  TEncodingKind = (ekAnsi, ekUnicode, ekUnicodeBigEndian);
  TFillPaintStyle = (fsSolid, fsHorzGradient, fsVertGradient, fsGlass);
  TItemsDisplayMode = (dmDefault, dmNameList, dmValueList, dmIndentList);
  TMouseAction = (maMouseDown, maMouseMove, maMouseUp);
  TPrintUnit = (puCentimeter, puMillimeter, puInch, puPixel);
  TStartDayOfWeek = (dwAutomatic, dwMonday, dwSunday);
  TTreeItemState = set of (tisAdded);
  TTextAngle = -90..90;
  TWideFile = file of WideChar;

  TCellPosition = record
    Col: Integer;
    Row: Integer;
  end;

  TIndent = record
    Left: Integer;
    Top: Integer;
  end;

  TOrientation = (orHorizontal, orVertical);

{$IFNDEF D2005UP}
  TVerticalAlignment = (taAlignTop, taAlignBottom, taVerticalCenter);
{$ENDIF}
  TWrapKind = (wkNone, wkEllipsis, wkPathEllipsis, wkWordWrap);

{$IFDEF TNTUNICODE}
  TChar = WideChar;
  TString = WideString;
  TNxStrings = TTntStrings;
  TNxStringList = TTntStringList;
  TNxEditControl = class(TTntCustomEdit);
{$ELSE}
  TChar = Char;
  TString = string;
  TNxStrings = TStrings;
  TNxStringList = TStringList;
  TNxEditControl = TCustomEdit;
{$ENDIF}

  TNxHtmlClickEvent = procedure(Sender: TObject; Href: WideString) of object;

  TNxTreeNodes = class;
  TNxTreeNode = class;

  TNxTreeNodeClass = class of TNxTreeNode;

  TNxTreeNode = class(TPersistent)
  private
    FCount: Integer;
    FData: Pointer;
    FExpanded: Boolean;
    FHidden: Boolean;
    FItems: TNxTreeNodes;
    FLevel: Integer;
    FParent: TNxTreeNode;
    FState: TTreeItemState;
    FText: WideString;
    FTree: TNxTreeNodes;
    FVisible: Boolean;
    FTag: Longint;
    function GetAbsoluteIndex: Integer;
    procedure SetCount(const Value: Integer);
    procedure SetData(const Value: Pointer);
    procedure SetExpanded(const Value: Boolean);
    procedure SetItems(const Value: TNxTreeNodes);
    procedure SetLevel(const Value: Integer);
    procedure SetParent(const Value: TNxTreeNode);
    procedure SetText(const Value: WideString);
    function GetItem(Index: Integer): TNxTreeNode;
    function GetHasChildren: Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetFirstSibling: TNxTreeNode;
    function GetLastSibling: TNxTreeNode;
    property HasChildren: Boolean read GetHasChildren;
    procedure MoveTo(Destination: TNxTreeNode; Mode: TNodeAttachMode);
    property AbsoluteIndex: Integer read GetAbsoluteIndex;
    property Count: Integer read FCount;
    property Data: Pointer read FData write SetData;
    property Hidden: Boolean read FHidden;
    property Item[Index: Integer]: TNxTreeNode read GetItem;
    property Items: TNxTreeNodes read FItems;
    property Level: Integer read FLevel;
    property Parent: TNxTreeNode read FParent;
    property State: TTreeItemState read FState;
  published
    property Expanded: Boolean read FExpanded write SetExpanded;
    property Tag: Longint read FTag write FTag default 0;
    property Text: WideString read FText write SetText;
  end;

  TNxNodeNotifyEvent = procedure(Sender: TObject; Item: TNxTreeNode) of object;

  TNxTreeNodes = class
  private
    FList: TList;
    FOnDeleted: TNxNodeNotifyEvent;
    FOwner: TComponent;
    FTopLevelCount: Integer;
    procedure Expand(AItem: TNxTreeNode; const Value: Boolean);
    function GetCount: Integer;
    procedure SetParent(Item, Parent: TNxTreeNode);
    function GetEmpty: Boolean;
  protected
    procedure DoAdded(Item: TNxTreeNode); dynamic;
    procedure DoDeleted(Item: TNxTreeNode); dynamic;
    function GetChildCount(Item: TNxTreeNode): Integer;
    function GetItem(Index: Integer): TNxTreeNode;
    function GetTreeNodeClass: TNxTreeNodeClass; virtual;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function GetChildNode(Parent: TNxTreeNode; Index: Integer): TNxTreeNode;
    function GetItemCount(Item: TNxTreeNode): Integer;
    function GetNodeOf(Data: Pointer): TNxTreeNode;
    function AddChild(Parent: TNxTreeNode): TNxTreeNode;
    procedure AddItem(Parent, Item: TNxTreeNode; Position: TAddPosition = apLast);
		procedure Clear;
    procedure ClearChildren(const AItem: TNxTreeNode);
    procedure Delete(Index: Integer);
    function Find(Data: Pointer): TNxTreeNode;
    function Insert(Item: TNxTreeNode; const S: WideString): TNxTreeNode;
    property Item[Index: Integer]: TNxTreeNode read GetItem;
    procedure MoveItem(Destination, Item: TNxTreeNode; CurIndex, NewIndex:
      Integer; Sibling: Boolean);
    procedure Remove(Item: TNxTreeNode);
    procedure Sort;
    property Count: Integer read GetCount;
    property Empty: Boolean read GetEmpty;
    property OnDeleted: TNxNodeNotifyEvent read FOnDeleted write FOnDeleted;
  end;

  TNxObjectTreeNodes = class;

  TNxObjectTreeNode = class(TComponent)
  private
    FCount: Integer;
    FExpanded: Boolean;
    FHidden: Boolean;
    FItems: TNxObjectTreeNodes;
    FLevel: Integer;
    FParent: TNxObjectTreeNode;
    FTag: Longint;
    FText: WideString;
    procedure SetCount(const Value: Integer);
    procedure SetItems(const Value: TNxObjectTreeNodes);
    procedure SetLevel(const Value: Integer);
    procedure SetParent(const Value: TNxObjectTreeNode);
    function GetAbsoluteIndex: Integer;
    procedure SetExpanded(const Value: Boolean);
    procedure SetText(const Value: WideString);
    function GetTopLevel: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MoveTo(Destination: TNxObjectTreeNode; Mode: TNodeAttachMode);
    property AbsoluteIndex: Integer read GetAbsoluteIndex;
    property Count: Integer read FCount;
    property Level: Integer read FLevel;
    property Items: TNxObjectTreeNodes read FItems;
    property Parent: TNxObjectTreeNode read FParent;
    property TopLevel: Boolean read GetTopLevel;
  published
    property Expanded: Boolean read FExpanded write SetExpanded;
    property Tag: Longint read FTag write FTag default 0;
    property Text: WideString read FText write SetText;
  end;

  TNxObjectTreeNodes = class
  private
    FList: TList;
    FTopLevelCount: Integer;
    procedure SetParent(Item, Parent: TNxObjectTreeNode);
    function GetCount: Integer;
    function GetItem(Index: Integer): TNxObjectTreeNode;
  protected
    function GetChildCount(Item: TNxObjectTreeNode): Integer;
  public
		procedure Clear;
    constructor Create;
    destructor Destroy; override;
    procedure AddAfter(Source, Target: TNxObjectTreeNode);
    procedure AddItem(Parent, Item: TNxObjectTreeNode; Position: TAddPosition = apLast); virtual;
    procedure Insert(Before, Item: TNxObjectTreeNode; const S: WideString);
    procedure Remove(Item: TNxObjectTreeNode);
    property Count: Integer read GetCount;
    property Item[Index: Integer]: TNxObjectTreeNode read GetItem;
  end;

  TNxLocalizer = class(TComponent)
  private
    procedure SetTodayCaption(const Value: WideString);
    procedure SetNoneCaption(const Value: WideString);
    function GetNoneCaption: WideString;
    function GetTodayCaption: WideString;
    function GetStartDay: TStartDayOfWeek;
    procedure SetStartDay(const Value: TStartDayOfWeek);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property NoneCaption: WideString read GetNoneCaption write SetNoneCaption stored False;
    property StartDay: TStartDayOfWeek read GetStartDay write SetStartDay stored False;
    property TodayCaption: WideString read GetTodayCaption write SetTodayCaption stored False;
  end;

  procedure ActivateHint(HintWindow: THintWindow; Rect: TRect; const AHint: WideString);
  function CalcHintRect(HintWindow: THintWindow; MaxWidth: Integer; const AHint: WideString): TRect;
  procedure DeactivateHint(var HintWindow: THintWindow);
  function GetDataKind(S: string): TDataKind;
  function GetTextHeight(Canvas: TCanvas; const Text: WideString): Integer;
  function GetMultilineTextWidth(Canvas: TCanvas; const Text: WideString): Integer;
  function GetTextWidth(Canvas: TCanvas; const Text: WideString): Integer;
  function GetValidNumber(S: string; AllowFloat, AllowSigns: Boolean; Min, Max: Double): Double;
  procedure Exchange(var N1: Integer; var N2: Integer);
  function Indent(Left, Top: Integer): TIndent;
  function ParentFormActive(Control: TControl): Boolean;
  procedure ResizeRect(var R: TRect; DeltaLeft, DeltaTop, DeltaRight, DeltaBottom: Integer);
  procedure SetRange(var Value: Integer; Min, Max: Integer);

var
  TodayCaption: string = 'Today';
  NoneCaption: string = 'None';
  StartDay: TStartDayOfWeek = dwSunday;
  UnicodeSupported: Boolean;

implementation

uses
  Forms, Dialogs, SysUtils, Math;

procedure ActivateHint(HintWindow: THintWindow; Rect: TRect;
  const AHint: WideString);
begin
  if HintWindow = nil then Exit;
{$IFDEF TNTUNICODE}
  if HintWindow is TTntHintWindow then
  begin
    (HintWindow as TTntHintWindow).ActivateHint(Rect, AHint);
  end else HintWindow.ActivateHint(Rect, AHint);
{$ELSE}
  HintWindow.ActivateHint(Rect, AHint);
{$ENDIF}
end;

function CalcHintRect(HintWindow: THintWindow; MaxWidth: Integer;
  const AHint: WideString): TRect;
begin
{$IFDEF TNTUNICODE}
  if HintWindow is TTntHintWindow then
  begin
    Result := (HintWindow as TTntHintWindow).CalcHintRect(MaxWidth, AHint, nil);
  end else Result := HintWindow.CalcHintRect(MaxWidth, AHint, nil);
{$ELSE}
  Result := HintWindow.CalcHintRect(MaxWidth, AHint, nil);
{$ENDIF}
end;

procedure DeactivateHint(var HintWindow: THintWindow);
begin
  if HintWindow <> nil then HintWindow.ReleaseHandle;
end;

procedure Exchange(var N1: Integer; var N2: Integer);
var
  T: Integer;
begin
  T := N1;
  N1 := N2;
  N2 := T;
end;

function GetDataKind(S: string): TDataKind;
var
  i, Signs: Integer;
  Check: set of (isInt, isFloat);
begin
  Signs := 0;
  Check := [isInt, isFloat];
  for i := 1 to Length(S) do
  begin
    if not (S[i] in ['0'..'9', DecimalSeparator, '-', '+'])
      or ((S[i] in ['-', '+']) and (i > 1)) then
    begin
      Check := [];
    end else
    begin
      if S[i] = DecimalSeparator then
      begin
        Exclude(Check, isInt);
        Inc(Signs);
        if Signs > 1 then Exclude(Check, isFloat);
      end;
    end;
  end;
  if isInt in Check then Result := dkInteger
  else if isFloat in Check then Result := dkFloat
  else Result := dkString;
end;

function TextExtent(Canvas: TCanvas; const Text: WideString): TSize;
begin
  Result.cX := 0;
  Result.cY := 0;
  Windows.GetTextExtentPoint32W(Canvas.Handle, PWideChar(Text), Length(Text), Result);
end;

function GetTextHeight(Canvas: TCanvas; const Text: WideString): Integer;
begin
  if UnicodeSupported then
    Result := TextExtent(Canvas, Text).cy
  else Result := Canvas.TextHeight(Text);
end;

function GetMultilineTextWidth(Canvas: TCanvas; const Text: WideString): Integer;
var
  CR: TRect;
  StringText: string;
  Flags: Integer;
begin
  Flags := DT_TOP or DT_LEFT;
  StringText := Text;
  if UnicodeSupported then
    DrawTextExW(Canvas.Handle, PWideChar(Text), -1, CR, Flags or DT_CALCRECT, nil)
      {$IFDEF DELPHI2009}
      else Windows.DrawTextEx(Canvas.Handle, PWideChar(Text), -1, CR, Flags or DT_CALCRECT, nil);
      {$ElSE}
      else Windows.DrawTextEx(Canvas.Handle, PAnsiChar(StringText), -1, CR, Flags or DT_CALCRECT, nil);
      {$ENDIF}
  Result := CR.Right - CR.Left;
end;

function GetTextWidth(Canvas: TCanvas; const Text: WideString): Integer;
begin
  if UnicodeSupported then
    Result := TextExtent(Canvas, Text).cx
  else Result := Canvas.TextWidth(Text);
end;

function Indent(Left, Top: Integer): TIndent;
begin
  Result.Left := Left;
  Result.Top := Top;
end;

function ParentFormActive(Control: TControl): Boolean;
begin
  Result := Assigned(GetParentForm(Control)) and (GetParentForm(Control).Active);
end;

procedure ResizeRect(var R: TRect; DeltaLeft, DeltaTop, DeltaRight,
  DeltaBottom: Integer);
begin
  with R do
  begin
    Inc(Left, DeltaLeft);
    Inc(Top, DeltaTop);
    Inc(Right, DeltaRight);
    Inc(Bottom, DeltaBottom);
  end;
end;

procedure SetRange(var Value: Integer; Min, Max: Integer);
begin
  if Value < Min then Value := Min;
  if Value > Max then Value := Max;
end;

function GetValidNumber(S: string; AllowFloat, AllowSigns: Boolean; Min, Max: Double): Double;
var
  i: Integer;
  CanInc: Boolean;
  HaveDecimalSeparator: Boolean;
begin
  i := 1;
  CanInc := True;
  HaveDecimalSeparator := False;

  repeat
    if S[i] in ['0'..'9', DecimalSeparator, '-', '+', #8] then
    begin

      { Decimal Separator }
      if S[i] = DecimalSeparator then
      begin
        if not AllowFloat or HaveDecimalSeparator then
        begin
          Delete(S, i, 1);
          CanInc := False;
        end;
        if not HaveDecimalSeparator then HaveDecimalSeparator := True;
      end;

      { Signs }
      if (S[i] in ['-', '+']) then
      begin
        if (not AllowSigns) or (i > 1) then
        begin
          Delete(S, i, 1);
          CanInc := False;
        end;

      end;

      if CanInc then Inc(i) else if not CanInc then CanInc := not CanInc;

    end else Delete(S, i, 1)
  until i = Length(S) + 1;
  if (S = '-') or (S = '+') or (S = '') then S := '0';

  Result := StrToFloat(S);
  
  { adjust using max and min }
  if (Max <> 0) or (Min <> 0) then
  begin
    if Result > Max then Result := Max;
    if Result < Min then Result := Min;
  end;
end;

{ TNxTreeNode }

constructor TNxTreeNode.Create;
begin
  inherited;
  FData := nil;
  FHidden := False;
  FTag := 0;
end;

destructor TNxTreeNode.Destroy;
begin
  if FItems <> nil then
  begin
    if FCount > 0 then FItems.ClearChildren(Self);
    FItems.Remove(Self);
  end;
  inherited;
end;

function TNxTreeNode.GetAbsoluteIndex: Integer;
begin
  Result := FItems.FList.IndexOf(Self);
end;

function TNxTreeNode.GetFirstSibling: TNxTreeNode;
var
  i: Integer;
begin
  { desc: Returns the first node at the same level as
          the calling node. }
  Result := Self;
  i := AbsoluteIndex;
  while (i > 0) and (FItems.GetItem(i).Level >= Level) do
  begin
    if FItems.GetItem(i).Level = Level then Result := FItems.GetItem(i);
    Dec(i);
  end;
end;

function TNxTreeNode.GetHasChildren: Boolean;
begin
  Result := FCount > 0;
end;

function TNxTreeNode.GetItem(Index: Integer): TNxTreeNode;
begin
  Result := FItems.GetChildNode(Self, Index);
end;

function TNxTreeNode.GetLastSibling: TNxTreeNode;
var
  i: Integer;
begin
  { desc: Returns the last node at the same level as
          the calling node. }
  Result := Self;
  i := AbsoluteIndex + 1;
  while (i < FItems.Count) and (FItems.GetItem(i).Level >= Level) do
  begin
    if FItems.GetItem(i).Level = Level then Result := FItems.GetItem(i);
    Inc(i);
  end;
end;

procedure TNxTreeNode.MoveTo(Destination: TNxTreeNode;
  Mode: TNodeAttachMode);
var
  NewIndex: Integer;
  Sibling: Boolean;
  AParent: TNxTreeNode;
begin
  NewIndex := -1;
  Sibling := False;
  AParent := nil;
  case Mode of
    naAdd:
    begin
      AParent := Destination.GetLastSibling;
      NewIndex := AParent.GetAbsoluteIndex + AParent.Count + 1;
      Sibling := True;
    end;
    naAddFirst:
    begin
      AParent := Destination.GetFirstSibling;
      NewIndex := AParent.GetAbsoluteIndex;
      Sibling := True;
    end;
    naInsert:
    begin
      AParent := FItems.GetItem(Destination.GetAbsoluteIndex);
      NewIndex := AParent.GetAbsoluteIndex;
      Sibling := True;
    end;
    naAddChild:
    begin
      AParent := Destination;
      NewIndex := Destination.GetAbsoluteIndex + Destination.Count + 1;
    end;
    naAddChildFirst:
    begin
      AParent := Destination;
      NewIndex := Destination.GetAbsoluteIndex + 1;
    end;
  end;
  if NewIndex <> -1 then { Move Item }
  begin
    FItems.MoveItem(AParent, Self, AbsoluteIndex, NewIndex, Sibling);
  end;
  { Parent, Level & Count }
  case Mode of
    naAdd, naAddFirst:
    begin
      if Assigned(FParent) then AParent.Parent.SetCount(AParent.Parent.Count - 1);
      if Assigned(AParent.Parent) then AParent.Parent.SetCount(AParent.Parent.Count + 1);
      FParent := Destination.Parent;
    end;
    naInsert:
    begin
      FParent := Destination.Parent;
    end;
    naAddChild, naAddChildFirst:
    begin
      if Assigned(FParent) then AParent.Parent.SetCount(AParent.Parent.Count - 1);
      FParent := AParent;
      Destination.SetCount(Destination.Count + 1);
    end;
  end;
end;

procedure TNxTreeNode.SetCount(const Value: Integer);
begin
  FCount := Value;
end;

procedure TNxTreeNode.SetData(const Value: Pointer);
begin
  FData := Value;
end;

procedure TNxTreeNode.SetExpanded(const Value: Boolean);
begin
  if FExpanded <> Value then
  begin
    FExpanded := Value;
    if Assigned(FTree) then FTree.Expand(Self, Value);
  end;
end;

procedure TNxTreeNode.SetItems(const Value: TNxTreeNodes);
begin
  FItems := Value;
end;

procedure TNxTreeNode.SetLevel(const Value: Integer);
begin
  FLevel := Value;
end;

procedure TNxTreeNode.SetParent(const Value: TNxTreeNode);
begin
  FParent := Value;
end;

procedure TNxTreeNode.SetText(const Value: WideString);
begin
  FText := Value;
end;

{ TNxTreeNodes }

function TNxTreeNodes.AddChild(Parent: TNxTreeNode): TNxTreeNode;
begin
  try
    Result := GetTreeNodeClass.Create;
    AddItem(Parent, Result);
  except
    Result := nil;
  end;
end;

procedure TNxTreeNodes.AddItem(Parent, Item: TNxTreeNode;
  Position: TAddPosition);
var
  Pos: Integer;
begin
  Item.SetItems(Self);
  if Parent <> nil then
  begin
    SetParent(Item, Parent);
    case Position of
      apFirst: Pos := FList.IndexOf(Parent) + 1;
      else Pos := FList.IndexOf(Parent) + GetChildCount(Parent) + 1;
    end;
    FList.Insert(Pos, Item);
  end else
  begin
    { TopLevel Items }
    Inc(FTopLevelCount);
    Item.FLevel := 0;
    case Position of
      apFirst: FList.Insert(0, Item);
      else FList.Add(Item)
    end;
  end;
end;

procedure TNxTreeNodes.Clear;
var
	i: Integer;
  Node: TNxTreeNode;
begin
	for i := FList.Count - 1 downto 0 do
  begin
    Node := Item[i];
    FreeAndNil(Node);
  end;
  FTopLevelCount := 0;
end;

procedure TNxTreeNodes.ClearChildren(const AItem: TNxTreeNode);
var
  i: Integer;
  Node: TNxTreeNode;
begin
  if AItem.FCount = 0 then Exit; { no children to delete }
  i := AItem.AbsoluteIndex + 1;
  while i < FList.Count do
  begin
    Node := Item[i];
    if Node.Level > AItem.Level then FreeAndNil(Node) { will call remove }
      else Exit;
  end;
end;

constructor TNxTreeNodes.Create(AOwner: TComponent);
begin
  FOwner := AOwner;
  FList := TList.Create;
end;

procedure TNxTreeNodes.Delete(Index: Integer);
begin
  { note: parent count will be set
          inside remowe proc. }
  Item[Index].Free;
end;

destructor TNxTreeNodes.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited;
end;

procedure TNxTreeNodes.DoAdded(Item: TNxTreeNode);
begin

end;

procedure TNxTreeNodes.DoDeleted(Item: TNxTreeNode);
begin
  if Assigned(FOnDeleted) then FOnDeleted(Self, Item);
end;

procedure TNxTreeNodes.Expand(AItem: TNxTreeNode; const Value: Boolean);
var
  i: Integer;
begin
  i := FList.IndexOf(AItem) + 1;
  while (i < FList.Count)
    and (GetItem(i).Level > AItem.Level) do
  begin
    if Value then
    begin
      if Item[i].FVisible then Item[i].FHidden := False;
      if not Item[i].FExpanded then Inc(i, GetChildCount(Item[i]));
    end else Item[i].FHidden := True;
    Inc(i);
  end;
end;

function TNxTreeNodes.Find(Data: Pointer): TNxTreeNode;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if Item[i].Data = Data then
    begin
      Result := Item[i];
      Exit;
    end;
end;

function TNxTreeNodes.GetChildCount(Item: TNxTreeNode): Integer;
var
  i: Integer;
begin
  Result := 0;
  i := Item.AbsoluteIndex + 1;
  while (i < Count)
    and (GetItem(i).Level > Item.Level) do
  begin
    Inc(Result);
    Inc(i);
  end;
end;

function TNxTreeNodes.GetChildNode(Parent: TNxTreeNode;
  Index: Integer): TNxTreeNode;
var
  i, c: Integer;
begin
  Result := nil;
  if not InRange(Index, 0, Pred(Parent.Count))
    then raise Exception.CreateFmt(exIndexOutOfBounds, [Index, ClassName]) else
  begin
    c := 0;
    i := Parent.AbsoluteIndex + 1;
    while (c <= Index) and (i < Count) do
    begin
      if Item[i].Parent = Parent then
      begin
        Result := Item[i];
        Inc(c);
      end;
      Inc(i);
    end;
  end;
end;

function TNxTreeNodes.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TNxTreeNodes.GetEmpty: Boolean;
begin
  Result := FList.Count <= 0;
end;

function TNxTreeNodes.GetItem(
  Index: Integer): TNxTreeNode;
begin
  Result := TNxTreeNode(FList[Index]);
end;

function TNxTreeNodes.GetItemCount(Item: TNxTreeNode): Integer;
begin
  if Item = nil then Result := FTopLevelCount
    else Result := Item.Count;
end;

function TNxTreeNodes.GetNodeOf(Data: Pointer): TNxTreeNode;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if Data = Item[i].Data then
    begin
      Result := Item[i];
      Exit;
    end;
end;

function TNxTreeNodes.GetTreeNodeClass: TNxTreeNodeClass;
begin
  Result := TNxTreeNode;
end;

function TNxTreeNodes.Insert(Item: TNxTreeNode;
  const S: WideString): TNxTreeNode;
begin
  if Item = nil then Exit;
  try
    Result := GetTreeNodeClass.Create;
    Result.FItems := Self;
    SetParent(Result, Item.Parent);

    FList.Insert(Item.AbsoluteIndex, Result); { non-sorted }

    Result.Text := S;
//    Result.Change(ckAdded);
  except
    FreeAndNil(Result);
  end;
end;

procedure TNxTreeNodes.MoveItem(Destination, Item: TNxTreeNode;
  CurIndex, NewIndex: Integer; Sibling: Boolean);
begin

end;

procedure TNxTreeNodes.Remove(Item: TNxTreeNode);
var
  Index: Integer;
begin
  Index := FList.IndexOf(Item);
  if Index <> -1 then
  begin
    if Assigned(Item.Parent) then Dec(Item.Parent.FCount);
    FList.Delete(Index);
    DoDeleted(Item);
  end;
end;

procedure TNxTreeNodes.SetParent(Item, Parent: TNxTreeNode);
begin
  Item.SetParent(Parent);
  Item.SetLevel(Parent.Level + 1);
  Item.FHidden := Parent.FHidden or not(Parent.FExpanded);
  Parent.SetCount(Parent.Count + 1);
end;

procedure TNxTreeNodes.Sort;
  function CompareNodes(Item1, Item2: Pointer): Integer;
  begin
     Result := CompareText(IntToStr(TNxTreeNode(Item1).Level) + '::' + TNxTreeNode(Item1).Text,
                           IntToStr(TNxTreeNode(Item2).Level) + '::' + TNxTreeNode(Item2).Text);
  end;
begin
  FList.Sort(@CompareNodes);
end;

{ TNxLocalizer }

constructor TNxLocalizer.Create(AOwner: TComponent);
begin
  inherited;

end;

function TNxLocalizer.GetNoneCaption: WideString;
begin
  Result := NxClasses.NoneCaption;
end;

function TNxLocalizer.GetStartDay: TStartDayOfWeek;
begin
  Result := NxClasses.StartDay;
end;

function TNxLocalizer.GetTodayCaption: WideString;
begin
  Result := NxClasses.TodayCaption;
end;

procedure TNxLocalizer.SetNoneCaption(const Value: WideString);
begin
  NxClasses.NoneCaption := Value;
end;

procedure TNxLocalizer.SetStartDay(const Value: TStartDayOfWeek);
begin
  NxClasses.StartDay := Value;
end;

procedure TNxLocalizer.SetTodayCaption(const Value: WideString);
begin
  NxClasses.TodayCaption := Value;
end;

{ TNxObjectTreeNodes }

procedure TNxObjectTreeNodes.AddAfter(Source, Target: TNxObjectTreeNode);
begin
  FList.Insert(Target.AbsoluteIndex, Source);
end;

procedure TNxObjectTreeNodes.AddItem(Parent, Item: TNxObjectTreeNode;
  Position: TAddPosition);
var
  Pos: Integer;
begin
  Item.SetItems(Self);
  if Parent <> nil then
  begin
    SetParent(Item, Parent);
    case Position of
      apFirst: Pos := FList.IndexOf(Parent) + 1;
      else Pos := FList.IndexOf(Parent) + GetChildCount(Parent) + 1;
    end;
    FList.Insert(Pos, Item);
  end else
  begin
    { TopLevel Items }
    Inc(FTopLevelCount);
    Item.FLevel := 0;
    case Position of
      apFirst: FList.Insert(0, Item);
      else FList.Add(Item)
    end;
  end;
end;

procedure TNxObjectTreeNodes.Clear;
var
	i: Integer;
  Node: TNxObjectTreeNode;
begin
	for i := FList.Count - 1 downto 0 do
  begin
    Node := FList[i];
    FreeAndNil(Node);
  end;
  FTopLevelCount := 0;
end;

constructor TNxObjectTreeNodes.Create;
begin
  FList := TList.Create;
end;

destructor TNxObjectTreeNodes.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited;
end;

function TNxObjectTreeNodes.GetChildCount(
  Item: TNxObjectTreeNode): Integer;
var
  i: Integer;
begin
  Result := 0;
  i := Item.AbsoluteIndex + 1;
  while (i < Count)
    and (GetItem(i).Level > Item.Level) do
  begin
    Inc(Result);
    Inc(i);
  end;
end;

function TNxObjectTreeNodes.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TNxObjectTreeNodes.GetItem(Index: Integer): TNxObjectTreeNode;
begin
  Result := TNxObjectTreeNode(FList[Index]);
end;

procedure TNxObjectTreeNodes.Insert(Before, Item: TNxObjectTreeNode;
  const S: WideString);
begin
  Item.FItems := Self;
  SetParent(Item, Before.Parent);
  FList.Insert(Before.AbsoluteIndex, Item); { non-sorted }
  Item.Text := S;
end;

procedure TNxObjectTreeNodes.Remove(Item: TNxObjectTreeNode);
begin
  FList.Delete(FList.IndexOf(Item));
end;

procedure TNxObjectTreeNodes.SetParent(Item, Parent: TNxObjectTreeNode);
begin
  Item.SetParent(Parent);
  Item.SetLevel(Parent.Level + 1);
  Item.FHidden := Parent.FHidden or not(Parent.FExpanded);
  Parent.SetCount(Parent.Count + 1);
end;

{ TNxObjectTreeNode }

constructor TNxObjectTreeNode.Create(AOwner: TComponent);
begin
  inherited;
  FParent := nil;
end;

destructor TNxObjectTreeNode.Destroy;
begin
  if FItems <> nil then
  begin
    FItems.Remove(Self);
  end;
  inherited;
end;

function TNxObjectTreeNode.GetAbsoluteIndex: Integer;
begin
  Result := FItems.FList.IndexOf(Self);
end;

function TNxObjectTreeNode.GetTopLevel: Boolean;
begin
  Result := FLevel = 0;
end;

procedure TNxObjectTreeNode.MoveTo(Destination: TNxObjectTreeNode;
  Mode: TNodeAttachMode);
begin

end;

procedure TNxObjectTreeNode.SetCount(const Value: Integer);
begin
  FCount := Value;
end;

procedure TNxObjectTreeNode.SetExpanded(const Value: Boolean);
begin
  FExpanded := Value;
end;

procedure TNxObjectTreeNode.SetItems(const Value: TNxObjectTreeNodes);
begin
  FItems := Value;
end;

procedure TNxObjectTreeNode.SetLevel(const Value: Integer);
begin
  FLevel := Value;
end;

procedure TNxObjectTreeNode.SetParent(const Value: TNxObjectTreeNode);
begin
  FParent := Value;
end;

procedure TNxObjectTreeNode.SetText(const Value: WideString);
begin
  FText := Value;
end;

initialization
  UnicodeSupported := Win32Platform = VER_PLATFORM_WIN32_NT;

end.







