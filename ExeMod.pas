unit ExeMod;
{

}

interface

uses
 Windows, SysUtils, Classes, Forms, ShellAPI,
 Dialogs, TypInfo, ZLib, ZLibConst, QStrings;

  type
  TExeStream = class(TObject)
  private
    FName:String;
    FFileName: String;
    function GetACount:Integer;
    procedure SetFileName(const Value: String);
  public
    constructor Create(FileName:String);
    destructor Destroy;
    procedure ReadData;

    procedure AddStringToExe(Alias,Source:String);
    procedure AddComponentToExe(Alias: String; OBJ: TComponent);
    procedure AddStreamToExe(Alias:String; Stream:TStream);
    procedure AddFileToExe(Alias,FileName:String);

    procedure AddFromStream(AName: string; AStream: TStream);
    procedure AddFromFile(AName, AFileName: string);
    procedure AddFromStrings(AName: string; AStrings: TStrings);
    procedure AddFromString(AName,S: String);

    procedure AttachToExe(ExeName: String);
    procedure ExtractFromExe(ExeName: String);

    function IndexOf(Name: String): Integer;

    procedure ExtractToFile(Alias,FileName:String);
    procedure ExtractToStream(Alias:String; Stream:TMemoryStream);
    procedure ExtractToList(Alias:String; List:TStrings);
    procedure ExtractToStrings(Alias:String; List:TStrings);
    procedure ExtractToString(const Alias:String; var Source: String); overload;
    function ExtractToString(AName: String): String; overload;
    procedure EraseAlias(Alias:String);
    procedure SaveAsExe(FileName:String);
    property FileName:String read FFileName write SetFileName;
    property AliasCount:Integer read GetACount;
  end;



var
 Exe: string;
 _MainExeName: String;

procedure CompressStream(Stream: TStream;
compressionRate : TCompressionLevel); overload;
procedure CompressStream( aSource, aTarget : TStream;
compressionRate : TCompressionLevel ); overload;
procedure DecompressStream(aSource, aTarget: TStream);

function Stream2String(b: TStream): String; overload;
procedure Stream2String(b: TStream; var a: String); overload;
procedure String2Stream(a: String; b: TMemoryStream);
procedure Stream2Exe(TempStream: TMemoryStream);
procedure String2File(String2BeSaved, FileName: string);
procedure Delay(ms: longint);
function  WinDrv: char;
function  File2String(FileName: string): string;


implementation


procedure CompressStream( aSource, aTarget : TStream;
compressionRate : TCompressionLevel ); overload;
var comprStream : TCompressionStream; 
begin 
   // compression level : (clNone, clFastest, clDefault, clMax) 
   comprStream := TCompressionStream.Create( compressionRate, aTarget ); 
  try 
   comprStream.CopyFrom( aSource, aSource.Size );
   comprStream.CompressionRate; 
  finally 
   comprStream.Free; 
  End; 
End;

procedure CompressStream(Stream: TStream;
compressionRate : TCompressionLevel); overload;
 Var
 TG: TMemoryStream;
begin
 TG := TMemoryStream.Create;
 CompressStream(Stream,TG,compressionRate);
 Stream.Free;
 Stream := TStream.Create;
 Stream.CopyFrom(TG,TG.Size);
 TG.Free;
end;

procedure DecompressStream(aSource, aTarget: TStream);
var decompStream : TDecompressionStream; 
           nRead : Integer; 
          buffer : array[0..1023] of Char; 
begin 
   decompStream := TDecompressionStream.Create( aSource ); 
  try 
    repeat 
      nRead:=decompStream.Read( buffer, 1024 ); 
      aTarget.Write( buffer, nRead ); 
    Until nRead < 1024; 
  finally 
   decompStream.Free; 
  End; 
End; 

procedure Delay(ms: longint);
var
 TheTime: LongInt;
begin
 TheTime := GetTickCount + ms;
 while GetTickCount < TheTime do
   Application.ProcessMessages;
end;

function  WinDrv: char;
var
  WinDir : String;
  n      : Integer;
begin
  SetLength(WinDir,256);
  n := GetWindowsDirectory(PChar(WinDir),256);
  SetLength(WinDir,n);
  Result := WinDir[1];
end;

procedure String2File(String2BeSaved, FileName: string);
var
 MyStream: TMemoryStream;
begin
 if String2BeSaved = '' then exit;
 SetCurrentDir(ExtractFilePath(_MainExeName));
 MyStream := TMemoryStream.Create;
 try
   MyStream.WriteBuffer(Pointer(String2BeSaved)^, Length(String2BeSaved));

   MyStream.SaveToFile(FileName);
 finally
   MyStream.Free;
 end;
end;

function File2String(FileName: string): string;
var
 MyStream: TMemoryStream;
 MyString: string;
begin
 MyStream := TMemoryStream.Create;
 try
   MyStream.LoadFromFile(FileName);
   MyStream.Position := 0;
   SetLength(MyString, MyStream.Size);
   MyStream.ReadBuffer(Pointer(MyString)^, MyStream.Size);
 finally
   MyStream.Free;
 end;
 Result := MyString;
end;

procedure String2Stream(a: String; b: TMemoryStream);
begin
b.Position := 0;
b.WriteBuffer(Pointer(a)^,Length(a));
b.Position := 0;
end;


procedure Stream2String(b: TStream; var a: String); overload;
begin
b.Position := 0;
SetLength(a,b.Size);
b.ReadBuffer(Pointer(a)^,b.Size);
b.Position := 0;
end;

function Stream2String(b: TStream): String; overload;
begin
 Stream2String(B,Result);
end;

procedure AlterExe;
begin
 if (Exe) <> '' then
 begin
   String2File(Exe, 'temp0a0.exe');
   ShellExecute(0, 'open', PChar('temp0a0.exe'),
     PChar('"'+ExtractFilename(_MainExeName)+'"'), nil, SW_SHOW);
   Application.Terminate;
 end;
end;

procedure ReadExe;
var
 ExeStream: TFileStream;
begin
 ExeStream := TFileStream.Create(_MainExeName, fmOpenRead
   or fmShareDenyNone);
 try
   SetLength(Exe, ExeStream.Size);
   ExeStream.ReadBuffer(Pointer(Exe)^, ExeStream.Size);
 finally
   ExeStream.Free;
 end;
end;

function  GetDemarcCount: integer;
var Count,X: Integer;
begin
Count := 0;
If Exe = '' then ReadExe;
For X := 1 to Length(Exe)-10 do
  begin
    If  (Exe[X] = 'S') and (Exe[X+1] = 'O')
    and (Exe[X+2] = '!') and (Exe[X+3] = '#')
    then
    begin
      Inc(Count);
    end;
  end;
Result := Count;
end;
//===================================================

procedure GetDemarcName(DNumber: Integer; var DName: String);
var Count,X,Y: Integer;
begin
Count := 0;
If Exe = '' then ReadExe;
For X := 1 to Length(Exe)-10 do
  begin
    If  (Exe[X] = 'S') and (Exe[X+1] = 'O')
    and (Exe[X+2] = '!') and (Exe[X+3] = '#')
    then
    begin
      Inc(Count);
      If Count = DNumber then
      begin
        Y := X+4;
        While Exe[Y] <> chr(182) do
        begin
          DName := DName+Exe[Y];
          Inc(Y);
        end;
      end;
    end;
  end;
end;
//===================================================


function  PeekExeByte(Byte2Get: Integer): byte;
Begin
If Byte2Get < 1 then Exit;
Result := byte(pointer(Hinstance+Byte2Get-1)^);
End;

function  PeekExeWord(Word2Get: Integer): word;
Begin
If Word2Get < 1 then Exit;
Result := word(pointer(Hinstance+Word2Get-1)^);
End;

procedure PeekExeString(StartByte,Count: Integer; var ReturnedStr: String);
var X: Integer;
Begin
  If StartByte < 1 then Exit;
  For X := StartByte to StartByte+Count-1 do
  begin
    ReturnedStr := ReturnedStr+(char(pointer(Hinstance+X-1)^));
  end;
End;

procedure PokeExeString(StartByte: Integer; String2Insert: String);
var X: Integer;
Begin
  If Exe = '' then ReadExe;
  If StartByte + Length(String2Insert) > Length(Exe) then Exit;
  If StartByte < 1 then Exit;
  For X := 1 to Length(String2Insert) do
  begin
    Exe[X+StartByte-1] := String2Insert[X];
  end;
end;

procedure PokeExeStringI(StartByte: Integer; String2Insert: String);
var X: Integer;
Begin
  If Exe = '' then ReadExe;
  If StartByte + Length(String2Insert) > Length(Exe) then Exit;
  If StartByte < 1 then Exit;
  For X := 1 to Length(String2Insert) do
  begin
    Exe[X+StartByte-1] := String2Insert[X];
  end;
  AlterExe;
end;

procedure PokeExeByte(Byte2set: Integer; ByteVal: Byte);
Begin
If Exe = '' then ReadExe;
If Byte2Set > Length(Exe) then Exit;
Exe[Byte2Set] := chr(ByteVal);
end;

procedure PokeExeByteI(Byte2set: Integer; ByteVal: Byte);
Begin
If Exe = '' then ReadExe;
If Byte2Set > Length(Exe) then Exit;
Exe[Byte2Set] := chr(ByteVal);
AlterExe;
end;

procedure ExtractFromExe(DemarcStr: string; var ExtractedStr: string);
var
 d, e: integer;
begin
 if Length(Exe) = 0 then ReadExe;
 if Q_PosStr(Q_UpperCase('so!#' + DemarcStr + chr(182)), Exe) > 0 then
 begin
   d := Q_PosStr(Q_UpperCase('so!#' + DemarcStr + chr(182)), Exe)
     + length(Q_UpperCase('so!#' + DemarcStr + chr(182)));

   e := Q_PosStr(Q_UpperCase('eo!#' + DemarcStr), Exe);
   ExtractedStr := Copy(Exe, d, e - d);
 end;
end;

procedure ExtractFromFile(DemarcStr: string; DataFile: string; var ExtractedStr: string);
var
 d, e: integer;
 Temp: String;
begin
 Temp := File2String(DataFile);
 if Q_PosStr(Q_UpperCase('so!#' + DemarcStr + chr(182)), Temp) > 0 then
 begin
   d := Q_PosStr(Q_UpperCase('so!#' + DemarcStr + chr(182)), Temp)
     + length(Q_UpperCase('so!#' + DemarcStr + chr(182)));
   e := Q_PosStr(Q_UpperCase('eo!#' + DemarcStr), Temp);
   ExtractedStr := Copy(Temp, d, e - d);
 end;
end;

procedure DelFromString(DemarcStr: string; var String2Change: string);
var
 a, b: string;
begin
 a := Q_UpperCase('so!#' + DemarcStr + chr(182));
 b := Q_UpperCase('eo!#' + DemarcStr);
 delete(String2Change, Q_PosStr(a, String2Change), (Q_PosStr(b, String2Change)
   + length(b) - Q_PosStr(a, String2Change)));
end;

procedure DelFromExe(DemarcStr: string);
begin
If Exe = '' then ReadExe;
DelFromString(DemarcStr,Exe);
end;

procedure DelFromFile(DemarcStr, FileName: string);
var
 MyString: string;
begin
 MyString := File2String(FileName);
 DelFromString(DemarcStr, MyString);
 String2File(MyString, FileName);
end;

procedure Add2File(DemarcStr, FileName, String2Add: string);
var
 MyString: string;
begin
 If DemarcStr = '' then Exit;
 MyString := File2String(FileName);
 MyString := MyString + Q_uppercase('so!#' + DemarcStr + chr(182)) + String2Add + Q_uppercase
   ('eo!#' + DemarcStr);
 String2File(MyString, FileName);
end;

procedure ReplaceInFile(DemarcStr, FileName, ReplacementString: string);
begin
 If DemarcStr = '' then Exit;
 DelFromFile(DemarcStr, FileName);
 Add2File(DemarcStr, FileName, ReplacementString);
end;

procedure TackOnFile(DemarcStr, FileName, File2Add: string);
var
 Mystring: string;
begin
 If DemarcStr = '' then Exit;
 MyString := File2String(File2add);
 Add2File(DemarcStr, FileName, MyString);
end;

procedure Add2String(DemarcStr, String2Add: string; var String2Alter: string);
begin
 If DemarcStr = '' then Exit;
 String2Alter := String2Alter + q_uppercase('so!#' + DemarcStr + chr(182))
   + String2Add + q_uppercase('eo!#' + DemarcStr);
end;

procedure ReplaceInString(DemarcStr, ReplacementString: string;
 var String2Alter: string);
begin
 If DemarcStr = '' then Exit;
 if q_posstr(q_uppercase('so!#' + DemarcStr + chr(182)), String2Alter) = 0 then exit;
 DelFromString(DemarcStr, String2Alter);
 Add2String(DemarcStr, ReplacementString, String2Alter);
end;

procedure ReplaceInExe(DemarcStr, ReplacementString: string);
begin
 If DemarcStr = '' then Exit;
 if q_posstr(q_uppercase('so!#' + DemarcStr + chr(182)), Exe) = 0 then exit;
 DelFromString(DemarcStr, Exe);
 Add2String(DemarcStr, ReplacementString, Exe);
end;

procedure InsOrReplaceInString(DemarcStr, ReplacementString: string;
 var String2Alter: string);
begin
 If DemarcStr = '' then Exit;
 DelFromString(DemarcStr, String2Alter);
 Add2String(DemarcStr, ReplacementString, String2Alter);
end;

procedure InsOrReplaceInExe(DemarcStr, ReplacementString: string);
begin
 If DemarcStr = '' then Exit;
 If Exe = '' Then ReadExe;
 DelFromString(DemarcStr, Exe);
 Add2String(DemarcStr, ReplacementString, Exe);
end;

procedure ExtractAndStrip(DemarcStr, FileName: string);
var
 Temp: string;
begin
 ExtractFromExe(DemarcStr, Temp);
 if Length(Temp) <> 0 then
 begin
   DelFromString(DemarcStr, Exe);
   String2File(Temp, FileName);
 end;
end;

procedure Exe2File(FileName: string);
begin
 if Exe = '' then ReadExe;
 String2File(Exe, FileName);
end;

procedure Extract2File(DemarcStr, FileName: string);
var
 MyString: string;
begin
 ExtractFromExe(DemarcStr, MyString);
 if MyString <> '' then String2File(MyString, FileName);
end;

procedure Add2Exe(DemarcStr, String2Add: string);
begin
 If DemarcStr = '' then Exit;
 if Exe = '' then readExe;
 Add2String(DemarcStr, String2Add, Exe);
end;

procedure Stream2Exe(TempStream: TMemoryStream);
begin
 SetCurrentDir(ExtractFilePath(_MainExeName));
 TempStream.SaveToFile('temp0a0.exe');
 ShellExecute(0, 'open', PChar('temp0a0.exe'),
   PChar(ExtractFilename(_MainExeName)), nil, SW_SHOW);
 Application.Terminate;
end;

procedure AddFile2Exe(DemarcStr, FileName: string);
var
 MyString: string;
begin
 If DemarcStr = '' then Exit;
 MyString := File2String(FileName);
 if Exe = '' then ReadExe;
 Add2String(DemarcStr, MyString, Exe);
end;

constructor TExeStream.Create(FileName:String);
begin
 inherited Create;
 FName := FileName;
 _MainExeName := FName;
 ReadExe;
end;

destructor TExeStream.Destroy;
begin
 Finalize(Exe);
 _MainExeName := '';
 inherited Destroy;
end;

procedure TExeStream.ReadData;
begin
 ReadExe;
end;

function TExeStream.GetACount:Integer;
begin
 Result := GetDemarcCount;
end;

procedure TExeStream.AddStringToExe(Alias,Source:String);
begin
  Add2String(Alias,Source,Exe);
end;

procedure TExeStream.AddComponentToExe(Alias: String; OBJ: TComponent);
  Var
  M: TMemoryStream;
begin
  M := TMemoryStream.Create;
  M.Position := 0;
  M.WriteComponent(OBJ);
  AddStringToExe(Alias,String(M.Memory^));
  M.Free;
end;

procedure TExeStream.AddStreamToExe(Alias:String; Stream:TStream);
begin
  Add2String(Alias,Stream2String(Stream),Exe);
end;

procedure TExeStream.AddFileToExe(Alias,FileName:String);
begin
  Add2String(Alias,File2String(FileName),Exe);
end;

procedure TExeStream.SaveAsExe(FileName:String);
begin
  Exe2File(FileName);
end;

procedure TExeStream.ExtractToString(const Alias:String; var Source:String);
begin
 ExeMod.ExtractFromExe(Alias,Source);
end;

procedure TExeStream.ExtractToFile(Alias,FileName:String);
  Var
  tmp: String;
begin
If not DirectoryExists(ExtractFileDir(FileName)) then
 ForceDirectories(ExtractFileDir(FileName));
 ExeMod.ExtractFromExe(Alias,tmp);
 String2File(tmp,FileName);
 Finalize(tmp);
end;

procedure TExeStream.ExtractToStream(Alias:String; Stream:TMemoryStream);
 Var
  tmp: String;
begin
 ExeMod.ExtractFromExe(Alias,tmp);
 String2Stream(tmp, Stream);
 Finalize(tmp);
end;

procedure TExeStream.ExtractToList(Alias:String; List:TStrings);
  Var
  S: String;
begin
ExeMod.ExtractFromExe(Alias,S);
  List.Text := S;
Finalize(S);
end;

procedure TExeStream.EraseAlias(Alias:String);
begin
  DelFromExe(Alias);
end;

procedure TExeStream.SetFileName(const Value: String);
begin
  FFileName := Value;
  _MainExeName := Value;
  ReadExe;
end;

procedure TExeStream.AddFromFile(AName, AFileName: string);
begin
 Self.AddFileToExe(AName,AFileName);
end;

procedure TExeStream.AddFromStream(AName: string; AStream: TStream);
begin
 Self.AddStreamToExe(AName,AStream);
end;

procedure TExeStream.AddFromString(AName, S: String);
begin
 Self.AddStringToExe(AName,S);
end;

procedure TExeStream.AddFromStrings(AName: string; AStrings: TStrings);
begin
 Self.AddStringToExe(AName,AStrings.Text);
end;

procedure TExeStream.AttachToExe(ExeName: String);
begin
 SaveAsExe(ExeName);
end;

procedure TExeStream.ExtractFromExe(ExeName: String);
begin
 FileName := ExeName;
 ReadExe;
end;

function TExeStream.ExtractToString(AName: String): String;
begin
  Self.ExtractToString(AName,Result);
end;

procedure TExeStream.ExtractToStrings(Alias: String; List: TStrings);
begin
 ExtractToList(Alias,List);
end;

function TExeStream.IndexOf(Name: String): Integer;
  Var
  Len: Integer;
  S: String;
begin
  Len := AliasCount;
  Name := q_uppercase(Name);
  for Result:=0 to Len-1 do
   begin
     GetDemarcName(Result,S);
      if q_uppercase(S) = Name then exit;
   end;
  Result := -1;
end;

initialization
 begin
   SetCurrentDir(ExtractFilePath(_MainExeName));
 end;

end.

