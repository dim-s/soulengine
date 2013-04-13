{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{ http://delphi32.blogspot.com                          }
{*******************************************************}
{$I PHP.INC}

{ $Id: PHPAPI.pas,v 7.2 10/2009 delphi32 Exp $ }

unit phpAPI;

{$ifdef fpc}
   {$mode delphi}
{$endif}

interface

uses
 {Windows} SysUtils,

 {$IFDEF FPC}
  dynlibs,
 {$ELSE}
  windows,
 {$ENDIF}

 ZendTypes, PHPTypes, zendAPI,


 {$IFDEF VERSION6}Variants{$ENDIF}{WinSock};


{$IFNDEF VERSION11}
const
  varUString  = $0102; { Unicode string 258 } {not OLE compatible}
{$ENDIF}

var
 php_request_startup: function(TSRMLS_D : pointer) : Integer; cdecl;
 php_request_shutdown: procedure(dummy : Pointer); cdecl;
 php_module_startup: function(sf : pointer; additional_modules : pointer; num_additional_modules : uint) : Integer; cdecl;
 php_module_shutdown:  procedure(TSRMLS_D : pointer); cdecl;
 php_module_shutdown_wrapper:  function (globals : pointer) : Integer; cdecl;

 sapi_startup: procedure (module : pointer); cdecl;
 sapi_shutdown:  procedure; cdecl;

 sapi_activate: procedure (p : pointer); cdecl;
 sapi_deactivate: procedure (p : pointer); cdecl;

 sapi_add_header_ex: function(header_line : PAnsiChar; header_line_len : uint; duplicated : zend_bool; replace : zend_bool; TSRMLS_DC : pointer) : integer; cdecl;

 php_execute_script : function (primary_file: pointer; TSRMLS_D : pointer) : Integer; cdecl;

 php_handle_aborted_connection:  procedure; cdecl;

 php_register_variable: procedure(_var : PAnsiChar; val: PAnsiChar; track_vars_array: pointer; TSRMLS_DC : pointer); cdecl;

  // binary-safe version
  php_register_variable_safe: procedure(_var : PAnsiChar; val : PAnsiChar; val_len : integer; track_vars_array : pointer; TSRMLS_DC : pointer); cdecl;
  php_register_variable_ex: procedure(_var : PAnsiChar;   val : pzval;  track_vars_array : pointer; TSRMLS_DC : pointer); cdecl;

//php_output.h

  php_output_startup: procedure(); cdecl;
  php_output_activate: procedure (TSRMLS_D : pointer); cdecl;
  php_output_set_status: procedure(status: boolean; TSRMLS_DC : pointer); cdecl;
  php_output_register_constants: procedure (TSRMLS_D : pointer); cdecl;
  php_start_ob_buffer: function  (output_handler : pzval; chunk_size : uint; erase : boolean; TSRMLS_DC : pointer) : integer; cdecl;
  php_start_ob_buffer_named: function  (const output_handler_name : PAnsiChar;  chunk_size : uint; erase : boolean; TSRMLS_DC : pointer) : integer; cdecl;
  php_end_ob_buffer: procedure (send_buffer : boolean; just_flush : boolean; TSRMLS_DC : pointer); cdecl;
  php_end_ob_buffers: procedure (send_buffer : boolean; TSRMLS_DC : pointer); cdecl;
  php_ob_get_buffer: function  (p : pzval; TSRMLS_DC : pointer) : integer; cdecl;
  php_ob_get_length: function  (p : pzval; TSRMLS_DC : pointer) : integer; cdecl;
  php_start_implicit_flush: procedure (TSRMLS_D : pointer); cdecl;
  php_end_implicit_flush: procedure (TSRMLS_D : pointer); cdecl;
  php_get_output_start_filename: function  (TSRMLS_D : pointer) : PAnsiChar; cdecl;
  php_get_output_start_lineno: function (TSRMLS_D : pointer) : integer; cdecl;
  php_ob_handler_used: function (handler_name : PAnsiChar; TSRMLS_DC : pointer) : integer; cdecl;
  php_ob_init_conflict: function (handler_new : PAnsiChar; handler_set : PAnsiChar; TSRMLS_DC : pointer) : integer; cdecl;


function GetSymbolsTable : PHashTable;
function GetTrackHash(Name : AnsiString) : PHashTable;
function GetSAPIGlobals : Psapi_globals_struct;
procedure phperror(Error : PAnsiChar);

var

php_default_post_reader : procedure;

//php_string.h
php_strtoupper: function  (s : PAnsiChar; len : size_t) : PAnsiChar; cdecl;
php_strtolower: function  (s : PAnsiChar; len : size_t) : PAnsiChar; cdecl;

php_strtr: function (str : PAnsiChar; len : Integer; str_from : PAnsiChar;
  str_to : PAnsiChar; trlen : Integer) : PAnsiChar; cdecl;

php_stripcslashes: procedure (str : PAnsiChar; len : PInteger); cdecl;

php_basename: function (str : PAnsiChar; len : size_t; suffix : PAnsiChar;
  sufflen : size_t) : PAnsiChar; cdecl;

php_dirname: procedure (str : PAnsiChar; len : Integer); cdecl;

php_stristr: function (s : PByte; t : PByte; s_len : size_t; t_len : size_t) : PAnsiChar; cdecl;

php_str_to_str: function (haystack : PAnsiChar; length : Integer; needle : PAnsiChar;
    needle_len : Integer; str : PAnsiChar; str_len : Integer;
    _new_length : PInteger) : PAnsiChar; cdecl;

php_strip_tags: procedure (rbuf : PAnsiChar; len : Integer; state : PInteger;
  allow : PAnsiChar; allow_len : Integer); cdecl;

php_implode: procedure (var delim : zval; var arr : zval;
  var return_value : zval); cdecl;

php_explode: procedure  (var delim : zval; var str : zval;
  var return_value : zval; limit : Integer); cdecl;


var

php_info_html_esc: function (str : PAnsiChar; TSRMLS_DC : pointer) : PAnsiChar; cdecl;

php_print_info_htmlhead: procedure (TSRMLS_D : pointer); cdecl;

php_log_err: procedure (err_msg : PAnsiChar; TSRMLS_DC : pointer); cdecl;

php_html_puts: procedure (str : PAnsiChar; str_len : integer; TSRMLS_DC : pointer); cdecl;

_php_error_log: function (opt_err : integer; msg : PAnsiChar; opt: PAnsiChar;  headers: PAnsiChar; TSRMLS_DC : pointer) : integer; cdecl;

php_print_credits: procedure (flag : integer); cdecl;

php_info_print_css: procedure(); cdecl;

php_set_sock_blocking: function (socketd : integer; block : integer; TSRMLS_DC : pointer) : integer; cdecl;
php_copy_file: function (src : PAnsiChar; dest : PAnsiChar; TSRMLS_DC : pointer) : integer; cdecl;

var
php_escape_html_entities: function (old : PByte; oldlen : integer; newlen : PINT; all : integer;
  quote_style : integer; hint_charset: PAnsiChar; TSRMLS_DC : pointer) : PAnsiChar; cdecl;

var
php_ini_long: function (name : PAnsiChar; name_length : uint; orig : Integer) : Longint; cdecl;

php_ini_double: function(name : PAnsiChar; name_length : uint; orig : Integer) : Double; cdecl;

php_ini_string: function(name : PAnsiChar; name_length : uint; orig : Integer) : PAnsiChar; cdecl;

function  zval2variant(value : zval) : variant;
procedure variant2zval(value : variant; z : pzval);


var

php_url_free: procedure (theurl : pphp_url); cdecl;
php_url_parse: function  (str : PAnsiChar) : pphp_url; cdecl;
php_url_decode: function (str : PAnsiChar; len : Integer) : Integer; cdecl;
                     { return value: length of decoded string }

php_raw_url_decode: function (str : PAnsiChar; len : Integer) : Integer; cdecl;
                          { return value: length of decoded string }

php_url_encode: function (s : PAnsiChar; len : Integer; new_length : PInteger) : PAnsiChar; cdecl;

php_raw_url_encode: function (s : PAnsiChar; len : Integer; new_length : PInteger) : PAnsiChar; cdecl;

{$IFDEF PHP510}
php_register_extensions: function (ptr : pointer; count: integer; TSRMLS_DC: pointer) : integer; cdecl;
{$ELSE}
php_startup_extensions: function (ptr: pointer; count : integer) : integer; cdecl;
{$ENDIF}

php_error_docref0: procedure (const docref : PAnsiChar; TSRMLS_DC : pointer; _type : integer; const Msg : PAnsiChar); cdecl;
php_error_docref: procedure (const docref : PAnsiChar; TSRMLS_DC : pointer; _type : integer; const Msg : PAnsiChar); cdecl;

php_error_docref1: procedure (const docref : PAnsiChar; TSRMLS_DC : pointer; const param1 : PAnsiChar; _type: integer; Msg : PAnsiChar); cdecl;
php_error_docref2: procedure (const docref : PAnsiChar; TSRMLS_DC : pointer; const param1 : PAnsiChar; const param2 : PAnsiChar; _type : integer; Msg : PAnsiChar); cdecl;

sapi_globals_id : pointer;
core_globals_id : pointer;

function GetPostVariables: pzval;
function GetGetVariables : pzval;
function GetServerVariables : pzval;
function GetEnvVariables : pzval;
function GetFilesVariables : pzval;

function GetPHPGlobals(TSRMLS_DC : pointer) : Pphp_Core_Globals;
function PG(TSRMLS_DC : pointer) : Pphp_Core_Globals;


procedure PHP_FUNCTION(var AFunction : zend_function_entry; AName : PAnsiChar; AHandler : pointer);

function LoadPHP(const DllFileName: AnsiString = PHPWin) : boolean;

procedure UnloadPHP;

function PHPLoaded : boolean;

{$IFNDEF QUIET_LOAD}
procedure CheckPHPErrors;
{$ENDIF}

function FloatToValue(Value: Extended): AnsiString;
function ValueToFloat(Value : AnsiString) : extended;

type
  TPHPFileInfo = record
    MajorVersion: Word;
    MinorVersion: Word;
    Release:Word;
    Build:Word;
  end;

function GetPHPVersion: TPHPFileInfo;


implementation

function PHPLoaded : boolean;
begin
  Result := PHPLib <> 0;
end;

procedure UnloadPHP;
var
 H : THandle;
begin
  H := InterlockedExchange(integer(PHPLib), 0);
  if H > 0 then
  begin
    FreeLibrary(H);
  end;
end;

{$IFDEF PHP4}
function GetSymbolsTable : PHashTable;
var
 executor_globals : pointer;
 executor_globals_value : integer;
 executor_hash : PHashTable;
 tsrmls_dc : pointer;
begin
  if not PHPLoaded then
   begin
     Result := nil;
     Exit;
   end;

  executor_globals := GetProcAddress(PHPLib, 'executor_globals_id');
  executor_globals_value := integer(executor_globals^);
  tsrmls_dc := tsrmls_fetch;
  asm
    mov ecx, executor_globals_value
    mov edx, dword ptr tsrmls_dc
    mov eax, dword ptr [edx]
    mov ecx, dword ptr [eax+ecx*4-4]
    add ecx, 0DCh
    mov executor_hash, ecx
  end;
  Result := executor_hash;
end;
{$ELSE}
function GetSymbolsTable : PHashTable;
begin
  Result := @GetExecutorGlobals.symbol_table;
end;

{$ENDIF}

function GetTrackHash(Name : AnsiString) : PHashTable;
var
 data : ^ppzval;
 arr  : PHashTable;
 ret  : integer;
begin
 Result := nil;
  {$IFDEF PHP4}
   arr := GetSymbolsTable;
  {$ELSE}
   arr := @GetExecutorGlobals.symbol_table;
  {$ENDIF}
 if Assigned(Arr) then
  begin
    new(data);
    ret := zend_hash_find(arr, PAnsiChar(Name), Length(Name)+1, Data);
    if ret = SUCCESS then
     begin
       Result := data^^^.value.ht;
     end;
  end;
end;


function GetSAPIGlobals : Psapi_globals_struct;
var
 sapi_globals_value : integer;
 sapi_globals : Psapi_globals_struct;
 tsrmls_dc : pointer;
begin
  Result := nil;
  if Assigned(sapi_globals_id) then
   begin
     tsrmls_dc := tsrmls_fetch;
     sapi_globals_value := integer(sapi_globals_id^);
     asm
       mov ecx, sapi_globals_value
       mov edx, dword ptr tsrmls_dc
       mov eax, dword ptr [edx]
       mov ecx, dword ptr [eax+ecx*4-4]
       mov sapi_globals, ecx
     end;
     Result := sapi_globals;
   end;
end;


function zval2variant(value : zval) : variant;
begin
  case Value._type of
   IS_NULL    : Result := NULL;
   IS_LONG    : Result := Value.value.lval;
   IS_DOUBLE  : Result := Value.value.dval;
   IS_STRING  : Result := AnsiString(Value.Value.str.val);
   IS_BOOL    : Result := Boolean(Value.Value.lval);
    else
      Result := NULL;
  end;
end;


procedure variant2zval(value : variant; z : pzval);
var
 W : WideString;
begin
  if VarIsEmpty(value) then
   begin
     ZVAL_NULL(z);
     Exit;
   end;

   case TVarData(Value).VType of
     varString    : //Peter Enz
         begin
           if Assigned ( TVarData(Value).VString ) then
             begin
               ZVAL_STRING(z, TVarData(Value).VString , true);
             end
               else
                 begin
                   ZVAL_STRING(z, '', true);
                 end;
         end;

     varOleStr    : //Peter Enz
         begin
           if Assigned ( TVarData(Value).VOleStr ) then
             begin
               W := WideString(Pointer(TVarData(Value).VOleStr));
               ZVAL_STRINGW(z, PWideChar(W),  true);
             end
               else
                 begin
                   ZVAL_STRING(z, '', true);
                 end;
         end;
     varSmallInt : ZVAL_LONG(z, TVarData(Value).VSmallint);
     varInteger  : ZVAL_LONG(z, TVarData(Value).VInteger);
     varBoolean  : ZVAL_BOOL(z, TVarData(Value).VBoolean);
     varSingle   : ZVAL_DOUBLE(z, TVarData(Value).VSingle);
     varDouble   : ZVAL_DOUBLE(z, TVarData(Value).VDouble);
     varError    : ZVAL_LONG(z, TVarData(Value).VError);
     varByte     : ZVAL_LONG(z, TVarData(Value).VByte);
     varDate     : ZVAL_DOUBLE(z, TVarData(Value).VDate);
     else
       ZVAL_NULL(Z);
   end;
end;


function GetPHPGlobals(TSRMLS_DC : pointer) : Pphp_Core_Globals;
var
 core_globals_value : integer;
 core_globals : Pphp_core_globals;
begin
  Result := nil;
  if Assigned(core_globals_id) then
   begin
     core_globals_value := integer(core_globals_id^);
     asm
       mov ecx, core_globals_value
       mov edx, dword ptr tsrmls_dc
       mov eax, dword ptr [edx]
       mov ecx, dword ptr [eax+ecx*4-4]
       mov core_globals, ecx
     end;
     Result := core_globals;
   end;
end;



function PG(TSRMLS_DC : pointer) : Pphp_Core_Globals;
begin
  result := GetPHPGlobals(TSRMLS_DC);
end;




procedure PHP_FUNCTION(var AFunction : zend_function_entry; AName : PAnsiChar; AHandler : pointer);
begin
  AFunction.fname := AName;

  AFunction.handler := AHandler;
  {$IFDEF PHP4}
  AFunction.func_arg_types := nil;
  {$ELSE}
  AFunction.arg_info := nil;
  {$ENDIF}
end;


procedure phperror(Error : PAnsiChar);
begin
  zend_error(E_PARSE, Error);
end;


function LoadPHP(const DllFileName: AnsiString = PHPWin) : boolean;

begin
  Result := false;
  if not PHPLoaded then
    begin
      if not LoadZend(DllFileName) then
       Exit;
    end;

  sapi_globals_id                  := GetProcAddress(PHPLib, 'sapi_globals_id');

  core_globals_id                  := GetProcAddress(PHPLib, 'core_globals_id');

  php_default_post_reader          := GetProcAddress(PHPLib, 'php_default_post_reader');

  sapi_add_header_ex               := GetProcAddress(PHPLib, 'sapi_add_header_ex');

  php_request_startup              := GetProcAddress(PHPLib, 'php_request_startup');

  php_request_shutdown             := GetProcAddress(PHPLib, 'php_request_shutdown');

  php_module_startup               := GetProcAddress(PHPLib, 'php_module_startup');

  php_module_shutdown              := GetProcAddress(PHPLib, 'php_module_shutdown');

  php_module_shutdown_wrapper      := GetProcAddress(PHPLib, 'php_module_shutdown_wrapper');

  sapi_startup                     := GetProcAddress(PHPLib, 'sapi_startup');

  sapi_shutdown                    := GetProcAddress(PHPLib, 'sapi_shutdown');

  sapi_activate                    := GetProcAddress(PHPLib, 'sapi_activate');

  sapi_deactivate                  := GetProcAddress(PHPLib, 'sapi_deactivate');

  php_execute_script               := GetProcAddress(PHPLib, 'php_execute_script');

  php_handle_aborted_connection    := GetProcAddress(PHPLib, 'php_handle_aborted_connection');

  php_register_variable            := GetProcAddress(PHPLib, 'php_register_variable');

  php_register_variable_safe       := GetProcAddress(PHPLib, 'php_register_variable_safe');

  php_register_variable_ex         := GetProcAddress(PHPLib, 'php_register_variable_ex');

  php_stripcslashes                := GetProcAddress(PHPLib, 'php_stripcslashes');

  php_strip_tags                   := GetProcAddress(PHPLib, 'php_strip_tags');

  php_log_err                         := GetProcAddress(PHPLib, 'php_log_err');

  php_html_puts                       := GetProcAddress(PHPLib, 'php_html_puts');

  _php_error_log                      := GetProcAddress(PHPLib, '_php_error_log');

  php_print_credits                   := GetProcAddress(PHPLib, 'php_print_credits');

  php_info_print_css                  := GetProcAddress(PHPLib, 'php_info_print_css');

  php_set_sock_blocking               := GetProcAddress(PHPLib, 'php_set_sock_blocking');

  php_copy_file                       := GetProcAddress(PHPLib, 'php_copy_file');

  php_escape_html_entities            := GetProcAddress(PHPLib, 'php_escape_html_entities');

  php_ini_long                        := GetProcAddress(PHPLib, 'zend_ini_long');

  php_ini_double                      := GetProcAddress(PHPLib, 'zend_ini_double');

  php_ini_string                      := GetProcAddress(PHPLib, 'zend_ini_string');

  php_url_free                        := GetProcAddress(PHPLib, 'php_url_free');

  php_url_parse                       := GetProcAddress(PHPLib, 'php_url_parse');

  php_url_decode                      := GetProcAddress(PHPLib, 'php_url_decode');

  php_raw_url_decode                  := GetProcAddress(PHPLib, 'php_raw_url_decode');

  php_url_encode                      := GetProcAddress(PHPLib, 'php_url_encode');

  php_raw_url_encode                  := GetProcAddress(PHPLib, 'php_raw_url_encode');

  {$IFDEF PHP510}
  php_register_extensions             := GetProcAddress(PHPLib, 'php_register_extensions');
  {$ELSE}
  php_startup_extensions              := GetProcAddress(PHPLib, 'php_startup_extensions');
  {$ENDIF}

  php_error_docref0                   := GetProcAddress(PHPLib, 'php_error_docref0');

  php_error_docref                    := GetProcAddress(PHPLib, 'php_error_docref0');

  php_error_docref1                   := GetProcAddress(PHPLib, 'php_error_docref1');

  php_error_docref2                   := GetProcAddress(PHPLib, 'php_error_docref2');

  {$IFNDEF QUIET_LOAD}
  CheckPHPErrors;
  {$ENDIF}

  Result := true;
end;



{$IFNDEF QUIET_LOAD}
procedure CheckPHPErrors;
begin
  if @sapi_add_header_ex = nil then raise EPHP4DelphiException.Create('sapi_add_header_ex');
  if @php_request_startup = nil then raise EPHP4DelphiException.Create('php_request_startup');
  if @php_request_shutdown = nil then raise EPHP4DelphiException.Create('php_request_shutdown');
  if @php_module_startup = nil then raise EPHP4DelphiException.Create('php_module_startup');
  if @php_module_shutdown = nil then raise EPHP4DelphiException.Create('php_module_shutdown');
  if @php_module_shutdown_wrapper = nil then raise EPHP4DelphiException.Create('php_module_shutdown_wrapper');
  if @sapi_startup = nil then raise EPHP4DelphiException.Create('sapi_startup');
  if @sapi_shutdown = nil then raise EPHP4DelphiException.Create('sapi_shutdown');
  if @sapi_activate = nil then raise EPHP4DelphiException.Create('sapi_activate');
  if @sapi_deactivate = nil then raise EPHP4DelphiException.Create('sapi_deactivate');
  if @php_execute_script = nil then raise EPHP4DelphiException.Create('php_execute_script');
  if @php_handle_aborted_connection = nil then raise EPHP4DelphiException.Create('php_handle_aborted_connection');
  if @php_register_variable = nil then raise EPHP4DelphiException.Create('php_register_variable');
  if @php_register_variable_safe = nil then raise EPHP4DelphiException.Create('php_register_variable_safe');
  if @php_register_variable_ex = nil then raise EPHP4DelphiException.Create('php_register_variable_ex');
  if @php_strip_tags = nil then raise EPHP4DelphiException.Create('php_strip_tags');
  if @php_log_err = nil then raise EPHP4DelphiException.Create('php_log_err');
  if @php_html_puts = nil then raise EPHP4DelphiException.Create('php_html_puts');
  if @_php_error_log = nil then raise EPHP4DelphiException.Create('_php_error_log');
  if @php_print_credits = nil then raise EPHP4DelphiException.Create('php_print_credits');
  if @php_info_print_css = nil then raise EPHP4DelphiException.Create('php_info_print_css');
  if @php_set_sock_blocking = nil then raise EPHP4DelphiException.Create('php_set_sock_blocking');
  if @php_copy_file = nil then raise EPHP4DelphiException.Create('php_copy_file');

  if @php_ini_long = nil then raise EPHP4DelphiException.Create('php_ini_long');
  if @php_ini_double = nil then raise EPHP4DelphiException.Create('php_ini_double');
  if @php_ini_string = nil then raise EPHP4DelphiException.Create('php_ini_string');
  if @php_url_free = nil then raise EPHP4DelphiException.Create('php_url_free');
  if @php_url_parse = nil then raise EPHP4DelphiException.Create('php_url_parse');
  if @php_url_decode = nil then raise EPHP4DelphiException.Create('php_url_decode');
  if @php_raw_url_decode = nil then raise EPHP4DelphiException.Create('php_raw_url_decode');
  if @php_url_encode = nil then raise EPHP4DelphiException.Create('php_url_encode');
  if @php_raw_url_encode = nil then raise EPHP4DelphiException.Create('php_raw_url_encode');

  {$IFDEF PHP510}
  if @php_register_extensions = nil then raise EPHP4DelphiException.Create('php_register_extensions');
  {$ELSE}
  if @php_startup_extensions = nil then raise EPHP4DelphiException.Create('php_startup_extensions');
  {$ENDIF}
  
  if @php_error_docref0 = nil then raise EPHP4DelphiException.Create('php_error_docref0');
  if @php_error_docref = nil then raise EPHP4DelphiException.Create('php_error_docref');
  if @php_error_docref1 = nil then raise EPHP4DelphiException.Create('php_error_docref1');
  if @php_error_docref2 = nil then raise EPHP4DelphiException.Create('php_error_docref2');
end;
{$ENDIF}

function GetPostVariables: pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[0];
end;

function GetGetVariables : pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[1];
end;

function GetServerVariables : pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[3];
end;

function GetEnvVariables : pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[4];
end;

function GetFilesVariables : pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[5];
end;


function FloatToValue(Value: Extended): AnsiString;
var
  {$IFDEF VERSION12}
  c: WideChar;
  {$ELSE}
  c: AnsiChar;
  {$ENDIF}
begin
  c := DecimalSeparator;
  try
   DecimalSeparator := '.';
   Result := SysUtils.FormatFloat('0.####', Value);
  finally
    DecimalSeparator := c;
  end;
end;

function ValueToFloat(Value : AnsiString) : extended;
var
  {$IFDEF VERSION12}
  c: WideChar;
  {$ELSE}
  c : AnsiChar;
  {$ENDIF}
begin
  c := DecimalSeparator;
  try
   DecimalSeparator := '.';
   Result := SysUtils.StrToFloat(Value);
  finally
   DecimalSeparator := c;
  end;
end;


function GetPHPVersion: TPHPFileInfo;
var
  FileName: AnsiString;
begin
  Result.MajorVersion := 0;
  Result.MinorVersion := 0;
  Result.Release := 0;
  Result.Build := 0;
  FileName := PHPWin;
end;

initialization
{$IFDEF PHP4DELPHI_AUTOLOAD}
  LoadPHP;
{$ENDIF}

finalization
{$IFDEF PHP4DELPHI_AUTOUNLOAD}
  UnloadPHP;
{$ENDIF}

end.
