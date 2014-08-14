rollout fonts "Fonts" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------



	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

-- make sure the path below is correct and correspods to where you put the getFontNames script.

	--file = getDir #scripts + "\getFontNames-v0_3.ms"
	include "D:\Design\1 - 3D\3dsmax4\scripts\getFontNames-v0_3.ms"

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




if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout fonts myFloater