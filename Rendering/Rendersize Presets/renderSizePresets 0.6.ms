--------------------------------------------------------------------------------------------------------
--
-- Script:			Render Size Presets
-- Version:			0.6
-- Date:			18 Sept 2007
-- Max version:		All (probably)
--
-- Author:			Dave Stewart
-- Website:			www.davestewart.co.uk
--
--------------------------------------------------------------------------------------------------------
/* Description:	

	Adds a new toolbar, allowing you to quickly change render size presets (PAL, PAL widescreen, HDTV, etc), 
	and sizes ranging from full to 25%. Also, optionally render when clicking the preset buttons.
	

Installation:

	Place this file in your scripts/startup directory.


Version History
	0.6		Changed preset-size buttons to be checkbuttons (indicating current render-size preset)
			Added tooltips to preset-size buttons
			Set the default UI state to "Selet render preset..." and disabled buttons
	0.55	Changed the floater to be a dockable toolbar instead
	0.5		Main tool completed

*/

try(destroydialog roRenderSizePresets);catch()
rollout roRenderSizePresets "Render Size Presets" width:236 height:39
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

		local dockPosition	= #cui_dock_bottom -- #cui_dock_top

		local rWidth		= 0
		local rHeight		= 0
		local rFraction	= 1
		local rPAspect		= 1
		local rWindow

	----------------------------------------------------------------------------------------------------
	-- interface 
	----------------------------------------------------------------------------------------------------
	
		dropdownList ddlPresets "" pos:[4,7] width:132 height:21
		checkbutton btn1 "1" pos:[136,9] width:16 height:16
		checkbutton btn2 "¾" pos:[152,9] width:16 height:16
		checkbutton btn3 "½" pos:[168,9] width:16 height:16
		checkbutton btn4 "¼" pos:[184,9] width:16 height:16

		--button btn5 "?" pos:[172,6] width:16 height:16
		
		checkbutton chk1 "R" pos:[204,9] width:16 height:16 toolTip:"Automatically render when a preset is clicked"
		
	----------------------------------------------------------------------------------------------------
	-- functions
	----------------------------------------------------------------------------------------------------
	
		function updateDialog =
		(
			if renderSceneDialog.isOpen() do renderSceneDialog.update()
		)

		function getTooltip str rWidth rHeight fraction =
		(
			str + " (" + ((rWidth * fraction) as integer) as string + " x " + ((rHeight * fraction) as integer) as string + ")"
		)
			
		function setRenderFraction index fraction =
		(
			-- settings
				rFraction			= fraction
				renderWidth		= rWidth * fraction
				renderHeight		= rHeight * fraction
				renderPixelAspect	= rPAspect
				
			-- UI
				btn1.state	= fraction == 1
				btn2.state	= fraction == 0.75
				btn3.state	= fraction == 0.5
				btn4.state	= fraction == 0.25
				updateDialog()
		
			-- render
				if chk1.checked do
				(
					try(undisplay rWindow);catch()
					rWindow = render()
				)
		)
			
		function setRenderSize index =
		(
			-- check UI
				local uiState	= index > 2
				btn1.enabled 	= uiState
				btn2.enabled 	= uiState
				btn3.enabled	= uiState
				btn4.enabled 	= uiState

				if NOT uiState do
				(
					btn1.tooltip			= ""
					btn2.tooltip			= ""
					btn3.tooltip			= ""
					btn4.tooltip			= ""
					ddlPresets.selection	= 1
					return false
				)
			
			-- settings
				local preset	= presets[index - 2]
				
				rWidth			= preset[2]
				rHeight			= preset[3]
				rPAspect		= preset[4]

				setRenderFraction index rFraction
				updateDialog()
				
			-- UI			
				btn1.tooltip	= getTooltip "Set renderer to full size" rWidth rHeight 1
				btn2.tooltip	= getTooltip "Set renderer to ¾ size" rWidth rHeight 0.75
				btn3.tooltip	= getTooltip "Set renderer to ½ size" rWidth rHeight 0.5
				btn4.tooltip	= getTooltip "Set renderer to ¼ size" rWidth rHeight 0.25
			
		)
		
		function loadPresets =
		(
			local arr = #("Select render preset...","- - - - - - - - - - - - - - - - - - - - ")
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
		
		on btn1 changed state do setRenderFraction 1 1
		on btn2 changed state do setRenderFraction 2 0.75
		on btn3 changed state do setRenderFraction 3 0.5
		on btn4 changed state do setRenderFraction 4 0.25
		
		on roRenderSizePresets open do
		(
			-- load presets
				loadPresets()
				
			-- update UI
				chk1.checked	= true
				btn1.checked	= true

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
