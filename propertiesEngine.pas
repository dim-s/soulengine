unit propertiesEngine;

interface

uses
  SysUtils,
  Dialogs, Forms, Graphics, Classes, Controls, StdCtrls, TypInfo, Variants,
  mainLCL;

function setProperty(id: integer; prop: string; Value: variant): boolean;
function getProperty(id: integer; prop: string): variant;
function existProperty(id: integer; prop: string): boolean;
function getProperties(id: integer): string;

function getPropertyType(id: integer; prop: string): integer;

implementation


function setProperty(id: integer; prop: string; Value: variant): boolean;
var
  o: TObject;
  inf: PPropInfo;
begin
  try
    o := TObject(integer(id));
    inf := TypInfo.GetPropInfo(o, prop);
    if inf <> nil then
      SetPropValue(o, prop, Value);
  except
    on E: Exception do
    begin
      //ShowMessage(o.ClassName);
      //ShowMessage(E.Message);
      Result := False;
      exit;
    end;
  end;
  Result := inf <> nil;
end;

function getProperty(id: integer; prop: string): variant;
var
  o: TObject;
  inf: PPropInfo;
begin
  o := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o, prop);
  if inf <> nil then
    Result := GetPropValue(o, prop)
  else
    Result := Null;
end;

function getPropertyType(id: integer; prop: string): integer;
var
  o: TObject;
  inf: PPropInfo;
begin
  o := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o, prop);
  if inf <> nil then
    Result := integer(inf^.PropType^.Kind)
  else
    Result := -1;
end;

function existProperty(id: integer; prop: string): boolean;
var
  o: TObject;
  inf: PPropInfo;
begin
  o := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o, prop);
  Result := inf <> nil;
end;

function getProperties(id: integer): string;
var
  o: TObject;
  inf: PPropInfo;
  lst: PPropList;
  i: integer;
  res: TStrings;
begin
  o := TObject(integer(id));
  TypInfo.GetPropList(o, lst);
  res := TStringList.Create;
  i := 0;
  while True do
  begin
    inf := lst^[i];
    i := i + 1;
    if inf = nil then
      break;

    res.Add(inf^.Name);
  end;

  Result := res.Text;
  res.Free;
end;

end.
