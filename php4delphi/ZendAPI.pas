{*******************************************************}
{                     PHP4Delphi                        }
{               ZEND - Delphi interface                 }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{*******************************************************}
{$I PHP.INC}

{ $Id: ZENDAPI.pas,v 7.2 10/2009 delphi32 Exp $ }

unit zendAPI;

{$ifdef fpc}
   {$mode delphi}
{$endif}

interface

uses
  Windows, SysUtils, ZendTypes;

const
{$IFDEF PHP_DEBUG}
 {$IFDEF PHP5}
  PHPWin = 'php5ts_debug.dll';
  {$ELSE}
  PHPWin = 'php4ts_debug.dll';
  {$ENDIF}
{$ELSE}
 {$IFDEF PHP5}

    {$IFDEF LINUX}
         PHPWin = 'php5ts.so';
   {$ENDIF}
   {$IFDEF MSWINDOWS}
    PHPWin = 'php5ts.dll';
     {$ENDIF}

  {$ELSE}
  PHPWin = 'php4ts.dll';
  {$ENDIF}
{$ENDIF}

type
  EPHP4DelphiException = class(Exception)
   constructor Create(const Msg: AnsiString);
  end;

  align_test = record
  case Integer of
      1: (ptr: Pointer; );
      2: (dbl: Double; );
      3: (lng: Longint; );
  end;

const
  PLATFORM_ALIGNMENT = (SizeOf(align_test));

function AnsiFormat(const Format: AnsiString; const Args: array of const): AnsiString;

function  LoadZEND(const DllFilename: AnsiString = PHPWin) : boolean;

procedure UnloadZEND;
function  ZENDLoaded: boolean;

{Memory management functions}
var
  zend_strndup   : function(s: PAnsiChar; length: Integer): PAnsiChar; cdecl;
  _emalloc       : function(size: size_t; __zend_filename: PAnsiChar; __zend_lineno: uint; __zend_orig_filename: PAnsiChar; __zend_orig_line_no: uint): pointer; cdecl;
  _efree         : procedure(ptr: pointer; __zend_filename: PAnsiChar; __zend_lineno: uint; __zend_orig_filename: PAnsiChar; __zend_orig_line_no: uint); cdecl;
  _ecalloc       : function(nmemb: size_t; size: size_t; __zend_filename: PAnsiChar; __zend_lineno: uint; __zend_orig_filename: PAnsiChar; __zend_orig_line_no: uint): pointer; cdecl;
  _erealloc      : function(ptr: pointer; size: size_t; allow_failure: integer; __zend_filename: PAnsiChar; __zend_lineno: uint; __zend_orig_filename: PAnsiChar; __zend_orig_line_no: uint): pointer; cdecl;
  _estrdup       : function(const s: PAnsiChar; __zend_filename: PAnsiChar; __zend_lineno: uint; __zend_orig_filename: PAnsiChar; __zend_orig_line_no: uint): pointer; cdecl;
  _estrndup      : function(s: PAnsiChar; Len: Cardinal; __zend_filename: PAnsiChar; __zend_lineno: uint; __zend_orig_filename: PAnsiChar; __zend_orig_line_no: uint): PAnsiChar; cdecl;

function emalloc(size: size_t): pointer;
procedure efree(ptr: pointer);
function ecalloc(nmemb: size_t; size: size_t): pointer;
function erealloc(ptr: pointer; size: size_t; allow_failure: integer): pointer;
function estrdup(const s: PAnsiChar): PAnsiChar;
function estrndup(s: PAnsiChar; len: Cardinal): PAnsiChar;
function STR_EMPTY_ALLOC : PAnsiChar;

var
  zend_set_memory_limit                           : function(memory_limit: uint): integer; cdecl;
  start_memory_manager                            : procedure(TSRMLS_D: pointer); cdecl;
  shutdown_memory_manager                         : procedure(silent: integer; clean_cache: integer; TSRMLS_DC: pointer); cdecl;


  { startup/shutdown }

var

  zend_register_resource       : function (rsrc_result : pzval;  rsrc_pointer : pointer;  rsrc_type : integer) : integer; cdecl;
  zend_fetch_resource          : function (passed_id  : ppzval; TSRMLS_DC : pointer; default_id : integer;  resource_type_name : PAnsiChar;  found_resource_type : pointer; num_resource_types: integer; resource_type: integer) : pointer; cdecl;
  zend_list_insert             : function (ptr : pointer; _type: integer) : integer; cdecl;
  _zend_list_addref            : function (id  : integer; TSRMLS_DC : pointer) : integer; cdecl;
  _zend_list_delete            : function (id : integer; TSRMLS_DC : pointer) : integer; cdecl;
  _zend_list_find              : function (id : integer; _type : pointer; TSRMLS_DC : pointer) : pointer; cdecl;
  zend_rsrc_list_get_rsrc_type : function (resource: integer; TSRMLS_DC : pointer) : PAnsiChar; cdecl;
  zend_fetch_list_dtor_id      : function (type_name : PAnsiChar) : integer; cdecl;
  zend_register_list_destructors_ex : function (ld : pointer; pld : pointer; type_name : PAnsiChar; module_number : integer) : integer; cdecl;



{disable functions}

var
  zend_disable_function : function(function_name : PAnsiChar; function_name_length : uint; TSRMLS_DC : pointer) : integer; cdecl;
  zend_disable_class   : function(class_name : PAnsiChar; class_name_length : uint; TSRMLS_DC : pointer) : integer; cdecl;


{$IFDEF PHP4}
  zend_hash_add_or_update  : function(ht: PHashTable; arKey: PAnsiChar;
    nKeyLength: uint; pData: Pointer; nDataSize: uint; pDest: Pointer;
    flag: Integer): Integer; cdecl;
{$ELSE}
var
 _zend_hash_add_or_update : function (ht : PHashTable; arKey : PAnsiChar;
    nKeyLength : uint; pData : pointer; nDataSize : uint; pDes : pointer;
    flag : integer; __zend_filename: PAnsiChar; __zend_lineno: uint) : integer; cdecl;

 function zend_hash_add_or_update(ht : PHashTable; arKey : PAnsiChar;
    nKeyLength : uint; pData : pointer; nDataSize : uint; pDes : pointer;
    flag : integer) : integer; cdecl;

{$ENDIF}

function zend_hash_add(ht : PHashTable; arKey : PAnsiChar; nKeyLength : uint; pData : pointer; nDataSize : uint; pDest : pointer) : integer; cdecl;

var
 {$IFDEF PHP4}
  zend_hash_init                                  : function(ht: PHashTable; nSize: uint;
    pHashFunction: pointer; pDestructor: pointer;
    persistent: Integer): Integer; cdecl;

  zend_hash_init_ex                               : function(ht: PHashTable; nSize: uint;
    pHashFunction: pointer; pDestructor: pointer;
    persistent: Integer; bApplyProtection: boolean): Integer; cdecl;


  zend_hash_quick_add_or_update                   : function(ht: PHashTable; arKey: PAnsiChar;
    nKeyLength: uint; h: ulong; pData: Pointer; nDataSize: uint;
    pDest: Pointer; flag: Integer): Integer; cdecl;

  zend_hash_index_update_or_next_insert           : function(ht: PHashTable; h: ulong;
    pData: Pointer; nDataSize: uint; pDest: Pointer; flag: Integer): Integer; cdecl;

  zend_hash_merge                                 : procedure(target: PHashTable; source: PHashTable;
    pCopyConstructor: pointer; tmp: Pointer; size: uint; overwrite: Integer); cdecl;

 {$ELSE}

 _zend_hash_init : function (ht : PHashTable; nSize : uint;
   pHashFunction : pointer; pDestructor : pointer; persistent: zend_bool;
   __zend_filename: PAnsiChar; __zend_lineno: uint) : integer; cdecl;
 _zend_hash_init_ex : function (ht : PHashTable;  nSize : uint;
   pHashFunction : pointer; pDestructor : pointer;  persistent : zend_bool;
   bApplyProtection : zend_bool; __zend_filename: PAnsiChar; __zend_lineno: uint): integer; cdecl;

 function zend_hash_init (ht : PHashTable; nSize : uint; pHashFunction : pointer;
   pDestructor : pointer; persistent: zend_bool) : integer; cdecl;
 function zend_hash_init_ex (ht : PHashTable;  nSize : uint; pHashFunction : pointer;
 pDestructor : pointer;  persistent : zend_bool;  bApplyProtection : zend_bool): integer; cdecl;


{$ENDIF}

var
  zend_hash_destroy                               : procedure(ht: PHashTable); cdecl;
  zend_hash_clean                                 : procedure(ht: PHashTable); cdecl;

  { additions/updates/changes }




  zend_hash_add_empty_element                     : function(ht: PHashTable; arKey: PAnsiChar;
    nKeyLength: uint): Integer; cdecl;




var
  zend_hash_graceful_destroy                      : procedure(ht: PHashTable); cdecl;
  zend_hash_graceful_reverse_destroy              : zend_hash_graceful_reverse_destroy_t;

  zend_hash_apply                                 : procedure(ht: PHashTable; apply_func: pointer; TSRMLS_DC: Pointer); cdecl;

  zend_hash_apply_with_argument                   : procedure(ht: PHashTable;
    apply_func: pointer; _noname1: Pointer; TSRMLS_DC: Pointer); cdecl;

  { This function should be used with special care (in other words,
   * it should usually not be used).  When used with the ZEND_HASH_APPLY_STOP
   * return value, it assumes things about the order of the elements in the hash.
   * Also, it does not provide the same kind of reentrancy protection that
   * the standard apply functions do.
   }

  zend_hash_reverse_apply                         : procedure(ht: PHashTable;
    apply_func: pointer; TSRMLS_DC: Pointer); cdecl;

  { Deletes }

  zend_hash_del_key_or_index                      : function(ht: PHashTable; arKey: PAnsiChar;
    nKeyLength: uint; h: ulong; flag: Integer): Integer; cdecl;

  zend_get_hash_value                             : function(ht: PHashTable; arKey: PAnsiChar;
    nKeyLength: uint): Longint; cdecl;

  { Data retreival }

  zend_hash_find                                  : function(ht: PHashTable; arKey: PAnsiChar; nKeyLength: uint;
    pData: Pointer): Integer; cdecl;

  zend_hash_quick_find                            : function(ht: PHashTable; arKey: PAnsiChar;
    nKeyLength: uint; h: ulong; pData: Pointer): Integer; cdecl;

  zend_hash_index_find                            : function(ht: PHashTable; h: ulong; pData: Pointer): Integer; cdecl;

  { Misc }

  zend_hash_exists                                : function(ht: PHashTable; arKey: PAnsiChar; nKeyLength: uint): Integer; cdecl;

  zend_hash_index_exists                          : function(ht: PHashTable; h: ulong): Integer; cdecl;

  zend_hash_next_free_element                     : function(ht: PHashTable): Longint; cdecl;

  { traversing }

  zend_hash_move_forward_ex                       : function(ht: PHashTable; pos: HashPosition): Integer; cdecl;

  zend_hash_move_backwards_ex                     : function(ht: PHashTable; pos: HashPosition): Integer; cdecl;

  zend_hash_get_current_key_ex                    : function(ht: PHashTable;
    var str_index: PAnsiChar; var str_length: uint; var num_index: ulong;
    duplicate: boolean; pos: HashPosition): Integer; cdecl;

  zend_hash_get_current_key_type_ex               : function(ht: PHashTable; pos: HashPosition): Integer; cdecl;

  zend_hash_get_current_data_ex                   : function(ht: PHashTable; pData: Pointer; pos: HashPosition): Integer; cdecl;

  zend_hash_internal_pointer_reset_ex             : procedure(ht: PHashTable; pos: HashPosition); cdecl;

  zend_hash_internal_pointer_end_ex               : procedure(ht: PHashTable; pos: HashPosition); cdecl;

  { Copying, merging and sorting }

  zend_hash_copy                                  : procedure(target: PHashTable; source: PHashTable;
    pCopyConstructor: pointer; tmp: Pointer; size: uint); cdecl;


  zend_hash_sort                                  : function(ht: PHashTable; sort_func: pointer;
    compare_func: pointer; renumber: Integer; TSRMLS_DC: Pointer): Integer; cdecl;

  zend_hash_compare                               : function(ht1: PHashTable; ht2: PHashTable;
    compar: pointer; ordered: boolean; TSRMLS_DC: Pointer): Integer; cdecl;

  zend_hash_minmax                                : function(ht: PHashTable; compar: pointer;
    flag: Integer; pData: Pointer; TSRMLS_DC: Pointer): Integer; cdecl;

  zend_hash_num_elements                          : function(ht: PHashTable): Integer; cdecl;

  zend_hash_rehash                                : function(ht: PHashTable): Integer; cdecl;

  zend_hash_func                                  : function(arKey: PAnsiChar; nKeyLength: uint): Longint; cdecl;


function zend_hash_get_current_data(ht: PHashTable; pData: Pointer): Integer; cdecl;
procedure zend_hash_internal_pointer_reset(ht: PHashTable); cdecl;


var
  zend_get_constant                               : function(name: PAnsiChar; name_len: uint; var result: zval;
    TSRMLS_DC: Pointer): Integer; cdecl;

  zend_register_long_constant                     : procedure(name: PAnsiChar; name_len: uint;
    lval: Longint; flags: Integer; module_number: Integer; TSRMLS_DC: Pointer); cdecl;

  zend_register_double_constant                   : procedure(name: PAnsiChar; name_len: uint; dval: Double; flags: Integer; module_number: Integer;
    TSRMLS_DC: Pointer); cdecl;

  zend_register_string_constant                   : procedure(name: PAnsiChar; name_len: uint; strval: PAnsiChar; flags: Integer; module_number: Integer;
    TSRMLS_DC: Pointer); cdecl;

  zend_register_stringl_constant                  : procedure(name: PAnsiChar; name_len: uint;
    strval: PAnsiChar; strlen: uint; flags: Integer; module_number: Integer;
    TSRMLS_DC: Pointer); cdecl;

  zend_register_constant                          : function(var c: zend_constant; TSRMLS_DC: Pointer): Integer; cdecl;

  zend_register_auto_global : function(name: PAnsiChar; name_len: uint; callback: Pointer; TSRMLS_DC: Pointer): Integer; cdecl;

procedure REGISTER_MAIN_LONG_CONSTANT(name: PAnsiChar; lval: longint; flags: integer; TSRMLS_DC: Pointer);
procedure REGISTER_MAIN_DOUBLE_CONSTANT(name: PAnsiChar; dval: double; flags: integer; TSRMLS_DC: Pointer);
procedure REGISTER_MAIN_STRING_CONSTANT(name: PAnsiChar; str: PAnsiChar; flags: integer; TSRMLS_DC: Pointer);
procedure REGISTER_MAIN_STRINGL_CONSTANT(name: PAnsiChar; str: PAnsiChar; len: uint; flags: integer; TSRMLS_DC: Pointer);


var
  tsrm_startup                                    : function(expected_threads: integer;
    expected_resources: integer; debug_level: integer; debug_filename: PAnsiChar): integer; cdecl;

  ts_allocate_id                                  : function(rsrc_id: pts_rsrc_id; size: size_t; ctor: pointer; dtor: pointer): ts_rsrc_id; cdecl;
  // deallocates all occurrences of a given id
  ts_free_id                                      : procedure(id: ts_rsrc_id); cdecl;

  tsrm_shutdown                                   : procedure(); cdecl;
  ts_resource_ex                                  : function(id: integer; p: pointer): pointer; cdecl;
  ts_free_thread                                  : procedure; cdecl;

  zend_error                                      : procedure(ErrType: integer; ErrText: PAnsiChar); cdecl;
  zend_error_cb                                   : procedure; cdecl;

  zend_eval_string                                : function(str: PAnsiChar; val: pointer; strname: PAnsiChar; tsrm: pointer): integer; cdecl;
  zend_make_compiled_string_description           : function(a: PAnsiChar; tsrm: pointer): PAnsiChar; cdecl;

  {$IFDEF PHP4}
  _zval_copy_ctor                                 : function(val: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint): integer; cdecl;
  _zval_dtor                                      : procedure(val: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint); cdecl;
  {$ELSE}
  _zval_copy_ctor_func                            : procedure(val: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint); cdecl;
  _zval_dtor_func                                 : procedure(val: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint); cdecl;
  _zval_ptr_dtor: procedure(val: ppzval;  __zend_filename: PAnsiChar); cdecl;
  procedure  _zval_copy_ctor (val: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint); cdecl;
  procedure _zval_dtor(val: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint); cdecl;
  {$ENDIF}

var
  zend_print_variable                             : function(val: pzval): integer; cdecl;


  zend_get_compiled_filename : function(TSRMLS_DC: Pointer): PAnsiChar; cdecl;
  zend_get_compiled_lineno   : function(TSRMLS_DC: Pointer): integer; cdecl;


{$IFDEF PHP4}
function zval_copy_ctor(val : pzval) : integer;
{$ENDIF}

function ts_resource(id : integer) : pointer;
function tsrmls_fetch : pointer;

procedure zenderror(Error : PAnsiChar);

var
  zend_stack_init                                 : function(stack: Pzend_stack): Integer; cdecl;

  zend_stack_push                                 : function(stack: Pzend_stack; element: Pointer; size: Integer): Integer; cdecl;

  zend_stack_top                                  : function(stack: Pzend_stack; element: Pointer): Integer; cdecl;

  zend_stack_del_top                              : function(stack: Pzend_stack): Integer; cdecl;

  zend_stack_int_top                              : function(stack: Pzend_stack): Integer; cdecl;

  zend_stack_is_empty                             : function(stack: Pzend_stack): Integer; cdecl;

  zend_stack_destroy                              : function(stack: Pzend_stack): Integer; cdecl;

  zend_stack_base                                 : function(stack: Pzend_stack): Pointer; cdecl;

  zend_stack_count                                : function(stack: Pzend_stack): Integer; cdecl;

  zend_stack_apply                                : procedure(stack: Pzend_stack; _type: Integer; apply_function: Integer); cdecl;

  zend_stack_apply_with_argument                  : procedure(stack: Pzend_stack; _type: Integer; apply_function: Integer; arg: Pointer); cdecl;


  //zend_operators.h

var
  _convert_to_string                              : procedure(op: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint); cdecl;

procedure convert_to_string(op: pzval);

var
  add_function                                    : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  sub_function                                    : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  mul_function                                    : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  div_function                                    : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  mod_function                                    : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  boolean_xor_function                            : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  boolean_not_function                            : function(_result: Pzval; op1: Pzval): Integer; cdecl;

  bitwise_not_function                            : function(_result: Pzval; op1: Pzval): Integer; cdecl;

  bitwise_or_function                             : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  bitwise_and_function                            : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  bitwise_xor_function                            : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  shift_left_function                             : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  shift_right_function                            : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  concat_function                                 : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  is_equal_function                               : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  is_identical_function                           : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  is_not_identical_function                       : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  is_not_equal_function                           : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  is_smaller_function                             : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  is_smaller_or_equal_function                    : function(_result: Pzval; op1: Pzval; var op2: zval; TSRMLS_DC: Pointer): Integer; cdecl;

  increment_function                              : function(op1: Pzval): Integer; cdecl;

  decrement_function                              : function(op2: Pzval): Integer; cdecl;

  convert_scalar_to_number                        : procedure(op: Pzval; TSRMLS_DC: Pointer); cdecl;

  convert_to_long                                 : procedure(op: Pzval); cdecl;

  convert_to_double                               : procedure(op: Pzval); cdecl;

  convert_to_long_base                            : procedure(op: Pzval; base: Integer); cdecl;

  convert_to_null                                 : procedure(op: Pzval); cdecl;

  convert_to_boolean                              : procedure(op: Pzval); cdecl;

  convert_to_array                                : procedure(op: Pzval); cdecl;

  convert_to_object                               : procedure(op: Pzval); cdecl;

  add_char_to_string                              : function(_result: Pzval; op1: Pzval; op2: Pzval): Integer; cdecl;

  add_string_to_string                            : function(_result: Pzval; op1: Pzval; op2: Pzval): Integer; cdecl;

  zend_string_to_double                           : function(number: PAnsiChar; length: zend_uint): Double; cdecl;

  zval_is_true                                    : function(op: Pzval): Integer; cdecl;

  compare_function                                : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  numeric_compare_function                        : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  string_compare_function                         : function(_result: Pzval; op1: Pzval; op2: Pzval; TSRMLS_DC: Pointer): Integer; cdecl;

  zend_str_tolower                                : procedure(str: PAnsiChar; length: Integer); cdecl;

  zend_binary_zval_strcmp                         : function(s1: Pzval; s2: Pzval): Integer; cdecl;

  zend_binary_zval_strncmp                        : function(s1: Pzval; s2: Pzval; s3: Pzval): Integer; cdecl;

  zend_binary_zval_strcasecmp                     : function(s1: Pzval; s2: Pzval): Integer; cdecl;

  zend_binary_zval_strncasecmp                    : function(s1: Pzval; s2: Pzval; s3: Pzval): Integer; cdecl;

  zend_binary_strcmp                              : function(s1: PAnsiChar; len1: uint; s2: PAnsiChar; len2: uint): Integer; cdecl;

  zend_binary_strncmp                             : function(s1: PAnsiChar; len1: uint; s2: PAnsiChar; len2: uint; length: uint): Integer; cdecl;

  zend_binary_strcasecmp                          : function(s1: PAnsiChar; len1: uint; s2: PAnsiChar; len2: uint): Integer; cdecl;

  zend_binary_strncasecmp                         : function(s1: PAnsiChar; len1: uint; s2: PAnsiChar; len2: uint; length: uint): Integer; cdecl;

  zendi_smart_strcmp                              : procedure(_result: zval; s1: Pzval; s2: Pzval); cdecl;

  zend_compare_symbol_tables                      : procedure(_result: Pzval; ht1: PHashTable; ht2: PHashTable; TSRMLS_DC: Pointer); cdecl;

  zend_compare_arrays                             : procedure(_result: zval; a1: Pzval; a2: Pzval; TSRMLS_DC: Pointer); cdecl;

  zend_compare_objects                            : procedure(_result: Pzval; o1: Pzval; o2: Pzval; TSRMLS_DC: Pointer); cdecl;

  zend_atoi                                       : function(str: PAnsiChar; str_len: Integer): Integer; cdecl;

  //zend_execute.h
  get_active_function_name                        : function(TSRMLS_D: pointer): PAnsiChar; cdecl;

  zend_get_executed_filename                      : function(TSRMLS_D: pointer): PAnsiChar; cdecl;

  zend_set_timeout                                : procedure(seconds: Longint); cdecl;

  zend_unset_timeout                              : procedure(TSRMLS_D: pointer); cdecl;

  zend_timeout                                    : procedure(dummy: Integer); cdecl;


var
  zend_highlight                                  : procedure(syntax_highlighter_ini: Pzend_syntax_highlighter_ini; TSRMLS_DC: Pointer); cdecl;

  zend_strip                                      : procedure(TSRMLS_D: pointer); cdecl;

  highlight_file                                  : function(filename: PAnsiChar; syntax_highlighter_ini: Pzend_syntax_highlighter_ini; TSRMLS_DC: Pointer): Integer; cdecl;

  highlight_string                                : function(str: Pzval; syntax_highlighter_ini: Pzend_syntax_highlighter_ini; str_name: PAnsiChar; TSRMLS_DC: Pointer): Integer; cdecl;

  zend_html_putc                                  : procedure(c: AnsiChar); cdecl;

  zend_html_puts                                  : procedure(s: PAnsiChar; len: uint; TSRMLS_DC: Pointer); cdecl;

  zend_indent                                     : procedure; cdecl;

  ZendGetParameters                               : function: integer; cdecl;

function zend_get_parameters_ex(number: integer; var Params: pzval_array): integer;
function zend_get_parameters_my(number: integer; var Params: pzval_array; TSRMLS_DC: Pointer): integer;

function zend_get_parameters(ht: integer; param_count: integer; Params: array of ppzval): integer;

var
  _zend_get_parameters_array_ex : function(param_count: integer; argument_array: pppzval; TSRMLS_CC: pointer): integer; cdecl;

procedure dispose_pzval_array(Params: pzval_array);

var
  zend_ini_refresh_caches                         : procedure(stage: Integer; TSRMLS_DC: Pointer); cdecl;


var
  _zend_bailout                                   : procedure (filename : PAnsiChar; lineno : uint); cdecl;

  zend_alter_ini_entry                            : function(name: PAnsiChar; name_length: uint; new_value: PAnsiChar; new_value_length: uint; modify_type: Integer; stage: Integer): Integer; cdecl;

  zend_restore_ini_entry                          : function(name: PAnsiChar; name_length: uint; stage: Integer): Integer; cdecl;

  zend_ini_long                                   : function(name: PAnsiChar; name_length: uint; orig: Integer): Longint; cdecl;

  zend_ini_double                                 : function(name: PAnsiChar; name_length: uint; orig: Integer): Double; cdecl;

  zend_ini_string                                 : function(name: PAnsiChar; name_length: uint; orig: Integer): PAnsiChar; cdecl;

  compile_string                                  : function(source_string: pzval; filename: PAnsiChar; TSRMLS_DC: Pointer): pointer; cdecl;

  execute                                         : procedure(op_array: pointer; TSRMLS_DC: Pointer); cdecl;

  zend_wrong_param_count                          : procedure(TSRMLS_D: pointer); cdecl;

  {$IFDEF PHP4}
  add_property_long_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint; l: longint): integer; cdecl;
  {$ELSE}
  add_property_long_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint; l: longint; TSRMLS_DC : pointer): integer; cdecl;
  {$ENDIF}

  {$IFDEF PHP4}
  add_property_null_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint): integer; cdecl;
  add_property_bool_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint; b: integer): integer; cdecl;
  add_property_resource_ex                        : function(arg: pzval; key: PAnsiChar; key_len: uint; r: integer): integer; cdecl;
  add_property_double_ex                          : function(arg: pzval; key: PAnsiChar; key_len: uint; d: double): integer; cdecl;
  add_property_string_ex                          : function(arg: pzval; key: PAnsiChar; key_len: uint; str: PAnsiChar; duplicate: integer): integer; cdecl;
  add_property_stringl_ex                         : function(arg: pzval; key: PAnsiChar; key_len: uint; str: PAnsiChar; len: uint; duplicate: integer): integer; cdecl;
  add_property_zval_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint; value: pzval): integer; cdecl;
  {$ELSE}
  add_property_null_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint; TSRMLS_DC: Pointer): integer; cdecl;
  add_property_bool_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint; b: integer; TSRMLS_DC: Pointer): integer; cdecl;
  add_property_resource_ex                        : function(arg: pzval; key: PAnsiChar; key_len: uint; r: integer; TSRMLS_DC: Pointer): integer; cdecl;
  add_property_double_ex                          : function(arg: pzval; key: PAnsiChar; key_len: uint; d: double; TSRMLS_DC: Pointer): integer; cdecl;
  add_property_string_ex                          : function(arg: pzval; key: PAnsiChar; key_len: uint; str: PAnsiChar; duplicate: integer; TSRMLS_DC: Pointer): integer; cdecl;
  add_property_stringl_ex                         : function(arg: pzval; key: PAnsiChar; key_len: uint; str: PAnsiChar; len: uint; duplicate: integer; TSRMLS_DC: Pointer): integer; cdecl;
  add_property_zval_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint; value: pzval; TSRMLS_DC: Pointer): integer; cdecl;
  {$ENDIF}


  call_user_function : function(function_table: PHashTable; object_pp: pzval;
                         function_name: pzval; return_ptr: pzval; param_count: zend_uint; params: pzval_array_ex;
                          TSRMLS_DC: Pointer): integer; cdecl;

  call_user_function_ex : function(function_table: PHashTable; object_pp: pzval;
                         function_name: pzval; return_ptr_ptr: ppzval; param_count: zend_uint;
                         params: pzval_array;
                         no_separation: zend_uint; symbol_table: PHashTable;
                          TSRMLS_DC: Pointer): integer; cdecl;

{
call_user_function_ex(HashTable *function_table,
                      zval **object_pp,
                      zval *function_name,
                      zval **retval_ptr_ptr,
                      zend_uint param_count,
                      zval **params[],
                      int no_separation,
                      HashTable *symbol_table
                      TSRMLS_DC);
}


  add_assoc_long_ex                               : function(arg: pzval; key: PAnsiChar; key_len: uint; n: longint): integer; cdecl;
  add_assoc_null_ex                               : function(arg: pzval; key: PAnsiChar; key_len: uint): integer; cdecl;
  add_assoc_bool_ex                               : function(arg: pzval; key: PAnsiChar; key_len: uint; b: integer): integer; cdecl;
  add_assoc_resource_ex                           : function(arg: pzval; key: PAnsiChar; key_len: uint; r: integer): integer; cdecl;
  add_assoc_double_ex                             : function(arg: pzval; key: PAnsiChar; key_len: uint; d: double): integer; cdecl;
  add_assoc_string_ex                             : function(arg: pzval; key: PAnsiChar; key_len: uint; str: PAnsiChar; duplicate: integer): integer; cdecl;
  add_assoc_stringl_ex                            : function(arg: pzval; key: PAnsiChar; key_len: uint; str: PAnsiChar; len: uint; duplicate: integer): integer; cdecl;
  add_assoc_zval_ex                               : function(arg: pzval; key: PAnsiChar; key_len: uint; value: pzval): integer; cdecl;

  add_index_long                                  : function(arg: pzval; idx: uint; n: longint): integer; cdecl;
  add_index_null                                  : function(arg: pzval; idx: uint): integer; cdecl;
  add_index_bool                                  : function(arg: pzval; idx: uint; b: integer): integer; cdecl;
  add_index_resource                              : function(arg: pzval; idx: uint; r: integer): integer; cdecl;
  add_index_double                                : function(arg: pzval; idx: uint; d: double): integer; cdecl;
  add_index_string                                : function(arg: pzval; idx: uint; str: PAnsiChar; duplicate: integer): integer; cdecl;
  add_index_stringl                               : function(arg: pzval; idx: uint; str: PAnsiChar; len: uint; duplicate: integer): integer; cdecl;
  add_index_zval                                  : function(arg: pzval; index: uint; value: pzval): integer; cdecl;

  add_next_index_long                             : function(arg: pzval; n: longint): integer; cdecl;
  add_next_index_null                             : function(arg: pzval): integer; cdecl;
  add_next_index_bool                             : function(arg: pzval; b: integer): integer; cdecl;
  add_next_index_resource                         : function(arg: pzval; r: integer): integer; cdecl;
  add_next_index_double                           : function(arg: pzval; d: double): integer; cdecl;
  add_next_index_string                           : function(arg: pzval; str: PAnsiChar; duplicate: integer): integer; cdecl;
  add_next_index_stringl                          : function(arg: pzval; str: PAnsiChar; len: uint; duplicate: integer): integer; cdecl;
  add_next_index_zval                             : function(arg: pzval; value: pzval): integer; cdecl;

  add_get_assoc_string_ex                         : function(arg: pzval; key: PAnsiChar; key_len: uint; str: PAnsiChar; dest: pointer; duplicate: integer): integer; cdecl;
  add_get_assoc_stringl_ex                        : function(arg: pzval; key: PAnsiChar; key_len: uint; str: PAnsiChar; len: uint; dest: pointer; duplicate: integer): integer; cdecl;

  add_get_index_long                              : function(arg: pzval; idx: uint; l: longint; dest: pointer): integer; cdecl;
  add_get_index_double                            : function(arg: pzval; idx: uint; d: double; dest: pointer): integer; cdecl;
  add_get_index_string                            : function(arg: pzval; idx: uint; str: PAnsiChar; dest: pointer; duplicate: integer): integer; cdecl;
  add_get_index_stringl                           : function(arg: pzval; idx: uint; str: PAnsiChar; len: uint; dest: pointer; duplicate: integer): integer; cdecl;

  _array_init                                     : function(arg: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint): integer; cdecl;

  {$IFDEF PHP4}
  _object_init                                    : function(arg: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint; TSRMLS_DC: pointer): integer; cdecl;
  {$ELSE}
  _object_init                                    : function(arg: pzval;TSRMLS_DC: pointer): integer; cdecl;
  {$ENDIF}

  {$IFDEF PHP4}
  _object_init_ex                                 : function (arg: pzval; ce: pzend_class_entry; __zend_filename: PAnsiChar; __zend_lineno: uint; TSRMLS_DC: pointer) : integer; cdecl;
  {$ELSE}
  _object_init_ex                                 : function (arg: pzval; ce: pzend_class_entry; __zend_lineno : integer; TSRMLS_DC : pointer) : integer; cdecl;
  {$ENDIF}

  _object_and_properties_init                     : function(arg: pzval; ce: pointer; properties: phashtable; __zend_filename: PAnsiChar; __zend_lineno: uint; TSRMLS_DC: pointer): integer; cdecl;


  {$IFDEF PHP5}
  zend_destroy_file_handle : procedure(file_handle : PZendFileHandle; TSRMLS_DC : pointer); cdecl;
  {$ENDIF}

var
  zend_write                                      : zend_write_t;

procedure ZEND_PUTS(str: PAnsiChar);


var
  zend_register_internal_class     : function(class_entry: pzend_class_entry; TSRMLS_DC: pointer): Pzend_class_entry; cdecl;
  zend_register_internal_class_ex  : function(class_entry: pzend_class_entry; parent_ce: pzend_class_entry; parent_name: PAnsiChar; TSRMLS_DC: pointer): Pzend_class_entry; cdecl;

procedure ZVAL_RESOURCE(value: pzval; l: longint);
procedure ZVAL_BOOL(z: pzval; b: boolean);
procedure ZVAL_NULL(z: pzval);
procedure ZVAL_LONG(z: pzval; l: longint);
procedure ZVAL_DOUBLE(z: pzval; d: double);
procedure ZVAL_EMPTY_STRING(z: pzval);
procedure ZVAL_TRUE(z: pzval);
procedure ZVAL_FALSE(z: pzval);


procedure ZVAL_STRING(z: pzval; s: PAnsiChar; duplicate: boolean);
procedure ZVAL_STRINGW(z: pzval; s: PWideChar; duplicate: boolean);

procedure ZVAL_STRINGL(z: pzval; s: PAnsiChar; l: integer; duplicate: boolean);
procedure ZVAL_STRINGLW(z: pzval; s: PWideChar; l: integer; duplicate: boolean);

procedure INIT_CLASS_ENTRY(var class_container: Tzend_class_entry; class_name: PAnsiChar; functions: pointer);


var
  get_zend_version           : function(): PAnsiChar; cdecl;
  zend_make_printable_zval   : procedure(expr: pzval; expr_copy: pzval; use_copy: pint); cdecl;
  zend_print_zval            : function(expr: pzval; indent: integer): integer; cdecl;
  zend_print_zval_r          : procedure(expr: pzval; indent: integer); cdecl;
  zend_output_debug_string   : procedure(trigger_break: boolean; Msg: PAnsiChar); cdecl;

{$IFDEF PHP5}
  zend_copy_constants: procedure(target: PHashTable; source: PHashTable); cdecl;
  zend_objects_new : function (_object : pointer; class_type : pointer; TSRMLS_DC : pointer) : _zend_object_value; cdecl;
  zend_objects_clone_obj: function(_object: pzval; TSRMLS_DC : pointer): _zend_object_value; cdecl;
  zend_objects_store_add_ref: procedure (_object : pzval; TSRMLS_DC : pointer); cdecl;
  zend_objects_store_del_ref: procedure (_object : pzval; TSRMLS_DC : pointer); cdecl;

  function_add_ref: procedure (func: PZendFunction); cdecl;

  zend_class_add_ref: procedure(aclass: Ppzend_class_entry); cdecl;


{$ENDIF}


const
  MSCRT = 'msvcrt.dll';

//Microsoft C++ functions

{$IFDEF PHP4}
function  pipe(phandles : pointer; psize : uint; textmode : integer) : integer; cdecl; external MSCRT name '_pipe';
procedure close(AHandle : THandle); cdecl; external MSCRT name '_close';
function  _write(AHandle : integer; ABuffer : pointer; count : uint) : integer; cdecl; external MSCRT name '_write';
function  setjmp(buf : jump_buf) : integer; cdecl; external  MSCRT name '_setjmp3';
{$ENDIF}

{$IFNDEF COMPILER_VC9}
function  strdup(strSource : PAnsiChar) : PAnsiChar; cdecl; external MSCRT name '_strdup';
{$ELSE}
function  DupStr(strSource : PAnsiChar) : PAnsiChar; cdecl;
{$ENDIF}

function ZEND_FAST_ALLOC: pzval;
function ALLOC_ZVAL: pzval;
procedure INIT_PZVAL(p: pzval);
function MAKE_STD_ZVAL: pzval;

{$IFNDEF QUIET_LOAD}
procedure CheckZendErrors;
{$ENDIF}

var
  PHPLib : THandle = 0;

var
 zend_ini_deactivate : function(TSRMLS_D : pointer) : integer; cdecl;

function GetGlobalResource(resource_name: AnsiString) : pointer;

function GetCompilerGlobals : Pzend_compiler_globals;
function GetExecutorGlobals : pzend_executor_globals;
function GetAllocGlobals : pointer;

function zend_register_functions(functions : pzend_function_entry;  function_table : PHashTable; _type: integer;  TSRMLS_DC : pointer) : integer;
function zend_unregister_functions(functions : pzend_function_entry; count : integer; function_table : PHashTable; TSRMLS_DC : pointer) : integer;

{$IFDEF PHP5}

var
  zend_get_std_object_handlers : function() : pzend_object_handlers;
  zend_objects_get_address : function (_object : pzval; TSRMLS_DC : pointer) : pzend_object; cdecl;
  zend_is_true : function(z : pzval) : integer; cdecl;

function object_init(arg: pzval; ce: pzend_class_entry; TSRMLS_DC : pointer) : integer; cdecl; assembler;

function Z_LVAL(z : Pzval) : longint;
function Z_BVAL(z : Pzval) : boolean;
function Z_DVAL(z : Pzval) : double;
function Z_STRVAL(z : Pzval) : AnsiString;
function Z_STRLEN(z : Pzval) : longint;
function Z_ARRVAL(z : Pzval ) : PHashTable;
function Z_OBJ_HANDLE(z :Pzval) : zend_object_handle;
function Z_OBJ_HT(z : Pzval) : pzend_object_handlers;
function Z_OBJPROP(z : Pzval) : PHashtable;
function Z_VARREC(z: pzval): TVarRec;

 procedure zend_addref_p(z: pzval); cdecl;
 procedure my_class_add_ref(aclass: Ppzend_class_entry); cdecl;
 procedure copy_zend_constant(C: PZendConstant); cdecl;


{$ENDIF}

implementation


function zend_hash_add(ht : PHashTable; arKey : PAnsiChar; nKeyLength : uint; pData : pointer; nDataSize : uint; pDest : pointer) : integer; cdecl;
begin
  result := zend_hash_add_or_update(ht, arKey, nKeyLength, pData, nDataSize, pDest, HASH_ADD);
end;

function STR_EMPTY_ALLOC : PAnsiChar;
begin
  Result := estrndup('', 0);
end;

function estrndup(s: PAnsiChar; len: Cardinal): PAnsiChar;
begin
  if assigned(s) then
    Result := _estrndup(s, len, nil, 0, nil, 0)
     else
      Result := nil;
end;

function emalloc(size: size_t): pointer;
begin
  Result := _emalloc(size, nil, 0, nil, 0);
end;

procedure efree(ptr: pointer);
begin
  _efree(ptr, nil, 0, nil, 0);
end;

function ecalloc(nmemb: size_t; size: size_t): pointer;
begin
  Result := _ecalloc(nmemb, size, nil, 0, nil, 0);
end;

function erealloc(ptr: pointer; size: size_t; allow_failure: integer): pointer;
begin
  Result := _erealloc(ptr, size, allow_failure, nil, 0, nil, 0);
end;

function estrdup(const s: PAnsiChar): PAnsiChar;
begin
  if assigned(s) then
  begin
   Result := _estrdup(s, nil, 0, nil, 0);
  end
    else
     Result := nil;
end;


procedure REGISTER_MAIN_LONG_CONSTANT(name: PAnsiChar; lval: longint; flags: integer; TSRMLS_DC: Pointer);
begin
  zend_register_long_constant(name, length(name) + 1, lval, flags, 0, TSRMLS_DC);
end;

procedure REGISTER_MAIN_DOUBLE_CONSTANT(name: PAnsiChar; dval: double; flags: integer; TSRMLS_DC: Pointer);
begin
  zend_register_double_constant(name, length(name) + 1, dval, flags, 0, TSRMLS_DC);
end;

procedure REGISTER_MAIN_STRING_CONSTANT(name: PAnsiChar; str: PAnsiChar; flags: integer; TSRMLS_DC: Pointer);
begin
  zend_register_string_constant(name, length(name) + 1, str, flags, 0, TSRMLS_DC);
end;

procedure REGISTER_MAIN_STRINGL_CONSTANT(name: PAnsiChar; str: PAnsiChar; len: uint; flags: integer; TSRMLS_DC: Pointer);
begin
  zend_register_stringl_constant(name, length(name) + 1, str, len, flags, 0, TSRMLS_DC);
end;

procedure ZVAL_RESOURCE(value: pzval; l: longint);
begin
  value^._type := IS_RESOURCE;
  value^.value.lval := l;
end;

procedure ZVAL_BOOL(z: pzval; b: boolean);
begin
  z^._type := IS_BOOL;
  z^.value.lval := integer(b);
end;

procedure ZVAL_NULL(z: pzval);
begin
  z^._type := IS_NULL;
end;

procedure ZVAL_LONG(z: pzval; l: longint);
begin
  z^._type := IS_LONG;
  z^.value.lval := l;
end;

procedure ZVAL_DOUBLE(z: pzval; d: double);
begin
  z^._type := IS_DOUBLE;
  z^.value.dval := d;
end;

procedure ZVAL_STRING(z: pzval; s: PAnsiChar; duplicate: boolean);
var
  __s : PAnsiChar;
begin
  if not assigned(s) then
   __s := ''
    else
     __s := s;

  z^.value.str.len := strlen(__s);
  if duplicate then

   z^.value.str.val := estrndup(__s, z^.value.str.len)
  else
    z^.value.str.val := __s;
  z^._type := IS_STRING;
end;

procedure ZVAL_STRINGW(z: pzval; s: PWideChar; duplicate: boolean);
var
  __s : PAnsiChar;
  StA : AnsiString;
  StW : WideString;
begin
  if not assigned(s) then
   __s := ''
    else
      begin
        StW := WideString(s);
        StA := AnsiString(StW);
        __s := PAnsiChar(StA);
      end;

  z^.value.str.len := strlen(__s);
  if duplicate then

   z^.value.str.val := estrndup(__s, z^.value.str.len)
  else
    z^.value.str.val := __s;
  z^._type := IS_STRING;
end;

procedure ZVAL_STRINGL(z: pzval; s: PAnsiChar; l: integer; duplicate: boolean);
var
  __s  : PAnsiChar;
  __l  : integer;
begin
  if not assigned(s) then
   __s := ''
    else
     __s := s;
  __l := l;
  z^.value.str.len := __l;
  if duplicate then
    z^.value.str.val := estrndup(__s, __l)
  else
    z^.value.str.val := __s;
  z^._type := IS_STRING;
end;

procedure ZVAL_STRINGLW(z: pzval; s: PWideChar; l: integer; duplicate: boolean);
var
  __s  : PAnsiChar;
  __l  : integer;
  StA : AnsiString;
  StW : WideString;
begin
  if not assigned(s) then
   __s := ''
    else
     begin
       StW := WideString(s);
       StA := AnsiString(StW);
        __s := PAnsiChar(StA);
     end;

  __l := l;
  z^.value.str.len := __l;
  if duplicate then
    z^.value.str.val := estrndup(__s, __l)
  else
    z^.value.str.val := __s;
  z^._type := IS_STRING;
end;

procedure ZVAL_EMPTY_STRING(z: pzval);
begin
  z^.value.str.len := 0;
 // {$IFDEF PHP510}
  z^.value.str.val := STR_EMPTY_ALLOC;
  (*{$ELSE}
  z^.value.str.val := '';
  {$ENDIF}*)
  z^._type := IS_STRING;
end;

procedure ZVAL_TRUE(z: pzval);
begin
  z^._type := IS_BOOL;
  z^.value.lval := 1;
end;

procedure ZVAL_FALSE(z: pzval);
begin
  z^._type := IS_BOOL;
  z^.value.lval := 0;
end;

function ZENDLoaded: boolean;
begin
  Result := PHPLib <> 0;
end;

procedure UnloadZEND;
var
 H : THandle;
begin
  H := InterlockedExchange(Integer(PHPLib), 0);
  if H > 0 then
  begin
    FreeLibrary(H);
  end;
end;


function LoadZEND(const DllFilename: AnsiString = PHPWin) : boolean;
var
  WriteFuncPtr  : pointer;
begin
 {$IFDEF QUIET_LOAD}
  Result := false;
 {$ENDIF}
  PHPLib := LoadLibraryA(PAnsiChar(DllFileName));

{$IFNDEF QUIET_LOAD}
  if PHPLib = 0 then
  begin
   RaiseLastOSError;
  // raise Exception.Create(RaiseLastOSError);
  end;
{$ELSE}
  if PHPLib = 0 then Exit;
{$ENDIF}

 {$IFDEF PHP5}
   zend_copy_constants := GetProcAddress(PHPLib, 'zend_copy_constants');
   zend_objects_new := GetProcAddress(PHPLib, 'zend_objects_new');
   zend_objects_clone_obj := GetProcAddress(PHPLib, 'zend_objects_clone_obj');
   function_add_ref := GetProcAddress(PHPLib, 'function_add_ref');
   zend_class_add_ref := GetProcAddress(PHPLib, 'zend_class_add_ref');

   zend_objects_store_add_ref := GetProcAddress(PHPLib, 'zend_objects_store_add_ref');
   zend_objects_store_del_ref := GetProcAddress(PHPLib, 'zend_objects_store_del_ref');

   zend_get_std_object_handlers := GetProcAddress(PHPLib, 'zend_get_std_object_handlers');
   zend_objects_get_address := GetProcAddress(PHPLib, 'zend_objects_get_address');
   zend_is_true := GetProcAddress(PHPLib, 'zend_is_true');
{$ENDIF}

  _zend_bailout := GetProcAddress(PHPLib, '_zend_bailout');

  zend_disable_function := GetProcAddress(PHPLib, 'zend_disable_function');
  zend_disable_class := GetProcAddress(PHPLib, 'zend_disable_class');
  zend_register_list_destructors_ex   := GetProcAddress(PHPLib, 'zend_register_list_destructors_ex');
  zend_register_resource :=           GetProcAddress(PHPLib, 'zend_register_resource');
  zend_fetch_resource :=              GetProcAddress(PHPLib, 'zend_fetch_resource');
  zend_list_insert :=                 GetProcAddress(PHPLib, 'zend_list_insert');
  _zend_list_addref :=                GetProcAddress(PHPLib, '_zend_list_addref');
  _zend_list_delete :=                GetProcAddress(PHPLib, '_zend_list_delete');
  _zend_list_find :=                  GetProcAddress(PHPLib, '_zend_list_find');
  zend_rsrc_list_get_rsrc_type :=     GetProcAddress(PHPLib, 'zend_rsrc_list_get_rsrc_type');
  zend_fetch_list_dtor_id :=          GetProcAddress(PHPLib, 'zend_fetch_list_dtor_id');

  zend_get_compiled_filename := GetProcAddress(PHPLib, 'zend_get_compiled_filename');

  zend_get_compiled_lineno := GetProcAddress(PHPLib, 'zend_get_compiled_lineno');

  zend_ini_deactivate := GetProcAddress(PHPLib, 'zend_ini_deactivate');

  // -- tsrm_startup
  tsrm_startup := GetProcAddress(PHPLib, 'tsrm_startup');

  // -- ts_allocate_id
  ts_allocate_id := GetProcAddress(PHPLib, 'ts_allocate_id');

  // -- ts_free_id
  ts_free_id := GetProcAddress(PHPLib, 'ts_free_id');


  // -- zend_strndup
  zend_strndup := GetProcAddress(PHPLib, 'zend_strndup');


  // -- _emalloc
  _emalloc := GetProcAddress(PHPLib, '_emalloc');


  // -- _efree
  _efree := GetProcAddress(PHPLib, '_efree');


  // -- _ecalloc
  _ecalloc := GetProcAddress(PHPLib, '_ecalloc');


  // -- _erealloc
  _erealloc := GetProcAddress(PHPLib, '_erealloc');


  // -- _estrdup
  _estrdup := GetProcAddress(PHPLib, '_estrdup');

  // -- _estrndup
  _estrndup := GetProcAddress(PHPLib, '_estrndup');

  // -- zend_set_memory_limit
  zend_set_memory_limit := GetProcAddress(PHPLib, 'zend_set_memory_limit');

  // -- start_memory_manager
  start_memory_manager := GetProcAddress(PHPLib, 'start_memory_manager');

  // -- shutdown_memory_manager
  shutdown_memory_manager := GetProcAddress(PHPLib, 'shutdown_memory_manager');

  {$IFDEF PHP4}
  // -- zend_hash_init
  zend_hash_init := GetProcAddress(PHPLib, 'zend_hash_init');

  // -- zend_hash_init_ex
  zend_hash_init_ex := GetProcAddress(PHPLib, 'zend_hash_init_ex');

  // -- zend_hash_quick_add_or_update
  zend_hash_quick_add_or_update := GetProcAddress(PHPLib, 'zend_hash_quick_add_or_update');

  // -- zend_hash_index_update_or_next_insert
  zend_hash_index_update_or_next_insert := GetProcAddress(PHPLib, 'zend_hash_index_update_or_next_insert');

  // -- zend_hash_merge
  zend_hash_merge := GetProcAddress(PHPLib, 'zend_hash_merge');
  {$ELSE}
  _zend_hash_init := GetProcAddress(PHPLib, '_zend_hash_init');
  _zend_hash_init_ex := GetProcAddress(PHPLib, '_zend_hash_init_ex');

  {$ENDIF}

  {$IFDEF PHP4}
  // -- zend_hash_add_or_update
  zend_hash_add_or_update := GetProcAddress(PHPLib, 'zend_hash_add_or_update');
  {$ELSE}
  // -- zend_hash_add_or_update
  _zend_hash_add_or_update := GetProcAddress(PHPLib, '_zend_hash_add_or_update');
  {$ENDIF}

  // -- zend_hash_destroy
  zend_hash_destroy := GetProcAddress(PHPLib, 'zend_hash_destroy');

  // -- zend_hash_clean
  zend_hash_clean := GetProcAddress(PHPLib, 'zend_hash_clean');

  // -- zend_hash_add_empty_element
  zend_hash_add_empty_element := GetProcAddress(PHPLib, 'zend_hash_add_empty_element');

  // -- zend_hash_graceful_destroy
  zend_hash_graceful_destroy := GetProcAddress(PHPLib, 'zend_hash_graceful_destroy');

  // -- zend_hash_graceful_reverse_destroy
  zend_hash_graceful_reverse_destroy := GetProcAddress(PHPLib, 'zend_hash_graceful_reverse_destroy');

  // -- zend_hash_apply
  zend_hash_apply := GetProcAddress(PHPLib, 'zend_hash_apply');

  // -- zend_hash_apply_with_argument
  zend_hash_apply_with_argument := GetProcAddress(PHPLib, 'zend_hash_apply_with_argument');

  // -- zend_hash_reverse_apply
  zend_hash_reverse_apply := GetProcAddress(PHPLib, 'zend_hash_reverse_apply');

  // -- zend_hash_del_key_or_index
  zend_hash_del_key_or_index := GetProcAddress(PHPLib, 'zend_hash_del_key_or_index');

  // -- zend_get_hash_value
  zend_get_hash_value := GetProcAddress(PHPLib, 'zend_get_hash_value');

  // -- zend_hash_find
  zend_hash_find := GetProcAddress(PHPLib, 'zend_hash_find');

  // -- zend_hash_quick_find
  zend_hash_quick_find := GetProcAddress(PHPLib, 'zend_hash_quick_find');

  // -- zend_hash_index_find
  zend_hash_index_find := GetProcAddress(PHPLib, 'zend_hash_index_find');

  // -- zend_hash_exists
  zend_hash_exists := GetProcAddress(PHPLib, 'zend_hash_exists');

  // -- zend_hash_index_exists
  zend_hash_index_exists := GetProcAddress(PHPLib, 'zend_hash_index_exists');

  // -- zend_hash_next_free_element
  zend_hash_next_free_element := GetProcAddress(PHPLib, 'zend_hash_next_free_element');

  // -- zend_hash_move_forward_ex
  zend_hash_move_forward_ex := GetProcAddress(PHPLib, 'zend_hash_move_forward_ex');

  // -- zend_hash_move_backwards_ex
  zend_hash_move_backwards_ex := GetProcAddress(PHPLib, 'zend_hash_move_backwards_ex');

  // -- zend_hash_get_current_key_ex
  zend_hash_get_current_key_ex := GetProcAddress(PHPLib, 'zend_hash_get_current_key_ex');

  // -- zend_hash_get_current_key_type_ex
  zend_hash_get_current_key_type_ex := GetProcAddress(PHPLib, 'zend_hash_get_current_key_type_ex');

  // -- zend_hash_get_current_data_ex
  zend_hash_get_current_data_ex := GetProcAddress(PHPLib, 'zend_hash_get_current_data_ex');

  // -- zend_hash_internal_pointer_reset_ex
  zend_hash_internal_pointer_reset_ex := GetProcAddress(PHPLib, 'zend_hash_internal_pointer_reset_ex');

  // -- zend_hash_internal_pointer_end_ex
  zend_hash_internal_pointer_end_ex := GetProcAddress(PHPLib, 'zend_hash_internal_pointer_end_ex');

  // -- zend_hash_copy
  zend_hash_copy := GetProcAddress(PHPLib, 'zend_hash_copy');


  // -- zend_hash_sort
  zend_hash_sort := GetProcAddress(PHPLib, 'zend_hash_sort');

  // -- zend_hash_compare
  zend_hash_compare := GetProcAddress(PHPLib, 'zend_hash_compare');

  // -- zend_hash_minmax
  zend_hash_minmax := GetProcAddress(PHPLib, 'zend_hash_minmax');

  // -- zend_hash_num_elements
  zend_hash_num_elements := GetProcAddress(PHPLib, 'zend_hash_num_elements');

  // -- zend_hash_rehash
  zend_hash_rehash := GetProcAddress(PHPLib, 'zend_hash_rehash');

  // -- zend_hash_func
  zend_hash_func := GetProcAddress(PHPLib, 'zend_hash_func');

  // -- zend_get_constant
  zend_get_constant := GetProcAddress(PHPLib, 'zend_get_constant');

  // -- zend_register_long_constant
  zend_register_long_constant := GetProcAddress(PHPLib, 'zend_register_long_constant');

  // -- zend_register_double_constant
  zend_register_double_constant := GetProcAddress(PHPLib, 'zend_register_double_constant');

  // -- zend_register_string_constant
  zend_register_string_constant := GetProcAddress(PHPLib, 'zend_register_string_constant');

  // -- zend_register_stringl_constant
  zend_register_stringl_constant := GetProcAddress(PHPLib, 'zend_register_stringl_constant');

  // -- zend_register_constant
  zend_register_constant := GetProcAddress(PHPLib, 'zend_register_constant');

  zend_register_auto_global := GetProcAddress(PHPLib, 'zend_register_auto_global');

  // -- tsrm_shutdown
  tsrm_shutdown := GetProcAddress(PHPLib, 'tsrm_shutdown');

  // -- ts_resource_ex
  ts_resource_ex := GetProcAddress(PHPLib, 'ts_resource_ex');

  // -- ts_free_thread
  ts_free_thread := GetProcAddress(PHPLib, 'ts_free_thread');

  // -- zend_error
  zend_error := GetProcAddress(PHPLib, 'zend_error');

  // -- zend_error_cb
  zend_error_cb := GetProcAddress(PHPLib, 'zend_error_cb');

  // -- zend_eval_string
  zend_eval_string := GetProcAddress(PHPLib, 'zend_eval_string');

  // -- zend_make_compiled_string_description
  zend_make_compiled_string_description := GetProcAddress(PHPLib, 'zend_make_compiled_string_description');


  {$IFDEF PHP4}
  // -- _zval_dtor
  _zval_dtor := GetProcAddress(PHPLib, '_zval_dtor');

  // -- _zval_copy_ctor
  _zval_copy_ctor := GetProcAddress(PHPLib, '_zval_copy_ctor');

  {$ELSE}
  _zval_copy_ctor_func := GetProcAddress(PHPLib, '_zval_copy_ctor_func');
  _zval_dtor_func := GetProcAddress(PHPLib, '_zval_dtor_func');
  _zval_ptr_dtor := GetProcAddress(PHPLib, '_zval_ptr_dtor');

  {$ENDIF}

  // -- zend_print_variable
  zend_print_variable := GetProcAddress(PHPLib, 'zend_print_variable');

  // -- zend_stack_init
  zend_stack_init := GetProcAddress(PHPLib, 'zend_stack_init');

  // -- zend_stack_push
  zend_stack_push := GetProcAddress(PHPLib, 'zend_stack_push');

  // -- zend_stack_top
  zend_stack_top := GetProcAddress(PHPLib, 'zend_stack_top');

  // -- zend_stack_del_top
  zend_stack_del_top := GetProcAddress(PHPLib, 'zend_stack_del_top');

  // -- zend_stack_int_top
  zend_stack_int_top := GetProcAddress(PHPLib, 'zend_stack_int_top');

  // -- zend_stack_is_empty
  zend_stack_is_empty := GetProcAddress(PHPLib, 'zend_stack_is_empty');

  // -- zend_stack_destroy
  zend_stack_destroy := GetProcAddress(PHPLib, 'zend_stack_destroy');

  // -- zend_stack_base
  zend_stack_base := GetProcAddress(PHPLib, 'zend_stack_base');

  // -- zend_stack_count
  zend_stack_count := GetProcAddress(PHPLib, 'zend_stack_count');

  // -- zend_stack_apply
  zend_stack_apply := GetProcAddress(PHPLib, 'zend_stack_apply');

  // -- zend_stack_apply_with_argument
  zend_stack_apply_with_argument := GetProcAddress(PHPLib, 'zend_stack_apply_with_argument');

  // -- _convert_to_string
  _convert_to_string := GetProcAddress(PHPLib, '_convert_to_string');

  // -- add_function
  add_function := GetProcAddress(PHPLib, 'add_function');

  // -- sub_function
  sub_function := GetProcAddress(PHPLib, 'sub_function');

  // -- mul_function
  mul_function := GetProcAddress(PHPLib, 'mul_function');

  // -- div_function
  div_function := GetProcAddress(PHPLib, 'div_function');

  // -- mod_function
  mod_function := GetProcAddress(PHPLib, 'mod_function');

  // -- boolean_xor_function
  boolean_xor_function := GetProcAddress(PHPLib, 'boolean_xor_function');

  // -- boolean_not_function
  boolean_not_function := GetProcAddress(PHPLib, 'boolean_not_function');

  // -- bitwise_not_function
  bitwise_not_function := GetProcAddress(PHPLib, 'bitwise_not_function');

  // -- bitwise_or_function
  bitwise_or_function := GetProcAddress(PHPLib, 'bitwise_or_function');

  // -- bitwise_and_function
  bitwise_and_function := GetProcAddress(PHPLib, 'bitwise_and_function');

  // -- bitwise_xor_function
  bitwise_xor_function := GetProcAddress(PHPLib, 'bitwise_xor_function');

  // -- shift_left_function
  shift_left_function := GetProcAddress(PHPLib, 'shift_left_function');

  // -- shift_right_function
  shift_right_function := GetProcAddress(PHPLib, 'shift_right_function');

  // -- concat_function
  concat_function := GetProcAddress(PHPLib, 'concat_function');

  // -- is_equal_function
  is_equal_function := GetProcAddress(PHPLib, 'is_equal_function');

  // -- is_identical_function
  is_identical_function := GetProcAddress(PHPLib, 'is_identical_function');

  // -- is_not_identical_function
  is_not_identical_function := GetProcAddress(PHPLib, 'is_not_identical_function');

  // -- is_not_equal_function
  is_not_equal_function := GetProcAddress(PHPLib, 'is_not_equal_function');

  // -- is_smaller_function
  is_smaller_function := GetProcAddress(PHPLib, 'is_smaller_function');

  // -- is_smaller_or_equal_function
  is_smaller_or_equal_function := GetProcAddress(PHPLib, 'is_smaller_or_equal_function');

  // -- increment_function
  increment_function := GetProcAddress(PHPLib, 'increment_function');

  // -- decrement_function
  decrement_function := GetProcAddress(PHPLib, 'decrement_function');

  // -- convert_scalar_to_number
  convert_scalar_to_number := GetProcAddress(PHPLib, 'convert_scalar_to_number');

  // -- convert_to_long
  convert_to_long := GetProcAddress(PHPLib, 'convert_to_long');

  // -- convert_to_double
  convert_to_double := GetProcAddress(PHPLib, 'convert_to_double');

  // -- convert_to_long_base
  convert_to_long_base := GetProcAddress(PHPLib, 'convert_to_long_base');

  // -- convert_to_null
  convert_to_null := GetProcAddress(PHPLib, 'convert_to_null');

  // -- convert_to_boolean
  convert_to_boolean := GetProcAddress(PHPLib, 'convert_to_boolean');

  // -- convert_to_array
  convert_to_array := GetProcAddress(PHPLib, 'convert_to_array');

  // -- convert_to_object
  convert_to_object := GetProcAddress(PHPLib, 'convert_to_object');

  // -- add_char_to_string
  add_char_to_string := GetProcAddress(PHPLib, 'add_char_to_string');

  // -- add_string_to_string
  add_string_to_string := GetProcAddress(PHPLib, 'add_string_to_string');

  // -- zend_string_to_double
  zend_string_to_double := GetProcAddress(PHPLib, 'zend_string_to_double');

  // -- zval_is_true
  zval_is_true := GetProcAddress(PHPLib, 'zval_is_true');

  // -- compare_function
  compare_function := GetProcAddress(PHPLib, 'compare_function');

  // -- numeric_compare_function
  numeric_compare_function := GetProcAddress(PHPLib, 'numeric_compare_function');

  // -- string_compare_function
  string_compare_function := GetProcAddress(PHPLib, 'string_compare_function');

  // -- zend_str_tolower
  zend_str_tolower := GetProcAddress(PHPLib, 'zend_str_tolower');

  // -- zend_binary_zval_strcmp
  zend_binary_zval_strcmp := GetProcAddress(PHPLib, 'zend_binary_zval_strcmp');

  // -- zend_binary_zval_strncmp
  zend_binary_zval_strncmp := GetProcAddress(PHPLib, 'zend_binary_zval_strncmp');

  // -- zend_binary_zval_strcasecmp
  zend_binary_zval_strcasecmp := GetProcAddress(PHPLib, 'zend_binary_zval_strcasecmp');

  // -- zend_binary_zval_strncasecmp
  zend_binary_zval_strncasecmp := GetProcAddress(PHPLib, 'zend_binary_zval_strncasecmp');

  // -- zend_binary_strcmp
  zend_binary_strcmp := GetProcAddress(PHPLib, 'zend_binary_strcmp');

  // -- zend_binary_strncmp
  zend_binary_strncmp := GetProcAddress(PHPLib, 'zend_binary_strncmp');

  // -- zend_binary_strcasecmp
  zend_binary_strcasecmp := GetProcAddress(PHPLib, 'zend_binary_strcasecmp');

  // -- zend_binary_strncasecmp
  zend_binary_strncasecmp := GetProcAddress(PHPLib, 'zend_binary_strncasecmp');

  // -- zendi_smart_strcmp
  zendi_smart_strcmp := GetProcAddress(PHPLib, 'zendi_smart_strcmp');

  // -- zend_compare_symbol_tables
  zend_compare_symbol_tables := GetProcAddress(PHPLib, 'zend_compare_symbol_tables');

  // -- zend_compare_arrays
  zend_compare_arrays := GetProcAddress(PHPLib, 'zend_compare_arrays');

  // -- zend_compare_objects
  zend_compare_objects := GetProcAddress(PHPLib, 'zend_compare_objects');

  // -- zend_atoi
  zend_atoi := GetProcAddress(PHPLib, 'zend_atoi');

  // -- get_active_function_name
  get_active_function_name := GetProcAddress(PHPLib, 'get_active_function_name');

  // -- zend_get_executed_filename
  zend_get_executed_filename := GetProcAddress(PHPLib, 'zend_get_executed_filename');

  // -- zend_set_timeout
  zend_set_timeout := GetProcAddress(PHPLib, 'zend_set_timeout');

  // -- zend_unset_timeout
  zend_unset_timeout := GetProcAddress(PHPLib, 'zend_unset_timeout');

  // -- zend_timeout
  zend_timeout := GetProcAddress(PHPLib, 'zend_timeout');

  // -- zend_highlight
  zend_highlight := GetProcAddress(PHPLib, 'zend_highlight');

  // -- zend_strip
  zend_strip := GetProcAddress(PHPLib, 'zend_strip');

  // -- highlight_file
  highlight_file := GetProcAddress(PHPLib, 'highlight_file');

  // -- highlight_string
  highlight_string := GetProcAddress(PHPLib, 'highlight_string');

  // -- zend_html_putc
  zend_html_putc := GetProcAddress(PHPLib, 'zend_html_putc');

  // -- zend_html_puts
  zend_html_puts := GetProcAddress(PHPLib, 'zend_html_puts');

  // -- zend_indent
  zend_indent := GetProcAddress(PHPLib, 'zend_indent');

  // -- _zend_get_parameters_array_ex
  _zend_get_parameters_array_ex := GetProcAddress(PHPLib, '_zend_get_parameters_array_ex');

  // -- zend_ini_refresh_caches
  zend_ini_refresh_caches := GetProcAddress(PHPLib, 'zend_ini_refresh_caches');

  // -- zend_alter_ini_entry
  zend_alter_ini_entry := GetProcAddress(PHPLib, 'zend_alter_ini_entry');

  // -- zend_restore_ini_entry
  zend_restore_ini_entry := GetProcAddress(PHPLib, 'zend_restore_ini_entry');

  // -- zend_ini_long
  zend_ini_long := GetProcAddress(PHPLib, 'zend_ini_long');

  // -- zend_ini_double
  zend_ini_double := GetProcAddress(PHPLib, 'zend_ini_double');

  // -- zend_ini_string
  zend_ini_string := GetProcAddress(PHPLib, 'zend_ini_string');

  // -- compile_string
  compile_string := GetProcAddress(PHPLib, 'compile_string');

  // -- execute
  execute := GetProcAddress(PHPLib, 'execute');

  // -- zend_wrong_param_count
  zend_wrong_param_count := GetProcAddress(PHPLib, 'zend_wrong_param_count');

  // -- add_property_long_ex
  add_property_long_ex := GetProcAddress(PHPLib, 'add_property_long_ex');

  // -- add_property_null_ex
  add_property_null_ex := GetProcAddress(PHPLib, 'add_property_null_ex');

  // -- add_property_bool_ex
  add_property_bool_ex := GetProcAddress(PHPLib, 'add_property_bool_ex');

  // -- add_property_resource_ex
  add_property_resource_ex := GetProcAddress(PHPLib, 'add_property_resource_ex');

  // -- add_property_double_ex
  add_property_double_ex := GetProcAddress(PHPLib, 'add_property_double_ex');

  // -- add_property_string_ex
  add_property_string_ex := GetProcAddress(PHPLib, 'add_property_string_ex');

  // -- add_property_stringl_ex
  add_property_stringl_ex := GetProcAddress(PHPLib, 'add_property_stringl_ex');

  // -- add_property_zval_ex
  add_property_zval_ex := GetProcAddress(PHPLib, 'add_property_zval_ex');

  call_user_function := GetProcAddress(PHPLib, 'call_user_function');
  call_user_function_ex := GetProcAddress(PHPLib, 'call_user_function_ex');

  // -- add_assoc_long_ex
  add_assoc_long_ex := GetProcAddress(PHPLib, 'add_assoc_long_ex');

  // -- add_assoc_null_ex
  add_assoc_null_ex := GetProcAddress(PHPLib, 'add_assoc_null_ex');

  // -- add_assoc_bool_ex
  add_assoc_bool_ex := GetProcAddress(PHPLib, 'add_assoc_bool_ex');

  // -- add_assoc_resource_ex
  add_assoc_resource_ex := GetProcAddress(PHPLib, 'add_assoc_resource_ex');

  // -- add_assoc_double_ex
  add_assoc_double_ex := GetProcAddress(PHPLib, 'add_assoc_double_ex');

  // -- add_assoc_string_ex
  add_assoc_string_ex := GetProcAddress(PHPLib, 'add_assoc_string_ex');

  // -- add_assoc_stringl_ex
  add_assoc_stringl_ex := GetProcAddress(PHPLib, 'add_assoc_stringl_ex');

  // -- add_assoc_zval_ex
  add_assoc_zval_ex := GetProcAddress(PHPLib, 'add_assoc_zval_ex');

  // -- add_index_long
  add_index_long := GetProcAddress(PHPLib, 'add_index_long');

  // -- add_index_null
  add_index_null := GetProcAddress(PHPLib, 'add_index_null');

  // -- add_index_bool
  add_index_bool := GetProcAddress(PHPLib, 'add_index_bool');

  // -- add_index_resource
  add_index_resource := GetProcAddress(PHPLib, 'add_index_resource');

  // -- add_index_double
  add_index_double := GetProcAddress(PHPLib, 'add_index_double');

  // -- add_index_string
  add_index_string := GetProcAddress(PHPLib, 'add_index_string');

  // -- add_index_stringl
  add_index_stringl := GetProcAddress(PHPLib, 'add_index_stringl');

  // -- add_index_zval
  add_index_zval := GetProcAddress(PHPLib, 'add_index_zval');

  // -- add_next_index_long
  add_next_index_long := GetProcAddress(PHPLib, 'add_next_index_long');

  // -- add_next_index_null
  add_next_index_null := GetProcAddress(PHPLib, 'add_next_index_null');

  // -- add_next_index_bool
  add_next_index_bool := GetProcAddress(PHPLib, 'add_next_index_bool');

  // -- add_next_index_resource
  add_next_index_resource := GetProcAddress(PHPLib, 'add_next_index_resource');

  // -- add_next_index_double
  add_next_index_double := GetProcAddress(PHPLib, 'add_next_index_double');

  // -- add_next_index_string
  add_next_index_string := GetProcAddress(PHPLib, 'add_next_index_string');

  // -- add_next_index_stringl
  add_next_index_stringl := GetProcAddress(PHPLib, 'add_next_index_stringl');

  // -- add_next_index_zval
  add_next_index_zval := GetProcAddress(PHPLib, 'add_next_index_zval');

  // -- add_get_assoc_string_ex
  add_get_assoc_string_ex := GetProcAddress(PHPLib, 'add_get_assoc_string_ex');

  // -- add_get_assoc_stringl_ex
  add_get_assoc_stringl_ex := GetProcAddress(PHPLib, 'add_get_assoc_stringl_ex');

  // -- add_get_index_long
  add_get_index_long := GetProcAddress(PHPLib, 'add_get_index_long');

  // -- add_get_index_double
  add_get_index_double := GetProcAddress(PHPLib, 'add_get_index_double');

  // -- add_get_index_string
  add_get_index_string := GetProcAddress(PHPLib, 'add_get_index_string');

  // -- add_get_index_stringl
  add_get_index_stringl := GetProcAddress(PHPLib, 'add_get_index_stringl');

  // -- _array_init
  _array_init := GetProcAddress(PHPLib, '_array_init');

  // -- _object_init
  _object_init := GetProcAddress(PHPLib, '_object_init');

  // -- _object_init_ex
  _object_init_ex := GetProcAddress(PHPLib, '_object_init_ex');

  // -- _object_and_properties_init
  _object_and_properties_init := GetProcAddress(PHPLib, '_object_and_properties_init');

    // -- zend_register_internal_class
  zend_register_internal_class := GetProcAddress(PHPLib, 'zend_register_internal_class');

  // -- zend_register_internal_class_ex
  zend_register_internal_class_ex := GetProcAddress(PHPLib, 'zend_register_internal_class_ex');

  // -- get_zend_version
  get_zend_version := GetProcAddress(PHPLib, 'get_zend_version');

  // -- zend_make_printable_zval
  zend_make_printable_zval := GetProcAddress(PHPLib, 'zend_make_printable_zval');

  // -- zend_print_zval
  zend_print_zval := GetProcAddress(PHPLib, 'zend_print_zval');

  // -- zend_print_zval_r
  zend_print_zval_r := GetProcAddress(PHPLib, 'zend_print_zval_r');

  // -- zend_output_debug_string
  zend_output_debug_string := GetProcAddress(PHPLib, 'zend_output_debug_string');

  // -- zend_get_parameters
  ZendGetParameters := GetProcAddress(PHPLib, 'zend_get_parameters');

  {$IFDEF PHP5}
  zend_destroy_file_handle := GetProcAddress(PHPLib, 'zend_destroy_file_handle');
  {$ENDIF}

 {$IFNDEF QUIET_LOAD}
 CheckZendErrors;
 {$ENDIF}

  WriteFuncPtr := GetProcAddress(PHPLib, 'zend_write');
  if Assigned(WriteFuncPtr) then
    @zend_write := pointer(WriteFuncPtr^);

  Result := true;
end;

procedure ZEND_PUTS(str: PAnsiChar);
begin
  if assigned(str) then
    zend_write(str, strlen(str));
end;

procedure convert_to_string(op: pzval);
begin
  _convert_to_string(op, nil, 0);
end;

procedure INIT_CLASS_ENTRY(var class_container: Tzend_class_entry; class_name: PAnsiChar; functions: pointer);
begin

  if class_name = nil then
   Exit;

  ZeroMemory(@class_container, sizeof(Tzend_class_entry));

  {$IFNDEF COMPILER_VC9}
  class_container.name := strdup(class_name);
  {$ELSE}
  class_container.name := estrdup(class_name);
  {$ENDIF}

  class_container.name_length := strlen(class_name);
  class_container.builtin_functions := functions;

  {$IFDEF PHP4}
  class_container.handle_function_call := nil;
  class_container.handle_property_get := nil;
  class_container.handle_property_set := nil;
  {$ENDIF}
end;

function ZEND_FAST_ALLOC: pzval;
begin
  Result := emalloc(sizeof(zval));
end;

function ALLOC_ZVAL: pzval;
begin
  Result := emalloc(sizeof(zval));
end;

procedure INIT_PZVAL(p: pzval);
begin
  p^.refcount := 1;
  p^.is_ref := 0;
end;

procedure LOCK_ZVAL(p: pzval);
begin
  Inc(p^.refcount);
end;

procedure UNLOCK_ZVAL(p: pzval);
begin
  if p^.refcount > 0 then
    Dec(p^.refcount);
end;

function MAKE_STD_ZVAL: pzval;
begin
  Result := ALLOC_ZVAL;
  INIT_PZVAL(Result);
end;

function zend_get_parameters_ex(number: integer; var Params: pzval_array): integer;
var
  i  : integer;
begin
  SetLength(Params, number);
  if number = 0 then
  begin
    Result := SUCCESS;
    Exit;
  end;
  for i := 0 to number - 1 do
    New(Params[i]);

  Result := zend_get_parameters(number, number, Params);
end;

function zend_get_parameters_my(number: integer; var Params: pzval_array; TSRMLS_DC: Pointer): integer;
var
  i  : integer;
  p: pppzval;
begin
  SetLength(Params, number);
  if number = 0 then
  begin
    Result := SUCCESS;
    Exit;
  end;
  for i := 0 to number - 1 do
    New(Params[i]);

  p := emalloc(number * sizeOf(ppzval));
  Result := _zend_get_parameters_array_ex(number, p, TSRMLS_DC);

  for i := 0 to number - 1 do
  begin
     Params[i]^ := p^^;
     if i <> number then
         inc(integer(p^), sizeof(ppzval));
  end;

  efree(p);
end;

function zend_get_parameters(ht: integer; param_count: integer; Params: array of ppzval): integer; assembler; register;
asm
  push  esi
  mov   esi, ecx
  mov   ecx, [ebp+8]
  cmp   ecx, 0
  je @first
  @toploop:
  {$IFDEF VERSION6}
  push  [esi][ecx * 4]
  {$ELSE}
  push  dword [esi][ecx * 4]
  {$ENDIF}
  loop   @toploop
  @first:
  push    dword [esi]
  push    edx
  push    eax
  call    ZendGetParameters
  mov   ecx, [ebp+8]
  add     ecx, 3
  @toploop2:
  pop     edx
  loop   @toploop2
  pop     esi
end;

procedure dispose_pzval_array(Params: pzval_array);
var
  i : integer;
begin
  for i := 0 to High(Params) do
    FreeMem(Params[i]);
end;

{ EPHP4DelphiException }

constructor EPHP4DelphiException.Create(const Msg: AnsiString);
begin
  inherited Create('Unable to link '+ Msg+' function');
end;

procedure zenderror(Error : PAnsiChar);
begin
  zend_error(E_PARSE, Error);
end;


{$IFNDEF QUIET_LOAD}
procedure CheckZendErrors;
begin
  if @zend_disable_function = nil then raise EPHP4DelphiException.Create('zend_disable_function');
  if @zend_disable_class = nil then raise EPHP4DelphiException.Create('zend_disable_class');
  if @zend_register_list_destructors_ex = nil then raise EPHP4DelphiException.Create('zend_register_list_destructors_ex');
  if @zend_register_resource = nil then raise EPHP4DelphiException.Create('zend_register_resource');
  if @zend_fetch_resource =    nil then raise EPHP4DelphiException.Create('zend_fetch_resource');
  if @zend_list_insert =       nil then raise EPHP4DelphiException.Create('zend_list_insert');
  if @_zend_list_addref =      nil then raise EPHP4DelphiException.Create('zend_list_addref');
  if @_zend_list_delete =      nil then raise EPHP4DelphiException.Create('zend_list_delete');
  if @_zend_list_find =        nil then raise EPHP4DelphiException.Create('_zend_list_find');
  if @zend_rsrc_list_get_rsrc_type =  nil then raise EPHP4DelphiException.Create('zend_rsrc_list_get_rsrc_type');
  if @zend_fetch_list_dtor_id =       nil then raise EPHP4DelphiException.Create('zend_fetch_list_dtor_id');
  if @zend_get_compiled_filename = nil then raise EPHP4DelphiException.Create('zend_get_compiled_filename');
  if @zend_get_compiled_lineno = nil then raise EPHP4DelphiException.Create('zend_get_compiled_lineno');
  if @tsrm_startup = nil then raise EPHP4DelphiException.Create('tsrm_startup');
  if @ts_allocate_id = nil then raise EPHP4DelphiException.Create('ts_allocate_id');
  if @ts_free_id = nil then raise EPHP4DelphiException.Create('ts_free_id');
  if @zend_strndup = nil then raise EPHP4DelphiException.Create('zend_strndup');
  if @_emalloc = nil then raise EPHP4DelphiException.Create('_emalloc');
  if @_efree = nil then raise EPHP4DelphiException.Create('_efree');
  if @_ecalloc = nil then raise EPHP4DelphiException.Create('_ecalloc');
  if @_erealloc = nil then raise EPHP4DelphiException.Create('_erealloc');
  if @_estrdup = nil then raise EPHP4DelphiException.Create('_estrdup');
  if @_estrndup = nil then raise EPHP4DelphiException.Create('_estrndup');
  if @zend_set_memory_limit = nil then raise EPHP4DelphiException.Create('zend_set_memory_limit');
  if @start_memory_manager = nil then raise EPHP4DelphiException.Create('start_memory_manager');
  if @shutdown_memory_manager = nil then raise EPHP4DelphiException.Create('shutdown_memory_manager');
  {$IFDEF PHP4}
  if @zend_hash_init = nil then raise EPHP4DelphiException.Create('zend_hash_init');
  if @zend_hash_init_ex = nil then raise EPHP4DelphiException.Create('zend_hash_init_ex');
  if @zend_hash_add_or_update = nil then raise EPHP4DelphiException.Create('zend_hash_add_or_update');
  if @zend_hash_quick_add_or_update = nil then raise EPHP4DelphiException.Create('zend_hash_quick_add_or_update');
  if @zend_hash_index_update_or_next_insert = nil then raise EPHP4DelphiException.Create('zend_hash_index_update_or_next_insert');
  if @zend_hash_merge = nil then raise EPHP4DelphiException.Create('zend_hash_merge');
  {$ENDIF}

  {$IFDEF PHP5}
  if @_zend_hash_add_or_update = nil then raise EPHP4DelphiException.Create('_zend_hash_add_or_update');
  {$ENDIF}

  if @zend_hash_destroy = nil then raise EPHP4DelphiException.Create('zend_hash_destroy');
  if @zend_hash_clean = nil then raise EPHP4DelphiException.Create('zend_hash_clean');
  if @zend_hash_add_empty_element = nil then raise EPHP4DelphiException.Create('zend_hash_add_empty_element');
  if @zend_hash_graceful_destroy = nil then raise EPHP4DelphiException.Create('zend_hash_graceful_destroy');
  if @zend_hash_graceful_reverse_destroy = nil then raise EPHP4DelphiException.Create('zend_hash_graceful_reverse_destroy');
  if @zend_hash_apply = nil then raise EPHP4DelphiException.Create('zend_hash_apply');
  if @zend_hash_apply_with_argument = nil then raise EPHP4DelphiException.Create('zend_hash_apply_with_argument');
  if @zend_hash_reverse_apply = nil then raise EPHP4DelphiException.Create('zend_hash_reverse_apply');
  if @zend_hash_del_key_or_index = nil then raise EPHP4DelphiException.Create('zend_hash_del_key_or_index');
  if @zend_get_hash_value = nil then raise EPHP4DelphiException.Create('zend_get_hash_value');
  if @zend_hash_find = nil then raise EPHP4DelphiException.Create('zend_hash_find');
  if @zend_hash_quick_find = nil then raise EPHP4DelphiException.Create('zend_hash_quick_find');
  if @zend_hash_index_find = nil then raise EPHP4DelphiException.Create('zend_hash_index_find');
  if @zend_hash_exists = nil then raise EPHP4DelphiException.Create('zend_hash_exists');
  if @zend_hash_index_exists = nil then raise EPHP4DelphiException.Create('zend_hash_index_exists');
  if @zend_hash_next_free_element = nil then raise EPHP4DelphiException.Create('zend_hash_next_free_element');
  if @zend_hash_move_forward_ex = nil then raise EPHP4DelphiException.Create('zend_hash_move_forward_ex');
  if @zend_hash_move_backwards_ex = nil then raise EPHP4DelphiException.Create('zend_hash_move_backwards_ex');
  if @zend_hash_get_current_key_ex = nil then raise EPHP4DelphiException.Create('zend_hash_get_current_key_ex');
  if @zend_hash_get_current_key_type_ex = nil then raise EPHP4DelphiException.Create('zend_hash_get_current_key_type_ex');
  if @zend_hash_get_current_data_ex = nil then raise EPHP4DelphiException.Create('zend_hash_get_current_data_ex');
  if @zend_hash_internal_pointer_reset_ex = nil then raise EPHP4DelphiException.Create('zend_hash_internal_pointer_reset_ex');
  if @zend_hash_internal_pointer_end_ex = nil then raise EPHP4DelphiException.Create('zend_hash_internal_pointer_end_ex');
  if @zend_hash_copy = nil then raise EPHP4DelphiException.Create('zend_hash_copy');
  if @zend_hash_sort = nil then raise EPHP4DelphiException.Create('zend_hash_sort');
  if @zend_hash_compare = nil then raise EPHP4DelphiException.Create('zend_hash_compare');
  if @zend_hash_minmax = nil then raise EPHP4DelphiException.Create('zend_hash_minmax');
  if @zend_hash_num_elements = nil then raise EPHP4DelphiException.Create('zend_hash_num_elements');
  if @zend_hash_rehash = nil then raise EPHP4DelphiException.Create('zend_hash_rehash');
  if @zend_hash_func = nil then raise EPHP4DelphiException.Create('zend_hash_func');
  if @zend_get_constant = nil then raise EPHP4DelphiException.Create('zend_get_constant');
  if @zend_register_long_constant = nil then raise EPHP4DelphiException.Create('zend_register_long_constant');
  if @zend_register_double_constant = nil then raise EPHP4DelphiException.Create('zend_register_double_constant');
  if @zend_register_string_constant = nil then raise EPHP4DelphiException.Create('zend_register_string_constant');
  if @zend_register_stringl_constant = nil then raise EPHP4DelphiException.Create('zend_register_stringl_constant');
  if @zend_register_constant = nil then raise EPHP4DelphiException.Create('zend_register_constant');
  if @tsrm_shutdown = nil then raise EPHP4DelphiException.Create('tsrm_shutdown');
  if @ts_resource_ex = nil then raise EPHP4DelphiException.Create('ts_resource_ex');
  if @ts_free_thread = nil then raise EPHP4DelphiException.Create('ts_free_thread');
  if @zend_error = nil then raise EPHP4DelphiException.Create('zend_error');
  if @zend_error_cb = nil then raise EPHP4DelphiException.Create('zend_error_cb');
  if @zend_eval_string = nil then raise EPHP4DelphiException.Create('zend_eval_string');
  if @zend_make_compiled_string_description = nil then raise EPHP4DelphiException.Create('zend_make_compiled_string_description');

  {$IFDEF PHP4}
  if @_zval_dtor = nil then raise EPHP4DelphiException.Create('_zval_dtor');
  if @_zval_copy_ctor = nil then raise EPHP4DelphiException.Create('_zval_copy_ctor');
  {$ELSE}
  if @_zval_dtor_func = nil then raise EPHP4DelphiException.Create('_zval_dtor_func');
  if @_zval_copy_ctor_func = nil then raise EPHP4DelphiException.Create('_zval_ctor_func');
 {$ENDIF}

  if @zend_print_variable = nil then raise EPHP4DelphiException.Create('zend_print_variable');
  if @zend_stack_init = nil then raise EPHP4DelphiException.Create('zend_stack_init');
  if @zend_stack_push = nil then raise EPHP4DelphiException.Create('zend_stack_push');
  if @zend_stack_top = nil then raise EPHP4DelphiException.Create('zend_stack_top');
  if @zend_stack_del_top = nil then raise EPHP4DelphiException.Create('zend_stack_del_top');
  if @zend_stack_int_top = nil then raise EPHP4DelphiException.Create('zend_stack_int_top');
  if @zend_stack_is_empty = nil then raise EPHP4DelphiException.Create('zend_stack_is_empty');
  if @zend_stack_destroy = nil then raise EPHP4DelphiException.Create('zend_stack_destroy');
  if @zend_stack_base = nil then raise EPHP4DelphiException.Create('zend_stack_base');
  if @zend_stack_count = nil then raise EPHP4DelphiException.Create('zend_stack_count');
  if @zend_stack_apply = nil then raise EPHP4DelphiException.Create('zend_stack_apply');
  if @zend_stack_apply_with_argument = nil then raise EPHP4DelphiException.Create('zend_stack_apply_with_argument');
  if @_convert_to_string = nil then raise EPHP4DelphiException.Create('_convert_to_string');
  if @add_function = nil then raise EPHP4DelphiException.Create('add_function');
  if @sub_function = nil then raise EPHP4DelphiException.Create('sub_function');
  if @mul_function = nil then raise EPHP4DelphiException.Create('mul_function');
  if @div_function = nil then raise EPHP4DelphiException.Create('div_function');
  if @mod_function = nil then raise EPHP4DelphiException.Create('mod_function');
  if @boolean_xor_function = nil then raise EPHP4DelphiException.Create('boolean_xor_function');
  if @boolean_not_function = nil then raise EPHP4DelphiException.Create('boolean_not_function');
  if @bitwise_not_function = nil then raise EPHP4DelphiException.Create('bitwise_not_function');
  if @bitwise_or_function = nil then raise EPHP4DelphiException.Create('bitwise_or_function');
  if @bitwise_and_function = nil then raise EPHP4DelphiException.Create('bitwise_and_function');
  if @bitwise_xor_function = nil then raise EPHP4DelphiException.Create('bitwise_xor_function');
  if @shift_left_function = nil then raise EPHP4DelphiException.Create('shift_left_function');
  if @shift_right_function = nil then raise EPHP4DelphiException.Create('shift_right_function');
  if @concat_function = nil then raise EPHP4DelphiException.Create('concat_function');
  if @is_equal_function = nil then raise EPHP4DelphiException.Create('is_equal_function');
  if @is_identical_function = nil then raise EPHP4DelphiException.Create('is_identical_function');
  if @is_not_identical_function = nil then raise EPHP4DelphiException.Create('is_not_identical_function');
  if @is_not_equal_function = nil then raise EPHP4DelphiException.Create('is_not_equal_function');
  if @is_smaller_function = nil then raise EPHP4DelphiException.Create('is_smaller_function');
  if @is_smaller_or_equal_function = nil then raise EPHP4DelphiException.Create('is_smaller_or_equal_function');
  if @increment_function = nil then raise EPHP4DelphiException.Create('increment_function');
  if @decrement_function = nil then raise EPHP4DelphiException.Create('decrement_function');
  if @convert_scalar_to_number = nil then raise EPHP4DelphiException.Create('convert_scalar_to_number');
  if @convert_to_long = nil then raise EPHP4DelphiException.Create('convert_to_long');
  if @convert_to_double = nil then raise EPHP4DelphiException.Create('convert_to_double');
  if @convert_to_long_base = nil then raise EPHP4DelphiException.Create('convert_to_long_base');
  if @convert_to_null = nil then raise EPHP4DelphiException.Create('convert_to_null');
  if @convert_to_boolean = nil then raise EPHP4DelphiException.Create('convert_to_boolean');
  if @convert_to_array = nil then raise EPHP4DelphiException.Create('convert_to_array');
  if @convert_to_object = nil then raise EPHP4DelphiException.Create('convert_to_object');
  if @add_char_to_string = nil then raise EPHP4DelphiException.Create('add_char_to_string');
  if @add_string_to_string = nil then raise EPHP4DelphiException.Create('add_string_to_string');
  if @zend_string_to_double = nil then raise EPHP4DelphiException.Create('zend_string_to_double');
  if @zval_is_true = nil then raise EPHP4DelphiException.Create('zval_is_true');
  if @compare_function = nil then raise EPHP4DelphiException.Create('compare_function');
  if @numeric_compare_function = nil then raise EPHP4DelphiException.Create('numeric_compare_function');
  if @string_compare_function = nil then raise EPHP4DelphiException.Create('string_compare_function');
  if @zend_str_tolower = nil then raise EPHP4DelphiException.Create('zend_str_tolower');
  if @zend_binary_zval_strcmp = nil then raise EPHP4DelphiException.Create('zend_binary_zval_strcmp');
  if @zend_binary_zval_strncmp = nil then raise EPHP4DelphiException.Create('zend_binary_zval_strncmp');
  if @zend_binary_zval_strcasecmp = nil then raise EPHP4DelphiException.Create('zend_binary_zval_strcasecmp');
  if @zend_binary_zval_strncasecmp = nil then raise EPHP4DelphiException.Create('zend_binary_zval_strncasecmp');
  if @zend_binary_strcmp = nil then raise EPHP4DelphiException.Create('zend_binary_strcmp');
  if @zend_binary_strncmp = nil then raise EPHP4DelphiException.Create('zend_binary_strncmp');
  if @zend_binary_strcasecmp = nil then raise EPHP4DelphiException.Create('zend_binary_strcasecmp');
  if @zend_binary_strncasecmp = nil then raise EPHP4DelphiException.Create('zend_binary_strncasecmp');
  if @zendi_smart_strcmp = nil then raise EPHP4DelphiException.Create('zendi_smart_strcmp');
  if @zend_compare_symbol_tables = nil then raise EPHP4DelphiException.Create('zend_compare_symbol_tables');
  if @zend_compare_arrays = nil then raise EPHP4DelphiException.Create('zend_compare_arrays');
  if @zend_compare_objects = nil then raise EPHP4DelphiException.Create('zend_compare_objects');
  if @zend_atoi = nil then raise EPHP4DelphiException.Create('zend_atoi');
  if @get_active_function_name = nil then raise EPHP4DelphiException.Create('get_active_function_name');
  if @zend_get_executed_filename = nil then raise EPHP4DelphiException.Create('zend_get_executed_filename');
  if @zend_set_timeout = nil then raise EPHP4DelphiException.Create('zend_set_timeout');
  if @zend_unset_timeout = nil then raise EPHP4DelphiException.Create('zend_unset_timeout');
  if @zend_timeout = nil then raise EPHP4DelphiException.Create('zend_timeout');
  if @zend_highlight = nil then raise EPHP4DelphiException.Create('zend_highlight');
  if @zend_strip = nil then raise EPHP4DelphiException.Create('zend_strip');
  if @highlight_file = nil then raise EPHP4DelphiException.Create('highlight_file');
  if @highlight_string = nil then raise EPHP4DelphiException.Create('highlight_string');
  if @zend_html_putc = nil then raise EPHP4DelphiException.Create('zend_html_putc');
  if @zend_html_puts = nil then raise EPHP4DelphiException.Create('zend_html_puts');
  if @zend_indent = nil then raise EPHP4DelphiException.Create('zend_indent');
  if @_zend_get_parameters_array_ex = nil then raise EPHP4DelphiException.Create('_zend_get_parameters_array_ex');
  if @zend_ini_refresh_caches = nil then raise EPHP4DelphiException.Create('zend_ini_refresh_caches');
  if @zend_alter_ini_entry = nil then raise EPHP4DelphiException.Create('zend_alter_ini_entry');
  if @zend_restore_ini_entry = nil then raise EPHP4DelphiException.Create('zend_restore_ini_entry');
  if @zend_ini_long = nil then raise EPHP4DelphiException.Create('zend_ini_long');
  if @zend_ini_double = nil then raise EPHP4DelphiException.Create('zend_ini_double');
  if @zend_ini_string = nil then raise EPHP4DelphiException.Create('zend_ini_string');
  if @compile_string = nil then raise EPHP4DelphiException.Create('compile_string');
  if @execute = nil then raise EPHP4DelphiException.Create('execute');
  if @zend_wrong_param_count = nil then raise EPHP4DelphiException.Create('zend_wrong_param_count');
  if @add_property_long_ex = nil then raise EPHP4DelphiException.Create('add_property_long_ex');
  if @add_property_null_ex = nil then raise EPHP4DelphiException.Create('add_property_null_ex');
  if @add_property_bool_ex = nil then raise EPHP4DelphiException.Create('add_property_bool_ex');
  if @add_property_resource_ex = nil then raise EPHP4DelphiException.Create('add_property_resource_ex');
  if @add_property_double_ex = nil then raise EPHP4DelphiException.Create('add_property_double_ex');
  if @add_property_string_ex = nil then raise EPHP4DelphiException.Create('add_property_string_ex');
  if @add_property_stringl_ex = nil then raise EPHP4DelphiException.Create('add_property_stringl_ex');
  if @add_property_zval_ex = nil then raise EPHP4DelphiException.Create('add_property_zval_ex');
  if @call_user_function = nil then raise EPHP4DelphiException.Create('call_user_function');
  if @call_user_function_ex = nil then raise EPHP4DelphiException.Create('call_user_function_ex');
  if @add_assoc_long_ex = nil then raise EPHP4DelphiException.Create('add_assoc_long_ex');
  if @add_assoc_null_ex = nil then raise EPHP4DelphiException.Create('add_assoc_null_ex');
  if @add_assoc_bool_ex = nil then raise EPHP4DelphiException.Create('add_assoc_bool_ex');
  if @add_assoc_resource_ex = nil then raise EPHP4DelphiException.Create('add_assoc_resource_ex');
  if @add_assoc_double_ex = nil then raise EPHP4DelphiException.Create('add_assoc_double_ex');
  if @add_assoc_string_ex = nil then raise EPHP4DelphiException.Create('add_assoc_string_ex');
  if @add_assoc_stringl_ex = nil then raise EPHP4DelphiException.Create('add_assoc_stringl_ex');
  if @add_assoc_zval_ex = nil then raise EPHP4DelphiException.Create('add_assoc_zval_ex');
  if @add_index_long = nil then raise EPHP4DelphiException.Create('add_index_long');
  if @add_index_null = nil then raise EPHP4DelphiException.Create('add_index_null');
  if @add_index_bool = nil then raise EPHP4DelphiException.Create('add_index_bool');
  if @add_index_resource = nil then raise EPHP4DelphiException.Create('add_index_resource');
  if @add_index_double = nil then raise EPHP4DelphiException.Create('add_index_double');
  if @add_index_string = nil then raise EPHP4DelphiException.Create('add_index_string');
  if @add_index_stringl = nil then raise EPHP4DelphiException.Create('add_index_stringl');
  if @add_index_zval = nil then raise EPHP4DelphiException.Create('add_index_zval');
  if @add_next_index_long = nil then raise EPHP4DelphiException.Create('add_next_index_long');
  if @add_next_index_null = nil then raise EPHP4DelphiException.Create('add_next_index_null');
  if @add_next_index_bool = nil then raise EPHP4DelphiException.Create('add_next_index_bool');
  if @add_next_index_resource = nil then raise EPHP4DelphiException.Create('add_next_index_resource');
  if @add_next_index_double = nil then raise EPHP4DelphiException.Create('add_next_index_double');
  if @add_next_index_string = nil then raise EPHP4DelphiException.Create('add_next_index_string');
  if @add_next_index_stringl = nil then raise EPHP4DelphiException.Create('add_next_index_stringl');
  if @add_next_index_zval = nil then raise EPHP4DelphiException.Create('add_next_index_zval');
  if @add_get_assoc_string_ex = nil then raise EPHP4DelphiException.Create('add_get_assoc_string_ex');
  if @add_get_assoc_stringl_ex = nil then raise EPHP4DelphiException.Create('add_get_assoc_stringl_ex');
  if @add_get_index_long = nil then raise EPHP4DelphiException.Create('add_get_index_long');
  if @add_get_index_double = nil then raise EPHP4DelphiException.Create('add_get_index_double');
  if @add_get_index_string = nil then raise EPHP4DelphiException.Create('add_get_index_string');
  if @add_get_index_stringl = nil then raise EPHP4DelphiException.Create('add_get_index_stringl');
  if @_array_init = nil then raise EPHP4DelphiException.Create('_array_init');
  if @_object_init = nil then raise EPHP4DelphiException.Create('_object_init');
  if @_object_init_ex = nil then raise EPHP4DelphiException.Create('_object_init_ex');
  if @_object_and_properties_init = nil then raise EPHP4DelphiException.Create('_object_and_properties_init');
  if @zend_register_internal_class = nil then raise EPHP4DelphiException.Create('zend_register_internal_class');
  if @zend_register_internal_class_ex = nil then raise EPHP4DelphiException.Create('zend_register_internal_class_ex');
  if @get_zend_version = nil then raise EPHP4DelphiException.Create('get_zend_version');
  if @zend_make_printable_zval = nil then raise EPHP4DelphiException.Create('zend_make_printable_zval');
  if @zend_print_zval = nil then raise EPHP4DelphiException.Create('zend_print_zval');
  if @zend_print_zval_r = nil then raise EPHP4DelphiException.Create('zend_print_zval_r');
  if @zend_output_debug_string = nil then raise EPHP4DelphiException.Create('zend_output_debug_string');
  if @ZendGetParameters = nil then raise EPHP4DelphiException.Create('zend_get_parameters');
end;
{$ENDIF}

function zend_hash_get_current_data(ht: PHashTable; pData: Pointer): Integer; cdecl;
begin
  result := zend_hash_get_current_data_ex(ht, pData, nil);
end;

procedure zend_hash_internal_pointer_reset(ht: PHashTable); cdecl;
begin
  zend_hash_internal_pointer_reset_ex(ht, nil);
end;

function ts_resource(id : integer) : pointer;
begin
  result := ts_resource_ex(id, nil);
end;

function tsrmls_fetch : pointer;
begin
  result := ts_resource_ex(0, nil);
end;

{$IFDEF PHP4}
function zval_copy_ctor(val : pzval) : integer;
begin
  result := _zval_copy_ctor(val, nil, 0);
end;
{$ENDIF}

function zend_unregister_functions(functions : pzend_function_entry; count : integer; function_table : PHashTable; TSRMLS_DC : pointer) : integer;
var
 i : integer;
 ptr : pzend_function_entry;
begin
  Result := SUCCESS;
  i := 0;
  ptr := functions;
  if ptr = nil then
   Exit;
  while ptr.fname <> nil do
   begin
     if ( count <> -1 ) and (i >= count) then
      break;
      zend_hash_del_key_or_index(function_table, ptr.fname, strlen(ptr.fname) +1, 0, HASH_DEL_KEY);
      inc(ptr);
      inc(i);
   end;
end;

// registers all functions in *library_functions in the function hash

function zend_register_functions(functions : pzend_function_entry;  function_table : PHashTable; _type: integer;  TSRMLS_DC : pointer) : integer;
var
 ptr : pzend_function_entry;
 _function : zend_function;
 internal_function : PzendInternalFunction;
  count : integer;
  unload : integer;
  target_function_table : PHashTable;
  error_type : integer;

begin
 Result := FAILURE;
 if functions = nil then
  Exit;
  ptr := functions;
  count := 0;
  unload := 0;
  if _type = MODULE_PERSISTENT then
   error_type := E_CORE_WARNING
    else
      error_type := E_WARNING;

  internal_function := @_function;
  target_function_table  := function_table;

  if (target_function_table = nil) then
    target_function_table :=  GetCompilerGlobals.function_table;


  internal_function._type := ZEND_INTERNAL_FUNCTION;

  while (ptr.fname <> nil) do
    begin
      internal_function.handler := ptr.handler;
      internal_function.function_name := ptr.fname;
      if (internal_function.handler = nil) then begin
     	zend_error(error_type, 'Null function defined as active function');
	zend_unregister_functions(functions, count, target_function_table, TSRMLS_DC);
	Result := FAILURE;
        Exit;
       end;

     if (zend_hash_add_or_update(target_function_table, ptr.fname, strlen(ptr.fname)+1, @_function, sizeof(zend_function), nil, HASH_ADD) = FAILURE) then
       begin
         unload:=1;
         break;
       end;
      inc(ptr);
      inc(count);
     end;


     if (unload = 1) then begin  // before unloading, display all remaining bad function in the module */
	while (ptr.fname<> nil) do begin
          if (zend_hash_exists(target_function_table, ptr.fname, strlen(ptr.fname)+1)) = 1 then
          begin
            zend_error(error_type, PAnsiChar(Format('Function registration failed - duplicate name - %s', [ptr.fname])));
	  end;
	   inc(ptr);
	 end;
	 zend_unregister_functions(functions, count, target_function_table, TSRMLS_DC);
         result := FAILURE;
         Exit;
      end;
    Result := SUCCESS;

end;



function GetGlobalResource(resource_name: AnsiString) : pointer;
var
 global_id : pointer;
 global_value : integer;
 global_ptr   : pointer;
 tsrmls_dc : pointer;
begin
  Result := nil;
  try
    global_id := GetProcAddress(PHPLib, PAnsiChar(resource_name));
    if Assigned(global_id) then
     begin
       tsrmls_dc := tsrmls_fetch;
       global_value := integer(global_id^);
       asm
         mov ecx, global_value
         mov edx, dword ptr tsrmls_dc
         mov eax, dword ptr [edx]
         mov ecx, dword ptr [eax+ecx*4-4]
         mov global_ptr, ecx
       end;
       Result := global_ptr;
     end;
  except
    Result := nil;
  end;
end;


function GetCompilerGlobals : Pzend_compiler_globals;
begin
  result := GetGlobalResource('compiler_globals_id');
end;

function GetExecutorGlobals : pzend_executor_globals;
begin
  result := GetGlobalResource('executor_globals_id');
end;

function GetAllocGlobals : pointer;
begin
  result := GetGlobalResource('alloc_globals_id');
end;

{$IFDEF PHP5}

procedure zend_addref_p;
begin
    Inc(z.refcount);
end;

procedure my_class_add_ref;
begin
    Inc(aclass^^.refcount,1);
end;

procedure copy_zend_constant(C: PZendConstant); cdecl;
  var
  I: Integer;
begin
    C^.name := zend_strndup(C^.name, C^.name_len - 1);
    I := c^.flags and CONST_PERSISTENT;
    if I > 0 then
        _zval_copy_ctor(@c.value, nil, 0);
end;

function object_init(arg: pzval; ce: pzend_class_entry; TSRMLS_DC : pointer) : integer; cdecl; assembler;
asm
  mov eax, [esp + 16]
  mov ecx, [esp + 12]
  mov edx, [esp + 8]
  pop ebp
  push eax
  push ecx
  push edx
  call _object_init_ex
  add esp, $0c
  ret
end;


function Z_LVAL(z : pzval) : longint;
begin
  if z = nil then
  begin
      Result := 0;
      exit;
  end;

  if z._type = IS_LONG then
  Result := z.value.lval
  else
    case z._type of
       IS_DOUBLE: Result := Trunc(z.value.dval);
       IS_BOOL  : Result := z.value.lval;
       IS_STRING: Result := StrToIntDef( Z_STRVAL(z), 0 );
       else
          Result := 0;
    end;
end;

function Z_BVAL(z : pzval) : boolean;
begin
  if z = nil then
  begin
      Result := false;
      exit;
  end;

  if z._type = IS_BOOL then
     Result := zend_bool(z.value.lval)
  else
    case z._type of
       IS_DOUBLE: if Trunc(z.value.dval) = 0 then Result := false else Result := true;
       IS_LONG  : if z.value.lval = 0 then Result := false else Result := true;
       IS_STRING: if Z_STRVAL(z) = '' then Result := False else Result := True;
       else
          Result := False;
    end;
  //Result := zend_bool(z.value.lval);
end;

function Z_DVAL(z : pzval) : double;
begin
  if z = nil then
  begin
      Result := 0;
      exit;
  end;

  if z._type = IS_DOUBLE then
     Result := z.value.dval
  else
    case z._type of
       IS_LONG, IS_BOOL:  Result := z.value.lval;
       IS_STRING: Result := StrToFloatDef( Z_STRVAL(z), 0 );
       else
          Result := 0;
    end;
end;

function Z_VARREC(z: pzval): TVarRec;
  Var
  P: AnsiString;
begin
  if z = nil then
  begin
      Result.VType := vtBoolean;
      Result.VBoolean := false;
      exit;
  end;

    case z._type of
        IS_BOOL: begin
            Result.VType := vtBoolean;
            Result.VBoolean := Boolean(z.value.lval);
        end;
        IS_LONG: begin
            Result.VType := vtInteger;
            Result.VInteger := z.value.lval;
        end;
        IS_DOUBLE: begin
            Result.VType := vtExtended;
            New(Result.VExtended);
            Result.VExtended^ := z.value.dval;
        end;
        IS_STRING: begin
            Result.VType := vtAnsiString;

            SetLength(P, z.value.str.len);
            Move(z.value.str.val^, P[1], z.value.str.len);

            Result.VAnsiString := Pointer(P);
        end;
        else
        begin
            Result.VType := vtPointer;
            Result.VPointer := nil;
        end;
    end;
end;


function Z_STRVAL(z : pzval) : AnsiString;
begin
  if z = nil then
  begin
      Result := '';
      exit;
  end;

  if z._type = IS_STRING then
  begin
     SetLength(Result, z.value.str.len);
     Move(z.value.str.val^, Result[1], z.value.str.len);
  end else
    case z._type of
       IS_LONG: Result := IntToStr(z.value.lval);
       IS_DOUBLE: Result := FloatToStr(z.value.dval);
       IS_BOOL: if z.value.lval = 0 then Result := '' else Result := '1';
       else
        Result := '';
    end;
end;

function Z_STRLEN(z : pzval) : longint;
begin
  Result := Length(Z_STRVAL(z));
end;

function Z_ARRVAL(z : pzval ) : PHashTable;
begin
  Result := z.value.ht;
end;

function Z_OBJ_HANDLE(z :pzval) : zend_object_handle;
begin
  Result := z.value.obj.handle;
end;

function Z_OBJ_HT(z : pzval) : pzend_object_handlers;
begin
  Result := z.value.obj.handlers;
end;

function Z_OBJPROP(z : pzval) : PHashtable;
var
 TSRMLS_DC : pointer;
begin
  TSRMLS_DC := ts_resource_ex(0, nil);
  Result := Z_OBJ_HT(z)^.get_properties(@z, TSRMLS_DC);
end;


{$ENDIF}

{$IFDEF PHP5}
procedure  _zval_copy_ctor (val: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint);
begin
  if val^._type <= IS_BOOL then
   Exit
    else
      _zval_copy_ctor_func(val, __zend_filename, __zend_lineno);
end;

procedure _zval_dtor(val: pzval; __zend_filename: PAnsiChar; __zend_lineno: uint);
begin
  if val^._type <= IS_BOOL then
   Exit
     else
       _zval_dtor_func(val, __zend_filename, __zend_lineno);
end;

function zend_hash_init (ht : PHashTable; nSize : uint; pHashFunction : pointer; pDestructor : pointer; persistent: zend_bool) : integer;
begin
  Result := _zend_hash_init(ht, nSize, pHashFunction, pDestructor, persistent, nil, 0);
end;

function zend_hash_add_or_update(ht : PHashTable; arKey : PAnsiChar;
    nKeyLength : uint; pData : pointer; nDataSize : uint; pDes : pointer;
    flag : integer) : integer;
begin
  if Assigned(_zend_hash_add_or_update) then
   Result := _zend_hash_add_or_update(ht, arKey, nKeyLength, pData, nDataSize, pDes, flag, nil, 0)
     else
       Result := FAILURE;
end;

function zend_hash_init_ex (ht : PHashTable;  nSize : uint; pHashFunction : pointer;
 pDestructor : pointer;  persistent : zend_bool;  bApplyProtection : zend_bool): integer;
begin
  Result := _zend_hash_init_ex(ht, nSize, pHashFunction, pDestructor, persistent, bApplyProtection, nil, 0);
end;

{$ENDIF}


function AnsiFormat(const Format: AnsiString; const Args: array of const): AnsiString;
begin
   Result := Sysutils.Format(Format, Args);
end;

{$IFDEF COMPILER_VC9}
function  DupStr(strSource : PAnsiChar) : PAnsiChar; cdecl;
var
  P : PAnsiChar;
begin

  if (strSource = nil) then
     P := nil
       else
         begin
           P := StrNew(strSource);
         end;
  Result := P;
end;
{$ENDIF}

initialization
{$IFDEF PHP4DELPHI_AUTOLOAD}
  LoadZEND;
{$ENDIF}

finalization
{$IFDEF PHP4DELPHI_AUTOUNLOAD}
  UnloadZEND;
{$ENDIF}

end.


