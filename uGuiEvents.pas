unit uGuiEvents;

{$I 'sDef.inc'}

interface

   uses classes, SysUtils, Dialogs, Variants, ExtCtrls,
    Graphics, Forms, Controls, ComCtrls, StdCtrls, Windows, FileCtrl,
    ShellApi, Math, TypInfo, ObjAuto, zendAPI, SizeControl,
    Messages

      {$IFDEF ADD_CHROMIUM}
       ,ceflib, cefvcl
      {$ENDIF}

      {$IFDEF VS_EDITOR}
              ,NxPropertyItems, NxPropertyItemClasses, NxScrollControl,
                NxInspector, SynEditTypes, SynEdit, SynCompletionProposal,
                CategoryButtons
      {$ENDIF}
    ;

    function AddSlashes(const  S : AnsiString) : string;

    var
    __varEx: Variant;

type
  TTypeEvent = (teCode, teFile);

type
  TMainEvent = procedure (Sender: TObject) of object;

  { ----------- key events -------------- }
  TKeyEvent = procedure (Sender: TObject; var Key: Word;
            Shift: TShiftState) of object;
  TKeyEnterEvent = procedure (Sender: TObject; var Key: Char) of object;
  TChangingEvent = procedure (Sender: TObject; var AllowChange: Boolean) of object;

  { ----------- form events -------------- }
  TCloseEvent = procedure (Sender: TObject; var Action: TCloseAction) of object;
  TCloseQueryEvent = procedure (Sender: TObject; var CanClose: Boolean) of object;
  TCanResize = procedure (Sender: TObject; var NewWidth,
                            NewHeight: Integer; var Resize: Boolean) of object;

  { ----------- mouse events -------------- }
  TMouseDownEvent = procedure (Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer) of object;
  TMouseMoveEvent = procedure (Sender: TObject;
                            Shift: TShiftState; X, Y: Integer) of object;

  TScrollEvent = procedure (Sender: TObject; ScrollCode: TScrollCode;
                            var ScrollPos: Integer) of object;


  TEditedEvent = procedure (Sender: TObject; Item: TListItem; var S: String) of object;
  TEditingEvent = procedure (Sender: TObject; Item: TListItem; var AllowEdit: Boolean) of object;

  { ----------- size control events ------- }
  TDuringSizeMove = TDuringEvent;

  { drag-n-drop }
  TStartDockEvent = procedure (Sender: TObject; var DragObject: TDragDockObject) of object;
  TEndDockEvent = procedure (Sender, Target: TObject; X, Y: Integer) of object;
  TUnDockEvent = procedure (Sender: TObject; Client: TControl;
                                NewTarget: TWinControl; var Allow: Boolean) of object;

  TDockDropEvent = procedure (Sender: TObject; Source: TDragDockObject; X,Y: Integer) of object;
  TDockOverEvent = procedure (Sender: TObject; Source: TDragDockObject; X,
                              Y: Integer; State: TDragState; var Accept: Boolean) of object;
  TDragDropEvent = procedure (Sender, Source: TObject; X, Y: Integer) of object;
  TDragOverEvent = procedure (Sender, Source: TObject; X, Y: Integer;
        State: TDragState; var Accept: Boolean) of object;
  { -------------------------- }


  {$IFDEF VS_EDITOR}
  TMouseCursorEvent = procedure (Sender: TObject; const aLineCharPos: TBufferCoord;
                                 var aCursor: TCursor) of object;

  TVSInsChangeEvent = procedure (Sender: TObject; Item: TNxPropertyItem; Value: WideString) of object;
  TVSInsEditEvent = procedure (Sender: TObject; Item: TNxPropertyItem; Value: WideString; var Accept: Boolean) of object;
  TVSInsToolbarClick = procedure (Sender: TObject; Item: TNxPropertyItem; ButtonIndex: Integer) of object;

  TButtonClickedEvent = procedure (Sender: TObject; const Button: TButtonItem) of object;
  {$ENDIF}


  {$IFDEF ADD_CHROMIUM}

  {$ENDIF}


{$M+}
type
  TEvents = class(TComponent)
  private
    Flist: string;
    Fcomponent_link: string;
    Fcomponent_name: string;
    Fcomponent_index: integer;
    procedure Setlist(const Value: string);
    procedure Setcomponent_link(const Value: string);
    procedure Setcomponent_name(const Value: string);
    procedure Setcomponent_index(const Value: integer);

  published

     property text: string read Flist write Setlist;
     property component_index: integer read Fcomponent_index write Setcomponent_index;
     property component_link: string read Fcomponent_link write Setcomponent_link;
     property component_name: string read Fcomponent_name write Setcomponent_name;

end;

  TEventInfo = class(TObject)
      EventList: TStrings;
      EventFunc: TStrings;
    public
      constructor Create();
      destructor Destroy();

      procedure DeleteEvent(Name: String);
      function AddEvent(Name,Func: String): Integer;
      function SetEvent(Name,Func: String): Integer;
      function GetEventID(Name: String): Integer;
      function GetEvent(Name: String): String;
  end;

type
  TEventItem = class(TObject)

     published
        procedure doEvent(Obj: TObject; Event: String; Params: Array of Variant; AddStr: String);
        { -------- main events ---------- }
        procedure onClick(Sender: TObject);
        procedure onDbClick(Sender: TObject);
        procedure onChange(Sender: TObject);
        procedure onSelect(Sender: TObject);
        procedure onChanging(Sender: TObject; var AllowChange: Boolean);
        procedure onTimer(Sender: TObject);
        procedure onMoved(Sender: TObject);
        procedure onCloseEx(Sender: TObject);

        procedure onPopup(Sender: TObject);
        procedure onButtonClick(Sender: TObject);

        { ----- key events ------ }
        procedure onKeyDown(Sender: TObject; var Key: Word;
            Shift: TShiftState);
        procedure onKeyUp(Sender: TObject; var Key: Word;
            Shift: TShiftState);
        procedure onKeyEnter(Sender: TObject; var Key: Char);

        { ----- mouse events ------ }
        procedure onMouseDown(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
        procedure onMouseUp(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
        procedure onMouseMove(Sender: TObject;
          Shift: TShiftState; X, Y: Integer);
        procedure onMouseEnter(Sender: TObject);
        procedure onMouseLeave(Sender: TObject);

        { ----- form events ------ }
        procedure onClose(Sender: TObject; var Action: TCloseAction);
        procedure onCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure onActivate(Sender: TObject);
        procedure onDeactivate(Sender: TObject);
        procedure onDestroy(Sender: TObject);
        procedure onHide(Sender: TObject);
        procedure onPaint(Sender: TObject);
        procedure onResize(Sender: TObject);
        procedure onShow(Sender: TObject);
        procedure onCanResize(Sender: TObject; var NewWidth,
                    NewHeight: Integer; var Resize: Boolean);

        procedure onMouseActivate(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y, HitTest: Integer;
          var MouseActivate: TMouseActivate);

        procedure onMouseWheel(Sender: TObject; Shift: TShiftState;
            WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
        procedure onMouseWheelDown(Sender: TObject; Shift: TShiftState;
            MousePos: TPoint; var Handled: Boolean);
        procedure onMouseWheelUp(Sender: TObject; Shift: TShiftState;
            MousePos: TPoint; var Handled: Boolean);

        { --- scrolling ---- }
        procedure onScroll(Sender: TObject; ScrollCode: TScrollCode;
            var ScrollPos: Integer);

        { --- edit --- }
        procedure onEdited(Sender: TObject; Item: TListItem; var S: String);
        procedure onEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);

        { --- size controls  }
        procedure onDuringSizeMove(Sender: TObject; dx, dy: integer; State: TSCState);
        procedure onStartSizeMove(Sender: TObject; State: TSCState);
        procedure onEndSizeMove(Sender: TObject; State: TSCState);
        procedure onSetCursor(Sender: TObject; Target: TControl; TargetPt: TPoint; var handled: Boolean);
        procedure onSizeMouseDown(Sender: TObject; Target: TControl; TargetPt: TPoint; var handled: Boolean);


        { --- drag'n'drop --- }
        procedure onStartDock(Sender: TObject; var DragObject: TDragDockObject);
        procedure onEndDock(Sender, Target: TObject; X, Y: Integer);
        procedure onUnDock(Sender: TObject; Client: TControl;
                                NewTarget: TWinControl; var Allow: Boolean);

        procedure onDockDrop(Sender: TObject; Source: TDragDockObject; X,Y: Integer);
        procedure onDockOver(Sender: TObject; Source: TDragDockObject; X,
                              Y: Integer; State: TDragState; var Accept: Boolean);
        procedure onDragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure onDragOver(Sender, Source: TObject; X, Y: Integer;
                        State: TDragState; var Accept: Boolean);

        {$IFDEF VS_EDITOR}
        procedure onMouseCursor(Sender: TObject; const aLineCharPos: TBufferCoord;
                                 var aCursor: TCursor);

        procedure onVSInsChange(Sender: TObject;
                                Item: TNxPropertyItem; Value: WideString);



        procedure onVSInsEdit(Sender: TObject;
                                Item: TNxPropertyItem; Value: WideString; var Accept: Boolean);

        procedure onVSInsToolBarClick(Sender: TObject;
                                Item: TNxPropertyItem; ButtonIndex: Integer);

        procedure onButtonClicked2(Sender: TObject; const Button: TButtonItem);
        {$ENDIF}

        
        {$IFDEF ADD_HTMLREAD}
        procedure onLink(Sender: TObject; const Rel, Rev, Href: string);
        procedure onHotSpotClick(Sender: TObject; const SRC: string;
                     var Handled: boolean);
        procedure onFormSubmit(Sender: TObject; const AnAction, Target, EncType, Method: String;
                    Results: TStringList);
        procedure onHotSpotCovered(Sender: TObject; const URL: string);
        {$ENDIF}

        {$IFDEF ADD_CHROMIUM}
        procedure onChromiumBeforeBrowse(Sender: TCustomChromium;
            const browser: ICefBrowser; const frame: ICefFrame;
            const request: ICefRequest; navType: TCefHandlerNavtype; isRedirect: Boolean;
            out Result: Boolean);
        {$ENDIF}

     public
        OnEvent: String;
        TypeEvent: TTypeEvent;
        aSender: TObject;
        ObjsEventList: TStringList;  // מבתוךעû
        ObjsEventInfo: TList; // event info

        function getEventInfo(Obj: TObject): TEventInfo;

        function SetEvent(Obj: TObject; Event, Func: String): Boolean;
        function GetEvent(Obj: TObject; Event: String): String;

        constructor Create;
        destructor Destroy;
  end;
{$M-}

Type
  TScriptEventHandler = class(TObject)
    protected
       Data: Pointer;
    public
       
  end;


implementation

uses uPHPMod;

{ TEventItem }
function GetSym(S: String; N: Integer): Char;
begin
  Result := S[N];
end;

function Shift2Str(Shift: TShiftState): String;
   Var
   Arr: TStrings;
begin
Arr := TStringList.Create;
    if Shift = Shift + [ssShift] then
      Arr.Add('ssShift');
    if Shift = Shift + [ssAlt] then
      Arr.Add('ssAlt');
    if Shift = Shift + [ssCtrl] then
      Arr.Add('ssCtrl');
    if Shift = Shift + [ssLeft] then
      Arr.Add('ssLeft');
    if Shift = Shift + [ssRight] then
      Arr.Add('ssRight');
    if Shift = Shift + [ssMiddle] then
      Arr.Add('ssMiddle');
    if Shift = Shift + [ssDouble] then
      Arr.Add('ssDouble');

Result := StringReplace(Arr.Text,#13#10,',',[rfReplaceAll]);
Arr.Free;
end;

function Str2Shift(const S: String): TShiftState;
begin
  Result := [];
  if Pos('ssShift',S)>0 then
    Result := Result + [ssShift];
  if Pos('ssAlt',S)>0 then
    Result := Result + [ssAlt];
  if Pos('ssCtrl',S)>0 then
    Result := Result + [ssCtrl];
  if Pos('ssLeft',S)>0 then
    Result := Result + [ssLeft];
  if Pos('ssRight',S)>0 then
    Result := Result + [ssRight];
  if Pos('ssMiddle',S)>0 then
    Result := Result + [ssMiddle];
  if Pos('ssDouble',S)>0 then
    Result := Result + [ssDouble];
end;

function Bool2Str(B: Boolean): String;
begin
  if B then
    Result := 'True'
  else
    Result := 'False';
end;

function Str2Bool(const S: String): Boolean;
begin
Result := false;
  if (CompareText(S,'True')=0) or (CompareText(S,'1')=0) Then
    Result := true;
end;

function in_Array(search: String; arr: Array of String): Boolean;
  Var
  i: integer;
begin
Result := false;
  for I := 0 to high(arr) do
      if CompareText(search, arr[i])=0 then
      begin
        Result := true;
        exit;
      end;
end;

function AddSlashes(const  S : string) : string;
var Src,Dst : pchar; I,J : integer;
begin

  Result := StringReplace(S,chr(8),'8',[rfReplaceAll]);
  Result := StringReplace(S, '\', '\\',[rfReplaceAll]);
{  Result := StringReplace(Result, '<', '\<',[rfReplaceAll]);
  Result := StringReplace(Result, '?', '\?',[rfReplaceAll]);
  Result := StringReplace(Result, '>', '\>',[rfReplaceAll]);
 }
 Result := StringReplace(Result,'''','\''',[rfReplaceAll]);
 Result := StringReplace(Result,'<?','''."<".chr('+IntToStr(ord('?'))+').''',[rfReplaceAll] );

  //Application.MainForm.Caption := Result;
end;

function implode(sep: string; arr: Array of Variant): String;
var
  i: Integer;
begin
  for i := 0 to High(arr) do
    begin
     { if (arr[i] = True) or (arr[i] = False) then
        Result := Result + '''' + String(arr[i]) + ''''
      {else if arr[i].VType = vtInteger then
        Result := Result + String(arr[i])
      else if arr[i].VType = vtExtended then
        Result := Result + StringReplace(String(arr[i]),',','.',[])
      else}
        Result := Result + '''' + AddSlashes(String(arr[i])) + '''';

        if i <> High(arr) then
          Result := Result + sep;
    end;
end;


function TEventItem.SetEvent(Obj: TObject; Event, Func: String): Boolean;
  Var
  MT: TMethod;
  PEvent: ^TMainEvent;
  PKeyEvent: ^TKeyEvent;
  PKeyEnterEvent: ^TKeyEnterEvent;
  PCloseEvent: ^TCloseEvent;
  PCloseQuery: ^TCloseQueryEvent;
  PCanResize: ^TCanResizeEvent;
  PMouseEvent: ^TMouseDownEvent;
  PMouseMove : ^TMouseMoveEvent;
  PScrollEvent: ^TScrollEvent;
  PChangingEvent: ^TChangingEvent;
  PDuringSizeMove: ^TDuringSizeMove;
  PStartEndEvent: ^TStartEndEvent;
  PSetCursor: ^TSetCursorEvent;
  PEditedEvent: ^TEditedEvent;
  PEditingEvent: ^TEditingEvent;

  {$IFDEF VS_EDITOR}
  PMouseCursorEvent: ^TMouseCursorEvent;
  PVSInsEvent: ^TVSInsChangeEvent;
  PVSInsEditEvent: ^TVSInsEditEvent;
  PVSInsToolbarClick: ^TVSInsToolbarClick;
  PButtonClicked: ^TButtonClickedEvent;
  {$ENDIF}

  { drag'n'drop }
  PStartDockEvent: ^TStartDockEvent;
  PEndDockEvent: ^TEndDockEvent;
  PUnDockEvent: ^TUnDockEvent;
  PDockDropEvent: ^TDockDropEvent;
  PDockOverEvent: ^TDockOverEvent;
  PDragDropEvent: ^TDragDropEvent;
  PDragOverEvent: ^TDragOverEvent;
  { ///// drag'n'drop }

  MP: Pointer;
  EI: TEventInfo;
begin
  EI := getEventInfo(Obj);

  aSender := Obj; MT.Data := Obj;
  MP := @MT.Code;
  Event := UpperCase(Event);

   if in_Array(Event,['OnKeyUp','OnKeyDown']) then
    PKeyEvent := MP

   { drag'n'drop }
   else if Event = 'ONSTARTDOCK' then
    PStartDockEvent := MP
   else if Event = 'ONENDDOCK' then
    PEndDockEvent := MP
   else if Event = 'ONUNDOCK' then
    PUnDockEvent := MP
   else if Event = 'ONDOCKDROP' then
    PDockDropEvent := MP
   else if Event = 'ONDOCKOVER' then
    PDockOverEvent := MP
   else if Event = 'ONDRAGDROP' then
    PDragDropEvent := MP
   else if Event = 'ONDRAGOVER' then
    PDragOverEvent := MP
   { /////////// }

   else if in_Array(Event,['OnKeyPress','OnKeyEnter']) then
    PKeyEnterEvent := MP
   else if in_Array(Event,['OnMouseDown','OnMouseUp']) then
    PMouseEvent := MP
   else if in_Array(Event,['OnMouseMove']) then
    PMouseMove := MP
   else if in_Array(Event,['OnClose']) then
    PCloseEvent := MP
   else if in_Array(Event,['OnCloseQuery']) then
    PCloseQuery := MP
   else if in_Array(Event,['OnCanResize']) then
    PCanResize := MP
   else if in_Array(Event,['OnScroll']) then
    PScrollEvent := MP
   else if in_Array(Event,['OnChanging']) then
    PChangingEvent := MP
   else if in_Array(Event,['OnDuringSizeMove']) then
    PDuringSizeMove := MP
   else if in_Array(Event,['OnStartSizeMove','OnEndSizeMove']) then
    PStartEndEvent := MP
   else if in_Array(Event,['OnSetCursor', 'OnSizeMouseDown']) then
    PSetCursor := MP
   else if in_Array(Event,['OnEdited']) then
    PEditedEvent := MP
   else if in_Array(Event,['OnEditing']) then
    PEditingEvent := MP

   {$IFDEF VS_EDITOR}
   else if Event = 'OnMouseCursor' then
    PMouseCursorEvent := MP
   else if in_Array(Event,['ONVSINSPECTORCHANGE']) then
    PVSInsEvent := MP
   else if in_Array(Event,['OnVsInspectorEdit']) then
    PVSInsEditEvent := MP
   else if in_Array(Event,['OnVsToolBarClick']) then
    PVSInsToolbarClick := MP
    {$ENDIF}
   else
    PEvent := MP;

   {$IFDEF VS_EDITOR}
   if in_Array(Event,['OnClose']) and (obj is TSynCompletionProposal) then
        PEvent := MP;
   if Event = 'ONBUTTONCLICKED' then
        PButtonClicked := Mp;
   {$ENDIF}


   {$IFDEF VS_EDITOR}
   if (Event = 'ONCLOSE') and (Obj is TSynCompletionProposal) then
      PEvent^ := onCloseEx
   else
   {$ENDIF}
   if Event = 'ONCLICK' then
      PEvent^ := onClick
   else if Event = 'ONDBLCLICK' then
      PEvent^ := onDbClick
   else if Event = 'ONACTIVATE' then
      PEvent^ := onActivate
   else if Event = 'ONDEACTIVATE' then
      PEvent^ := onDeactivate
   else if Event = 'ONDESTROY' then
      PEvent^ := onDestroy
   else if Event = 'ONHIDE' then
      PEvent^ := onHide
   else if Event = 'ONPAINT' then
      PEvent^ := onPaint
    else if Event = 'ONRESIZE' then
      PEvent^ := onResize
    else if Event = 'ONSHOW' then
      PEvent^ := onShow
    else if Event = 'ONCHANGE' then
         PEvent^ := onChange
    else if Event = 'ONSELECT' then
         PEvent^ := onSelect
    else if Event = 'ONTIMER' then
         PEvent^ := onTimer
   else if Event = 'ONCLOSE' then
      PCloseEvent^ := onClose
   else if Event = 'ONCLOSEQUERY' then
      PCloseQuery^ := onCloseQuery
   else if Event = 'ONCANRESIZE' then
      PCanResize^ := onCanResize
   else if Event = 'ONKEYDOWN' then
      PKeyEvent^ := onKeyDown
   else if Event = 'ONKEYUP' then
        PKeyEvent^ := onKeyUp
   else if Event = 'ONKEYPRESS' then
        PKeyEnterEvent^ := onKeyEnter
   else if Event = 'ONMOUSEDOWN' then
        PMouseEvent^ := onMouseDown
   else if Event = 'ONMOUSEUP' then
        PMouseEvent^ := onMouseUp
   else if Event = 'ONMOUSEMOVE' then
        PMouseMove^ := onMouseMove
   else if Event = 'ONMOUSEENTER' then
        PEvent^ := onMouseEnter
   else if Event = 'ONMOUSELEAVE' then
        PEvent^ := onMouseLeave
   else if Event = 'ONSCROLL' then
        PScrollEvent^ := onScroll
   else if Event = 'ONCHANGING' then
        PChangingEvent^ := onChanging
   else if Event = 'ONDURINGSIZEMOVE' then
        PDuringSizeMove^ := onDuringSizeMove
   else if Event = 'ONSTARTSIZEMOVE' then
        PStartEndEvent^ := onStartSizeMove
   else if Event = 'ONENDSIZEMOVE' then
        PStartEndEvent^ := onEndSizeMove
   else if Event = 'ONSETCURSOR' then
        PSetCursor^ := onSetCursor
   else if Event = 'ONSIZEMOUSEDOWN' then
        PSetCursor^ := onSizeMouseDown
   else if Event = 'ONEDITED' then
        PEditedEvent^ := onEdited
   else if Event = 'ONEDITING' then
        PEditingEvent^ := onEditing
   else if Event = 'ONMOVED' then
        PEvent^ := onMoved
   else if Event = 'ONPOPUP' then
        PEvent^ := onPopup
   else if Event = 'ONBUTTONCLICK' then
        PEvent^ := onButtonClick;
   { drag'n'drop }

   if Event = 'ONSTARTDOCK' then
    PStartDockEvent^ := onStartDock
   else if Event = 'ONENDDOCK' then
    PEndDockEvent^ := onEndDock
   else if Event = 'ONUNDOCK' then
    PUnDockEvent^ := onUnDock
   else if Event = 'ONDOCKDROP' then
    PDockDropEvent^ := onDockDrop
   else if Event = 'ONDOCKOVER' then
    PDockOverEvent^ := onDockOver
   else if Event = 'ONDRAGDROP' then
    PDragDropEvent^ := onDragDrop
   else if Event = 'ONDRAGOVER' then
    PDragOverEvent^ := onDragOver;
   { /////////// }



   {$IFDEF VS_EDITOR}
   if Event = 'ONMOUSECURSOR' then
        PMouseCursorEvent^ := onMouseCursor
   else if Event = 'ONVSINSPECTORCHANGE' then
        PVSInsEvent^ := onVSInsChange
   else if Event = 'ONVSINSPECTOREDIT' then
        PVSInsEditEvent^ := onVSInsEdit
   else if Event = 'ONVSTOOLBARCLICK' then
        PVSInsToolbarClick^ := onVSInsToolBarClick
   else if Event = 'ONBUTTONCLICKED' then
        PButtonClicked^ := onButtonClicked2;

   {$ENDIF}

  EI.SetEvent(Event,Func);

  if Event = 'ONSIZEMOUSEDOWN' then Event := 'ONMOUSEDOWN';

  {$IFDEF VS_EDITOR}
  if Event = 'ONVSINSPECTORCHANGE' then Event := 'ONCHANGE';
  if Event = 'ONVSINSPECTOREDIT' then Event := 'ONEDIT';
  if Event = 'ONVSTOOLBARCLICK' then Event := 'ONTOOLBARCLICK';
  {$ENDIF}


  if ( TypInfo.GetPropInfo(Obj,Event) = nil ) then
  begin
       Result := false;
       exit;
  end;

  TypInfo.SetMethodProp(Obj,Event,Mt);
  Result:=true;
end;

constructor TEventItem.Create;
begin
  ObjsEventList := TStringList.Create;
  ObjsEventInfo := TList.Create;
end;

destructor TEventItem.Destroy;
begin
  ObjsEventList.Free;
  ObjsEventInfo.Free;
end;

procedure TEventItem.doEvent(Obj: TObject; Event: String; Params: Array of Variant; AddStr: String);
begin
 if phpMOD.psvPHP.EngineActive then begin

      phpMOD.psvPHP.UseDelimiters := false;
      
      if LowerCase(Event)='onclose' then begin

      {$IFDEF VS_EDITOR}
      if Obj is TSynBaseCompletionProposalForm then
        phpMOD.RunCode(GetEvent(TComponent(Obj).Owner,Event)+'('+implode(',',Params)+');' + addStr)
      else
      {$ENDIF}
        phpMOD.RunCode(GetEvent(Obj,Event)+'('+implode(',',Params)+');' + addStr);

      end else begin
         phpMOD.RunCode(GetEvent(Obj,Event)+'('+implode(',',Params)+');' + addStr);
      end;

      phpMOD.psvPHP.UseDelimiters := true;

   end

end;


function TEventItem.GetEvent(Obj: TObject; Event: String): String;
begin
  Result := getEventInfo(Obj).GetEvent(Event);
end;

function TEventItem.getEventInfo(Obj: TObject): TEventInfo;
  var
  id: Integer;
  EI: TEventInfo;
begin
  id := ObjsEventList.IndexOf(IntToStr(integer(Obj)));
  if id > -1 then
    Result := TEventInfo(ObjsEventInfo[id])
  else begin
      EI := TEventInfo.Create;
      ObjsEventList.Add(IntToStr(integer(Obj)));
      ObjsEventInfo.Add(EI);
      Result := EI;
  end;
end;

procedure TEventItem.onClick(Sender: TObject);
begin
   doEvent(Sender,'OnClick',[integer(Sender)],'');
end;

procedure TEventItem.onPopup(Sender: TObject);
begin
   doEvent(Sender,'OnPopup',[integer(Sender)],'');
end;

procedure TEventItem.onCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   __varEx := CanClose;
   doEvent(Sender,'OnCloseQuery',[integer(Sender),CanClose],'');
   CanClose := __varEx;
end;

procedure TEventItem.onDbClick(Sender: TObject);
begin

   doEvent( Sender,'OnDblClick',[integer(Sender)],'');
end;

{----------------------- FORMS EVENTS -------------------------------- }

procedure TEventItem.onClose(Sender: TObject; var Action: TCloseAction);
begin
   doEvent( Sender,'OnClose',[integer(Sender),Action],'');
end;

procedure TEventItem.onCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  __varEx := Resize;
  doEvent( Sender,'OnCanResize',[integer(Sender),NewWidth,NewHeight,Resize],'');
  Resize := __varEx;
end;

procedure TEventItem.onActivate(Sender: TObject);
begin doEvent( Sender,'OnActivate',[integer(Sender)],''); end;

procedure TEventItem.onDeactivate(Sender: TObject);
begin doEvent( Sender,'OnDeactivate',[integer(Sender)],''); end;

procedure TEventItem.onDestroy(Sender: TObject);
begin doEvent( Sender,'OnDestroy',[integer(Sender)],''); end;

procedure TEventItem.onDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin
doEvent( Sender,'OnDockDrop',[integer(Sender),integer(Source.Control), X, Y],'');
end;

procedure TEventItem.onDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  __varEx := Accept;
doEvent( Sender,'OnDockOver',[integer(Sender), integer(Source), X, Y, integer(State),Accept],'');
  Accept := __varEx;
end;

procedure TEventItem.onDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
doEvent( Sender,'OnDragDrop',[integer(Sender),integer(Source),X,Y],'');
end;

procedure TEventItem.onDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  __varEx := Accept;
doEvent( Sender,'OnDragOver',[integer(Sender), integer(Source), X, Y, integer(State),Accept],'');
  Accept := __varEx;
end;

procedure TEventItem.onHide(Sender: TObject);
begin doEvent( Sender,'OnHide',[integer(Sender)],''); end;


procedure TEventItem.onPaint(Sender: TObject);
begin doEvent( Sender,'OnPaint',[integer(Sender)],''); end;

procedure TEventItem.onResize(Sender: TObject);
begin doEvent( Sender,'OnResize',[integer(Sender)],''); end;

procedure TEventItem.onShow(Sender: TObject);
begin doEvent( Sender,'OnShow',[integer(Sender)],''); end;

procedure TEventItem.onChange(Sender: TObject);
begin doEvent( Sender,'OnChange',[integer(Sender)],''); end;

procedure TEventItem.onSelect(Sender: TObject);
begin doEvent( Sender,'OnSelect',[integer(Sender)],''); end;

procedure TEventItem.onTimer(Sender: TObject);
begin doEvent( Sender,'OnTimer',[integer(Sender)],''); end;

procedure TEventItem.onUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
  __varEx := Allow;
doEvent( Sender,'OnUnDock',[integer(Sender), integer(Client), integer(NewTarget),Allow],'');
  Allow := __varEx;
end;

procedure TEventItem.onChanging(Sender: TObject; var AllowChange: Boolean);
begin
__varEx := AllowChange;
doEvent( Sender,'OnChanging',[integer(Sender),AllowChange],'');
AllowChange := __varEx;
end;

procedure TEventItem.onDuringSizeMove(Sender: TObject; dx, dy: integer;
  State: TSCState);
begin
  doEvent( Sender, 'OnDuringSizeMove',[integer(Sender),dx,dy,integer(State)],'');
end;

procedure TEventItem.onStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
begin
  __varEx := integer(DragObject);
doEvent( Sender,'OnStartDock',[integer(Sender), integer(DragObject)],'');
  Pointer(DragObject) := pointer(integer(__varEx));
end;

procedure TEventItem.onStartSizeMove(Sender: TObject; State: TSCState);
begin
  doEvent( Sender, 'OnStartSizeMove',[integer(Sender),integer(State)],'');
end;

procedure TEventItem.onEndDock(Sender, Target: TObject; X, Y: Integer);
begin
doEvent( Sender,'OnEndDock',[integer(Sender), integer(Target), X,Y],'');
end;

procedure TEventItem.onEndSizeMove(Sender: TObject; State: TSCState);
begin
  doEvent( Sender, 'OnEndSizeMove',[integer(Sender),integer(State)],'');
end;

procedure TEventItem.onKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
__varEx := Key;
doEvent( Sender,'OnKeyDown',[integer(Sender),Key,Shift2Str(Shift)],'');
Key := __varEx;
end;

procedure TEventItem.onKeyEnter(Sender: TObject; var Key: Char);
begin
__varEx := Key;
doEvent( Sender,'OnKeyPress',[integer(Sender),Key],'');
Key := GetSym(__varEx,1);
end;

procedure TEventItem.onKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
__varEx := Key;
doEvent( Sender,'OnKeyUp',[integer(Sender),Key,Shift2Str(Shift)],'');
Key := __varEx;
end;

{$IFDEF ADD_HTMLREAD}
procedure TEventItem.onLink(Sender: TObject; const Rel, Rev, Href: string);
begin
  doEvent( Sender,'OnLink',[integer(Sender),Rel, Rev, Href],'');
end;

procedure TEventItem.onHotSpotClick(Sender: TObject; const SRC: string;
  var Handled: boolean);
begin
__varEx := Handled;
  doEvent( Sender,'OnHotSpotClick',[integer(Sender),SRC, Handled],'');
Handled := __varEx;
end;

procedure TEventItem.onHotSpotCovered(Sender: TObject; const URL: string);
begin                         
  doEvent( Sender,'OnHotSpotCovered',[integer(Sender),URL],'');
end;

procedure TEventItem.onFormSubmit(Sender: TObject; const AnAction, Target, EncType, Method: String;
  Results: TStringList);
begin
  doEvent( Sender,'OnFormSubmit',[integer(Sender),AnAction, Target, EncType, Method, Results.Text],'');
end;

{$ENDIF}


{$IFDEF ADD_CHROMIUM}
procedure TEventItem.onChromiumBeforeBrowse(Sender: TCustomChromium;
            const browser: ICefBrowser; const frame: ICefFrame;
            const request: ICefRequest; navType: TCefHandlerNavtype; isRedirect: Boolean;
            out Result: Boolean);
begin
  __varEx := Result;
  doEvent( Sender,'OnChromiumBeforeBrowse',
              [Integer(Sender), Integer(browser), Integer(frame),
                 navType, isRedirect, Result],'');
  Result := __varEx;
end;
{$ENDIF}

procedure TEventItem.onMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  doEvent( Sender,'OnMouseDown',[integer(Sender),integer(Button),
              Shift2Str(Shift),X,Y],'');
end;

procedure TEventItem.onMouseEnter(Sender: TObject);
begin
  doEvent( Sender,'OnMouseEnter',[integer(Sender)],'');
end;

procedure TEventItem.onMouseLeave(Sender: TObject);
begin
  doEvent( Sender,'OnMouseLeave',[integer(Sender)],'');
end;

procedure TEventItem.onMouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Integer);
begin
  doEvent( Sender,'OnMouseMove',[integer(Sender),
              Shift2Str(Shift),X,Y],'');
end;

procedure TEventItem.onMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  doEvent( Sender,'OnMouseUp',[integer(Sender),integer(Button),
              Shift2Str(Shift),X,Y],'');
end;

procedure TEventItem.onMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TEventItem.onMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TEventItem.onMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TEventItem.onScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
__varEx := ScrollPos;
  doEvent( Sender,'OnScroll',[integer(Sender),integer(ScrollCode),ScrollPos],'');
ScrollPos := __varEx;
end;

procedure TEventItem.onSetCursor(Sender: TObject; Target: TControl;
  TargetPt: TPoint; var handled: Boolean);
begin
  doEvent( Sender, 'OnSetCursor', [integer(Sender), integer(Target), TargetPt.X, TargetPt.Y],'');
end;

procedure TEventItem.onSizeMouseDown(Sender: TObject; Target: TControl;
  TargetPt: TPoint; var handled: Boolean);
begin
  doEvent( Sender, 'OnSizeMouseDown', [integer(Sender), integer(Target), TargetPt.X, TargetPt.Y],'');
end;

procedure TEventItem.onEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
__varEx := S;
  doEvent( Sender,'OnEdited',[integer(Sender),integer(Item),S],'');
S := __varEx;
end;

procedure TEventItem.onEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
__varEx := AllowEdit;
  doEvent( Sender,'OnEditing',[integer(Sender),integer(Item),AllowEdit],'');
AllowEdit := __varEx;
end;

procedure TEventItem.onMouseActivate(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
  doEvent( Sender,'OnMouseActive',[integer(Sender),Button, Shift2Str(Shift), X, Y,
   HitTest, integer(MouseActivate) ],'');
end;

{$IFDEF VS_EDITOR}
procedure TEventItem.onMouseCursor(Sender: TObject;
  const aLineCharPos: TBufferCoord; var aCursor: TCursor);
begin
  doEvent( Sender,'OnMouseCursor',[integer(Sender),aLineCharPos.Char,aLineCharPos.Line],'');
end;
{$ENDIF}

procedure TEventItem.onMoved(Sender: TObject);
begin
  doEvent( Sender,'OnMoved',[integer(Sender)],'');
end;

procedure TEventItem.onCloseEx(Sender: TObject);
begin
    doEvent( Sender,'OnClose',[integer(Sender)],'');
end;

procedure TEventItem.onButtonClick(Sender: TObject);
begin
     doEvent( Sender,'OnButtonClick',[integer(Sender)],'');
end;

{$IFDEF VS_EDITOR}
procedure TEventItem.onVSInsChange(Sender: TObject; Item: TNxPropertyItem;
  Value: WideString);
begin
    doEvent( Sender,'OnVSInspectorChange',[integer(Sender),integer(Item),(Value)],'');
end;

procedure TEventItem.onVSInsEdit(Sender: TObject; Item: TNxPropertyItem;
  Value: WideString; var Accept: Boolean);
begin
    __varEx := Accept;

    doEvent( Sender,'OnVSInspectorEdit',[integer(Sender),integer(Item),(Value),Accept],'');
    Accept := __varEx;
end;


procedure TEventItem.onVSInsToolBarClick(Sender: TObject;
  Item: TNxPropertyItem; ButtonIndex: Integer);
begin
    doEvent( Sender,'OnVSToolBarClick',[integer(Sender),integer(Item),ButtonIndex],'');
end;

procedure TEventItem.onButtonClicked2(Sender: TObject; const Button: TButtonItem);
begin
    doEvent( Sender,'OnButtonClicked',[integer(Sender),integer(Button)],'');
end;
{$ENDIF}

{ TEventInfo }

function TEventInfo.AddEvent(Name, Func: String): Integer;
begin
    EventList.Add(Name);
    EventFunc.Add(Func);
end;

constructor TEventInfo.Create;
begin
  EventList := TStringList.Create;
  EventFunc := TStringList.Create;
end;

procedure TEventInfo.DeleteEvent(Name: String);
  var
  id: integer;
begin
  id := GetEventID(Name);
  if id > -1 then
    begin
      EventList.Delete(id);
      EventFunc.Delete(id);
    end;
end;

destructor TEventInfo.Destroy;
begin
  EventList.Free;
  EventFunc.Free;
end;

function TEventInfo.GetEvent(Name: String): String;
  var
  id: integer;
begin
  id := GetEventID(Name);
  if id > -1 then
    Result := EventFunc[id]
  else
    Result := '';
end;

function TEventInfo.GetEventID(Name: String): Integer;
begin
   Result := EventList.IndexOf(Name);
end;

function TEventInfo.SetEvent(Name, Func: String): Integer;
  var
  id: integer;
begin
  id := GetEventID(Name);
  if id > -1 then
    EventFunc[id] := Func
  else
    AddEvent(Name,Func);

  Result := id;
end;

{ TEvents }

procedure TEvents.Setcomponent_index(const Value: integer);
begin
  Fcomponent_index := Value;
end;

procedure TEvents.Setcomponent_link(const Value: string);
begin
  Fcomponent_link := Value;
end;

procedure TEvents.Setcomponent_name(const Value: string);
begin
  Fcomponent_name := Value;
end;

procedure TEvents.Setlist(const Value: string);
begin
  Flist := Value;
end;

end.
