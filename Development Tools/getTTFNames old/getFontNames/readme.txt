For more details, please see the script files.


-- getFontNames V0.1a 12/8/2001
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
--		ttfname.exe	\	these 3 files can go anywhere, as long as they
--		listfonts.bat	 }	all stay in the same folder, and you modify
--		fontinfo.bat	/	the cmdPath var in getFontNames fn to point to that folder.
--							the default for the 3 files is max script folder.
--********************************************************************************************

