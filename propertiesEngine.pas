unit propertiesEngine;

interface

  Uses
    SysUtils,
    Dialogs, Forms, Graphics, Classes, Controls, StdCtrls, TypInfo, Variants,
    mainLCL;

    function setProperty(id: integer; prop: string; value: variant): boolean;
    function getProperty(id: integer; prop: string): Variant;
    function existProperty(id: integer; prop: string): Boolean;
    function getProperties(id: integer): String;

    function getPropertyType(id: integer; prop: string): Integer;

implementation


function setProperty(id: integer; prop: string; value: variant): boolean;
  var
  o: tobject;
  inf: PPropInfo;
  typ: TTypeKind;
begin
try
  o   := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o,prop);
  if inf <> nil then
    SetPropValue(o,prop,value);
except
  on E: Exception do
  begin
    //ShowMessage(o.ClassName);
    //ShowMessage(E.Message);
    Result := false;
    exit;
  end;
end;
  Result := inf <> nil;
end;

function getProperty(id: integer; prop: string): Variant;
  var
  o: tobject;
  inf: PPropInfo;
begin
  o   := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o,prop);
  if inf <> nil then
    Result := GetPropValue(o,prop)
  else
    Result := Null;
end;

function getPropertyType(id: integer; prop: string): Integer;
  var
  o: tobject;
  inf: PPropInfo;
begin
  o   := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o,prop);
  if inf <> nil then
    Result := integer(inf^.PropType^.Kind)
  else
    Result := -1;
end;

function existProperty(id: integer; prop: string): Boolean;
  var
  o: tobject;
  inf: PPropInfo;
begin
  o   := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o,prop);
  Result := inf <> nil;
end;

function getProperties(id: integer): String;
  var
  o: tobject;
  inf: PPropInfo;
  lst: PPropList;
  i: integer;
  res: TStrings;
begin
  o   := TObject(integer(id));
  TypInfo.GetPropList(o,lst);
  res := TStringList.Create;
  while True do
    begin
        inf := lst^[i];
        if inf = nil then
          break;

        res.Add(inf^.Name);
    end;

  Result := res.Text;
  res.Free;
end;

end.
