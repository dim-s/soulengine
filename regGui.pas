unit regGui;

{$I 'sDef.inc'}

interface

  uses Forms, Dialogs, SysUtils, Windows, TypInfo, Classes, Controls, Buttons,
  Messages,
  StdCtrls, CommCtrl, ComCtrls, Menus, ExtCtrls, ExtDlgs, Math, Mask, Grids
  , Tabs, Graphics, MImage, ValEdit, mainLCL, uGuiScreen, cooltrayicon,

  pngimage, dsStdCtrl{, rkSmartTabs}


  {$IFDEF ADD_CHROMIUM}
    ,ceflib, cefvcl, cefgui
  {$ENDIF}

  {$IFDEF ADD_SKINS}
   {,sSkinProvider, sSkinManager, ValEdit,

   sSpeedButton, sBitBtn, acProgressBar, sTrackBar, sBevel, sLabel}
  {$ENDIF}



  {$IFDEF VS_EDITOR}
          ,NxPropertyItems, NxPropertyItemClasses, NxScrollControl,
          NxInspector, DockTabSet,
          SynEditHighlighter,
          SynHighlighterPHP, SynHighlighterSQL, SynHighlighterHtml,
          SynHighlighterPas, SynHighlighterXML, SynHighlighterCSS, SynHighlighterJScript,
          SynHighlighterCpp,
          SynEdit, SynHighlighterGeneral,
          SynCompletionProposal,

          CategoryButtons
  {$ENDIF}

  {$IFDEF NOT_LITE}
  , CheckLst
  {$ENDIF}

  {$IFDEF C_SIZECONTROL}
   ,SizeControl
  {$ENDIF}
  ;

  function createComponent(aClass: ansistring; aOwner: integer): Integer;
  function parentControl(id: integer; parent: integer): integer;
  function ownerComponent(id: integer): integer;
  function objectClass(id: integer): ansistring;
  function objectIs(id: integer; const aClass: AnsiString): Boolean;
  function ComponentToString(id: integer): ansistring;
  procedure StringToComponent(id: integer; Value: ansistring);    

  procedure registerGui();

implementation

uses uNonVisual;



function objectClass(id: integer): ansistring;
begin
  if id <> 0 then
     Result := toObject(id).ClassName
  else
     Result := #0;
end;

function objectIs(id: integer; const aClass: AnsiString): Boolean;
   var
   CL: TClass;
begin
   CL := GetClass(aClass);
     Result := (CL <> NIL) and (ID <> 0) and (toObject(id) is CL);
end;

function createComponent(aClass: ansistring; aOwner: integer): Integer;
  Var
  Owner: TComponent;
  P: TComponentClass;
begin
try
  if aOwner = 0 then
    Owner := nil
  else
    Owner := TComponent(toObject(aOwner));
    p := TComponentClass(GetClass(aClass));
    if (p <> nil) then
        Result := toID(TComponentClass(p).Create(Owner))
    else
        Result := 0;

  except
      Result := 0;
  end;
end;

function parentControl(id: integer; parent: integer): integer;
begin
Result := 0;

  if toObject(id) is TControl then
  if parent = -1 then
      Result := toID(toControl(id).Parent)
  else
      toControl(id).Parent := toWControl(parent);
end;

function ownerComponent(id: integer): integer;
begin
     if toObject(id) is TComponent then
       Result := toID(TComponent( id ).Owner)
     else
       Result := 0;
end;



function ComponentToString(id: integer): ansistring;
var
ms: TMemoryStream;
ss: TStringStream;
Component: TComponent;
begin
Component := TComponent(toObject(id));
ss := TStringStream.Create(' ');
ms := TMemoryStream.Create;
try
  try
   ms.WriteComponent(Component);
   ms.position := 0;

   {$ifdef fpc}
       LRSObjectBinaryToText(ms, ss);
   {$else}
       ObjectBinaryToText(ms, ss);
   {$endif}

   ss.position := 0;
   Result := ss.DataString;
   //MessageBoxFunction(pchar(Result),'', 0);
   except
   end;

finally
   ms.Free;
   ss.free;
end;
end;

procedure StringToComponent(id: integer; Value: ansistring);
var
ss: TStringStream;
ms: TMemoryStream;
Component: TComponent;
begin
Component := TComponent(toObject(id));
ss := TStringStream.Create(Value);
try
   ms := TMemoryStream.Create;
   try
     ss.Position := 0;
     try

   {$ifdef fpc}
       LRSObjectTextToBinary(ms, ss);
   {$else}
       ObjectTextToResource(ss, ms);
   {$endif}

     ms.position := 0;
     ms.ReadComponentRes(Component);
     except
        on e: Exception do
           ShowMessage(e.Message);
     end;
   finally
     ms.Free;
   end;
finally
   ss.Free;
end;
end;    


procedure registerArr(classes: array of TPersistentClass);
begin

   RegisterClasses(classes);
end;

procedure registerButtons;
begin
  registerArr([
          TSpeedButton
          {$IFDEF NOT_LITE}, TButton, TButtonControl {$ENDIF}
   ]);

  RegisterClass(Buttons.TBitBtn);
  UnRegisterClass(Buttons.TBitBtn);
  RegisterClassAlias(dsStdCtrl.TBitBtn, 'TBitBtn');
end;

procedure registerStandart;
begin
  registerButtons;


  //RegisterClass(TEdit);
  registerArr([
                TMainMenu,
                Menus.TMenuItem,
                Menus.TMenu,
                Menus.TPopupMenu,
                TRadioButton,
                TLabel,
                TGroupBox,
                TPadding, TMargins,

                {$IFDEF NOT_LITE}
                     TScrollBar,
                {$ENDIF}

                TPNGObject
              ]);

  RegisterClass(StdCtrls.TEdit);
  UnRegisterClass(StdCtrls.TEdit);
  RegisterClassAlias(dsStdCtrl.TEdit, 'TEdit');

  RegisterClass(StdCtrls.TMemo);
  UnRegisterClass(StdCtrls.TMemo);
  RegisterClassAlias(dsStdCtrl.TMemo, 'TMemo');

  RegisterClass(StdCtrls.TListBox);
  UnRegisterClass(StdCtrls.TListBox);
  RegisterClassAlias(dsStdCtrl.TListBox, 'TListBox');

  RegisterClass(StdCtrls.TCheckBox);
  UnRegisterClass(StdCtrls.TCheckBox);
  RegisterClassAlias(dsStdCtrl.TCheckBox, 'TCheckBox');

  RegisterClass(StdCtrls.TComboBox);
  UnRegisterClass(StdCtrls.TComboBox);
  RegisterClassAlias(dsStdCtrl.TComboBox, 'TComboBox');

  RegisterClass(ExtCtrls.TPanel);
end;

procedure registerAdditional;
begin
  registerArr([
                TImage, TShape, TBevel, __TNoVisual

                {$IFDEF C_SIZECONTROL}
                 ,TSizeCtrl
                {$ENDIF}

                {$IFDEF NOT_LITE}
                 ,TColorBox, TLabeledEdit, {TColorListBox,}
                 TCheckListBox, TDateTimePicker, TStaticText, TSplitter,
                 TValueListEditor, TValueListStrings, TSplitter,
                 TDrawGrid, TControlBar, TMaskEdit,
                 TStringGrid, TStringGridStrings,
                 TMonthCalendar, TCoolTrayIcon, TDropFilesTarget,
                 TTabSet
                 {$ENDIF}
              ]);
end;

procedure registerWin32;
begin
  registerArr([
                TImageList, TTabControl,  TPageControl,
               // TSmartTabs,
               {$IFDEF NOT_LITE}
                 TTrackBar, TRichEdit, TTabSheet,
                 TUpDown, THotKey, TAnimate, TDateTimePicker,
                 TMonthCalendar,
                 TTreeView, TTreeNode, TTreeNodes,
                  THeaderControl, THeader,
                  TToolBar, TCoolBar, TPageScroller, TComboBoxEx,
                  TListView, TListItems, TListItem, 
                TListColumn, TListColumns,
               {$ENDIF}
               
                TProgressBar,
                TStatusBar
              ]);
end;

procedure registerSystem;
begin
  registerArr([
                TTimer, {TMediaPlayer,} {$IFDEF NOT_LITE}TPaintBox, {$ENDIF}
                 TSizeConstraints
                {$IFDEF NOT_LITE}, THintWindow{$ENDIF}{, TOleContainer}
              ]);
end;

procedure registerGraph;
begin
  registerArr([
                TFont, TMImage,
                Graphics.TGraphicsObject,
                Graphics.TPen,
                Graphics.TBrush,
                Graphics.TPicture,
                Graphics.TMetafileCanvas,
                Graphics.TBitmap,
                Graphics.TMetafile,
                Graphics.TIcon
              ]);
end;

procedure registerSamples;
begin
 {$IFDEF NOT_LITE}
  //registerArr([
      //          {TColorGrid,} TSpinButton, TSpinEdit
        //        {TCalendar, TGauge }
          //    ]);
 {$ENDIF}
end;

procedure registerForms;
begin
  registerArr([
          TForm, TCustomForm,
          {$IFDEF NOT_LITE}
          TFrame, TCustomFrame,
          {$ENDIF}
          TColorDialog, TCommonDialog,

          {$IFDEF NOT_LITE}
          TDataModule,
          {$ENDIF}
          
          TFontDialog,

          {$IFDEF NOT_LITE}
          Forms.TControlScrollBar,
          Forms.TScrollingWinControl,
          Forms.TScrollBox,
          {$ENDIF}

          Forms.TCustomActiveForm,
          Forms.TScreen, TScreenEx,
          TOpenDialog, TSaveDialog

          {$IFDEF NOT_LITE}
          , Dialogs.TPrinterSetupDialog,
          Dialogs.TPrintDialog,
          Dialogs.TPageSetupDialog,
          Dialogs.TFindDialog,
          Dialogs.TReplaceDialog
           {$ENDIF}

     ]);
end;

procedure registerVSEditor;
begin
  {$IFDEF VS_EDITOR}
  registerArr([
                {DockTabSet.TDockTabSet, DockTabSet.TTabDockPanel,}
                
                TNxCustomInspector, TNxScrollBar, TNxControl,
                TNxTextItem, TNxTimeItem, TNxPopupItem,
                TNxToolbarItemButton, TNxToolbarItem,
                TNxCheckBoxItem, TNxButtonItem, TNxMemoItem,
                TNxAlignmentItem, TNxVertAlignmentItem,
                TNxColorItem, TNxCustomNumberItem, TNxSpinItem,
                TNxTrackBarItem, TNxRadioItem, TNxPropertyItem,
                TNxPropertyItems, TNxProgressItem, TNextInspector,
                TNxComboBoxItem,
                TSynEdit,

                TSynPHPSyn, TSynGeneralSyn, TSynCppSyn, TSynCssSyn, TSynHTMLSyn,
                TSynSQLSyn, TSynJScriptSyn, TSynXMLSyn,

                TSynCompletionProposal, TSynHighlighterAttributes,

                TButtonCategory, TButtonCategories,
                TButtonItem, TCategoryButtons

              ]);
   {$ENDIF}
end;

procedure registerSkins;
begin
  {$IFDEF ADD_SKINS}
  registerArr([
               { TsSkinManager, TsSkinProvider, TStaticText,
                TsSpeedButton, TsBitBtn, TsTrackBar, TsProgressBar,
                TsBevel, TsLabel, TsLabelFX }
              ]);
  {$ENDIF}
end;

  var
    Registered: Boolean = false;

procedure registerGui();
begin
  if Registered then
    exit;

    registerForms;
    registerStandart;
    registerAdditional;
    registerWin32;
    registerSystem;
    registerSamples;
    registerGraph;
    
   {$IFDEF ADD_SKINS}
    registerSkins;
   {$ENDIF}

   {$IFDEF ADD_CHROMIUM}
        registerArr([TChromium, TChromiumOptions]);
   {$ENDIF}
   registerVSEditor;
   Registered := true;
end;

initialization
  registerGui;

end.
