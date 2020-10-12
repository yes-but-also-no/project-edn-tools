@echo off

set dd=%~dp0\..\dd\dd.exe
set patcher=%~dp0\..\l2encdec\patcher.exe
set patch=%~dp0\patch.bin

rem "print header"
echo Welcome to ProjectEDN!
echo Created by jakefahrbach

echo.

rem "last chance to pull out"
echo [CLIENT] Game guard removal
echo The purpose of this script is to remove game guard from the game binary
echo This script will:
echo   - Create a backup (destroying if it exists) of the game file %1
echo   - Patch the game guard loading instruction
echo   - This will ONLY work on 2.2.4.26301. Other versions must be patched by hand
echo.
echo You may exit the program now or continue if you would like to perform these actions

pause

echo.
echo.

rem "check input"

echo Checking for that the file is correct...
if not %~n1 == Exteel goto BadInput
    
echo File is correct!

echo.
echo.

rem "make directory and copy files"
echo Making backup file: %~n1.bak...

copy %1 "%CD%\%~n1.bak"

echo Backup complete!

echo.
echo.

rem "patch key"
echo Patching exe encryption key...

cd %~dp1

%patcher% -n -x Exteel.exe -t 

rd /q /s backup 2>nul

cd %~dp0

echo Patch complete!

echo.
echo.

rem "patch file"
echo Patching exe gameguard...

%dd% if=%patch% of=%1 bs=1 seek=74485 count=6 conv=notrunc

echo Patch complete!

echo.
echo.

echo Script has completed successfully! The output files if %1.
echo Please be sure to test the completed patch!

echo.
echo.

rem "end of script"
pause
exit

rem "fail case"
:BadInput
    echo %1 does not appear to be the game binary! 
    echo Make sure you use this on the game binary!
    pause
    exit 