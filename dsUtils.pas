unit dsUtils;

{$ifdef fpc}
{$mode delphi}{$H+}
{$endif}

interface

uses
  Classes, SysUtils, Dialogs, Controls, Forms, ShellAPI, ClipBrd, Windows, ShlObj,
  Graphics, GifImage, Jpeg, PNGImage, exemod,

  {$ifdef fpc}
  LCLType,
  {$endif}

  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  phpUtils,
  php4delphi;

  procedure InitializeDsUtils(PHPEngine: TPHPEngine);

  procedure clipboard_setFiles(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure clipboard_getFiles(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure clipboard_assign(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure clipboard_get(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

implementation

procedure CopyFilesToClipboard( FileList: string );
var
  DropFiles: PDropFiles;
  hGlobal: THandle;
  iLen: Integer;
begin
   iLen := Length( FileList ) + 2;
   FileList := FileList + #0#0;
   hGlobal := GlobalAlloc( GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf( TDropFiles ) + iLen );
   if ( hGlobal = 0 ) then raise Exception.Create( 'Could not allocate memory.' );
   begin
      DropFiles := GlobalLock( hGlobal );
      DropFiles^.pFiles := SizeOf( TDropFiles );
      Move( FileList[1], ( PChar( DropFiles ) + SizeOf( TDropFiles ) )^, iLen );
      GlobalUnlock( hGlobal);
      Clipboard.SetAsHandle( CF_HDROP, hGlobal );
   end;
end;

function GetFilesFromClipboard(): String;
var
  f: THandle;
  Buffer: array [0..1024] of Char;
  i, numFiles: Integer;
begin
   Clipboard.Open;
   try
      f := Clipboard.GetAsHandle( CF_HDROP ) ;
      if f <> 0 then
      begin
         numFiles := DragQueryFile( f, $FFFFFFFF, nil, 0 ) ;

         for i := 0 to numFiles-1 do
         begin
            Buffer[0] := #0;
            DragQueryFile( f, i, Buffer, SizeOf( Buffer ) ) ;
            if i <> 0 then
              Result := Result + #13#10;

            Result := Result + Buffer;
         end;
      end;
   finally
      Clipboard.Close;
   end;
end;

procedure clipboard_setFiles;
  var p: pzval_array;
  FileList: String;
  arr: PHashTable;
  tmp: ^ppzval;
   i, cnt: integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_ex(ht, p);

  FileList := '';
  if p[0]^._type = IS_ARRAY then
  begin
     arr := p[0]^.value.ht;
     cnt := zend_hash_num_elements(arr);
     New(tmp);
     for i := 0 to cnt - 1 do
     begin
         zend_hash_index_find(arr, i, tmp);
         if Z_STRLEN(tmp^^) = 0 then
          Continue;

        if i = 0 then
            FileList := FileList + (Z_STRVAL(tmp^^))
        else
            FileList := FileList + #0 + (Z_STRVAL(tmp^^));
     end;
     Dispose(tmp);


     CopyFilesToClipboard( FileList );
  end else
     CopyFilesToClipboard( Z_STRVAL(p[0]^) );

  dispose_pzval_array(p);
end;


procedure clipboard_getFiles;
  var
  FileList: TStrings;
  i: integer;
begin
  FileList := TStringList.Create;
  FileList.Text := GetFilesFromClipboard;

  _array_init( return_value, nil, 0 );
  for i := 0 to FileList.Count - 1 do
    add_index_stringl(return_value, i, PAnsiChar(FileList[i]), Length(FileList[i]), 1);

  FileList.Free;
end;


procedure clipboard_assign;
  var p: pzval_array;
  format: String;
  M: TMemoryStream;
  PNG: TPNGObject;
  JPG: TJPEGImage;
  GIF: TGIFImage;
  Pic: TPicture;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_ex(ht, p);

if (ht > 1) and (p[1]^._type <> IS_NULL) then
begin
  Pic := TPicture.Create;
  M := TMemoryStream.Create;
  format := LowerCase(Z_STRVAL(p[1]^));

  try

    String2Stream( Z_STRVAL(p[0]^), M );
  if ( format = 'png' )  then
  begin
       PNG := TPNGObject.Create;
       with PNG do
       begin
           LoadFromStream( M );
           Pic.Assign(PNG);

       end;
       PNG.Free;
  end
  else if ( (format = 'jpeg') or (format = 'jpg') ) then
  begin
       JPG := TJPEGImage.Create;
       with JPG do
       begin
           LoadFromStream( M );
           Pic.Assign(JPG);
       end;
       JPG.Free;
  end
  else if ( format = 'gif' ) then
  begin
       GIF := TGIFImage.Create;
       with GIF do
       begin
           LoadFromStream( M );
           Pic.Assign(GIF);
       end;
       GIF.Free;
  end
  else if ( format = 'ico' ) then
       Pic.Icon.LoadFromStream( M )
  else if ( format = 'bmp' ) then
       Pic.Bitmap.LoadFromStream( M );

       Clipboard.Assign( Pic );
  finally
     M.Free;
     Pic.Free;
  end;

end else
  Clipboard.Assign( TObject(Z_LVAL(p[0]^)) as TPersistent );
  dispose_pzval_array(p);
end;

procedure clipboard_get;
begin
   ZVAL_LONG(return_value, Integer(Clipboard));
end;


procedure InitializeDsUtils(PHPEngine: TPHPEngine);
begin
  PHPEngine.AddFunction('clipboard_setFiles', @clipboard_setFiles);
  PHPEngine.AddFunction('clipboard_getFiles', @clipboard_getFiles);
  PHPEngine.AddFunction('clipboard_assign', @clipboard_assign);
  PHPEngine.AddFunction('clipboard_get', @clipboard_get);
end;




end.

