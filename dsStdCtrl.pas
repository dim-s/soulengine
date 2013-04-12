unit dsStdCtrl;

{$I 'sDef.inc'}

interface

  uses Forms, Dialogs, SysUtils, Windows, TypInfo, Classes, Controls, Buttons,
  Messages, StdCtrls, Graphics, ExtCtrls, ShellAPI, ComCtrls;

type
  TComponentLabel = class(TCustomControl)
  private
    FCaption: String;
    FPanel: TCustomControl;
    procedure SetCaption(const Value: String);
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption: String read FCaption write SetCaption;
  end;

type
  __TNoVisual = class(TCustomControl)
  private
    FGlyph: TBitmap;
    FLabel: TComponentLabel;
    FfileName: String;
    FrealHeight: Integer;
    FrealWidth: Integer;
    FCaption: String;
    FLabelDblClick: TNotifyEvent;
   // FLabelClick: TNotifyEvent;
    procedure SetfileName(const Value: String);
    procedure SetrealHeight(const Value: Integer);
    procedure SetrealWidth(const Value: Integer);
    procedure SetCaption(const Value: String);
  protected
    procedure SetName(const Value: TComponentName); override;
    procedure Paint; override;
    procedure initLabel;
    procedure WMMove( var Msg : TWMMove ) ; message WM_MOVE ;{процедура для обработки сообщения Wm_move, чтобы метка перемещалась вместе с кнопкой}

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure loadFromFile(fileName: String);
  published
    property __iconName: String read FfileName write SetfileName;
    property realWidth: Integer read FrealWidth write SetrealWidth default 26;
    property realHeight: Integer read FrealHeight write SetrealHeight default 26;
    property Caption: String read FCaption write SetCaption;
    property OnDblClick: TNotifyEvent read FLabelDblClick write FLabelDblClick;
    property Font;
    property Cursor;
    property Visible;
  end;

type
  TDropFilesInfo = class(TPersistent)
  private
    FControl: TWinControl;          // Drop action target control
    FStamp: TDateTime;              // Timestamp of drop action
    FPoint: TPoint;                 // Drop point
    FFiles: TStrings;               // List with filenames
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Control: TWinControl read FControl;
    property Files: TStrings read FFiles;
    property Point: TPoint read FPoint;
    property Stamp: TDateTime read FStamp;
  end;


  TDropFilesEvent = procedure (Sender: TObject; Files: TStrings; X: Integer; Y: Integer) of object;

  TDropFilesTarget = class(TComponent)
  private
    FTargetControl: TWinControl;    // Target control to accept WM_DROPFILES
    FEnabled: Boolean;              // Enable/disable accepting
    FOnDropFiles: TDropFilesEvent;  // Notification handler
    FAcceptingWindow: HWND;         // Window handle that got "DragAcceptFiles"
    FOldWndProc: TWndMethod;        // Old WindowProc method
    procedure DropFiles(hDrop: HDROP);
    procedure NewWndProc(var Msg: TMessage);
    procedure AttachControl;
    procedure DetachControl;
    procedure SetEnabled(AEnabled: Boolean);
    procedure SetTargetControl(AControl: TWinControl);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property TargetControl: TWinControl read FTargetControl write SetTargetControl;
    property OnDropFiles: TDropFilesEvent read FOnDropFiles write FOnDropFiles;
  end;

type
  TEdit = class(StdCtrls.TEdit)
  private
    FInitDraw : Boolean;
    FOldBackColor : TColor;
    FOldFontColor : TColor;
    FColorOnEnter : TColor;
    FFontColorOnEnter: TColor;
    FAlignment: TAlignment;
    FTabOnEnter: boolean;
    FTextHint: String;
    FOnFocus : TNotifyEvent;
    FOnBlur  : TNotifyEvent;
    FMarginLeft: Integer;
    FMarginRight: Integer;

    procedure SetAlignment(Value: TAlignment);
    procedure SetMarginLeft(const Value: Integer);
    procedure SetMarginRight(const Value: Integer);
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

    procedure KeyPress(var Key: Char); override;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    procedure UpdateMargins;
  public
    constructor Create(AOwner:TComponent); override;
  published
    property TextHint: String read FTextHint write FTextHint;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property ColorOnEnter : TColor read FColorOnEnter write FColorOnEnter;
    property FontColorOnEnter : TColor read FFontColorOnEnter write FFontColorOnEnter;

    property TabOnEnter : boolean read FTabOnEnter write FTabOnEnter;
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;

    property MarginLeft: Integer read FMarginLeft write SetMarginLeft;
    property MarginRight: Integer read FMarginRight write SetMarginRight;
  end;

type
  TMemo = class(StdCtrls.TMemo)
  private
    FAlignment: TAlignment;
    FTabOnEnter: boolean;
    
    FOnFocus : TNotifyEvent;
    FOnBlur  : TNotifyEvent;

    procedure SetAlignment(Value: TAlignment);
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

    procedure KeyPress(var Key: Char); override;

    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner:TComponent); override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;

    property TabOnEnter : boolean read FTabOnEnter write FTabOnEnter;
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;

type
  TBitBtn = class(Buttons.TBitBtn)
  private
    FOnFocus : TNotifyEvent;
    FOnBlur  : TNotifyEvent;
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

  public
    constructor Create(AOwner:TComponent); override;
  published
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;

 type
  TListBox = class(StdCtrls.TListBox)
  private
    FAlignment: TAlignment;
    FOnFocus : TNotifyEvent;
    FOnBlur  : TNotifyEvent;
    FTwoColor: TColor;
    FTwoFontColor: TColor;
    FMarginLeft: Integer;
    FBorderSelected: Boolean;
    FReadOnly: Boolean;
    FFonts: TList;
    FColors: TList;

    procedure SetTwoColor(const Value: TColor);
    procedure SetTwoFontColor(const Value: TColor);
    procedure SetMarginLeft(const Value: Integer);
    procedure SetBorderSelected(const Value: Boolean);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetReadOnly(const Value: Boolean);
  protected
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DrawItem(Index: Integer; Rect: TRect;
        State: TOwnerDrawState); override;

  public

    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    procedure SetColor(Index: Integer; Color: TColor);
    function GetColor(Index: Integer): TColor;
    procedure ClearColor(Index: Integer);
    
    function GetFont(Index: Integer): TFont;
    procedure ClearFont(Index: Integer);
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property BorderSelected: Boolean read FBorderSelected write SetBorderSelected;
    property TwoColor: TColor read FTwoColor write SetTwoColor;
    property TwoFontColor: TColor read FTwoFontColor write SetTwoFontColor;
    property MarginLeft: Integer read FMarginLeft write SetMarginLeft;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;


  type
  TCheckBox = class(StdCtrls.TCheckBox)
  private
    FOnFocus : TNotifyEvent;
    FOnBlur  : TNotifyEvent;
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

  public
    constructor Create(AOwner:TComponent); override;
  published
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;

  type
  TComboBox = class(StdCtrls.TComboBox)
  private
    FOnFocus : TNotifyEvent;
    FOnBlur  : TNotifyEvent;
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

  public
    constructor Create(AOwner:TComponent); override;
  published
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;


implementation


constructor TEdit.Create(AOwner: TComponent);
begin
  inherited;

  FColorOnEnter := clNone;
  FFontColorOnEnter := clNone;
  FTextHint := '';

  Alignment := taLeftJustify;
  if (TextHint <> '') and (Text = '') then
    Text := TextHint;

  FInitDraw := False;
end; (*Create*)

procedure TEdit.CreateParams(var Params: TCreateParams);
const
  Alignments : array[TAlignment] of LongWord= (ES_Left,ES_Right, ES_Center);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or Alignments[FAlignment];
  if (TextHint <> '') and (Text = '') then
    Text := TextHint;
end;

procedure TEdit.DoEnter;
begin
  FOldBackColor := Color;
  FOldFontColor := Font.Color;
  if FColorOnEnter <> clNone then
    Color := FColorOnEnter;

  if FFontColorOnEnter <> clNone then
    Font.Color := FFontColorOnEnter;

  if (TextHint <> '') and (TextHint = Text) then
    Text := '';

  if Assigned(FOnFocus) then
    FOnFocus(Self);

  UpdateMargins;

  inherited;
end; (*DoEnter*)

procedure TEdit.DoExit;
begin
  Color := FOldBackColor;
  Font.Color := FOldFontColor;

  if (TextHint <> '') and (Text = '') then
    Text := TextHint;

  if Assigned(FOnBlur) then
    FOnBlur(Self);

  UpdateMargins;

  inherited;
end; (*DoExit*)

procedure TEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
    UpdateMargins;
  end;
end;

procedure TEdit.SetMarginLeft(const Value: Integer);
begin
  FMarginLeft := Value;
  UpdateMargins;
end;

procedure TEdit.SetMarginRight(const Value: Integer);
begin
  FMarginRight := Value;
  UpdateMargins;
end;

procedure TEdit.UpdateMargins;
begin
  SendMessage(Handle, EM_SETMARGINS, EC_LEFTMARGIN,LPARAM(FMarginLeft));
  SendMessage(Handle, EM_SETMARGINS, EC_RIGHTMARGIN,FMarginRight shl 16);
end;

procedure TEdit.WMPaint(var Message: TWMPaint);
begin
   inherited;
   if (TextHint <> '') and (Text = '') then
     Text := TextHint;

   if not FInitDraw then
   begin
     FInitDraw := true;
     UpdateMargins;
   end;

end;

procedure TEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  //UpdateMargins;
  
  if FTabOnEnter AND (Owner is TWinControl) then
  begin
    if Key = Char(VK_RETURN) then
    begin
     if HiWord(GetKeyState(VK_SHIFT)) <> 0 then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0)
     else
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
     Key := #0;
    end;
  end;
end; (*KeyPress*)


{ TMemo }

constructor TMemo.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TMemo.CreateParams(var Params: TCreateParams);
const
  Alignments : array[TAlignment] of LongWord= (ES_Left,ES_Right, ES_Center);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or Alignments[FAlignment];
end;

procedure TMemo.DoEnter;
begin
  if Assigned(FOnFocus) then
    FOnFocus(Self);
    
  inherited;
end;

procedure TMemo.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);
    
  inherited;
end;

procedure TMemo.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);

  if FTabOnEnter AND (Owner is TWinControl) then
  begin
    if Key = Char(VK_RETURN) then
    begin
     if HiWord(GetKeyState(VK_SHIFT)) <> 0 then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0)
     else
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
     Key := #0;
    end;
  end;
end;

procedure TMemo.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

{ TBitBtn }


constructor TBitBtn.Create(AOwner: TComponent);
begin
  inherited;
end;


procedure TBitBtn.DoEnter;
begin
  if Assigned(FOnFocus) then
    FOnFocus(Self);
    
  inherited;
end;

procedure TBitBtn.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);
    
  inherited;
end;


{ TListBox }

constructor TListBox.Create(AOwner: TComponent);
begin
  inherited;
  FTwoColor := clNone;
  FTwoFontColor := clNone;
  FMarginLeft := 2;
  FFonts := TList.Create;
  FColors := TList.Create;
  Style := lbOwnerDrawFixed;
  BorderSelected := true;
  FReadOnly := False;
end;


destructor TListBox.Destroy;
  var
  i: integer;
begin
  for i := 0 to FFonts.Count - 1 do
  if FFonts[i] <> nil then
    TFont(FFonts[i]).Free;

  FFonts.Free;
  FColors.Free;

  inherited;
end;

procedure TListBox.DoEnter;
begin

  if Assigned(FOnFocus) then
    FOnFocus(Self);
    
  inherited;
end;

procedure TListBox.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);
    
  inherited;
end;

procedure TListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
  var
  MyColor, MyFontColor: TColor;
  H: Integer;
  ItemHeight: Integer;
begin

     if (not BorderSelected) and (odFocused in State) then begin
         DrawFocusRect(Canvas.Handle, Rect);
         exit;
     end;

     if FReadOnly then
     begin
        MyColor     := Color;
        MyFontColor := Font.Color;
     end
     else begin
        MyColor := Canvas.Brush.Color;
        MyFontColor := Canvas.Font.Color;
     end;

      if not(odSelected in State) or FReadOnly then
      begin
          if (Index+1) mod 2 = 0 then
          begin
              if (FTwoColor <> clNone) then
                MyColor := TwoColor;

              if (FTwoFontColor <> clNone) then
                MyFontColor := TwoFontColor;
          end;

          if (FColors.Count > Index) and (TColor(FColors[ Index ]) <> clNone) then
          begin
              MyColor := TColor(FColors[ Index ]);
          end;
      end;

      Canvas.Pen.Style := psClear;
      Canvas.Brush.Color := MyColor;
      Canvas.FillRect(Rect);

      if (FFonts.Count > Index) and (FFonts[Index] <> nil) then
      begin
        MyFontColor := Canvas.Font.Color;
        Canvas.Font.Assign( TFont(FFonts[Index]) );
        if (odSelected in State) and not FReadOnly then
          Canvas.Font.Color := MyFontColor;
      end
      else
        Canvas.Font.Color := MyFontColor;

      if Self.ItemHeight > 0 then
          ItemHeight := Self.ItemHeight
      else
          ItemHeight := Canvas.TextHeight(Items[Index]);

      H := Rect.Top + ItemHeight div 2 - Canvas.TextHeight(Items[Index]) div 2;

      case FAlignment of
        taLeftJustify: Canvas.TextOut(Rect.Left + MarginLeft, H, Items[Index]);
        taRightJustify: Canvas.TextOut(Rect.Right - MarginLeft
                           - Canvas.TextWidth(Items[Index]), H, Items[Index]);
        taCenter: Canvas.TextOut(Rect.Left + ((Rect.Right - Rect.Left) div 2)
                                           - (Canvas.TextWidth(Items[Index]) div 2),
                     H, Items[Index]);
      end;
end;

procedure TListBox.ClearColor(Index: Integer);
begin
   if (FColors.Count > Index) and (Index > -1) then
    FColors[ Index ] := Pointer(clNone);
end;

procedure TListBox.ClearFont(Index: Integer);
  var
  Font: TFont;
  i: integer;
begin
  if (Index > Items.Count - 1) or (Index < 0) or (Index > FFonts.Count - 1 )then
   exit;

  if ( FFonts[ Index ] <> nil ) then
    TFont(FFonts[ Index ]).Free;

  FFonts[ Index ]:= nil;
  Invalidate;
end;

function TListBox.GetColor(Index: Integer): TColor;
begin
  if (FColors.Count > Index) and (Index > -1) then
    Result := TColor(FColors[ Index ])
  else
    Result := clNone;
end;

function TListBox.GetFont(Index: Integer): TFont;
  var
  Font: TFont;
  i: integer;
begin

   if Items.Count < FFonts.Count then
   begin
       for i := FFonts.Count - 1 downto Items.Count do
       begin
          if FFonts[i] <> nil then
            TFont(FFonts[i]).Free;

          FFonts.Delete(i);
       end;
   end;

   if (Index > Items.Count - 1) or (Index < 0) then
   begin
     Result := nil;
     exit;
   end;

   if Index > FFonts.Count - 1 then
   begin
       Font := TFont.Create;
       Font.Assign( Self.Font );
       for i := FFonts.Count to Index - 1 do
       begin
          FFonts.Add(nil)
       end;
       FFonts.Add(Font);
       Result := Font;
       exit;
   end;

   if FFonts[ Index ] = nil then
   begin
     Font := TFont.Create;
     Font.Assign( Self.Font );
     FFonts[ Index ] := Font;
     Result := Font;
   end else
     Result := FFonts[ Index ];
end;

procedure TListBox.SetMarginLeft(const Value: Integer);
begin
  FMarginLeft := Value;
  Invalidate;
end;

procedure TListBox.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
  ItemIndex := -1;
end;

procedure TListBox.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TListBox.SetBorderSelected(const Value: Boolean);
begin
  FBorderSelected := Value;
  Invalidate;
end;

procedure TListBox.SetColor(Index: Integer; Color: TColor);
  var
  i: integer;
begin
   if (Index < 0) or (Index > Items.Count - 1) then
      exit;

   for i := FColors.Count to Items.Count - 1 do
      FColors.Add(Pointer(clNone));

   FColors[ Index ] := Pointer( Color );
   Invalidate;
end;

procedure TListBox.SetTwoColor(const Value: TColor);
begin
  FTwoColor := Value;
  Invalidate;
end;

procedure TListBox.SetTwoFontColor(const Value: TColor);
begin
  FTwoFontColor := Value;
  Invalidate;
end;

{ TCheckBox }

constructor TCheckBox.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TCheckBox.DoEnter;
begin
  if Assigned(FOnFocus) then
    FOnFocus(Self);
    
  inherited;
end;

procedure TCheckBox.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);
    
  inherited;
end;

{ TComboBox }
constructor TComboBox.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TComboBox.DoEnter;
begin
  if Assigned(FOnFocus) then
    FOnFocus(Self);

  inherited;
end;

procedure TComboBox.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);

  inherited;
end;

{ TForm }


{ TDropFilesInfo }

constructor TDropFilesInfo.Create;
begin
  inherited;
  FFiles := TStringList.Create;
end;

destructor TDropFilesInfo.Destroy;
begin
  FreeAndNil(FFiles);
  inherited;
end;

procedure TDropFilesInfo.Assign(Source: TPersistent);
begin
  if Source is TDropFilesInfo then
  begin
    FControl := TDropFilesInfo(Source).Control;
    FStamp := TDropFilesInfo(Source).Stamp;
    FPoint := TDropFilesInfo(Source).Point;
    FFiles.Assign(TDropFilesInfo(Source).Files);
  end
  else
    inherited Assign(Source);
end;

{ TDropFilesTarget }

constructor TDropFilesTarget.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled := true;
  if AOwner Is TWinControl then
      SetTargetControl(TWinControl(AOwner));
end;

destructor TDropFilesTarget.Destroy;
begin
  TargetControl := nil;  // This detaches any attached control
  inherited;
end;

procedure TDropFilesTarget.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if Operation = opRemove then
    if AComponent = FTargetControl then
      TargetControl := nil;
end;

{ Do the dropping. Note that DragFinish is called in the window
  procedure and not here.
}
procedure TDropFilesTarget.DropFiles(hDrop: HDROP);
var
  Info: TDropFilesInfo;
  Count, Index, Len: Integer;
  Filename: PChar;
begin
  Info := TDropFilesInfo.Create;
  try
    Info.FStamp := Now;
    Info.FControl := FTargetControl;
    DragQueryPoint(hDrop, Info.FPoint);

    Count := DragQueryFile(hDrop, $ffffffff, nil, 0);
    for Index := 0 to Count - 1 do
    begin
      Len := DragQueryFile(hDrop, Index, nil, 0);
      Filename := AllocMem(Len + 1);
      try
        DragQueryFile(hDrop, Index, Filename, Len + 1);
        TStringList(Info.FFiles).Add(StrPas(Filename));
      finally
        FreeMem(Filename);
      end;
    end;

    FOnDropFiles(Self, Info.FFiles, Info.Point.X, Info.Point.Y);
  finally
    Info.Free;
  end;
end;

{ The new Window procedure for the attached drop target control.
}
procedure TDropFilesTarget.NewWndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
  begin
    try
      if Assigned(FOnDropFiles) then
        DropFiles(Msg.WParam);
    finally
      DragFinish(Msg.WParam);
    end;
    Msg.Result := 0;
  end
  else
  begin
    if Msg.Msg = WM_DESTROY then
      if FAcceptingWindow <> 0 then
        // Don't clear FAcceptingWindow
        DragAcceptFiles(FAcceptingWindow, false);

    FOldWndProc(Msg);

    if Msg.Msg = WM_CREATE then
      // Make it believe the window handle must be refreshed
      FAcceptingWindow := 0;

    if FTargetControl.HandleAllocated then
      if FAcceptingWindow <> FTargetControl.Handle then
      begin
        FAcceptingWindow := FTargetControl.Handle;
        DragAcceptFiles(FAcceptingWindow, true);
      end;
  end;
end;

{ Attach to FTargetControl: subclass, force a window handle and call
  DragAcceptFiles with Accept=true.
}
procedure TDropFilesTarget.AttachControl;
begin
  if [csDesigning, csDestroying] * ComponentState <> [] then
    exit;

  if (FTargetControl = nil) or (not FEnabled) then
    exit;

  if [csDesigning, csDestroying] * FTargetControl.ComponentState <> [] then
    exit;

  FOldWndProc := FTargetControl.WindowProc;
  FTargetControl.WindowProc := NewWndProc;

  // Note: If we don't force a handle here we get problems with controls
  // that call ReCreateWnd before they even got a handle (-> RichEdit).
  FTargetControl.HandleNeeded;
  FAcceptingWindow := FTargetControl.Handle;
  DragAcceptFiles(FAcceptingWindow, true);
end;

{ Detach from FTargetControl: call DragAcceptFiles with Accept=false and
  remove subclassing.
}
procedure TDropFilesTarget.DetachControl;
begin
  if FAcceptingWindow <> 0 then
  begin
    DragAcceptFiles(FAcceptingWindow, false);
    FAcceptingWindow := 0;
  end;

  if @FOldWndProc <> nil then
  begin
    FTargetControl.WindowProc := FOldWndProc;
    FOldWndProc := nil;
  end;
end;

procedure TDropFilesTarget.SetEnabled(AEnabled: Boolean);
begin
  if FEnabled <> AEnabled then
  begin
    DetachControl;
    FEnabled := AEnabled;
    AttachControl;
  end;
end;

procedure TDropFilesTarget.SetTargetControl(AControl: TWinControl);
begin
  if FTargetControl <> AControl then
  begin
    DetachControl;

    if FTargetControl <> nil then
      FTargetControl.RemoveFreeNotification(Self);

    FTargetControl := AControl;

    if FTargetControl <> nil then
      FTargetControl.FreeNotification(Self);

    AttachControl;
  end;
end;



{ TComponentLabel }

constructor TComponentLabel.Create(AOwner: TComponent);
begin
  inherited;
  Width := 1;
  Height := 1;
end;

procedure TComponentLabel.CreateParams(var Params: TCreateParams);
begin
    inherited CreateParams(Params);
    Params.ExStyle := Params.ExStyle or WS_EX_NOPARENTNOTIFY;
end;

destructor TComponentLabel.Destroy;
begin

  inherited;
end;

procedure TComponentLabel.Paint;
begin
 // inherited;
 Visible := FPanel.Visible;
 if not Visible then exit;


  Width  :=  Canvas.TextWidth(Caption)+2;
  Height := Canvas.TextHeight(Caption)+2;

  Canvas.Pen.Style := psClear;
  Canvas.Pen.Width := 0;
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(0,0,Width,Height);
  Canvas.TextOut(1,1, Caption);
end;

procedure TComponentLabel.SetCaption(const Value: String);
begin
  FCaption := Value;
end;


{ __TNoVisual }

constructor __TNoVisual.Create(AOwner: TComponent);
begin
  inherited;
  FGlyph := TBitmap.Create;
  FLabel := TComponentLabel.Create(self);

  FGlyph.Transparent := true;
  FGlyph.TransparentMode := tmAuto;
  realWidth  := 25;
  realHeight := 25;
  Color := clBtnFace;

  Parent := TWinControl(AOwner);
end;

destructor __TNoVisual.Destroy;
begin

//  FLabel.Free;
  FGlyph.Free;
  inherited;
end;

procedure __TNoVisual.initLabel;
begin
  if Parent = nil then exit;

 FLabel.Parent := Self.Parent;
 FLabel.Font.Assign(Self.Font);
 FLabel.Color := Color;
 FLabel.Caption := Name;
 FLabel.FPanel := self;
 FLabel.BringToFront;

 FLabel.Left := Round(Left + (realWidth/2) - (FLabel.Canvas.TextWidth(Name)/2) - 1 );
 FLabel.Top  := Top + Height + 3;
 FLabel.OnDblClick := OnDblClick;
 FLabel.OnClick    := OnClick;
end;

procedure __TNoVisual.loadFromFile(fileName: String);
begin
  FfileName := fileName;
  FGlyph.LoadFromFile(fileName);
end;

procedure __TNoVisual.Paint;
begin
  //if not Visible then exit;
  inherited;
  if Parent = nil then exit;
  

  Canvas.Pen.Style := psAlternate;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(0,0,Width,Height);

  if FLabel <> nil then
  begin
    FLabel.Caption := Name;
    FLabel.Left := Round(Left + (realWidth/2) - (Canvas.TextWidth(Name)/2) - 1 );
    FLabel.Top  := Top + Height + 3;
    FLabel.Paint;
  end;

  if not FGlyph.Empty then
  begin
      Canvas.Draw( Round((Width/2)-(FGlyph.Width/2)),
                   Round((Height/2)-(FGlyph.Height/2)),
                   FGlyph );
  end;

end;


procedure __TNoVisual.SetCaption(const Value: String);
begin
  FCaption := Value;
  initLabel;
end;

procedure __TNoVisual.SetfileName(const Value: String);
begin
  if Value = '' then
    FGlyph.FreeImage
  else
    loadFromFile(Value);

  FfileName := '';
  initLabel;
end;


procedure __TNoVisual.SetName(const Value: TComponentName);
begin
  inherited;
  if FLabel <> nil then
  begin
    FLabel.Caption := Name;
    FLabel.Left := Round(Left + (realWidth/2) - (Canvas.TextWidth(Name)/2) - 1 );
    FLabel.Top  := Top + Height + 3;
    FLabel.Paint;
  end;
end;

procedure __TNoVisual.SetrealHeight(const Value: Integer);
begin
  FrealHeight := Value;
  Height := Value;
  Constraints.MinHeight := Value;
  Constraints.MaxHeight := Value;
end;

procedure __TNoVisual.SetrealWidth(const Value: Integer);
begin
  FrealWidth := Value;
  Width := Value;
  Constraints.MinWidth := Value;
  Constraints.MaxWidth := Value;
end;

procedure __TNoVisual.WMMove(var Msg: TWMMove);
begin
  inherited;
  initLabel;
end;


end.
