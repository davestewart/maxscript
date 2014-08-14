@Echo OFF

rem *********************************************
rem * fontinfo.bat 12/8/2001 by Ofer Zelichover *
rem * This file is part of the getFontNames MXS *
rem *********************************************
rem * This file takes the output of ttfname     *
rem * and adds it to the TMPfontlist.txt        *
rem * file after deleting the first 4 lines     *
rem * of the output.                            *
rem *********************************************

rem Make sure we've got the needed arguments
if "%1"=="" goto NEEDARG

rem print the font file we're processing
echo %1

rem get the ttfname output into a temp file
if "%2"=="" (
        .\ttfname.exe %1 >%tmp%\fontinfo.txt
) else (
        %2\ttfname.exe %1 >%tmp%\fontinfo.txt
)

rem add seperator
type %tmp%\seperator.txt >>c:\TMPfontlist.txt

rem add the temp file minus first 4 lines to TMPfontlist.txt
for /F "skip=4 tokens=*" %%i in (%tmp%\fontinfo.txt) do echo %%i >> c:\TMPfontlist.txt

goto EXIT

:NEEDARG
echo You have to use the font name as input
echo Example: fontinfo.bat C:\WINNT\FONTS\ARIAL.TTF

:EXIT
