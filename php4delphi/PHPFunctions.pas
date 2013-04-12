{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
{$I PHP.INC}

{ $Id: PHPFunctions.pas,v 7.2 10/2009 delphi32 Exp $ } 

unit phpFunctions;

{$ifdef fpc}
   {$mode delphi}
{$endif}

interface
 uses
   Windows, SysUtils,  Classes, {$IFDEF VERSION6} Variants,
   {$ENDIF} ZendTypes, PHPTypes, ZendAPI, PHPAPI ;

type
  TParamType = (tpString, tpInteger, tpFloat, tpBoolean, tpArray, tpUnknown);

  TZendVariable = class
  private
    FValue : PZval;
    function  GetAsBoolean: boolean;
    procedure SetAsBoolean(const Value: boolean);
    function  GetAsFloat: double;
    function  GetAsInteger: integer;
    function  GetAsString: AnsiString;
    procedure SetAsFloat(const Value: double);
    procedure SetAsInteger(const Value: integer);
    procedure SetAsString(const Value: AnsiString);
    function  GetAsDate: TDateTime;
    function  GetAsDateTime: TDateTime;
    function  GetAsTime: TDateTime;
    procedure SetAsDate(const Value: TDateTime);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsTime(const Value: TDateTime);
    function  GetAsVariant: variant;
    procedure SetAsVariant(const Value: variant);
    function  GetDataType: integer;
    function  GetIsNull: boolean;
    function  GetTypeName: string;
  public
    constructor Create; virtual;
    procedure   UnAssign;
    property    IsNull : boolean read GetIsNull;
    property    AsZendVariable : Pzval read FValue write FValue;
    property    AsBoolean : boolean read GetAsBoolean write SetAsBoolean;
    property    AsInteger : integer read GetAsInteger write SetAsInteger;
    property    AsString  : AnsiString read GetAsString  write SetAsString;
    property    AsFloat   : double  read GetAsFloat write SetAsFloat;
    property    AsDate    : TDateTime read GetAsDate write SetAsDate;
    property    AsTime    : TDateTime read GetAsTime write SetAsTime;
    property    AsDateTime : TDateTime read GetAsDateTime write SetAsDateTime;
    property    AsVariant : variant read GetAsVariant write SetAsVariant;
    property    DataType : integer read GetDataType;
    property    TypeName : string read GetTypeName;
  end;


  TFunctionParam = class(TCollectionItem)
  private
    FName  : string;
    FParamType : TParamType;
    FZendVariable : TZendVariable;
    function GetZendValue: PZVal;
    procedure SetZendValue(const Value: PZVal);
    function GetValue: variant;
    procedure SetValue(const Value: variant);
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    function GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
    procedure AssignTo(Dest: TPersistent); override;
    property Value : variant read GetValue write SetValue;
    property ZendValue : PZVal read GetZendValue write SetZendValue;
    property ZendVariable : TZendVariable read FZendVariable write FZendVariable;
  published
    property Name : string read FName write SetDisplayName;
    property ParamType : TParamType read FParamType write FParamType;
  end;

  TFunctionParams = class(TCollection)
  private
    FOwner: TPersistent;
    function  GetItem(Index: Integer): TFunctionParam;
    procedure SetItem(Index: Integer; Value: TFunctionParam);
  protected
    function GetOwner: TPersistent; override;
    procedure SetItemName(Item: TCollectionItem); override;
  public
    constructor Create(Owner: TPersistent; ItemClass: TCollectionItemClass);
    function ParamByName(AName : string) : TFunctionParam;
    function Values(AName : string) : Variant;
    function Add : TFunctionParam;
    property Items[Index: Integer]: TFunctionParam read GetItem write SetItem; default;
  end;


  TPHPExecute = procedure(Sender : TObject; Parameters : TFunctionParams ; var ReturnValue : Variant;
                          ZendVar : TZendVariable;  TSRMLS_DC : pointer) of object;

  TPHPFunction = class(TCollectionItem)
  private
    FOnExecute : TPHPExecute;
    FFunctionName  : AnsiString;
    FTag       : integer;
    FFunctionParams: TFunctionParams;
    FDescription: AnsiString;
    procedure SetFunctionParams(const Value: TFunctionParams);
    procedure _SetDisplayName(const value : AnsiString);
  public
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    function  GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
    procedure AssignTo(Dest: TPersistent); override;
  published
    property FunctionName : AnsiString read FFunctionName write _SetDisplayName;
    property Tag  : integer read FTag write FTag;
    property Parameters: TFunctionParams read FFunctionParams write SetFunctionParams;
    property OnExecute : TPHPExecute read FOnExecute write FOnExecute;
    property Description : AnsiString read FDescription write FDescription;
  end;

  TPHPFunctions = class(TCollection)
  private
    FOwner: TPersistent;
  protected
    function GetItem(Index: Integer): TPHPFunction;
    procedure SetItem(Index: Integer; Value: TPHPFunction);
    function GetOwner: TPersistent; override;
    procedure SetItemName(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass); virtual;
    function Add : TPHPFunction;
    function FunctionByName(const AName : AnsiString) : TPHPFunction;
    property Items[Index: Integer]: TPHPFunction read GetItem write SetItem; default;
  end;


function IsParamTypeCorrect(AParamType :  TParamType; z : Pzval) : boolean;

function ZendTypeToString(_type : integer) : string;

implementation

function ZendTypeToString(_type : integer) : string;
begin
  case _type of
  IS_NULL              : Result := 'IS_NULL';
  IS_LONG              : Result := 'IS_LONG';
  IS_DOUBLE            : Result := 'IS_DOUBLE';
  IS_STRING            : Result := 'IS_STRING';
  IS_ARRAY             : Result := 'IS_ARRAY';
  IS_OBJECT            : Result := 'IS_OBJECT';
  IS_BOOL              : Result := 'IS_BOOL';
  IS_RESOURCE          : Result := 'IS_RESOURCE';
  IS_CONSTANT          : Result := 'IS_CONSTANT';
  IS_CONSTANT_ARRAY    : Result := 'IS_CONSTANT_ARRAY';
  end;
end;

function IsParamTypeCorrect(AParamType :  TParamType; z : Pzval) : boolean;
var
  ZType : integer;
begin
  ZType := Z^._type;
  case AParamType Of
   tpString  : Result := (ztype in [IS_STRING, IS_NULL]);
   tpInteger : Result := (ztype in [IS_LONG, IS_BOOL, IS_NULL, IS_RESOURCE]);
   tpFloat   : Result := (ztype in [IS_NULL, IS_DOUBLE, IS_LONG]);
   tpBoolean : Result := (ztype in [IS_NULL, IS_BOOL]);
   tpArray   : Result := (ztype in [IS_NULL, IS_ARRAY]);
   tpUnknown : Result := True;
    else
     Result := False;
   end;
end;

{ TPHPFunctions }

function TPHPFunctions.Add: TPHPFunction;
begin
  Result := TPHPFunction(inherited Add);
end;

constructor TPHPFunctions.Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FOwner := AOwner;
end;

function TPHPFunctions.FunctionByName(const AName: AnsiString): TPHPFunction;
var
 cnt : integer;
begin
  Result := nil;
  for cnt := 0 to Count -1 do
   begin
     if SameText(AName, Items[cnt].FunctionName) then
      begin
        Result := Items[cnt];
        break;
      end;
   end;
end;

function TPHPFunctions.GetItem(Index: Integer): TPHPFunction;
begin
  Result := TPHPFunction(inherited GetItem(Index));
end;

function TPHPFunctions.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TPHPFunctions.SetItem(Index: Integer; Value: TPHPFunction);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;


procedure TPHPFunctions.SetItemName(Item: TCollectionItem);
var
  I, J: Integer;
  ItemName: string;
  CurItem: TPHPFunction;
begin
  J := 1;
  while True do
  begin
    ItemName := Format('phpfunction%d', [J]);
    I := 0;
    while I < Count do
    begin
      CurItem := Items[I] as TPHPFunction;
      if (CurItem <> Item) and (CompareText(CurItem.FunctionName, ItemName) = 0) then
      begin
        Inc(J);
        Break;
      end;
      Inc(I);
    end;
    if I >= Count then
    begin
      (Item as TPHPFunction).FunctionName := ItemName;
      Break;
    end;
  end;
end;

{ TPHPFunction }


procedure TPHPFunction.AssignTo(Dest: TPersistent);
begin
  if Dest is TPHPFunction then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      with TPHPFunction(Dest) do
      begin
        Tag := Self.Tag;
        Parameters.Assign(Self.Parameters);
        Description := Self.Description;
        FunctionName := Self.FunctionName;
      end;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end else inherited AssignTo(Dest);
end;
  

constructor TPHPFunction.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFunctionParams := TFunctionParams.Create(TPHPFunctions(Self.Collection).GetOwner, TFunctionParam);
end;

destructor TPHPFunction.Destroy;
begin
  FOnExecute := nil;
  FFunctionParams.Free;
  inherited;
end;

function TPHPFunction.GetDisplayName: string;
begin
  if FFunctionName = '' then
   result :=  inherited GetDisplayName else
     Result := FFunctionName;
end;



procedure TPHPFunction.SetDisplayName(const Value: string);
var
  I: Integer;
  F: TPHPFunction;
  NameValue : AnsiString;
begin
   NameValue := Value;
  if AnsiCompareText(NameValue, FFunctionName) <> 0 then
  begin
    if Collection <> nil then
      for I := 0 to Collection.Count - 1 do
      begin
        F := TPHPFunctions(Collection).Items[I];
        if (F <> Self) and (F is TPHPFunction) and
          (AnsiCompareText(NameValue, F.FunctionName) = 0) then
          raise Exception.CreateFmt('Duplicate function name: %s', [Value]);
      end;
    FFunctionName :=  AnsiLowerCase(Value);
    Changed(False);
  end;
end;

procedure TPHPFunction._SetDisplayName(const Value: AnsiString);
var
  NewName : string;
begin
  NewName := value;
  SetDisplayName(NewName);
end;

procedure TPHPFunction.SetFunctionParams(const Value: TFunctionParams);
begin
  FFunctionParams.Assign(Value);
end;


{ TFunctionParams }

function TFunctionParams.Add: TFunctionParam;
begin
  Result := TFunctionParam(inherited Add);
end;

constructor TFunctionParams.Create(Owner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FOwner := Owner;
end;

function TFunctionParams.GetItem(Index: Integer): TFunctionParam;
begin
  Result := TFunctionParam(inherited GetItem(Index));
end;

function TFunctionParams.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TFunctionParams.ParamByName(AName: string): TFunctionParam;
var
 i : integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
   begin
     if SameText(AName, Items[i].Name) then
      begin
        Result := Items[i];
        Break;
      end;
   end;
end;

procedure TFunctionParams.SetItem(Index: Integer; Value: TFunctionParam);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

procedure TFunctionParams.SetItemName(Item: TCollectionItem);
var
  I, J: Integer;
  ItemName: string;
  CurItem: TFunctionParam;
begin
  J := 1;
  while True do
  begin
    ItemName := Format('Param%d', [J]);
    I := 0;
    while I < Count do
    begin
      CurItem := Items[I] as TFunctionParam;
      if (CurItem <> Item) and (CompareText(CurItem.Name, ItemName) = 0) then
      begin
        Inc(J);
        Break;
      end;
      Inc(I);
    end;
    if I >= Count then
    begin
      (Item as TFunctionParam).Name := ItemName;
      Break;
    end;
  end;
end;

function TFunctionParams.Values(AName: string): Variant;
var
 P : TFunctionParam;
begin
  Result := NULL;
  P := ParamByName(AName);
  if Assigned(P) then
   Result := P.Value;
end;

{ TFunctionParam }

procedure TFunctionParam.AssignTo(Dest: TPersistent);
begin
  if Dest is TFunctionParam then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      with TFunctionParam(Dest) do
      begin
        ParamType := Self.ParamType;
        Name := Self.Name;
      end;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end else inherited AssignTo(Dest);
end;

constructor TFunctionParam.Create(Collection: TCollection);
begin
  inherited;
  FZendVariable := TZendVariable.Create;
end;

destructor TFunctionParam.Destroy;
begin
  FZendVariable.Free;
  inherited;
end;

function TFunctionParam.GetDisplayName: string;
begin
  if FName = '' then
   result :=  inherited GetDisplayName else
     Result := FName;
end;

function TFunctionParam.GetValue: variant;
begin
   Result := FZendVariable.AsVariant;
end;

function TFunctionParam.GetZendValue: PZVal;
begin
  Result := FZendVariable.FValue;
end;

procedure TFunctionParam.SetDisplayName(const Value: string);
var
  I: Integer;
  F: TFunctionParam;
begin
  if AnsiCompareText(Value, FName) <> 0 then
  begin
    if Collection <> nil then
      for I := 0 to Collection.Count - 1 do
      begin
        F := TFunctionParams(Collection).Items[I];
        if ((F <> Self) and (F is TFunctionParam) and
          (AnsiCompareText(Value, F.Name) = 0)) then
          raise Exception.Create('Duplicate parameter name');
      end;
    FName := Value;
    Changed(False);
  end;
end;


procedure TFunctionParam.SetValue(const Value: variant);
begin
  FZendVariable.AsVariant := Value;
end;

procedure TFunctionParam.SetZendValue(const Value: PZVal);
begin
   FZendVariable.AsZendVariable := Value;
end;

{ TZendVariable }

constructor TZendVariable.Create;
begin
  inherited Create;
  FValue := nil;
end;



function TZendVariable.GetAsBoolean: boolean;
begin
  if not Assigned(FValue) then
   begin
    Result := false;
    Exit;
   end;

  case FValue^._type of
   IS_STRING :
    begin
      if SameText(GetAsString, 'True') then
       Result := true
        else
         Result := false;
    end;
   IS_BOOL : Result := (FValue^.value.lval = 1);
   IS_LONG, IS_RESOURCE : Result := (FValue^.value.lval = 1);
   else
    Result := false;
   end;
end;

function TZendVariable.GetAsDate: TDateTime;
begin
  if not Assigned(FValue) then
   begin
    Result := 0;
    Exit;
   end;

  case FValue^._type of
   IS_STRING : Result := StrToDate(GetAsString);
   IS_DOUBLE : Result := FValue^.value.dval;
  else
    Result := 0;
  end;
end;

function TZendVariable.GetAsDateTime: TDateTime;
begin
  if not Assigned(FValue) then
   begin
    Result := 0;
    Exit;
   end;

  case FValue^._type of
   IS_STRING : Result := StrToDateTime(GetAsString);
   IS_DOUBLE : Result := FValue^.value.dval;
  else
    Result := 0;
  end;
end;

{$IFDEF VERSION5}
function StrToFloatDef(const S: string; const Default: Extended): Extended;
begin
  if not TextToFloat(PAnsiChar(S), Result, fvExtended) then
    Result := Default;
end;
{$ENDIF}

function TZendVariable.GetAsFloat: double;
begin
  if not Assigned(FValue) then
   begin
    Result := 0;
    Exit;
   end;

  case FValue^._type of
   IS_STRING : Result := StrToFloatDef(GetAsString,0.0);
   IS_DOUBLE : Result := FValue^.value.dval;
  else
    Result := 0;
  end;
end;

function TZendVariable.GetAsInteger: integer;
begin
  if not Assigned(FValue) then
   begin
    Result := 0;
    Exit;
   end;

  case FValue^._type of
   IS_STRING : result := StrToIntDef(GetAsString, 0);
   IS_DOUBLE : result := Round(FValue^.value.dval);
   IS_NULL   : result := 0;
   IS_LONG   : result := FValue^.value.lval;
   IS_BOOL   : result := FValue^.value.lval;
   IS_RESOURCE  : result := FValue^.value.lval;
  else
    Result := 0;
  end;
end;

function TZendVariable.GetAsString: AnsiString;
begin
  if not Assigned(FValue) then
   begin
    Result := '';
    Exit;
   end;

  case FValue^._type of
   IS_STRING : begin
                 try
                   SetLength(Result, FValue^.value.str.len);
                   Move(FValue^.value.str.val^, Result[1], FValue^.value.str.len);
                 except
                   Result := '';
                 end;
               end;
   IS_DOUBLE : result := FloatToStr(FValue^.value.dval);
   IS_LONG   : result := IntToStr(FValue^.value.lval);
   IS_NULL   : result := '';
   IS_RESOURCE : result := IntToStr(FValue^.value.lval);
   IS_BOOL     :
      begin
        if FValue^.value.lval = 1 then
          Result := 'True'
           else
            result := 'False';
      end;
   else
    Result := '';
  end;
end;

function TZendVariable.GetAsTime: TDateTime;
begin
  if not Assigned(FValue) then
   begin
    Result := 0;
    Exit;
   end;

  case FValue^._type of
   IS_STRING : Result := StrToTime(GetAsString);
   IS_DOUBLE : Result := FValue^.value.dval;
  else
    Result := 0;
  end;
end;

function TZendVariable.GetAsVariant: variant;
begin
  if not Assigned(FValue) then
   begin
    Result := NULL;
    Exit;
   end;

  result := zval2variant(FValue^);
end;

function TZendVariable.GetDataType: integer;
begin
  if not Assigned(FValue) then
   begin
    Result := IS_NULL;
    Exit;
   end;

  Result := FValue^._type;
end;

function TZendVariable.GetIsNull: boolean;
begin
  if not Assigned(FValue) then
   begin
    Result := true;
    Exit;
   end;
  Result := FValue^._type = IS_NULL;
end;

function TZendVariable.GetTypeName: string;
begin
  if not Assigned(FValue) then
   begin
    Result := 'null';
    Exit;
   end;

  case FValue^._type of
		IS_NULL:    result :=  'null';
		IS_LONG:    result := 'integer';
		IS_DOUBLE:  result := 'double';
		IS_STRING:	result := 'string';
		IS_ARRAY:  	result := 'array';
		IS_OBJECT:	result := 'object';
		IS_BOOL:   	result := 'boolean';
		IS_RESOURCE: result :=  'resource';
     else
       result :=  'unknown';
   end;
end;

procedure TZendVariable.SetAsBoolean(const Value: boolean);
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  ZVAL_BOOL(FValue, Value);
end;

procedure TZendVariable.SetAsDate(const Value: TDateTime);
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  ZVAL_DOUBLE(FValue, Value);
end;

procedure TZendVariable.SetAsDateTime(const Value: TDateTime);
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  ZVAL_DOUBLE(FValue, Value);
end;

procedure TZendVariable.SetAsFloat(const Value: double);
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  ZVAL_DOUBLE(FValue, Value);
end;

procedure TZendVariable.SetAsInteger(const Value: integer);
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  ZVAL_LONG(FValue, Value);
end;

procedure TZendVariable.SetAsString(const Value: AnsiString);
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  ZVAL_STRINGL(FValue, PAnsiChar(Value), Length(Value), true);
end;

procedure TZendVariable.SetAsTime(const Value: TDateTime);
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  ZVAL_DOUBLE(FValue, Value);
end;

procedure TZendVariable.SetAsVariant(const Value: variant);
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  variant2zval(Value, FValue);
end;


procedure TZendVariable.UnAssign;
begin
  if not Assigned(FValue) then
   begin
    Exit;
   end;
  ZVAL_NULL(FValue);
end;


end.

