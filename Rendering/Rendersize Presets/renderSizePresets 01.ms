try(destroydialog roRenderSizePresets);catch()
rollout roRenderSizePresets "Render Size Presets" width:216 height:32
(

	----------------------------------------------------------------------------------------------------
	-- presets
	----------------------------------------------------------------------------------------------------

		-- to do: load and save all presets to an ini file

		local presets =
			#(
				#("PAL", 768, 576, 1),
				#("PAL (Widescreen)", 1024, 576, 1),
				#("HDTV", 1920, 1080, 1)
		)

	----------------------------------------------------------------------------------------------------
	-- variables
	----------------------------------------------------------------------------------------------------

		local rWidth	= 0
		local rHeight	= 0
		local rFraction	= 1
		local rPAspect	= 1
		local rWindow

	----------------------------------------------------------------------------------------------------
	-- interface 
	----------------------------------------------------------------------------------------------------
	
		dropdownList ddlPresets "" pos:[4,4] width:120 height:21 tooltip:"ljlj"
		button btn1 "1" pos:[124,6] width:16 height:16
		button btn2 "¾" pos:[140,6] width:16 height:16
		button btn3 "½" pos:[156,6] width:16 height:16
		button btn4 "¼" pos:[172,6] width:16 height:16
		--button btn5 "?" pos:[172,6] width:16 height:16
		
		checkbutton chk1 "R" pos:[192,6] width:16 height:16 toolTip:"Automatically render when a preset is clicked"
		
	----------------------------------------------------------------------------------------------------
	-- functions
	----------------------------------------------------------------------------------------------------
	
		function updateDialog =
		(
			if renderSceneDialog.isOpen() do renderSceneDialog.update()
		)
			
		function setRenderFraction fraction =
		(
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
		
		on roRenderSizePresets open do loadPresets()
		on roRenderSizePresets close do savePresets()
)

createdialog roRenderSizePresets