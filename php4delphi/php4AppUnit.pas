{*******************************************************}
{                   PHP4Applications                    }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{*******************************************************}

{$I PHP.INC}

{ $Id: php4AppUnit.pas,v 7.2 10/2009 delphi32 Exp $ }

unit php4AppUnit;

interface
uses
  Windows,
  SysUtils,
  Classes,
  ZendTypes,
  phpTypes,
  PHPAPI,
  ZENDAPI;

const
  REQUEST_ID_NOT_FOUND = -1;
  VARIABLE_NOT_FOUND = -2;
  ERROR_CREATE_PIPE = -3;
  SCRIPT_IS_EMPTY = -4;

type

 TPHPInfoBlock = class
 private
  FBuffer  : AnsiString;
  FVarList : TStringList;
  {$IFDEF PHP5}
  FVirtualStream : TMemoryStream;
  {$ENDIF}
  procedure SetVarList(AValue : TStringList);
 public
  constructor Create; virtual;
  destructor  Destroy; override;
  property    Buffer : AnsiString read FBuffer write FBuffer;
  property    VarList : TStringList read FVarList write SetVarList;
 end;

function  InitRequest : integer; stdcall;
procedure DoneRequest(RequestID : integer); stdcall;

procedure RegisterVariable(RequestID : integer; AName : PAnsiChar; AValue : PAnsiChar); stdcall;
function  ExecutePHP(RequestID : integer; FileName : PAnsiChar) : integer; stdcall;
function  ExecuteCode(RequestID : integer; ACode : PAnsiChar) : integer; stdcall;
function  GetResultText(RequestID : integer; Buffer : PAnsiChar; BufLen : integer) : integer; stdcall;
function  GetVariable(RequestID : integer; AName : PAnsiChar; Buffer : PAnsiChar; BufLen : integer) : integer; stdcall;
procedure SaveToFile(RequestID : integer; AFileName : PAnsiChar); stdcall;
function  GetVariableSize(RequestID : integer; AName : PAnsiChar) : integer; stdcall;
function  GetResultBufferSize(RequestID : integer) : integer; stdcall;

procedure PrepareStartup;

procedure InitEngine;

procedure StopEngine;

implementation

var
  delphi_sapi_module : sapi_module_struct;
  php_delphi_module : Tzend_module_entry;

procedure php_info_delphi(zend_module : Pointer; TSRMLS_DC : pointer); cdecl;
begin
  php_info_print_table_start();
  php_info_print_table_row(2, PAnsiChar('SAPI module version'), PAnsiChar('PHP4Delphi 7.2 Oct 2009'));
  php_info_print_table_row(2, PAnsiChar('Home page'), PAnsiChar('http://users.telenet.be/ws36637'));
  php_info_print_table_end();
end;

function php_delphi_startup(sapi_module : Psapi_module_struct) : integer; cdecl;
begin
  result := php_module_startup(sapi_module, nil, 0);
end;

function php_delphi_deactivate(p : pointer) : integer; cdecl;
begin
  result := 0;
end;


function php_delphi_ub_write(str : PAnsiChar; len : uint; p : pointer) : integer; cdecl;
var
 s : AnsiString;
 php : TPHPInfoBlock;
 gl : psapi_globals_struct;
begin
  Result := 0;
  gl := GetSAPIGlobals;
  if Assigned(gl) then
   begin
     php := TPHPInfoBlock(gl^.server_context);
     if Assigned(php) then
      begin
        SetLength(s, len);
        Move(str^, s[1], len);
        try
         php.FBuffer := php.FBuffer + s;
        except
          s := '';
        end;
        result := len;
      end;
   end;
   s := '';
end;

procedure php_delphi_flush(p : pointer); cdecl;
begin
end;

procedure php_delphi_register_variables(val : pzval; p : pointer); cdecl;
var
 cnt : integer;
 InfoBlock : TPHPInfoBlock;
 gl : psapi_globals_struct;
begin
  gl := GetSAPIGlobals;
  InfoBlock := TPHPInfoBlock(gl^.server_context);
  php_register_variable('SERVER_NAME','DELPHI', val, p);
  php_register_variable('SERVER_SOFTWARE', 'Delphi', val, p);
  if Assigned(InfoBlock) then
   try
     for cnt := 0 to InfoBlock.VarList.Count - 1 do
      begin
        php_register_variable(PAnsiChar(InfoBlock.VarList.Names[cnt]),
               PAnsiChar(InfoBlock.VarList.Values[InfoBlock.VarList.Names[cnt]]), val, p);
      end;
   except
   end;
end;


procedure php_delphi_send_header(p1, p2, p3 : pointer); cdecl;
begin
  //
end;

function php_delphi_read_cookies(p1 : pointer) : pointer; cdecl;
begin
  result := nil;
end;


procedure PrepareStartup;
begin
  delphi_sapi_module.name := 'embed';  (* name *)
  delphi_sapi_module.pretty_name := 'PHP for Delphi';  (* pretty name *)
  delphi_sapi_module.startup := php_delphi_startup;    (* startup *)
  delphi_sapi_module.shutdown := php_module_shutdown_wrapper;   (* shutdown *)
  delphi_sapi_module.activate:= nil;  (* activate *)
  delphi_sapi_module.deactivate := @php_delphi_deactivate;  (* deactivate *)
  delphi_sapi_module.ub_write := @php_delphi_ub_write;      (* unbuffered write *)
  delphi_sapi_module.flush := @php_delphi_flush;
  delphi_sapi_module.stat:= nil;
  delphi_sapi_module.getenv:= nil;
  delphi_sapi_module.sapi_error := @zend_error;  (* error handler *)
  delphi_sapi_module.header_handler := nil;
  delphi_sapi_module.send_headers := nil;
  delphi_sapi_module.send_header :=  @php_delphi_send_header;
  delphi_sapi_module.read_post := nil;
  delphi_sapi_module.read_cookies := @php_delphi_read_cookies;
  delphi_sapi_module.register_server_variables := @php_delphi_register_variables;   (* register server variables *)
  delphi_sapi_module.log_message := nil;  (* Log message *)
  delphi_sapi_module.php_ini_path_override := nil;
  delphi_sapi_module.block_interruptions := nil;
  delphi_sapi_module.unblock_interruptions := nil;
  delphi_sapi_module.default_post_reader := nil;
  delphi_sapi_module.treat_data := nil;
  delphi_sapi_module.executable_location := nil;
  delphi_sapi_module.php_ini_ignore := 0;

  php_delphi_module.size := sizeOf(Tzend_module_entry);
  php_delphi_module.zend_api := ZEND_MODULE_API_NO;
  php_delphi_module.zend_debug := 0;
  php_delphi_module.zts := USING_ZTS;
  php_delphi_module.name := 'php4delphi_support';
  php_delphi_module.functions := nil;
  php_delphi_module.module_startup_func := nil;
  php_delphi_module.module_shutdown_func := nil;
  php_delphi_module.info_func := @php_info_delphi;
  php_delphi_module.version := '7.2';
  {$IFDEF PHP4}
  php_delphi_module.global_startup_func := nil;
  {$ENDIF}
  php_delphi_module.request_shutdown_func := nil;
  {$IFDEF PHP5}
  {$IFNDEF PHP520}
  php_delphi_module.global_id := 0;
  {$ENDIF}
  {$ENDIF}
  php_delphi_module.module_started := 0;
  php_delphi_module._type := 0;
  php_delphi_module.handle := nil;
  php_delphi_module.module_number := 0;

  {$IFDEF PHP530}
  {$IFNDEF COMPILER_VC9}
  php_delphi_module.build_id := strdup(PAnsiChar(ZEND_MODULE_BUILD_ID));
  {$ELSE}
  php_delphi_module.build_id := DupStr(PAnsiChar(ZEND_MODULE_BUILD_ID));
  {$ENDIF}
  {$ENDIF}

end;



procedure PrepareResult(RequestID : integer; TSRMLS_D : pointer);
var
  ht  : PHashTable;
  data: ^ppzval;
  cnt : integer;
  InfoBlock : TPHPInfoBlock;
  {$IFDEF PHP5}
  EG : pzend_executor_globals;
  {$ENDIF}

begin
  InfoBlock := TPHPInfoBlock(RequestID);

  {$IFDEF PHP4}
   ht := GetSymbolsTable
  {$ELSE}
    begin
     EG := GetExecutorGlobals;
     if Assigned(EG) then
     ht := @EG.symbol_table
      else
        ht := nil;
    end ;
  {$ENDIF}

  if Assigned(ht) then
   begin
     for cnt := 0 to InfoBlock.VarList.Count - 1  do
      begin
        new(data);
        try
          if zend_hash_find(ht, PAnsiChar(InfoBlock.VarList.Names[cnt]),
          strlen(PAnsiChar(InfoBlock.VarList.Names[cnt])) + 1, data) = SUCCESS then
          case data^^^._type of
            IS_STRING : InfoBlock.VarList.Values[InfoBlock.VarList.Names[cnt]] := data^^^.value.str.val;
            IS_LONG,
            IS_RESOURCE,
            IS_BOOL   : InfoBlock.VarList.Values[InfoBlock.VarList.Names[cnt]] := IntToStr(data^^^.value.lval);
            IS_DOUBLE : InfoBlock.VarList.Values[InfoBlock.VarList.Names[cnt]] := FloatToStr(data^^^.value.dval);
          end;
        finally
          freemem(data);
        end;
      end;
   end;
end;

function ExecutePHP(RequestID : integer; FileName : PAnsiChar) : integer; stdcall;
var
  file_handle : zend_file_handle;
  TSRMLS_D : pointer;
  gl  : psapi_globals_struct;
begin
  if RequestID <= 0 then
   begin
     Result := REQUEST_ID_NOT_FOUND;
     Exit;
   end;

  try
   TSRMLS_D := ts_resource_ex(0, nil);

   ZeroMemory(@file_handle, sizeof(zend_file_handle));

   file_handle._type := ZEND_HANDLE_FILENAME;
   file_handle.filename := FileName;
   file_handle.opened_path := nil;
   file_handle.free_filename := 0;
   file_handle.handle.fp := nil;

   PG(TSRMLS_D)^.register_globals := true;
   gl := GetSAPIGlobals;
   TPHPInfoBlock(RequestID).FBuffer := '';
   gl^.server_context := pointer(RequestID);
   gl^.sapi_headers.http_response_code := 200;
   gl^.request_info.request_method := 'GET';

   php_request_startup(TSRMLS_D);
   result := php_execute_script(@file_handle, TSRMLS_D);
   {$IFDEF PHP5}
   zend_destroy_file_handle(@file_handle, TSRMLS_D);
   {$ENDIF}
   PrepareResult(RequestID, TSRMLS_D);
   php_request_shutdown(nil);
  except
    result := FAILURE;
  end;
end;

{$IFDEF PHP5}

{PHP 5 only}
function delphi_stream_reader (handle : pointer; buf : PAnsiChar; len : size_t; TSRMLS_DC : pointer) : size_t; cdecl;
var
 MS : TMemoryStream;
begin
  MS := TMemoryStream(handle);
  if MS =  nil then
    result := 0
     else
       try
         result := MS.Read(buf^, len);
       except
          result := 0;
       end;
end;

{PHP 5 only}
procedure delphi_stream_closer(handle : pointer; TSRMLS_DC : pointer); cdecl;
var
 MS : TMemoryStream;
begin
  MS := TMemoryStream(handle);
  if MS <> nil then
   try
     MS.Clear;
   except
   end;
end;

{$IFDEF PHP530}
function delphi_stream_fsizer(handle : pointer; TSRMLS_DC : pointer) : size_t; cdecl;
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream(handle);
  if MS <> nil then
   try
     result := MS.Size;
   except
     Result := 0;
   end
    else
      Result := 0;
end;
{$ELSE}
{$IFDEF PHP510}

{ PHP 5.10 and higher }
function delphi_stream_teller(handle : pointer; TSRMLS_DC : pointer) : longint; cdecl;
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream(handle);
  if MS <> nil then
   try
     result := MS.Size;
   except
     Result := 0;
   end
    else
      Result := 0;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}


{$IFDEF PHP4}
function ExecuteCode(RequestID : integer; ACode : PAnsiChar) : integer; stdcall;
var
  file_handle : zend_file_handle;
  TSRMLS_D : pointer;
 _handles : array[0..1] of THandle;
 _code : AnsiString;
 gl  : psapi_globals_struct;
begin
  if RequestID <= 0 then
   begin
     Result := REQUEST_ID_NOT_FOUND;
     Exit;
   end;

  if ACode = nil then
   begin
     Result := SCRIPT_IS_EMPTY;
     Exit;
   end;

  if pipe(@_handles, Length(ACode) + 512, 0) = -1 then
   begin
     Result := ERROR_CREATE_PIPE;
     Exit;
   end;

  _code := ACode;
  if Pos('<?', _Code) = 0 then
    _Code := '<? ' + _Code;
  if Pos('?>', _Code) = 0 then
    _Code := _Code + ' ?>';

  _write(_handles[1], @_Code[1], Length(_Code));
  close(_handles[1]);


  TSRMLS_D := ts_resource_ex(0, nil);
  file_handle._type := ZEND_HANDLE_FD;

  PG(TSRMLS_D)^.register_globals := true;
  gl := GetSAPIGlobals;
  TPHPInfoBlock(RequestID).FBuffer := '';
  gl^.server_context := pointer(RequestID);
  gl^.sapi_headers.http_response_code := 200;
  gl^.request_info.request_method := 'GET';

  file_handle.filename := '-';
  file_handle.opened_path := nil;
  file_handle.free_filename := 0;
  file_handle.handle.fd := _handles[0];
  php_request_startup(TSRMLS_D);

  result := php_execute_script(@file_handle, TSRMLS_D);
  close(_handles[0]);
  PrepareResult(RequestID, TSRMLS_D);
  php_request_shutdown(nil);
end;
{$ELSE}
function ExecuteCode(RequestID : integer; ACode : PAnsiChar) : integer; stdcall;
var
  file_handle : zend_file_handle;
  TSRMLS_D : pointer;
 _code : AnsiString;
 gl  : psapi_globals_struct;
  ZendStream : TZendStream;
begin
  if RequestID <= 0 then
   begin
     Result := REQUEST_ID_NOT_FOUND;
     Exit;
   end;

  if ACode = nil then
   begin
     Result := SCRIPT_IS_EMPTY;
     Exit;
   end;

  _code := ACode;
  if Pos('<?', _Code) = 0 then
    _Code := '<? ' + _Code;
  if Pos('?>', _Code) = 0 then
    _Code := _Code + ' ?>';


  ZeroMemory(@file_handle, sizeof(zend_file_handle));

  ZeroMemory(@ZendStream, sizeof(ZendStream));
  ZendStream.reader := delphi_stream_reader;
  ZendStream.closer := delphi_stream_closer;
 {$IFDEF PHP530}
 ZendStream.fsizer := delphi_stream_fsizer;
 {$ELSE}
 {$IFDEF PHP510}
 ZendStream.fteller := delphi_stream_teller;
 {$ENDIF}
 ZendStream.interactive := 0;
 {$ENDIF}


  TSRMLS_D := ts_resource_ex(0, nil);

  PG(TSRMLS_D)^.register_globals := true;
  gl := GetSAPIGlobals;
  TPHPInfoBlock(RequestID).FBuffer := '';
  gl^.server_context := pointer(RequestID);
  gl^.sapi_headers.http_response_code := 200;
  gl^.request_info.request_method := 'GET';

  ZendStream.handle := TPHPInfoBlock(RequestID).FVirtualStream;

  file_handle._type := ZEND_HANDLE_STREAM;
  file_handle.opened_path := nil;
  file_handle.filename := '-';
  file_handle.free_filename := 0;
  file_handle.handle.stream := ZendStream;

  TPHPInfoBlock(RequestID).FVirtualStream.Clear;
  TPHPInfoBlock(RequestID).FVirtualStream.Write(_code[1], Length(_code));
  TPHPInfoBlock(RequestID).FVirtualStream.Position := 0;

  php_request_startup(TSRMLS_D);

  result := php_execute_script(@file_handle, TSRMLS_D);

  PrepareResult(RequestID, TSRMLS_D);
  php_request_shutdown(nil);
end;
{$ENDIF}


procedure RegisterVariable(RequestID : integer; AName : PAnsiChar; AValue : PAnsiChar); stdcall;
begin
  try
    TPHPInfoBlock(RequestID).VarList.Add(AName + '=' + AValue);
  except
  end;
end;


function  GetResultText(RequestID : integer; Buffer : PAnsiChar; BufLen : integer) : integer; stdcall;
var
 L : integer;
begin
  if RequestID <= 0 then
   begin
     Result := REQUEST_ID_NOT_FOUND;
     Exit;
   end;

  try
    L := Length(TPHPInfoBlock(RequestID).FBuffer)+1;
    if L > BufLen then
     begin
       Result := L;
       Exit;
     end;

    StrLCopy(Buffer, PAnsiChar(TPHPInfoBlock(RequestID).FBuffer), BufLen -1);
    TPHPInfoBlock(RequestID).FBuffer := '';
    Result := 0;
  except
     Result := REQUEST_ID_NOT_FOUND;
  end;
end;

function  GetResultBufferSize(RequestID : integer) : integer;
var
 L : integer;
begin
  if RequestID <= 0 then
   begin
     Result := REQUEST_ID_NOT_FOUND;
     Exit;
   end;

  try
    L := Length(TPHPInfoBlock(RequestID).FBuffer)+1;
    Result := L;
  except
     Result := REQUEST_ID_NOT_FOUND;
  end;
end;

procedure SaveToFile(RequestID : integer; AFileName : PAnsiChar);
var
 L : integer;
 FS : TFileStream;
begin
  if RequestID <= 0 then
   begin
     Exit;
   end;

  try
    FS := TFileStream.Create(AFileName, fmCreate);
    try
     L := Length(TPHPInfoBlock(RequestID).FBuffer);
     FS.WriteBuffer(TPHPInfoBlock(RequestID).FBuffer[1], L);
    finally
      FS.Free;
    end;
  except
  end;
end;

function  GetVariable(RequestID : integer; AName : PAnsiChar; Buffer : PAnsiChar; BufLen : integer) : integer; stdcall;
var
 L  : integer;
 St : AnsiString;
begin
  if RequestID <= 0 then
   begin
     Result := REQUEST_ID_NOT_FOUND;
     Exit;
   end;

  try
    St := TPHPInfoBlock(RequestID).VarList.Values[AName];
    if St = '' then
     begin
       Result := VARIABLE_NOT_FOUND;
       Exit;
     end;
     L := Length(St)  +1 ;
     if L > BufLen then
      begin
        Result := L;
        Exit;
      end;

    StrLCopy(Buffer, PAnsiChar(St), BufLen -1);
    Result := 0;
  except
     Result := REQUEST_ID_NOT_FOUND;
  end;
end;

function  GetVariableSize(RequestID : integer; AName : PAnsiChar) : integer;
var
 L  : integer;
 St : AnsiString;
begin
  if RequestID <= 0 then
   begin
     Result := REQUEST_ID_NOT_FOUND;
     Exit;
   end;

  try
    St := TPHPInfoBlock(RequestID).VarList.Values[AName];
    if St = '' then
     begin
       Result := VARIABLE_NOT_FOUND;
       Exit;
     end;
     L := Length(St)  +1 ;
     Result := L;
  except
     Result := REQUEST_ID_NOT_FOUND;
  end;
end;

{ TPHPInfoBlock }

constructor TPHPInfoBlock.Create;
begin
  inherited Create;
  FBuffer := '';
  FVarList := TStringList.Create;
  {$IFDEF PHP5}
  FVirtualStream := TMemoryStream.Create;
  {$ENDIF}
end;

destructor TPHPInfoBlock.Destroy;
begin
  FBuffer := '';
  FVarList.Free;
  {$IFDEF PHP5}
  if FVirtualStream <> nil then
   FreeAndNil(FVirtualStream);
  {$ENDIF}
  inherited;
end;

procedure TPHPInfoBlock.SetVarList(AValue: TStringList);
begin
  FVarList.Assign(AValue);
end;


function  InitRequest : integer;
var
 InfoBlock : TPHPInfoBlock;
begin
  InfoBlock := TPHPInfoBlock.Create;
  Result := integer(InfoBlock);
end;

procedure DoneRequest(RequestID : integer);
begin
  if RequestID <= 0 then Exit;

  try
     TPHPInfoBlock(RequestID).FBuffer := '';
     TPHPInfoBlock(RequestID).Free;
     TPHPInfoBlock(RequestID) := nil;
  except
  end;
end;


procedure DLLExitProc(Reason: Integer); register;
begin
   case Reason of
     DLL_PROCESS_DETACH: StopEngine;
     DLL_THREAD_DETACH : ts_free_thread();
   end;
end;

procedure InitEngine;
var
 p : pointer;
begin

  if not PHPLoaded then
   LoadPHP;

  if PHPLoaded then
   begin
     try
       PrepareStartup;
       tsrm_startup(128, 1, TSRM_ERROR_LEVEL_CORE, 'TSRM.log');
       sapi_startup(@delphi_sapi_module);
       p := @php_delphi_module;
       php_module_startup(@delphi_sapi_module, p, 1);
       zend_alter_ini_entry('register_argc_argv', 19, '0', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);
       zend_alter_ini_entry('register_globals',   17, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);
       zend_alter_ini_entry('implicit_flush',     15, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);
       zend_alter_ini_entry('max_input_time',     15, '0', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);
       zend_alter_ini_entry('implicit_flush',     15, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);
     except
     end;
   end;

  IsMultiThread := true;
  DLLProc := @DLLExitProc;

end;

procedure StopEngine;
begin
  if PHPLoaded then
   begin
     try
       delphi_sapi_module.shutdown(@delphi_sapi_module);
       sapi_shutdown;
       tsrm_shutdown();
     except
     end;
   end;
end;


end.
