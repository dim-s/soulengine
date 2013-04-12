{*******************************************************}
{                   PHP4Applications                    }
{                                                       }
{       Delphi interface for PHP4Applications           }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{*******************************************************}

unit php4AppIntf;

interface

function  InitRequest : integer; stdcall;
procedure DoneRequest(RequestID : integer); stdcall;
procedure RegisterVariable(RequestID : integer; AName : PAnsiChar; AValue : PAnsiChar); stdcall;
function  ExecutePHP(RequestID : integer; FileName : PAnsiChar) : integer; stdcall;
function  ExecuteCode(RequestID : integer; ACode : PAnsiChar) : integer; stdcall;
function  GetResultText(RequestID : integer; Buffer : PAnsiChar; BufLen : integer) : integer; stdcall;
function  GetVariable(RequestID : integer; AName : PAnsiChar; Buffer : PAnsiChar; BufLen : integer) : integer; stdcall;
procedure SaveToFile(RequestID : integer; AFileName : PAnsiChar); stdcall;
function  GetVariableSize(RequestID : integer; AName : PAnsiChar) : integer; stdcall;
function  GetResultBufferSize(RequestID : integer) : integer; stdcall;

implementation

function InitRequest; external 'php4app.dll';
procedure DoneRequest; external 'php4app.dll';
procedure RegisterVariable; external 'php4app.dll';
function ExecutePHP; external 'php4app.dll';
function ExecuteCode; external 'php4app.dll';
function GetResultText; external 'php4app.dll';
function GetVariable; external 'php4app.dll';
procedure SaveToFile; external  'php4app.dll';
function  GetVariableSize; external 'php4app.dll';
function GetResultBufferSize; external 'php4app.dll';

end.