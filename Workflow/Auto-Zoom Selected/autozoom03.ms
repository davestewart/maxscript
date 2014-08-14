macroScript AutoZoom_Selected

	category:"Dave's Tools" 
	internalcategory:"Dave's Tools" 
	tooltip:"AutoZoom Extents Selected" 
	buttontext:"AutoZoom Extents Selected" 
	Icon:#("ViewportNavigationControls",1) 
( 
		---------------------------------------------------------------------------------------------------
		-- Another small script by Dave Stewart
		-- www.davestewart.co.uk
		---------------------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------------------
		-- local declarations
		---------------------------------------------------------------------------------------------------
		local state = false


		---------------------------------------------------------------------------------------------------
		-- Functions
		---------------------------------------------------------------------------------------------------
		fn zoomOn =
		(
			callbacks.addScript #selectionSetChanged "autoZoom()" persistent:true id:#autoZoom
			autoZoom()
			state = true
		)
	
		fn zoomOff =
		(
			callbacks.removeScripts id:#autoZoom
			state = false
		)
	
		fn autoZoom =
		(
			if (subObjectLevel==0 OR subObjectLevel==undefined) then max zoomext sel
		)
	
		---------------------------------------------------------------------------------------------------
		-- Handlers
		---------------------------------------------------------------------------------------------------

		On IsChecked return state

		On Execute do
		( 
			if state == off then zoomOn()
			else zoomOff()
			updateToolbarButtons()
	)
	) 