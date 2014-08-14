--------------------------------------------------------------------------------------------------------
--
-- Script:			Render Size Presets
-- Version:			0.75
-- Date:			18 Sept 2007
-- Max version:		Tested in 7+ (tooltips only work in max 9+)
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
	0.75	Added "Last render time: Time" to tooltip on render complete
	0.7		Added "Image @ Size rendered in: Time" or "render was cancelled at:Time" user feedback
			Added progress bar and cancel button
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

		local dockPosition	-- #cui_dock_top

		local rWidth			= 0
		local rHeight			= 0
		local rFraction			= 1
		local rPAspect			= 1
		
		local rWindow
		local rCancelled
		local rRenderTime		= ""
		
		local arrRenderFractions= #(1, 0.75, 0.5, 0.25)
		local arrRenderSizes	= #("full", "¾", "½", "¼")
		local arrRenderTimes	= #()

	----------------------------------------------------------------------------------------------------
	-- interface 
	----------------------------------------------------------------------------------------------------
	
		dropdownList ddlPresets "" pos:[4,7] width:132 height:21
		checkbutton btn1 "1" pos:[136,9] width:16 height:16
		checkbutton btn2 "¾" pos:[152,9] width:16 height:16
		checkbutton btn3 "½" pos:[168,9] width:16 height:16
		checkbutton btn4 "¼" pos:[184,9] width:16 height:16

		checkbutton chk1 "R" pos:[204,9] width:16 height:16 toolTip:"Automatically render when a preset is clicked"
		
	----------------------------------------------------------------------------------------------------
	-- utility functions
	----------------------------------------------------------------------------------------------------
	
		fn updateDialog =
		(
			if renderSceneDialog.isOpen() do renderSceneDialog.update()
		)
			
		fn secondsToMinutes t =
		(
			local s	= (mod t 60) as integer
			local m	= ((t - s) / 60) as integer
		
			if s < 10 do s = "0" + s as string
			return m as string + ":" + s as string
		)
			
		fn secondsToTime t =
		(
			
			fn pad str n strPad:"0"=
			(
				str = str as string
				while str.count < n do str = strPad as string + str
				str
			)
				
			local s = (mod t 60) as integer
			local m = (mod ((t - s) / 60) 60) as integer
			local h = ((t - (m * 60) - 5) / 60 / 60) as integer
		
			s		= pad s 2
			m		= pad m 2
			h		= pad h 2

			return h + ":" + m + ":" + s
		)
			
		fn tooltipsOK =
		(
			(maxVersion())[1] >= 9000 
		)

	----------------------------------------------------------------------------------------------------
	-- functions
	----------------------------------------------------------------------------------------------------
	
		function getTooltip n =
		(
			local str		= arrRenderSizes[n]
			local fraction	= arrRenderFractions[n]
			local time		= arrRenderTimes[n]
			if time != undefined then time = ". Last render: " + time else time = ""
			"Render at " + str + " size (" + ((rWidth * fraction) as integer) as string + " x " + ((rHeight * fraction) as integer) as string + ")" + time
		)
			
		function doRender index =
		(
			-- hide last render
				try(undisplay rWindow);catch()
				
			-- render and time
				local t					= timestamp()
				local str				= stringstream ""
				rWindow					= render progressbar:true cancelled:&rCancelled
				t						= (timestamp() - t) / 1000.0
				local strTime			= secondsToTime t

				arrRenderTimes[index]	= strTime

			-- display feedback				
				if NOT rCancelled then
				(
					-- prompt
						format "Image @ %x% rendered in: %" renderWidth renderHeight strTime to:str
						
					-- update tooltips
						if tooltipsOK() do
						(
							btn1.tooltip	= getTooltip 1
							btn2.tooltip	= getTooltip 2
							btn3.tooltip	= getTooltip 3
							btn4.tooltip	= getTooltip 4
						)
				)
				else
				(
					-- prompt
						format "Render was cancelled at: %" strTime to:str
				)
				pushPrompt (str as string)
				
		)
			
		function setRenderFraction index fraction =
		(
			-- settings
				rFraction			= fraction
				renderWidth			= rWidth * fraction
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
					doRender index
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
					if tooltipsOK() do
					(
						btn1.tooltip			= ""
						btn2.tooltip			= ""
						btn3.tooltip			= ""
						btn4.tooltip			= ""
					)
					ddlPresets.selection	= 1
					return false
				)
			
			-- settings
				local preset	= presets[index - 2]
				
				rWidth			= preset[2]
				rHeight			= preset[3]
				rPAspect		= preset[4]

			-- UI
				arrRenderTimes = #()
				if tooltipsOK() do
				(
					btn1.tooltip	= getTooltip 1
					btn2.tooltip	= getTooltip 2
					btn3.tooltip	= getTooltip 3
					btn4.tooltip	= getTooltip 4
				)

			-- update renderer
				setRenderFraction index rFraction
				updateDialog()
				
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
				if dockPosition == undefined do
				(
					dockPosition	= if systemTools.GetScreenWidth() / systemTools.GetScreenHeight() > 1 then #cui_dock_top else #cui_dock_bottom
				)
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
