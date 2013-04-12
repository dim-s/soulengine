{*******************************************************}
{                     PHP4Delphi                        }
{                PHP  classes support                   }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{ http://delphi32.blogspot.com                          }
{*******************************************************}
{$I PHP.INC}

{ $Id: phpClass.pas,v 7.2 10/2009 delphi32 Exp $ }

unit phpClass;

interface

uses
  Windows, SysUtils, Classes, PHPCommon,
  ZendTypes, ZendAPI, phpTypes, PHPAPI,
  phpFunctions;

type
  // Instance of the class
  TPHPClassInstance = class;

  //Execute method
  TClassMethodExecute = procedure (Sender : TPHPClassInstance; Parameters : TFunctionParams;
    var ReturnValue : variant; ZendValue : pzval; this_ptr : pzval; TSRMLS_DC : pointer) of object;

  //Property
  TClassProperty = class(TCollectionItem)
  private
    FName  : AnsiString;
    FValue : AnsiString;
    function  GetAsBoolean: boolean;
    function  GetAsFloat: double;
    function  GetAsInteger: integer;
    procedure SetAsBoolean(const Value: boolean);
    procedure SetAsFloat(const Value: double);
    procedure SetAsInteger(const Value: integer);
  protected
    function  GetDisplayName : string; override;
  public
    procedure Assign(Source : TPersistent); override;
    property AsInteger : integer read GetAsInteger write SetAsInteger;
    property AsBoolean : boolean read GetAsBoolean write SetAsBoolean;
    property AsString  : AnsiString  read FValue write FValue;
    property AsFloat   : double  read GetAsFloat write SetAsFloat;
  published
    property Name  : AnsiString read FName write FName;
    property Value : AnsiString read FValue write FValue;
  end;

  //Collection of the class properties
  TClassProperties = class(TCollection)
  private
    FOwner : TComponent;
    procedure SetItem(Index: Integer; const Value: TClassProperty);
    function  GetItem(Index: Integer): TClassProperty;
  protected
    function  GetOwner : TPersistent; override;
  public
    function Add: TClassProperty;
    constructor Create(AOwner: TComponent);
    function GetVariables : AnsiString;
    function IndexOf(AName : AnsiString) : integer;
    function ByName(AName : AnsiString) : TClassProperty;
    property Items[Index: Integer]: TClassProperty read GetItem write SetItem; default;
  end;

  //The method of the class
  TPHPClassMethod = class(TCollectionItem)
  private
    FOnExecute : TClassMethodExecute;
    FName: AnsiString;
    FTag       : integer;
    FFunctionParams: TFunctionParams;
    FZendVar   : TZendVariable;
    procedure SetFunctionParams(const Value: TFunctionParams);
    procedure _SetDisplayName(value : AnsiString);
  public
    ReturnValue : variant;
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    function  GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
    procedure AssignTo(Dest: TPersistent); override;
    property  ZendVar: TZendVariable read FZendVar;
  published
    property Name : AnsiString read FName write _SetDisplayName;
    property Tag  : integer read FTag write FTag;
    property Parameters: TFunctionParams read FFunctionParams write SetFunctionParams;
    property OnExecute : TClassMethodExecute read FOnExecute write FOnExecute;
  end;

  //Collection of the class methods
  TPHPClassMethods = class(TCollection)
  private
    FOwner: TPersistent;
    function GetItem(Index: Integer): TPHPClassMethod;
    procedure SetItem(Index: Integer; Value: TPHPClassMethod);
  protected
    function GetOwner: TPersistent; override;
    procedure SetItemName(Item: TCollectionItem); override;
  public
    constructor Create(Owner: TPersistent; ItemClass: TCollectionItemClass);
    function Add : TPHPClassMethod;
    function ByName(AName : AnsiString) : TPHPClassMethod;
    property Items[Index: Integer]: TPHPClassMethod read GetItem write SetItem; default;
  end;

  //Represents PHP class
  TPHPClass = class(TPHPComponent)
  private
    FProperties : TClassProperties;
    FMethods    : TPHPClassMethods;
    FClassObject: pzend_class_entry;
    FClassName  : AnsiString;
    FClassEntry : tzend_class_entry;
    {$IFDEF PHP5}
    FClassFunction : array[0..1] of zend_function_entry;
    {$ENDIF}
    procedure SetProperties(const Value: TClassProperties);
    procedure SetMethods(const Value : TPHPClassMethods);
    procedure SetClassName(const Value: AnsiString);
  protected
    function  GetClassEntry : pzend_class_entry; virtual;
    procedure Loaded; override;
    function  InstanceConstructor(return_value : pzval) : TPHPClassInstance;
    property  ZendClassObject : pzend_class_entry read FClassObject write FClassObject;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure   ClassRegister(AModuleNumber : integer); virtual;
    procedure   ProduceInstance(AValue : pzval); virtual;
  published
    property Properties : TClassProperties read FProperties write SetProperties;
    property Methods : TPHPClassMethods read FMethods write SetMethods;
    property PHPClassName : AnsiString read FClassName write SetClassName;
  end;


  TPHPClassInstance = class(TComponent)
  private
    FProperties : TClassProperties;
    FProducer   : TPHPClass;
    procedure SetProperties(const Value: TClassProperties);
  protected
    property    Producer : TPHPClass read FProducer;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    property    Properties : TClassProperties read FProperties write SetProperties;
  end;


{$IFDEF PHP5}
procedure RegisterClassHandlers;
{$ENDIF}

implementation

uses
  phpModules;

var
 le_classresource : integer = 0;

 {$IFDEF PHP5}
 ClassObjectHandlers : zend_object_handlers;
 {$ENDIF}

const
 {$IFDEF PHP4}
 le_classresource_name = 'TPHPCLASS4';
 {$ELSE}
 le_classresource_name = 'TPHPCLASS5';
 {$ENDIF}

procedure class_destructor_handler(rsrc : PZend_rsrc_list_entry; TSRMLS_D : pointer); cdecl;
var
 resource : TPHPClassInstance;
begin
  if rsrc = nil then
   Exit;
  resource := rsrc^.ptr;
  if Assigned(Resource) then
   try
     resource.free;
   except
   end;
end;

{ TphpClass }


//when object created from script using "new"
function  class_call_constructor(AClassName : AnsiString; return_value : pzval) : TPHPClassInstance;
var
  Extension : TPHPExtension;
  idp : pointer;
  id : integer;
  cnt : integer;
begin
  Result := nil;
  idp := ts_resource_ex(integer(app_globals_id), nil);
  id := integer(idp^);
  if id <= 0 then
   Exit;
  Extension := TPHPExtension(id);
  for cnt := 0 to Extension.ComponentCount - 1 do
   begin
      if (Extension.Components[cnt] is TphpClass) then
       begin
         if SameText(AClassName, TphpClass(Extension.Components[cnt]).PHPClassName) then
          begin
            Result := TPHPClass(Extension.Components[cnt]).InstanceConstructor(return_value);
            break;
          end;
       end;
   end;
end;

{$IFDEF PHP4}

//PHP4
function class_set_property_handler(property_reference : Pzend_property_reference; value : pzval) : integer; cdecl;
var
 this_ptr : pzval;
 OBJ : TPHPClassInstance;
 data: ^ppzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 p : pointer;
 propname : AnsiString;
 tsrmls : pointer;
 param : TClassProperty;
begin
  tsrmls := ts_resource_ex(0, nil);
  element :=  property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  propname := prop^.element.value.str.val;

  this_ptr := property_reference^._object;
  new(data);
  if zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data) = SUCCESS then
    Obj := zend_fetch_resource(data^, TSRMLS, -1, 'class resource', nil, 1, le_classresource)
      else
        OBJ := nil;
  freemem(data);
  if Assigned(Obj) then
   begin
    convert_to_string(value);
    param := Obj.Properties.ByName(propname);
    if Assigned(param) then
     param.Value := value.value.str.val;
   end;
  Result := SUCCESS;
end;



//PHP4
procedure class_call_function(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer; property_reference : Pzend_property_reference ); cdecl;
var
 OBJ : TPHPClassInstance;
 Producer : TPHPClass;
 M : TPHPClassMethod;
 data: ^ppzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 p : pointer;
 MethodName : AnsiString;
 Params : pzval_array;
 j : integer;
begin
  element :=  property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  MethodName := prop^.element.value.str.val;
  this_ptr := property_reference^._object;
  new(data);
  if (zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data) = SUCCESS) then
   Obj := zend_fetch_resource(data^, TSRMLS_DC, -1, 'class resource', nil, 1, le_classresource)
     else
       Obj := nil;
  freemem(data);

  if not Assigned(Obj) then
   begin
     //not assigned obj = new instance (constructor)
     class_call_constructor(MethodName, this_ptr);
     exit;
   end;

  if ht > 0 then
    begin
      if ( not (zend_get_parameters_ex(ht, Params) = SUCCESS )) then
        begin
           zend_wrong_param_count(TSRMLS_DC);
           Exit;
        end;
    end;


   Producer := Obj.Producer;
   if Assigned(Producer) then
    begin
      M := Producer.Methods.ByName(MethodName);
      if Assigned(M) then
       begin
         if Assigned(M.FOnExecute) then
          begin
             if M.Parameters.Count <> ht then
                begin
                  zend_wrong_param_count(TSRMLS_DC);
                   Exit;
                end;

               if ht > 0 then
                  begin
                     for j := 0 to ht - 1 do
                       begin
                         if not IsParamTypeCorrect(M.Parameters[j].ParamType, Params[j]^) then
                            begin
                              zend_error(E_WARNING, PAnsiChar(Format('Wrong parameter type for %s()', [get_active_function_name(TSRMLS_DC)])));
                               Exit;
                             end;
                             M.Parameters[j].Value := zval2variant(Params[j]^^);
                           end;
                  end; // if ht > 0


             M.ZendVar.AsZendVariable := return_value; //direct access to zend variable
             M.FOnExecute(Obj, M.Parameters, M.ReturnValue, M.FZendVar.AsZendVariable, this_ptr, TSRMLS_DC);
             if M.ZendVar.ISNull then   //perform variant conversion
              variant2zval(M.ReturnValue, return_value);

          end;
       end;
    end;
   dispose_pzval_array(Params);
end;


//PHP4
procedure class_get_property_handler(val : pzval; property_reference : PZend_property_reference); cdecl;
var
 this_ptr : pzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 obj : TPHPClassInstance;
 p : pointer;
 propname : AnsiString;
 tsrmls : pointer;
 data: ^ppzval;
 param : TClassProperty;
begin
  tsrmls := ts_resource_ex(0, nil);
  element := property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  propname := prop^.element.value.str.val;
  this_ptr := property_reference^._object;
  new(data);
  if ( zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data) <> SUCCESS) then
   Obj := nil
     else
       Obj := zend_fetch_resource(data^, TSRMLS, -1, 'class resource', nil, 1, le_classresource);
  freemem(data);
  if Assigned(Obj) then
   begin
    param := Obj.Properties.ByName(propname);
    if Assigned(param) then
     ZVAL_STRING(val, PAnsiChar(param.value), true)
       else
         ZVAL_EMPTY_STRING(val)
   end
     else
       ZVAL_STRING(val, 'undefined', true);
end;

//PHP4
procedure _class_get_property_wrapper; assembler;
asm
  push        ebp
  mov         ebp,esp
  sub         esp,50h
  push        ebx
  push        esi
  push        edi
  lea         edi,[ebp-50h]
  mov         ecx,14h
  mov         eax,0CCCCCCCCh
  rep         stosd
  mov         eax,dword ptr [ebp+0Ch]
  push        eax
  lea         ecx,[ebp-10h]
  push        ecx
  call        class_get_property_handler
  add         esp,8
  mov         edx,dword ptr [ebp+8]
  mov         eax,dword ptr [ebp-10h]
  mov         dword ptr [edx],eax
  mov         ecx,dword ptr [ebp-0Ch]
  mov         dword ptr [edx+4],ecx
  mov         eax,dword ptr [ebp-8]
  mov         dword ptr [edx+8],eax
  mov         ecx,dword ptr [ebp-4]
  mov         dword ptr [edx+0Ch],ecx
  mov         eax,dword ptr [ebp+8]

  pop         edi
  pop         esi
  pop         ebx
  add         esp,50h
  cmp         ebp,esp
  mov         esp,ebp
  pop         ebp
  ret
end;
{$ENDIF}




{$IFDEF PHP5}

// Read object property value  (getter)
//PHP5
function class_get_property_handler(_object : pzval; member : pzval; _type : integer; TSRMLS_DC : pointer) : pzval; cdecl;
var
 retval : pzval;
 obj : TPHPClassInstance;
 data: ^ppzval;
 propname : AnsiString;
 object_properties : PHashTable;
 param : TClassProperty;
begin
  retval := emalloc(sizeof(zval));
  ZeroMemory(retval, sizeof(zval));
  propname := member^.value.str.val;
  new(data);
    try
     object_properties := Z_OBJPROP(_object);
     if zend_hash_find(object_properties, 'instance', strlen('instance') + 1, data) = SUCCESS then
      Obj := zend_fetch_resource(data^, TSRMLS_DC, -1, 'class resource', nil, 1, le_classresource)
       else
         Obj := nil;
     finally
      freemem(data);
    end;

  if Assigned(Obj) then
   begin
    param := Obj.Properties.ByName(propname);
    if Assigned(param) then
     ZVAL_STRING(retval, PAnsiChar(param.value), true)
       else
         ZVAL_EMPTY_STRING(retval);
   end
     else
       ZVAL_STRING(retval, 'undefined', true);

  retval.refcount := 1;
  Result := retval;
end;

// Write object property value (setter)
//PHP5
procedure class_set_property_handler(_object : pzval; member : pzval; value : pzval; TSRMLS_DC : pointer); cdecl;
var
 OBJ : TPHPClassInstance;
 data: ^ppzval;
 propname : AnsiString;
 object_properties : PHashTable;
 param : TClassProperty;
begin
  propname := member^.value.str.val;
  new(data);
    try
     object_properties := Z_OBJPROP(_object);
     if zend_hash_find(object_properties, 'instance', strlen('instance') + 1, data) = SUCCESS then
      Obj := zend_fetch_resource(data^, TSRMLS_DC, -1, 'class resource', nil, 1, le_classresource)
       else
         Obj := nil;
     finally
      freemem(data);
    end;

  if Assigned(Obj) then
   begin
    convert_to_string(value);
    param := Obj.Properties.ByName(propname);
    if Assigned(param) then
     param.Value := value.value.str.val;
   end;

end;

{$IFDEF PHP510}
function class_call_method(method : PAnsiChar; ht : integer; return_value : pzval; return_value_ptr : ppzval;
    this_ptr : pzval; return_value_used : integer; TSRMLS_DC : pointer) : integer; cdecl;
{$ELSE}
function class_call_method(method : PAnsiChar; ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer) : integer; cdecl;
{$ENDIF}
var
 OBJ : TPHPClassInstance;
 data: ^ppzval;
 Params : pzval_array;
 Producer : TPHPClass;
 M : TPHPClassMethod;
 j : integer;
begin
 new(data);
 if zend_hash_find(this_ptr^.value.obj.handlers.get_properties(this_ptr, TSRMLS_DC), 'instance', strlen('instance') + 1, data) = SUCCESS then
   Obj := zend_fetch_resource(data^, TSRMLS_DC, -1, 'class resource', nil, 1, le_classresource)
   else
     Obj := nil;
  freemem(data);

  if not Assigned(Obj) then
   begin
     //not assigned obj = new instance (constructor)
     class_call_constructor(Method, this_ptr);
     Result := SUCCESS;
     exit;
   end;

  if ht > 0 then
    begin
      if ( not (zend_get_parameters_ex(ht, Params) = SUCCESS )) then
        begin
           zend_wrong_param_count(TSRMLS_DC);
           Result := FAILURE;
           Exit;
        end;
    end;


   Producer := Obj.Producer;
   if Assigned(Producer) then
    begin
      M := Producer.Methods.ByName(Method);
      if Assigned(M) then
       begin
         if Assigned(M.FOnExecute) then
          begin
             if M.Parameters.Count <> ht then
                begin
                  zend_wrong_param_count(TSRMLS_DC);
                   Result := FAILURE;
                   Exit;
                end;

               if ht > 0 then
                  begin
                     for j := 0 to ht - 1 do
                       begin
                         if not IsParamTypeCorrect(M.Parameters[j].ParamType, Params[j]^) then
                            begin
                              zend_error(E_WARNING, PAnsiChar(Format('Wrong parameter type for %s()', [get_active_function_name(TSRMLS_DC)])));
                               Result := FAILURE;
                               Exit;
                             end;
                             M.Parameters[j].ZendValue := (Params[j]^);
                           end;
                  end; // if ht > 0


             M.ZendVar.AsZendVariable := return_value; //direct access to zend variable
             M.FOnExecute(Obj, M.Parameters, M.ReturnValue, M.FZendVar.AsZendVariable, this_ptr, TSRMLS_DC);
             if M.ZendVar.ISNull then   //perform variant conversion
              variant2zval(M.ReturnValue, return_value);

          end;
       end;
    end;
   dispose_pzval_array(Params);

  result := SUCCESS;
end;

//PHP5
function class_get_method(_object : pzval; method_name : PAnsiChar; method_len : integer; TSRMLS_DC : pointer) : PzendFunction; cdecl;
var
 fnc : pZendFunction;
begin
  fnc := emalloc(sizeof(TZendFunction));

  ZeroMemory(fnc, sizeOf(TZendFunction));

  fnc^.internal_function._type := ZEND_OVERLOADED_FUNCTION;

  {$IFNDEF COMPILER_VC9}
  fnc^.internal_function.function_name := strdup(method_name);
  {$ELSE}
  fnc^.internal_function.function_name := DupStr(method_name);
  {$ENDIF}

  fnc^.internal_function.handler := @class_call_method;
  result := fnc;
end;


{$IFDEF PHP510}
procedure class_init_new(ht : integer; return_value : pzval; return_value_ptr : ppzval;
     this_ptr : pzval;  return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure class_init_new(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 AClassName : PAnsiChar;
 len : integer;
 Extension : TPHPExtension;
 idp : pointer;
 id : integer;
 cnt : integer;
begin
 if not Assigned(Application) then
  Exit;

  AClassName := '';
  this_ptr^.value.obj.handlers.get_class_name(this_ptr, @AClassName, @len, 0, TSRMLS_DC);

  idp := ts_resource_ex(integer(app_globals_id), nil);
  id := integer(idp^);
  if id <= 0 then
   Exit;
  Extension := TPHPExtension(id);
  for cnt := 0 to Extension.ComponentCount - 1 do
   begin
      if (Extension.Components[cnt] is TphpClass) then
       begin
         if SameText(AClassName, TphpClass(Extension.Components[cnt]).PHPClassName) then
          begin
            TPHPClass(Extension.Components[cnt]).ProduceInstance(this_ptr);
            break;
          end;
       end;
   end;


end;

{$ENDIF}


procedure TPHPClass.ClassRegister(AModuleNumber : integer);
var
 tsrmls : pointer;
begin
  if not Assigned(Application) then
   Exit;

  if not Application.Loading then
   Exit;

  if (csDesigning in ComponentState) then
   Exit;

  {$IFDEF PHP5}
  RegisterClassHandlers;
  {$ENDIF}

  if le_classresource = 0 then
   le_classresource := zend_register_list_destructors_ex(@class_destructor_handler, nil, PAnsiChar(le_classresource_name), AModuleNumber);

  if (Application.GetPHPClass(FClassName) = nil) then
   begin
    tsrmls := ts_resource_ex(0, nil);

    ZeroMemory(@FClassEntry, SizeOf(TZend_Class_Entry));

    {$IFDEF PHP5}
    FClassFunction[0].fname := PAnsiChar(FClassName);
    FClassFunction[0].handler := @class_init_new;
    INIT_CLASS_ENTRY(FClassEntry, PAnsiChar(FClassName) , @FClassFunction);
    {$ELSE}
    INIT_CLASS_ENTRY(FClassEntry, PAnsiChar(FClassName) , nil);
    {$ENDIF}


    FClassObject := zend_register_internal_class(@FClassEntry,  tsrmls);

    {$IFDEF PHP4}
    FClassObject.handle_property_get :=   @_class_get_property_wrapper;
    FClassObject.handle_property_set :=   @class_set_property_handler;
    FClassObject.handle_function_call :=  @class_call_function;
    {$ENDIF}


    Application.RegisterPHPClass(FClassName, FClassObject);
  end;
end;

constructor TPHPClass.Create(AOwner: TComponent);
begin
  inherited;
  if Assigned(Owner) then
   begin
     if ( not (AOwner is TCustomPHPExtension)) then
       raise Exception.Create('TPHPClass component can be placed only on PHPExtension module');
   end;
  FProperties := TClassProperties.Create(Self);
  FMethods := TPHPClassMethods.Create(Self, TPHPClassMethod);
end;

destructor TPHPClass.Destroy;
begin
   FProperties.Free;
   FMethods.Free;
  inherited;
end;

function TPHPClass.GetClassEntry: pzend_class_entry;
begin
  Result := Application.GetPHPClass(FClassName);
end;

function TPHPClass.InstanceConstructor(return_value : pzval): TPHPClassInstance;
var
 CI : TphpClassInstance;
 rn : integer;
 tsrmls : pointer;
begin
  Result := nil;
  if not Assigned(Application) then
    Exit;
  tsrmls := ts_resource_ex(0, nil);
  CI := TPHPClassInstance.Create(nil);
  CI.FProperties.Assign(FProperties);
  CI.FProducer := Self;
  Result := CI;
  rn := zend_register_resource(nil, CI, le_classresource);
  FClassObject := GetClassEntry;
  if not assigned(FClassObject) then
   Exit;
   {$IFDEF PHP4}
  _object_init_ex(return_value, FClassObject, nil, 0, TSRMLS);
  {$ELSE}
  object_init(return_value, FClassObject,  TSRMLS );
   {$ENDIF}

  {$IFDEF PHP4}
  add_property_resource_ex(return_value, 'instance', strlen('instance') +1, rn);
  {$ELSE}
  add_property_resource_ex(return_value, 'instance', strlen('instance') +1, rn, TSRMLS);
  {$ENDIF}

 {$IFDEF PHP5}
   return_value.value.obj.handlers := @ClassObjectHandlers;
 {$ENDIF}
  
end;

procedure TPHPClass.Loaded;
begin
  inherited;
  if ( not (csDesigning in ComponentState))  then
   begin
     if Assigned(Application) then
      ClassRegister(Application.ModuleNumber);
   end;
end;

procedure TPHPClass.ProduceInstance(AValue: pzval);
var
 CI : TphpClassInstance;
 rn : integer;
 tsrmls : pointer;
begin
 if not Assigned(Application) then
  Exit;
 tsrmls := ts_resource_ex(0, nil);
 CI := TPHPClassInstance.Create(nil);
 CI.FProperties.Assign(FProperties);
 CI.FProducer := Self;
 rn := zend_register_resource(nil, CI, le_classresource);
 FClassObject := Application.GetPHPClass(FClassName);
 if not assigned(FClassObject) then
  Exit;

  {$IFDEF PHP4}
 _object_init_ex(AValue, FClassObject, nil, 0, TSRMLS);
  {$ELSE}
  object_init(AValue, FClassObject, TSRMLS );
 {$ENDIF}

 {$IFDEF PHP4}
 add_property_resource_ex(AValue, 'instance', strlen('instance') +1, rn);
 {$ELSE}
 add_property_resource_ex(AValue, 'instance', strlen('instance') +1, rn, TSRMLS);
 {$ENDIF}

 {$IFDEF PHP5}
   AValue.value.obj.handlers := @ClassObjectHandlers;
 {$ENDIF}

end;

procedure TPHPClass.SetClassName(const Value: AnsiString);
begin
  FClassName := LowerCase(Value);
end;

procedure TPHPClass.SetMethods(const Value: TPHPClassmethods);
begin
  FMethods.Assign(Value);
end;

procedure TphpClass.SetProperties(const Value: TClassProperties);
begin
  FProperties.Assign(Value);
end;

{ TPHPClassInstance }

constructor TPHPClassInstance.Create;
begin
  inherited;
  FProperties := TClassProperties.Create(Self);
end;

destructor TPHPClassInstance.Destroy;
begin
  FProperties.Free;
  inherited;
end;


procedure TPHPClassInstance.SetProperties(const Value: TClassProperties);
begin
  FProperties.Assign(Value);
end;


{ TClassProperty }

procedure TClassProperty.Assign(Source: TPersistent);
begin
  if (Source is TClassProperty) then
   begin
     FName := TClassProperty(Source).Name;
     FValue := TClassProperty(Source).Value;
   end
    else
     inherited;
end;

function TClassProperty.GetAsBoolean: boolean;
begin
  if FValue = '' then
   begin
    Result := false;
    Exit;
   end;

 if SameText(FValue, 'True') then
  Result := true
   else
    Result := false;
end;

function TClassProperty.GetAsFloat: double;
begin
  if FValue = '' then
   begin
    Result := 0;
    Exit;
   end;

  Result := ValueToFloat(FValue);
end;

function TClassProperty.GetAsInteger: integer;
var
 {$IFDEF VERSION12}
 c : WideChar;
 {$ELSE}
 c : AnsiChar;
 {$ENDIF}
begin
  c := DecimalSeparator;
  try
    DecimalSeparator := '.';
    Result := Round(ValueToFloat(FValue));
  finally
   DecimalSeparator := c;
  end;
end;

function TClassProperty.GetDisplayName: string;
begin
  if FName = '' then
   result := inherited GetDisplayName
    else
      Result := FName;
end;

procedure TClassProperty.SetAsBoolean(const Value: boolean);
begin
  if Value then
   FValue := 'True'
    else
      FValue := 'False';
end;

procedure TClassProperty.SetAsFloat(const Value: double);
begin
  FValue := FloatToValue(Value);
end;

procedure TClassProperty.SetAsInteger(const Value: integer);
var
 {$IFDEF VERSION12}
 c : WideChar;
 {$ELSE}
 c : AnsiChar;
 {$ENDIF}
begin
  c := DecimalSeparator;
  try
   DecimalSeparator := '.';
   FValue := IntToStr(Value);
  finally
   DecimalSeparator := c;
  end;
end;


{ TClassProperties }
function TClassProperties.Add: TClassProperty;
begin
  result := TClassProperty(inherited Add);
end;

constructor TClassProperties.Create(AOwner: TComponent);
begin
 inherited create(TClassProperty);
 FOwner := AOwner;
end;

function TClassProperties.GetItem(Index: Integer): TClassProperty;
begin
  Result := TClassProperty(inherited GetItem(Index));
end;

procedure TClassProperties.SetItem(Index: Integer; const Value: TClassProperty);
begin
  inherited SetItem(Index, Value)
end;

function TClassProperties.GetOwner : TPersistent;
begin
  Result := FOwner;
end;

function TClassProperties.GetVariables: AnsiString;
var i : integer;
begin
  for i := 0 to Count - 1 do
    begin
      Result := Result + Items[i].FName + '=' + Items[i].FValue;
      if i < Count - 1 then
        Result := Result + '&';
    end;
end;

function TClassProperties.IndexOf(AName: AnsiString): integer;
var
 i : integer;
begin
 Result := -1;
 for i := 0 to Count - 1 do
  begin
    if SameText(Items[i].Name, AName) then
     begin
       Result := i;
       break;
     end;
  end;
end;


function TClassProperties.ByName(AName: AnsiString): TClassProperty;
var
 i : integer;
begin
 Result := nil;
 for i := 0 to Count - 1 do
  begin
    if SameText(Items[i].Name, AName) then
     begin
       Result := Items[i];
       break;
     end;
  end;
end;

{ TPHPClassMethods }

function TPHPClassMethods.Add: TPHPClassMethod;
begin
  Result := TPHPClassMethod(inherited Add);
end;

function TPHPClassMethods.ByName(AName: AnsiString): TPHPClassMethod;
var
 i : integer;
begin
 Result := nil;
 for i := 0 to Count - 1 do
  begin
    if SameText(Items[i].Name, AName) then
     begin
       Result := Items[i];
       break;
     end;
  end;
end;

constructor TPHPClassMethods.Create(Owner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FOwner := Owner;
end;

function TPHPClassMethods.GetItem(Index: Integer): TPHPClassMethod;
begin
  Result := TPHPClassMethod(inherited GetItem(Index));
end;

function TPHPClassMethods.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TPHPClassMethods.SetItem(Index: Integer; Value: TPHPClassMethod);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

procedure TPHPClassMethods.SetItemName(Item: TCollectionItem);
var
  I, J: Integer;
  ItemName: string;
  CurItem: TPHPClassMethod;
begin
  J := 1;
  while True do
  begin
    ItemName := Format('classmethod%d', [J]);
    I := 0;
    while I < Count do
    begin
      CurItem := Items[I] as TPHPClassMethod;
      if (CurItem <> Item) and (CompareText(CurItem.Name, ItemName) = 0) then
      begin
        Inc(J);
        Break;
      end;
      Inc(I);
    end;
    if I >= Count then
    begin
      (Item as TPHPClassMethod).Name := ItemName;
      Break;
    end;
  end;
end;

{ TPHPClassMethod }

procedure TPHPClassMethod.AssignTo(Dest: TPersistent);
begin
  if Dest is TPHPClassMethod then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      with TPHPClassMethod(Dest) do
      begin
        Tag := Self.Tag;
        Name := Self.Name;
      end;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end else inherited AssignTo(Dest);
end;

constructor TPHPClassMethod.Create(Collection: TCollection);
begin
  inherited;
  FFunctionParams := TFunctionParams.Create(TPHPClassMethods(Self.Collection).GetOwner, TFunctionParam);
  FZendVar := TZendVariable.Create;
end;

destructor TPHPClassMethod.Destroy;
begin
  FFunctionParams.Free;
  FZendVar.Free;
  inherited;
end;

function TPHPClassMethod.GetDisplayName: string;
begin
  if FName = '' then
   result :=  inherited GetDisplayName else
     Result := FName;
end;

procedure TPHPClassMethod.SetDisplayName(const Value: string);
var
  I: Integer;
  F: TPHPClassMethod;
begin
  if AnsiCompareText(Value, FName) <> 0 then
  begin
    if Collection <> nil then
      for I := 0 to Collection.Count - 1 do
      begin
        F := TPHPClassMethods(Collection).Items[I];
        if (F <> Self) and (F is TPHPClassMethod) and
          (AnsiCompareText(Value, F.Name) = 0) then
          raise Exception.Create('Duplicate method name');
      end;
    FName :=  LowerCase(Value);
    Changed(False);
  end;
end;

procedure TPHPClassMethod._SetDisplayName(Value: AnsiString);
var
  NewName : string;
begin
  NewName := value;
  SetDisplayName(NewName);
end;

procedure TPHPClassMethod.SetFunctionParams(const Value: TFunctionParams);
begin
  FFunctionParams.Assign(Value);
end;


{$IFDEF PHP5}
procedure RegisterClassHandlers;
begin
  Move(zend_get_std_object_handlers()^, ClassObjectHandlers, sizeof(zend_object_handlers));
  ClassObjectHandlers.read_property := @class_get_property_handler;
  ClassObjecthandlers.write_property := @class_set_property_handler;
  ClassObjectHandlers.call_method := @class_call_method;
  ClassObjectHandlers.get_method := @class_get_method;
end;
{$ENDIF}

end.
