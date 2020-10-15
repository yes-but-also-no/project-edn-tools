@echo off

set config=%~dp0Config
set dec=%~dp0\..\l2encdec\l2encdec.exe

rem "print header"
echo Welcome to ProjectEDN!
echo Created by jakefahrbach

echo.

rem "last chance to pull out"
echo [SERVER] Map and Poo file decrypter
echo The purpose of this script is to quick start a new server
echo This script will:
echo   - Create (destroying if it exists) the directory %config%
echo   - Copy all map and config files from %1 into %config%
echo   - Decrypt the *.poo files and rename them to .csv
echo.
echo You may exit the program now or continue if you would like to perform these actions

pause

echo.
echo.

rem "check input"

echo Checking for files...
if not exist %1\Maps goto BadInput
if not exist %1\Mutmap goto BadInput
    
echo Directory is correct!

echo.
echo.

rem "delete if it exists"
echo Deleting %config% if it exists...

rd /q /s %config% 2>nul

echo Done!

echo.
echo.

rem "make directory and copy files"
echo Creating %config%...

mkdir %config%
mkdir %config%\Maps
mkdir %config%\Poo

echo Copying files...

xcopy /s %1\Maps\*.map %config%\Maps
for /R %1\Mutmap %%f in (*.poo) do copy %%f %config%\Poo

echo Copy complete!

echo.
echo.

rem "decrypt poo files"
echo Decrypting poo files...


for /R %config%\Poo %%x in (*.poo) do %dec% -l -t %%x %config%\Poo\%%~nx.csv && (
    echo %%x decrypted successfully!
) || (
    echo %%x failed. Trying again with -d ...
    %dec% -d -t %%x %config%\Poo\%%~nx.csv && (
        echo %%x decrypted successfully!
    ) || (
        echo Unable to decrypt %%x with -d or -l! Verify you are not trying decrypt an already decrypted file!
        pause
        exit
    )
)

echo Decryption complete!

echo.
echo.

rem "rename files and remove originals"
echo Cleaning up...

for /R %config%\Poo %%x in (*.poo) do del %%x

echo Cleanup complete!

echo.
echo.

echo Script has completed successfully! The output files have been placed in %config%.
echo Please copy these files to the Config\ directory of your server.

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