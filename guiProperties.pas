unit guiProperties;

{$ifdef fpc}
{$mode delphi}{$H+}
{$endif}

interface

uses
  Classes, SysUtils,

  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  phpUtils,
  php4delphi,

  propertiesEngine;

  procedure InitializeGuiProperties(PHPEngine: TPHPEngine);

  procedure regConstant();

  procedure gui_propGet(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_propType(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_propExists(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_propList(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_propSet(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_propSet2(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;


implementation


procedure regConstant();
begin
    regConstList(['tkUnknown','tkInteger','tkChar','tkEnumeration','tkFloat',
                   'tkSet','tkMethod','tkSString','tkLString','tkAString',
                   'tkWString','tkVariant','tkArray','tkRecord','tkInterface',
                   'tkClass','tkObject','tkWChar','tkBool','tkInt64','tkQWord',
                   'tkDynArray','tkInterfaceRaw','tkProcVar','tkUString','tkUChar']);
end;

procedure gui_propGet;
var p : pzval_array;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  variant2zval( getProperty(Z_LVAL(p[0]^), Z_STRVAL(p[1]^)), return_value );
            
  dispose_pzval_array(p);
  {
  if not checkPrs(ht,2,TSRMLS_DC) then exit; if not checkPrs2(ht,p,TSRMLS_DC) then exit;

  readPrs(p, ht);
  variant2zval(getProperty(prs[0],prs[1]), return_value);
  dispose_pzval_array(p); }
end;


procedure gui_propType;
var p : pzval_array;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_LONG(return_value, getPropertyType(Z_LVAL(p[0]^), Z_STRVAL(p[1]^)));

  dispose_pzval_array(p);
  {
  if not checkPrs(ht,2,TSRMLS_DC) then exit; if not checkPrs2(ht,p,TSRMLS_DC) then exit;

  readPrs(p, ht);
  variant2zval(getPropertyType(prs[0],prs[1]), return_value);
  dispose_pzval_array(p); }
end;

procedure gui_propExists;
var p : pzval_array;
begin
 if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_BOOL(return_value, existProperty(Z_LVAL(p[0]^), Z_STRVAL(p[1]^)));

  dispose_pzval_array(p);
  {
   if not checkPrs(ht,2,TSRMLS_DC) then exit; if not checkPrs2(ht,p,TSRMLS_DC) then exit;

   readPrs(p, ht);
   variant2zval(existProperty(prs[0],prs[1]), return_value);
   dispose_pzval_array(p);    }
end;

procedure gui_propList;
var p : pzval_array;
begin
if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_STRING( return_value, PAnsiChar(getProperties(Z_LVAL(p[0]^))), true );

  dispose_pzval_array(p);
   {
  if not checkPrs(ht,1,TSRMLS_DC) then exit; if not checkPrs2(ht,p,TSRMLS_DC) then exit;

  readPrs(p, ht);
  variant2zval(getProperties(prs[0]), return_value);
  dispose_pzval_array(p); }
end;


procedure gui_propSet;
  var p: pzval_array;
begin
  if ht < 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  if p[2]^^._type in [IS_LONG, IS_BOOL, IS_DOUBLE, IS_STRING] then
    ZVAL_BOOL(return_value, setProperty( Z_LVAL(p[0]^), Z_STRVAL(p[1]^),
            zval2variant(p[2]^^)));
            
  dispose_pzval_array(p);
end;

procedure gui_propSet2;
  var p: pzval_array;
begin
  {if ht < 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);
                           0

  if p[2]^^._type in [IS_LONG, IS_BOOL, IS_DOUBLE, IS_STRING] then
    ZVAL_BOOL(return_value, setProperty( Z_LVAL(p[0]^), Z_STRVAL(p[1]^),
            zval2variant(p[2]^^)));

  dispose_pzval_array(p);  }
end;

procedure InitializeGuiProperties(PHPEngine: TPHPEngine);
begin
  PHPEngine.AddFunction('gui_propGet', @gui_propGet);
  PHPEngine.AddFunction('gui_propType', @gui_propType);
  PHPEngine.AddFunction('gui_propExists', @gui_propExists);
  PHPEngine.AddFunction('gui_propList', @gui_propList);
  PHPEngine.AddFunction('gui_propSet', @gui_propSet);
  //PHPEngine.AddFunction('gui_propSet2', @gui_propSet2);
end;


end.

