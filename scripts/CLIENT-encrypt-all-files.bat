@echo off
setlocal enabledelayedexpansion

set gamed=%~dp0GameDecrypted
set game=%~dp0GameEncrypted
set dec=%~dp0\..\l2encdec\l2encdec.exe

rem "print header"
echo Welcome to ProjectEDN!
echo Created by jakefahrbach

echo.

rem "last chance to pull out"
echo [CLIENT] Game file encrypter
echo The purpose of this script is to re-encrypt all files and prepare them for transfering into the client
echo This script will:
echo   - Create (or error if it already exist) the directory %game%
echo   - Copy all files from %gamed% into %game%
echo   - Get the md5 hashes of GF.dll and Exteel.exe from %1
echo   - Re-encrypt the files
echo   - Copy all of the files into %1 replacing the old ones
echo.
echo You may exit the program now or continue if you would like to perform these actions

pause

echo.
echo.

rem "check input"

echo Checking for files...
if not exist %1\System goto BadInput
    
echo Directory is correct!

echo.
echo.

rem "exit if it exists"
echo Verifying %gamed% exists...

if not exist %gamed% (
    echo Directory %gamed% does not exist. Please run CLIENT-decrypt-all-files.bat on your install directory!

    pause
    exit
)

echo Done!

echo.
echo.

rem "delete if it exists"
echo Deleting %game% if it exists...

rd /q /s %game% 2>nul

echo Done!

echo.
echo.

rem "make directory and copy files"
echo Creating %game%...

mkdir %game%

echo Copying files...

robocopy %gamed%\ %game% *.poo *.ini *.jof *.rc /s

echo Copy complete!

echo.
echo.

rem "update md5"
echo Updating MD5 hashes in version.ini...


for /f "skip=1 tokens=* delims=" %%# in ('certutil -hashfile %1\System\GF.dll MD5') do (
	if not defined md5 (
		for %%Z in (%%#) do set md5=!md5!%%Z
	)
)

echo %md5%
pause

rem "decrypt files"
echo Encrypting files...


for /R %game%\ %%x in (*.poo, *.ini, *.jof, *.rc) do %dec% -e 414 -t %%x %%xenc && (
    echo %%x encrypted successfully!
    del %%x
    ren %%xenc *%%~xx
) || (

    echo Unable to encrypt %%x. Verify you are not trying encrypt an already encrypted file!
    pause
    exit
)

echo Encryption complete!

echo.
echo.

rem "end of script"
pause
exit

rem "fail case"
:BadInput
    echo %1 does not appear to be game install directory! 
    echo Make sure the folder you use this script on contains the \System and \Mutmap directories!
    pause
    exit 