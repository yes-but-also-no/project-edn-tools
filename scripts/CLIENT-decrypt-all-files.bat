@echo off
setlocal enabledelayedexpansion

set game=%~dp0GameDecrypted
set dec=%~dp0\..\l2encdec\l2encdec.exe

rem "build exclusion list"
for /f "usebackq tokens=*" %%D in (%~dp0\excluded-files.txt) do (
    set exclusions=!exclusions! "%%D"
)

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

robocopy %1\ %game% *.poo *.ini *.jof *.rc /s /xf !exclusions!

echo Copy complete!

echo.
echo.

rem "decrypt files"
echo Decrypting files...


for /R %game%\ %%x in (*.poo, *.ini, *.jof, *.rc) do %dec% -l -t %%x %%xdec && (
    echo %%x decrypted successfully!
    del %%x
    ren %%xdec *%%~xx
) || (
    echo %%x failed. Trying again with -d ...
    %dec% -d -t %%x %%xdec && (
        echo %%x decrypted successfully!
        del %%x
        ren %%xdec *%%~xx
    ) || (
        echo Unable to decrypt %%x with -d or -l! Verify you are not trying decrypt an already decrypted file!
        pause
        exit
    )
)

echo Decryption complete!

echo.
echo.

echo Script has completed successfully! The output files have been placed in %game%.
echo Feel free to modify them as you see with and run CLIENT-encrypt-all-files.bat to re-encrypt them!

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