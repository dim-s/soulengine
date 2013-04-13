unit uPhpEvents;

{$I 'sDef.inc'}

{$ifdef fpc}
        {$mode delphi}
{$endif}

interface

uses
  Windows,
  Classes, SysUtils, typinfo, ExtCtrls, StdCtrls, ComCtrls, SizeControl,
  Forms, Dialogs, Buttons, Controls,
  dwsHashtables, zendAPI, phpApi, ZENDTypes, php4delphi


      {$IFDEF ADD_CHROMIUM}
  , ceflib, cefvcl
      {$ENDIF}

      {$IFDEF VS_EDITOR}
  , NxPropertyItems, NxPropertyItemClasses, NxScrollControl,
  NxInspector, SynEditTypes, SynEdit, SynCompletionProposal,
  CategoryButtons
      {$ENDIF}    ;

type
  THandlerFuncs = class(TObject)
  public
    procedure onClick(Sender: TObject);
    procedure onDblClick(Sender: TObject);
    procedure onChange(Sender: TObject);
    procedure onSelect(Sender: TObject);
    procedure onChanging(Sender: TObject; var AllowChange: boolean);
    procedure onMoved(Sender: TObject);

    procedure onKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure onKeyUp(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure onKeyPress(Sender: TObject; var Key: char);


    procedure onMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure onMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure onMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
    procedure onMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
    procedure onMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: integer;
      var MouseActivate: TMouseActivate);


    procedure onScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: integer);
    procedure onPopup(Sender: TObject);

    { --- edit --- }
    procedure onEdited(Sender: TObject; Item: TListItem; var S: string);
    procedure onEditing(Sender: TObject; Item: TListItem; var AllowEdit: boolean);

    procedure onTimer(Sender: TObject);
    procedure onExecute(Sender: TObject);

    procedure onActivate(Sender: TObject);
    procedure onDeactivate(Sender: TObject);
    procedure onCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure onClose(Sender: TObject);
    procedure onResize(Sender: TObject);
    procedure onCanResize(Sender: TObject;
      var NewWidth, NewHeight: integer; var Resize: boolean);
    procedure onShow(Sender: TObject);
    procedure onHide(Sender: TObject);
    procedure onPaint(Sender: TObject);

    procedure onFocus(Sender: TObject);
    procedure onBlur(Sender: TObject);

    /// docks ///
    procedure onStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure onEndDock(Sender, Target: TObject; X, Y: integer);
    procedure onUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: boolean);
    procedure onDockDrop(Sender: TObject; Source: TDragDockObject; X, Y: integer);
    procedure onDockOver(Sender: TObject; Source: TDragDockObject;
      X, Y: integer; State: TDragState; var Accept: boolean);
    procedure onDragDrop(Sender, Source: TObject; X, Y: integer);
    procedure onDragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: boolean);

    procedure onDropFiles(Sender: TObject; Files: TStrings; X: integer; Y: integer);

    { --- size controls  }
    procedure onDuringSizeMove(Sender: TObject; dx, dy: integer; State: TSCState);
    procedure onStartSizeMove(Sender: TObject; State: TSCState);
    procedure onEndSizeMove(Sender: TObject; State: TSCState);
    procedure onSetCursor(Sender: TObject; Target: TControl;
      TargetPt: TPoint; var handled: boolean);
    procedure onSizeMouseDown(Sender: TObject; Target: TControl;
      TargetPt: TPoint; var handled: boolean);


    {-- synedit --}
        {$IFDEF VS_EDITOR}
    procedure onSynClose(Sender: TObject);
    procedure onMouseCursor(Sender: TObject;
      const aLineCharPos: TBufferCoord; var aCursor: TCursor);


    procedure onVSInsChange(Sender: TObject;
      Item: TNxPropertyItem; Value: WideString);
    procedure onVSInsEdit(Sender: TObject;
      Item: TNxPropertyItem; Value: WideString;
      var Accept: boolean);
    procedure onVSInsToolBarClick(Sender: TObject;
      Item: TNxPropertyItem; ButtonIndex: integer);

    procedure onButtonClick(Sender: TObject);
    procedure onCatButtonClicked(Sender: TObject; const Button: TButtonItem);

        {$ENDIF}


        {$IFDEF ADD_CHROMIUM}
    procedure OnChromiumBeforePopup(Sender: TObject;
      const parentBrowser: ICefBrowser; var popupFeatures: TCefPopupFeatures;
      var windowInfo: TCefWindowInfo; var url: ustring;
      var client: ICefBase; out Result: boolean);

    procedure OnChromiumBeforeMenu(Sender: TObject; const browser: ICefBrowser;
      const menuInfo: PCefHandlerMenuInfo; out Result: boolean);

    procedure onChromiumBeforeBrowse(Sender: TCustomChromium;
      const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; navType: TCefHandlerNavtype;
      isRedirect: boolean; out Result: boolean);

    procedure OnAuthCredentials(Sender: TObject; const browser: ICefBrowser;
      isProxy: boolean; Port: integer; const host, realm, scheme: ustring;
      var username, password: ustring; out Result: boolean);

    procedure OnGetDownloadHandler(Sender: TObject; const browser: ICefBrowser;
      const mimeType, fileName: ustring; contentLength: int64;
      var handler: ICefDownloadHandler; out Result: boolean);

    procedure OnConsoleMessage(Sender: TObject; const browser: ICefBrowser;
      message, Source: ustring; line: integer; out Result: boolean);

    procedure OnLoadStart(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame);
    procedure OnLoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: integer; out Result: boolean);
    procedure OnLoadError(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
      const failedUrl: ustring; var errorText: ustring;
      out Result: boolean);

    procedure OnStatusMessage(Sender: TObject; const browser: ICefBrowser;
      const Value: ustring; StatusType: TCefHandlerStatusType; out Result: boolean);

    procedure OnAddressChange(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring);

    procedure OnTitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring; out Result: boolean);

    procedure OnTooltip(Sender: TObject; const browser: ICefBrowser;
      var Text: ustring; out Result: boolean);

    procedure OnContentsSizeChange(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; Width, Height: integer);

    procedure OnChromiumLibLoad(Sender: TObject);
        {$ENDIF}

    procedure SafeOnTimer(Sender: TObject);
  end;




type
  TScriptEventHandler = class;
  TPHPScriptEventHandler = class;

  TPHPScriptEvents = class(TObject)
  protected
    Events: TStringList;
    This: Pointer;
    TSRMLS_DC: Pointer;
  public
    function GetEvent(const Name: ansistring): TPHPScriptEventHandler;
    function RunEvent(const Name: ansistring;
      Args: array of const): TPHPScriptEventHandler;
    procedure ClearEvent(const Name: ansistring);
    procedure AddEvent(const Name: ansistring; Call: pzval;
      First: boolean = False; aIsThread: boolean = False);
    procedure SetEvent(const Name: ansistring; Call: pzval);
    function GetFirstEvent(const Name: ansistring): pzval;
    constructor Create(This, TSRMLS_DC: Pointer);
    destructor Destroy; override;
  end;


  TScriptEventHandler = class(TObject)
  protected
    CallBack: TList;
    This: Pointer;
    Return: Pointer;
    function GetCallback(Data: Pointer): Pointer; virtual;
    procedure Execute(Data: Pointer); virtual; abstract;
  public
    procedure Run(Args: array of const); virtual;
    constructor Create(This: Pointer);
    destructor Destroy; override;

    procedure AddCallback(Data: Pointer);
    procedure AddCallbackFirst(Data: Pointer);
    procedure Clear; virtual;
  end;

  TPHPScriptEventHandler = class(TScriptEventHandler)
  protected
    TSRMLS_DC: Pointer;
    Args: pzval_array_ex;
    AddArgs: pzval_array_ex;

    function GetCallback(Data: Pointer): Pointer; override;
    procedure Execute(Data: Pointer); override;

    procedure CopyVal(dest: integer; src: pzval);
  public
    IsThread: boolean;
    function ParamBool(Index: integer): boolean;
    function ParamChar(Index: integer): AnsiChar;
    function ParamInt(Index: integer): integer;
    function ParamPtr(Index: integer): Pointer;
    function ParamDouble(Index: integer): double;
    function ParamString(Index: integer): ansistring;

    procedure AddArg(arg: pzval);
    procedure ClearAddArg;

    procedure Clear; override;
    procedure ClearArgs;
    procedure Run(Args: array of const); override;
    constructor Create(This: Pointer; TSRMLS_DC: Pointer);
  end;

  TScriptThread = class;

  TScriptThreadHelper = class(TThread)
  protected
    Main: TScriptThread;
  public
    Data: ansistring;
    MyData: ansistring;
    procedure Execute; override;
    procedure CallSyncFunc;
    constructor Create(Main: TScriptThread);
  end;

  {$M+}
  TScriptThread = class(TComponent)
  private
    FOnExecute: TNotifyEvent;
    FImportClasses: boolean;
    FImportFunctions: boolean;
    FImportConstants: boolean;
    FImportGlobals: boolean;
    procedure SetOnExecute(const Value: TNotifyEvent);
    procedure SetImportClasses(const Value: boolean);
    procedure SetImportConstants(const Value: boolean);
    procedure SetImportFunctions(const Value: boolean);
    procedure SetImportGlobals(const Value: boolean);
  public
    psv: TpsvPHP;
    compiler_globals: Pzend_compiler_globals;
    executor_globals: pzend_executor_globals;
    addDATA: TStringHashTable;

    FThread: TScriptThreadHelper;

    class procedure SetBeforeCode(const Code: ansistring);

    procedure Execute;
    procedure Resume;
    procedure Suspend;

    procedure Sync(Func, MyData: ansistring);

    constructor Create;
    destructor Destroy; override;
  published
    property OnExecute: TNotifyEvent read FOnExecute write SetOnExecute;
    property ImportFunctions: boolean read FImportFunctions
      write SetImportFunctions default True;
    property ImportConstants: boolean read FImportConstants
      write SetImportConstants default True;
    property ImportClasses: boolean
      read FImportClasses write SetImportClasses default True;
    property ImportGlobals: boolean
      read FImportGlobals write SetImportGlobals default True;
  end;

  {$M-}


function GetEventController(Obj: TObject; TSRMLS_DC: Pointer): TPHPScriptEvents;
procedure FreeEventController(Obj: TObject);
procedure InitializeEventSystem(PHPEngine: TPHPEngine);
procedure FinalizeEventSystem;

function ScriptThreadCreate: TScriptThread;
function GetMaxCntThreads: word;
function GetCntThreads: word;
procedure SetMaxCntThreads(Cnt: word);

type
  TScriptSafeCommand = class(TObject)
  protected
    Data: Pointer;
  public
    constructor Create(Data: Pointer = nil);
    procedure Execute; virtual; abstract;
  end;

  TScriptSafeCommand_Destroy = class(TScriptSafeCommand)
  public
    procedure Execute; override;
  end;

  TScriptSafeCommand_Message = class(TScriptSafeCommand)
  public
    procedure Execute; override;
    destructor Destroy; override;
  end;

  TScriptSafeCommand_ThreadDestroy = class(TScriptSafeCommand)
  public
    procedure Execute; override;
  end;

implementation

uses
  core;

var
  ObjectController: TList;
  ObjectHandlers: TList;
  EventTypes: TStringList = nil;
  EventClassType: TList = nil;
  EventTypesThread: TList;
  SafeTimer: TTimer;
  SafeCommand: TList;

  SafeList_CRITICAL: TRTLCriticalSection;
  StartRequest_CRITICAL: TRTLCriticalSection;
  CntThreads_CRITICAL: TRTLCriticalSection;

  ThreadBeforeCode: ansistring = '';
  CntThreads: word = 0;
  MaxCntThreads: word = 300;

procedure zval_copy(var dest: pzval; src: pzval);
var
  tmp: pointer;
begin
  dest._type := src._type;
  case src._type of
    IS_LONG, IS_BOOL: dest.Value.lval := src.Value.lval;
    IS_DOUBLE: dest.Value.dval := src.Value.dval;
    IS_STRING:
    begin
      ZVAL_STRINGL(dest, src.Value.str.val, src.Value.str.len, True);
    end;
    IS_ARRAY:
    begin
      tmp := nil;
      zend_hash_copy(dest.Value.ht, src.Value.ht, @zend_addref_p,
        tmp, sizeof(pzval));
    end;
    else
      dest._type := IS_NULL;
  end;
end;

function ScriptThreadCreate: TScriptThread;
begin
  EnterCriticalSection(CntThreads_CRITICAL);
  Inc(CntThreads);
  LeaveCriticalSection(CntThreads_CRITICAL);

  while CntThreads > MaxCntThreads do
  begin
  end;

  Result := TScriptThread.Create;
end;

function GetCntThreads: word;
begin
  Result := CntThreads;
end;

function GetMaxCntThreads: word;
begin
  Result := MaxCntThreads;
end;

procedure SetMaxCntThreads(Cnt: word);
begin
  if Cnt > 500 then
    Cnt := 500;
  if Cnt < 1 then
    Cnt := 1;

  MaxCntThreads := Cnt;
end;

(*
ZEND_API void _zval_ptr_dtor(zval **zval_ptr ZEND_FILE_LINE_DC)
{
#if DEBUG_ZEND>=2
        printf("Reducing refcount for %x (%x):  %d->%d\n", *zval_ptr, zval_ptr, (*zval_ptr)->refcount, (*zval_ptr)->refcount-1);
#endif
        (*zval_ptr)->refcount--;
        if ((*zval_ptr)->refcount==0) {
                zval_dtor(*zval_ptr);
                safe_free_zval_ptr_rel(*zval_ptr ZEND_FILE_LINE_RELAY_CC ZEND_FILE_LINE_CC);
        } else if ((*zval_ptr)->refcount == 1) {
                if ((*zval_ptr)->type == IS_OBJECT) {
                        TSRMLS_FETCH();

                        if (EG(ze1_compatibility_mode)) {
                                return;
                        }
                }
                (*zval_ptr)->is_ref = 0;
        }
}     *)


procedure zval_dtor_func(val: pzval);
begin
  //efree(val);
   {Dec(val^.refcount);
   if val^.refcount = 0 then }
  _zval_dtor(val, nil, 0);
end;

function Shift2Str(Shift: TShiftState): string;
var
  Arr: TStrings;
begin
  Arr := TStringList.Create;
  if Shift = Shift + [ssShift] then
    Arr.Add('ssShift');
  if Shift = Shift + [ssAlt] then
    Arr.Add('ssAlt');
  if Shift = Shift + [ssCtrl] then
    Arr.Add('ssCtrl');
  if Shift = Shift + [ssLeft] then
    Arr.Add('ssLeft');
  if Shift = Shift + [ssRight] then
    Arr.Add('ssRight');
  if Shift = Shift + [ssMiddle] then
    Arr.Add('ssMiddle');
  if Shift = Shift + [ssDouble] then
    Arr.Add('ssDouble');

  Result := StringReplace(Arr.Text, #13#10, ',', [rfReplaceAll]);
  Arr.Free;
end;

function Str2Shift(const S: string): TShiftState;
begin
  Result := [];
  if Pos('ssShift', S) > 0 then
    Result := Result + [ssShift];
  if Pos('ssAlt', S) > 0 then
    Result := Result + [ssAlt];
  if Pos('ssCtrl', S) > 0 then
    Result := Result + [ssCtrl];
  if Pos('ssLeft', S) > 0 then
    Result := Result + [ssLeft];
  if Pos('ssRight', S) > 0 then
    Result := Result + [ssRight];
  if Pos('ssMiddle', S) > 0 then
    Result := Result + [ssMiddle];
  if Pos('ssDouble', S) > 0 then
    Result := Result + [ssDouble];
end;

procedure EventRun(Sender: TObject; Event: ansistring); overload;
var
  H: TPHPScriptEvents;
  M: TPHPScriptEventHandler;
begin
  H := GetEventController(Sender, nil);
  if H <> nil then
  begin
    M := H.RunEvent(Event, []);
     {if M <> nil then
        M.ClearArgs; }
  end;
end;

function EventRun(Sender: TObject; Event: ansistring; Args: array of const;
  ClearArgs: boolean = True): TPHPScriptEventHandler; overload;
var
  H: TPHPScriptEvents;
begin
  H := GetEventController(Sender, nil);
  if H <> nil then
  begin
    Result := H.RunEvent(Event, Args);
    if ClearArgs and (Result <> nil) then
      Result.ClearArgs;
  end
  else
    Result := nil;
end;


procedure EventAddNewType(Event: ansistring; Handler: Pointer;
  TypeClass: TClass = nil; IsThread: byte = 0);
begin
  if EventTypes = nil then
  begin
    EventTypes := TStringList.Create;
    EventClassType := TList.Create;
    EventTypesThread := TList.Create;
  end;

  EventClassType.Add(TypeClass);
  EventTypesThread.Add(Pointer(IsThread));
  EventTypes.AddObject(Event, TObject(Handler));
end;

// return true/false -
function EventExists(Obj: TObject; Event: ansistring): boolean;
var
  i: integer;
begin
  Event := LowerCase(Event);
  Result := True;

  for i := EventTypes.Count - 1 downto 0 do
  begin
    if LowerCase(EventTypes[i]) = Event then
      if (EventClassType[i] = nil) or (Obj.InheritsFrom(EventClassType[i])) then
        exit;
  end;
  Result := False;
end;

function EventSet(Obj: TObject; Event: ansistring): boolean;
var
  MT: TMethod;
  Func: Pointer;
  ID, i: integer;
begin

  Event := LowerCase(Event);

  ID := -1;
  for i := EventTypes.Count - 1 downto 0 do
  begin
    if LowerCase(EventTypes[i]) = Event then
      if (EventClassType[i] = nil) or (Obj.InheritsFrom(EventClassType[i])) then
      begin
        ID := i;
        Break;
      end;
  end;

  Result := False;
  if ID = -1 then
    exit;

  Func := EventTypes.Objects[ID];
  Result := boolean(EventTypesThread[ID]);

  MT.Data := Obj;
  MT.Code := Func;

  if (TypInfo.GetPropInfo(Obj, Event) = nil) then
    exit;

  Result := True;
  try
    TypInfo.SetMethodProp(Obj, Event, MT);
  except
    Result := False;
  end;
end;

{-------------- PHP MODULE ----------------------- }


procedure event_args(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
var
  param: pzval_array;
  arr: PHashTable;
  obj: TObject;
  tmp: ^ppzval;
  i: integer;
begin
  if zend_get_parameters_ex(ht, param) <> SUCCESS then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  obj := TObject(Z_LVAL(param[0]^));
  if obj <> nil then
    with GetEventController(obj, TSRMLS_DC) do
    begin
      if param[2]^^._type = IS_ARRAY then
        arr := param[2]^^.Value.ht
      else
        arr := nil;

      if arr <> nil then
      begin
        with GetEventController(obj, TSRMLS_DC).GetEvent(Z_STRVAL(param[1]^)) do
        begin
          SetLength(args, zend_hash_num_elements(arr));
          ClearAddArg;
          New(tmp);
          for i := 0 to High(args) do
          begin
            zend_hash_index_find(arr, i, tmp);
            AddArg(tmp^^);
          end;
          Dispose(tmp);
        end;

      end;

    end;

  dispose_pzval_array(param);
end;

procedure event_run(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
var
  param: pzval_array;
  arr: PHashTable;
  obj: TObject;
  args: array of TVarRec;
  tmp: ^ppzval;
  i: integer;
begin
  if zend_get_parameters_ex(ht, param) <> SUCCESS then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  obj := TObject(Z_LVAL(param[0]^));
  if obj <> nil then
    with GetEventController(obj, TSRMLS_DC) do
    begin
      if param[2]^^._type = IS_ARRAY then
        arr := param[2]^^.Value.ht
      else
        arr := nil;

      if arr <> nil then
      begin

        SetLength(args, zend_hash_num_elements(arr));
        New(tmp);
        for i := 0 to High(args) do
        begin
          zend_hash_index_find(arr, i, tmp);
          args[i] := Z_VARREC(tmp^^);
        end;
        Dispose(tmp);

      end;

      EventRun(obj, Z_STRVAL(param[1]^), args);
    end;

  dispose_pzval_array(param);
end;

procedure event_add(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
var
  param: pzval_array;
  obj: TObject;
begin
  if zend_get_parameters_ex(ht, param) <> SUCCESS then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  obj := TObject(Z_LVAL(param[0]^));

  if obj <> nil then
    with GetEventController(obj, TSRMLS_DC) do
    begin
      ZVAL_FALSE(return_value);

      if (EventSet(obj, Z_STRVAL(param[1]^))) then
      begin
        AddEvent(Z_STRVAL(param[1]^), param[2]^);
        ZVAL_TRUE(return_value);
      end;

    end;

  dispose_pzval_array(param);
end;

procedure event_set(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
var
  param: pzval_array;
  obj: TObject;
begin
  if zend_get_parameters_ex(ht, param) <> SUCCESS then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  obj := TObject(Z_LVAL(param[0]^));
  if obj <> nil then

    with GetEventController(obj, TSRMLS_DC) do
    begin
      ZVAL_FALSE(return_value);

      if param[2]^^._type = IS_NULL then
      begin
        if EventExists(obj, Z_STRVAL(param[1]^)) then
        begin
          ClearEvent(Z_STRVAL(param[1]^));
          ZVAL_TRUE(return_value);
        end;
      end
      else
      begin

        if EventSet(obj, Z_STRVAL(param[1]^)) then
        begin
          SetEvent(Z_STRVAL(param[1]^), param[2]^);
          ZVAL_TRUE(return_value);
        end;
      end;
    end;

  dispose_pzval_array(param);
end;

procedure event_get(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
var
  param: pzval_array;
  obj: TObject;
  r: pzval;
begin
  if zend_get_parameters_ex(ht, param) <> SUCCESS then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  obj := TObject(Z_LVAL(param[0]^));
  if obj <> nil then

    with GetEventController(obj, TSRMLS_DC) do
    begin
      ZVAL_FALSE(return_value);

      r := GetFirstEvent(Z_STRVAL(param[1]^));
      if r = nil then
        ZVAL_NULL(return_value)
      else
        zval_copy(return_value, r);
    end;

  dispose_pzval_array(param);
end;



procedure InitializeEventSystem(PHPEngine: TPHPEngine);
var
  MT: TMethod;
begin
  InitializeCriticalSection(SafeList_CRITICAL);
  InitializeCriticalSection(StartRequest_CRITICAL);
  InitializeCriticalSection(CntThreads_CRITICAL);

  ObjectController := TList.Create;
  ObjectHandlers := TList.Create;
  PHPEngine.AddFunction('event_add', @event_add);
  PHPEngine.AddFunction('event_set', @event_set);
  PHPEngine.AddFunction('event_get', @event_get);
  PHPEngine.AddFunction('event_run', @event_run);
  PHPEngine.AddFunction('event_args', @event_args);

  EventAddNewType('OnClick', @THandlerFuncs.OnClick);
  EventAddNewType('OnDblClick', @THandlerFuncs.OnDblClick);

  EventAddNewType('OnKeyDown', @THandlerFuncs.OnKeyDown);
  EventAddNewType('OnKeyUp', @THandlerFuncs.OnKeyUp);
  EventAddNewType('OnKeyPress', @THandlerFuncs.OnKeyPress);

  EventAddNewType('OnMouseDown', @THandlerFuncs.OnMouseDown);
  EventAddNewType('OnMouseUp', @THandlerFuncs.OnMouseUp);
  EventAddNewType('OnMouseMove', @THandlerFuncs.OnMouseMove);
  EventAddNewType('OnMouseEnter', @THandlerFuncs.OnMouseEnter);
  EventAddNewType('OnMouseLeave', @THandlerFuncs.OnMouseLeave);
  EventAddNewType('OnMouseWheel', @THandlerFuncs.OnMouseWheel);
  EventAddNewType('OnMouseActivate', @THandlerFuncs.OnMouseActivate);


  EventAddNewType('OnExecute', @THandlerFuncs.OnExecute, TScriptThread, 1);
  EventAddNewType('OnCloseQuery', @THandlerFuncs.OnCloseQuery, TForm);
  EventAddNewType('OnClose', @THandlerFuncs.OnClose, TForm);
  EventAddNewType('OnResize', @THandlerFuncs.OnResize, TForm);
  EventAddNewType('OnCanResize', @THandlerFuncs.OnCanResize, TForm);
  EventAddNewType('OnShow', @THandlerFuncs.OnShow, TForm);
  EventAddNewType('OnHide', @THandlerFuncs.OnHide, TForm);
  EventAddNewType('OnPaint', @THandlerFuncs.OnPaint);
  EventAddNewType('OnActivate', @THandlerFuncs.onActivate, TForm);
  EventAddNewType('OnDeactivate', @THandlerFuncs.OnDeactivate, TForm);

  EventAddNewType('OnScroll', @THandlerFuncs.OnScroll);
  EventAddNewType('OnPopup', @THandlerFuncs.OnPopup);
  EventAddNewType('OnMoved', @THandlerFuncs.OnMoved);
  EventAddNewType('onChange', @THandlerFuncs.onChange);
  EventAddNewType('onSelect', @THandlerFuncs.onSelect);
  EventAddNewType('onChanging', @THandlerFuncs.onChanging);
  EventAddNewType('onFocus', @THandlerFuncs.onFocus);
  EventAddNewType('onBlur', @THandlerFuncs.onBlur);

  EventAddNewType('onEdited', @THandlerFuncs.onEdited, TListView);
  EventAddNewType('onEditing', @THandlerFuncs.onEditing, TListView);


  EventAddNewType('OnStartDock', @THandlerFuncs.onStartDock);
  EventAddNewType('OnEndDock', @THandlerFuncs.onEndDock);
  EventAddNewType('OnUnDock', @THandlerFuncs.onUnDock);
  EventAddNewType('OnDockDrop', @THandlerFuncs.onDockDrop);
  EventAddNewType('OnDockOver', @THandlerFuncs.onDockOver);
  EventAddNewType('OnDragDrop', @THandlerFuncs.onDragDrop);
  EventAddNewType('OnDragOver', @THandlerFuncs.onDragOver);
  EventAddNewType('OnDropFiles', @THandlerFuncs.onDropFiles);

  EventAddNewType('onDuringSizeMove', @THandlerFuncs.onDuringSizeMove, TSizeCtrl);
  EventAddNewType('onStartSizeMove', @THandlerFuncs.onStartSizeMove, TSizeCtrl);
  EventAddNewType('onEndSizeMove', @THandlerFuncs.onEndSizeMove, TSizeCtrl);
  EventAddNewType('onSetCursor', @THandlerFuncs.onSetCursor, TSizeCtrl);
  EventAddNewType('onMouseDown', @THandlerFuncs.onSizeMouseDown, TSizeCtrl);

   {$IFDEF VS_EDITOR}
  EventAddNewType('OnClose', @THandlerFuncs.onSynClose, TSynCompletionProposal);
  EventAddNewType('OnMouseCursor', @THandlerFuncs.onMouseCursor);


  EventAddNewType('OnChange', @THandlerFuncs.onVSInsChange, TNxCustomInspector);
  EventAddNewType('OnEdit', @THandlerFuncs.onVSInsEdit, TNxCustomInspector);
  EventAddNewType('OnToolbarClick', @THandlerFuncs.onVSInsToolBarClick,
    TNxCustomInspector);
  EventAddNewType('OnButtonClick', @THandlerFuncs.onButtonClick, TNxButtonItem);

  EventAddNewType('OnButtonClicked', @THandlerFuncs.onCatButtonClicked,
    TCategoryButtons);
   {$ENDIF}


   {$IFDEF ADD_CHROMIUM}
  EventAddNewType('OnBeforePopup', @THandlerFuncs.onChromiumBeforePopup, TChromium);
  EventAddNewType('OnBeforeBrowse', @THandlerFuncs.onChromiumBeforeBrowse, TChromium);
  EventAddNewType('OnBeforeMenu', @THandlerFuncs.OnChromiumBeforeMenu, TChromium);

  EventAddNewType('OnAuthCredentials', @THandlerFuncs.OnAuthCredentials, TChromium);
  EventAddNewType('OnGetDownloadHandler', @THandlerFuncs.OnGetDownloadHandler,
    TChromium);
  EventAddNewType('OnConsoleMessage', @THandlerFuncs.OnConsoleMessage, TChromium);

  EventAddNewType('OnLoadStart', @THandlerFuncs.OnLoadStart, TChromium);
  EventAddNewType('OnLoadEnd', @THandlerFuncs.OnLoadEnd, TChromium);
  EventAddNewType('OnLoadError', @THandlerFuncs.OnLoadError, TChromium);

  EventAddNewType('OnStatusMessage', @THandlerFuncs.OnStatusMessage, TChromium);

  EventAddNewType('OnAddressChange', @THandlerFuncs.OnAddressChange, TChromium);
  EventAddNewType('OnTitleChange', @THandlerFuncs.OnTitleChange, TChromium);
  EventAddNewType('OnTooltip', @THandlerFuncs.OnTooltip, TChromium);
  EventAddNewType('OnContentsSizeChange', @THandlerFuncs.OnContentsSizeChange,
    TChromium);

  EventAddNewType('OnChromiumLibLoad', @THandlerFuncs.OnChromiumLibLoad, TChromium);
   {$ENDIF}



  EventAddNewType('OnTimer', @THandlerFuncs.OnTimer);

  SafeCommand := TList.Create;
  SafeTimer := TTimer.Create(Application);
  SafeTimer.Interval := 15;

  MT.Code := @THandlerFuncs.SafeOnTimer;
  MT.Data := SafeTimer;
  SetMethodProp(SafeTimer, 'OnTimer', MT);

end;

procedure FinalizeEventSystem();
begin
  DeleteCriticalSection(SafeList_CRITICAL);
  DeleteCriticalSection(StartRequest_CRITICAL);
  DeleteCriticalSection(CntThreads_CRITICAL);
  ObjectController.Free;
  ObjectHandlers.Free;
end;

function GetEventController(Obj: TObject; TSRMLS_DC: Pointer): TPHPScriptEvents;
var
  ID: integer;
begin
  ID := ObjectController.IndexOf(Obj);
  if ID = -1 then
  begin
    if TSRMLS_DC = nil then
    begin
      Result := nil;
      exit;
    end;

    Result := TPHPScriptEvents.Create(Obj, TSRMLS_DC);
    ObjectController.Add(Obj);
    ObjectHandlers.Add(Result);
  end
  else
  begin
    Result := ObjectHandlers[ID];
  end;
end;

procedure FreeEventController(Obj: TObject);
var
  ID: integer;
  Result: TPHPScriptEvents;
begin
  ID := ObjectController.IndexOf(Obj);
  if ID <> -1 then
  begin
    Result := ObjectHandlers[ID];
    Result.Free;
    ObjectController.Delete(ID);
    ObjectHandlers.Delete(ID);
  end;
end;

{ TScriptEventHandler }

procedure TScriptEventHandler.AddCallback(Data: Pointer);
begin
  Data := GetCallback(Data);
  CallBack.Add(Data);
end;

procedure TScriptEventHandler.AddCallbackFirst(Data: Pointer);
begin
  Data := GetCallback(Data);
  if CallBack.Count > 0 then
    CallBack.Insert(0, Data)
  else
    CallBack.Add(Data);
end;

procedure TScriptEventHandler.Clear;
begin
  CallBack.Clear;
end;

constructor TScriptEventHandler.Create(This: Pointer);
begin
  Self.This := This;
  CallBack := TList.Create;
end;

destructor TScriptEventHandler.Destroy;
begin
  Clear;
  CallBack.Free;
  inherited;
end;


function TScriptEventHandler.GetCallback(Data: Pointer): Pointer;
begin
  Result := Data;
end;

procedure TScriptEventHandler.Run;
var
  i: integer;
begin
  for i := 0 to CallBack.Count - 1 do
  begin
    Execute(CallBack[i]);
  end;
end;


{ TPHPScriptEventHandler }

procedure TPHPScriptEventHandler.ClearAddArg;
var
  i: integer;
begin
  for i := 0 to Length(AddArgs) - 1 do
    zval_dtor_func(addArgs[i]);
end;

procedure TPHPScriptEventHandler.ClearArgs;
var
  I, Cnt: integer;
begin
  Cnt := Length(Args);
  for i := 0 to Cnt - 1 do
  begin
    if Args[i] <> nil then
      //ZVAL_EMPTY_STRING(Args[i]);
      zval_dtor_func(Args[i]);
  end;
  SetLength(Args, 0);
end;


constructor TPHPScriptEventHandler.Create;
begin
  inherited Create(This);
  Return := MAKE_STD_ZVAL;

  Self.TSRMLS_DC := TSRMLS_DC;
  SetLength(Args, 0);
end;


procedure TPHPScriptEventHandler.Execute;
var
  eg: pzend_executor_globals;
  cg: Pzend_compiler_globals;

  lastConstants, lastFunctions, lastClasses: PHashTable;
begin
  if IsThread then
  begin
    with TScriptThread(This) do
    begin
      try
        psv := TpsvPHP.Create(nil);
        psv.RunCode('echo 1; ' + '$GLOBALS["THREAD_SELF"] = ' +
          IntToStr(integer(This)) + ';');

        eg := GetExecutorGlobals;
        cg := GetCompilerGlobals;

        eg.current_module := executor_globals.current_module;

        //if FThread.Main.FImportFunctions then
        begin
          lastFunctions := eg.function_table;
          eg.function_table := executor_globals.function_table;

          {zend_hash_clean( eg.function_table );
          zend_hash_copy( eg.function_table, executor_globals.function_table,
                                             @function_add_ref, nil, SizeOf(zend_function));}
        end;

        if FThread.Main.FImportClasses then
        begin
          lastClasses := eg.class_table;
          eg.class_table := executor_globals.class_table;

          {zend_hash_clean( eg.class_table );
          zend_hash_copy( eg.class_table, executor_globals.class_table, @my_class_add_ref, nil,
                        SizeOf(Tzend_class_entry) ); }
        end;

        if FThread.Main.FImportConstants then
        begin
          lastConstants := eg.zend_constants;
          eg.zend_constants := executor_globals.zend_constants;
          {zend_hash_clean( eg.zend_constants );
          zend_hash_copy(eg.zend_constants, executor_globals.zend_constants,
                         @copy_zend_constant, @tmp, sizeof(TZendConstant)); }
        end;

        psv.thread := This;
        psv.RunCode('if (class_exists("TThread")) TThread::__init();');

        try
          call_user_function(
            cg.function_table,
            nil,
            Data,
            pzval(Return),
            Length(Args),
            Args,
            psv.TSRMLS_D
            );
        except

        end;

        //zend_hash_clean( eg.class_table )
        if FImportClasses then
          //zend_hash_clean( eg.class_table );
          eg.class_table := lastClasses;

        if FImportConstants then
          eg.zend_constants := lastConstants;
          
        eg.function_table := lastFunctions;
        try
          psv.ShutdownRequest;
          psv.Free;
          //Sleep(250);
        except

        end;

      finally
        try
          ts_free_thread(); //for zend_timeout to kill timer
        except

        end;
      end;

    end;

  end
  else
  begin
    try
      call_user_function(
        GetExecutorGlobals.function_table,
        nil,
        Data,
        pzval(Return),
        Length(Args),
        Args,
        TSRMLS_DC
        );
    except
      //ShowMessage(Z_STRVAL(Data));
    end;
  end;
end;

function TPHPScriptEventHandler.GetCallback(Data: Pointer): Pointer;
var
  M, Return: pzval;
  tmp: pzval;
begin
  M := Data;
  Return := MAKE_STD_ZVAL;

  case M._type of
    IS_ARRAY:
    begin
      tmp := nil;
      _array_init(Return, nil, 0);
      Return._type := IS_ARRAY;
      zend_hash_init(Return.Value.ht, 0, nil, @_zval_dtor_func, False);
      zend_hash_copy(Return.Value.ht, M.Value.ht, @zend_addref_p,
        tmp, sizeof(zval));
    end;
    IS_STRING:
    begin
      ZVAL_STRINGL(Return, M.Value.str.val, M.Value.str.len, True);
    end;
    IS_OBJECT:
    begin
      Return._type := IS_OBJECT;
      Return.Value.obj := M.Value.obj;
      zend_objects_store_add_ref(M, TSRMLS_DC);
    end;
  end;
  Result := Return;
end;

function TPHPScriptEventHandler.ParamBool(Index: integer): boolean;
begin
  if Index < Length(args) then
    Result := Z_BVAL(args[index])
  else
    Result := False;
end;

function TPHPScriptEventHandler.ParamChar(Index: integer): AnsiChar;
var
  S: ansistring;
begin
  S := Z_STRVAL(args[index]);
  if Length(S) > 0 then
    Result := S[1]
  else
    Result := #0;
end;

function TPHPScriptEventHandler.ParamDouble(Index: integer): double;
begin
  Result := Z_DVAL(args[index]);
end;

function TPHPScriptEventHandler.ParamInt(Index: integer): integer;
begin
  Result := Z_LVAL(args[index]);
end;

function TPHPScriptEventHandler.ParamPtr(Index: integer): Pointer;
begin
  Result := Pointer(Z_LVAL(args[index]));
end;

function TPHPScriptEventHandler.ParamString(Index: integer): ansistring;
begin
  Result := Z_STRVAL(args[index]);
end;



procedure TPHPScriptEventHandler.CopyVal(dest: integer; src: pzval);
begin
  if Self.Args[dest] = nil then
  begin
    Self.Args[dest] := ALLOC_ZVAL;
    INIT_PZVAL(Self.Args[dest]);
  end;

  zval_copy(Self.Args[dest], src);
end;

procedure TPHPScriptEventHandler.Run(Args: array of const);
var
  Cnt, I: integer;
  S: ansistring;
begin
  Cnt := Length(Args);
  SetLength(Self.Args, Cnt + 1 + Length(AddArgs));

  if Self.Args[0] = nil then
  begin
    Self.Args[0] := ALLOC_ZVAL;
    INIT_PZVAL(Self.Args[0]);
  end;
  ZVAL_LONG(Self.Args[0], integer(This));


  for i := 1 to Cnt do
  begin
    if Self.Args[i] = nil then
    begin
      Self.Args[i] := ALLOC_ZVAL;
      INIT_PZVAL(Self.Args[i]);
    end;

    case Args[i - 1].VType of
      vtInteger: ZVAL_LONG(Self.Args[i], Args[i - 1].VInteger);
      vtPointer, vtObject: ZVAL_LONG(Self.Args[i], integer(Args[i - 1].VPointer));
      vtInt64: ZVAL_DOUBLE(Self.Args[i], Args[i - 1].VInt64^);
      vtExtended: ZVAL_DOUBLE(Self.Args[i], Args[i - 1].VExtended^);
      vtBoolean: ZVAL_BOOL(Self.Args[i], Args[i - 1].VBoolean);
      vtString: ZVAL_STRINGL(Self.Args[i], @(Args[i - 1].VString^[0]),
          Length(Args[i - 1].VString^), True);
      vtAnsiString:
      begin
        if Args[i - 1].VAnsiString = nil then
          ZVAL_EMPTY_STRING(Self.Args[i])
        else
          ZVAL_STRINGL(Self.Args[i],
            PAnsiChar(Args[i - 1].VAnsiString),
            Length(ansistring(Args[i - 1].VAnsiString)),
            True);
      end;
      vtWideString:
      begin
        if Args[i - 1].VWideString = nil then
          ZVAL_EMPTY_STRING(Self.Args[i])
        else
          ZVAL_STRINGLW(Self.Args[i],
            PWideChar(Args[i - 1].VWideString),
            Length(WideString(Args[i - 1].VWideString)),
            True);
      end;
      vtCurrency: ZVAL_DOUBLE(Self.Args[i], double(Args[i - 1].VCurrency^));
      vtChar:
      begin
        S := Args[i - 1].VChar;
        ZVAL_STRINGL(Self.Args[i], PAnsiChar(S), 1, True);
      end
      else
        ZVAL_NULL(Self.Args[i]);
    end;
  end;

  for i := Cnt + 1 to Cnt + Length(AddArgs) do
  begin
    Self.CopyVal(i, AddArgs[i - Cnt - 1]);
  end;

  ZVAL_BOOL(Return, True);
  for i := 0 to CallBack.Count - 1 do
  begin
    Execute(CallBack[i]);
     {if (PZval(Return)^._type <> IS_NULL) and not Z_BVAL(PZval(Return)) then
       break; }
  end;

end;

procedure TPHPScriptEventHandler.AddArg(arg: pzval);
var
  val: pzval;
begin
  val := ALLOC_ZVAL;
  INIT_PZVAL(val);
  zval_copy(val, arg);

  SetLength(AddArgs, Length(AddArgs) + 1);
  AddArgs[High(AddArgs)] := val;
end;

procedure TPHPScriptEventHandler.Clear;
var
  i: integer;
  M: pzval;
begin

  for i := 0 to High(Args) do
  begin
    if Args[i] = nil then
      continue;
    //ZVAL_EMPTY_STRING(Args[i]);
    zval_dtor_func(Args[i]);
    Args[i] := nil;
  end;

  for i := 0 to CallBack.Count - 1 do
  begin
    M := CallBack[i];
    case M._type of
      IS_ARRAY:
      begin
        zend_hash_clean(M.Value.ht);
        zend_hash_destroy(M.Value.ht);
      end;
      IS_STRING:
      begin
        ZVAL_EMPTY_STRING(M);
      end;
      IS_OBJECT:
      begin
        zend_objects_store_del_ref(M, TSRMLS_DC);
      end;
    end;
    zval_dtor_func(M);
  end;

  SetLength(Args, 0);

  inherited;
end;

{ TScriptEvents }

procedure TPHPScriptEvents.AddEvent;
begin
  with GetEvent(Name) do
  begin
    if First then
      AddCallbackFirst(call)
    else
      AddCallback(Call);

    IsThread := aIsThread;
  end;
end;

procedure TPHPScriptEvents.ClearEvent(const Name: ansistring);
begin
  with GetEvent(Name) do
    Clear;
end;

constructor TPHPScriptEvents.Create(This, TSRMLS_DC: Pointer);
begin
  Self.This := This;
  Self.TSRMLS_DC := TSRMLS_DC;
  Events := TStringList.Create;
end;

destructor TPHPScriptEvents.Destroy;
var
  i: integer;
begin
  for i := 0 to Events.Count - 1 do
    TPHPScriptEventHandler(Events.Objects[i]).Free;

  Events.Clear;
  Events.Free;
  inherited;
end;

function TPHPScriptEvents.GetEvent(const Name: ansistring): TPHPScriptEventHandler;
var
  ID: integer;
begin
  ID := Events.IndexOf(LowerCase(Name));
  if ID = -1 then
  begin
    Result := TPHPScriptEventHandler.Create(This, TSRMLS_DC);
    Events.AddObject(LowerCase(Name), Result);
  end
  else
    Result := TPHPScriptEventHandler(Events.Objects[ID]);
end;

function TPHPScriptEvents.RunEvent(const Name: ansistring;
  Args: array of const): TPHPScriptEventHandler;
var
  ID: integer;
begin
  ID := Events.IndexOf(LowerCase(Name));
  Result := nil;
  if ID <> -1 then
  begin
    Result := TPHPScriptEventHandler(Events.Objects[ID]);
    Result.Run(Args);
  end;
end;

procedure TPHPScriptEvents.SetEvent;
begin
  with GetEvent(Name) do
  begin

    Clear;
    AddCallback(Call);

    IsThread := LowerCase(Name) = 'onexecute';
  end;
end;


function TPHPScriptEvents.GetFirstEvent(const Name: ansistring): pzval;
begin
  with GetEvent(Name) do
  begin
    if CallBack.Count > 1 then
      Result := CallBack[0]
    else
      Result := nil;
  end;
end;

{ THandlerFuncs }

procedure THandlerFuncs.onClick(Sender: TObject);
begin
  EventRun(Sender, 'OnClick');
end;

procedure THandlerFuncs.onActivate(Sender: TObject);
begin
  EventRun(Sender, 'OnActivate');
end;

procedure THandlerFuncs.onDeactivate(Sender: TObject);
begin
  EventRun(Sender, 'OnDeactivate');
end;

procedure THandlerFuncs.onCloseQuery(Sender: TObject; var CanClose: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnCloseQuery', [CanClose], False);
  if H <> nil then
  begin
    CanClose := H.ParamBool(1);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onClose(Sender: TObject);
begin
  EventRun(Sender, 'OnClose');
end;

procedure THandlerFuncs.onResize(Sender: TObject);
begin
  EventRun(Sender, 'OnResize');
end;

procedure THandlerFuncs.onBlur(Sender: TObject);
begin
  EventRun(Sender, 'OnBlur');
end;

procedure THandlerFuncs.onCanResize(Sender: TObject;
  var NewWidth, NewHeight: integer; var Resize: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnCanResize', [NewWidth, NewHeight, Resize], False);
  if H <> nil then
  begin
    NewWidth := H.ParamInt(1);
    NewHeight := H.ParamInt(2);
    Resize := H.ParamBool(3);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onChange(Sender: TObject);
begin
  EventRun(Sender, 'onChange');
end;

procedure THandlerFuncs.onChanging(Sender: TObject; var AllowChange: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'onChanging', [AllowChange], False);
  if H <> nil then
  begin
    AllowChange := H.ParamBool(1);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: integer);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnScroll', [integer(ScrollCode), ScrollPos], False);
  if H <> nil then
  begin
    ScrollPos := H.ParamInt(2);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onSelect(Sender: TObject);
begin
  EventRun(Sender, 'onSelect');
end;

procedure THandlerFuncs.onSetCursor(Sender: TObject; Target: TControl;
  TargetPt: TPoint; var handled: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'onSetCursor', [Target, TargetPt.X, TargetPt.Y,
    handled], False);
  if H <> nil then
  begin
    handled := H.ParamBool(4);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onShow(Sender: TObject);
begin
  EventRun(Sender, 'OnShow');
end;

procedure THandlerFuncs.onSizeMouseDown(Sender: TObject; Target: TControl;
  TargetPt: TPoint; var handled: boolean);
begin
  EventRun(Sender, 'onMouseDown', [Target, TargetPt.X, TargetPt.Y]);
end;

procedure THandlerFuncs.onHide(Sender: TObject);
begin
  EventRun(Sender, 'OnHide');
end;

procedure THandlerFuncs.onDblClick(Sender: TObject);
begin
  EventRun(Sender, 'OnDblClick');
end;

procedure THandlerFuncs.onKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnKeyDown', [Key, Shift2Str(Shift)], False);
  if H <> nil then
  begin
    Key := H.ParamInt(1);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnKeyUp', [Key, Shift2Str(Shift)], False);
  if H <> nil then
  begin
    Key := H.ParamInt(1);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onKeyPress(Sender: TObject; var Key: char);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnKeyPress', [Key], False);
  if H <> nil then
  begin
    Key := H.ParamChar(1);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onExecute(Sender: TObject);
begin
  EventRun(Sender, 'OnExecute');
end;

procedure THandlerFuncs.onFocus(Sender: TObject);
begin
  EventRun(Sender, 'OnFocus');
end;

procedure THandlerFuncs.onTimer(Sender: TObject);
begin
  EventRun(Sender, 'OnTimer');
end;

procedure THandlerFuncs.onMouseActivate(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y, HitTest: integer; var MouseActivate: TMouseActivate);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnMouseActivate', [integer(Button),
    Shift2Str(Shift), X, Y, HitTest, integer(MouseActivate)], False);
  if H <> nil then
  begin
    MouseActivate := TMouseActivate(H.ParamInt(6));
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  EventRun(Sender, 'OnMouseDown', [integer(Button), Shift2Str(Shift), X, Y]);
end;

procedure THandlerFuncs.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  EventRun(Sender, 'OnMouseUp', [integer(Button), Shift2Str(Shift), X, Y]);
end;

procedure THandlerFuncs.onMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  EventRun(Sender, 'OnMouseMove', [Shift2Str(Shift), X, Y]);
end;

procedure THandlerFuncs.onMouseEnter(Sender: TObject);
begin
  EventRun(Sender, 'OnMouseEnter');
end;

procedure THandlerFuncs.onMouseLeave(Sender: TObject);
begin
  EventRun(Sender, 'OnMouseLeave');
end;

procedure THandlerFuncs.onMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnMouseWheel', [Shift2Str(Shift), WheelDelta,
    MousePos.X, MousePos.Y, Handled], False);

  if H <> nil then
  begin
    Handled := H.ParamBool(5);
    H.ClearArgs;
  end;
end;


procedure THandlerFuncs.onMoved(Sender: TObject);
begin
  EventRun(Sender, 'OnMoved');
end;

procedure THandlerFuncs.onPaint(Sender: TObject);
begin
  EventRun(Sender, 'OnPaint');
end;

procedure THandlerFuncs.onPopup(Sender: TObject);
begin
  EventRun(Sender, 'OnPopup');
end;

procedure THandlerFuncs.onStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnStartDock', [DragObject], False);

  if H <> nil then
  begin
    Pointer(DragObject) := H.ParamPtr(1);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onStartSizeMove(Sender: TObject; State: TSCState);
begin
  EventRun(Sender, 'onStartSizeMove', [integer(State)]);
end;

{$IFDEF VS_EDITOR}
procedure THandlerFuncs.onMouseCursor(Sender: TObject;
  const aLineCharPos: TBufferCoord; var aCursor: TCursor);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnMouseCursor', [aLineCharPos.char, aLineCharPos.Line,
    aCursor], False);
  if H <> nil then
  begin
    aCursor := H.ParamInt(3);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onSynClose(Sender: TObject);
begin
  EventRun(Sender, 'onClose');
end;


procedure THandlerFuncs.onVSInsChange(Sender: TObject; Item: TNxPropertyItem;
  Value: WideString);
begin
  EventRun(Sender, 'OnChange', [Item, Value]);
end;

procedure THandlerFuncs.onVSInsEdit(Sender: TObject; Item: TNxPropertyItem;
  Value: WideString; var Accept: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnEdit', [Item, Value, Accept], False);
  if H <> nil then
  begin
    Accept := H.ParamBool(3);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onVSInsToolBarClick(Sender: TObject;
  Item: TNxPropertyItem; ButtonIndex: integer);
begin
  EventRun(Sender, 'OnToolbarClick', [Item, ButtonIndex]);
end;

procedure THandlerFuncs.onButtonClick(Sender: TObject);
begin
  EventRun(Sender, 'onButtonClick');
end;

procedure THandlerFuncs.onCatButtonClicked(Sender: TObject; const Button: TButtonItem);
begin
  EventRun(Sender, 'onButtonClicked', [Button]);
end;

{$ENDIF}

procedure THandlerFuncs.onEdited(Sender: TObject; Item: TListItem; var S: string);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnEdited', [Item, S], False);

  if H <> nil then
  begin
    S := H.ParamString(2);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: boolean);
begin

end;

procedure THandlerFuncs.onEndDock(Sender, Target: TObject; X, Y: integer);
begin
  EventRun(Sender, 'OnEndDock', [Target, X, Y]);
end;


procedure THandlerFuncs.onEndSizeMove(Sender: TObject; State: TSCState);
begin
  EventRun(Sender, 'onEndSizeMove', [integer(State)]);
end;

procedure THandlerFuncs.onUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnUnDock', [Client, NewTarget, Allow], False);
  if H <> nil then
  begin
    Allow := H.ParamBool(3);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onDockDrop(Sender: TObject; Source: TDragDockObject;
  X, Y: integer);
begin
  EventRun(Sender, 'OnDockDrop', [Source, X, Y]);
end;

procedure THandlerFuncs.onDockOver(Sender: TObject; Source: TDragDockObject;
  X, Y: integer; State: TDragState; var Accept: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnDockOver', [Source, X, Y, integer(State), Accept], False);
  if H <> nil then
  begin
    Accept := H.ParamBool(5);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onDragDrop(Sender, Source: TObject; X, Y: integer);
begin
  EventRun(Sender, 'OnDragDrop', [Source, X, Y]);
end;

procedure THandlerFuncs.onDragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: boolean);
var
  H: TPHPScriptEventHandler;
begin
  H := EventRun(Sender, 'OnDragOver', [Source, X, Y, integer(State), Accept], False);
  if H <> nil then
  begin
    Accept := H.ParamBool(5);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onDropFiles(Sender: TObject; Files: TStrings;
  X: integer; Y: integer);
begin
  EventRun(Self, 'OnDropFiles',
    [StringReplace(TrimRight(Files.Text), #13#10, #10, [rfReplaceAll]), X, Y]);
end;

procedure THandlerFuncs.onDuringSizeMove(Sender: TObject; dx, dy: integer;
  State: TSCState);
begin
  EventRun(Sender, 'OnEndDock', [dx, dy, integer(State)]);
end;


{$IFDEF ADD_CHROMIUM}
procedure THandlerFuncs.OnChromiumBeforePopup(Sender: TObject;
  const parentBrowser: ICefBrowser; var popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var url: ustring;
  var client: ICefBase; out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;
  H := EventRun(Sender, 'OnBeforePopup', [url, Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(2);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.OnChromiumBeforeMenu(Sender: TObject;
  const browser: ICefBrowser; const menuInfo: PCefHandlerMenuInfo;
  out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;

  H := EventRun(Sender, 'OnBeforeMenu', [menuInfo.x, menuInfo.y,
    // CefStringClearAndGet вот в ней херня.!!!
    CefString(@menuInfo.linkUrl), CefString(@menuInfo.imageUrl),
    CefString(@menuInfo.pageUrl), CefString(@menuInfo.frameUrl),
    CefString(@menuInfo.selectionText), Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(8);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.onChromiumBeforeBrowse(Sender: TCustomChromium;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; navType: TCefHandlerNavtype;
  isRedirect: boolean; out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;
  H := EventRun(Sender, 'OnBeforeBrowse', [request.Url, request.Method,
    integer(navType), isRedirect, Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(5);
    H.ClearArgs;
  end;
end;



procedure THandlerFuncs.OnAuthCredentials(Sender: TObject;
  const browser: ICefBrowser; isProxy: boolean; Port: integer;
  const host, realm, scheme: ustring; var username, password: ustring;
  out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;
  H := EventRun(Sender, 'OnAuthCredentials', [isProxy, Port, host,
    realm, scheme, username, password, Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(8);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.OnGetDownloadHandler(Sender: TObject;
  const browser: ICefBrowser; const mimeType, fileName: ustring;
  contentLength: int64; var handler: ICefDownloadHandler;
  out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;

  H := EventRun(Sender, 'OnGetDownloadHandler',
    [browser.MainFrame.Url, mimeType, fileName, contentLength, Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(5);
    H.ClearArgs;
  end;
end;


procedure THandlerFuncs.OnConsoleMessage(Sender: TObject;
  const browser: ICefBrowser; message, Source: ustring;
  line: integer; out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;

  H := EventRun(Sender, 'OnConsoleMessage', [message, Source, line, Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(4);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.OnLoadStart(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame);
begin
  EventRun(Sender, 'OnLoadStart');
end;

procedure THandlerFuncs.OnLoadEnd(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: integer; out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;

  H := EventRun(Sender, 'OnLoadEnd', [httpStatusCode, Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(2);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.OnLoadError(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
  const failedUrl: ustring; var errorText: ustring;
  out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;

  H := EventRun(Sender, 'OnLoadError', [integer(errorCode), failedUrl,
    errorText, Result], False);
  if H <> nil then
  begin
    errorText := H.ParamString(3);
    Result := not H.ParamBool(4);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.OnStatusMessage(Sender: TObject;
  const browser: ICefBrowser; const Value: ustring; StatusType: TCefHandlerStatusType;
  out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;

  H := EventRun(Sender, 'OnStatusMessage', [Value, integer(StatusType), Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(3);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.OnAddressChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring);
begin
  EventRun(Sender, 'OnAddressChange', [url]);
end;

procedure THandlerFuncs.OnTitleChange(Sender: TObject; const browser: ICefBrowser;
  const title: ustring; out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;

  H := EventRun(Sender, 'OnTitleChange', [title, Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(2);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.OnTooltip(Sender: TObject; const browser: ICefBrowser;
  var Text: ustring; out Result: boolean);
var
  H: TPHPScriptEventHandler;
begin
  Result := True;

  H := EventRun(Sender, 'OnTooltip', [Text, Result], False);
  if H <> nil then
  begin
    Result := not H.ParamBool(2);
    H.ClearArgs;
  end;
end;

procedure THandlerFuncs.OnContentsSizeChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; Width, Height: integer);
begin
  EventRun(Sender, 'OnContentsSizeChange', [Width, Height]);
end;

procedure THandlerFuncs.OnChromiumLibLoad(Sender: TObject);
begin
  EventRun(Sender, 'OnChromiumLibLoad');
end;

{$ENDIF}

procedure THandlerFuncs.SafeOnTimer(Sender: TObject);
var
  i: integer;
begin
  EnterCriticalSection(SafeList_CRITICAL);
  for i := 0 to SafeCommand.Count - 1 do
  begin
    TScriptSafeCommand(SafeCommand[i]).Execute;
  end;

  for i := 0 to SafeCommand.Count - 1 do
  begin
    TScriptSafeCommand(SafeCommand[i]).Free;
  end;

  SafeCommand.Clear;
  LeaveCriticalSection(SafeList_CRITICAL);
end;

{ TScriptSafeCommand }

constructor TScriptSafeCommand.Create;
begin
  Self.Data := Data;
  EnterCriticalSection(SafeList_CRITICAL);
  SafeCommand.Add(Self);
  LeaveCriticalSection(SafeList_CRITICAL);
end;

{ TScriptSafeCommand_Destroy }

procedure TScriptSafeCommand_Destroy.Execute;
begin
  inherited;
  FreeEventController(TObject(Data));
  TObject(Data).Free;
end;

{ TScriptSafeCommand_Message }

destructor TScriptSafeCommand_Message.Destroy;
begin
  Dispose(PAnsiString(Data));
  inherited;
end;

procedure TScriptSafeCommand_Message.Execute;
begin
  ShowMessage(PAnsiString(Data)^);
end;

{ TScriptThread }

constructor TScriptThread.Create;
begin
  FThread := TScriptThreadHelper.Create(Self);
  compiler_globals := GetCompilerGlobals;
  executor_globals := GetExecutorGlobals;

  FImportFunctions := True;
  FImportConstants := True;
  FImportClasses := True;
  FImportGlobals := False;

  addDATA := TStringHashTable.Create(30);
end;

destructor TScriptThread.Destroy;
begin
  //  FThread.Suspend;
  FThread.FreeOnTerminate := True;
  addData.Free;
  // FThread.Terminate;
  inherited;
end;

procedure TScriptThread.Execute;
begin
  inherited;
  if Assigned(FOnExecute) then
    FOnExecute(Self);


  EnterCriticalSection(CntThreads_CRITICAL);
  Dec(CntThreads);
  LeaveCriticalSection(CntThreads_CRITICAL);
end;

procedure TScriptThread.Resume;
begin
  FThread.Resume;
end;

class procedure TScriptThread.SetBeforeCode(const Code: ansistring);
begin
  ThreadBeforeCode := Code;
end;

procedure TScriptThread.SetImportClasses(const Value: boolean);
begin
  FImportClasses := Value;
end;

procedure TScriptThread.SetImportConstants(const Value: boolean);
begin
  FImportConstants := Value;
end;

procedure TScriptThread.SetImportFunctions(const Value: boolean);
begin
  FImportFunctions := Value;
end;

procedure TScriptThread.SetImportGlobals(const Value: boolean);
begin
  FImportGlobals := Value;
end;

procedure TScriptThread.SetOnExecute(const Value: TNotifyEvent);
begin
  FOnExecute := Value;
end;

procedure TScriptThread.Suspend;
begin
  Self.FThread.Suspend;
end;

procedure TScriptThread.Sync(Func, MyData: ansistring);
begin
  FThread.Data := Func;
  FThread.MyData := MyData;
  try
    //Sleep(1);
    FThread.Synchronize(FThread.CallSyncFunc);
  except

  end;
end;

{ TScriptThreadHelper }

procedure TScriptThreadHelper.CallSyncFunc;
var
  Args: pzval_array_ex;
  Return, Func: pzval;
begin
  Return := MAKE_STD_ZVAL;
  Func := MAKE_STD_ZVAL;

  ZVAL_STRINGL(Func, PAnsiChar(Data), Length(Data), True);

  SetLength(Args, 2);
  args[0] := MAKE_STD_ZVAL;
  ZVAL_LONG(args[0], integer(Self.Main));

  Args[1] := MAKE_STD_ZVAL;
  ZVAL_STRINGL(args[1], PAnsiChar(MyData), Length(MyData), True);

  call_user_function(
    GetExecutorGlobals.function_table,
    nil,
    Func,
    Return,
    2,
    args,
    getPsvPHP().TSRMLS_D
    );

  zval_dtor_func(args[1]);
  zval_dtor_func(args[0]);
  zval_dtor_func(Return);
  zval_dtor_func(Func);
end;

constructor TScriptThreadHelper.Create(Main: TScriptThread);
begin
  inherited Create(True);
  Self.Main := Main;
end;

procedure TScriptThreadHelper.Execute;
begin
  inherited;
  Main.Execute;
end;

{ TScriptSafeCommand_ThreadDestroy }

procedure TScriptSafeCommand_ThreadDestroy.Execute;
begin
  FreeEventController(TObject(Data));
  //TScriptThread( Data ).Free;
end;

end.
