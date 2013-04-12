{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
{$I PHP.INC}

{ $Id: zend_dynamic_array.pas,v 7.2 10/2009 delphi32 Exp $ } 

unit zend_dynamic_array;

interface
  uses
    Windows, SysUtils;

type


   dynamic_array = record
        _array : PAnsiChar;
        element_size : UINT;
        current : UINT;
        allocated : UINT;
   end;

   TDynamicArray = dynamic_array;
   PDynamicArray = ^TDynamicArray;

function zend_dynamic_array_init(da : PDynamicArray; element_size : UINT; size: UINT) : integer; cdecl;
function zend_dynamic_array_push(da : PDynamicArray) : pointer; cdecl;
function zend_dynamic_array_pop(da : PDynamicArray) : pointer; cdecl;
function zend_dynamic_array_get_element(da : PDynamicArray; index: UINT) : pointer; cdecl;

implementation

function zend_dynamic_array_init(da : PDynamicArray; element_size : UINT; size: UINT) : integer; cdecl;
begin
  da^.element_size := element_size;
  da^.allocated := size;
  da^.current := 0;
  da^._array :=  AllocMem(size*element_size);
  if (da^._array = nil) then
   Result := 1
     else
       Result := 0;
end;


function zend_dynamic_array_push(da : PDynamicArray) : pointer; cdecl;
begin
  if (da^.current = da^.allocated) then
   begin
     da^.allocated := da^.Allocated * 2;
     da^._array := ReallocMemory (da^._array, da^.allocated*da^.element_size);
   end;
    Result := da^._array + (da^.current)*da^.element_size;
    inc(da^.current);
end;

function zend_dynamic_array_pop(da : PDynamicArray) : pointer; cdecl;
begin
  dec(da^.current);
  Result := da^._array + (da^.current)*da^.element_size;
end;

function zend_dynamic_array_get_element(da : PDynamicArray; index: UINT) : pointer; cdecl;
begin
  if (index >= da^.current) then
    result := nil
      else
        Result := da^._array+index*da^.element_size;
end;

end.
