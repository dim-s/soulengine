{$R NxEditRes.res}
{$I NxSuite.inc}

unit NxEdit;

interface

uses
	Types, Classes, Controls, Windows, Graphics, StdCtrls, ExtCtrls,
  Messages, Forms, Dialogs, ExtDlgs, ImgList,
  NxClasses, NxConsts, NxStdCtrls, NxPopupControl, NxThemesSupport, NxSharedDraw, NxSharedCommon;

const
  sizExecuteButton = 21;
  sizFastInterval = 20;
  sizSlowInterval = 400;
  crReversedArrow = 1000;
  spGlyphIndent = 2;

  { Space between checkbox and text }
  spChkBoxTextIndent = 4;

  strNone = 'None';
  strToday = 'Today';

type
  TArrowStyle = (asUp, asDown);
  TDropDownStyle = (dsDropDown, dsDropDownList);
  TNxNumberEditOptions = set of (eoAllowAll, eoAllowFloat, eoAllowSigns, eoDisablePaste, eoDisableTyping);
  TNxEditOptions = set of (epDisablePaste, epDisableTyping);
  TCursorDirection = (cdLeft, cdRight);

  TEditEvent = procedure (Sender: TObject) of object;
  TCustomPreviewDrawEvent = procedure (Sender: TObject; PreviewRect: TRect) of object;

  TNxCustomEdit = class;

  TNxEditMargins = class(TPersistent)
  private
    FOwner: TNxCustomEdit;
    FLeft: Integer;
    FRight: Integer;
    procedure SetLeft(const Value: Integer);
    procedure SetRight(const Value: Integer);
  public
    constructor Create(AOwner: TNxCustomEdit);
  published
    property Left: Integer read FLeft write SetLeft default 0;
    property Right: Integer read FRight write SetRight default 0;
  end;

  TNxMargins = class(TPersistent)
  private
    FTop: Integer;
    FBottom: Integer;
    FOwner: TNxCustomEdit;
    FRight: Integer;
    FLeft: Integer;
    procedure SetBottom(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetRight(const Value: Integer);
    procedure SetTop(const Value: Integer);
  public
    constructor Create(AOwner: TNxCustomEdit);
  published
    property Bottom: Integer read FBottom write SetBottom default 0;
    property Left: Integer read FLeft write SetLeft default 0;
    property Top: Integer read FTop write SetTop default 0;
    property Right: Integer read FRight write SetRight default 0;
  end;

  TNxEditInfo = class(TCustomControl)
  private
    FOwner: TNxCustomEdit;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Canvas;
  end;

  TNxCustomEdit = class(TNxEditControl)
  private
    FAlignment: TAlignment;
    FCanvas: TCanvas;
    FEditInfo: TNxEditInfo;
    FEditing: Boolean;
    FEditMargins: TNxEditMargins;
    FEditorUpdating: Boolean;
    FGlyph: Graphics.TBitmap;
    FInplaceEditor: Boolean;
    FOnCustomPreviewDraw: TCustomPreviewDrawEvent;
    FOnGlyphClick: TNotifyEvent;
    FPreviewBorder: Boolean;
    FShowPreview: Boolean;
    FWantTabs: Boolean;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetEditorUpdating(const Value: Boolean);
    procedure SetGlyph(const Value: Graphics.TBitmap);
    procedure SetInplaceEditor(const Value: Boolean);
    procedure SetPreviewBorder(const Value: Boolean);
    procedure SetShowPreview(const Value: Boolean);
    procedure UpdateGlyph;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    function GetAsBoolean: Boolean; virtual;
    function GetAsDateTime: TDateTime; virtual;
    function GetAsFloat: Double; virtual;
    function GetAsInteger: Integer; virtual;
    function GetAsString: WideString; virtual;
    function GetDefaultDrawing: Boolean; virtual;
    function GetEditLeft: Integer;
    function GetPreviewRect: TRect; virtual;
    procedure DoCustomPreviewDraw(PreviewRect: TRect); dynamic;
    procedure DoEditInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); virtual;
    procedure DoGlyphClick; dynamic;
    procedure DoGlyphChange(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; virtual;
    procedure PaintPreview(Canvas: TCanvas; var ARect: TRect); virtual;
    procedure RedrawBorder;
    procedure RefreshPreview;
    procedure SetAsBoolean(const Value: Boolean); virtual;
    procedure SetAsDateTime(const Value: TDateTime); virtual;
    procedure SetAsFloat(const Value: Double); virtual;
    procedure SetAsInteger(const Value: Integer); virtual;
    procedure SetAsString(const Value: WideString); virtual;
    procedure UpdateEditMargins(var LeftMargin, RightMargin: Integer); virtual;
    procedure UpdateEditRect;
    procedure UpdateInfoRect;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyEditing; virtual;
    procedure BeginEditing; virtual;
    procedure EndEditing; virtual;
    procedure PressKey(Key: TChar);
  	property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
  	property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
  	property AsFloat: Double read GetAsFloat write SetAsFloat;
  	property AsInteger: Integer read GetAsInteger write SetAsInteger;
  	property AsString: WideString read GetAsString write SetAsString;
    property Canvas: TCanvas read FCanvas;
    property Editing: Boolean read FEditing;
    property EditorUpdating: Boolean read FEditorUpdating write SetEditorUpdating;
    property InplaceEditor: Boolean read FInplaceEditor write SetInplaceEditor;
	published
  	property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Constraints;
    property CharCase;
    property EditMargins: TNxEditMargins read FEditMargins write FEditMargins;
    property Enabled;
  	property Font;
    property Glyph: Graphics.TBitmap read FGlyph write SetGlyph;
    property MaxLength;
    property ParentColor;
    property ParentFont;
    property PreviewBorder: Boolean read FPreviewBorder write SetPreviewBorder default True;
    property TabOrder;
    property TabStop;
    property Text;
    property PasswordChar;
    property ReadOnly;
    property ShowHint;
    property ShowPreview: Boolean read FShowPreview write SetShowPreview default False;
    property Visible;
    property WantTabs: Boolean read FWantTabs write FWantTabs default False;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnCustomPreviewDraw: TCustomPreviewDrawEvent read FOnCustomPreviewDraw write FOnCustomPreviewDraw;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGlyphClick: TNotifyEvent read FOnGlyphClick write FOnGlyphClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;                      

  TNxEdit = class(TNxCustomEdit)
  protected
    procedure DoTextChange; dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure SetAsString(const Value: WideString); override;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
  	constructor Create(AOwner: TComponent); override;
    procedure BeginEditing; override;
  end;

  TNxCustomNumberEdit = class(TNxEdit)
  private
    FMax: Double;
    FMin: Double;
    FNullText: TCaption;
    FOptions: TNxNumberEditOptions;
    FPrecision: Integer;
    FTextAfter: TCaption;
    FValue: Double;
    procedure AdjustToRange(var Value: Double);
    function CheckRange: Boolean;
    function GetValue: Double;
    function GetValidText(UnCheckedText: string; AllowFloat, AllowSigns: Boolean): string;
    procedure SetNullText(const Value: TCaption);
    procedure SetOptions(const Value: TNxNumberEditOptions);
    procedure SetPrecision(Value: Integer);
    procedure SetTextAfter(const Value: TCaption);
    procedure SetValue(Value: Double);
    procedure SetValueToText(SendValue: Double);
  protected
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    procedure CMPaste(var Msg: TMessage); message WM_PASTE;
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
  public
    procedure ApplyEditing; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
    function GetFormatedValue(AValue: Double): WideString;
	published
    property Max: Double read FMax write FMax;
    property Min: Double read FMin write FMin;
    property NullText: TCaption read FNullText write SetNullText;
    property Options: TNxNumberEditOptions read FOptions write SetOptions default [eoAllowFloat, eoAllowSigns];
    property Precision: Integer read FPrecision write SetPrecision default 2;
    property TextAfter: TCaption read FTextAfter write SetTextAfter;
    property Value: Double read GetValue write SetValue;
  end;

  TNxNumberEdit = class(TNxCustomNumberEdit)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCellEditorClass = class of TNxCustomEdit;
  TSmallButtonClass = class of TNxSmallButton;

  TNxSmallButton = class(TCustomControl)
  private
  	FDown: Boolean;
    FHover: Boolean;
    FCellEditor: TNxCustomEdit;
    FOnButtonDown: TNotifyEvent;
    FOnButtonClick: TNotifyEvent;
    FCaption: WideString;
    procedure SetDown(const Value: Boolean);
    procedure SetHover(const Value: Boolean);
    procedure SetCaption(const Value: WideString);
	protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  	procedure Paint; override;
    { Messages }
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
	  procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
	  procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Caption: WideString read FCaption write SetCaption;
    property CellEditor: TNxCustomEdit read FCellEditor write FCellEditor;
    property Down: Boolean read FDown write SetDown;
		property Hover: Boolean read FHover write SetHover;
  	property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  	property OnButtonDown: TNotifyEvent read FOnButtonDown write FOnButtonDown;
  end;

  TNxExecuteButton = class(TNxSmallButton)
  private
    FGlyph: TBitmap;
    procedure SetGlyph(const Value: TBitmap);
  protected
  	procedure Paint; override;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Caption;
    property Glyph: TBitmap read FGlyph write SetGlyph;
  end;

  TDropDownButton = class(TNxSmallButton)
  protected
  	procedure Paint; override;
  public
  	constructor Create(AOwner: TComponent); override;
  end;

  TSpinButtonSet = set of (sbUp, sbDown);
  TSpinEvent = procedure (Sender: TObject; Buttons: TSpinButtonSet) of object;

  TNxSpinButtons = class(TCustomControl)
  private
    FCellEditor: TNxCustomEdit;
    FDelayTimer: TTimer;
    FHoverButtons: TSpinButtonSet;
    FPressedButtons: TSpinButtonSet;
    FRepeatTimer: TTimer;
    FOnSpin: TSpinEvent;
    procedure SetHoverButtons(const Value: TSpinButtonSet);
    procedure SetPressedButtons(const Value: TSpinButtonSet);
  protected
  	procedure Paint; override;
    procedure DoDelayTimer(Sender: TObject);
    procedure DoRepeatTimer(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
	public
    constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
    property CellEditor: TNxCustomEdit read FCellEditor write FCellEditor;
    property HoverButtons: TSpinButtonSet read FHoverButtons write SetHoverButtons;
    property PressedButtons: TSpinButtonSet read FPressedButtons write SetPressedButtons;
    property Width;
    property OnSpin: TSpinEvent read FOnSpin write FOnSpin;
  end;

  TNxCustomButtonEdit = class(TNxEdit)
  private
    FOptions: TNxEditOptions;
    FOnButtonClick: TNotifyEvent;
    FShowButton: Boolean;
    procedure SetShowButton(const Value: Boolean);
	protected
    FButton: TNxSmallButton;
    FPopupControl: TNxPopupControl;
    procedure CreatePopupControl; virtual;
    function GetButtonClass: TSmallButtonClass; virtual;
    function GetPopupControlClass: TNxPopupControlClass; virtual;
    procedure ApplyInput(Value: string); virtual;
    procedure CreateWnd; override;
    procedure BeforeDrop(var APoint: TPoint); virtual;
    procedure DoButtonClick(Sender: TObject); dynamic;
    procedure DoButtonDown(Sender: TObject); dynamic;
    procedure DoDropDownDeactivate(Sender: TObject);
    procedure DoDropDownInput(Sender: TObject; Value: string); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure UpdateEditMargins(var LeftMargin, RightMargin: Integer); override;
    procedure UpdateButton; virtual;
	  procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
	  procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMPaste(var Msg: TMessage); message WM_PASTE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginEditing; override;
  published
    property Options: TNxEditOptions read FOptions write FOptions default [];
    property ShowButton: Boolean read FShowButton write SetShowButton default True;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
	end;

  TNxButtonEdit = class(TNxCustomButtonEdit)
  private
    FButtonGlyph: Graphics.TBitmap;
    FButtonCaption: WideString;
    FButtonWidth: Integer;
    FTransparentColor: TColor;
    procedure ApplyTransparency;
    procedure SetButtonGlyph(const Value: Graphics.TBitmap);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetButtonCaption(const Value: WideString);
    procedure SetButtonWidth(const Value: Integer);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ButtonCaption: WideString read FButtonCaption write SetButtonCaption;
    property ButtonGlyph: Graphics.TBitmap read FButtonGlyph write SetButtonGlyph;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth default 21;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor;
  end;

  TNxMultiButtonEdit = class(TNxEdit)
  private
//    FButtons: TList;
  public
//    constructor Create(AOwner: TComponent); override;
//    destructor Destroy; override;
  published

  end;

  TNxImagePathEdit = class(TNxButtonEdit)
  protected
    procedure DoButtonClick(Sender: TObject); override;
  end;

  TDialogType = (dtBrowseFolder, dtOpenFile, dtSaveFile);

  TNxFolderEdit = class(TNxButtonEdit)
  private
    FRoot: string;
    FDialogCaption: string;
  public
    constructor Create(AOwner: TComponent); override;
  published
    procedure DoButtonClick(Sender: TObject); override;
    property DialogCaption: string read FDialogCaption write FDialogCaption;
    property Root: string read FRoot write FRoot;
  end;

  TNxPopupEdit = class(TNxCustomButtonEdit)
  private
    FDroppedDown: Boolean;
    FStyle: TDropDownStyle;
    FHideFocus: Boolean;
    FOnCloseUp: TNotifyEvent;
    FOnSelect: TNotifyEvent;
    function GetFillColor: TColor; 
    procedure SetHideFocus(const Value: Boolean);
    procedure SetDroppedDown(const Value: Boolean);
  protected
    procedure CreatePopupControl; override;
    function GetButtonClass: TSmallButtonClass; override;
    function GetDefaultDrawing: Boolean; override;
    procedure DoButtonDown(Sender: TObject); override;
    procedure DoDropDownInput(Sender: TObject; Value: string); override;
    procedure DoCloseUp; dynamic;
    procedure DoEditInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DoSelect; dynamic;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure SetStyle(const Value: TDropDownStyle); virtual;
    procedure VisibleChanging; override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
  public
    property DroppedDown: Boolean read FDroppedDown write SetDroppedDown;
    property PopupControl: TNxPopupControl read FPopupControl write FPopupControl;
  published
    property HideFocus: Boolean read FHideFocus write SetHideFocus;
    property Style: TDropDownStyle read FStyle write SetStyle default dsDropDown;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
  end;

  TNxComboBox = class(TNxPopupEdit)
  private
    FDisplayMode: TItemsDisplayMode;
    FDropDownColor: TColor;
    FDropDownCount: Integer;
    FHighlightTextColor: TColor;
    FImages: TCustomImageList;
    FItemHeight: Integer;
    FItemIndex: Integer;
    FItems: TNxStrings;
    FSelectionColor: TColor;
    FListWidth: Integer;
    function GetItemName: string;
    function GetItemValue: string;
    procedure SetItems(const Value: TNxStrings);
    procedure SetDropDownCount(const Value: Integer);
    procedure SetHighlightTextColor(const Value: TColor);
    procedure SetItemIndex(const Value: Integer);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetItemHeight(const Value: Integer);
    procedure SetSelectionColor(const Value: TColor);
    procedure SetDropDownColor(const Value: TColor);
    procedure SetListWidth(const Value: Integer);
  protected
    procedure ApplyInput(Value: string); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DoDropDownInput(Sender: TObject; Value: string); override;
    function GetPopupControlClass: TNxPopupControlClass; override;
    function GetValueFromIndex(const Index: Integer): string;
    procedure BeforeDrop(var APoint: TPoint); override;
    procedure DoTextChange; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure PaintPreview(Canvas: TCanvas; var ARect: TRect); override;
    procedure SetStyle(const Value: TDropDownStyle); override;
    procedure SetTextFromItemIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IndexInRange(const Index: Integer): Boolean;
    function LocateKey(Key: TChar): Integer;
    function SearchFor(const S: TString): Integer;
    property ItemName: string read GetItemName;
    property ItemValue: string read GetItemValue;
  published
    property DisplayMode: TItemsDisplayMode read FDisplayMode write FDisplayMode default dmDefault;
    property DropDownColor: TColor read FDropDownColor write SetDropDownColor default clWindow;
		property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property HighlightTextColor: TColor read FHighlightTextColor write SetHighlightTextColor default clHighlightText;
    property Images: TCustomImageList read FImages write SetImages;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 16;
		property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
  	property Items: TNxStrings read FItems write SetItems;
    property ListWidth: Integer read FListWidth write SetListWidth default 0;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clHighlight;
  end;

  TNxFontComboBox = class(TNxComboBox)
  protected
    function GetPopupControlClass: TNxPopupControlClass; override;
    procedure BeforeDrop(var APoint: TPoint); override;
    procedure PaintPreview(Canvas: TCanvas; var ARect: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TNxCanvasCellEditor = class(TCustomControl)
  private
    FAlignment: TAlignment;
    FVerticalAlignment: TVerticalAlignment;
    FMargin: Integer;
    FBorderStyle: TBorderStyle;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetVerticalAlignment(const Value: TVerticalAlignment);
    procedure SetMargin(const Value: Integer);
    procedure SetBorderStyle(const Value: TBorderStyle);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RedrawBorder;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  	property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Color;
    property Constraints;
    property Enabled;
  	property Font;
    property Margin: Integer read FMargin write SetMargin default 0;
    property ParentColor default False;
    property ParentFont;
    property TabOrder;
    property TabStop;
    property Text;
    property ShowHint;
    property VerticalAlignment: TVerticalAlignment read FVerticalAlignment write SetVerticalAlignment default taVerticalCenter;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TCheckBoxOptions = set of (coExpandActiveRect);

  TNxCheckBox = class(TNxCanvasCellEditor)
  private
    FCaption: WideString;
    FChecked: Boolean;
    FDown: Boolean;
    FGrayed: Boolean;
    FHover: Boolean;
    FIndent: Integer;
    FOnChange: TNotifyEvent;
    FOptions: TCheckBoxOptions;
    function GetCheckBoxRect: TRect;
    procedure SetChecked(const Value: Boolean);
    procedure SetGrayed(const Value: Boolean);
    procedure SetHover(const Value: Boolean);
    procedure SetCaption(const Value: WideString);
    procedure SetOptions(const Value: TCheckBoxOptions);
    procedure SetIndent(const Value: Integer);
  protected
    function GetAsBoolean: Boolean;
    function GetAsString: WideString;
    function GetDefaultDrawing: Boolean;
    function DrawCheckBox: TRect;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  	procedure Paint; override;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsString(const Value: WideString);
    { messages }
	  procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    property Hover: Boolean read FHover write SetHover;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginEditing;
    procedure Clear;
	published
    property Caption: WideString read FCaption write SetCaption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Grayed: Boolean read FGrayed write SetGrayed default False;
    property Indent: Integer read FIndent write SetIndent default spChkBoxTextIndent;
    property Options: TCheckBoxOptions read FOptions write SetOptions default [];
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TNxRadioButton = class(TNxCanvasCellEditor)
  private
    FCaption: WideString;
    FChecked: Boolean;
    FDown: Boolean;
    FGrayed: Boolean;
    FHover: Boolean;
    FIndent: Integer;
    FOnChange: TNotifyEvent;
    FOptions: TCheckBoxOptions;
    function GetCheckBoxRect: TRect;
    procedure SetChecked(const Value: Boolean);
    procedure SetGrayed(const Value: Boolean);
    procedure SetHover(const Value: Boolean);
    procedure SetCaption(const Value: WideString);
    procedure SetOptions(const Value: TCheckBoxOptions);
    procedure SetIndent(const Value: Integer);
  protected
    function GetAsBoolean: Boolean;
    function GetAsString: WideString;
    function GetDefaultDrawing: Boolean;
    function DrawRadioButton: TRect;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  	procedure Paint; override;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsString(const Value: WideString);
    { messages }
	  procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    property Hover: Boolean read FHover write SetHover;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginEditing;
    procedure Clear;
	published
    property Caption: WideString read FCaption write SetCaption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Grayed: Boolean read FGrayed write SetGrayed default False;
    property Indent: Integer read FIndent write SetIndent default spChkBoxTextIndent;
    property Options: TCheckBoxOptions read FOptions write SetOptions default [];
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TNxDatePicker = class(TNxPopupEdit)
  private
    FDayNames: TStrings;
    FEmptyText: string;
    FMonthNames: TStrings;
    FNoneCaption: WideString;
    FShowNoneButton: Boolean;
    FStartDay: TStartDayOfWeek;
    FTodayCaption: WideString;
    procedure SetDayNames(const Value: TStrings);
    procedure SetEmptyText(const Value: string);
    procedure SetMonthNames(const Value: TStrings);
    procedure SetShowNoneButton(const Value: Boolean);
    procedure SetTodayCaption(const Value: WideString);
    procedure SetNoneCaption(const Value: WideString);
    procedure SetStartDay(const Value: TStartDayOfWeek);
  protected
    function GetAsDateTime: TDateTime; override;
    function GetPopupControlClass: TNxPopupControlClass; override;
    procedure BeforeDrop(var APoint: TPoint); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetValueToText(SendValue: TDateTime);
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  	property Date: TDateTime read GetAsDateTime write SetAsDateTime;
    property DayNames: TStrings read FDayNames write SetDayNames;
    property EmptyText: string read FEmptyText write SetEmptyText;
    property MonthNames: TStrings read FMonthNames write SetMonthNames;
    property NoneCaption: WideString read FNoneCaption write SetNoneCaption;
    property ShowNoneButton: Boolean read FShowNoneButton write SetShowNoneButton default True;
    property StartDay: TStartDayOfWeek read FStartDay write SetStartDay default dwSunday;
    property TodayCaption: WideString read FTodayCaption write SetTodayCaption;
  end;

  TNxColorPickerOptions = set of (coAllowColorNames, coColorsButton, coNoneButton);

  TNxColorPicker = class(TNxPopupEdit)
  private
    FOnColorOver: TColorOverEvent;
    FOnDialogClose: TDialogCloseEvent;
    FOptions: TNxColorPickerOptions;
    FSelectedColor: TColor;
    FWebColorFormat: Boolean;
    function GetColorFromText(const Value: string): TColor;
    function GetValidText(UnCheckedText: string; AddPrefix: Boolean): string;
    function IsValidColorName(const ColorName: string): Boolean;
    procedure CorrectLenght(var S: string);
    procedure SetOptions(const Value: TNxColorPickerOptions);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetWebColorFormat(const Value: Boolean);
    function GetColorDialog: TColorDialog;
  protected
    procedure CreatePopupControl; override;
    procedure CreateWnd; override;
    function GetColorAsString(const Value: TColor): string;
    function GetPopupControlClass: TNxPopupControlClass; override;
    procedure BeforeDrop(var APoint: TPoint); override;
    procedure DoColorOver(Sender: TObject; Value: TColor); dynamic;
    procedure DoDialogClose(Sender: TObject; Execute: Boolean); dynamic;
    procedure DoDropDownInput(Sender: TObject; Value: string); override;
    procedure DoTextChange; override;
    procedure KeyPress(var Key: Char); override;
    procedure PaintPreview(Canvas: TCanvas; var ARect: TRect); override;
    procedure CMPaste(var Msg: TMessage); message WM_PASTE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetTextToColor(Value: string);
  published
    property ColorDialog: TColorDialog read GetColorDialog;
    property Options: TNxColorPickerOptions read FOptions write SetOptions;
  	property SelectedColor: TColor read FSelectedColor write SetSelectedColor;
    property WebColorFormat: Boolean read FWebColorFormat write SetWebColorFormat default False;
    property OnColorOver: TColorOverEvent read FOnColorOver write FOnColorOver;
    property OnDialogClose: TDialogCloseEvent read FOnDialogClose write FOnDialogClose;
  end;

  TNxMemo = class(TCustomMemo)
  private
    FMargin: Integer;
    procedure SetMargin(const Value: Integer);
  protected
    function GetEditRect: TRect; virtual;
    procedure CreateWnd; override;
    procedure RedrawBorder;
    procedure UpdateEditRect;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(const AFormat: string; const Args: array of const); overload;
    procedure Add(const S: string); overload;
  published
    property Align;
    property Alignment;
    property Anchors;
    property BevelKind default bkNone;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Lines;
    property Margin: Integer read FMargin write SetMargin default 0;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxSpinEdit = class(TNxCustomNumberEdit)
  private
    FButtons: TNxSpinButtons;
    FIncrement: Double;
    FOnSpin: TSpinEvent;
    FSpinButtons: Boolean;
    procedure SetIncrement(const Value: Double);
    procedure SetSpinButtons(const Value: Boolean);
  protected
    procedure CreateWnd; override;
    { Mouse }
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint) : Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint) : Boolean; override;
		procedure DoSpin(Sender: TObject; Buttons: TSpinButtonSet); dynamic;
    procedure UpdateButtonRect;
    procedure UpdateEditMargins(var LeftMargin, RightMargin: Integer); override;
    { values }
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    { Messages }
	  procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
	  procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMKeyUP(var Message: TWMKeyUP); message WM_KEYUP;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginEditing; override;
  published
    property Increment: Double read FIncrement write SetIncrement;
    property Precision default 0;
    property SpinButtons: Boolean read FSpinButtons write SetSpinButtons default True;
    property OnSpin: TSpinEvent read FOnSpin write FOnSpin;
  end;

  TNxTimeElement = (teHour, teMin, teSec, teAMPM);

{$HINTS OFF}
  TNxTimeEdit = class(TNxEdit)
  private
    FButtons: TNxSpinButtons;
    FSpinButtons: Boolean;
    FTimeFormat: string;
    FTimeSeparator: string;
    function GetTimeFormat: string;
    function GetTimeSeparator: string;
    function GetValidText(UnCheckedText: string): string;
    function CleanTimeFormat(Value: string): string;
    procedure SetSpinButtons(const Value: Boolean);
    procedure SetTimeFormat(const Value: string);
    procedure SerTimeSeparator(const Value: string);
  protected
    procedure UpdateButtonRect;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Is24HourFormat: Boolean;
    procedure SetTimeToColor;
  published
    property SpinButtons: Boolean read FSpinButtons write SetSpinButtons default True;
    property TimeFormat: string read FTimeFormat write SetTimeFormat;
    property TimeSeparator: string read FTimeSeparator write SerTimeSeparator;
  end;
{$HINTS ON}

  TCalcOperation = (cpNone, cpDivide, cpMultiply, cpMinus, cpPlus);
  TCalcEditOptions = set of (coAllowFloat, coAllowSigns, coMoveCursor);

  TNxCalcEdit = class(TNxPopupEdit)
  private
    FAutoClose: Boolean;
    FFormatMask: string;
    FMax: Double;
    FMemory: Double;
    FMin: Double;
    FOperation: TCalcOperation;
    FOptions: TNxNumberEditOptions;
    FReset: Boolean;
    FValue: Double;
    function GetValue: Double;
    procedure SetFormatMask(const Value: string);
    procedure SetOptions(const Value: TNxNumberEditOptions);
    procedure SetValue(const Value: Double);
    procedure SetValueToText(SendValue: Double);
  protected
    function GetPopupControlClass: TNxPopupControlClass; override;
    procedure CalculateValue;
    procedure BeforeDrop(var APoint: TPoint); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MoveCursor;
    { Messages }
    procedure CMPaste(var Msg: TMessage); message WM_PASTE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsMemoryEmpty: Boolean;
    procedure AddNumber(const Number: Integer);
    procedure AddDot;
    procedure Backspace;
    procedure ClearMemory;
    procedure ClearValue;
    procedure Divide;
    procedure Erase;
    procedure Equal;
    procedure Memory;
    procedure Minus;
    procedure Multiply;
    procedure Plus;
    procedure Ratio;
    procedure RestoreMemory;
    procedure Sign;
    procedure Sqrt;
    property FormatMask: string read FFormatMask write SetFormatMask;
  published
    property AutoClose: Boolean read FAutoClose write FAutoClose default False;
    property Max: Double read FMax write FMax;
    property Min: Double read FMin write FMin;
    property Options: TNxNumberEditOptions read FOptions write SetOptions default [eoAllowFloat, eoAllowSigns];
    property Value: Double read GetValue write SetValue;
  end;

  TNxMemoInplaceEdit = class(TNxButtonEdit)
  private
    FScrollBars: TScrollStyle;
    FWantReturns: Boolean;
    FWordWrap: Boolean;
    procedure SetScrollBars(const Value: TScrollStyle);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  public
  	constructor Create(AOwner: TComponent); override;
  published
    property AutoSize default False;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssNone;
    property WantReturns: Boolean read FWantReturns write FWantReturns default True;
    property WordWrap: Boolean read FWordWrap write FWordWrap default True;
  end;

  TNxDayFontEvent = procedure(Sender: TObject; Day: Integer; Font: TFont) of object;

  TNxMonthCalendar = class(TCustomControl)
  private
    FDate: TDate;
    FDay: Word;
    FDayNames: TStrings;
    FDown: Boolean;
    FMonth: Word;
    FMonthNames: TStrings;
    FNoneButton: TNxMiniButton;
    FNoneCaption: WideString;
    FOldRect: TRect;
    FOnChange: TNotifyEvent;
    FOnDayFont: TNxDayFontEvent;
		FSelectedDate: TDate;
    FShowNoneButton: Boolean;
    FStartDay: TStartDayOfWeek;
    FTodayButton: TNxMiniButton;
    FTodayCaption: WideString;
    FYear: Word;
    function GetActualStartDay: TStartDayOfWeek;
    function GetDateAtPos(ACol, ARow: Integer): TDate;
    function GetDayInWeekChar(DayInWeek: Integer): Char;
    function GetDayOfWeek(Day: TDateTime): Integer;
    function GetMonthName(Month: Integer): WideString;
    procedure SelectDate(X, Y: Integer);
    procedure SetDate(const Value: TDate);
    procedure SetDay(const Value: Word);
    procedure SetMonth(const Value: Word);
    procedure SetMonthNames(const Value: TStrings);
    procedure SetNoneCaption(const Value: WideString);
    procedure SetPastMonth(var AYear, AMonth: Integer; Decrease: Boolean = True);
    procedure SetSelectedDate(const Value: TDate);
    procedure SetShowNoneButton(const Value: Boolean);
    procedure SetTodayCaption(const Value: WideString);
    procedure SetYear(const Value: Word);
    procedure SetStartDay(const Value: TStartDayOfWeek);
    procedure SetDayNames(const Value: TStrings);
  protected
    procedure CreateWnd; override;
    function GetDaysRect: TRect;
    function GetMonthRect: TRect;
    procedure DoButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
    	X, Y: Integer);
    procedure DoChange; dynamic;
    procedure DoDayFont(Day: Integer; Font: TFont); dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure PaintDay(Day: Integer; DayRect: TRect);
    procedure PaintMonth(MonthRect: TRect);
    procedure RefreshMonth;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property NoneButton: TNxMiniButton read FNoneButton;
    property TodayButton: TNxMiniButton read FTodayButton;
  public
    property Date: TDate read FDate write SetDate;
  published
    property Align;
    property Constraints;
		property Day: Word read FDay write SetDay;
    property DayNames: TStrings read FDayNames write SetDayNames;
    property Font;
		property Month: Word read FMonth write SetMonth;
    property MonthNames: TStrings read FMonthNames write SetMonthNames;
    property NoneCaption: WideString read FNoneCaption write SetNoneCaption;
    property SelectedDate: TDate read FSelectedDate write SetSelectedDate;
    property ShowNoneButton: Boolean read FShowNoneButton write SetShowNoneButton default False;
    property StartDay: TStartDayOfWeek read FStartDay write SetStartDay default dwAutomatic;
    property TodayCaption: WideString read FTodayCaption write SetTodayCaption;
    property Visible;
    property Year: Word read FYear write SetYear;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnContextPopup;
    property OnDayFont: TNxDayFontEvent read FOnDayFont write FOnDayFont;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  DateUtils, SysUtils, ClipBrd, Math, StrUtils, NxScrollControl,
{$WARNINGS OFF}
  FileCtrl,
{$WARNINGS ON}
  ActnList;

const
  MaxWebColorLen: array[Boolean] of Integer = (9, 7);
  WebColorPrefix: array[Boolean] of Char = ('$', '#');

  InvalidChars: array[1..3] of Integer = (VK_BACK, VK_DELETE, VK_CLEAR);

procedure ClearMouseMessages;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, WM_MOUSEFIRST, WM_MOUSELAST,
    PM_REMOVE or PM_NOYIELD) do;
end;

function ValidKey(var Key: Word): Boolean;
begin
  Result := not(Key in [VK_DELETE, VK_CLEAR, VK_BACK]);
  if not Result then Key := 0;
end;

function GetNumericText(UnCheckedText: string; AllowFloat, AllowSigns: Boolean;
  Max, Min: Double): string;
var
  i: Integer;
  CanInc: Boolean;
  HaveDecimalSeparator: Boolean;
begin
  i := 1;
  CanInc := True;
  HaveDecimalSeparator := False;

  repeat
    if UnCheckedText[i] in ['0'..'9', DecimalSeparator, '-', '+', #8] then
    begin

      { Decimal Separator }
      if UnCheckedText[i] = DecimalSeparator then
      begin
        if (not AllowFloat)
          or (HaveDecimalSeparator) then
        begin
          Delete(UnCheckedText, i, 1);
          CanInc := False;
        end;
        if not HaveDecimalSeparator then HaveDecimalSeparator := True;
      end;

      { Signs }
      if (UnCheckedText[i] in ['-', '+']) then
      begin
        if (not AllowSigns) or (i > 1) then
        begin
          Delete(UnCheckedText, i, 1);
          CanInc := False;
        end;
      end;

      if CanInc then Inc(i) else if not CanInc then CanInc := not CanInc;

    end else Delete(UnCheckedText, i, 1)
  until i = Length(UnCheckedText) + 1;

  if (UnCheckedText = '-') or (UnCheckedText = '+')
    or (UnCheckedText = '') then UnCheckedText := '0';
  Result := UnCheckedText;

  { set using max and min }
  if (Max > 0) and (StrToFloat(Result) > Max) then Result := FloatToStr(Max);
  if (StrToFloat(Result) < Min) then Result := FloatToStr(Min);
end;

function GetTextHeight(Canvas: TCanvas): Integer;
var
  DC: HDC;
  Metrics: TTextMetric;
begin
  DC := Canvas.Handle;
  GetTextMetrics(DC, Metrics);
  ReleaseDC(0, DC);
  Result := Metrics.tmHeight;
end;

{ TNxEditMargins }

constructor TNxEditMargins.Create(AOwner: TNxCustomEdit);
begin
  inherited Create;
  FOwner := AOwner;
  FLeft := 0;
  FRight := 0;
end;

procedure TNxEditMargins.SetLeft(const Value: Integer);
begin
  FLeft := Value;
  FOwner.RecreateWnd;
end;

procedure TNxEditMargins.SetRight(const Value: Integer);
begin
  FRight := Value;
  FOwner.RecreateWnd;
end;

{ TNxMargins }

constructor TNxMargins.Create(AOwner: TNxCustomEdit);
begin
  inherited Create;
  FOwner := AOwner;
  FBottom := 0;
  FLeft := 0;
  FRight := 0;
  FTop := 0;
end;

procedure TNxMargins.SetBottom(const Value: Integer);
begin
  FBottom := Value;
  FOwner.RecreateWnd;
end;

procedure TNxMargins.SetLeft(const Value: Integer);
begin
  FLeft := Value;
  FOwner.RecreateWnd;
end;

procedure TNxMargins.SetRight(const Value: Integer);
begin
  FRight := Value;
  FOwner.RecreateWnd;
end;

procedure TNxMargins.SetTop(const Value: Integer);
begin
  FTop := Value;
  FOwner.RecreateWnd;
end;

{ TNxEditInfo }

constructor TNxEditInfo.Create(AOwner: TComponent);
begin
  inherited;
  FOwner := TNxCustomEdit(AOwner);
end;

procedure TNxEditInfo.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Assigned(FOwner.FGlyph) and not FOwner.FGlyph.Empty
    and PtInRect(Rect(0, 0, FOwner.FGlyph.Width, Height), Point(X, Y)) then
  begin
    FOwner.DoGlyphClick;
  end;
end;

procedure TNxEditInfo.Paint;
var
  GlyphY, X: Integer;
  PreviewRect: TRect;
begin
  inherited;
  { paint glyph }
  X := 0;
  if Assigned(FOwner.Glyph) and not FOwner.Glyph.Empty then
  begin
    GlyphY := Round(Height / 2 - FOwner.Glyph.Height / 2);
    Canvas.Draw(X, GlyphY, FOwner.Glyph);
    Inc(X, FOwner.Glyph.Width + 2);
  end;
  { paint preview }
  if FOwner.ShowPreview then
  begin
    PreviewRect := Rect(X, 0, X + 20, ClientHeight);
    if FOwner.PreviewBorder then
    begin
      Canvas.Brush.Color := clGray;
      Canvas.FrameRect(PreviewRect);
      InflateRect(PreviewRect, -1, -1);
    end;
    FOwner.PaintPreview(Canvas, PreviewRect);
  end;
end;

{ TNxCustomEdit }

constructor TNxCustomEdit.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  Alignment := taLeftJustify;
  FEditInfo := TNxEditInfo.Create(Self);
  FEditInfo.Parent := Self;
  FEditInfo.OnMouseDown := DoEditInfoMouseDown;
  FEditing := False;
  FEditMargins := TNxEditMargins.Create(Self);
  FEditorUpdating := False;
  FGlyph := Graphics.TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FInplaceEditor := False;
  FPreviewBorder := True;
  FShowPreview := False;
  AutoSize := True;
  BorderStyle := bsSingle;
  Color := clWindow;
	Height := 20;
  ParentColor := False;
  TabStop := True;
  Width := 121;
  Screen.Cursors[crReversedArrow] := LoadCursor(HInstance, 'REVERSEDARROW');
end;

procedure TNxCustomEdit.CreateParams(var Params: TCreateParams);
const
  Styles: array [TAlignment] of DWORD = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or (ES_AUTOHSCROLL or ES_AUTOVSCROLL)
  	or WS_CLIPCHILDREN or Styles[FAlignment];
end;

procedure TNxCustomEdit.CreateWnd;
begin
  inherited;
  UpdateEditRect;
end;

destructor TNxCustomEdit.Destroy;
begin
  FreeAndNil(FCanvas);
  FreeAndNil(FGlyph);
  FreeAndNil(FEditInfo);
  FreeAndNil(FEditMargins);
  inherited;
end;

procedure TNxCustomEdit.DoCustomPreviewDraw(PreviewRect: TRect);
begin
  if Assigned(FOnCustomPreviewDraw) then FOnCustomPreviewDraw(Self, PreviewRect);
end;

procedure TNxCustomEdit.DoEditInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TNxCustomEdit.DoGlyphClick;
begin
  if Assigned(FOnGlyphClick) then FOnGlyphClick(Self);
end;

procedure TNxCustomEdit.DoGlyphChange(Sender: TObject);
begin
  UpdateGlyph;
end;

procedure TNxCustomEdit.ApplyEditing;
begin

end;

procedure TNxCustomEdit.BeginEditing;
begin

end;

procedure TNxCustomEdit.EndEditing;
begin

end;

procedure TNxCustomEdit.PressKey(Key: TChar);
var
  Message: TWMChar;
begin
  Message.CharCode := Ord(Key);
  SendMessage(Handle, WM_CHAR, TMessage(Message).WParam, TMessage(Message).LParam);
end;

procedure TNxCustomEdit.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  RecreateWnd;
end;

procedure TNxCustomEdit.SetPreviewBorder(const Value: Boolean);
begin
  FPreviewBorder := Value;
  RefreshPreview;
end;

procedure TNxCustomEdit.SetShowPreview(const Value: Boolean);
begin
  FShowPreview := Value;
  UpdateEditRect;
  Invalidate;
end;

procedure TNxCustomEdit.UpdateGlyph;
begin
  FGlyph.TransparentColor := FGlyph.Canvas.Pixels[0, FGlyph.Height - 1];
  FGlyph.Transparent := True;
  UpdateEditRect;
  RecreateWnd;
end;

procedure TNxCustomEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

procedure TNxCustomEdit.RedrawBorder;
var
  DC: HDC;
  R, R1: TRect;
begin
  if IsThemed and (BorderStyle = bsSingle) then
  begin
    R := Rect(0, 0, Width, Height);
    DC := GetWindowDC(Handle);
    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    R1 := R;
    InflateRect(R1, -2, -2);
    ExcludeClipRect(DC, r1.Left, r1.Top, r1.Right, r1.Bottom);
    ThemeRect(Handle, DC, R, teEdit, 1, 0);
    ReleaseDC(Handle, DC);
  end;
end;

procedure TNxCustomEdit.RefreshPreview;
var
  R: TRect;
begin
  R := GetPreviewRect;
  FEditInfo.Invalidate;
//  InvalidateRect(FEditInfo.Handle, @R, False);
end;

procedure TNxCustomEdit.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  inherited;
  if GetDefaultDrawing then
  begin
    Message.Result := 0;
    inherited;
  end else Message.Result := 1;
end;

procedure TNxCustomEdit.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateInfoRect;
end;

procedure TNxCustomEdit.Paint;
begin

end;

procedure TNxCustomEdit.PaintPreview(Canvas: TCanvas; var ARect: TRect);
begin
  DoCustomPreviewDraw(ARect);
end;

function TNxCustomEdit.GetAsBoolean: Boolean;
begin
  Result := StrToBool(Text);
end;

function TNxCustomEdit.GetAsDateTime: TDateTime;
begin
  Result := StrToDateTime(Text);
end;

function TNxCustomEdit.GetAsFloat: Double;
begin
  Result := StrToFloat(Text);
end;

function TNxCustomEdit.GetAsInteger: Integer;
begin
  Result := StrToInt(Text);
end;

function TNxCustomEdit.GetAsString: WideString;
begin
  Result := Text;
end;

function TNxCustomEdit.GetPreviewRect: TRect;
var
  Indent: Integer;
begin
  inherited;
  Indent := 0;
  if not FGlyph.Empty then Indent := spGlyphIndent + FGlyph.Width + 2;
  Result := ClientRect;
  Result.Left := Result.Left + Indent;
  Result.Top := Result.Top;
  Result.Bottom := Result.Bottom;
  Result.Right := Result.Left + 20;
end;

procedure TNxCustomEdit.SetAsBoolean(const Value: Boolean);
begin
  Text := BoolToStr(Value, True);
end;

procedure TNxCustomEdit.SetAsDateTime(const Value: TDateTime);
begin
  Text := DateTimeToStr(Value);
end;

procedure TNxCustomEdit.SetAsFloat(const Value: Double);
begin
  Text := FloatToStr(Value);
end;

procedure TNxCustomEdit.SetAsInteger(const Value: Integer);
begin
  Text := IntToStr(Value);
end;

procedure TNxCustomEdit.SetAsString(const Value: WideString);
begin
  Text := Value;
end;

procedure TNxCustomEdit.UpdateEditRect;
var
  LeftMargin, RightMargin: Integer;
begin
  LeftMargin := FEditMargins.Left;
  RightMargin := FEditMargins.Right;
  { 3/4/07: set margins for every control }
  UpdateEditMargins(LeftMargin, RightMargin);
  SendMessage(Handle, EM_SETMARGINS, EC_LEFTMARGIN or EC_RIGHTMARGIN,
    MAKEWPARAM(LeftMargin, RightMargin));
end;

procedure TNxCustomEdit.UpdateInfoRect;
const
  FlagVisible: array[Boolean] of DWORD = (SWP_HIDEWINDOW, SWP_SHOWWINDOW);
var
  W: Integer;
begin
  if FEditInfo = nil then Exit;
  W := 0;
  if Assigned(FGlyph) and not FGlyph.Empty then W := spGlyphIndent + FGlyph.Width + 2;
  if ShowPreview then Inc(W, 20);
  SetWindowPos(FEditInfo.Handle, HWND_TOP, 0,
    0, W, Self.ClientHeight, FlagVisible[ShowPreview or (Assigned(FGlyph) and not FGlyph.Empty)]);
end;

function TNxCustomEdit.GetDefaultDrawing: Boolean;
begin
  Result := True;
end;

function TNxCustomEdit.GetEditLeft: Integer;
begin
  if FEditInfo.Visible
    then Result := FEditInfo.Left + FEditInfo.Width
      else Result := 0;
end;

procedure TNxCustomEdit.SetInplaceEditor(const Value: Boolean);
begin
  FInplaceEditor := Value;
end;

procedure TNxCustomEdit.SetEditorUpdating(const Value: Boolean);
begin
  FEditorUpdating := Value;
end;

procedure TNxCustomEdit.SetGlyph(const Value: Graphics.TBitmap);
begin
  FGlyph.Assign(Value);
  UpdateGlyph;
end;

procedure TNxCustomEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTARROWS;
  if WantTabs then Message.Result := Message.Result or DLGC_WANTTAB
  else Message.Result := Message.Result and not DLGC_WANTTAB;
end;

procedure TNxCustomEdit.CMEnabledChanged(var Message: TMessage);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ComponentCount - 1 do
    TControl(Components[i]).Invalidate;
end;

procedure TNxCustomEdit.WMWindowPosChanged(
  var Message: TWMWindowPosChanged);
begin
  inherited;
  if not (csDestroying in ComponentState) then
  begin
    Repaint;
    FEditInfo.Repaint;
    UpdateInfoRect;
  end;
end;

procedure TNxCustomEdit.UpdateEditMargins(var LeftMargin, RightMargin: Integer);
begin
  if ShowPreview then
    Inc(LeftMargin, LeftMargin + 20 + spaImageToText);
  if not FGlyph.Empty then
    Inc(LeftMargin, FGlyph.Width + spGlyphIndent + 2);
end;

procedure TNxCustomEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if FEditInfo.Visible then
      FEditInfo.Invalidate;
end;

procedure TNxCustomEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if Assigned(FEditInfo) and FEditInfo.Visible then
    FEditInfo.Invalidate;
end;

{ TNxSmallButton }

constructor TNxSmallButton.Create(AOwner: TComponent);
begin
  inherited;
  FCaption := '';
  FDown := False;
  FHover := False;
end;

destructor TNxSmallButton.Destroy;
begin

  inherited;
end;

procedure TNxSmallButton.SetDown(const Value: Boolean);
begin
  FDown := Value;
  Invalidate;
end;

procedure TNxSmallButton.SetHover(const Value: Boolean);
begin
	if FHover <> Value then
  begin
	  FHover := Value;
	  Invalidate;
  end;
end;

procedure TNxSmallButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    if FCellEditor.Visible then FCellEditor.SetFocus; { focus editor }
    Down := True;
    if Assigned(FOnButtonDown) then FOnButtonDown(Self);
  end;
end;

procedure TNxSmallButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if FDown then
  begin
    Down := False;
    Invalidate;    
    if Assigned(FOnButtonClick) then FOnButtonClick(Self);
  end;
end;

procedure TNxSmallButton.Paint;
begin

end;

procedure TNxSmallButton.CMMouseEnter(var Message: TMessage);
begin
	inherited;
  if csDesigning in ComponentState then Exit;
  FHover := True;
  Invalidate;
end;

procedure TNxSmallButton.CMMouseLeave(var Message: TMessage);
begin
	inherited;
  FHover := False;
  Invalidate;
end;

procedure TNxSmallButton.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxSmallButton.SetCaption(const Value: WideString);
begin
  FCaption := Value;
end;

{ TNxSpinButtons }

constructor TNxSpinButtons.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPressedButtons := [];
  FHoverButtons := [];
  FRepeatTimer := TTimer.Create(Self);
  FRepeatTimer.OnTimer := DoRepeatTimer;
  FRepeatTimer.Interval := sizFastInterval;
  FRepeatTimer.Enabled := False;
  FDelayTimer := TTimer.Create(Self);
  FDelayTimer.OnTimer := DoDelayTimer;
  FDelayTimer.Interval := sizSlowInterval;
  FDelayTimer.Enabled := False;
end;

destructor TNxSpinButtons.Destroy;
begin
  FRepeatTimer.Free;
  FDelayTimer.Free;
  inherited;
end;

procedure TNxSpinButtons.DoDelayTimer(Sender: TObject);
begin
  FRepeatTimer.Enabled := True;
end;

procedure TNxSpinButtons.DoRepeatTimer(Sender: TObject);
begin
  if Assigned(FOnSpin) then FOnSpin(Self, FPressedButtons); { spin value }
end;

procedure TNxSpinButtons.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    if Y < Height div 2 then FPressedButtons := [sbUp]
      else FPressedButtons := [sbDown];
    FDelayTimer.Enabled := True;
    if Assigned(FOnSpin) then FOnSpin(Self, FPressedButtons);
    Invalidate;
  end;
end;

procedure TNxSpinButtons.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Y < Height div 2	then FHoverButtons := [sbUp] else FHoverButtons := [sbDown];
  Invalidate;
end;

procedure TNxSpinButtons.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FPressedButtons := [];
  FRepeatTimer.Enabled := False;
  FDelayTimer.Enabled := False;
  Invalidate;
end;

procedure TNxSpinButtons.Paint;
var
  DrawFlags, UpState, DownState: Integer;
  UpButtonRect, DownButtonRect: TRect;
begin
  inherited;
  UpButtonRect := Rect(0, -1, ClientWidth, (ClientHeight div 2));
  DownButtonRect := Rect(0, (ClientHeight div 2), ClientWidth, ClientHeight);
	if IsThemed then
 	begin
    if TControl(Owner).Enabled then
    begin
      if sbUp in FPressedButtons then UpState := 3
        else if sbUp in FHoverButtons then UpState := 2
          else UpState := 1;
      if sbDown in FPressedButtons then DownState := 3
        else if sbDown in FHoverButtons then DownState := 2
          else DownState := 1;
    end else
    begin
      UpState := 4;
      DownState := 4;
    end;
    ThemeRect(Handle, Canvas.Handle, UpButtonRect, teSpin, tcSpinUp, UpState);
    ThemeRect(Handle, Canvas.Handle, DownButtonRect, teSpin, tcSpinDown, DownState);
  end else
  begin { theme off }
    DrawFlags := DFCS_SCROLLUP or DFCS_ADJUSTRECT;
    if sbUp in FPressedButtons then DrawFlags := DrawFlags or DFCS_PUSHED;
    if not TControl(Owner).Enabled then DrawFlags := DrawFlags or DFCS_INACTIVE;
    DrawFrameControl(Canvas.Handle, UpButtonRect, DFC_SCROLL, DrawFlags);
    DrawFlags := DFCS_SCROLLDOWN or DFCS_ADJUSTRECT;
    if not TControl(Owner).Enabled then DrawFlags := DrawFlags or DFCS_INACTIVE;
    if sbDown in FPressedButtons then DrawFlags := DrawFlags or DFCS_PUSHED;
    DrawFrameControl(Canvas.Handle, DownButtonRect, DFC_SCROLL, DrawFlags);
  end;
end;

procedure TNxSpinButtons.CMMouseLeave(var Message: TMessage);
begin
  FHoverButtons := [];
  Invalidate;
end;

procedure TNxSpinButtons.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxSpinButtons.SetHoverButtons(const Value: TSpinButtonSet);
begin
  if csDesigning in ComponentState then Exit;
  FHoverButtons := Value;
  Invalidate;
end;

procedure TNxSpinButtons.SetPressedButtons(const Value: TSpinButtonSet);
begin
  FPressedButtons := Value;
	if FPressedButtons <> [] then
  begin
    FDelayTimer.Enabled := True;
    if Assigned(FOnSpin) then FOnSpin(Self, FPressedButtons);
  end else
  begin
    FDelayTimer.Enabled := False;
    FRepeatTimer.Enabled := False;
  end;
  Invalidate;
end;

{ TNxEdit }

constructor TNxEdit.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TNxEdit.SetAsString(const Value: WideString);
begin
  Text := Value;
end;

procedure TNxEdit.BeginEditing;
begin
  inherited;
  SelStart := Length(Text);
end;

procedure TNxEdit.WMSize(var Message: TWMSize);
begin
	inherited;
  UpdateEditRect;
end;

procedure TNxEdit.DoTextChange;
begin
  
end;

procedure TNxEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if X <= GetEditLeft + 2 then Cursor := crReversedArrow else Cursor := crDefault;
end;

procedure TNxEdit.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if X <= GetEditLeft + 2 then SelectAll;
end;

procedure TNxEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateEditRect;
end;

procedure TNxEdit.CMTextChanged(var Message: TMessage);
begin
  inherited;
  DoTextChange;
end;

procedure TNxEdit.WMNCPaint(var Message: TMessage);
begin
  if IsThemed = False then inherited else RedrawBorder;
end;

procedure TNxEdit.WMPaint(var Message: TWMPaint);
var
  FillBrush: HBRUSH;
  DC: HDC;
  R: TRect;
  I: Integer;
begin
  if BorderWidth > 0 then
  begin
    DC := GetWindowDC(Handle);
    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    FillBrush := CreateSolidBrush(ColorToRGB(Color));
    if BorderStyle = bsSingle then InflateRect(R, -1, -1)
      else InflateRect(R, 1, 1);
    for I := 0 to BorderWidth - 1 do
    begin
      InflateRect(R, -1, -1);
      FrameRect(DC, R, FillBrush);
    end;
    DeleteObject(FillBrush);
    ReleaseDC(Handle, DC);
  end;
  inherited;
  if not GetDefaultDrawing then Paint;
end;

{ TNxCanvasCellEditor }

constructor TNxCanvasCellEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlignment := taLeftJustify;
  FBorderStyle := bsSingle;
  FMargin := 0;
  FVerticalAlignment := taVerticalCenter;
end;

procedure TNxCanvasCellEditor.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := Style or (ES_AUTOHSCROLL or ES_AUTOVSCROLL);
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

destructor TNxCanvasCellEditor.Destroy;
begin

  inherited Destroy;
end;

procedure TNxCanvasCellEditor.RedrawBorder;
var
  DC: HDC;
  R, R1: TRect;
begin
  if IsThemed and (BorderStyle = bsSingle) then
  begin
    R := Rect(0, 0, Width, Height);
    DC := GetWindowDC(Handle);
    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    R1 := R;
    InflateRect(R1, -2, -2);
    ExcludeClipRect(DC, r1.Left, r1.Top, r1.Right, r1.Bottom);
    ThemeRect(Handle, DC, R, teEdit, 1, 0);
    ReleaseDC(Handle, DC);
  end;
end;

procedure TNxCanvasCellEditor.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TNxCanvasCellEditor.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
  RecreateWnd;
end;

procedure TNxCanvasCellEditor.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Invalidate;
end;

procedure TNxCanvasCellEditor.SetVerticalAlignment(
  const Value: TVerticalAlignment);
begin
  FVerticalAlignment := Value;
  Invalidate;
end;

procedure TNxCanvasCellEditor.WMNCPaint(var Message: TMessage);
begin
  if IsThemed = False then inherited else RedrawBorder;
end;

{ TNxCheckBox }

constructor TNxCheckBox.Create(AOwner: TComponent);
begin
  inherited;
  FChecked := False;
  FDown := False;
  FGrayed := False;
  FHover := False;
  FIndent := spChkBoxTextIndent;
  Color := clWindow;
  ParentColor := False;
  Width := 75;
  Height := 21;
end;

destructor TNxCheckBox.Destroy;
begin

  inherited;
end;

function TNxCheckBox.GetCheckBoxRect: TRect;
var
	r: TRect;
  p: TPoint;
  w: Integer;
begin
  r := ClientRect;
	InflateRect(r, 1, 1);
  if IsThemed then w := 13 else w := 11;
  p := TCalcProvider.PosInRect(w, w, 2, r, Alignment, VerticalAlignment);
  Result := Rect(p.X, p.Y, p.X + w, p.Y + w);
end;

function TNxCheckBox.GetAsBoolean: Boolean;
begin
  Result := FChecked;
end;

function TNxCheckBox.GetAsString: WideString;
begin
  Result := BoolToStr(FChecked, True);
end;

procedure TNxCheckBox.BeginEditing;
begin
  inherited;
  Refresh;
end;

procedure TNxCheckBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then
  begin
	  FDown := True;
	  Invalidate;
  end;
end;

procedure TNxCheckBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then
  begin
	  FDown := False;
	  Checked := not Checked;
  end;
end;

procedure TNxCheckBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
	r: TRect;
begin
  inherited;
  SetFocus;
  if (Button = mbLeft)
    and (PtInRect(GetCheckBoxRect, Point(X, Y)) or (coExpandActiveRect in FOptions)) then
  begin
	  FDown := True;
	  r := GetCheckBoxRect;
	  InvalidateRect(Handle, @r, False);
  end;
end;

procedure TNxCheckBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if PtInRect(GetCheckBoxRect, Point(X, Y)) or
    (coExpandActiveRect in FOptions) then Hover := True else Hover := False;
end;

procedure TNxCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
	r: TRect;
begin
  inherited;
  if (Button = mbLeft)
    and (PtInRect(GetCheckBoxRect, Point(X, Y)) or (coExpandActiveRect in FOptions)) then
  begin
    Checked := not Checked;
  end;
  if FDown then
  begin
    FDown := False;
	  r := GetCheckBoxRect;
    InvalidateRect(Handle, @r, False);
  end;
end;

procedure TNxCheckBox.Paint;
var
	R, TextRect: TRect;
begin
  Canvas.Brush.Color := Self.Color;
  Canvas.FillRect(ClientRect);
  R := ClientRect;
  InflateRect(R, 1, 1);
  TextRect := ClientRect;
  case Alignment of
    taLeftJustify, taCenter: TextRect.Left := DrawCheckBox.Right + FIndent;
    taRightJustify: TextRect.Left := DrawCheckBox.Left - GetTextWidth(Canvas, Caption) - FIndent;
  end;
  Canvas.Font.Assign(Font);
  DrawTextRect(Canvas, TextRect, taLeftJustify, Caption);
end;

procedure TNxCheckBox.SetAsBoolean(const Value: Boolean);
begin
  inherited;
  Checked := Value;
end;

procedure TNxCheckBox.SetAsString(const Value: WideString);
begin
  inherited;
  Checked := LowerCase(Value) = 'true';
end;

procedure TNxCheckBox.SetChecked(const Value: Boolean);
var
	r: TRect;
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    r := GetCheckBoxRect;
    InvalidateRect(Handle, @r, False);
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TNxCheckBox.SetGrayed(const Value: Boolean);
begin
  FGrayed := Value;
end;

procedure TNxCheckBox.SetHover(const Value: Boolean);
var
	r: TRect;
begin
 	if FHover <> Value then
  begin
	  FHover := Value;
    r := GetCheckBoxRect;
    InvalidateRect(Handle, @r, False);
  end;
end;

procedure TNxCheckBox.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxCheckBox.CMMouseLeave(var Message: TMessage);
begin
  Hover := False;
end;

procedure TNxCheckBox.Clear;
begin
  Checked := False;
end;

function TNxCheckBox.GetDefaultDrawing: Boolean;
begin
  Result := False;
end;

function TNxCheckBox.DrawCheckBox: TRect;
var
  P: TPoint;
  Index: Integer;
begin
	if IsThemed then
  begin
	  P := TCalcProvider.PosInRect(13, 13, 2, ClientRect, Alignment, VerticalAlignment);
	  Result := Rect(P.X, P.Y, P.X + 13, P.Y + 13);
    Index := 1;
    if Hover then
		begin
    	case Checked of
        True: if FDown then Index := 7 else Index := 6;
        False: if FDown then Index := 3 else Index := 2;
      end;
		end else if Checked then Index := 5;
    if not Enabled then Inc(Index, 3);
    ThemeRect(Handle, Canvas.Handle, Result, teButton, tcCheckBox, Index);
  end else
  begin
	  P := TCalcProvider.PosInRect(11, 11, 2, ClientRect, Alignment, VerticalAlignment);
	  Result := Rect(P.X, P.Y, P.X + 11, P.Y + 11);
    with Canvas, ClientRect, P do
    begin
      if FDown then Brush.Color := clBtnFace else Brush.Color := clWindow;
      Pen.Color := clBtnShadow;
      Rectangle(Result);
      Pen.Color := clWindowText;
      if Checked then
      begin
        Polyline([Point(X + 2, Y + 4), Point(X + 4, Y + 6), Point(X + 9, Y + 1)]);
        Polyline([Point(X + 2, Y + 5), Point(X + 4, Y + 7), Point(X + 9, Y + 2)]);
        Polyline([Point(X + 2, Y + 6), Point(X + 4, Y + 8), Point(X + 9, Y + 3)]);
      end;
    end;
  end;
end;

procedure TNxCheckBox.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TNxCheckBox.SetOptions(const Value: TCheckBoxOptions);
begin
  FOptions := Value;
  Invalidate;
end;

procedure TNxCheckBox.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Invalidate;
end;

{ TNxCustomButtonEdit }

constructor TNxCustomButtonEdit.Create(AOwner: TComponent);
begin
	inherited;
  FButton := GetButtonClass.Create(Self);
  FButton.CellEditor := Self;
  FOptions := [];
  FShowButton := True;
  with FButton do
  begin
    Parent := Self;
    Visible := False;
    OnButtonDown := DoButtonDown;
    OnButtonClick := DoButtonClick;
  end;
  CreatePopupControl;
end;

procedure TNxCustomButtonEdit.CreatePopupControl;
begin

end;

destructor TNxCustomButtonEdit.Destroy;
begin
  FreeAndNil(FPopupControl);
  inherited;
end;

procedure TNxCustomButtonEdit.CreateWnd;
begin
  inherited;
  UpdateEditRect;
end;

procedure TNxCustomButtonEdit.ApplyInput(Value: string);
begin
  Text := Value;
end;

procedure TNxCustomButtonEdit.BeforeDrop;
begin

end;

procedure TNxCustomButtonEdit.BeginEditing;
begin
  inherited;
  FButton.Repaint;
end;

procedure TNxCustomButtonEdit.DoDropDownDeactivate(Sender: TObject);
begin
  FButton.Down := False;
end;

procedure TNxCustomButtonEdit.DoDropDownInput(Sender: TObject; Value: string);
begin
{ 02/19/08: ApplyInput (set Editor.Text property) is called first
            before OnCloseUp event is called }
  ApplyInput(Value);
  { Close popup window }
  FPopupControl.ClosePopup;
  { Refresh button }
  FButton.FHover := False;
  FButton.Down := False;
end;


function TNxCustomButtonEdit.GetPopupControlClass: TNxPopupControlClass;
begin
  Result := TNxPopupControl;
end;

function TNxCustomButtonEdit.GetButtonClass: TSmallButtonClass;
begin
  Result := TNxExecuteButton;
end;

procedure TNxCustomButtonEdit.DoButtonClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then FOnButtonClick(Self);
end;

procedure TNxCustomButtonEdit.DoButtonDown(Sender: TObject);
begin

end;

procedure TNxCustomButtonEdit.UpdateButton;
const
  ButtonVisible: array[Boolean] of Integer = (SWP_HIDEWINDOW, SWP_SHOWWINDOW);
begin
  Repaint;
  SetWindowPos(FButton.Handle, HWND_TOP, ClientWidth - FButton.Width,
    0, FButton.Width, Self.ClientHeight, ButtonVisible[ShowButton] or SWP_NOREDRAW);
  FButton.Repaint;
end;

procedure TNxCustomButtonEdit.CMMouseEnter(var Message: TMessage);
begin
  if not(csDesigning in ComponentState) then FButton.Hover := True;
end;

procedure TNxCustomButtonEdit.CMMouseLeave(var Message: TMessage);
begin
  FButton.Hover := False;
end;

procedure TNxCustomButtonEdit.WMSize(var Message: TWMSize);
begin
	inherited;
  UpdateButton;
end;

procedure TNxCustomButtonEdit.WMWindowPosChanged(
  var Message: TWMWindowPosChanged);
begin
	inherited;
  FButton.Repaint;
  Repaint;
end;

procedure TNxCustomButtonEdit.UpdateEditMargins(var LeftMargin,
  RightMargin: Integer);
begin
  inherited;
  if FShowButton then RightMargin := FButton.Width else RightMargin := 0;
end;

procedure TNxCustomButtonEdit.KeyPress(var Key: Char);
begin
  if epDisableTyping in FOptions then
  begin
    Key := #0;
    Exit;
  end else inherited;
end;

procedure TNxCustomButtonEdit.CMPaste(var Msg: TMessage);
begin
  if not (epDisablePaste in FOptions) then inherited;
end;

procedure TNxCustomButtonEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (epDisableTyping in FOptions) and not ValidKey(Key) then Exit;
  inherited;
end;

procedure TNxCustomButtonEdit.SetShowButton(const Value: Boolean);
begin
  FShowButton := Value;
  FButton.Visible := FShowButton;
  UpdateButton;
  UpdateEditRect;
end;

{ TNxComboBox }

procedure TNxComboBox.ApplyInput(Value: string);
begin

end;

constructor TNxComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FDisplayMode := dmDefault;
  FHighlightTextColor := clHighlightText;
  FItemHeight := sizListItemHeight;
  FItemIndex := -1;
  FItems := TNxStringList.Create;
  FListWidth := 0;
  FDropDownColor := clWindow;
  FDropDownCount := 8;
  FSelectionColor := clHighlight;
end;

destructor TNxComboBox.Destroy;
begin
  FItems.Clear;
  FItems.Free;
  inherited;
end;

procedure TNxComboBox.BeforeDrop(var APoint: TPoint);
begin
  with FPopupControl as TNxPopupList do
  begin            
    DropDownColor := FDropDownColor;
    DropDownCount := FDropDownCount;
    HighlightTextColor := FHighlightTextColor;
    DisplayMode := FDisplayMode;
    Items := FItems;
    Images := FImages;
    ItemHeight := Self.ItemHeight;
    ItemIndex := Self.ItemIndex;
    ShowImages := Images <> nil;
    SelectionColor := Self.SelectionColor;
    if FListWidth > 0 then Width := FListWidth else Width := Self.Width;
    if Width < Self.Width then Width := Self.Width;
    if Items.Count <= Self.DropDownCount then ClientHeight := Items.Count * Self.ItemHeight
			else ClientHeight := Self.DropDownCount * Self.ItemHeight;
    ClientHeight := ClientHeight + 4;
  end;
end;

procedure TNxComboBox.DoTextChange;
begin
  inherited;
  if (FDisplayMode = dmDefault) and (FItems.IndexOf(Text) = -1)
    then FItemIndex := -1;
end;

function TNxComboBox.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  if InplaceEditor then Exit;
  if FDroppedDown then
  begin
    with (FPopupControl as TNxPopupList).VertScrollBar do
    begin
      Position := Position + 1;
    end;
  end else if ItemIndex < Pred(Items.Count) then ItemIndex := ItemIndex + 1;
end;

function TNxComboBox.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
  if InplaceEditor then Exit;
  if FDroppedDown then
  begin
    with (FPopupControl as TNxPopupList).VertScrollBar do
    begin
      Position := Position - 1;
    end;
  end else if ItemIndex > 0 then ItemIndex := ItemIndex - 1;
end;

function TNxComboBox.GetPopupControlClass: TNxPopupControlClass;
begin
  Result := TNxPopupList;
end;

function TNxComboBox.GetValueFromIndex(const Index: Integer): string;
begin
  if Index >= 0 then
    if (DisplayMode = dmDefault) then
        Result := Copy(Items[Index], Length(Items.Names[Index]) + 1, MaxInt)
      else
        Result := Copy(Items[Index], Length(Items.Names[Index]) + 2, MaxInt)
    else
      Result := '';
end;

procedure TNxComboBox.SetDropDownCount(const Value: Integer);
begin
  FDropDownCount := Value;
end;

procedure TNxComboBox.SetItemIndex(const Value: Integer);
begin
  { Bn: Causes a problem when editing cell }
//  if FItemIndex <> Value then
  begin
    FItemIndex := Value;
    if not (csLoading in ComponentState) then SetTextFromItemIndex;
    TNxPopupList(FPopupControl).ItemIndex := FItemIndex;
    if ShowPreview then RefreshPreview;
  end;
end;

procedure TNxComboBox.SetItems(const Value: TNxStrings);
begin
  FItems.Assign(Value);
end;

procedure TNxComboBox.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TNxComboBox.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
end;

procedure TNxComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if FDroppedDown then
  begin
    with FPopupControl as TNxPopupList do
      case Key of
        VK_UP: if (HoverIndex > 0) and not(ssAlt in Shift) then Self.ItemIndex := HoverIndex - 1;
        VK_DOWN: if (HoverIndex < Pred(FItems.Count)) and not(ssAlt in Shift) then Self.ItemIndex := HoverIndex + 1;
      end;
  end else
  begin
    if InplaceEditor then Exit;
    case Key of
      VK_UP: if (ItemIndex > 0) and not(ssAlt in Shift) then ItemIndex := ItemIndex - 1;
      VK_DOWN: if (ItemIndex < Pred(FItems.Count)) and not(ssAlt in Shift) then ItemIndex := ItemIndex + 1;
    end;
  end;
end;

procedure TNxComboBox.KeyPress(var Key: Char);
var
  AIndex: Integer;
begin
  inherited;
  if Style = dsDropDownList then
  begin
    AIndex := LocateKey(TChar(Key));
    if InRange(AIndex, 0, Items.Count - 1) then begin
      ItemIndex := AIndex;
      if InplaceEditor then
        DoCloseUp;
    end;
  end;
end;

procedure TNxComboBox.PaintPreview(Canvas: TCanvas; var ARect: TRect);
var
	ImgTop, ImgLeft: Integer;
begin
  with Canvas do
  begin
    Brush.Color := GetFillColor;
    FillRect(ARect);
  end;
  if Assigned(FImages) then
  begin
    ImgTop := ClientHeight div 2 - FImages.Height div 2;
    ImgLeft := ARect.Left + 1;
    FImages.Draw(Canvas, ImgLeft, ImgTop, ItemIndex);
  end;
end;

procedure TNxComboBox.SetStyle(const Value: TDropDownStyle);
begin
  inherited;
  if Value in [dsDropDownList] then SetItemIndex(ItemIndex);
end;

procedure TNxComboBox.SetSelectionColor(const Value: TColor);
begin
  FSelectionColor := Value;
end;

procedure TNxComboBox.SetHighlightTextColor(const Value: TColor);
begin
  FHighlightTextColor := Value;
end;

procedure TNxComboBox.SetDropDownColor(const Value: TColor);
begin
  FDropDownColor := Value;
end;

function TNxComboBox.GetItemName: string;
begin
  if (Items.Count > 0) and InRange(ItemIndex, 0, Pred(Items.Count)) then
    Result := Items.Names[ItemIndex] else Result := '';
end;

function TNxComboBox.GetItemValue: string;
begin
  if (Items.Count > 0) and InRange(ItemIndex, 0, Pred(Items.Count)) then
    Result := GetValueFromIndex(ItemIndex) else Result := '';
end;

procedure TNxComboBox.DoDropDownInput(Sender: TObject; Value: string);
begin
  { note: first set ItemIndex then trigger
          events (OnChange, OnCloseUp, OnSelect) }
  ItemIndex := TNxPopupList(FPopupControl).ItemIndex;
  inherited;
end;

procedure TNxComboBox.SetTextFromItemIndex;
begin
  if IndexInRange(FItemIndex) then
  begin
    case FDisplayMode of
      dmDefault: Text := Items[FItemIndex];
      dmValueList: Text := GetValueFromIndex(FItemIndex);
      dmNameList: Text := Items.Names[FItemIndex];
      dmIndentList: Text := GetValueFromIndex(FItemIndex);
    end;
  end else Text := '';
end;

procedure TNxComboBox.Loaded;
begin
  inherited;
  SetTextFromItemIndex;
end;

function TNxComboBox.IndexInRange(const Index: Integer): Boolean;
begin
  Result := (FItems.Count > 0) and InRange(Index, 0, Pred(FItems.Count));
end;                 

function TNxComboBox.SearchFor(const S: TString): Integer;
var
  i, j, c, c1: Integer;
  ch1, ch2: TChar;
begin
  c := 0;
  Result := -1;
  for i := 0 to Pred(FItems.Count) do
  begin
    c1 := 0;
    for j := 1 to Length(S) do
    begin
      ch1 := s[j];
      ch2 := FItems[i][j];
      if ch1 = ch2 then Inc(c1) else
        if (c1 < c) and (c1 > 0) then
        begin
          Result := i;
          Exit;
        end else Break;
    end;
  end;
end;

function TNxComboBox.LocateKey(Key: TChar): Integer;
var
  i: Integer;
  function FirstChar(S: TString): TChar;
  begin
    if Length(S) > 0 then Result := S[1]
      else Result := #0;
  end;
begin
  Result := -1;
  i := 0;
  if InRange(ItemIndex, 0, Pred(Items.Count)) then
    if WideCompareText(FirstChar(Items[ItemIndex]), Key) = 0 then
      i := ItemIndex + 1;
  while i <= Pred(Items.Count) do
  begin
    if WideCompareText(FirstChar(Items[i]), Key) = 0 then
    begin
      Result := i;
      Exit;
    end;
    Inc(i);
  end;
end;

procedure TNxComboBox.SetListWidth(const Value: Integer);
begin
  FListWidth := Value;
end;

{ TNxDatePicker }

constructor TNxDatePicker.Create(AOwner: TComponent);
begin
  inherited;
  AsDateTime := Today;
  FDayNames := TStringList.Create;
  FMonthNames := TStringList.Create;
  FNoneCaption := strNone;
  FShowNoneButton := True;
  FStartDay := dwSunday;
  FTodayCaption := strToday;
end;

destructor TNxDatePicker.Destroy;
begin
  FDayNames.Free;
  FMonthNames.Free;
  inherited;
end;

procedure TNxDatePicker.BeforeDrop(var APoint: TPoint);
var
	y, m, d: Word;
begin
  inherited;
  with FPopupControl as TNxDatePopup do
  begin
    NoneButton.Text := FNoneCaption;
    if AsDateTime = 0 then SelectedDate := Today { don't show 1899 year }
      else SelectedDate := GetAsDateTime;
    DecodeDate(SelectedDate, y, m, d);
    DayNames := Self.FDayNames;
    Year := y;
    Month := m;
    Day := d;
    StartDay := FStartDay;
    TodayButton.Text := FTodayCaption;
  	Height := 163;
  	Width := 151;
    MonthNames := Self.MonthNames;
    NoneButton.Visible := ShowNoneButton;
    if NoneButton.Visible then TodayButton.Left := 20
      else TodayButton.Left := ClientWidth div 2 - TodayButton.Width div 2;
  end;
end;

function TNxDatePicker.GetAsDateTime: TDateTime;
begin
	if (Text = '') or (Text = '0') then Result := Today
    else if not TryStrToDateTime(Text, Result) then Result := 0;
end;

function TNxDatePicker.GetPopupControlClass: TNxPopupControlClass;
begin
  Result := TNxDatePopup;
end;

procedure TNxDatePicker.SetAsDateTime(const Value: TDateTime);
begin
  Text := DateTimeToStr(Value);
end;

procedure TNxDatePicker.SetDayNames(const Value: TStrings);
begin
  FDayNames.Assign(Value);
end;

procedure TNxDatePicker.SetEmptyText(const Value: string);
begin
  FEmptyText := Value;
  SetValueToText(Date);
end;

procedure TNxDatePicker.SetMonthNames(const Value: TStrings);
begin
  FMonthNames.Assign(Value);
end;

procedure TNxDatePicker.SetShowNoneButton(const Value: Boolean);
begin
  FShowNoneButton := Value;
end;

procedure TNxDatePicker.SetValueToText(SendValue: TDateTime);
begin

end;

procedure TNxDatePicker.KeyDown(var Key: Word; Shift: TShiftState);
var
  y, m, d: Word;
begin
  inherited;
  if DroppedDown then
  begin
    case Key of
      VK_LEFT: if (ssShift in Shift) then Date := IncMonth(Date, -1)
                else Date := IncDay(Date, -1);
      VK_RIGHT: if (ssShift in Shift) then Date := IncMonth(Date, 1)
                  else Date := IncDay(Date, 1);
      VK_UP: Date := IncWeek(Date, -1);
      VK_DOWN: Date := IncWeek(Date, 1);
      VK_PRIOR: Date := IncMonth(Date, -1);
      VK_NEXT: Date := IncMonth(Date, 1);
      else if Style = dsDropDownList then Key := 0;
    end;
    if Key <> 0 then
    begin
      with FPopupControl as TNxDatePopup do
      begin
        DecodeDate(GetAsDateTime, y, m, d);
        Year := y;
        Month := m;
        Day := d;
        SelectedDate := GetAsDateTime;
        Invalidate;
      end;
    end;
  end;
end;

procedure TNxDatePicker.SetTodayCaption(const Value: WideString);
begin
  FTodayCaption := Value;
end;

procedure TNxDatePicker.SetNoneCaption(const Value: WideString);
begin
  FNoneCaption := Value;
end;

procedure TNxDatePicker.SetStartDay(const Value: TStartDayOfWeek);
begin
  FStartDay := Value;
end;

procedure TNxDatePicker.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if Text <> '' then
  begin
    AsDateTime := StrToDateDef(Text, Today);
  end;
end;

{ TNxCustomNumberEdit }

procedure TNxCustomNumberEdit.AdjustToRange(var Value: Double);
begin
  if CheckRange then
  begin
    if Value > FMax then Value := FMax;
    if Value < FMin then Value := FMin;
  end;
end;

constructor TNxCustomNumberEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  FMax := 0;
  FMin := 0;
  FNullText := '';
  FOptions := [eoAllowFloat, eoAllowSigns];
  FPrecision := 2;
  FTextAfter := '';
  FValue := 0;
end;

procedure TNxCustomNumberEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetValueToText(Value);
end;

function TNxCustomNumberEdit.GetValidText(UnCheckedText: string; AllowFloat, AllowSigns: Boolean) : string;
var
  i: Integer;
  CanInc: Boolean;
  HaveDecimalSeparator: Boolean;
  BoundValue: Double;
begin
  i := 1;
  CanInc := True;
  HaveDecimalSeparator := False;
  repeat
    if UnCheckedText[i] in ['0'..'9', DecimalSeparator, '-', '+', #8] then
    begin

      { Decimal Separator }
      if UnCheckedText[i] = DecimalSeparator then
      begin
        if (not AllowFloat)
          or (HaveDecimalSeparator) then
        begin
          Delete(UnCheckedText, i, 1);
          CanInc := False;
        end;
        if not HaveDecimalSeparator then HaveDecimalSeparator := True;
      end;

      { Signs }
      if (UnCheckedText[i] in ['-', '+']) then
      begin
        if (not AllowSigns) or (i > 1) then
        begin
          Delete(UnCheckedText, i, 1);
          CanInc := False;
        end;

      end;

      if CanInc then Inc(i) else if not CanInc then CanInc := not CanInc;

    end else Delete(UnCheckedText, i, 1)
  until i = Length(UnCheckedText) + 1;
  if (UnCheckedText = '-') or (UnCheckedText = '+')
    then UnCheckedText := '0';

  Result := UnCheckedText;
  { set using max and min }
  BoundValue := StrToFloat(Result);
  AdjustToRange(BoundValue);
  Result := FloatToStr(BoundValue);
end;

function TNxCustomNumberEdit.GetValue: Double;
var
  ValidText: string;
begin
  if (Text = NullText) then
  begin
    Value := 0;
    Exit;
  end;
  if Text = '' then Result := FMin else
  begin
    ValidText := GetValidText(Text, eoAllowFloat in FOptions, eoAllowSigns in FOptions);
    if ValidText = '' then ValidText := FloatToStr(Min);
    if TryStrToFloat(ValidText, Result) then
    begin
      AdjustToRange(Result);
      FValue := Result;
    end else Result := FValue;
  end;
end;

procedure TNxCustomNumberEdit.SetOptions(const Value: TNxNumberEditOptions);
begin
  FOptions := Value;
end;

procedure TNxCustomNumberEdit.SetPrecision(Value: Integer);
begin
  FPrecision := Value;
  SetValueToText(Self.Value);
end;

function TNxCustomNumberEdit.CheckRange: Boolean;
begin
  Result := (FMax <> 0) or (FMin <> 0);
end;

procedure TNxCustomNumberEdit.SetNullText(const Value: TCaption);
begin
  FNullText := Value;
  SetValueToText(0);
end;

procedure TNxCustomNumberEdit.SetValue(Value: Double);
begin
  SetValueToText(Value);
end;

procedure TNxCustomNumberEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (eoDisableTyping in FOptions) and not ValidKey(Key) then Exit;
  inherited;
end;

procedure TNxCustomNumberEdit.KeyPress(var Key: Char);
begin
  if eoDisableTyping in FOptions then
  begin
    Key := #0;
    Exit;
  end;

  if (eoAllowAll in FOptions) or (Key in [#3, #9, #22, #24]) then
	begin
  	inherited KeyPress(Key);
	  Exit; { Clipboard keys and tab key - #9 }
	end;

  if not (Key in ['0'..'9', DecimalSeparator, '-', '+', #8, #13]) then Key := #0;

  { Decimal Separator }
  if Key = DecimalSeparator then
    if eoAllowFloat in FOptions then
    begin
      if (Pos(Key, Text) > 0) and (Pos(Key, SelText) = 0) then Key := #0;
    end else Key := #0;

  { Signs }
  if (Key = '-') or (Key = '+') then
    if eoAllowSigns in FOptions then
    begin
      if ((SelStart > 0) or (Pos('-', Text) > 0) or (Pos('+', Text) > 0))
        and ((Pos('-', SelText) = 0) and (Pos('+', SelText) = 0)) then Key := #0;
    end else Key := #0;

  if Key <> #0 then inherited KeyPress(Key);
end;

procedure TNxCustomNumberEdit.CMPaste(var Msg: TMessage);
var
  ClientText, NewText, ClipboardText: string;
  OldSelStart: Integer;
  AllowFloat, AllowSigns: Boolean;
begin
  if eoDisablePaste in FOptions then Exit;

  OldSelStart := SelStart;
  if Clipboard.HasFormat(CF_TEXT)
    then ClipboardText := Clipboard.AsText
      else ClipboardText := '';

  ClientText := Text;
  Delete(ClientText, SelStart + 1, SelLength);

  { Set flags and get valid text }
  AllowFloat := (eoAllowFloat in FOptions)
    and (Pos(DecimalSeparator, ClientText) = 0);
  AllowSigns := (eoAllowSigns in FOptions)
    and (SelStart = 0);
  NewText := GetValidText(ClipboardText, AllowFloat, AllowSigns);

  Insert(NewText, ClientText, SelStart + 1);

  Text := ClientText;
  SelStart := OldSelStart;
end;

procedure TNxCustomNumberEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if not (eoAllowAll in FOptions) then SetValueToText(Value);
end;

procedure TNxCustomNumberEdit.ApplyEditing;
begin
  if not (eoAllowAll in FOptions) then SetValueToText(Value);
end;

procedure TNxCustomNumberEdit.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxCustomNumberEdit then
  begin
    Max := TNxCustomNumberEdit(Source).Max;
    Min := TNxCustomNumberEdit(Source).Min;
    NullText := TNxCustomNumberEdit(Source).NullText;
    Options := TNxCustomNumberEdit(Source).Options;
    Precision := TNxCustomNumberEdit(Source).Precision;
    Value := TNxCustomNumberEdit(Source).Value;
  end;
end;

function TNxCustomNumberEdit.GetFormatedValue(AValue: Double): WideString;
begin
  if (AValue = 0) and (FNullText <> '')
    then Result := FNullText else
  begin
    if eoAllowFloat in FOptions then
    begin
      if Precision > 0 then
        Result := FloatToStrF(AValue, ffFixed, 18, Precision) + FTextAfter
          else Result := FloatToStr(AValue) + FTextAfter;
    end else Result := FloatToStrF(AValue, ffFixed, 18, 0) + FTextAfter;
  end;
end;

procedure TNxCustomNumberEdit.SetValueToText(SendValue: Double);
begin
  if not EditorUpdating then
    Text := GetFormatedValue(SendValue);
end;

procedure TNxCustomNumberEdit.SetTextAfter(const Value: TCaption);
begin
  FTextAfter := Value;
  if not (eoAllowAll in FOptions)
    then SetValueToText(Self.Value);
end;

procedure TNxCustomNumberEdit.BeginEditing;
begin
	inherited;

end;

function TNxCustomNumberEdit.GetAsFloat: Double;
begin
  Result := Value;
end;

procedure TNxCustomNumberEdit.SetAsFloat(const Value: Double);
begin
  inherited;
  Self.Value := Value;
end;

function TNxCustomNumberEdit.GetAsInteger: Integer;
begin
  Result := Trunc(Value);
end;

procedure TNxCustomNumberEdit.SetAsInteger(const Value: Integer);
begin
  inherited;
  Self.Value := Value;
end;

{ TNxNumberEdit }

constructor TNxNumberEdit.Create(AOwner: TComponent);
begin
  inherited;
  Value := 0;
end;

{ TNxSpinEdit }

constructor TNxSpinEdit.Create(AOwner: TComponent);
begin
  inherited;
  FButtons := TNxSpinButtons.Create(Self);
  FButtons.CellEditor := Self;
  FButtons.Parent := Self;
  FButtons.Visible := True;
  FButtons.OnSpin := DoSpin;
  FSpinButtons := True;
  FPrecision := 0;
  Value := 0;
  FIncrement := 1;
end;

procedure TNxSpinEdit.CreateWnd;
begin
  inherited;
  UpdateButtonRect;
  FButtons.Repaint;
end;

destructor TNxSpinEdit.Destroy;
begin
  { av when deleting column } //FButtons.Free;
  inherited;
end;

procedure TNxSpinEdit.SetIncrement(const Value: Double);
begin
  FIncrement := Value;
end;

procedure TNxSpinEdit.SetSpinButtons(const Value: Boolean);
const
  ButtonsVisible: array[Boolean] of Integer = (SW_HIDE, SW_SHOW);
begin
  FSpinButtons := Value;
  ShowWindow(FButtons.Handle, ButtonsVisible[FSpinButtons]);
  FButtons.Visible := FSpinButtons;
  UpdateEditRect;
end;

function TNxSpinEdit.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  inherited DoMouseWheelDown(Shift, MousePos);
  Result := True;
  if FInplaceEditor or not SpinButtons then Exit;
  FButtons.PressedButtons := [sbDown];
  FButtons.PressedButtons := []; { spin 1x }
end;

function TNxSpinEdit.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  inherited DoMouseWheelUp(Shift, MousePos);
  Result := True;
  if FInplaceEditor or not SpinButtons then Exit;
  FButtons.PressedButtons := [sbUp];
  FButtons.PressedButtons := [];
end;

procedure TNxSpinEdit.DoSpin(Sender: TObject; Buttons: TSpinButtonSet);
var
(*  State : TKeyboardState;
  CtrlPressed: Boolean;  *)
  Delta: Integer;
begin
  if ReadOnly then Exit;
  if (not Focused) and (Visible) then
      SetFocus;

  Delta := 1;

  if Buttons = [sbUp] then
  begin
    if CheckRange and (Value + FIncrement > Max) then Exit;
    Value := Value + FIncrement * Delta;
  end else
  begin
    { if no signs are allowed, negative values are not
      accepted anyway }
    if (Value = 0) and not(eoAllowSigns in Options) then Exit;
    if CheckRange and (Value - FIncrement < Min) then Exit;
    Value := Value - FIncrement * Delta;
  end;
  SelStart := Length(Text);
  if Assigned(FOnSpin) then FOnSpin(Self, Buttons);

  { StdCtrls.pas }
  Modified := True;
end;

procedure TNxSpinEdit.UpdateButtonRect;
const
  ButtonsVisible: array[Boolean] of Integer = (SWP_HIDEWINDOW, SWP_SHOWWINDOW);
var
  ScrollBarWidth: Integer;
begin
  ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);
  if not HandleAllocated then Exit;
  if BorderStyle = bsSingle
    then SetWindowPos(FButtons.Handle, HWND_TOP, ClientWidth - FButtons.Width, 1, ScrollBarWidth,
      	  ClientHeight - 1, ButtonsVisible[FSpinButtons] or SWP_NOREDRAW)
    else SetWindowPos(FButtons.Handle, HWND_TOP, ClientWidth - FButtons.Width, 0, ScrollBarWidth,
      	  ClientHeight + 1, ButtonsVisible[FSpinButtons] or SWP_NOREDRAW)
end;

procedure TNxSpinEdit.WMKeyDown(var Message: TWMKeyDown);
begin
  inherited;
  if FInplaceEditor or not SpinButtons then Exit;
  case Message.CharCode of
    VK_UP: FButtons.PressedButtons := [sbUp];
    VK_DOWN: FButtons.PressedButtons := [sbDown];
  end;
end;

procedure TNxSpinEdit.WMKeyUP(var Message: TWMKeyUP);
begin
  inherited;
  if FInplaceEditor then Exit;
  FButtons.PressedButtons := [];
end;

procedure TNxSpinEdit.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateButtonRect;
  FButtons.Repaint;
end;

procedure TNxSpinEdit.BeginEditing;
begin
  inherited;
  FButtons.Repaint;
end;

procedure TNxSpinEdit.CMMouseEnter(var Message: TMessage);
begin
  FButtons.HoverButtons := [sbUp, sbDown];
end;

procedure TNxSpinEdit.CMMouseLeave(var Message: TMessage);
begin
  FButtons.HoverButtons := [];
end;

procedure TNxSpinEdit.WMWindowPosChanged(
  var Message: TWMWindowPosChanged);
begin
  inherited;
  Repaint;
  FButtons.Repaint;
end;

function TNxSpinEdit.GetAsFloat: Double;
begin
  Result := Value;
end;

function TNxSpinEdit.GetAsInteger: Integer;
begin
  Result := Round(Value);
end;

procedure TNxSpinEdit.SetAsFloat(const Value: Double);
begin
  Self.Value := Value;
end;

procedure TNxSpinEdit.SetAsInteger(const Value: Integer);
begin
  Self.Value := Value;
end;

procedure TNxSpinEdit.UpdateEditMargins(var LeftMargin,
  RightMargin: Integer);
begin
  inherited;
  if FButtons.Visible then Inc(RightMargin, FButtons.Width);
end;

{ TNxColorPicker }

constructor TNxColorPicker.Create(AOwner: TComponent);
begin
  inherited;
  FOptions := [coColorsButton, coNoneButton];
  FPreviewBorder := True;
  FShowPreview := True;
  FWebColorFormat := False;
  Text := '$00FFFFFF';
  FSelectedColor := $00FFFFFF;
end;

procedure TNxColorPicker.CreatePopupControl;
begin
  inherited;
  with FPopupControl as TNxColorPopup do
  begin
    OnDialogClose := DoDialogClose;
    OnColorOver := DoColorOver;
  end;
end;

procedure TNxColorPicker.CreateWnd;
begin
  inherited;
  
end;

function TNxColorPicker.GetColorAsString(const Value: TColor): string;
begin
  if Value = clNone then Result := '' else
  begin
    if coAllowColorNames in Options then
    begin
      case WebColorFormat of
        True: Result := WebColorToString(Value, True);
        False: Result := ColorToString(Value);
      end;
    end else
    begin
      case WebColorFormat of
        True: Result := HTMLColorToString(Value);
        False: FmtStr(Result, '%s%.8x', [HexDisplayPrefix, Value]);
      end;
    end;
  end;
end;

function TNxColorPicker.GetColorFromText(const Value: string): TColor;
begin
if Value = '' then
  Result := clNone
    else if WebColorFormat then
      Result := GetColorFromHTML(Value)
        else Result := StringToColor(Value);
end;

function TNxColorPicker.GetValidText(UnCheckedText: string;
  AddPrefix: Boolean): string;
var
  i: Integer;
  CanInc: Boolean;
begin
  i := 1;
  CanInc := True;

  repeat
    if UnCheckedText[i] in ['0'..'9', 'a'..'f', 'A'..'F', '#', '$', #8] then
    begin
      { Prefix }
      if (UnCheckedText[i] in ['#', '$']) then
        if (i > 1) or (WebColorFormat and (UnCheckedText[i] = '$')) then
        begin
          Delete(UnCheckedText, i, 1);
          CanInc := False;
        end;

      if CanInc then Inc(i) else if not CanInc then CanInc := not CanInc;
    end else Delete(UnCheckedText, i, 1)
  until i = Length(UnCheckedText) + 1;

  { Add prefix }
  if AddPrefix and (Pos(WebColorPrefix[WebColorFormat], UnCheckedText) = 0) then Insert(WebColorPrefix[WebColorFormat], UnCheckedText, 0);

  Result := UnCheckedText;
end;

function TNxColorPicker.IsValidColorName(const ColorName: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  case WebColorFormat of
    True: for I := Low(WebColorNames) to High(WebColorNames) do if SameText(WebColorNames[I][cnColorName], ColorName) then Exit;
    False: for I := Low(DelphiColorNames) to High(DelphiColorNames) do if SameText(DelphiColorNames[I], ColorName) then Exit;
  end;
  Result := False;
end;

procedure TNxColorPicker.CorrectLenght(var S: string);
var
  maxlen, delta: Integer;
begin
  maxlen := MaxWebColorLen[WebColorFormat];

  if Length(S) > maxlen then SetLength(S, maxlen)
  else if Length(S) < maxlen then
  begin
    delta := Abs(Length(S) - maxlen);
    S := S + StringOfChar('0', delta);
  end;
end;

procedure TNxColorPicker.SetOptions(const Value: TNxColorPickerOptions);
begin
  FOptions := Value;
end;

procedure TNxColorPicker.SetSelectedColor(const Value: TColor);
begin
  if Value <> FSelectedColor then
  begin
    FSelectedColor := Value;
    Text := GetColorAsString(Value);
    RefreshPreview;
  end;
end;

procedure TNxColorPicker.BeforeDrop(var APoint: TPoint);
begin
  inherited;
  with FPopupControl as TNxColorPopup do
  begin
    Font.Assign(Self.Font);
    ColorsButton.Visible := coColorsButton in Options;
    NoneButton.Visible := coNoneButton in Options;
    SelectedColor := Self.SelectedColor;
    UseColorNames := coAllowColorNames in Options;
    WebColorFormat := Self.WebColorFormat;
    Width := 213;
    Height := 151;
  end;
end;

procedure TNxColorPicker.DoColorOver(Sender: TObject; Value: TColor);
begin
  if Assigned(FOnColorOver) then FOnColorOver(Self, Value);
end;

procedure TNxColorPicker.DoDialogClose(Sender: TObject; Execute: Boolean);
begin
  if Assigned(FOnDialogClose) then FOnDialogClose(Self, Execute);
end;

procedure TNxColorPicker.DoDropDownInput(Sender: TObject; Value: string);
begin
  SetTextToColor(Value);
  inherited;
end;

procedure TNxColorPicker.DoTextChange;
begin
  if not(csLoading in ComponentState) and (HandleAllocated) then
    SetTextToColor(Text);
end;

procedure TNxColorPicker.KeyPress(var Key: Char);
begin
  if (Key in [#3, #9, #8, #22, #24]) or (coAllowColorNames in FOptions) then
	begin
  	inherited KeyPress(Key);
	  Exit; { Clipboard keys and tab key - #9 }
	end;

  { Limit }
  if (SelLength = 0) and (Length(Text) >= MaxWebColorLen[WebColorFormat]) then Key := #0;

  { Prefix on 1st pos }
  if (SelStart = 0) and (not (Key in ['#', '$'])) then Key := #0;

  if not (Key in ['0'..'9', 'a'..'f', 'A'..'F', '#', '$', #8]) then Key := #0;

  { Prefix }
  if Key in ['#', '$'] then
  begin
    if WebColorFormat then
    begin
      if Key = '$' then Key := #0;
    end else if Key = '#' then Key := #0;
    if SelStart > 0 then Key := #0;
  end;

  if Key <> #0 then inherited KeyPress(Key);
end;

function TNxColorPicker.GetPopupControlClass: TNxPopupControlClass;
begin
  Result := TNxColorPopup;
end;

procedure TNxColorPicker.SetWebColorFormat(const Value: Boolean);
begin
  if FWebColorFormat <> Value then
  begin
    FWebColorFormat := Value;
    AsString := GetColorAsString(SelectedColor);
  end;
end;

procedure TNxColorPicker.PaintPreview(Canvas: TCanvas; var ARect: TRect);
begin
  inherited PaintPreview(Canvas, ARect);
  with FEditInfo.Canvas do
  begin
    if AsString <> '' then
    begin
      Brush.Color := SelectedColor;
      FillRect(ARect);
    end else
    begin
      Brush.Color := clWhite;
      FillRect(ARect);
      Pen.Color := clRed;
      MoveTo(ARect.Left, ARect.Top);
      LineTo(ARect.Right, ARect.Bottom);
      MoveTo(ARect.Left, ARect.Bottom - 1);
      LineTo(ARect.Right, ARect.Top - 1);
    end;
  end;
end;

procedure TNxColorPicker.CMPaste(var Msg: TMessage);
var
  ClientText, NewText, ClipboardText: string;
  OldSelStart: Integer;
begin
  OldSelStart := SelStart;
  if Clipboard.HasFormat(CF_TEXT)
    then ClipboardText := Clipboard.AsText
      else ClipboardText := '';

  ClientText := Text;
  Delete(ClientText, SelStart + 1, SelLength);

  NewText := GetValidText(ClipboardText, SelStart = 0);
  Insert(NewText, ClientText, SelStart + 1);

  CorrectLenght(ClientText);
  Text := ClientText;
  SelStart := OldSelStart;
end;

procedure TNxColorPicker.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  SetTextToColor(Text); { update SelectedColor prop. }
end;

procedure TNxColorPicker.SetTextToColor(Value: string);
var
  NewText: string;
begin
  if Value <> '' then
  begin
    if coAllowColorNames in FOptions then
    begin
      if IsValidColorName(Value) then
      begin
        FSelectedColor := GetColorFromText(Value);
        RefreshPreview;
        Exit;
      end;
    end;
    NewText := GetValidText(Value, True);
    CorrectLenght(NewText);
    if Value <> NewText then Value := NewText;
    FSelectedColor := GetColorFromText(Value);
  end else
  begin { Click on NONE button }
    FSelectedColor := clNone;
  end;
  RefreshPreview;
end;

function TNxColorPicker.GetColorDialog: TColorDialog;
begin
  Result := TNxColorPopup(FPopupControl).ColorDialog;
end;

{ TNxExecuteButton }

constructor TNxExecuteButton.Create(AOwner: TComponent);
begin
  inherited;
  Width := sizExecuteButton;
end;

destructor TNxExecuteButton.Destroy;
begin
  inherited;

end;

procedure TNxExecuteButton.Paint;
var
  DrawFlags, State, X, Y: Integer;
  r: TRect;
begin
	if IsThemed then
 	begin
    Brush.Color := Self.Color;
    Canvas.FillRect(ClientRect);
    if Down then State := 3 else if FHover then State := 2 else State := 1;
    if not TControl(Owner).Enabled then State := 4;
    r := ClientRect;
    InflateRect(r, 1, 1);
    ThemeRect(Handle, Canvas.Handle, r, teButton, 1, State);
  end else
  begin { theme off }
    with Canvas do
    begin
      if FDown then
      begin
        Brush.Color := clBtnFace;
        Pen.Color := clBtnShadow;
        Rectangle(ClientRect);
      end else
      begin
        DrawFlags := DFCS_ADJUSTRECT or DFCS_BUTTONPUSH;
        if not TControl(Owner).Enabled then DrawFlags := DrawFlags or DFCS_INACTIVE;
        DrawFrameControl(Canvas.Handle, ClientRect, DFC_BUTTON, DrawFlags)
      end;
    end;
  end;
  if Assigned(FGlyph) then
  begin
    X := Width div 2 - FGlyph.Width div 2;
    Y := Height div 2 - FGlyph.Height div 2;
    TDrawProvider.ApplyBitmap(Canvas, X, Y, Glyph);
  end;
  TGraphicsProvider.DrawTextRect(Canvas, ClientRect, taCenter, Caption);
end;

procedure TNxExecuteButton.SetGlyph(const Value: TBitmap);
begin
  FGlyph := Value;
end;

{ TDropDownButton }

constructor TDropDownButton.Create(AOwner: TComponent);
begin
  inherited;
  Width := sizDropDownButton;
end;

procedure TDropDownButton.Paint;
var
  DrawFlags, State: Integer;
begin
	if IsThemed then
 	begin
    if Down then State := 3 else if FHover then State := 2 else State := 1;
    if not TControl(Owner).Enabled then State := 4;
    ThemeRect(Handle, Canvas.Handle, ClientRect, teComboBox, 1, State);
  end else
  begin { theme off }
    DrawFlags := DFCS_SCROLLCOMBOBOX or DFCS_ADJUSTRECT;
    with Canvas do
    begin
      if FDown then DrawFlags := DrawFlags or DFCS_PUSHED;
      if not TControl(Owner).Enabled then DrawFlags := DrawFlags or DFCS_INACTIVE;
      DrawFrameControl(Canvas.Handle, ClientRect, DFC_SCROLL, DrawFlags)
    end;
  end;
end;

{ TNxPopupEdit }

procedure TNxPopupEdit.CreatePopupControl;
begin
  FPopupControl := GetPopupControlClass.Create(Self);
  with FPopupControl do
  begin
    FPopupControl.Visible := False;
    OnDeactivate := DoDropDownDeactivate;
    OnInput := DoDropDownInput;
  end;
end;

procedure TNxPopupEdit.DoButtonDown(Sender: TObject);
var
	ScreenPoint: TPoint;
begin
  ScreenPoint := ClientToScreen(Point(-1, ClientHeight));
  FPopupControl.Font := Self.Font;
	with FPopupControl do
  begin
  	Width := Self.Width;
    Text := Self.Text;
    Cursor := Self.Cursor;
    BeforeDrop(ScreenPoint);
    DroppedDown := True;
  end;
end;

procedure TNxPopupEdit.DoDropDownInput(Sender: TObject; Value: string);
begin
  { note: OnSelect occur first, then OnCloseUp }
  DoSelect;
  inherited;
end;

procedure TNxPopupEdit.DoCloseUp;
begin
  if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;

procedure TNxPopupEdit.DoEditInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  MouseDown(Button, Shift, X, Y);
end;

procedure TNxPopupEdit.DoSelect;
begin
  if Assigned(FOnSelect) then FOnSelect(Self);
end;

function TNxPopupEdit.GetButtonClass: TSmallButtonClass;
begin
  Result := TDropDownButton;
end;

function TNxPopupEdit.GetDefaultDrawing: Boolean;
begin
  Result := Style <> dsDropDownList;
end;

procedure TNxPopupEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
 inherited;
  if (ssAlt in Shift) and (Key in [VK_DOWN, VK_UP])
    then DroppedDown := not DroppedDown;
  if (Key = VK_RETURN) then DroppedDown := False;
end;

procedure TNxPopupEdit.KeyPress(var Key: Char);
begin
  inherited;
  if Key = #27 then FPopupControl.ClosePopup;
end;

procedure TNxPopupEdit.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Button = mbLeft) and (Style = dsDropDownList) then
	begin
    DoButtonDown(Self);
    FButton.Down := True;
  end;
end;

procedure TNxPopupEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Style = dsDropDownList then Cursor := crArrow else Cursor := crDefault;
end;

procedure TNxPopupEdit.Paint;
var
  R, RF, TextR: TRect;
begin
  if Style = dsDropDownList then
  begin
    R := Rect(0, 0, ClientWidth - FButton.Width, ClientHeight);
    with Canvas do
    begin             
      Font.Assign(Self.Font);
      if Focused then
      begin
        Brush.Color := GetFillColor;
        if not InplaceEditor then Font.Color := clHighlightText;
        FillRect(R);
        RF := R;
        if not FHideFocus and not InplaceEditor then
          TGraphicsProvider.DrawFocused(Canvas, RF);
      end else
      begin
        Brush.Color := Self.Color;
        FillRect(R);
      end;
      TextR := R;
      Inc(TextR.Left, EditMargins.Left);
      Inc(TextR.Left, FEditInfo.Width);
      Dec(TextR.Right, EditMargins.Right);
      if BorderStyle = bsSingle then
      begin
        InflateRect(TextR, -BorderWidth, -BorderWidth);
        InflateRect(TextR, -2, -2); { margin }
      end;
      if not Enabled then Font.Color := clGrayText;
      TGraphicsProvider.DrawWrapedTextRect(Canvas, TextR, Alignment, taAlignTop, False, Text, BiDiMode);
    end;
  end;
end;

procedure TNxPopupEdit.SetDroppedDown(const Value: Boolean);
var
	ScreenPoint: TPoint;
begin
  if FDroppedDown <> Value then
  begin
    FDroppedDown := Value;
    if FDroppedDown then
    begin
      ScreenPoint := ClientToScreen(Point(-1, ClientHeight));
      FPopupControl.Font := Self.Font;
	    with FPopupControl do
      begin
  	    Width := Self.Width;
        FPopupControl.Text := Self.Text;
        BeforeDrop(ScreenPoint);
        FEditing := True;
  	    Popup(ScreenPoint.X, ScreenPoint.Y);
        if Style = dsDropDownList then Self.Invalidate;
      end;
    end else
    begin
      FPopupControl.DropMode := dmClosed;
      ReleaseCapture;
      FEditing := False;
      FButton.Down := False;
      ShowWindow(FPopupControl.Handle, SW_HIDE);
      DoCloseUp;
    end;
  end;
end;

procedure TNxPopupEdit.SetHideFocus(const Value: Boolean);
begin
  FHideFocus := Value;
  Invalidate;
end;

procedure TNxPopupEdit.SetStyle(const Value: TDropDownStyle);
begin
  FStyle := Value;
  case FStyle of
    dsDropDown:	begin
                  { Bn: Most probably not needed any more }
                  ReadOnly := False;
                  Cursor := crDefault;
                end;
    dsDropDownList:	begin
                      ReadOnly := True;
                      Cursor := crArrow;
                    end;
  end;
  UpdateEditRect;
end;

procedure TNxPopupEdit.VisibleChanging;
begin
  inherited;
  if Assigned(FPopupControl) then FPopupControl.ClosePopup;
end;

procedure TNxPopupEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  DroppedDown := False;
  FEditing := False;
  FButton.Invalidate;
  Invalidate;
end;

procedure TNxPopupEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if (FStyle = dsDropDownList) then DestroyCaret;
  Invalidate;
end;

procedure TNxPopupEdit.WMShowWindow(var Message: TWMShowWindow);
begin
  inherited;
  if not(csDestroying in ComponentState) then FPopupControl.ClosePopup;
end;

procedure TNxPopupEdit.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  if Style = dsDropDownList then Message.Result := 1;
end;

function TNxPopupEdit.GetFillColor: TColor;
begin
  Result := Color;
  if not InplaceEditor and (FStyle = dsDropDownList) and Focused then Result := clHighlight;
end;

{ TNxFontComboBox }

constructor TNxFontComboBox.Create(AOwner: TComponent);
begin
  inherited;
  Items.Assign(Screen.Fonts);
end;

procedure TNxFontComboBox.BeforeDrop(var APoint: TPoint);
begin
  inherited;
  with FPopupControl as TFontPopup do
  begin
    Items := Self.Items;
  end;
end;

function TNxFontComboBox.GetPopupControlClass: TNxPopupControlClass;
begin
  Result := TFontPopup;
end;

procedure TNxFontComboBox.PaintPreview(Canvas: TCanvas; var ARect: TRect);
begin
  TDisplayProvider.DrawFontPreview(FEditInfo.Canvas, ARect, AsString);
  FEditInfo.Canvas.Font.Assign(Font);
end;

{ TNxButtonEdit }

constructor TNxButtonEdit.Create(AOwner: TComponent);
begin
  inherited;
  FButtonGlyph := Graphics.TBitmap.Create;
  with FButton as TNxExecuteButton do
  begin
    Glyph := Self.FButtonGlyph;
  end;
  FTransparentColor := clNone;
  FButtonWidth := FButton.Width;
end;

destructor TNxButtonEdit.Destroy;
begin
  FreeAndNil(FButtonGlyph);
  inherited;
end;

procedure TNxButtonEdit.ApplyTransparency;
begin
  if not(FButtonGlyph.Empty) then
  begin
    FButtonGlyph.Transparent := True;
    FButtonGlyph.TransparentColor := FTransparentColor;
    FButton.Refresh;
  end;
end;

procedure TNxButtonEdit.SetButtonGlyph(const Value: Graphics.TBitmap);
begin
  FButtonGlyph.Assign(Value);
  ApplyTransparency;
end;

procedure TNxButtonEdit.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  ApplyTransparency;
end;

procedure TNxButtonEdit.SetButtonCaption(const Value: WideString);
begin
  FButtonCaption := Value;
  FButton.Caption := Value;
  FButton.Refresh;
end;

procedure TNxButtonEdit.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;
  FButton.Width := Value;
  UpdateEditRect;
  UpdateButton;
end;

procedure TNxButtonEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) and (ssCtrl in Shift) then
    DoButtonClick(Self);
end;

{ TNxImagePathEdit }

procedure TNxImagePathEdit.DoButtonClick(Sender: TObject);
var
  PictureDialog: TOpenPictureDialog;
begin
  inherited;
  PictureDialog := nil; // to avoid Delphi warning
  try
    PictureDialog := TOpenPictureDialog.Create(Self);
    if PictureDialog.Execute then Text := PictureDialog.FileName;
   finally
    PictureDialog.free;
  end;
end;

{ TNxFolderEdit }

constructor TNxFolderEdit.Create(AOwner: TComponent);
begin
  inherited;
  FDialogCaption := 'Select folder';
  FRoot := '\';
end;

procedure TNxFolderEdit.DoButtonClick(Sender: TObject);
var
  Folder: string;
begin
  inherited;
  Folder := Text;
  if SelectDirectory(FDialogCaption, FRoot, Folder) then
  begin
    Text := Folder;
  end;
end;

{ TNxTimeEdit }
{$HINTS OFF}
{$WARNINGS OFF}

constructor TNxTimeEdit.Create(AOwner: TComponent);
begin
  inherited;
  FButtons := TNxSpinButtons.Create(Self);
  FButtons.CellEditor := Self;
  FButtons.Parent := Self;
  FButtons.Visible := True;
  FTimeFormat := '';
  Text := TimeToStr(Now);
end;

destructor TNxTimeEdit.Destroy;
begin
  FButtons.Free;
  inherited;
end;

function TNxTimeEdit.GetTimeFormat: string;
begin
  { 2/28/07:  if FTimeFormat is empty, global variable LongTimeFormat is used
              Example: h:mm:ss AM/PM }
  if FTimeFormat = '' then Result := LongTimeFormat else Result := FTimeFormat;
  Result := CleanTimeFormat(Result);
end;

function TNxTimeEdit.GetTimeSeparator: string;
begin
  if FTimeSeparator = '' then Result := SysUtils.TimeSeparator else
    Result := FTimeSeparator;
end;

type
  TValidPart = (vpNumber, vpSeparator, vpAMPM);

function TNxTimeEdit.GetValidText(UnCheckedText: string): string;
var
  CanInc, Use24HourFormat: Boolean;
  t: TNxTimeElement;
  i, c: Integer;
  ValidChar: Char;
  HourDone, MinDone, SecDone: Boolean;
  TimeFormatStr, Hour, Min, Sec, AMPM: string;
  AMPMPos: Integer;
  Vp: TValidPart;
  HourCount, MinCount, SecCount, SeparatorCount: Integer;
begin


  TimeFormatStr := GetTimeFormat;
  Use24HourFormat := Is24HourFormat;

  if not Is24HourFormat then
  begin
    AMPMPos := Pos('AM/PM', TimeFormatStr);
  end;

  exit;


  CanInc := True;
  t := teHour;

  i := 1;
  repeat
    if i = AMPMPos then
    begin

    end;
    case TimeFormatStr[i] of
      'h': if UnCheckedText[i] in ['0'..'9'] then
          begin

          end;
      'm': Vp := vpNumber;
      's': Vp := vpNumber;
      ':': Vp := vpSeparator;
    end;
    Inc(i);
  until i = Length(UnCheckedText) + 1;
end;

function TNxTimeEdit.CleanTimeFormat(Value: string): string;
var
  i, hc, hm, hsec, hsep: Integer;
begin
  hc := 0;
  hm := 0;
  hsec := 0;
  hsep := 0;
  i := 1;
  repeat
    case Value[i] of
      'h':  begin
              Inc(hc);
              if hc <= 2 then Result := Result + Value[i];
            end;
      'm':  begin
              Inc(hm);
              if hm <= 2 then Result := Result + Value[i];
            end;
      's':  begin
              Inc(hsec);
              if hsec <= 2 then Result := Result + Value[i];
            end;
      ':':  begin
              Inc(hsep);
              if hsep <= 2 then Result := Result + Value[i];
            end;
    end;
    Inc(i);
  until i = Length(Value) + 1;
end;

procedure TNxTimeEdit.SetSpinButtons(const Value: Boolean);
begin
  FSpinButtons := Value;
end;

procedure TNxTimeEdit.SetTimeFormat(const Value: string);
begin
  FTimeFormat := Value;
end;

procedure TNxTimeEdit.SerTimeSeparator(const Value: string);
begin
  FTimeSeparator := Value;
end;

procedure TNxTimeEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
//  SetTimeToColor;
end;

procedure TNxTimeEdit.SetTimeToColor;
var
  NewText: string;
begin
  if Text <> '' then
  begin
    NewText := GetValidText(Text);
    if Text <> NewText then Text := NewText;
  end;
end;

procedure TNxTimeEdit.UpdateButtonRect;
const
  ButtonsVisible: array[Boolean] of Integer = (SWP_HIDEWINDOW, SWP_SHOWWINDOW);
var
  ScrollBarWidth: Integer;
begin
  ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);
  if not HandleAllocated then Exit;
  if BorderStyle = bsSingle
    then SetWindowPos(FButtons.Handle, HWND_TOP, ClientWidth - FButtons.Width, 1, ScrollBarWidth,
      	  ClientHeight - 1, ButtonsVisible[FSpinButtons] or SWP_NOREDRAW)
    else SetWindowPos(FButtons.Handle, HWND_TOP, ClientWidth - FButtons.Width, 0, ScrollBarWidth,
      	  ClientHeight + 1, ButtonsVisible[FSpinButtons] or SWP_NOREDRAW)
end;

procedure TNxTimeEdit.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateButtonRect;
end;

procedure TNxTimeEdit.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;

end;

function TNxTimeEdit.Is24HourFormat: Boolean;
begin
  { 2/28/07:  AM/PM may be at ANY position, but
              format must be AM/PM }
  Result := Pos('AM/PM', GetTimeFormat) > 0;
end;
{$HINTS ON}
{$WARNINGS ON}

{ TNxMemo }

procedure TNxMemo.Add(const AFormat: string; const Args: array of const);
begin
  Lines.Add(Format(AFormat, Args));
end;

procedure TNxMemo.Add(const S: string);
begin
  Lines.Add(S);
end;

constructor TNxMemo.Create(AOwner: TComponent);
begin
  inherited;
  FMargin := 0;
end;

destructor TNxMemo.Destroy;
begin

  inherited;
end;

procedure TNxMemo.CreateWnd;
begin
  inherited;
  UpdateEditRect;
end;

procedure TNxMemo.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  UpdateEditRect;
  Realign;
end;

function TNxMemo.GetEditRect: TRect;
begin
  Result := Rect(FMargin, 0, ClientWidth - (1 + FMargin), ClientHeight + 1);
end;

procedure TNxMemo.RedrawBorder;
var
  DC: HDC;
  R, R1: TRect;
begin
  if IsThemed and (BorderStyle = bsSingle) then
  begin
    R := Rect(0, 0, Width, Height);
    DC := GetWindowDC(Handle);
    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    R1 := R;
    InflateRect(R1, -2, -2);
    ExcludeClipRect(DC, R1.Left, R1.Top, R1.Right, R1.Bottom);
    ThemeRect(Handle, DC, R, teEdit, 1, 0);
    ReleaseDC(Handle, DC);
  end;
end;

procedure TNxMemo.UpdateEditRect;
var
  EditRect: TRect;
begin
  EditRect := GetEditRect;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@EditRect));
end;

procedure TNxMemo.WMNCPaint(var Message: TMessage);
begin
  inherited;
  if IsThemed then RedrawBorder;
end;

{ TNxCalcEdit }

constructor TNxCalcEdit.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csSetCaption];
  FAutoClose := False;
  FMax := 0;
  FMemory := 0;
  FMin := 0;
  FOptions := [eoAllowFloat, eoAllowSigns];
  FOperation := cpNone;
  Value := 0;
  FValue := 0;
  FReset := True;
end;

destructor TNxCalcEdit.Destroy;
begin

  inherited;
end;

procedure TNxCalcEdit.CalculateValue;
begin
  if FValue <> 0 then Equal;
end;

procedure TNxCalcEdit.BeforeDrop(var APoint: TPoint);
begin
  inherited;
  with FPopupControl do
  begin
    Font.Assign(Self.Font);
    FValue := 0; { clar auto-calculate buffer }
    Height := 139;
    Width := 199;
  end;
end;

procedure TNxCalcEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (eoDisableTyping in FOptions)  and (not ValidKey(Key)) then
    Exit;

  inherited;
end;

procedure TNxCalcEdit.KeyPress(var Key: Char);
begin
  if eoDisableTyping in FOptions then
  begin
    Key := #0;
    Exit;
  end;

  if Key in [#3, #9, #22, #24] then
	begin
  	inherited KeyPress(Key);
	  Exit; { Clipboard keys and tab key - #9 }
	end;

  if not (Key in ['0'..'9', DecimalSeparator, '-', '+', #8]) then Key := #0;

  { Decimal Separator }
  if Key = DecimalSeparator then
    if eoAllowFloat in FOptions then
    begin
      if (Pos(Key, Text) > 0) and (Pos(Key, SelText) = 0) then Key := #0;
    end else Key := #0;

  { Signs }
  if (Key = '-') or (Key = '+') then
    if eoAllowSigns in FOptions then
    begin
      if ((SelStart > 0) or (Pos('-', Text) > 0) or (Pos('+', Text) > 0))
        and ((Pos('-', SelText) = 0) and (Pos('+', SelText) = 0)) then Key := #0;
    end else Key := #0;

  if Key <> #0 then
  begin
    FReset := True;
    inherited KeyPress(Key);
  end;
end;

procedure TNxCalcEdit.MoveCursor;
begin
  SelStart := Length(Text);
end;

procedure TNxCalcEdit.CMPaste(var Msg: TMessage);
var
  ClientText, NewText, ClipboardText: string;
  OldSelStart: Integer;
  AllowFloat, AllowSigns: Boolean;
begin
  OldSelStart := SelStart;
  if Clipboard.HasFormat(CF_TEXT)
    then ClipboardText := Clipboard.AsText
      else ClipboardText := '';

  ClientText := Text;
  Delete(ClientText, SelStart + 1, SelLength);

  if (eoAllowFloat in FOptions)
    and (Pos(DecimalSeparator, ClientText) = 0)
      then AllowFloat := True
        else AllowFloat := False;

  if (eoAllowSigns in FOptions)
    and (SelStart = 0)
      then AllowSigns := True
        else AllowSigns := False;

  NewText := GetNumericText(ClipboardText, AllowFloat, AllowSigns, Max, Min);

  Insert(NewText, ClientText, SelStart + 1);

  Text := ClientText;
  SelStart := OldSelStart;
end;

procedure TNxCalcEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  SetValueToText(Value);
end;

function TNxCalcEdit.GetValue: Double;
var
  ValidText: string;
begin
  if Text = '' then Result := 0 else
  begin
    ValidText := GetNumericText(Text, eoAllowFloat in FOptions, eoAllowSigns in FOptions, Max, Min);
    if ValidText = '' then ValidText := '0';
    Result := StrToFloat(ValidText);
  end;
end;

procedure TNxCalcEdit.SetValue(const Value: Double);
begin
  SetValueToText(Value);
end;

procedure TNxCalcEdit.SetOptions(const Value: TNxNumberEditOptions);
begin
  FOptions := Value;
  SetValueToText(Self.Value);
end;

procedure TNxCalcEdit.SetValueToText(SendValue: Double);
begin
  Text := FloatToStr(SendValue);
end;

function TNxCalcEdit.GetPopupControlClass: TNxPopupControlClass;
begin
  Result := TNxCalcPopup;
end;

function TNxCalcEdit.IsMemoryEmpty: Boolean;
begin
  Result := FMemory = 0;
end;

procedure TNxCalcEdit.AddNumber(const Number: Integer);
begin
  if FReset then Text := ''; { type new number }
  Text := Text + IntToStr(Number);
  MoveCursor;
  FReset := False;
end;

procedure TNxCalcEdit.AddDot;
begin
  Text := Text + DecimalSeparator;
  MoveCursor;
end;

procedure TNxCalcEdit.Backspace;
var
  S: string;
begin
  S := Text;
  Delete(S, Length(S), 1);
  if S = '' then
  begin
    S := '0';
    FReset := True;
  end;
  Text := S;
  MoveCursor;
end;

procedure TNxCalcEdit.ClearMemory;
begin
  FMemory := 0;
end;

procedure TNxCalcEdit.ClearValue;
begin
  Value := 0;
  FValue := 0;
  FReset := True;
  MoveCursor;
end;

procedure TNxCalcEdit.Divide;
begin
  CalculateValue;
  FValue := Value;
  FOperation := cpDivide;
  FReset := True;
end;

procedure TNxCalcEdit.Erase;
begin
  Value := 0;
  FReset := True;
  MoveCursor;
end;

procedure TNxCalcEdit.Equal;
var
  AValue: Double;
begin
  case FOperation of
    cpDivide: AValue := FValue / Value;
    cpMultiply: AValue := FValue * Value;
    cpMinus: AValue := FValue - Value;
    cpPlus: AValue := FValue + Value;
    else AValue := Value;
  end;
  if FFormatMask <> ''
    then Text := FormatFloat(FFormatMask, AValue)
    else Value := AValue;
  MoveCursor;
  FReset := True;
  if DroppedDown and AutoClose then DroppedDown := False;
end;

procedure TNxCalcEdit.Memory;
begin
  FMemory := Value;
end;

procedure TNxCalcEdit.Minus;
begin
  CalculateValue;
  FValue := Value;
  FOperation := cpMinus;
  FReset := True;
end;

procedure TNxCalcEdit.Multiply;
begin
  CalculateValue;
  FValue := Value;
  FOperation := cpMultiply;
  FReset := True;
end;

procedure TNxCalcEdit.Plus;
begin
  CalculateValue;
  FValue := Value;
  FOperation := cpPlus;
  FReset := True;
end;

procedure TNxCalcEdit.Ratio;
begin
  CalculateValue;
  Value := 1 / Value;
  SetValueToText(Value);
  MoveCursor;
end;

procedure TNxCalcEdit.RestoreMemory;
begin
  if FMemory > 0 then
  begin
    Value := FMemory;
    MoveCursor;
  end;
end;

procedure TNxCalcEdit.Sign;
var
  S: string;
begin
  if Text[1] = '-' then
  begin
    S := Text;
    Delete(S, 1, 1);
    Text := S;
  end else Text := '-' + Text;
  FValue := Value; { add/remowe '-' to stored value }
end;

procedure TNxCalcEdit.Sqrt;
begin
  CalculateValue;
  Value := System.Sqrt(Value);
  SetValueToText(Value);
  MoveCursor;
end;

procedure TNxCalcEdit.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
end;

{ TNxRadioButton }

constructor TNxRadioButton.Create(AOwner: TComponent);
begin
  inherited;
  FChecked := False;
  FDown := False;
  FGrayed := False;
  FHover := False;
  FIndent := spChkBoxTextIndent;
  Color := clWindow;
  ParentColor := False;
  Width := 75;
  Height := 21;
end;

destructor TNxRadioButton.Destroy;
begin

  inherited;
end;

function TNxRadioButton.GetCheckBoxRect: TRect;
var
	r: TRect;
  p: TPoint;
  w: Integer;
begin
  r := ClientRect;
	InflateRect(r, 1, 1);
  if IsThemed then w := 13 else w := 11;
  p := TCalcProvider.PosInRect(w, w, 2, r, Alignment, VerticalAlignment);
  Result := Rect(p.X, p.Y, p.X + w, p.Y + w);
end;

function TNxRadioButton.GetAsBoolean: Boolean;
begin
  Result := FChecked;
end;

function TNxRadioButton.GetAsString: WideString;
begin
  Result := BoolToStr(FChecked, True);
end;

procedure TNxRadioButton.BeginEditing;
begin
  inherited;
  Refresh;
end;

procedure TNxRadioButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then
  begin
	  FDown := True;
	  Invalidate;
  end;
end;

procedure TNxRadioButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then
  begin
	  FDown := False;
	  Checked := not Checked;
  end;
end;

procedure TNxRadioButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
	r: TRect;
begin
  inherited;
  SetFocus;
  if (Button = mbLeft)
    and (PtInRect(GetCheckBoxRect, Point(X, Y)) or (coExpandActiveRect in FOptions)) then
  begin
	  FDown := True;
	  r := GetCheckBoxRect;
	  InvalidateRect(Handle, @r, False);
  end;
end;

procedure TNxRadioButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if PtInRect(GetCheckBoxRect, Point(X, Y)) or
    (coExpandActiveRect in FOptions) then Hover := True else Hover := False;
end;

procedure TNxRadioButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
	r: TRect;
begin
  inherited;
  if (Button = mbLeft)
    and (PtInRect(GetCheckBoxRect, Point(X, Y)) or (coExpandActiveRect in FOptions)) then
  begin
    Checked := True;
  end;
  if FDown then
  begin
    FDown := False;
	  r := GetCheckBoxRect;
    InvalidateRect(Handle, @r, False);
  end;
end;

procedure TNxRadioButton.Paint;
var
	R, TextRect: TRect;
begin
  Canvas.Brush.Color := Self.Color;
  Canvas.FillRect(ClientRect);
  R := ClientRect;
  InflateRect(R, 1, 1);
  TextRect := ClientRect;
  TextRect.Left := DrawRadioButton.Right + FIndent;
  Canvas.Font.Assign(Font);
  DrawTextRect(Canvas, TextRect, taLeftJustify, Caption);
end;

procedure TNxRadioButton.SetAsBoolean(const Value: Boolean);
begin
  inherited;
  Checked := Value;
end;

procedure TNxRadioButton.SetAsString(const Value: WideString);
begin
  inherited;
  Checked := LowerCase(Value) = 'true';
end;

procedure TNxRadioButton.SetChecked(const Value: Boolean);
  procedure TurnSiblingsOff;
  var
    i: Integer;
    Sibling: TControl;
  begin
    if Parent <> nil then
      with Parent do
        for i := 0 to ControlCount - 1 do
        begin
          Sibling := Controls[I];
          if (Sibling <> Self) and (Sibling is TNxRadioButton) then
            with TNxRadioButton(Sibling) do
            begin
              if Assigned(Action) and
                 (Action is TCustomAction) and
                 TCustomAction(Action).AutoCheck then
                TCustomAction(Action).Checked := False;
              SetChecked(False);
            end;
        end;
  end;
var
	r: TRect;
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if FChecked then TurnSiblingsOff;
    r := GetCheckBoxRect;
    InvalidateRect(Handle, @r, False);
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TNxRadioButton.SetGrayed(const Value: Boolean);
begin
  FGrayed := Value;
end;

procedure TNxRadioButton.SetHover(const Value: Boolean);
var
	r: TRect;
begin
 	if FHover <> Value then
  begin
	  FHover := Value;
    r := GetCheckBoxRect;
    InvalidateRect(Handle, @r, False);
  end;
end;

procedure TNxRadioButton.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxRadioButton.CMMouseLeave(var Message: TMessage);
begin
  Hover := False;
end;

procedure TNxRadioButton.Clear;
begin
  Checked := False;
end;

function TNxRadioButton.GetDefaultDrawing: Boolean;
begin
  Result := False;
end;

function TNxRadioButton.DrawRadioButton: TRect;
var
  P: TPoint;
  Index, Flags: Integer;
begin
	if IsThemed then
  begin
	  P := TCalcProvider.PosInRect(13, 13, 2, ClientRect, Alignment, VerticalAlignment);
	  Result := Rect(P.X, P.Y, P.X + 13, P.Y + 13);
    Index := 1;
    if Hover then
		begin
    	case Checked of
        True: if FDown then Index := 7 else Index := 6;
        False: if FDown then Index := 3 else Index := 2;
      end;
		end else if Checked then Index := 5;
    if not Enabled then Inc(Index, 3);
    ThemeRect(Handle, Canvas.Handle, Result, teButton, tcRadioButton, Index);
  end else
  begin
	  P := TCalcProvider.PosInRect(12, 12, 2, ClientRect, Alignment, VerticalAlignment);
    Result := Rect(P.X, P.Y, P.X + 12, P.Y + 12);
    Flags := DFCS_BUTTONRADIO;
    if FDown then Flags := Flags or DFCS_PUSHED;
    if Checked then Flags := Flags or DFCS_CHECKED;
    if not Enabled then Flags := Flags or DFCS_INACTIVE;
    DrawFrameControl(Canvas.Handle, Result, DFC_BUTTON, Flags);
  end;
end;

procedure TNxRadioButton.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TNxRadioButton.SetOptions(const Value: TCheckBoxOptions);
begin
  FOptions := Value;
  Invalidate;
end;

procedure TNxRadioButton.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Invalidate;
end;

{ TNxMemoInplaceEdit }

constructor TNxMemoInplaceEdit.Create(AOwner: TComponent);
begin
  inherited;
  AutoSize := False;
  Height := 89;
  WantReturns := True;
  Width := 185;
  WordWrap := True;
end;

procedure TNxMemoInplaceEdit.CreateParams(var Params: TCreateParams);
const
  ScrollBar: array[TScrollStyle] of DWORD = (0, WS_HSCROLL, WS_VSCROLL,
    WS_HSCROLL or WS_VSCROLL);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or ScrollBar[FScrollBars];
  if FWordWrap then Params.Style := Params.style and not ES_AUTOHSCROLL;
end;

procedure TNxMemoInplaceEdit.SetScrollBars(const Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    RecreateWnd;
  end;
end;

procedure TNxMemoInplaceEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if not FWantReturns then
    Message.Result := Message.Result and not DLGC_WANTALLKEYS;
end;

{ TNxMonthCalendar }

constructor TNxMonthCalendar.Create(AOwner: TComponent);
begin
  inherited;
  FDay := 1;
  FDown := False;
  FMonth := 1;
  FYear := 1;
  Date := Today;
  FShowNoneButton := False;

  FTodayCaption := strToday;
  FTodayButton := TNxMiniButton.Create(Self);
  FTodayButton.Parent := Self;
  FTodayButton.Visible := True;
  FTodayButton.SetBounds(20, 133, 47, 20);
  FTodayButton.Text := FTodayCaption;
  FTodayButton.Tag := 0;
  FTodayButton.OnMouseUp := DoButtonMouseUp;

  FNoneCaption := strNone;
  FNoneButton := TNxMiniButton.Create(Self);
  FNoneButton.Parent := Self;
  FNoneButton.Visible := FShowNoneButton;
  FNoneButton.SetBounds(82, 133, 47, 20);
  FNoneButton.Text := FNoneCaption;
  FNoneButton.Tag := 1;
  FNoneButton.OnMouseUp := DoButtonMouseUp;

  FMonthNames := TStringList.Create;
  FDayNames := TStringList.Create;

  Color := clWindow;
  ParentColor := False;
  Height := 163;
  Width := 151;
end;

procedure TNxMonthCalendar.CreateWnd;
begin
  inherited;
  ShowNoneButton := FShowNoneButton;
end;

destructor TNxMonthCalendar.Destroy;
begin
  FreeAndNil(FDayNames);
  FreeAndNil(FMonthNames);
  FreeAndNil(FNoneButton);
  FreeAndNil(FTodayButton);
  inherited;
end;

procedure TNxMonthCalendar.DoButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case (Sender as TNxMiniButton).Tag of
    0:  Date := Today;
    1:  Date := 0;
  end;
  RefreshMonth;
end;

procedure TNxMonthCalendar.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxMonthCalendar.DoDayFont(Day: Integer; Font: TFont);
begin
  if Assigned(FOnDayFont) then FOnDayFont(Self, Day, Font);
end;

function TNxMonthCalendar.GetActualStartDay: TStartDayOfWeek;
var
  D: array[0..1] of char;
begin
  case FStartDay of
    dwAutomatic:
    begin
      GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_IFIRSTDAYOFWEEK, D, SizeOf(D));
      case StrToInt(D) of
        0: Result := dwMonday;
        else Result := dwSunday;
      end;
    end
    else Result := FStartDay;
  end;
end;

function TNxMonthCalendar.GetDateAtPos(ACol, ARow: Integer): TDate;
var
	PastMonth, PastYear, StartingDay, LastDayInPastMonth, DaysInPastMonth, delta: Integer;
  p, ADay: Integer;
begin
	p := ARow * 7 + ACol;
  StartingDay := GetDayOfWeek(StartOfAMonth(Year, Month));
  if p < StartingDay - 1 then
  begin
    PastYear := Year;
    PastMonth := Month;
    SetPastMonth(PastYear, PastMonth);
    LastDayInPastMonth := GetDayOfWeek(EndOfAMonth(PastYear, PastMonth));
    DaysInPastMonth := DaysInAMonth(PastYear, PastMonth);
    delta := LastDayInPastMonth - (ACol + 1);
    Result := EncodeDate(PastYear, PastMonth, DaysInPastMonth - delta);
  end
  else if p + 2 > StartingDay + DaysInAMonth(Year, Month) then
  begin
    PastYear := Year;
    PastMonth := Month;
    SetPastMonth(PastYear, PastMonth, False);
    ADay := p - (StartingDay + DaysInAMonth(Year, Month)) + 2;
    Result := EncodeDate(PastYear, PastMonth, ADay);
  end
  else Result := EncodeDate(Year, Month, (ARow * 7) + (ACol - StartingDay + 2));
end;

function TNxMonthCalendar.GetDayInWeekChar(DayInWeek: Integer): Char;
begin
  Result := ' ';

  if Assigned(FDayNames) and InRange(DayInWeek, 1, 7)
    and (FDayNames.Count >= 7) then Result := FDayNames[DayInWeek - 1][1] else
  case GetActualStartDay of
    dwSunday: Result := LongDayNames[DayInWeek][1];
    dwMonday: if DayInWeek = 7 then Result := LongDayNames[1][1]
      else Result := LongDayNames[DayInWeek + 1][1];
  end;
end;

function TNxMonthCalendar.GetDayOfWeek(Day: TDateTime): Integer;
begin
  Result := 0;
  case GetActualStartDay of
    dwSunday: Result := DayOfWeek(Day);
    dwMonday: Result := DayOfTheWeek(Day);
  end;
end;

function TNxMonthCalendar.GetDaysRect: TRect;
begin
  Result := Rect(spDateStart, 37, ClientWidth - spDateStart, 127);
end;

function TNxMonthCalendar.GetMonthName(Month: Integer): WideString;
begin
  if Assigned(FMonthNames) and InRange(Month, 1, 12)
    and (FMonthNames.Count >= 12)
      then Result := FMonthNames[Month - 1] else Result := LongMonthNames[Month];
end;

function TNxMonthCalendar.GetMonthRect: TRect;
begin
  Result := Rect(5, 5, ClientWidth - 5, 5 + 16);
end;

procedure TNxMonthCalendar.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if PtInRect(Rect(0, 0, 18, 18), Point(X, Y)) then
  begin
    if Month > 1 then Month := Month - 1 else
    begin
	    Year := Year - 1;
      Month := 12;
    end;
  end;
  if PtInRect(Rect(ClientWidth - 18, 0, ClientWidth, 18), Point(X, Y)) then
  begin
    if Month < 12 then Month := Month + 1 else
    begin
	    Year := Year + 1;
      Month := 1;
    end;
  end;
  if PtInRect(Rect(14, 38, ClientWidth - 14, ClientHeight - 20), Point(X, Y)) then
  begin
    FDown := True;
    SelectDate(X, Y);
  end;
end;

procedure TNxMonthCalendar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (FDown) and (PtInRect(Rect(14, 38, ClientWidth - 14, ClientHeight - 20), Point(X, Y))) then
  begin
    SelectDate(X, Y);
  end;
end;

procedure TNxMonthCalendar.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
	if not PtInRect(Rect(0, 0, ClientWidth, 19), Point(X, Y)) then inherited;
  FDown := False;
end;

procedure TNxMonthCalendar.Paint;
var
	i, X, Y, p: Integer;
	dy, dm, dd, diw: Integer;
  r: TRect;
begin
  inherited;
  X := spDateStart;
  Y := 38;
  p := 0;
  with Canvas do
  begin
    Font.Assign(Self.Font);
    Font.Color := clWindowText;
    Brush.Color := Self.Color;
    Pen.Color := clGrayText;
    Rectangle(0, 0, ClientWidth, ClientHeight);
    PaintMonth(GetMonthRect);
    for i := 1 to 7 do
    begin
      TGraphicsProvider.DrawTextRect(Canvas, Rect(X, 22, X + 15, 36), taRightJustify, GetDayInWeekChar(i));
      Inc(X, 17);
    end;
	  X := spDateStart;
    Pen.Color := clGrayText;
    MoveTo(15, 36);
    LineTo(ClientWidth - 17, 36);
    Pen.Color := clGrayText;
    MoveTo(15, 128);
    LineTo(ClientWidth - 17, 128);

    dy := Year;
    dm := Month;
    diw := 1;
    if GetDayOfWeek(StartOfAMonth(Year, Month)) > 1 then
    begin
      SetPastMonth(dy, dm);
      dd := DaysInAMonth(dy, dm) - GetDayOfWeek(StartOfAMonth(Year, Month)) + 2;
    end else dd := 1;
    while p < 42 do
    begin
    	r := Rect(X, Y, X + 15, Y + 15);
      if dm = Month then Font.Color := clWindowText else Font.Color := clGrayText;
      if EncodeDate(dy, dm, dd) = SelectedDate then
      begin
      	if IsThemed then Brush.Color := RGB(251, 230, 148) else Brush.Color := clSilver;
        FillRect(Rect(X, Y, X + 17, Y + 15));
        FOldRect := Rect(X, Y, X + 17, Y + 15);
      end;
      if EncodeDate(dy, dm, dd) = Today then
      begin
      	if IsThemed then Brush.Color := clMaroon else Brush.Color := clHighlight;
        FrameRect(Rect(X, Y, X + 17, Y + 15));
      end;
      PaintDay(dd, r);
      Inc(p);
      Inc(dd);
      if dd > DaysInAMonth(dy, dm) then
			begin
	      SetPastMonth(dy, dm, False);
        dd := 1;
			end;
      Inc(X, 17);
      Inc(diw);
      if diw > 7 then
      begin
        X := spDateStart;
        Inc(Y, 15);
        diw := 1;
      end;
    end;
  end;
end;

procedure TNxMonthCalendar.PaintDay(Day: Integer; DayRect: TRect);
var
  StringText: string;
begin
  with Canvas.Brush do
  begin
    Style := bsClear;
    StringText := IntToStr(Day);
    DoDayFont(Day, Canvas.Font);
    TGraphicsProvider.DrawWrapedTextRect(Canvas, DayRect, taRightJustify, taVerticalCenter, False, StringText, bdLeftToRight);
    Style := bsSolid;
  end;
end;

procedure TNxMonthCalendar.PaintMonth(MonthRect: TRect);
var
  PosY: Integer;
begin
  with Canvas do
  begin
    if not IsThemed	then Brush.Color := clBtnFace
      else Brush.Color := TGraphicsProvider.BlendColor(clGradientInactiveCaption, clWindow, 249);

    FillRect(MonthRect);
    Font.Color := clWindowText;
    DrawTextRect(Canvas, MonthRect, taCenter, GetMonthName(Month) + ' ' + IntToStr(Year));

    { draw left and right arrow }
    Brush.Color := clWindowText;
    Pen.Color := clWindowText;
    PosY := MonthRect.Top + (MonthRect.Bottom - MonthRect.Top) div 2 - 8 div 2;
    Polygon([
      Point(15, PosY),
      Point(15, PosY + 8),
      Point(11, PosY + 4)]);
    Polygon([
      Point(ClientWidth - 15, PosY),
      Point(ClientWidth - 15, PosY + 8),
      Point(ClientWidth - 11, PosY + 4)]);
  end;
end;

procedure TNxMonthCalendar.RefreshMonth;
var
  R: TRect;
begin
  if not HandleAllocated then Exit;
  R := GetMonthRect;
  InflateRect(R, -15, 0);
  InvalidateRect(Handle, @R, False);
  R := GetDaysRect;
  InvalidateRect(Handle, @R, False);
end;

procedure TNxMonthCalendar.SelectDate(X, Y: Integer);
var
	l, t, col, row: Integer;
	r: TRect;
  sd: TDate;
begin
	col := (X - 14) div 17;
  row := (y - 36) div 15;
  sd := GetDateAtPos(col, row);
  if sd = SelectedDate then Exit else SelectedDate := sd;
  l := spDateStart + (col * 17);
  t := 38 + (row * 15);
  r := Rect(l, t, l + 17, t + 15);
  InvalidateRect(Handle, @FOldRect, False);
  InvalidateRect(Handle, @r, False);
end;

procedure TNxMonthCalendar.SetDate(const Value: TDate);
begin
  FDate := Value;
  FSelectedDate := Value;
  FYear := YearOf(FDate);
  FMonth := MonthOf(FDate);
  FDay := DayOf(FDate);
  RefreshMonth;
end;

procedure TNxMonthCalendar.SetDay(const Value: Word);
begin
  if FDay <> Value then
  begin
    FDay := Value;
  end;
end;

procedure TNxMonthCalendar.SetDayNames(const Value: TStrings);
begin
  FDayNames.Assign(Value);
end;

procedure TNxMonthCalendar.SetMonth(const Value: Word);
begin
  if FMonth <> Value then
  begin
    FMonth := Value;
    RefreshMonth;
  end;
end;

procedure TNxMonthCalendar.SetMonthNames(const Value: TStrings);
begin
  FMonthNames := Value;
end;

procedure TNxMonthCalendar.SetNoneCaption(const Value: WideString);
begin
  FNoneCaption := Value;
  FNoneButton.Text := FNoneCaption;
end;

procedure TNxMonthCalendar.SetPastMonth(var AYear, AMonth: Integer;
  Decrease: Boolean);
begin
	case Decrease of
  	True: if AMonth > 1 then AMonth := AMonth - 1 else
				  begin
				    AYear := AYear - 1;
				    AMonth := 12;
				  end;
    False:	if AMonth < 12 then AMonth := AMonth + 1 else
					  begin
					    AYear := AYear + 1;
					    AMonth := 1;
					  end;
  end;
end;

procedure TNxMonthCalendar.SetSelectedDate(const Value: TDate);
begin
  if FSelectedDate <> Value then
  begin
    FSelectedDate := Value;
    DoChange; { Event }
  end;
end;

procedure TNxMonthCalendar.SetShowNoneButton(const Value: Boolean);
begin
  FShowNoneButton := Value;
  FNoneButton.Visible := Value;
  if FNoneButton.Visible or (csDesigning in ComponentState)
    then FTodayButton.Left := 20
    else FTodayButton.Left := ClientWidth div 2 - FTodayButton.Width div 2;
end;

procedure TNxMonthCalendar.SetStartDay(const Value: TStartDayOfWeek);
begin
  FStartDay := Value;
  Invalidate;
end;

procedure TNxMonthCalendar.SetTodayCaption(const Value: WideString);
begin
  FTodayCaption := Value;
  FTodayButton.Text := FTodayCaption;
end;

procedure TNxMonthCalendar.SetYear(const Value: Word);
begin
  if FYear <> Value then
  begin
    FYear := Value;
    RefreshMonth;
  end;
end;

procedure TNxMonthCalendar.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

end.
