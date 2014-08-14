macroScript AutoZoom_Extents_Selected

	category:"Apondskata"
	internalcategory:"Apondskata"
	tooltip:"AutoZoom Extents Selected"
	buttontext:"AutoZoom Ext Sel"
	Icon:#("ViewportNavigationControls",1)
	( 

	---------------------------------------------------------------------------------------------------
	-- AutoZoom 1.0

	-- by pondskata (www.pondskata.com)
	-- August 2002

	-- One of three scripts; please distribute together...
	-- pondskata-AutoZoom_Extents_Selected.mcr
	-- pondskata-AutoZoom_Extents_Selected_All.mcr
	-- pondskata-AutoZoom_Functions.ms

	-- Autozooms to the selected object, except when in create or suboject mode.
	-- Stick this in your Quad menu or a toolbar. Look for "pondskata" in "Customise User Interface"

	---------------------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------------------
		-- declarations
		---------------------------------------------------------------------------------------------------

		--if autoZoom == undefined then 
		fileIn "AutoZoom_functions.ms"
		local state = false


		---------------------------------------------------------------------------------------------------
		-- Functions
		---------------------------------------------------------------------------------------------------
	
		fn checkAutoZoom =
			(
			autoZoomProps[3] = true -- enable autoZoom
		
			callbacks.removeScripts id:#autoZoom
			if (autoZoomProps[1]==true AND autoZoomProps[2]==true) then
				(
				callbacks.addScript #selectionSetChanged "autoZoomCB()" persistent:false id:#autoZoom
				autoZoom()
				)
			)


		---------------------------------------------------------------------------------------------------
		-- Handlers
		---------------------------------------------------------------------------------------------------

		On IsChecked return state

		On Execute do
			( 
			autoZoomProps[1] = state
			checkAutoZoom()
			updateToolbarButtons()
		)
	)
	
/*
	autoZoomProps=#(false,false,false,0)
	callbacks.removeScripts id:#autoZoom

*/	
	