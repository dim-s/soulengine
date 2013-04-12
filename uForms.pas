unit uForms;

interface

  uses Classes, Types, Forms, Controls, mainLCL,

  {$ifdef fpc}
  fileUtil,
  {$endif}

  Dialogs;

  function Form_Show(id: integer): Boolean; cdecl;
  function Form_ShowModal(id: integer): Integer; cdecl;
  function Form_Hide(id: integer): Boolean; cdecl;
  function Form_ShowOnTop(id: integer): Boolean; cdecl;
  function Form_SendToBack(id: integer): Boolean; cdecl;
  function Form_Close(id: integer): Boolean; cdecl;
  function Form_Parent(id, parent: integer): Integer; cdecl;
  function Form_Icon(id: integer; fileName: PWideChar): Integer; cdecl;
  function Form_Create(app: integer): Integer;

  procedure SetAsMainForm(aForm:integer);

implementation


function toForm(id: integer): TForm;
begin

  Result := TForm(toObject(id));
end;

procedure SetAsMainForm(aForm:integer);
var
  P: Pointer;
begin
  P := @Forms.Application.Mainform;
  Pointer(P^) := toForm( aForm );
end;

function Form_Show(id: integer): Boolean; cdecl;
begin
try
   Result := true;
   toForm(id).show();
   except
         Result := false;
   end;
end;

function Form_ShowModal(id: integer): Integer; cdecl;
begin
   Result := toForm(id).ShowModal();
end;

function Form_Hide(id: integer): Boolean; cdecl;
begin
try
   Result := true;
   toForm(id).hide();
   except
         Result := false;
   end;
end;

function Form_ShowOnTop(id: integer): Boolean; cdecl;
begin
try
   Result := true;
   toForm(id).BringToFront();
   except
         Result := false;
   end;
end;

function Form_SendToBack(id: integer): Boolean; cdecl;
begin
try
   Result := true;
   toForm(id).SendToBack();
   except
         Result := false;
   end;
end;

function Form_Close(id: integer): Boolean; cdecl;
begin
try
   Result := true;
   toForm(id).Close();
   except
         Result := false;
   end;
end;

function Form_Parent(id, parent: integer): Integer; cdecl;
begin
try

   if parent = -1 then
       Result := toID(toForm(id).Parent)
   else begin
       Result := 1;
       toForm(id).Parent := toWControl(parent);
   end;

   except
         Result := 0;
   end;
end;

function Form_Icon(id: integer; fileName: PWideChar): Integer; cdecl;
var
  Frm: TForm;
  Str: String;
begin
 Result := 0;
 Frm := toForm(id);
 Str := fileName;
 if (file_exists(Str)) then begin
      Frm.Icon.LoadFromFile(Str);
 end;
end;

function Form_Create(app: integer): Integer;
  var
  form: TForm;
begin
  form := TForm.CreateNew(TComponent(toObject(app)),0);

  {if Application.MainForm = nil then begin
     SetAsMainForm(Form);
     Application.Initialize;
     Randomize;
  end;}

  Result := toID( form );
end;



end.

