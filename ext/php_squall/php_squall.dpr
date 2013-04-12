library php_squall;

{$I PHP.INC}

uses
  Windows,
  SysUtils,
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  StrUtils,
  Squall,
  Variants;

{$R *.res}

type
    TArrayVariant = array of variant;
    TSoundVec = array[0..2] of Single;

function ToStrA(V: Variant): AnsiString;
begin
  Result := V;
end;

function ToStr(V: Variant): String;
begin
  Result := V;
end;

function ToPChar(V: Variant): PAnsiChar;
begin
  Result := PAnsiChar(ToStr(V));
end;

function toWChar(s: PAnsiChar): PWideChar;
  var
  ss: WideString;
  ss2: string;
begin
  ss2 := s;
  ss := ss2;
  Result := PWideChar(ss);
end;

function ZendToVariant(const Value: pppzval): Variant; overload;
  Var
  S: String;
begin
 case Value^^^._type of
 1: Result := Value^^^.value.lval;
 2: Result := Value^^^.value.dval;
 6: begin S := Value^^^.value.str.val; Result := S; end;
 4,5: Result := Null;
 end;
end;

function ZendToVariant(const Value: ppzval): Variant; overload;
  Var
  S: String;
begin
Result := Null;
 case Value^^._type of
 1: Result := Value^^.value.lval;
 2: Result := Value^^.value.dval;
 6: begin S := Value^^.value.str.val; Result := S; end;
 4,5: Result := Null;
 end;
end;

procedure HashToArray(HT: PHashTable; var AR: TArrayVariant); overload;
  Var
  Len,I: Integer;
  tmp : pppzval;
begin
 len := zend_hash_num_elements(HT);
 SetLength(AR,len);
 for i:=0 to len-1 do
  begin
    new(tmp);

    zend_hash_index_find(ht,i,tmp);

    AR[i] := ZendToVariant(tmp);
    freemem(tmp);
  end;
end;


procedure ArrayToHash(AR: Array of Variant; var HT: pzval); overload;
  Var
  I,Len: Integer;
    tmp : pppzval;
    pp: pzval_array;
begin
  _array_init(ht,nil,1);
  len := Length(AR);
  for i:=0 to len-1 do
   begin
     case VarType(AR[i]) of
     varInteger, varSmallint, varLongWord, 17: add_index_long(ht,i,AR[i]);
     varDouble,varSingle: add_index_double(ht,i,AR[i]);
     varBoolean: add_index_bool(ht,i,AR[I]);
     varEmpty: add_index_null(ht,i);
     varString: add_index_string(ht,i,PAnsiChar(ToStr(AR[I])),1);
     258: add_index_string(ht,i,PAnsiChar(AnsiString(ToStr(AR[I]))),1);
     end;
   end;
end;

procedure ArrayToHash(Keys,AR: Array of Variant; var HT: pzval); overload;
  Var
  I,Len: Integer;
    tmp : pppzval;
    pp: pzval_array;
    v: Variant;
    key: PAnsiChar;
    s: PAnsiChar;
begin
  _array_init(ht,nil,1);
  len := Length(AR);
  for i:=0 to len-1 do
   begin
     v := AR[I];
     key := PAnsiChar(ToStrA(keys[i]));
     s := PAnsiChar(ToStrA(v));
     case VarType(AR[i]) of
     varInteger, varSmallint, varLongWord, 17: add_assoc_long_ex(ht,ToPChar(Keys[i]),strlen(ToPChar(Keys[i]))+1,AR[i]);
     varDouble,varSingle: add_assoc_double_ex(ht,ToPChar(Keys[i]),strlen(ToPChar(Keys[i]))+1,AR[i]);
     varBoolean: add_assoc_bool_ex(ht,ToPChar(Keys[i]),strlen(ToPChar(Keys[i]))+1,AR[I]);
     varEmpty: add_assoc_null_ex(ht,ToPChar(Keys[i]),strlen(ToPChar(Keys[i]))+1);
     varString,258: add_assoc_string_ex(ht,key,strlen(key)+1,s,1);
     end;
   end;
end;


function rinit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

function rshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  SQUALL_Sample_UnloadAll();
  SQUALL_Free();
  Result := SUCCESS;
end;

procedure php_info_module(zend_module : Pzend_module_entry; TSRMLS_DC : pointer); cdecl;
begin
  php_info_print_table_start();
  php_info_print_table_row(2, PChar('php squall'), PChar('enabled'));
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


{$IFDEF PHP510}
procedure _SQUALL_Init(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Init(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
    pr: psquall_parameters_t;
    AR: TArrayVariant;
    param : pzval_array;
begin

   try
     ZVAL_LONG(return_value, SQUALL_Init(nil));
   except
       ZVAL_FALSE(return_value);
   end;
   dispose_pzval_array(param);

end;

{$IFDEF PHP510}
procedure _SQUALL_Free(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Free(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin

  if ht <> 0 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

   try
     SQUALL_Free;
     ZVAL_TRUE(return_value);
   except
       ZVAL_FALSE(return_value);
   end;

end;


{$IFDEF PHP510}
procedure _SQUALL_Sample_LoadFile(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_LoadFile(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      param : pzval_array;
      flag: cardinal;
begin

  if ht < 1 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
   end;

   flag := 0;
   if (param[1] <> nil) then
        flag := param[1]^.value.lval;

   try
     ZVAL_LONG(return_value,
                SQUALL_Sample_LoadFile(param[0]^.value.str.val, 0, nil));
   except
        ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(param);
end;


















{$IFDEF PHP510}
procedure _SQUALL_Sample_Play(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_Play(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      param : pzval_array;
      ID,LOOP,GROUP,START: Integer;
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

   ID   := param[0]^.value.lval;
   LOOP := param[1]^.value.lval;
   GROUP:= param[2]^.value.lval;
   START:= param[3]^.value.lval;


   try
     ZVAL_LONG(return_value, SQUALL_Sample_Play(ID,LOOP,GROUP,START));
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(param);
end;














{$IFDEF PHP510}
procedure _SQUALL_Sample_Stop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_Stop(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      param : pzval_array;
      ID: Integer;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   ID   := param[0]^.value.lval;

   try
     ZVAL_LONG(return_value, SQUALL_Sample_Stop(ID));
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(param);
end;











{$IFDEF PHP510}
procedure _SQUALL_Sample_Pause(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_Pause(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value, SQUALL_Sample_Pause(pr[0]^.value.lval,pr[1]^.value.lval));
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;






{$IFDEF PHP510}
procedure _SQUALL_Sample_SetDevice(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_SetDevice(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value, SQUALL_SetDevice( ZendToVariant(pr[0]) ) );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;


{$IFDEF PHP510}
procedure _SQUALL_Sample_GetDevice(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_GetDevice(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
     ZVAL_LONG(return_value, SQUALL_GetDevice())
end;



{$IFDEF PHP510}
procedure _SQUALL_Sample_Unload(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_Unload(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_TRUE(return_value);
     SQUALL_Sample_Unload(pr[0]^.value.lval);
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;









{$IFDEF PHP510}
procedure _SQUALL_Sample_UnloadAll(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_UnloadAll(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
   try
     ZVAL_TRUE(return_value);
     SQUALL_Sample_UnloadAll();
   except
       ZVAL_FALSE(return_value);
   end;
end;











{$IFDEF PHP510}
procedure _SQUALL_Sample_GetFileLength(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_GetFileLength(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_GetFileLength(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;












{$IFDEF PHP510}
procedure _SQUALL_Sample_GetFileLengthMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_GetFileLengthMs(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_GetFileLengthMs(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;














{$IFDEF PHP510}
procedure _SQUALL_Sample_GetFileFrequency(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_GetFileFrequency(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_GetFileFrequency(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;







{$IFDEF PHP510}
procedure _SQUALL_Sample_PlayEx(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_PlayEx(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
      ID,LOOP,GROUP,START,PRIORITY,VALUE,FREQ,PAN: Integer;
begin


  if ht <> 8 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    ID      := ZendToVariant(pr[0]);
    LOOP    := pr[1]^.value.lval;
    GROUP   := pr[2]^.value.lval;
    START   := pr[3]^.value.lval;
    PRIORITY:= pr[4]^.value.lval;
    VALUE   := pr[5]^.value.lval;
    FREQ    := pr[6]^.value.lval;
    PAN     := pr[7]^.value.lval;

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_PlayEx(ID,LOOP,GROUP,START,PRIORITY,VALUE,FREQ,PAN)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;











{$IFDEF PHP510}
procedure _SQUALL_Sample_SetDefault(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_SetDefault(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
      def: psquall_sample_default_t;
      AR: TArrayVariant;
      tmp : pppzval;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    HashToArray(pr[1]^.value.ht, AR);


    new(def);
    new(tmp);

    zend_hash_find(pr[1]^.value.ht,'sample_group_id',15, tmp);
    def^.SampleGroupID := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'priority',8, tmp);
    def^.Priority      := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'frequency',9, tmp);
    def^.Frequency     := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'volume',6, tmp);
    def^.Volume        := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'pan',3, tmp);
    def^.Pan           := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'min_dist',8, tmp);
    def^.MinDist       := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'max_dist',8, tmp);
    def^.MaxDist       := ZendToVariant(tmp);

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_SetDefault(pr[0]^.value.lval, def)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    FreeMem(def);
    dispose_pzval_array(pr);
end;



{$IFDEF PHP510}
procedure _SQUALL_Sample_GetDefault(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_GetDefault(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
      def: squall_sample_default_t;
      AR: TArrayVariant;
      res: integer;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;


    res := SQUALL_Sample_GetDefault(pr[0]^.value.lval, def);

    if res < 0 then
        ZVAL_LONG(return_value, res)
    else begin

        SetLength(AR,7);

        AR[0] := def.SampleGroupID;
        AR[1] := def.Priority;
        AR[2] := def.Frequency;
        AR[3] := def.Volume;
        AR[4] := def.Pan;
        AR[5] := def.MinDist;
        AR[6] := def.MaxDist;

        ArrayToHash(
                ['sample_group_id','priority','frequency','volume','pan','min_dist','max_dist'],
                AR,
                return_value
        );

    end;

    dispose_pzval_array(pr);
end;




{$IFDEF PHP510}
procedure _SQUALL_Sample_Play3D(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_Play3D(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
      ID,LOOP,GROUP,START,PRIORITY,VALUE,FREQ,PAN: Integer;
      s: string;
      POS, VEL: TArrayVariant;
      POSITION, VELOCITY: TSoundVec;
begin
  if ht <> 6 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    ID   := pr[0]^.value.lval;
    LOOP := pr[1]^.value.lval;
    GROUP:= pr[2]^.value.lval;
    START:= pr[3]^.value.lval;
    HashToArray(pr[4]^.value.ht, POS);
    HashToArray(pr[5]^.value.ht, VEL);


    POSITION[0] := POS[0];
    POSITION[1] := POS[1];
    POSITION[2] := POS[2];

    VELOCITY[0] := VEL[0];
    VELOCITY[1] := VEL[1];
    VELOCITY[2] := VEL[2];

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_Play3D(ID, LOOP, GROUP, START, @POSITION, @VELOCITY)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;














{$IFDEF PHP510}
procedure _SQUALL_Sample_Play3DEx(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Sample_Play3DEx(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
      ID,LOOP,GROUP,START,PRIORITY,VALUE,FREQ: Integer;
      min,max: single;
      s: string;
      POS, VEL: TArrayVariant;
      POSITION, VELOCITY: TSoundVec;
begin
  if ht <> 11 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    ID   := pr[0]^.value.lval;
    LOOP := pr[1]^.value.lval;
    GROUP:= pr[2]^.value.lval;
    START:= pr[3]^.value.lval;
    HashToArray(pr[4]^.value.ht, POS);
    HashToArray(pr[5]^.value.ht, VEL);

    PRIORITY := ZendToVariant(pr[6]);
    VALUE:= ZendToVariant(pr[7]);
    FREQ := ZendToVariant(pr[8]);
    min  := ZendToVariant(pr[9]);
    max  := ZendToVariant(pr[10]);


    POSITION[0] := POS[0];
    POSITION[1] := POS[1];
    POSITION[2] := POS[2];

    VELOCITY[0] := VEL[0];
    VELOCITY[1] := VEL[1];
    VELOCITY[2] := VEL[2];

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_Play3DEx(ID, LOOP, GROUP, START, @POSITION, @VELOCITY,
        PRIORITY,VALUE,FREQ,min,max)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;











{$IFDEF PHP510}
procedure _SQUALL_Channel_Start(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_Start(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_Start(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;








{$IFDEF PHP510}
procedure _SQUALL_Channel_Pause(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_Pause(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_Pause(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;










{$IFDEF PHP510}
procedure _SQUALL_Channel_Stop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_Stop(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_Stop(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;








{$IFDEF PHP510}
procedure _SQUALL_Channel_Status(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_Status(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_Status(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;









{$IFDEF PHP510}
procedure _SQUALL_Channel_SetVolume(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetVolume(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
      vol: Integer;
      channel: integer;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    channel := pr[0]^.value.lval;
    vol := pr[1]^.value.lval;

   try
     ZVAL_LONG(return_value,SQUALL_Channel_SetVolume(channel, vol));
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;











{$IFDEF PHP510}
procedure _SQUALL_Channel_GetVolume(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetVolume(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetVolume(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;










{$IFDEF PHP510}
procedure _SQUALL_Channel_SetFrequency(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetFrequency(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetFrequency(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;










{$IFDEF PHP510}
procedure _SQUALL_Channel_GetFrequency(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetFrequency(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetFrequency(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;






{$IFDEF PHP510}
procedure _SQUALL_Channel_SetPlayPosition(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetPlayPosition(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetPlayPosition(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;



{$IFDEF PHP510}
procedure _SQUALL_Channel_GetPlayPosition(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetPlayPosition(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetPlayPosition(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;



{$IFDEF PHP510}
procedure _SQUALL_Channel_SetPlayPositionMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetPlayPositionMs(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetPlayPositionMs(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;






{$IFDEF PHP510}
procedure _SQUALL_Channel_GetPlayPositionMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetPlayPositionMs(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetPlayPositionMs(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;








{$IFDEF PHP510}
procedure _SQUALL_Channel_SetFragment(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetFragment(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetFragment(pr[0]^.value.lval, pr[1]^.value.lval, pr[2]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;








{$IFDEF PHP510}
procedure _SQUALL_Channel_GetFragment(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetFragment(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
      s,e,r: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try

     r := SQUALL_Channel_GetFragment(pr[0]^.value.lval, s, e);

     if (r >= 0) then
        ArrayToHash(['start','end'],[s,e], return_value)
     else
        ZVAL_LONG(return_value,r);

   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;








{$IFDEF PHP510}
procedure _SQUALL_Channel_SetFragmentMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetFragmentMs(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetFragmentMs(pr[0]^.value.lval, pr[1]^.value.lval, pr[2]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;








{$IFDEF PHP510}
procedure _SQUALL_Channel_GetFragmentMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetFragmentMs(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
      s, e, r: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     r := SQUALL_Channel_GetFragment(pr[0]^.value.lval, s, e);

     if (r >= 0) then
        ArrayToHash(['start','end'],[s,e], return_value)
     else
        ZVAL_LONG(return_value,r);

   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;










{$IFDEF PHP510}
procedure _SQUALL_Channel_GetLength(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetLength(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetLength(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;




{$IFDEF PHP510}
procedure _SQUALL_Channel_GetLengthMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetLengthMs(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetLengthMs(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;









{$IFDEF PHP510}
procedure _SQUALL_Channel_SetPriority(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetPriority(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetPriority(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;











{$IFDEF PHP510}
procedure _SQUALL_Channel_GetPriority(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetPriority(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetPriority(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;









{$IFDEF PHP510}
procedure _SQUALL_Channel_SetLoop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetLoop(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetLoop(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;











{$IFDEF PHP510}
procedure _SQUALL_Channel_GetLoop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetLoop(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetLoop(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;













{$IFDEF PHP510}
procedure _SQUALL_Channel_SetPan(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_SetPan(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetPan(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;











{$IFDEF PHP510}
procedure _SQUALL_Channel_GetPan(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure _SQUALL_Channel_GetPan(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetPan(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;















var
  moduleEntry : Tzend_module_entry;
  module_entry_table : array[0..40]  of zend_function_entry;


function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;

  ModuleEntry.size := sizeOf(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zend_debug := 0;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.name :=  'squall';
  ModuleEntry.functions := nil;
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  ModuleEntry.version := '2.0';

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
  Module_entry_table[0].fname := 'SQUALL_Init';
  Module_entry_table[0].handler := @_SQUALL_Init;

  Module_entry_table[1].fname := 'SQUALL_Free';
  Module_entry_table[1].handler := @_SQUALL_Free;

  Module_entry_table[2].fname := 'SQUALL_Sample_LoadFile';
  Module_entry_table[2].handler := @_SQUALL_Sample_LoadFile;

  Module_entry_table[3].fname := 'SQUALL_Sample_Play';
  Module_entry_table[3].handler := @_SQUALL_Sample_Play;

  Module_entry_table[4].fname := 'SQUALL_Sample_Pause';
  Module_entry_table[4].handler := @_SQUALL_Sample_Pause;

  Module_entry_table[5].fname := 'SQUALL_Sample_Unload';
  Module_entry_table[5].handler := @_SQUALL_Sample_Unload;

  Module_entry_table[6].fname := 'SQUALL_Sample_UnloadAll';
  Module_entry_table[6].handler := @_SQUALL_Sample_UnloadAll;

  Module_entry_table[7].fname := 'SQUALL_Sample_GetFileLength';
  Module_entry_table[7].handler := @_SQUALL_Sample_GetFileLength;

  Module_entry_table[8].fname := 'SQUALL_Sample_GetFileLengthMs';
  Module_entry_table[8].handler := @_SQUALL_Sample_GetFileLengthMs;

  Module_entry_table[9].fname := 'SQUALL_Sample_GetFileFrequency';
  Module_entry_table[9].handler := @_SQUALL_Sample_GetFileFrequency;

  Module_entry_table[10].fname := 'SQUALL_Sample_PlayEx';
  Module_entry_table[10].handler := @_SQUALL_Sample_PlayEx;

  Module_entry_table[11].fname := 'SQUALL_Sample_Play3D';
  Module_entry_table[11].handler := @_SQUALL_Sample_Play3D;

  Module_entry_table[12].fname := 'SQUALL_Sample_GetDefault';
  Module_entry_table[12].handler := @_SQUALL_Sample_GetDefault;

  Module_entry_table[13].fname := 'SQUALL_Sample_SetDefault';
  Module_entry_table[13].handler := @_SQUALL_Sample_SetDefault;


  Module_entry_table[14].fname := 'SQUALL_Sample_GetDevice';
  Module_entry_table[14].handler := @_SQUALL_Sample_GetDevice;

  Module_entry_table[15].fname := 'SQUALL_Sample_SetDevice';
  Module_entry_table[15].handler := @_SQUALL_Sample_SetDevice;

  Module_entry_table[16].fname := 'SQUALL_Sample_Play3DEx';
  Module_entry_table[16].handler := @_SQUALL_Sample_Play3DEx;

  Module_entry_table[17].fname := 'SQUALL_Channel_Start';
  Module_entry_table[17].handler := @_SQUALL_Channel_Start;



  Module_entry_table[18].fname   := 'SQUALL_Channel_Pause';
  Module_entry_table[18].handler := @_SQUALL_Channel_Pause;

  Module_entry_table[19].fname   := 'SQUALL_Channel_Stop';
  Module_entry_table[19].handler := @_SQUALL_Channel_Stop;

  Module_entry_table[20].fname   := 'SQUALL_Channel_Status';
  Module_entry_table[20].handler := @_SQUALL_Channel_Status;

  Module_entry_table[21].fname   := 'SQUALL_Channel_SetVolume';
  Module_entry_table[21].handler := @_SQUALL_Channel_SetVolume;

  Module_entry_table[22].fname   := 'SQUALL_Channel_GetVolume';
  Module_entry_table[22].handler := @_SQUALL_Channel_GetVolume;

  Module_entry_table[23].fname   := 'SQUALL_Channel_SetFrequency';
  Module_entry_table[23].handler := @_SQUALL_Channel_SetFrequency;

  Module_entry_table[24].fname   := 'SQUALL_Channel_GetFrequency';
  Module_entry_table[24].handler := @_SQUALL_Channel_GetFrequency;

  Module_entry_table[25].fname   := 'SQUALL_Channel_SetPlayPosition';
  Module_entry_table[25].handler := @_SQUALL_Channel_SetPlayPosition;

  Module_entry_table[26].fname   := 'SQUALL_Channel_GetPlayPosition';
  Module_entry_table[26].handler := @_SQUALL_Channel_GetPlayPosition;

  Module_entry_table[27].fname   := 'SQUALL_Channel_SetPlayPositionMs';
  Module_entry_table[27].handler := @_SQUALL_Channel_SetPlayPositionMs;

  Module_entry_table[28].fname   := 'SQUALL_Channel_GetPlayPositionMs';
  Module_entry_table[28].handler := @_SQUALL_Channel_GetPlayPositionMs;

  Module_entry_table[29].fname   := 'SQUALL_Channel_SetFragment';
  Module_entry_table[29].handler := @_SQUALL_Channel_SetFragment;

  Module_entry_table[30].fname   := 'SQUALL_Channel_GetFragment';
  Module_entry_table[30].handler := @_SQUALL_Channel_GetFragment;

  Module_entry_table[31].fname   := 'SQUALL_Channel_GetFragmentMs';
  Module_entry_table[31].handler := @_SQUALL_Channel_GetFragmentMs;

  Module_entry_table[32].fname   := 'SQUALL_Channel_SetFragmentMs';
  Module_entry_table[32].handler := @_SQUALL_Channel_SetFragmentMs;

  Module_entry_table[33].fname   := 'SQUALL_Channel_GetLength';
  Module_entry_table[33].handler := @_SQUALL_Channel_GetLength;

  Module_entry_table[34].fname   := 'SQUALL_Channel_GetLengthMs';
  Module_entry_table[34].handler := @_SQUALL_Channel_GetLengthMs;

  Module_entry_table[35].fname   := 'SQUALL_Channel_SetPriority';
  Module_entry_table[35].handler := @_SQUALL_Channel_SetPriority;

  Module_entry_table[36].fname   := 'SQUALL_Channel_GetPriority';
  Module_entry_table[36].handler := @_SQUALL_Channel_GetPriority;

  Module_entry_table[37].fname   := 'SQUALL_Channel_SetLoop';
  Module_entry_table[37].handler := @_SQUALL_Channel_SetLoop;

  Module_entry_table[38].fname   := 'SQUALL_Channel_GetLoop';
  Module_entry_table[38].handler := @_SQUALL_Channel_GetLoop;

  Module_entry_table[39].fname   := 'SQUALL_Channel_SetPan';
  Module_entry_table[39].handler := @_SQUALL_Channel_SetPan;

  Module_entry_table[40].fname   := 'SQUALL_Channel_GetPan';
  Module_entry_table[40].handler := @_SQUALL_Channel_GetPan;




  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.
