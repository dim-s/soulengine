unit uPHPCatButtons;

interface

uses
  SysUtils, Classes, Variants, Dialogs,
  PHPCommon, PHPCustomLibrary, phpLibrary, phpFunctions, CategoryButtons,
  ImgList, Controls;

type
  TPHPCatButtons = class(TDataModule)
    _ButtonCatigories: TPHPLibrary;
    procedure _ButtonCatigoriesFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ButtonCatigoriesFunctions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ButtonCatigoriesFunctions2Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ButtonCatigoriesFunctions3Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ButtonCatigoriesFunctions4Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ButtonCatigoriesFunctions5Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure _ButtonCatigoriesFunctions6Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PHPCatButtons: TPHPCatButtons;

implementation

uses uPHPMod;

{$R *.dfm}

procedure TPHPCatButtons._ButtonCatigoriesFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TButtonCategories(ToObj(Parameters, 0)).Add);
end;

procedure TPHPCatButtons._ButtonCatigoriesFunctions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TButtonCategories(ToObj(Parameters, 0)).Insert(
    Parameters[1].Value));
end;

procedure TPHPCatButtons._ButtonCatigoriesFunctions2Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TCategoryButtons(ToObj(Parameters, 0)).Categories);
end;

procedure TPHPCatButtons._ButtonCatigoriesFunctions3Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TCategoryButtons(ToObj(Parameters, 0)).Images := TImageList(ToObj(Parameters, 1));
end;

procedure TPHPCatButtons._ButtonCatigoriesFunctions4Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TCategoryButtons(ToObj(Parameters, 0)).SelectedItem);
end;

procedure TPHPCatButtons._ButtonCatigoriesFunctions5Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  TCategoryButtons(ToObj(Parameters, 0)).SelectedItem := nil;
  //TCategoryButtons(ToObj(Parameters,0)).Categories.Items[0].Items[0];

end;

procedure TPHPCatButtons._ButtonCatigoriesFunctions6Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := integer(TButtonCategory(ToObj(Parameters, 0)).Items.Add);
end;

end.
