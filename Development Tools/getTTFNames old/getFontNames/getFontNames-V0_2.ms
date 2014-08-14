-- getFontNames V0.2 12/8/2001
-- By Ofer Zelichover
-- You may freely use this script. Altough I had no problems with it, use it at your OWN RISK.
--*****************************************************************************************
-- Decription:
------------------
-- This script gets the system font names and puts them in an array. it relays on an external
-- program called ttfname.exe to get the name from the ttf file, and two batch files : 
-- listfonts.bat and fontinfo.bat, to save the opening of a command window for each font.
-- The only DOS command the needs to be run is listfonts.bat. this batch creates a file in 
-- the C:\ folder called TMPfontlist.txt, this file is a sum of the modified output from 
-- the ttfname.exe. the modification is that before every new font there's a line with "New Font:"
-- and the next line is the font name (the 5th line from ttfname output).
-- 
--**************************************************************************************
-- THIS SCRIPT IS NOT FULLY TESTED, THERE ARE STILL KNOWN ISSUES WITH THE TTFNAME UTIL 
-- (IT DOESN'T GET ALL FONTS) AND THERE IS ONLY BASIC FAULT CHECKING. 
--**************************************************************************************
--
-- This is an alternative to swami's script, it only comes to solve the issue of opening multiple
-- command windows. Hopefully, swami will make a better one soon.
--------------------------------------------------------------------------------------------------
-- Installation:
-----------------
-- Put : 	getFontNames-V0_1.ms 	- anywhere.
--			ttfname.exe				\	these 3 files can go anywhere, as long as they
--			listfonts.bat			 }	all stay in the same folder, and you modify
--			fontinfo.bat			/	the cmdPath var in getFontNames fn to point to that folder.
--										the default for the 3 files is max script folder.
--********************************************************************************************

-- FUNCTION (sortCaseInsensitive)
-- 
-- This function sorts an array of strings in ascending or descending alphabetical order while ignoring case.
-- Returns "undefined" if an error occurs.
-- By default, sort is asceneding.  For descending sort, pass asc:false.
-- Sort string value is case sensitive (e.g. "Z" is BEFORE "a"!).
-- Sort #name value is NOT case sensitive (go figure!).
--
-- This function was written by swami, thanks swami

fn sortCaseInsensitive theArray asc:true =
(
	try
	(
		theArray=for arg in theArray collect (arg as name)
		sort theArray
		
		if NOT asc then
		(
			local theArrayTMP=copy theArray #noMap
			local revIdx=theArray.count
			for i = 1 to theArray.count do
			(
				theArray[revIdx]=theArrayTMP[i] as string
				revIdx-=1
			)
			theArray
		)
		else
		(		
			theArray=for arg in theArray collect (arg as string)
		)
	)
	catch(theArray=undefined)
)  -- End of sortCaseInsensitive function.

-- This is the actual function that gets the font names.
--------------------------------------------------------
fn getFontNames =
(
-- cmdPath is the path where you put the batch files: listfonts.bat & fontinfo.bat and the 
-- .exe file: ttfname.exe
-- note: DO NOT put back-slash at the end of the cmdPath. eg. "C:\\3dsmax4\\scripts"
	cmdPath = getDir #scripts
-- the cmdStr is the DOS command-line to execute. it calls a batch file called listfonts.bat
	cmdStr	=cmdPath+"\\listfonts.bat "+cmdPath 
	DOSCommand cmdStr

	local fontNames = #()  -- This is global now for debuging, should be changed later to local

	fontListFile = "c:\\TMPfontlist.txt"
	df=openFile fontListFile mode:"r"
	
	while (NOT eof df) do
	(
		if (findString (readLine df) "New Font:") != undefined then
			if (not eof df) then (
				i = filePos df
				s = readLine df
				if (findString s "New Font:") == undefined then	
					append fontNames s
				else seek df i
			)
	)

	flush df
	close df

	fontNames = sortCaseInsensitive fontNames 
	return fontNames
)  -- End of getFontNames function.

