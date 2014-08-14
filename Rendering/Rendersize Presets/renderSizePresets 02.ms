--------------------------------------------------------------------------------------------------------
--
-- Script:		Render Size Presets
-- Version:		0.5
-- Date:		18 Sept 2007
-- Max version:	All (probably)
--
-- Author:		Dave Stewart
-- Website:		www.davestewart.co.uk
--
--------------------------------------------------------------------------------------------------------
/* Description:	

	Adds a new toolbar, allowing you to quickly change render size presets (PAL, PAL widescreen, HDTV, etc), 
	and sizes ranging from full to 25%. Also, optionally render when clicking the preset buttons.
	

Installation:

	Place this file in your scripts/startup directory.

*/

try(destroydialog roRenderSizePresets);catch()
rollout roRenderSizePresets "Render Size Presets" width:224 height:39
(

	----------------------------------------------------------------------------------------------------
	-- presets. Edit this section to add your own presets
	----------------------------------------------------------------------------------------------------

		-- to do:
			-- load and save all presets to an ini file
			-- maybe create an "add preset" option

		local presets =
			#(
				#("PAL", 768, 576, 1),
				#("PAL (Widescreen)", 1024, 576, 1),
				#("HDTV", 1920, 1080, 1)
				-- feel free to add more here
			)
			
	----------------------------------------------------------------------------------------------------
	-- variables
	----------------------------------------------------------------------------------------------------

		local dockPosition = #cui_dock_bottom 

		local rWidth	= 0
		local rHeight	= 0
		local rFraction	= 1
		local rPAspect	= 1
		local rWindow

	----------------------------------------------------------------------------------------------------
	-- interface 
	----------------------------------------------------------------------------------------------------
	
		dropdownList ddlPresets "" pos:[4,7] width:120 height:21 tooltip:"ljlj"
		button btn1 "1" pos:[124,9] width:16 height:16
		button btn2 "¾" pos:[140,9] width:16 height:16
		button btn3 "½" pos:[156,9] width:16 height:16
		button btn4 "¼" pos:[172,9] width:16 height:16
		--button btn5 "?" pos:[172,6] width:16 height:16
		
		checkbutton chk1 "R" pos:[192,9] width:16 height:16 toolTip:"Automatically render when a preset is clicked"
		
	----------------------------------------------------------------------------------------------------
	-- functions
	----------------------------------------------------------------------------------------------------
	
		function updateDialog =
			(
			if renderSceneDialog.isOpen() do renderSceneDialog.update()
			)
			
		function setRenderFraction fraction =
			(
			rFraction			= fraction
			
			renderWidth			= rWidth * fraction
			renderHeight		= rHeight * fraction
			renderPixelAspect	= rPAspect
			
			updateDialog()
	
			if chk1.checked do
				(
				try(undisplay rWindow);catch()
				rWindow = render()
				)
			)
			
		function setRenderSize index =
			(
			local preset	= presets[index]
			
			rWidth			= preset[2]
			rHeight			= preset[3]
			rPAspect		= preset[4]
			
			setRenderFraction rFraction
			updateDialog()
			)
		
		function loadPresets =
			(
			local arr = #()
			for preset in presets do
				(
				append arr preset[1]
				)
			ddlPresets.items = arr
			setRenderSize 1
			)
			
		function savePresets =
			(
			)

	----------------------------------------------------------------------------------------------------
	-- interface 
	----------------------------------------------------------------------------------------------------
	
		on ddlPresets selected sel do setRenderSize sel
		
		on btn1 pressed do setRenderFraction 1
		on btn2 pressed do setRenderFraction 0.75
		on btn3 pressed do setRenderFraction 0.5
		on btn4 pressed do setRenderFraction 0.25
		
		on roRenderSizePresets open do
			(
			-- load presets
				loadPresets()
				chk1.checked = true
				
			-- dock
				cui.RegisterDialogBar roRenderSizePresets style:#(#cui_dock_top, #cui_dock_bottom, #cui_floatable, #cui_handles)
				cui.DockDialogBar roRenderSizePresets dockPosition
			
			-- workaround for not displaying straight away
				local mode = getCommandPanelTaskMode()
				setCommandPanelTaskMode #utility
				setCommandPanelTaskMode mode
			)

		on roRenderSizePresets close do savePresets()
)

-- create
	createdialog roRenderSizePresets style:#(#style_titlebar, #style_border, #style_sysmenu)


