unit phpUtils;

interface

uses
  SysUtils,
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  Variants;

type
  TArrayString = array of string;
  TArrayVariant = array of variant;

var
  tmpAR: TArrayVariant;
  tmpAR2: TArrayString;
  MT: TMethod;

var
  prs: TArrayVariant;

function readPr(param: pzval_array; index: integer): variant;
procedure readPrs(param: pzval_array; ht: integer);
function checkPrs(ht, Count: integer; var TSRMLS_DC: pointer): boolean;
function checkPrs2(ht: integer; var Param: pzval_array;
  var TSRMLS_DC: pointer): boolean;
procedure regConstL(Name: string; Value: integer);
procedure regConstD(Name: string; Value: double);
procedure regConstS(Name: string; Value: string);
procedure regConstList(Names: array of string; From: integer = 0);
procedure evalCode(Code: string);


implementation


procedure regConstList(Names: array of string; From: integer = 0);
var
  i: integer;
begin
  for i := 0 to high(Names) do
    regConstL(Names[i], i + from);
end;

procedure regConstL(Name: string; Value: integer);
begin
  REGISTER_MAIN_LONG_CONSTANT(PChar(Name), Value, 0, ts_resource(0));
end;

procedure regConstD(Name: string; Value: double);
begin
  REGISTER_MAIN_DOUBLE_CONSTANT(PChar(Name), Value, 0, ts_resource(0));
end;

procedure regConstS(Name: string; Value: string);
begin
  REGISTER_MAIN_STRING_CONSTANT(PChar(Name), PChar(Value), 0, ts_resource(0));
end;

procedure evalCode(Code: string);
begin
  zend_eval_string(PChar(Code), nil, 'eval code', ts_resource(0));
end;


function readPr(param: pzval_array; index: integer): variant;
begin
  Result := zval2variant(param[index]^^);
end;

procedure readPrs(param: pzval_array; ht: integer);
var
  i: integer;
begin
  SetLength(prs, 0);
  SetLength(prs, ht);
  for i := 0 to ht - 1 do
    prs[i] := readPr(param, i);
end;


function checkPrs(ht, Count: integer; var TSRMLS_DC: pointer): boolean;
begin
  Result := True;
  if ht < Count then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Result := False;
  end;
end;

function checkPrs2(ht: integer; var Param: pzval_array; var TSRMLS_DC: pointer): boolean;
begin
  Result := True;
  if (not (zend_get_parameters_ex(ht, Param) = SUCCESS)) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Result := False;
  end;
end;


end.
