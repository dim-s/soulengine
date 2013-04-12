library php_winres;

{$I PHP.INC}

uses
  Windows,
  SysUtils,
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  StrUtils,
  acWorkRes;

var
  ResName: PChar;

function toWChar(s: PAnsiChar): PWideChar;
  var
  ss: WideString;
  ss2: string;
begin
  ss2 := s;
  ss := ss2;
  Result := PWideChar(ss);
end;

procedure ChangeCompany(FileName: string; NewCompany: string; CompanyName:String = 'CompanyName');
const
  StringFileInfo = 'StringFileInfo';
var
  hUpdate : THandle;
  hExe : HMODULE;
  Data : WideString;
  ResInfo : HRSRC;
  ResData : HGLOBAL;
  Adr : Pointer;
  Size : DWORD;
  i0, i00, i, l, delta : integer;
  NewCompanyZ : string;
  LangID : word;
  function EnumFunc (hMod : HMODULE; lpszType : LPCTSTR; lpszName : LPTSTR; lParam : integer) : BOOL; stdcall;
  begin
    ResName := lpszName;
    Result := False;
  end;
begin
  hExe := LoadLibrary (PChar(FileName));
  if hExe = 0 then Exit;
  ResName := nil;
  EnumResourceNames (hExe, RT_VERSION, @EnumFunc, 0);
  ResInfo := FindResource (hExe, ResName, RT_VERSION);
  if ResInfo = 0 then Exit;
  ResData := LoadResource (hExe, ResInfo);  Adr := LockResource (ResData);
  Size := SizeofResource (hExe, ResInfo);  SetLength(Data, Size div 2);
  CopyMemory (@Data[1], Adr, Size); FreeResource (ResData);
  FreeLibrary (hExe); NewCompanyZ := NewCompany + #0;
  while (Length(NewCompanyZ) mod 2) <> 0 do NewCompanyZ := NewCompanyZ + #0;
  i00 := Pos(StringFileInfo, Data);
  if i00 = 0 then Exit; i0 := PosEx(CompanyName, Data, i00);
  if i0 = 0 then Exit; i := i0 + Length(CompanyName);
  while Data[i] = #0 do Inc(i);
  l := 0;
  while Data[i+l] <> #0 do Inc(l);
  while Data[i+l] = #0 do Inc(l);
  Delete (Data, i, l);  Insert (NewCompanyZ, Data, i);
  delta := (Length(NewCompanyZ) - l);
  Data[i0-3] := WideChar( Word(Data[i0-3]) + delta*2 ); // размер CompanyName
  Data[i0-2] := WideChar(Length(NewCompany)+1); // длина нового производителя
  Data[i00-3] := WideChar( Word(Data[i00-3]) + delta*2 ); // размер StringFileInfo
  i := i00+Length(StringFileInfo)+1;
  Data[i] := WideChar( Word(Data[i]) + delta*2 ); // размер языковой инфы
  Size := Length(Data)*2;  Data[1] := WideChar(Size);
  Inc(i, 3);  LangId := StrToInt('$' + Copy(Data, i, 4));
  hUpdate := BeginUpdateResource (PChar(FileName), False);
  UpdateResource (hUpdate, RT_VERSION, ResName, LangId, @Data[1], Size);
  EndUpdateResource (hUpdate, False);
end;

function rinit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

function rshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

procedure php_info_module(zend_module : Pzend_module_entry; TSRMLS_DC : pointer); cdecl;
begin
  php_info_print_table_start();
  php_info_print_table_row(2, PChar('php winres'), PChar('enabled'));
  php_info_print_table_end();
end;

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;



procedure begin_update_resource(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
    fileName: PWideChar;
    der: LongBool;

    param : pzval_array;
begin

  if ht <> 2 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
   end;

   fileName := toWChar(param[0]^.value.str.val);
   der      := longBool(param[1]^.value.lval);
   try
   ZVAL_LONG(return_value, BeginUpdateResourceW(fileName, der));
   except
       ZVAL_FALSE(return_value);
   end;

   dispose_pzval_array(param);

end;

procedure Load_Icon_Group_Resource(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
    update: cardinal;
    name, ico: PWideChar;
    lang: word;

    param : pzval_array;
begin

  if ht <> 4 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
   end;

   update := param[0]^.value.lval;
   name := toWChar(param[1]^.value.str.val);
   ico  := toWChar(param[3]^.value.str.val);
   lang := param[2]^.value.lval;

   try
     ZVAL_BOOL(return_value,LoadIconGroupResourceW(update,name,lang,ico));
   except
       ZVAL_FALSE(return_value);
   end;
   dispose_pzval_array(param);

end;

procedure end_update_resource(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
    update: cardinal;
    discard: longBool;

    param : pzval_array;
begin

  if ht <> 2 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
   end;

   update := param[0]^.value.lval;
   discard:= LongBool(param[1]^.value.lval);

   try
     ZVAL_BOOL(return_value,EndUpdateResourceW(update,discard));
   except
       ZVAL_FALSE(return_value);
   end;

   dispose_pzval_array(param);
end;



procedure ChangeICO(FileName:WideString; FileICO:WideString);
  Var
  hEXE:dword;
begin
hExe := BeginUpdateResourceW(PWideChar(FileName), False); // начинаю обновление иконки
  try
    LoadIconGroupResourceW(hExe, 'MAINICON', 0, PWideChar(FileICO)); // Устанавливаю иконку
  finally
     EndUpdateResourceW(hExe, False); // Обновление закончено
  end;
end;

procedure change_ico(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      param : pzval_array;
      s1, s2: string;
begin

  if ht <> 2 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
   end;

   s1 := Z_STRVAL(param[0]^);
   s2 := Z_STRVAL(param[1]^);

   try
     ChangeICO(s1, s2);
     ZVAL_TRUE(return_value);
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(param);
end;


procedure change_file_info(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      param : pzval_array;
begin

  if ht <> 3 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
   end;


   try
     ChangeCompany(Z_STRVAL(Param[0]^),
                   Z_STRVAL(param[2]^),
                   Z_STRVAL(param[1]^));
     
     ZVAL_TRUE(return_value);
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(param);
end;



var
  moduleEntry : Tzend_module_entry;
  module_entry_table : array[0..4]  of zend_function_entry;


function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;

   ModuleEntry.size := sizeOf(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zend_debug := 0;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.name :=  'winres';
  ModuleEntry.functions := nil;
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  ModuleEntry.version := '1.2';

  ModuleEntry.module_started := 0;
  ModuleEntry._type := MODULE_PERSISTENT;
  ModuleEntry.handle := nil;
  ModuleEntry.module_number := 0;
  {$IFDEF PHP530}
  {$IFNDEF COMPILER_VC9}
  ModuleEntry.build_id := strdup(PAnsiChar(ZEND_MODULE_BUILD_ID));
  {$ELSE}
  ModuleEntry.build_id := DupStr(PAnsiChar(ZEND_MODULE_BUILD_ID));
  {$ENDIF}
  {$ENDIF}

  // подключаем функции...
  Module_entry_table[0].fname := 'winres_begin_update_resource';
  Module_entry_table[0].handler := @begin_update_resource;

  Module_entry_table[1].fname := 'winres_load_icon_group_resource';
  Module_entry_table[1].handler := @load_icon_group_resource;

  Module_entry_table[2].fname := 'winres_end_update_resource';
  Module_entry_table[2].handler := @end_update_resource;

  Module_entry_table[3].fname := 'winres_change_ico';
  Module_entry_table[3].handler := @change_ico;

  Module_entry_table[4].fname := 'winres_change_file_info';
  Module_entry_table[4].handler := @change_file_info;


  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.
