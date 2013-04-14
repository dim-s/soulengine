unit guiChromium;

{$ifdef fpc}
{$mode delphi}{$H+}
{$endif}

interface

uses
  Classes, SysUtils, phpUtils, Forms, regGUI, Controls,
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  php4delphi,
  uPhpEvents,
  uPHPMod,
  Graphics, Dialogs, dwsHashtables,
  ceflib, cefvcl;

procedure InitializeGuiChromium(PHPEngine: TPHPEngine);

procedure chromium_allowedcall(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;

procedure chromium_settings(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;

procedure chromium_load(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;


procedure chromium_exec(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;

procedure chromium_prop(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;


type
  TExtension = class(TCefv8HandlerOwn)
  private

  protected
    function Execute(const Name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var Exception: ustring): boolean; override;
  end;

implementation

type
  TArrayString = array of string;
  TArrayVariant = array of variant;

var
  AllowedCall: TStringHashTable;

function ZendToVariant(const Value: pppzval): variant;
var
  S: string;
begin
  case Value^^^._type of
    1: Result := Value^^^.Value.lval;
    2: Result := Value^^^.Value.dval;
    6:
    begin
      S := Value^^^.Value.str.val;
      Result := S;
    end;
  end;
end;

procedure HashToArray(HT: PHashTable; var AR: TArrayVariant); overload;
var
  Len, I: integer;
  tmp: pppzval;
begin
  len := zend_hash_num_elements(HT);
  SetLength(AR, len);
  for i := 0 to len - 1 do
  begin
    new(tmp);
    zend_hash_index_find(ht, i, tmp);
    AR[i] := ZendToVariant(tmp);
    freemem(tmp);
  end;
end;

procedure HashToArray(ZV: pzval; var AR: TArrayVariant); overload;
begin
 if ZV^._type = IS_ARRAY then
    HashToArray(zv^.value.ht, AR)
  else
    SetLength(AR, 0);
end;

procedure chromium_prop;
  var p: pzval_array;
    isGet: boolean;
begin
  if ht < 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  isGet := isNull(p[2]);
  with TChromium(Z_LVAL(p[0]^)) do
  begin
    case Z_LVAL(p[1]^) of
      1: if isGet then
          ZVAL_DOUBLE(return_value, Browser.ZoomLevel)
        else
          Browser.ZoomLevel := Z_DVAL(p[2]^);

      2: ZVAL_STRING(return_value, Browser.MainFrame.Url);
      3: ZVAL_STRING(return_value, Browser.MainFrame.Source);
      4: ZVAL_STRING(return_value, Browser.MainFrame.Text);
    end;
  end;

  dispose_pzval_array(p);
end;

procedure chromium_exec;
  var p: pzval_array;
    id, i: Integer;
    tmp: ^ppzval;
    tmps: array of ^ppzval;

    Req: ICefRequest;
    Header: ICefStringMap;

    ARR: TArrayVariant;
begin
  if ht < 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  with TChromium(Z_LVAL(p[0]^)) do
  begin
    HashToArray(p[2]^, ARR);

    case Z_LVAL(p[1]^) of
      1: Browser.Reload;
      2: Browser.GoBack;
      3: ZVAL_BOOL(return_value, Browser.CanGoBack);
      4: Browser.GoForward;
      5: ZVAL_BOOL(return_value, Browser.CanGoForward);
      6: Browser.ShowDevTools;
      7: Browser.CloseDevTools;
      8: Browser.HidePopup;
      9:
      begin
        if Length(ARR) > 0 then
          Browser.SetFocus(ARR[0])
        else
          Browser.SetFocus(True);
      end;
      10: Browser.ReloadIgnoreCache;
      11: Browser.StopLoad;
      12: if Length(Arr) > 0 then
          Browser.SendFocusEvent(arr[0]);
      13: if Length(Arr) > 4 then
          Browser.SendKeyEvent(TCefKeyType(arr[0]), arr[1], arr[2], arr[3], arr[4]);
      14: if Length(Arr) > 4 then
          Browser.SendMouseClickEvent(arr[0], arr[1],
            TCefMouseButtonType(arr[2]), arr[3], arr[4]);
      15: if Length(arr) > 0 then
          Load(arr[0]);
      16: if Length(arr) > 1 then
          ScrollBy(arr[0], arr[1]);
      17: Browser.ClearHistory;
      18: ;
      19: ;
      20: ;
      21: ;
      22: Browser.MainFrame.Undo;
      23: Browser.MainFrame.Redo;
      24: Browser.MainFrame.Cut;
      25: Browser.MainFrame.Copy;
      26: Browser.MainFrame.Paste;
      27: Browser.MainFrame.Del;
      28: Browser.MainFrame.SelectAll;
      29: Browser.MainFrame.Print;
      30: Browser.MainFrame.ViewSource;
      31: if Length(arr) > 0 then
          Browser.MainFrame.LoadUrl(arr[0]);
      32: if Length(arr) > 1 then
          Browser.MainFrame.LoadString(arr[0], arr[1]);
      33: if Length(arr) > 1 then
          Browser.MainFrame.LoadFile(arr[0], arr[1]);
      34: if Length(arr) > 2 then
          Browser.MainFrame.ExecuteJavaScript(arr[0], arr[1], arr[2]);
      35:
      begin
        Req := TCefRequestRef.Create(nil);
        Header := TCefStringMapOwn.Create;

        Req.Url := arr[0];
        Req.Method := arr[1];
        //Req.SetHeaderMap();
        //Browser.MainFrame.LoadRequest();
      end;
      36:
      begin
        if length(arr) > 0 then
          UserStyleSheetLocation := arr[0]
        else
          ZVAL_STRING(return_value, UserStyleSheetLocation);
      end;
      37:
      begin
        if length(arr) > 0 then
          DefaultEncoding := arr[0]
        else
          ZVAL_STRING(return_value, UserStyleSheetLocation);
      end;
      38:
      begin
        if Browser.MainFrame <> nil then
          ZVAL_STRING(return_value, Browser.MainFrame.Source);
      end;
      39:
      begin
        if Browser.MainFrame <> nil then
          ZVAL_STRING(return_value, Browser.MainFrame.Url);
      end;
    end;
  end;

  dispose_pzval_array(p);
end;


procedure chromium_settings;
var
  p: pzval_array;
  id: integer;
  s: ansistring;
begin
  if ht < 10 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);


  CefCache := Z_STRVAL(p[0]^);
  CefUserAgent := Z_STRVAL(p[1]^);
  CefProductVersion := Z_STRVAL(p[2]^);
  CefLocale := Z_STRVAL(p[3]^);
  CefLogFile := Z_STRVAL(p[4]^);
  CefExtraPluginPaths := Z_STRVAL(p[5]^);
  CefLocalStorageQuota := Z_LVAL(p[6]^);
  CefSessionStorageQuota := Z_LVAL(p[7]^);

  CefJavaScriptFlags := Z_STRVAL(p[8]^);
  CefAutoDetectProxySettings := Z_BVAL(p[9]^);

  dispose_pzval_array(p);
end;

procedure chromium_allowedcall;
var
  p: pzval_array;
  i: integer;
  s: ansistring;
  tmp: ^ppzval;
  arr: PHashTable;
begin
  if ht < 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  AllowedCall.Clear;

  if p[0]^^._type = IS_ARRAY then
    arr := p[0]^^.Value.ht
  else
    arr := nil;

  if arr <> nil then
  begin
    New(tmp);
    for i := zend_hash_num_elements(arr) - 1 downto 0 do
    begin
      zend_hash_index_find(arr, i, tmp);
      AllowedCall.SetValue(LowerCase(Z_STRVAL(tmp^^)), '');
    end;
    Dispose(tmp);
  end;

  dispose_pzval_array(p);
end;

procedure chromium_load;
begin
  CefLoadLibDefault;
end;

procedure V8_ZVAL(Value: ICefv8Value; arg: pzval);
var
  S: ansistring;
begin
  if Value.IsUndefined or Value.IsNull then
    ZVAL_NULL(arg)
  else if Value.IsBool then
    ZVAL_BOOL(arg, Value.GetBoolValue)
  else if Value.IsInt then
    ZVAL_LONG(arg, Value.GetIntValue)
  else if Value.IsDouble then
    ZVAL_DOUBLE(arg, Value.GetDoubleValue)
  else if Value.IsDate then
    ZVAL_DOUBLE(arg, Value.GetDateValue)
  else if Value.IsString then
  begin
    S := Value.GetStringValue;
    if S = '' then
      ZVAL_EMPTY_STRING(arg)
    else
      ZVAL_STRINGL(arg, PAnsiChar(S), Length(S), True);
  end
  else
    ZVAL_NULL(arg);
end;

function ZVAL_V8(arg: pzval): ICefv8Value;
begin
  case arg._type of
    IS_LONG: Result := TCefv8ValueRef.CreateInt(arg.Value.lval);
    IS_DOUBLE: Result := TCefv8ValueRef.CreateDouble(arg.Value.dval);
    IS_BOOL: Result := TCefv8ValueRef.CreateBool(boolean(arg.Value.lval));
    IS_STRING: Result := TCefv8ValueRef.CreateString(Z_STRVAL(arg));
    else
      Result := TCefv8ValueRef.CreateNull;
  end;
end;

function TExtension.Execute(const Name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var Exception: ustring): boolean;
var
  S: ansistring;
  Args: pzval_array_ex;
  Return, Func: pzval;
  i: integer;
begin
   {if name = 'eval' then
   begin
      if length(arguments) > 0 then
      begin
         phpMOD.RunCode( arguments[0].GetStringValue );
      end;
   end else}
  if Name = 'call' then
  begin
    if length(arguments) > 0 then
    begin
      S := arguments[0].GetStringValue;
      if (AllowedCall.FSize = 0) or (not AllowedCall.HasKey(LowerCase(S))) then
      begin
        Result := False;
        exit;
      end;

      Func := MAKE_STD_ZVAL;
      Return := MAKE_STD_ZVAL;


      ZVAL_STRING(Func, PAnsiChar(S), True);

      SetLength(args, length(arguments) - 1);
      for i := 0 to high(args) do
      begin
        args[i] := MAKE_STD_ZVAL;
        V8_ZVAL(arguments[i + 1], args[i]);
      end;

      call_user_function(
        GetExecutorGlobals.function_table,
        nil,
        Func,
        Return,
        Length(Args),
        Args,
        phpMOD.psvPHP.TSRMLS_D
        );

      for i := 0 to high(args) do
      begin
        _zval_dtor(args[0], nil, 0);
      end;

      retval := ZVAL_V8(Return);
      Result := True;

      _zval_dtor(Func, nil, 0);
      _zval_dtor(Return, nil, 0);
    end;
  end;
end;

const
  code =
    'var PHP;' + 'if (!PHP)' + '  PHP = {};' + '(function() {' +
  (* '  PHP.eval = function(code) {'+
   '    native function eval(code);'+
   '    return eval(code);'+
   '  };'+   *)
    '  PHP.call = function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15) {' +
    '    native function call(arguments);' + '    return call.apply(null, arguments);' +
    '  };' + '})();';

// after load chromium callback
procedure callback_CefLoadLib;
begin
  CefRegisterExtension('v8/PHP', code, TExtension.Create as ICefV8Handler);
end;

procedure InitializeGuiChromium(PHPEngine: TPHPEngine);
begin
  PHPEngine.AddFunction('chromium_settings', @chromium_settings);
  PHPEngine.AddFunction('chromium_load', @chromium_load);
  PHPEngine.AddFunction('chromium_allowedcall', @chromium_allowedcall);
  PHPEngine.AddFunction('chromium_exec', @chromium_exec);
  PHPEngine.AddFunction('chromium_prop', @chromium_prop);


  CefLoadLibAfter := callback_CefLoadLib;
end;


initialization
  AllowedCall := TStringHashTable.Create(256);

end.
