                     PHP4Delphi library                       
PHP - Delphi interface and PHP extensions development framework                  

{ $Id: readme.txt,v 7.2 10/2009 delphi32 Exp $ } 

PHP4Delphi is a Delphi interface to PHP for Delphi 5, 6, 7, Delphi 2005 - Delphi 2010

PHP4Delphi consists of 3 big subprojects:

1. PHP scripting (using PHP as a scripting language in Delphi applications)
PHP4Delphi allows to execute the PHP scripts within the Delphi program using 
TpsvPHP component directly without a WebServer. 
It is a PHP extension that enables you to write client-side GUI applications. 
One of the goals behind it was to prove that PHP is a capable general-purpose scripting 
language that is suited for more than just Web applications. 
It is used by "Delphi for PHP" from CodeGear.

2. PHP extensions development framework (using Delphi to extend PHP functionality)
Visual Development Framework gives possibility to create custom PHP
Extensions using Delphi. 
PHP extension, in the most basic of terms, is a set of instructions that is
designed to add functionality to PHP.

3. PHP4Applications (integrate PHP in any application)
Supports C, C++, Visual Basic, VBA, C#, Delphi, Delphi .NET, Visual Basic .NET etc. 


More detail information available in php4Delphi manual php4Delphi.pdf


This is a source-only release of php4Delphi. It includes
design-time and run-time packages for Delphi 5 through Delphi 2010.



History:

7.2 Oct 2009

* Compatible with Delphi 2010
* Compatible with PHP 5.2.11
* Compatible with PHP 5.3.0 (VC6 and VC9 editions : see PHP.INC for more details)

7.1 Oct 2008

* Compatible with Delphi 2009

7.0 Apr 2007

* Compatible with Delphi 2007
* Compatible with PHP 5.2.1
* Compatible with PHP 4.4.6
* Thread safe TpsvPHP component
* New component TPHPEngine introduced
* RunCode method reimplemented to solve "black horror" of pipes.
* Not fully compatible with previous version due to multithreading, but migration is easy.

6.2 Feb 2006

* Compatible with PHP 5.2.0
* Compatible with Delphi 2006
* Compatible with PHP 5.1.1
* Compatible with PHP 5.1.2
* Code reorganized, some crap was removed
* Added headers support (Michael Maroszek)
* New demo projects
* PHP4Applications revisited

6.1

* Compatible with PHP 5.0.4
* Compatible with PHP 5.1.0b3
* Compatible with Delphi 2005

6.0

* Translated Zend II API
* New PHP Object Model support
* PHP classes support for PHP4 and PHP5
* New demo projects
* TPHPClass component compatible with PHP4 and PHP5
* Added new property DLLFolder to psvPHP component
* New component PHPSystemLibrary

5.5 fix 1

* New property RegisterGlobals (boolean) added to psvPHP component
* New property MaxExecutionTime (integer) added to psvPHP component - Maximum execution time of each script, in seconds
* New property MaxInputTime (integer) added to psvPHP component - Maximum amount of time each script may spend parsing request data
* New property SafeMode (boolean) added to psvPHP component
* New property SafeModeGid (boolean) added to psvPHP component -  When safe_mode is on, UID/GID checks are bypassed when
  including files from this directory and its subdirectories. (directory must also be in include_path or full path must
  be used when including)
* Memory leak fixed in phpModules unit
* php_class demo project errors fixed
* psvPHP can load now PHP modules using dl() function

5.5

* New component TPHPClass added (only for PHP 4)
* Added support of PHP 5
* Improved speed of unloading of the PHP extensions under Apache 
* Decreased size of the compiled modules (based on API only and developed using Visual FrameWork)
* ZendAPI unit is splitted to ZendAPI and ZendTypes units
* PHPAPI unit is splitted to  PHPAPI and PHPTypes units
* New version of php4App - php4Applications subproject. 
  php4Applications allows to use php scripts in VB, C, C++, etc applications.
  Demo projects for Delphi, VC and MS Word included.
* New property UseDelimiters added to TpsvPHP component. If UseDelimiters = true (by default) the
  syntax of RunCode method parameter ACode should include standard script delimiters "<?" and "?>"
  to make RunCode and Execute method compatible.
* New parameters for OnScriptError event (error type, file name and line number)

5.4

* Minor bugs fixed
* Documentation improved 
* New property IniPath (folder where php.ini located) added to TpsvPHP component
* New functions translated in ZendAPI unit

5.3
* Added new public property ExecuteMethod to psvPHP component. 
  if ExecuteMethod is emGet, psvPHP receives variables as $_GET["variable"],
  if ExecuteMethod is emServer (default), psvPHP receives variables as $variable.
  Can be used to debug real PHP scripts with GET parameters.
* Added possibility to access published property of Delphi components from PHP
* Fixed problem with loading of PHP extension compiled wihout PHP4DELPHI_AUTOLOAD
  option.

5.2
* Added dynamic attachement of all exported functions from php4ts.dll
  in PHPAPI.pas
* New function for safe dynamic functions linking PHPStubInit and ZendStubInit
  This functions can be used if you are planning to work with beta-version of PHP,
  for example
* New unit zend_dynamic_array.pas
* New unit logos.pas

5.0.3
* Fixed bug when php function without parameters does not return value.
* New classes: TZendVariable and TZendValue in  phpFunctions.pas
* New subproject: php4App
  Using php4App you can integrate PHP not only with Delphi, but with VB, for example

5.0.2 
* Fixed problem with assembler code in ZENDAPI.pas for Delphi 7

5.0.1
* Fixed problem with number of parameters of zend_getparameters_ex function

5.0
* First version written in Delphi


1.0 - 4.0  
* php4Delphi was written in C as a DLL with simple Delphi wrapper
 

Before using php4Delphi library:

If you have no PHP installed, you have to download and 
install PHP separately. It is not included in the package.
You can download the latest version of PHP from
http://www.php.net/downloads.php

ZEND API documentation available at http://www.zend.com
PHP  API documentation available at http://www.php.net

You need to ensure that the dlls which php uses can be found. 
php4ts.dll is always used. If you are using any php extension dlls then you
will need those as well. 
To make sure that the dlls can be found, you can either copy them to the 
system directory (e.g. winnt/system32 or  windows/system).

Copy the file, php.ini-dist to your %WINDOWS% directory on
Windows 95/98 or to your %SYSTEMROOT% directory under Windows NT,
Windows 2000 or Windows XP and rename it to php.ini. Your %WINDOWS% or
%SYSTEMROOT% directory is typically:
c:\windows for Windows 95/98
c:\winnt or c:\winnt40 for NT/2000/XP servers

How to install php4Delphi library:

1. Delphi 5.x:

Uninstall previous installed version of php4Delphi Library from Delphi 5 IDE.
Remove previously compiled php4Delphi packages from your hard disk.

Select PHP version you are going to use. php4Delphi supports PHP 4.x and PHP 5.x, 
but not at the same time. You have to compile php4Delphi for selected target version of PHP.

Open PHP.INC file.
If you are using PHP5:
a) Comment (remove) PHP4 directive  {$DEFINE PHP4}
b) Uncomment (remove dot) directive {$DEFINE PHP5}
c) Save PHP.INC file

If you are using PHP4:
a) Comment (remove) PHP5 directive {$DEFINE PHP5}
b) Uncomment (remove dot) directive {$DEFINE PHP4}
c) If you are using PHP version 4.2.x...4.3.0 add {$DEFINE PHP430} and remove {$DEFINE PHP433}
   If you are using PHP version 4.3.3...4.3.x add {$DEFINE PHP433} and remove {$DEFINE PHP430}
d) Save PHP.INC file

Use "File\Open..." menu item of Delphi IDE to open php4Delphi runtime
package php4DelphiR5.dpk. In "Package..." window click "Compile" button to
compile packages php4DelphiR5.dpk. 
Put compiled BPL file into directory that is accessible through the search PATH (i.e. DOS
"PATH" environment variable; 
for example, in the Windows\System directory).

After compiling php4Delphi run-time package you must install design-time
package into the IDE.

Use "File\Open..." menu item to open design-time package php4DelphiD5.dpk.
In "Package..." window click "Compile" button to compile the package
and then click "Install" button to register php4Delphi Library 
components on the component palette. 


2. Delphi 6.x:

Uninstall previous installed version of php4Delphi Library from Delphi 6 IDE.
Remove previously compiled php4Delphi packages from your hard disk.

Select PHP version you are going to use. php4Delphi supports PHP 4.x and PHP 5.x, 
but not at the same time. You have to compile php4Delphi for selected target version of PHP.

Open PHP.INC file.
If you are using PHP5:
a) Comment (remove) PHP4 directive  {$DEFINE PHP4}
b) Uncomment (remove dot) directive {$DEFINE PHP5}
c) Save PHP.INC file

If you are using PHP4:
a) Comment (remove) PHP5 directive {$DEFINE PHP5}
b) Uncomment (remove dot) directive {$DEFINE PHP4}
c) If you are using PHP version 4.2.x...4.3.0 add {$DEFINE PHP430} and remove {$DEFINE PHP433}
   If you are using PHP version 4.3.3...4.3.x add {$DEFINE PHP433} and remove {$DEFINE PHP430}
d) Save PHP.INC file

Use "File\Open..." menu item of Delphi IDE to open php4Delphi runtime
package php4DelphiR6.dpk. In "Package..." window click "Compile" button to
compile packages php4DelphiR6. 
Put compiled BPL file into directory that is accessible through the search PATH (i.e. DOS
"PATH" environment variable; 
for example, in the Windows\System directory).

After compiling php4Delphi run-time package you must install design-time
package into the IDE.

Use "File\Open..." menu item to open design-time package php4DelphiD6.dpk.
In "Package..." window click "Compile" button to compile the package
and then click "Install" button to register php4Delphi Library 
components on the component palette. 

3. Delphi 7.x:

Uninstall previous installed version of php4Delphi Library from Delphi 7 IDE.
Remove previously compiled php4Delphi packages from your hard disk.

Select PHP version you are going to use. php4Delphi supports PHP 4.x and PHP 5.x, 
but not at the same time. You have to compile php4Delphi for selected target version of PHP.

Open PHP.INC file.
If you are using PHP5:
a) Comment (remove) PHP4 directive  {$DEFINE PHP4}
b) Uncomment (remove dot) directive {$DEFINE PHP5}
c) Save PHP.INC file

If you are using PHP4:
a) Comment (remove) PHP5 directive {$DEFINE PHP5}
b) Uncomment (remove dot) directive {$DEFINE PHP4}
c) If you are using PHP version 4.2.x...4.3.0 add {$DEFINE PHP430} and remove {$DEFINE PHP433}
   If you are using PHP version 4.3.3...4.3.x add {$DEFINE PHP433} and remove {$DEFINE PHP430}
d) Save PHP.INC file

Use "File\Open..." menu item of Delphi IDE to open php4Delphi runtime
package php4DelphiR7.dpk. In "Package..." window click "Compile" button to
compile packages php4DelphiR7.dpk. 
Put compiled BPL file into directory that is accessible through the search PATH (i.e. DOS
"PATH" environment variable; 
for example, in the Windows\System directory).

After compiling php4Delphi run-time package you must install design-time
package into the IDE.

Use "File\Open..." menu item to open design-time package php4DelphiD7.dpk
In "Package..." window click "Compile" button to compile the package
and then click "Install" button to register php4Delphi Library 
components on the component palette. 


4. Delphi 2005:

Uninstall previous installed version of php4Delphi Library from Delphi 2005 IDE.
Remove previously compiled php4Delphi packages from your hard disk.

Select PHP version you are going to use. php4Delphi supports PHP 4.x and PHP 5.x, 
but not at the same time. You have to compile php4Delphi for selected target version of PHP.

Open PHP.INC file.
If you are using PHP5:
a) Comment (remove) PHP4 directive  {$DEFINE PHP4}
b) Uncomment (remove dot) directive {$DEFINE PHP5}
c) Save PHP.INC file

If you are using PHP4:
a) Comment (remove) PHP5 directive {$DEFINE PHP5}
b) Uncomment (remove dot) directive {$DEFINE PHP4}
c) If you are using PHP version 4.2.x...4.3.0 add {$DEFINE PHP430} and remove {$DEFINE PHP433}
   If you are using PHP version 4.3.3...4.3.x add {$DEFINE PHP433} and remove {$DEFINE PHP430}
d) Save PHP.INC file

Use "File\Open..." menu item of Delphi IDE to open php4Delphi runtime
package php4DelphiR2005.dpk. In "Package..." window click "Compile" button to
compile packages php4DelphiR2005.dpk. 
Put compiled BPL file into directory that is accessible through the search PATH (i.e. DOS
"PATH" environment variable; 
for example, in the Windows\System directory).

After compiling php4Delphi run-time package you must install design-time
package into the IDE.

Use "File\Open..." menu item to open design-time package php4DelphiD2005.dpk
In "Package..." window click "Compile" button to compile the package
and then click "Install" button to register php4Delphi Library 
components on the component palette. 



5. Delphi 2006:

Uninstall previous installed version of php4Delphi Library from Delphi 2006 IDE.
Remove previously compiled php4Delphi packages from your hard disk.

Select PHP version you are going to use. php4Delphi supports PHP 4.x and PHP 5.x, 
but not at the same time. You have to compile php4Delphi for selected target version of PHP.

Open PHP.INC file.
If you are using PHP5:
a) Comment (remove) PHP4 directive  {$DEFINE PHP4}
b) Uncomment (remove dot) directive {$DEFINE PHP5}
c) Save PHP.INC file

If you are using PHP4:
a) Comment (remove) PHP5 directive {$DEFINE PHP5}
b) Uncomment (remove dot) directive {$DEFINE PHP4}
c) If you are using PHP version 4.2.x...4.3.0 add {$DEFINE PHP430} and remove {$DEFINE PHP433}
   If you are using PHP version 4.3.3...4.3.x add {$DEFINE PHP433} and remove {$DEFINE PHP430}
d) Save PHP.INC file

Use "File\Open..." menu item of Delphi IDE to open php4Delphi runtime
package php4DelphiR2006.dpk. In "Package..." window click "Compile" button to
compile packages php4DelphiR2006.dpk. 
Put compiled BPL file into directory that is accessible through the search PATH (i.e. DOS
"PATH" environment variable; 
for example, in the Windows\System directory).

After compiling php4Delphi run-time package you must install design-time
package into the IDE.

Use "File\Open..." menu item to open design-time package php4DelphiD2006.dpk
In "Package..." window click "Compile" button to compile the package
and then click "Install" button to register php4Delphi Library 
components on the component palette. 


6. Delphi 2007:

Uninstall previous installed version of php4Delphi Library from Delphi 2007 IDE.
Remove previously compiled php4Delphi packages from your hard disk.

Select PHP version you are going to use. php4Delphi supports PHP 4.x and PHP 5.x, 
but not at the same time. You have to compile php4Delphi for selected target version of PHP.

Open PHP.INC file.
If you are using PHP5:
a) Comment (remove) PHP4 directive  {$DEFINE PHP4}
b) Uncomment (remove dot) directive {$DEFINE PHP5}
c) Save PHP.INC file

If you are using PHP4:
a) Comment (remove) PHP5 directive {$DEFINE PHP5}
b) Uncomment (remove dot) directive {$DEFINE PHP4}
c) If you are using PHP version 4.2.x...4.3.0 add {$DEFINE PHP430} and remove {$DEFINE PHP433}
   If you are using PHP version 4.3.3...4.3.x add {$DEFINE PHP433} and remove {$DEFINE PHP430}
d) Save PHP.INC file

Use "File\Open..." menu item of Delphi IDE to open php4Delphi runtime
package php4DelphiR2007.dpk. In "Package..." window click "Compile" button to
compile packages php4DelphiR2007.dpk. 
Put compiled BPL file into directory that is accessible through the search PATH (i.e. DOS
"PATH" environment variable; 
for example, in the Windows\System directory).

After compiling php4Delphi run-time package you must install design-time
package into the IDE.

Use "File\Open..." menu item to open design-time package php4DelphiD2007.dpk
In "Package..." window click "Compile" button to compile the package
and then click "Install" button to register php4Delphi Library 
components on the component palette. 


Since this is a freeware you are strongly encouraged to look 
at the source code and improve on the components if you want to. 
Of course I would appreciate it if you would send me back the 
changes and bug fixes you have made. 

For more information on the PHP Group and the PHP project,
please see <http://www.php.net>.


PHP4Delphi forum
http://sourceforge.net/forum/forum.php?forum_id=324242

Author:                                              
Serhiy Perevoznyk                                     
Belgium
serge_perevoznyk@hotmail.com
http://users.telenet.be/ws36637
http://delphi32.blogspot.com


