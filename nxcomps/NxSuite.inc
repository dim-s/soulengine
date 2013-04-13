//  Next Suite
//  Copyright (C) 1996-2009 by Berg
//  All rights reserved.
//
//  $id:NxSuite.inc bn

{ For Debug mode, remowe _ }
{$DEFINE _NX_DEBUG}

{$IFDEF NX_DEBUG}
  {$MESSAGE WARN 'NextSuite compiled in Debug mode. More details in NxSuite.inc file.'}
{$ENDIF}

{ For TNT Unicode Support, remowe _
  TNT controls web site: www.tntware.com/delphicontrols/unicode/ }
{$DEFINE _TNTUNICODE}

{$IFDEF TNTUNICODE}
  {$MESSAGE HINT 'TNTUnicode Controls support enabled.'}
{$ENDIF}

{ note: For TNT Unicode hints, set global variable
        HintWindowClass to TTntHintWindow }

{ Delphi 6 }
{$IFDEF VER140}
  {$DEFINE DELPHI6}
{$ENDIF}

{ Delphi 7 }
{$IFDEF VER150}
  {$DEFINE DELPHI7}
{$ENDIF}

{ Borland Delphi 2005 }
{$IFDEF VER170}
  {$DEFINE DELPHI2005}
  {$DEFINE D2005UP}
{$ENDIF}

{ Borland Developer Studio 2006 }
{$IFDEF VER180}
  {$DEFINE DELPHI2006}
  {$DEFINE D2005UP}
{$ENDIF}

{ CodeGear Delphi 2007 }
{$IFDEF VER185}
  {$DEFINE DELPHI2007}
  {$DEFINE D2005UP}
{$ENDIF}

{$IFDEF VER200}
  {$DEFINE DELPHI2009}
{$ENDIF}
