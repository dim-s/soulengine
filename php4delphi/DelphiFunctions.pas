{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{*******************************************************}
{$I PHP.INC}

{ $Id: DelphiFunctions.pas,v 7.2 10/2009 delphi32 Exp $ }

unit DelphiFunctions;

interface
uses
  SysUtils, Classes,
  Controls,
  ZendTypes, ZendAPI, PHPTypes, PHPAPI, Dialogs, typinfo,
  Forms, stdctrls;

{$ifdef fpc}
   {$mode delphi}
{$endif}

var

 author_class_entry   : Tzend_class_entry;
 delphi_object_entry  : TZend_class_entry;

 object_functions    : array[0..2] of zend_function_entry;
 author_functions    : array[0..2] of zend_function_entry;

 DelphiObject : pzend_class_entry;
 ce           : pzend_class_entry;

 {$IFDEF PHP5}
 DelphiObjectHandlers : zend_object_handlers;
 {$ENDIF}


procedure RegisterInternalClasses(p : pointer);


//proto string delphi_get_system_directory(void)
{$IFDEF PHP510}
procedure delphi_get_system_directory(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_get_system_directory(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

//proto string delphi_str_date(void)
{$IFDEF PHP510}
procedure delphi_str_date(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_str_date(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

//proto float delphi_date(void)
{$IFDEF PHP510}
procedure delphi_date(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_date(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

//proto string delphi_extract_file_dir(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_dir(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_dir(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

//proto string delphi_extract_file_drive(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_drive(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_drive(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

//proto string delphi_extract_file_name(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_name(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_name(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

//proto string delphi_extract_file_ext(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_ext(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_ext(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

//proto void delphi_show_message(string message)
{$IFDEF PHP510}
procedure delphi_show_message(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_show_message(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

//proto string delphi_input_box(string caption, string prompt, string default)
{$IFDEF PHP510}
procedure delphi_input_box(ht : integer; return_value : pzval; return_value_ptr : ppzval;
        this_ptr : pzval;  return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_input_box(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

{$IFDEF PHP510}
procedure register_delphi_object(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure register_delphi_object(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

{$IFDEF PHP510}
procedure delphi_get_author(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_get_author(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

{$IFDEF PHP510}
procedure register_delphi_component(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure register_delphi_component(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

const
  SimpleProps = [tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString,  tkWChar, tkLString, tkWString,  tkVariant];

implementation



//proto string delphi_get_system_directory(void)
{$IFDEF PHP510}
procedure delphi_get_system_directory(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_get_system_directory(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin

end;

//proto string delphi_str_date(void)
{$IFDEF PHP510}
procedure delphi_str_date(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_str_date(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
  ZVAL_STRING(return_value, PAnsiChar(DateToStr(Date)), true);
end;

//proto float delphi_date(void)
{$IFDEF PHP510}
procedure delphi_date(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_date(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
  ZVAL_DOUBLE(return_value, Date);
end;

//proto string delphi_extract_file_dir(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_dir(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_dir(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin

end;

//proto string delphi_extract_file_drive(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_drive(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_drive(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin

end;

//proto string delphi_extract_file_name(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_name(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_name(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin

end;

//proto string delphi_extract_file_ext(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_ext(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_ext(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin

end;

//proto void delphi_show_message(string message)
{$IFDEF PHP510}
procedure delphi_show_message(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_show_message(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

begin

end;

//proto string delphi_input_box(string caption, string prompt, string default)
{$IFDEF PHP510}
procedure delphi_input_box(ht : integer; return_value : pzval; return_value_ptr : ppzval;
        this_ptr : pzval;  return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_input_box(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin

end;

//proto void delphi_send_message(void)
{$IFDEF PHP510}
procedure delphi_send_email(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_send_email(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
  //ShellExecute(0, 'open', 'mailto:serge_perevoznyk@hotmail.com', nil, nil, SW_SHOWNORMAL);
end;

//proto void delphi_visit_homepage(void)
{$IFDEF PHP510}
procedure delphi_visit_homepage(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_visit_homepage(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
  //ShellExecute(0, 'open', 'http://users.chello.be/ws36637', nil, nil, SW_SHOW);
end;


//Delphi objects support

{$IFDEF PHP510}
procedure delphi_object_classname(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_object_classname(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin

end;

{$IFDEF PHP510}
procedure delphi_object_classnameis(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_object_classnameis(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
end;



{$IFDEF PHP4}
function delphi_set_property_handler(property_reference : Pzend_property_reference; value : pzval) : integer; cdecl;
var
 this_ptr : pzval;
 OBJ : TObject;
 data: ^ppzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 p : pointer;
 propname : AnsiString;
// --> hupu, 2006.06.01
// pt : TTypeKind;
{$IFDEF VERSION7}
 Scripter : TPHPScriptableObject;
{$ELSE}
 pt : TypInfo.TTypeKind;
{$ENDIF}
// <-- hupu, 2006.06.01
begin
  element :=  property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  propname := prop^.element.value.str.val;

  this_ptr := property_reference^._object;
  new(data);
  zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data);
  Obj := TObject(data^^^.value.lval);
  freemem(data);

// --> hupu, 2006.06.01
{$IFDEF VERSION7}
  Scripter := TPHPScriptableObject(Obj);
  if SameText('Parent', propname) then
   begin
     TWinControl(Scripter.InstanceObj).Parent :=
     TWinControl(value^.value.lval);
   end
     else
       Scripter.SetPropertyByID(Scripter.NameToDispID(propname),
        [zval2variant(value^)] );
{$ELSE}
// <-- hupu, 2006.06.01

  pt := PropType(Obj, propname);
  if ( pt in SimpleProps) then
   SetPropValue(OBJ, propname, zval2variant(value^))
     else
       if pt = tkClass then
         begin
           Obj := GetObjectProp(Obj, propname);
            while element <> nil do
             begin
               element := element^.prev;
               p := @element^.data;
               prop := pzend_overloaded_element(p);
               propname := prop^.element.value.str.val;
               pt := PropType(Obj, propname);
               if ( pt in SimpleProps) then
                begin
                  SetPropValue(OBJ, propname, zval2variant(value^));
                  break;
                end
                 else
                   if pt = tkClass then
                    Obj := GetObjectProp(Obj, propname);
             end;
         end;

// --> hupu, 2006.06.01
{$ENDIF}
// <-- hupu, 2006.06.01
  Result := SUCCESS;
end;



procedure delphi_get_property_handler(val : pzval; property_reference : PZend_property_reference); cdecl;
var
 this_ptr : pzval;
 OBJ : TObject;
 data: ^ppzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 p : pointer;
 propname : AnsiString;
// --> hupu, 2006.06.01
// pt : TTypeKind;
{$IFDEF VERSION7}
 Scripter : TPHPScriptableObject;
{$ELSE}
 pt : TypInfo.TTypeKind;
{$ENDIF}
// <-- hupu, 2006.06.01
begin
  element :=  property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  propname := prop^.element.value.str.val;
  this_ptr := property_reference^._object;
  new(data);
  zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data);
  Obj := TObject(data^^^.value.lval);
  freemem(data);

// --> hupu, 2006.06.01
{$IFDEF VERSION7}
Scripter := TPHPScriptableObject(Obj);
if SameText('Parent', propname) then
begin
TWinControl(Scripter.InstanceObj).Parent :=
TWinControl(val^.value.lval);
end
else

Scripter.SetPropertyByID(Scripter.NameToDispID(propname),
[zval2variant(val^)] );
{$ELSE}
// <-- hupu, 2006.06.01
  pt := PropType(Obj, propname);
  if ( pt in SimpleProps) then
   variant2zval(GetPropValue(OBJ, propname), val)
     else
       if pt = tkClass then
         begin
           Obj := GetObjectProp(Obj, propname);
            while element <> nil do
             begin
               element := element^.prev;
               p := @element^.data;
               prop := pzend_overloaded_element(p);
               propname := prop^.element.value.str.val;
               pt := PropType(Obj, propname);
               if ( pt in SimpleProps) then
                begin
                  variant2zval(GetPropValue(OBJ, propname), val);
                  break;
                end
                 else
                   if pt = tkClass then
                    Obj := GetObjectProp(Obj, propname);
             end;
         end;
// --> hupu, 2006.06.01
{$ENDIF}
// <-- hupu, 2006.06.01
end;



procedure _delphi_get_property_wrapper; assembler;
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
  call        delphi_get_property_handler
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


procedure delphi_call_function(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer; property_reference : Pzend_property_reference ); cdecl;
var
 OBJ : TObject;
 data: ^ppzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 p : pointer;
 MethodName : AnsiString;
 Params : pzval_array;
 M, D : integer;
begin
  element :=  property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  MethodName := prop^.element.value.str.val;
  this_ptr := property_reference^._object;
  new(data);
  zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data);
  Obj := TObject(data^^^.value.lval);
  freemem(data);
  if ( Obj.InheritsFrom(TCustomEdit) ) then
   begin
     if SameText(MethodName, 'Clear') then
      TCustomEdit(Obj).Clear;
     if SameText(MethodName, 'ClearSelection') then
      TCustomEdit(Obj).ClearSelection;
     if SameText(MethodName, 'CopyToClipboard') then
      TCustomEdit(Obj).CopyToClipboard;
     if SameText(MethodName, 'ControlCount') then
      ZVAL_LONG(return_value, TCustomEdit(Obj).ControlCount);
     if SameText(MethodName, 'ScaleBy') then
        begin
          if ht > 0 then
           begin
             if ( not (zend_get_parameters_ex(ht, Params) = SUCCESS )) then
               begin
                 zend_wrong_param_count(TSRMLS_DC);
                 Exit;
               end;
            end;
          M := Params[0]^.value.lval;
          D := Params[1]^.value.lval;
          TCustomEdit(Obj).ScaleBy(M, D);
          dispose_pzval_array(Params);
        end;
   end;
end;
{$ENDIF}



{$IFDEF PHP5}

// Read object property value  (getter)
function delphi_get_property_handler(_object : pzval; member : pzval; _type : integer; TSRMLS_DC : pointer) : pzval; cdecl;
begin

end;

// Write object property value (setter)
procedure delphi_set_property_handler(_object : pzval; member : pzval; value : pzval; TSRMLS_DC : pointer); cdecl;
begin

end;

{$IFDEF PHP510}
function delphi_call_method(method : PAnsiChar; ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer) : integer; cdecl;
{$ELSE}
function delphi_call_method(method : PAnsiChar; ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer) : integer; cdecl;
{$ENDIF}
begin

end;

function delphi_get_method(_object : pzval; method_name : PAnsiChar; method_len : integer; TSRMLS_DC : pointer) : PzendFunction; cdecl;

begin

end;


{$ENDIF}

{$IFDEF PHP510}
procedure delphi_get_author(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_get_author(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 properties : array[0..3] of PAnsiChar;
begin
  properties[0] := 'name';
  properties[1] := 'last';
  properties[2] := 'height';
  properties[3] := 'email';
  {$IFDEF PHP4}
  _object_init_ex(return_value, ce,  nil, 0, TSRMLS_DC );
  {$ELSE}
  object_init(return_value, ce,  TSRMLS_DC );
  {$ENDIF}

  {$IFDEF PHP4}
  add_property_string_ex(return_value, properties[0], strlen(properties[0]) + 1, 'Serhiy', 1);
  add_property_string_ex(return_value, properties[1], strlen(properties[1]) + 1, 'Perevoznyk', 1);
  {$ELSE}
  add_property_string_ex(return_value, properties[0], strlen(properties[0]) + 1, 'Serhiy', 1, TSRMLS_DC);
  add_property_string_ex(return_value, properties[1], strlen(properties[1]) + 1, 'Perevoznyk', 1, TSRMLS_DC);
  {$ENDIF}

  {$IFDEF PHP5}
  add_property_long_ex(return_value, properties[2], strlen(properties[2]) + 1, 185, TSRMLS_DC);
  {$ELSE}
  add_property_long_ex(return_value, properties[2], strlen(properties[2]) + 1, 185);
  {$ENDIF}

  {$IFDEF PHP4}
  add_property_string_ex(return_value, properties[3], strlen(properties[3]) + 1, 'serge_perevoznyk@hotmail.com', 1);
  {$ELSE}
  add_property_string_ex(return_value, properties[3], strlen(properties[3]) + 1, 'serge_perevoznyk@hotmail.com', 1, TSRMLS_DC);
  {$ENDIF}
end;




{$IFDEF PHP510}
procedure register_delphi_object(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure register_delphi_object(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

begin

end;

{$IFDEF PHP510}
procedure register_delphi_component(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure register_delphi_component(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

begin


end;



procedure RegisterInternalClasses(p : pointer);

begin
  object_functions[0].fname := 'delphi_classname';
  object_functions[0].handler := @delphi_object_classname;

  object_functions[1].fname := 'delphi_classnameis';
  object_functions[1].handler := @delphi_object_classnameis;

  object_functions[2].fname := nil;
  object_functions[2].handler := nil;

  INIT_CLASS_ENTRY(delphi_object_entry, 'delphi_class' , @object_functions);

  {$IFDEF PHP4}
  Delphi_Object_Entry.handle_property_get :=  @_delphi_get_property_wrapper;
  Delphi_Object_Entry.handle_property_set := @delphi_set_property_handler;
  Delphi_Object_Entry.handle_function_call :=  @delphi_call_function;
  {$ELSE}
  Move(zend_get_std_object_handlers()^, DelphiObjectHandlers, sizeof(zend_object_handlers));
  DelphiObjectHandlers.read_property := @delphi_get_property_handler;
  DelphiObjecthandlers.write_property := @delphi_set_property_handler;
  DelphiObjectHandlers.call_method := @delphi_call_method;
  DelphiObjectHandlers.get_method := @delphi_get_method;
  {$ENDIF}

  DelphiObject := zend_register_internal_class(@delphi_object_entry, p);

  author_functions[0].fname := 'send_email';
  author_functions[0].handler := @delphi_send_email;

  author_functions[1].fname := 'visit_homepage';
  author_functions[1].handler := @delphi_visit_homepage;

  author_functions[2].fname := nil;
  author_functions[2].handler := nil;
  INIT_CLASS_ENTRY(author_class_entry, 'php4delphi_author', @author_functions);
  ce := zend_register_internal_class(@author_class_entry, p);

end;

{$IFDEF VERSION7}

{
Delphi scripting support

The Original Code is: JvOle2Auto.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
All Rights Reserved.
}


function WashVariant(const Value: Variant): OleVariant;
begin
  if TVarData(Value).VType = (varString or varByRef) then
    Result := PString(TVarData(VAlue).VString)^ + ''
  else
    Result := Value;
end;



{$ENDIF}

end.
