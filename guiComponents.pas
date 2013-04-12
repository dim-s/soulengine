unit guiComponents;

{$ifdef fpc}
{$mode delphi}{$H+}
{$endif}

interface

uses
  Classes, SysUtils, phpUtils, Forms, regGUI,  Controls, windows,
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,

  php4delphi,
  uPhpEvents,

  pngimage, Graphics, dsStdCtrl
  ;

  procedure InitializeGuiComponents(PHPEngine: TPHPEngine);

  procedure gui_registerSuperGlobal(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

  procedure gui_hi(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_lo(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_uchr(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

  procedure gui_parent(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_owner(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_create(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_destroy(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_safeDestroy(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_class(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_is(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_writeStr(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_readStr(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;


  procedure gui_getHandle(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_setFocus(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_isFocused(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;


  procedure gui_repaint(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_toBack(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_toFront(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

  procedure gui_doubleBuffer(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_listGetFont(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_listClearFont(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

  procedure gui_listSetColor(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_listGetColor(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;



  procedure gui_threadCriticalCreate(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadCriticalEnter(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadCriticalLeave(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadCriticalDestroy(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;


  procedure gui_threadGetCount(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadSetMax(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadGetMax(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadCreate(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadPriority(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

  procedure gui_threadTerminate(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

  procedure gui_threadResume(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadSuspend(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadFree(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadBeforeCode(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadSynchronize(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadData(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadDataIsset(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure gui_threadDataUnset(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

   procedure gui_btnPNGLoadStr(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
   procedure gui_btnPNGLoadFile(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
   procedure gui_btnPNGGetStr(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
   procedure gui_btnPNGAssign(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
   procedure gui_btnPngIsEmpty(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

implementation

procedure gui_registerSuperGlobal;
  var p: pzval_array;
  Name: AnsiString;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  Name := Z_STRVAL(p[0]^);

  ZVAL_LONG(return_value, zend_register_auto_global(PAnsiChar(Name), Length(Name), nil, nil));

  dispose_pzval_array(p);
end;

procedure gui_hi;
  var p: pzval_array;
  id: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  id := Z_LVAL(p[0]^);
  ZVAL_LONG(return_value, hi(id));

  dispose_pzval_array(p);
end;

procedure gui_lo;
  var p: pzval_array;
  id: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  id := Z_LVAL(p[0]^);
  ZVAL_LONG(return_value, lo(id));

  dispose_pzval_array(p);
end;

procedure gui_uchr;
  var p: pzval_array;
  id: Integer;
  SW: WideString;
  S: AnsiString;
  CH: UTF8String;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  id := Z_LVAL(p[0]^);

  SW := WideChar(id);
  CH := UTF8Encode(SW);

  S := CH;

  ZVAL_STRINGL(return_value, PAnsiChar(S), Length(S), true);

  dispose_pzval_array(p);
end;




procedure gui_destroy;
  var p: pzval_array;
  id: Integer;
  s: AnsiString;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  id := Z_LVAL(p[0]^);
  if (id <> 0) and (TObject(ID) is TObject) then
  begin
     FreeEventController( TObject(id) );
     s := tobject(id).ClassName;
     TObject(id).Free;
     ZVAL_BOOL( return_value, true );
  end
  else
     ZVAL_BOOL( return_value, false );

  dispose_pzval_array(p);
end;

procedure gui_safeDestroy;
  var p: pzval_array;
  id: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  id := Z_LVAL(p[0]^);
  if (id <> 0) then
  begin
     TScriptSafeCommand_Destroy.Create( TObject(ID) );
     ZVAL_BOOL( return_value, true );
  end
  else
     ZVAL_BOOL( return_value, false );

  dispose_pzval_array(p);
end;

procedure gui_create;
  var p: pzval_array;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  variant2zval(regGUI.createComponent( Z_STRVAL(p[0]^), Z_LVAL(p[1]^)), return_value);

  dispose_pzval_array(p);
end;

procedure gui_parent;
  var p: pzval_array;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  variant2zval(regGUI.parentControl(Z_LVAL(p[0]^), Z_LVAL(p[1]^)), return_value);

  dispose_pzval_array(p);
end;

procedure gui_owner;
  var p: pzval_array;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  variant2zval(regGUI.ownerComponent(Z_LVAL(p[0]^)), return_value);

  dispose_pzval_array(p);
end;

procedure gui_getHandle;
  var p: pzval_array;
  id: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  id := Z_LVAL(p[0]^);
  if TObject(id) is TWinControl then
     ZVAL_LONG( return_value, TWinControl(id).Handle )
  else
     ZVAL_LONG( return_value, 0 );

  dispose_pzval_array(p);
end;

procedure gui_class;
  var p: pzval_array;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  variant2zval(regGUI.objectClass(Z_LVAL(p[0]^)), return_value);

  dispose_pzval_array(P);
end;

procedure gui_is;
  var p: pzval_array;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);


  variant2zval(regGUI.objectIs(Z_LVAL(p[0]^), Z_STRVAL(p[1]^)), return_value);

  dispose_pzval_array(P);
end;


procedure gui_writeStr;
  var p: pzval_array;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  variant2zval(regGUI.ComponentToString(Z_LVAL(p[0]^)), return_value);

  dispose_pzval_array(p);
end;

procedure gui_readStr;
  var p: pzval_array;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  regGUI.StringToComponent(Z_LVAL(p[0]^), Z_STRVAL(p[1]^));

  dispose_pzval_array(p);
end;

procedure gui_repaint;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TControl) then
      TControl(ID).Repaint;

  dispose_pzval_array(p);
end;

procedure gui_setFocus;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TWinControl) then
  begin
     with TWinControl(ID) do
     begin
      if (Visible and Enabled) and (Parent.Visible and Parent.Enabled) then
        SetFocus;

     end;
  end;


  dispose_pzval_array(p);
end;

procedure gui_isFocused;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TWinControl) then
  begin
      if TObject(ID) is TForm then
      begin
        
      end else
        ZVAL_BOOL( return_value, TWinControl(Pointer(ID)).Focused )
  end else
      ZVAL_NULL( return_value );

  dispose_pzval_array(p);
end;

procedure gui_toBack;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TControl) then
      TControl(ID).SendToBack;

  dispose_pzval_array(p);
end;

procedure gui_toFront;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TControl) then
      TControl(ID).BringToFront;

  dispose_pzval_array(p);
end;

procedure gui_doubleBuffer;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TWinControl) then
  begin
      if ht = 1 then
        ZVAL_BOOL( return_value, TWinControl(ID).DoubleBuffered )
      else
        TWinControl(ID).DoubleBuffered := Z_BVAL(p[1]^);
  end;

  dispose_pzval_array(p);
end;

procedure gui_listSetColor;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TWinControl) then
  begin
     dsStdCtrl.TListBox(ID).SetColor(Z_LVAL(p[1]^), TColor(Z_LVAL(p[2]^)));
  end;

  dispose_pzval_array(p);
end;



procedure gui_listGetColor;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TWinControl) then
  begin
      ZVAL_LONG( return_value, Integer(dsStdCtrl.TListBox(ID).GetColor(Z_LVAL(p[1]^))) )
  end;

  dispose_pzval_array(p);
end;

procedure gui_listGetFont;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TWinControl) then
  begin
      ZVAL_LONG( return_value, Integer(dsStdCtrl.TListBox(ID).GetFont(Z_LVAL(p[1]^))) )
  end;

  dispose_pzval_array(p);
end;

procedure gui_listClearFont;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TWinControl) then
  begin
      dsStdCtrl.TListBox(ID).ClearFont(Z_LVAL(p[1]^));
  end;

  dispose_pzval_array(p);
end;




procedure gui_threadCriticalCreate;
 var
  C: PRTLCriticalSection;
  p: pzval_array;
begin
  if ht < 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  New(C);
  InitializeCriticalSection(C^);

  ZVAL_LONG(return_value, Integer(C));

  dispose_pzval_array(p);
end;

procedure gui_threadCriticalEnter;
 var
  C: PRTLCriticalSection;
  p: pzval_array;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  C := PRTLCriticalSection( Z_LVAL(p[0]^) );
  if C <> nil then
  begin
    EnterCriticalSection(C^);
  end;

  dispose_pzval_array(p);
end;

procedure gui_threadCriticalLeave;
 var
  C: PRTLCriticalSection;
  p: pzval_array;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  C := PRTLCriticalSection( Z_LVAL(p[0]^) );
  if C <> nil then
  begin
    LeaveCriticalSection(C^);
  end;

  dispose_pzval_array(p);
end;

procedure gui_threadCriticalDestroy;
 var
  C: PRTLCriticalSection;
  p: pzval_array;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  C := PRTLCriticalSection( Z_LVAL(p[0]^) );
  if C <> nil then
  begin
    DeleteCriticalSection(C^);
    Dispose(C);
  end;

  dispose_pzval_array(p);
end;

procedure gui_threadCreate;
begin
   ZVAL_LONG( return_value, Integer(ScriptThreadCreate()) );
end;

procedure gui_threadGetCount;
begin
   ZVAL_LONG( return_value, GetCntThreads );
end;

procedure gui_threadGetMax;
begin
   ZVAL_LONG( return_value, GetMaxCntThreads );
end;

procedure gui_threadSetMax;
 var
  p: pzval_array;
 begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  SetMaxCntThreads( Z_LVAL(p[1]^) );

  dispose_pzval_array(p);
end;

procedure gui_threadPriority;
  var p: pzval_array;
  ID: Integer;
  S: AnsiString;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
     if ht > 1 then
       TScriptThread(ID).FThread.Priority := TThreadPriority( Z_LVAL(p[1]^) )
     else begin
       ZVAL_LONG(return_value, Integer(TScriptThread(ID).FThread.Priority));
     end;
  end;

  dispose_pzval_array(p);
end;

procedure gui_threadTerminate;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
       TScriptThread(ID).FThread.Terminate;
  end;

  dispose_pzval_array(p);
end;

procedure gui_threadBeforeCode;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  TScriptThread.SetBeforeCode( Z_STRVAL(p[0]^) );

    dispose_pzval_array(p);
end;

procedure gui_threadSynchronize;
  var p: pzval_array;
  ID: Integer;
  Func: pzval;
begin
  if ht < 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
     TScriptThread(ID).Sync( Z_STRVAL(p[1]^), Z_STRVAL(p[2]^) );
  end;

  dispose_pzval_array(p);
end;

procedure gui_threadData;
  var p: pzval_array;
  ID: Integer;
  S: AnsiString;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
     if ht > 2 then
       TScriptThread(ID).addDATA.SetValue(Z_STRVAL(p[1]^), Z_STRVAL(p[2]^))
     else begin
       S := TScriptThread(ID).addDATA.Get(Z_STRVAL(p[1]^));
       ZVAL_STRINGL(return_value, PAnsiChar(S), Length(S), true );
     end;
  end;

  dispose_pzval_array(p);
end;

procedure gui_threadDataIsset;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
       ZVAL_BOOL(return_value, TScriptThread(ID).addDATA.HasKey(Z_STRVAL(p[1]^)));
  end;

  dispose_pzval_array(p);
end;

procedure gui_threadDataUnset;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  ZVAL_BOOL(return_value, false);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
       ZVAL_BOOL(return_value, true);
       TScriptThread(ID).addDATA.RemoveKey(Z_STRVAL(p[1]^));
  end;

  dispose_pzval_array(p);
end;


procedure gui_threadResume;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
     TScriptThread(ID).Resume;
  end;
    dispose_pzval_array(p);
end;

procedure gui_threadSuspend;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
   // TThread(a).()
     TScriptThread(ID).Suspend;
  end;
    dispose_pzval_array(p);
end;


procedure gui_threadFree(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  var p: pzval_array;
  ID: Integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ID := Z_LVAL(p[0]^);
  if (ID <> 0) and (TObject(ID) is TScriptThread) then
  begin
    TScriptSafeCommand_ThreadDestroy.Create( Pointer(ID) );
  end;
    dispose_pzval_array(p);
end;


procedure gui_btnPNGLoadStr;
  var
  p: pzval_array;
  O: TObject;
  M: TStringStream;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  O := TObject(Z_LVAL(p[0]^));
    if O <> nil then
    begin
        M := TStringStream.Create( Z_STRVAL(p[1]^) );
        {if O is TPngSpeedButton then
          TPngSpeedButton(O).PngImage.LoadFromStream(M)
        else if O is TPngBitBtn then
          TPngBitBtn(O).PngImage.LoadFromStream(M);}
        M.Free;
    end;
    dispose_pzval_array(p);
end;

procedure gui_btnPNGLoadFile;
  var
  p: pzval_array;
  O: TObject;
  S: string;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  O := TObject(Z_LVAL(p[0]^));
  S := Z_STRVAL(p[1]^);
  
    if O <> nil then
    begin
        {if O is TPngSpeedButton then
          TPngSpeedButton(O).PngImage.LoadFromFile(S)
        else if O is TPngBitBtn then
          TPngBitBtn(O).PngImage.LoadFromFile(S); }
    end;
    dispose_pzval_array(p);
end;

procedure gui_btnPNGGetStr;
  var
  p: pzval_array;
  O: TObject;
  S: TStringStream;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  O := TObject(Z_LVAL(p[0]^));
  S := TStringStream.Create(#0);
    if O <> nil then
    begin
       { if O is TPngSpeedButton then
          TPngSpeedButton(O).PngImage.SaveToStream(S)
        else if O is TPngBitBtn then
          TPngBitBtn(O).PngImage.SaveToStream(S);  }
    end;

  ZVAL_STRINGL(return_value, PAnsiChar(S.DataString), S.Size, True);
  S.Free;
    dispose_pzval_array(p);
end;

procedure gui_btnPngIsEmpty;
  var
  p: pzval_array;
  O: TObject;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  O := TObject(Z_LVAL(p[0]^));
  ZVAL_BOOL(return_value,false);
  
    if O <> nil then
    begin        
        {if O is TPngSpeedButton then
          ZVAL_BOOL(Return_value, not TPngSpeedButton(O).PngImage.Empty)
        else if O is TPngBitBtn then
          ZVAL_BOOL(Return_value, not TPngBitBtn(O).PngImage.Empty);}
    end;

    dispose_pzval_array(p);
end;



procedure gui_btnPNGAssign;
  var
  p: pzval_array;
  O, D: TObject;
  label _exit;
begin
  if ht < 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  O := TObject(Z_LVAL(p[0]^));
  D := TObject(Z_LVAL(p[1]^));

    if (O <> nil) and (D <> nil) then
    begin
        if D is TPicture then
        begin
          if TPicture(D).Graphic is TPNGObject then
          begin

              {if O is TPngSpeedButton then
              begin
                 TPngSpeedButton(O).PngImage.Assign(TPicture(D).Graphic);
                 TPngSpeedButton(O).Refresh;
              end
              else if O is TPngBitBtn then
                 TPngBitBtn(O).PngImage.Assign(TPicture(D).Graphic);  }

             ZVAL_TRUE(return_value);
             goto _exit;
          end;
        end;
    end;
    ZVAL_FALSE(return_value);

    _exit:
    dispose_pzval_array(p);
end;

procedure InitializeGuiComponents(PHPEngine: TPHPEngine);
begin
  //PHPEngine.AddFunction('hi', @gui_hi);
  //PHPEngine.AddFunction('lo', @gui_lo);


  PHPEngine.AddFunction('u8chr', @gui_uchr);
  PHPEngine.AddFunction('gui_registerSuperGlobal', @gui_registerSuperGlobal);


  PHPEngine.AddFunction('gui_create', @gui_create);
  PHPEngine.AddFunction('gui_destroy', @gui_destroy);
  PHPEngine.AddFunction('gui_safeDestroy', @gui_safeDestroy);
  PHPEngine.AddFunction('gui_parent', @gui_parent);
  PHPEngine.AddFunction('gui_owner', @gui_owner);
  PHPEngine.AddFunction('gui_class', @gui_class);
  PHPEngine.AddFunction('gui_is', @gui_is);
  PHPEngine.AddFunction('gui_writeStr', @gui_writeStr);
  PHPEngine.AddFunction('gui_readStr', @gui_readStr);

  PHPEngine.AddFunction('gui_getHandle', @gui_getHandle);
  PHPEngine.AddFunction('gui_setFocus', @gui_setFocus);
  PHPEngine.AddFunction('gui_isFocused', @gui_isFocused);

  PHPEngine.AddFunction('gui_repaint', @gui_repaint);
  PHPEngine.AddFunction('gui_toFront', @gui_toFront);
  PHPEngine.AddFunction('gui_toBack', @gui_toBack);

  PHPEngine.AddFunction('gui_doubleBuffer', @gui_doubleBuffer);

  PHPEngine.AddFunction('gui_listGetFont', @gui_listGetFont);
  PHPEngine.AddFunction('gui_listClearFont', @gui_listClearFont);

  PHPEngine.AddFunction('gui_listSetColor', @gui_listSetColor);
  PHPEngine.AddFunction('gui_listGetColor', @gui_listGetColor);

  PHPEngine.AddFunction('gui_criticalCreate', @gui_threadCriticalCreate);
  PHPEngine.AddFunction('gui_criticalEnter', @gui_threadCriticalEnter);
  PHPEngine.AddFunction('gui_criticalLeave', @gui_threadCriticalLeave);
  PHPEngine.AddFunction('gui_criticalDestroy', @gui_threadCriticalDestroy);

  PHPEngine.AddFunction('gui_threadCreate', @gui_threadCreate);
  PHPEngine.AddFunction('gui_threadPriority', @gui_threadPriority);
  PHPEngine.AddFunction('gui_threadTerminate', @gui_threadTerminate);
  PHPEngine.AddFunction('gui_threadBeforeCode', @gui_threadBeforeCode);
  PHPEngine.AddFunction('gui_threadResume', @gui_threadResume);
  PHPEngine.AddFunction('gui_threadSuspend', @gui_threadSuspend);
  PHPEngine.AddFunction('gui_threadFree', @gui_threadFree);
  PHPEngine.AddFunction('gui_threadSynchronize', @gui_threadSynchronize);
  PHPEngine.AddFunction('gui_threadSync', @gui_threadSynchronize);
  PHPEngine.AddFunction('gui_threadData', @gui_threadData);
  PHPEngine.AddFunction('gui_threadIsset', @gui_threadDataIsset);
  PHPEngine.AddFunction('gui_threadUnset', @gui_threadDataUnset);

  PHPEngine.AddFunction('gui_threadGetCount', @gui_threadGetCount);
  PHPEngine.AddFunction('gui_threadGetMax', @gui_threadGetMax);

  PHPEngine.AddFunction('thread_count', @gui_threadGetCount);
  PHPEngine.AddFunction('thread_max', @gui_threadGetMax);
  PHPEngine.AddFunction('thread_setMax', @gui_threadSetMax);

end;

end.

