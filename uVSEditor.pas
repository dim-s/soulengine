unit uVSEditor;

{$I 'sDef.inc'}

interface

uses
  SysUtils, Classes, Variants, Dialogs,
  PHPCommon, PHPCustomLibrary, phpLibrary, phpFunctions

      {$IFDEF VS_EDITOR}
  , NxPropertyItems, NxPropertyItemClasses, NxScrollControl,
  NxInspector
      {$ENDIF}  ;

type
  TphpVSEditor = class(TDataModule)
    _VSEditor: TPHPLibrary;
    _VSItems: TPHPLibrary;
    procedure _VSEditorFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _VSEditorFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _VSItemsFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _VSItemsFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _VSEditorFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _VSItemsFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _VSEditorFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _VSEditorFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  phpVSEditor: TphpVSEditor;

  {$IFDEF VS_EDITOR}
  ins: TNextInspector;
  {$ENDIF}

implementation

uses uPHPMod, Graphics, TypInfo;

{$R *.dfm}

{$IFDEF VS_EDITOR}
procedure initIns(Parameters: TFunctionParams);
begin
  ins := TNextInspector(ToObj(Parameters, 0));
end;

{$ENDIF}

procedure TphpVSEditor._VSEditorFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
{$IFDEF VS_EDITOR}
var
  ItemClass: TNxItemClass;
{$ENDIF}
begin
{$IFDEF VS_EDITOR}
  initIns(Parameters);

  ItemClass := TNxItemClass(GetClass(Parameters[2].Value));

  ReturnValue := integer(ins.Items.AddChild(TNxPropertyItem(
    ToObj(Parameters, 1)), ItemClass, Parameters[3].Value));
{$ENDIF}
end;

procedure TphpVSEditor._VSEditorFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
{$IFDEF VS_EDITOR}
var
  ItemClass: TNxItemClass;
{$ENDIF}
begin
{$IFDEF VS_EDITOR}
  initIns(Parameters);

  ItemClass := TNxItemClass(GetClass(Parameters[2].Value));

  ReturnValue := integer(ins.Items.AddChildFirst(
    TNxPropertyItem(ToObj(Parameters, 1)), ItemClass, Parameters[3].Value));
{$ENDIF}
end;


procedure TphpVSEditor._VSItemsFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
{$IFDEF VS_EDITOR}
var
  n, v: variant;
  vF: boolean;
{$ENDIF}
begin
{$IFDEF VS_EDITOR}

  v := Parameters[2].Value;
  n := LowerCase(Parameters[1].ZendVariable.AsString);
  vF := Parameters[3].ZendVariable.AsBoolean;

  if vF = False then
    if v = Null then
    begin
      if n = 'color' then
        ReturnValue := TNxPropertyItem(ToObj(Parameters, 0)).Font.Color
      else if n = 'name' then
        ReturnValue := TNxPropertyItem(ToObj(Parameters, 0)).Font.Name
      else if n = 'size' then
        ReturnValue := TNxPropertyItem(ToObj(Parameters, 0)).Font.Size
      else if n = 'charset' then
        ReturnValue := TNxPropertyItem(ToObj(Parameters, 0)).Font.Charset
      else if n = 'style' then
        ReturnValue := GetPropValue(TNxPropertyItem(ToObj(Parameters, 0)).Font, 'Style');

    end
    else
    begin

      if n = 'color' then
        TNxPropertyItem(ToObj(Parameters, 0)).Font.Color := v
      else if n = 'name' then
        TNxPropertyItem(ToObj(Parameters, 0)).Font.Name := v
      else if n = 'size' then
        TNxPropertyItem(ToObj(Parameters, 0)).Font.Size := v
      else if n = 'charset' then
        TNxPropertyItem(ToObj(Parameters, 0)).Font.Charset := v
      else if n = 'style' then
        SetPropValue(TNxPropertyItem(ToObj(Parameters, 0)).Font, 'Style', v);

    end;


  if vF = True then
    if v = Null then
    begin
      if n = 'color' then
        ReturnValue := TNxPropertyItem(ToObj(Parameters, 0)).ValueFont.Color
      else if n = 'name' then
        ReturnValue := TNxPropertyItem(ToObj(Parameters, 0)).ValueFont.Name
      else if n = 'size' then
        ReturnValue := TNxPropertyItem(ToObj(Parameters, 0)).ValueFont.Size
      else if n = 'charset' then
        ReturnValue := TNxPropertyItem(ToObj(Parameters, 0)).ValueFont.Charset
      else if n = 'style' then
        ReturnValue := GetPropValue(TNxPropertyItem(ToObj(Parameters, 0)).ValueFont, 'Style');

    end
    else
    begin
      if n = 'color' then
        TNxPropertyItem(ToObj(Parameters, 0)).ValueFont.Color := v
      else if n = 'name' then
        TNxPropertyItem(ToObj(Parameters, 0)).ValueFont.Name := v
      else if n = 'size' then
        TNxPropertyItem(ToObj(Parameters, 0)).ValueFont.Size := v
      else if n = 'charset' then
        TNxPropertyItem(ToObj(Parameters, 0)).ValueFont.Charset := v
      else if n = 'style' then
        SetPropValue(TNxPropertyItem(ToObj(Parameters, 0)).ValueFont, 'Style', v);

      TNxPropertyItem(ToObj(Parameters, 0)).UpdateEditor;
    end;

{$ENDIF}

end;

procedure TphpVSEditor._VSItemsFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
{$IFDEF VS_EDITOR}
var
  ItemClass: TNxItemClass;
{$ENDIF}
begin
{$IFDEF VS_EDITOR}

  ItemClass := TNxItemClass(GetClass(Parameters[1].Value));

  ReturnValue := integer(TNxPropertyItem(ToObj(Parameters, 0)).AddChild(ItemClass, Parameters[2].Value));
{$ENDIF}

end;

procedure TphpVSEditor._VSEditorFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  initIns(Parameters);

  if Parameters[1].Value = null then
    ins.Items.AddItem(nil,
      TNxPropertyItem(ToObj(Parameters, 2)),
      Parameters[3].Value)
  else
    ins.Items.AddItem(TNxPropertyItem(ToObj(Parameters, 1)),
      TNxPropertyItem(ToObj(Parameters, 2)),
      Parameters[3].Value);
{$ENDIF}

end;

procedure TphpVSEditor._VSItemsFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  {$IFDEF VS_EDITOR}
  if Parameters[1].Value = null then
    ReturnValue := TNxComboBoxItem(ToObj(Parameters, 0)).Lines.Text
  else
    TNxComboBoxItem(ToObj(Parameters, 0)).Lines.Text := Parameters[1].Value;
{$ENDIF}
end;

procedure TphpVSEditor._VSEditorFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  initIns(Parameters);
  ins.SelectedIndex := 0;
{$ENDIF}
end;

procedure TphpVSEditor._VSEditorFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
{$IFDEF VS_EDITOR}
  initIns(Parameters);
  if Parameters[1].Value = Null then
  begin
    ReturnValue := ins.SelectedIndex;
  end
  else
    ins.SelectedIndex := Parameters[1].Value;
{$ENDIF}
end;

end.
