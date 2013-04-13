{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{ http://delphi32.blogspot.com                          }
{*******************************************************}

{ $Id: PHP.INC,v 7.2 10/2009 delphi32 Exp $ }

{IMPORTANT:
If you are using PHP version 4.2.x...4.3.0 please change $DEFINE PHP433 to $DEFINE PHP430
If you are using PHP version 5.0 please change $DEFINE PHP433 to $DEFINE PHP5 or remove it
If you are using PHP version 5.0.4 please add $DEFINE PHP504
If you are using PHP version 5.1.0 or higher please add $DEFINE PHP510
If you are using PHP version 5.1.1 or higher please add $DEFINE PHP511
If you are using PHP version 5.1.2 or higher please add $DEFINE PHP512
If you are using PHP version 5.2.0 or higher please add $DEFINE PHP520
IF you are using PHP version 5.3.0 or highre please add $DEFINE PHP530

Sorry for such complicated configuration, but PHP team does not keep
backward compatibility between PHP versions.
}


{.$DEFINE PHP4}
{.$DEFINE PHP430}
{.$DEFINE PHP433}
{.$DEFINE PHP435}
{.$DEFINE PHP446}

{If you are using PHP 4 please comment $DEFINE PHP5}

{PHP5 must be defined if you are using PHP5}
{$DEFINE PHP5}

{For PHP5 you have to define the subversion of PHP}
{$DEFINE PHP504}
{$DEFINE PHP510}
{$DEFINE PHP511}
{$DEFINE PHP512}
{$DEFINE PHP520}
{$DEFINE PHP530}
{$DEFINE PHP540}

{$IFDEF PHP530}
  {$DEFINE ZEND_WIN32}
  {$DEFINE PHP_COMPILER_ID}
{$ENDIF}

//Warning! You must select one of the compilers
//Look at the version of PHP you have installed
//I DO recommend to use php-5.3.0-Win32-VC6-x86, specially if you are using
//php4delphi component with php5ts.dll. If you are building PHP extensions,
//you have to define the right compiler, otherwise you would have incompatibility
//problems

{$IFDEF PHP_COMPILER_ID}
 {.$DEFINE COMPILER_VC6}
 {$DEFINE COMPILER_VC9}
{$ENDIF}

{$IFDEF PHP5}
  {$UNDEF PHP4}
  {$UNDEF PHP430}
  {$UNDEF PHP433}
  {$UNDEF PHP435}
  {$UNDEF PHP446}
{$ENDIF}


{.$DEFINE QUIET_LOAD} //Do not show error while loading php4ts.dll or php5ts.dll (depends from php version)

{.$DEFINE PHP4DELPHI_AUTOLOAD}     //Load php4ts.dll or php5ts.dll at initialization
{.$DEFINE PHP4DELPHI_AUTOUNLOAD}   // Unload php4ts.dll or php5ts.dll at finalization

{.$DEFINE PHP_DEBUG}

{$DEFINE REGISTER_COLORS} //register php constants for colors

{$IFNDEF LINUX}
 {$DEFINE ZTS}                                               {zts support}
{$ENDIF}

{$IFNDEF VER80}                                             {Delphi 1.0}
  {$DEFINE VERSION2}                                        {Delphi 2.0 and BCB 1 or higher}
{$ENDIF}

{$IFDEF VERSION2}
  {$IFNDEF VER90}                                           {Delphi 2.0}
    {$IFNDEF VER93}                                         {BCB 1.0}
      {$DEFINE VERSION3}                                    {Delphi 3.0 or BCB 3.0}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION3}
  {$IFNDEF VER100}                                          {Delphi 3}
    {$IFNDEF VER110}                                        {BCB 3}
      {$DEFINE VERSION4}                                    {Delphi 4.0 or higher}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION4}
  {$IFNDEF VER120}                                          {Delphi 4}
    {$IFNDEF VER125}                                        {BCB 4}
      {$DEFINE VERSION5}                                    {Delphi 5.0 or higher}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION5}
  {$IFNDEF VER130}                                          {Delphi 5}
    {$IFNDEF VER135}                                        {BCB 5}
      {$DEFINE VERSION6}                                    {Delphi 6.0 or higher}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION6}
  {$IFNDEF VER140}                                          {Delphi 6}
    {$IFNDEF VER145}                                        {BCB 6}
      {$DEFINE VERSION7}                                    {Delphi 7.0 or higher}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION7}
 {$IFNDEF VER150}                                           {Delphi 7}
     {$DEFINE VERSION9}                                     {Delphi 2005}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION9}
  {$IFNDEF VER170}                                          {Delphi 2005}
    {$DEFINE VERSION10}                                     {Delphi 2006}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION10}
  {$IFNDEF VER180}                                          {Delphi 2006}
    {$DEFINE VERSION11}                                     {Delphi 2007}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION11}
  {$IFNDEF VER185}                                          {Delphi 2007}
    {$DEFINE VERSION12}                                     {Delphi 2009}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION12}
  {$IFNDEF VERSION20}
    {$DEFINE VERSION13}                                     {Delphi 2010}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION6}
  {$WARN SYMBOL_PLATFORM OFF}
  {$IFDEF VERSION7}
    {$WARN UNIT_PLATFORM OFF}
    {$WARN UNSAFE_CODE OFF}
    {$WARN UNSAFE_TYPE OFF}
    {$WARN UNSAFE_CAST OFF}
    {$WARN UNIT_DEPRECATED OFF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION5}
  {$IFNDEF VERSION6}
    {$DEFINE VERSION5ONLY}
  {$ENDIF}
{$ENDIF}

{$IFDEF VERSION6}
{$A8}
{$ELSE}
{$A+}
{$ENDIF}


{$IFDEF VERSION7}
{$J+}
{$WARNINGS OFF}
{$ENDIF}
