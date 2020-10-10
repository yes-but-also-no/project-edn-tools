@echo off

set game=%~dp0GameDecrypted
set dec=%~dp0\..\l2encdec\l2encdec.exe

rem "print header"
echo Welcome to ProjectEDN!
echo Created by jakefahrbach

echo.

rem "last chance to pull out"
echo [CLIENT] Game file decrypter
echo The purpose of this script is to decrypt all the game files for modding or running the client
echo This script will:
echo   - Create (or error if it already exist) the directory %game%
echo   - Copy all encrypted files from %1 into %game%
echo   - Decrypt the files
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
echo Verifying %game% does not exist...

if exist %game% (
    echo Directory %game% already exists! If you really want to decrypt the client again, please delete or move this directory.

    pause
    exit
)

echo Done!

echo.
echo.

rem "make directory and copy files"
echo Creating %game%...

mkdir %game%

echo Copying files...

xcopy /s /h /c /exclude:%~dp0\excluded-files.txt %1\*.poo %game%
xcopy /s /h /c /exclude:%~dp0\excluded-files.txt %1\*.ini %game%
xcopy /s /h /c /exclude:%~dp0\excluded-files.txt %1\*.rc %game%
xcopy /s /h /c /exclude:%~dp0\excluded-files.txt %1\*.jof %game%

echo Copy complete!

echo.
echo.

rem "end of script"
pause
exit

rem "fail case"
:BadInput
    echo %1 does not appear to be game install directory! 
    echo Make sure the folder you use this script on contains the \Maps and \Mutmap directories!
    pause
    exit 