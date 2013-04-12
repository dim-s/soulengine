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

{ $Id: PHPLibrary.pas,v 7.2 10/2009 delphi32 Exp $ }

unit phpLibrary;

interface
 uses
  Windows, SysUtils, Classes,
  {$IFDEF VERSION6}
  Variants,
  {$ENDIF}
  ZendTypes, ZendAPI,
  PHPTypes,
  PHPAPI,
  phpCustomLibrary,
  phpFunctions;

type
  TPHPLibrary = class(TCustomPHPLibrary)
  published
    property LibraryName;
    property Functions;
  end;

  TDispatchProc = procedure of object;

  TDispatchObject = class
  Proc : TDispatchProc;
  end;

  TPHPSimpleLibrary = class(TCustomPHPLibrary)
  private
     FRetValue : variant;
     FParams   : TFunctionParams;
     FMethods  : TStringList;
  protected
     procedure _Execute(Sender: TObject; Parameters: TFunctionParams; var ReturnValue: Variant;
                        ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure ReturnOutputArg(AValue:variant);
    function GetInputArg(AIndex:integer):variant;
    function GetInputArgAsString(AIndex:integer):string;
    function GetInputArgAsInteger(AIndex:integer):integer;
    function GetInputArgAsBoolean(AIndex:integer):boolean;
    function GetInputArgAsFloat(AIndex:integer):double;
    function GetInputArgAsDateTime(AIndex:integer):TDateTime;
  public
    procedure RegisterMethod(AName : AnsiString; ADescription : AnsiString; AProc : TDispatchProc; AParams : array of TParamType); virtual;
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
  end;

  TPHPSystemLibrary = class(TPHPSimpleLibrary)
  protected
     {System procedures}
     procedure RoundProc;
     procedure TruncProc;
     procedure CopyProc;
     procedure PosProc;
     procedure LengthProc;
     {SysUtils procedures}
     procedure UpperCaseProc;
     procedure LowerCaseProc;
     procedure CompareStrProc;
     procedure CompareTextProc;
     procedure AnsiUpperCaseProc;
     procedure AnsiLowerCaseProc;
     procedure AnsiCompareStrProc;
     procedure AnsiCompareTextProc;
     procedure IsValidIdentProc;
     procedure IntToStrProc;
     procedure IntToHexProc;
     procedure StrToIntProc;
     procedure StrToIntDefProc;
     procedure FloatToStrProc;
     procedure FormatFloatProc;
     procedure StrToFloatProc;
     procedure EncodeDateProc;
     procedure EncodeTimeProc;
     procedure DayOfWeekProc;
     procedure DateProc;
     procedure TimeProc;
     procedure NowProc;
     procedure IncMonthProc;
     procedure IsLeapYearProc;
     procedure DateToStrProc;
     procedure TimeToStrProc;
     procedure DateTimeToStrProc;
     procedure StrToDateProc;
     procedure StrToTimeProc;
     procedure StrToDateTimeProc;
     procedure BeepProc;
     procedure RandomProc;
    public
     constructor Create(AOwner : TComponent); override;
     procedure Refresh; override;
    end;

implementation

{ TPHPSimpleLibrary }

function VarToInteger(v:variant):integer;
begin
   case VarType(v) of
      varSmallint, varInteger, varByte, varError: result:=v;
      varSingle, varDouble, varCurrency, varDate: result:=round(v);
      varBoolean: if v=true then result:=1 else result:=0;
      varString, varOleStr: result:=round(StrToFloat (v));
      varUnknown, varDispatch : result := 0;
      else
         if VarIsNull(v) then
            result := 0
         else
            result := VarAsType(v,varInteger);
   end;
end;

function VarToFloat(v:variant):double;
begin
   case VarType(v) of
    varSmallint,
    varInteger,
    varByte,
    varError,
    varSingle,
    varDouble,
    varCurrency,
    varDate:   Result:=v;
    varBoolean: if v=true then result:=1 else result:=0;
    varString,varOleStr: result:= StrToFloat(v);
    varUnknown, varDispatch : result := 0;
      else
         if VarIsNull(v) then
            result := 0
         else
            result := VarAsType(v,varDouble);
   end;
end;

function VarToBoolean(v:variant):boolean;
begin
   result:=(VarToInteger(v)<>0);
end;

procedure TPHPSimpleLibrary._Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar : TZendVariable;
  TSRMLS_DC: Pointer);
var
 ActiveFunctionName : string;
begin
  if not VarIsEmpty(FRetValue) then
   VarClear(FRetValue);
  FParams := Parameters;
  ActiveFunctionName := get_active_function_name(TSRMLS_DC);
  TDispatchObject(FMethods.Objects[FMethods.IndexOf(ActiveFunctionName)]).Proc;
  if not VarIsEmpty(FRetValue) then
   ReturnValue := FRetValue;
end;

procedure TPHPSimpleLibrary.RegisterMethod(AName: AnsiString; ADescription : AnsiString;
  AProc: TDispatchProc; AParams: array of TParamType);
var
 Func  : TPHPFunction;
 Param : TFunctionParam;
 cnt   : integer;
 O     : TDispatchObject;
begin
  Func := TPHPFunction(Functions.Add);
  Func.FunctionName := AnsiLowerCase(AName);
  Func.Description := ADescription;

  for cnt := 0 to Length(AParams) - 1 do
   begin
      Param := TFunctionparam(Func.Parameters.Add);
      Param.ParamType := AParams[cnt];
   end;

   Func.OnExecute := _Execute;

   O := TDispatchObject.Create;
   O.Proc := Aproc;

   FMethods.AddObject(AName, O);
end;

procedure TPHPSimpleLibrary.ReturnOutputArg(AValue: variant);
begin
  FRetValue := AValue;
end;

function TPHPSimpleLibrary.GetInputArg(AIndex: integer): variant;
begin
  Result := FParams[AIndex].Value;
end;

function TPHPSimpleLibrary.GetInputArgAsBoolean(AIndex: integer): boolean;
begin
  Result := VarToBoolean(GetInputArg(AIndex));
end;

function TPHPSimpleLibrary.GetInputArgAsDateTime(
  AIndex: integer): TDateTime;
begin
   Result := VarToDateTime(GetInputArg(AIndex));
end;

function TPHPSimpleLibrary.GetInputArgAsFloat(AIndex: integer): double;
begin
  Result := VarToFloat(GetInputArg(AIndex));
end;

function TPHPSimpleLibrary.GetInputArgAsInteger(AIndex: integer): integer;
begin
  Result := VarToInteger(GetInputArg(AIndex));
end;

function TPHPSimpleLibrary.GetInputArgAsString(AIndex: integer): string;
begin
  Result := VarToStr(GetInputArg(AIndex));
end;

constructor TPHPSimpleLibrary.Create(AOwner: TComponent);
begin
  inherited;
  FMethods := TStringList.Create;
end;

destructor TPHPSimpleLibrary.Destroy;
var
 cnt : integer;
begin
  for cnt := 0 to FMethods.Count - 1 do
   Fmethods.Objects[cnt].Free;
  FMethods.Free;
  inherited;
end;

procedure TPHPSystemLibrary.Refresh;
begin
  Functions.Clear;
  RegisterMethod( 'sys_UpperCase',          'Returns a copy of a string in uppercase.', UpperCaseProc, [tpString] ) ;
  RegisterMethod( 'sys_LowerCase',          'Converts an ASCII string to lowercase.', LowerCaseProc, [tpString] );
  RegisterMethod( 'sys_CompareStr',         'Compares two strings case sensitively.', CompareStrProc, [tpString, tpString] );
  RegisterMethod( 'sys_CompareText',        'Compares two strings by ordinal value without case sensitivity.', CompareTextProc, [tpString, tpString] );
  RegisterMethod( 'sys_AnsiUpperCase',      'Converts a string to upper case.', AnsiUpperCaseProc, [tpString] );
  RegisterMethod( 'sys_AnsiLowerCase',      'Returns a string that is a copy of the given string converted to lower case.', AnsiLowerCaseProc, [tpString] );
  RegisterMethod( 'sys_AnsiCompareStr',     'Compares strings based on the current Windows locale with case sensitivity.', AnsiCompareStrProc, [tpString, tpString] );
  RegisterMethod( 'sys_AnsiCompareText',    'Compares strings based on the current Windows locale without case sensitivity', AnsiCompareTextProc, [tpString, tpString] );
  RegisterMethod( 'sys_IsValidIdent',       'Tests for a valid Pascal identifier.', IsValidIdentProc, [tpString] );
  RegisterMethod( 'sys_IntToStr',           'Converts an integer to a string.', IntToStrProc, [tpInteger] );
  RegisterMethod( 'sys_IntToHex',           'Returns the hex representation of an integer.', IntToHexProc, [tpInteger, tpInteger] );
  RegisterMethod( 'sys_StrToInt',           'Converts a string that represents an integer (decimal or hex notation) to a number.', StrToIntProc, [tpString] );
  RegisterMethod( 'sys_StrToIntDef',        'Converts a string that represents an integer (decimal or hex notation) to a number.', StrToIntDefProc, [tpString, tpInteger] );
  RegisterMethod( 'sys_FloatToStr',         'Converts a floating point value to a string.', FloatToStrProc, [tpFloat] );
  RegisterMethod( 'sys_FormatFloat',        'Formats a floating point value.', FormatFloatProc, [tpString, tpFloat] );
  RegisterMethod( 'sys_StrToFloat',         'Converts a given string to a floating-point value.', StrToFloatProc, [tpString] );
  RegisterMethod( 'sys_EncodeDate',         'Returns a TDateTime value that represents a specified Year, Month, and Day.', EncodeDateProc, [tpInteger, tpInteger, tpInteger] );
  RegisterMethod( 'sys_EncodeTime',         'Returns a TDateTime value for a specified Hour, Min, Sec, and MSec.', EncodeTimeProc, [tpInteger, tpInteger, tpInteger, tpInteger] );
  RegisterMethod( 'sys_DayOfWeek',          'Returns the day of the week for a specified date.', DayOfWeekProc, [tpFloat] );
  RegisterMethod( 'sys_Date',               'Returns the current date.', DateProc, [] );
  RegisterMethod( 'sys_Time',               'Returns the current time.', TimeProc, [] );
  RegisterMethod( 'sys_Now',                'Returns the current date and time.', NowProc, [] );
  RegisterMethod( 'sys_IncMonth',           'Returns a date shifted by a specified number of months', IncMonthProc, [tpFloat, tpInteger] );
  RegisterMethod( 'sys_IsLeapYear',         'Indicates whether a specified year is a leap year.', IsLeapYearProc, [tpInteger] );
  RegisterMethod( 'sys_DateToStr',          'Converts a TDateTime value to a string.', DateToStrProc, [tpFloat] );
  RegisterMethod( 'sys_TimeToStr',          'Returns a string that represents a TDateTime value.', TimeToStrProc, [tpFloat] );
  RegisterMethod( 'sys_DateTimeToStr',      'Converts a TDateTime value to a string.', DateTimeToStrProc, [tpFloat] );
  RegisterMethod( 'sys_StrToDate',          'Converts a string to a TDate value.', StrToDateProc, [tpString] );
  RegisterMethod( 'sys_StrToTime',          'Converts a string to a TTime value.', StrToTimeProc, [tpString] );
  RegisterMethod( 'sys_StrToDateTime',      'Converts a string to a TDateTime value.',StrToDateTimeProc, [tpString] );
  RegisterMethod( 'sys_Beep',               'Generates a standard beep using the computer speaker.', BeepProc, [] );
  RegisterMethod( 'sys_Round',              'Returns the value of X rounded to the nearest whole number.', RoundProc, [tpFloat] );
  RegisterMethod( 'sys_Trunc',              'Truncates a real number to an integer.', TruncProc, [tpFloat] );
  RegisterMethod( 'sys_Copy',               'Returns a substring of a string or a segment of a dynamic array.', CopyProc, [tpString, tpInteger, tpInteger] );
  RegisterMethod( 'sys_Pos',                'Returns the index value of the first character in a specified substring that occurs in a given string.', PosProc, [tpString, tpString] );
  RegisterMethod( 'sys_Length',             'Returns the number of characters in a string or elements in an array.', LengthProc, [tpString] );
  RegisterMethod( 'sys_Random',             'Generates random numbers within a specified range.', RandomProc, [] );

  inherited;

end;

{ TPHPSystemLibrary }

procedure TPHPSystemLibrary.UpperCaseProc;
begin
   ReturnOutputArg( UpperCase( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.LowerCaseProc;
begin
   ReturnOutputArg( LowerCase( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.CompareStrProc;
begin
  ReturnOutputArg( CompareStr( GetInputArgAsString( 0 ),GetInputArgAsString( 1 ) ) );
end;

procedure TPHPSystemLibrary.CompareTextProc;
begin
   ReturnOutputArg( CompareText( GetInputArgAsString( 0 ),GetInputArgAsString( 1 ) ) );
end;

procedure TPHPSystemLibrary.AnsiUpperCaseProc;
begin
  ReturnOutputArg( AnsiUpperCase( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.AnsiLowerCaseProc;
begin
  ReturnOutputArg( AnsiLowerCase( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.AnsiCompareStrProc;
begin
  ReturnOutputArg( AnsiCompareStr( GetInputArgAsString( 0 ),GetInputArgAsString( 1 ) ) );
end;

procedure TPHPSystemLibrary.AnsiCompareTextProc;
begin
   ReturnOutputArg( AnsiCompareText( GetInputArgAsString( 0 ),GetInputArgAsString( 1 ) ) );
end;


procedure TPHPSystemLibrary.IsValidIdentProc;
begin
  ReturnOutputArg( IsValidIdent( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.IntToStrProc;
begin
  ReturnOutputArg( IntToStr( GetInputArgAsInteger( 0 ) ) );
end;

procedure TPHPSystemLibrary.IntToHexProc;
begin
  ReturnOutputArg( IntToHex( GetInputArgAsInteger( 0 ),GetInputArgAsInteger( 1 ) ) );
end;

procedure TPHPSystemLibrary.StrToIntProc;
begin
  ReturnOutputArg( StrToInt( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.StrToIntDefProc;
begin
  ReturnOutputArg( StrToIntDef( GetInputArgAsString( 0 ),GetInputArgAsInteger( 1 ) ) );
end;

procedure TPHPSystemLibrary.FloatToStrProc;
begin
  ReturnOutputArg( FloatToStr( GetInputArgAsFloat( 0 ) ) );
end;

procedure TPHPSystemLibrary.FormatFloatProc;
begin
  ReturnOutputArg( FormatFloat( GetInputArgAsString( 0 ),GetInputArgAsFloat( 1 ) ) );
end;

procedure TPHPSystemLibrary.StrToFloatProc;
begin
  ReturnOutputArg( StrToFloat( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.EncodeDateProc;
begin
  ReturnOutputArg( EncodeDate(
         GetInputArgAsInteger( 0 ),
         GetInputArgAsInteger( 1 ),
         GetInputArgAsInteger( 2 ) ) );
end;

procedure TPHPSystemLibrary.EncodeTimeProc;
begin
  ReturnOutputArg( EncodeTime(
         GetInputArgAsInteger( 0 ),
         GetInputArgAsInteger( 1 ),
         GetInputArgAsInteger( 2 ),
         GetInputArgAsInteger( 3 ) ) );
end;



procedure TPHPSystemLibrary.DayOfWeekProc;
begin
  ReturnOutputArg( DayOfWeek( GetInputArgAsDateTime( 0 ) ) );
end;

procedure TPHPSystemLibrary.DateProc;
begin
  ReturnOutputArg( Date );
end;

procedure TPHPSystemLibrary.TimeProc;
begin
  ReturnOutputArg( Time );
end;

procedure TPHPSystemLibrary.NowProc;
begin
  ReturnOutputArg( Now );
end;

procedure TPHPSystemLibrary.IncMonthProc;
begin
  ReturnOutputArg( IncMonth( GetInputArgAsDateTime( 0 ),GetInputArgAsInteger( 1 ) ) );
end;

procedure TPHPSystemLibrary.IsLeapYearProc;
begin
  ReturnOutputArg( IsLeapYear( GetInputArgAsInteger( 0 ) ) );
end;

procedure TPHPSystemLibrary.DateToStrProc;
begin
  ReturnOutputArg( DateToStr( GetInputArgAsDateTime( 0 ) ) );
end;

procedure TPHPSystemLibrary.TimeToStrProc;
begin
  ReturnOutputArg( TimeToStr( GetInputArgAsDateTime( 0 ) ) );
end;

procedure TPHPSystemLibrary.DateTimeToStrProc;
begin
  ReturnOutputArg( DateTimeToStr( GetInputArgAsDateTime( 0 ) ) );
end;

procedure TPHPSystemLibrary.StrToDateProc;
begin
  ReturnOutputArg( StrToDate( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.StrToTimeProc;
begin
  ReturnOutputArg( StrToTime( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.StrToDateTimeProc;
begin
  ReturnOutputArg( StrToDateTime( GetInputArgAsString( 0 ) ) );
end;


procedure TPHPSystemLibrary.BeepProc;
begin
  Beep;
end;


procedure TPHPSystemLibrary.RoundProc;
begin
  ReturnOutputArg( Integer(Round( GetInputArgAsFloat( 0 ) )) );
end;

procedure TPHPSystemLibrary.TruncProc;
begin
  ReturnOutputArg( Integer(Trunc( GetInputArgAsFloat( 0 ) )) );
end;

procedure TPHPSystemLibrary.CopyProc;
begin
  ReturnOutputArg( Copy(
         GetInputArgAsString( 0 ),
         GetInputArgAsInteger( 1 ),
         GetInputArgAsInteger( 2 ) ) );
end;


procedure TPHPSystemLibrary.PosProc;
begin
  ReturnOutputArg( pos(GetInputArgAsString( 0 ),GetInputArgAsString( 1 )) );
end;

procedure TPHPSystemLibrary.LengthProc;
begin
  ReturnOutputArg( Length( GetInputArgAsString( 0 ) ) );
end;


procedure TPHPSystemLibrary.RandomProc;
begin
  ReturnOutputArg( Random );
end;


constructor TPHPSystemLibrary.Create(AOwner: TComponent);
begin
  inherited;
  LibraryName := 'delphi_system';
end;

end.