@Echo OFF

rem **********************************************
rem * listfonts.bat 12/8/2001 by Ofer Zelichover *
rem * This file is part of the getFontNames MXS  *
rem **********************************************
rem * This file goes over the files in the       *
rem * system fonts folder, and for each one, it  *
rem * runs fontinfo.bat, to add that font info   *
rem * to TMPfontlist.txt.                        *
rem **********************************************

cls

@echo Getting system fonts, please wait...

rem create some temp files.
@echo off> c:\TMPfontlist.txt
echo New Font: >%tmp%\seperator.txt

rem check if there was an input to the batch and start the loop
if "%1"=="" (
        for %%f in (%SystemRoot%\fonts\*.ttf) do call .\fontinfo.bat %%f .
        ) else (
        for %%f in (%SystemRoot%\fonts\*.ttf) do call %1\fontinfo.bat %%f %1
        )

rem Clean the mess we've left behind...
del %tmp%\fontlist.cpy
del %tmp%\fontinfo.txt
del %tmp%\seperator.txt
