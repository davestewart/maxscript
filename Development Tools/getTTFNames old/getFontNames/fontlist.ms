-- If your in a MXS window, please press Ctrl+D (it will make life easier).

-- fontlist V0.1 12/8/2001
-- By Ofer Zelichover
-- You may freely use this script. Altough I had no problems with it, use it at your OWN RISK.
--*****************************************************************************************
-- Decription:
------------------
-- This is a demo script showing a posible way of using the getFontNames sript.
-- It Uses a global variable to store the font names, so the next time you run the script
-- (if you haven't closed max) you won't have to get the list again, since it take a little time.
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
-- Put : 	fontlist.ms 	- anywhere.
--********************************************************************************************
utility fonts "Fonts" (

-- make sure the path below is correct and correspods to where you put the getFontNames script.
	include "D:\\Design\\1 - 3D\\3dsmax4\\scripts\\getFontNames\\getFontNames-v0_2.ms"

	local getFontNamesList

-- I added the refresh button, just to see if it works, it's not really nessecary.	
	button refresh "Refresh Font List"
	dropdownlist fonts "Font: " items:#() selection:1

	on refresh pressed do (
		fonts.items = getFontNamesList forceUpd:true
	)
	
	on fonts selected i do (
		format "The selected font is: %\n" fonts.items[i]
	)

	on fonts open do (
		global fontNamesList = getFontNamesList()
		fonts.items=fontNamesList
	)

	fn getFontNamesList forceUpd:false =
	(
		if  forceUpd or (fontNamesList == undefined) then
			return getFontNames()
		else 
			return fontNamesList
	) -- End of getFontNamesList fn.
	
) -- End of utility