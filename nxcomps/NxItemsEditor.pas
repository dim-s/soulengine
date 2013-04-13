{$R NxItemsImagesRes.res}

unit NxItemsEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DesignWindows, DesignIntf, ComCtrls, ToolWin, NxInspector,
  NxPropertyItems, NxPropertyItemClasses, ImgList, Menus, NxStdCtrls;

type
  TCustomItemsForm = class(TDesignWindow)
  private
    FImages: TImageList;
    FTabControl: TNxTabControl;
  protected
    procedure AddButton(TabButtons: string; ReferenceType: TComponentClass;
      ImageIndex: Integer); virtual;
    function GetItemImageIndex(ItemClass: TNxItemClass): Integer; virtual;
    procedure CreateButtons; virtual;
    procedure CreateImages; virtual;
  public
    procedure AddImage(ResString: string);
    property Images: TImageList read FImages write FImages;
    property TabControl: TNxTabControl read FTabControl write FTabControl;
  end;

  TItemForm = class(TCustomItemsForm)
    ItemsTree: TTreeView;
    ToolbarImages: TImageList;
    ToolsImages: TImageList;
    PopupMenu1: TPopupMenu;
    SetName1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    ItemsPalette: TNxTabControl;
    Tools: TToolBar;
    btnDelete: TToolButton;
    btnClear: TToolButton;
    ToolButton14: TToolButton;
    btnUp: TToolButton;
    btnDown: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure ItemsTreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure ItemsTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ItemsTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SetName1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ItemsPaletteButtonClick(Sender: TObject;
      const Index: Integer);
    procedure ItemsTreeEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure ItemsTreeEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
  private
    FDesigner: IDesigner;
    FParentControl: TNextInspector;
    FEditingItem: TNxPropertyItem;
    procedure RefreshItems;
  protected
    procedure CreateNewItem(const ItemClass: TNxItemClass); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
  	procedure UpdateItem(Item: TNxPropertyItem);
    property Designer: IDesigner read FDesigner write FDesigner;
    property OwnerControl: TNextInspector read FParentControl write FParentControl;
    property EditingItem: TNxPropertyItem read FEditingItem write FEditingItem;
  end;

implementation

{$R *.dfm}

{ TCustomItemsForm }

procedure TCustomItemsForm.AddButton(TabButtons: string;
  ReferenceType: TComponentClass; ImageIndex: Integer);
begin
  with FTabControl.AddButton(TabButtons, ReferenceType, ImageIndex) do
  begin
    ShowHint := True;
    Hint := ReferenceType.ClassName;
  end;
end;

procedure TCustomItemsForm.AddImage(ResString: string);
var
  ABitmap: TBitmap;
begin
  ABitmap := TBitmap.Create;
  ABitmap.LoadFromResourceName(HInstance, ResString);
  FImages.AddMasked(ABitmap, ABitmap.Canvas.Pixels[0, ABitmap.Height - 1]);
end;

procedure TCustomItemsForm.CreateButtons;
begin
  AddButton('Standard', TNxTextItem, 1);
  AddButton('Standard', TNxSpinItem, 2);
  AddButton('Standard', TNxCheckBoxItem, 3);
  AddButton('Standard', TNxComboBoxItem, 4);
  AddButton('Standard', TNxCalcItem, 5);
  AddButton('Standard', TNxDateItem, 6);
  AddButton('Standard', TNxTimeItem, 7);
  AddButton('Standard', TNxButtonItem, 8);
  AddButton('Standard', TNxColorItem, 9);
  AddButton('Standard', TNxImagePathItem, 10);
  AddButton('Standard', TNxFolderItem, 11);
  AddButton('Additional', TNxMemoItem, 12);
  AddButton('Additional', TNxFontNameItem, 13);
  AddButton('Additional', TNxTrackBarItem, 14);
  AddButton('Additional', TNxProgressItem, 15);
  AddButton('Additional', TNxRadioItem, 16);
  AddButton('Toolbar Items', TNxToolbarItem, 17);
  AddButton('Toolbar Items', TNxFontStyleItem, 18);
  AddButton('Toolbar Items', TNxAlignmentItem, 19);
  AddButton('Toolbar Items', TNxVertAlignmentItem, 20);
end;

procedure TCustomItemsForm.CreateImages;
begin
  AddImage('TEXTITEM');
  AddImage('SPINITEM');
  AddImage('CHECKBOXITEM');
  AddImage('COMBOBOXITEM');
  AddImage('CALCITEM');
  AddImage('DATEITEM');
  AddImage('TIMEITEM');
  AddImage('BUTTONITEM');
  AddImage('COLORITEM');
  AddImage('IMAGEITEM');
  AddImage('FOLDERITEM');
  AddImage('MEMOITEM');
  AddImage('FONTNAMEITEM');
  AddImage('TRACKBARITEM');
  AddImage('PROGRESSITEM');
  AddImage('RADIOITEM');
  AddImage('TOOLBARITEM');
  AddImage('FONTSTYLEITEM');
  AddImage('ALIGNMENTITEM');
  AddImage('VERTALIGNMENTITEM');
end;

function TCustomItemsForm.GetItemImageIndex(
  ItemClass: TNxItemClass): Integer;
var
  i, j: Integer;
begin
  Result := -1;
  for i := 0 to Pred(TabControl.Count) do
    for j := 0 to Pred(TabControl.TabButtons[i].Count) do
      if TabControl.TabButtons[i].Button[j].ReferenceType = ItemClass then
      begin
        Result := TabControl.TabButtons[i].Button[j].ImageIndex;
        Exit;
      end;
end;

{ TItemForm }

procedure TItemForm.CreateNewItem(const ItemClass: TNxItemClass);
var
  Item, Parent: TNxPropertyItem;
  Node: TTreeNode;
begin
  try
    Item := ItemClass.Create(FParentControl.Owner);
    Item.Name := Designer.UniqueName(Item.ClassName);

    Parent := ItemsTree.Selected.Data;
    FParentControl.Items.AddItem(Parent, Item);
    Item.ReadOnly := Item.IsTopLevel;

    Node := ItemsTree.Items.AddChild(ItemsTree.Selected, '');
    Node.ImageIndex := GetItemImageIndex(ItemClass);
    Node.SelectedIndex := Node.ImageIndex;
    Node.Data := Item; { connect node and item }

    ItemsTree.Selected.Expand(False);
    Designer.Modified;
  except
    Designer.NoSelection;
    raise;
  end;
end;
{$WARNINGS OFF}

procedure TItemForm.RefreshItems;
var
  I: Integer;
  TopNode: TTreeNode;

  procedure CreateNodes(Items: TNxPropertyItems; Item: TNxPropertyItem;
    ParentNode: TTreeNode);
  var
    NewNode: TTreeNode;
  begin
    while I < Items.Count do
    begin
      if Items[I].Level > Item.Level then
        CreateNodes(Items, Items[I], NewNode);

      if (I = Items.Count) or (Items[I].Level < Item.Level)
        then Exit;

      NewNode := ItemsTree.Items.AddChild(ParentNode, Items[I].Caption);
      with NewNode do
      begin
        ImageIndex := GetItemImageIndex(TNxItemClass(Items[I].ClassType));
        SelectedIndex := ImageIndex;
        Data := Items[I]; { link node and item }
      end;
      Inc(I);
    end;
  end;

begin

  ItemsTree.Items.Clear;
	with FParentControl do
  begin
    TopNode := ItemsTree.Items.Add(nil, '(Root)');
    with TopNode do
    begin
      ImageIndex := 0;
      SelectedIndex := 0;
    end;
    if Items.Count = 0 then Exit;
    I := 0;
    CreateNodes(Items, Items[0], TopNode);
  end;
  ItemsTree.Items[0].Expand(True);
end;
{$WARNINGS ON}

procedure TItemForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  { we need to free (and close) this window
    when FParentControl (component) has been deleted }
  if (Operation = opRemove) and (AComponent = FParentControl) then Free;
end;

procedure TItemForm.UpdateItem(Item: TNxPropertyItem);
begin
	ItemsTree.Items[Item.AbsoluteIndex + 1].Text := Item.Caption;
  Designer.Modified;
end;

procedure TItemForm.ItemsTreeChange(Sender: TObject; Node: TTreeNode);
var
  AItem: TNxPropertyItem;
begin
  if TObject(Node.Data) is TNxPropertyItem then
  begin
    AItem := TNxPropertyItem(Node.Data);
	  Designer.SelectComponent(AItem);
    EditingItem := AItem;
    btnUp.Enabled := AItem.Index > 0;
    btnDown.Enabled := (AItem.ParentItem <> nil) and (AItem.Index < AItem.ParentItem.Count - 1);
  end else
  begin
    Designer.SelectComponent(FParentControl);
    EditingItem := nil;
    btnUp.Enabled := False;
    btnDown.Enabled := False;
  end;
end;

{ Form generated code }

procedure TItemForm.FormCreate(Sender: TObject);
begin
  TabControl := ItemsPalette;
  Images := ToolbarImages;
  CreateImages;
  CreateButtons;
end;

procedure TItemForm.FormShow(Sender: TObject);
begin
  { note: next line notify window (Self)
          that FOwner will be destroyed }
  TNextInspector(FParentControl).FreeNotification(Self);
  Caption := 'Items Editor - ' + TNextInspector(FParentControl).Name;
  RefreshItems;
end;

procedure TItemForm.FormDestroy(Sender: TObject);
begin
  TNextInspector(FParentControl).RemoveFreeNotification(Self);
end;

procedure TItemForm.btnDeleteClick(Sender: TObject);
var
  Item: TNxPropertyItem;
begin
	if ItemsTree.Selected.IsFirstNode then Exit;
	with FParentControl as TNextInspector do
  begin
    Designer.NoSelection;
    Item := ItemsTree.Selected.Data;
    Item.Free;
    ItemsTree.Selected.Delete;
  end;
end;

procedure TItemForm.btnClearClick(Sender: TObject);
begin
	with FParentControl as TNextInspector do
  begin
    Designer.NoSelection;
    Items.Clear;
    ItemsTree.Items[0].DeleteChildren;
  end;
end;

procedure TItemForm.btnUpClick(Sender: TObject);
var
  AItem: TNxPropertyItem;
  ANode, APrevNode: TTreeNode;
  Expanded: Boolean;
begin
  ANode := ItemsTree.Selected;
  if TObject(ANode.Data) is TNxPropertyItem then 
  begin
    AItem := TNxPropertyItem(ANode.Data);
    Designer.NoSelection;
    APrevNode := ANode.Parent.Item[ANode.Index - 1];
    Expanded := ANode.Expanded;
    ANode.MoveTo(APrevNode, naInsert);
    ANode.Expanded := Expanded;
    ItemsTree.Selected := ANode;
    { move item }
    AItem.MoveTo(AItem.GetPrevSibling, naInsert);
    ItemsTreeChange(ItemsTree, ANode);
  end;
end;

procedure TItemForm.btnDownClick(Sender: TObject);
var
  AItem: TNxPropertyItem;
  ANode, ANextNode: TTreeNode;
  Expanded: Boolean;
begin
  ANode := ItemsTree.Selected;
  if TObject(ANode.Data) is TNxPropertyItem then 
  begin
    AItem := TNxPropertyItem(ANode.Data);
    Designer.NoSelection;
    ANextNode := ANode.Parent.Item[ANode.Index + 1];
    Expanded := ANextNode.Expanded;
    ANextNode.MoveTo(ANode, naInsert);
    ANextNode.Expanded := Expanded;
    ItemsTree.Selected := ANode;
    { move item }
    AItem.GetNextSibling.MoveTo(AItem, naInsert);
    ItemsTreeChange(ItemsTree, ANode);
  end;
end;

procedure TItemForm.ItemsTreeDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  SourceItem, TargetItem: TNxPropertyItem;
  Node: TTreeNode;
begin
  Node := ItemsTree.GetNodeAt(X, Y);
  if Assigned(Node) then
  begin
    SourceItem := TNxPropertyItem(ItemsTree.Selected.Data);
    TargetItem := TNxPropertyItem(Node.Data);
    if Node.AbsoluteIndex > 0 then SourceItem.MoveTo(TargetItem, naAddChild)
      else SourceItem.SetTopLevel;
    ItemsTree.Selected.MoveTo(Node, naAddChild);
    Designer.Modified;
  end;
end;

procedure TItemForm.ItemsTreeDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  ANode, ASource: TTreeNode;
begin
  ANode := ItemsTree.GetNodeAt(X, Y);
  ASource := ItemsTree.Selected;
  Accept := (ANode <> ASource) and Assigned(ANode)
    and (not ASource.IsFirstNode)
      and (not ANode.HasAsParent(ASource)) and (ASource.Parent <> ANode);
end;

procedure TItemForm.SetName1Click(Sender: TObject);
var
  AItem: TNxPropertyItem;
begin
  if ItemsTree.Selected <> nil then
    if ItemsTree.Selected.AbsoluteIndex <> 0 then
    begin
      AItem := TNxPropertyItem(ItemsTree.Selected.Data);
      AItem.Name := Designer.UniqueName(AItem.ClassName);
      Designer.Modified;
    end;
end;

procedure TItemForm.ToolButton2Click(Sender: TObject);
begin
  if TToolButton(Sender).Down then FormStyle := fsStayOnTop
    else FormStyle := fsNormal; 
end;

procedure TItemForm.ItemsPaletteButtonClick(Sender: TObject;
  const Index: Integer);
var
  ItemClass: TNxItemClass;
begin
  if TabControl.ButtonExist(Index) then
  begin
    ItemClass := TNxItemClass(TabControl.Button[Index].ReferenceType);
    CreateNewItem(ItemClass);
  end;
end;

procedure TItemForm.ItemsTreeEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
  if Assigned(Node.Data) then
  begin
    TNxPropertyItem(Node.Data).Caption := S;
  end;
end;

procedure TItemForm.ItemsTreeEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if Node.AbsoluteIndex = 0 then AllowEdit := False;
end;

end.
