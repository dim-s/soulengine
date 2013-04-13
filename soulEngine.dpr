program soulEngine;

{$I 'sDef.inc'}

uses
  Forms,
  Dialogs,
  SysUtils,
  uMain in 'uMain.pas' {__fMain},
  uMainForm in 'uMainForm.pas' {__mainForm},
  uPHPMod in 'uPHPMod.pas' {phpMOD: TDataModule},
  uGuiScreen in 'uGuiScreen.pas',
  uApplication in 'uApplication.pas',

  {$IFDEF VS_EDITOR}
  uPHPCatButtons in 'uPHPCatButtons.pas',
  uVSEditor in 'uVSEditor.pas',
  {$ENDIF}

   regGui in 'regGui.pas';

{$R *.res}

{

  $IFDEF ADD_HTMLREAD
  uHTMLView in 'units\uHTMLView.pas',
  $ENDIF

  $IFDEF VS_EDITOR
  uPHPCatButtons in 'units\uPHPCatButtons.pas',
  uVSEditor in 'units\uVSEditor.pas',
  $ENDIF

}

{var
  isPSE: Boolean;
 }
begin
  Application.Initialize;

  Application.MainFormOnTaskBar := false;
  Application.ShowMainForm      := false;


  Application.CreateForm(T__mainForm, __mainForm);
  Application.CreateForm(T__fMain, __fMain);
  Application.CreateForm(TphpMOD, phpMOD);
  {$IFDEF VS_EDITOR}
  Application.CreateForm(TphpVSEditor, phpVSEditor);
  {$ENDIF}


  {$IFDEF VS_EDITOR}
  Application.CreateForm(TPHPCatButtons, PHPCatButtons);
  {$ENDIF}
  
   T__fMain.loadEngine(dllPHPPath);

  //if not isPSE then
    __mainForm.FormActivate(__mainForm);

  Application.Run;

end.
