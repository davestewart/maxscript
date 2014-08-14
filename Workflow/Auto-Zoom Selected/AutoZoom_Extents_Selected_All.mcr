macroScript AutoZoom_Extents_Selected_All

	category:"pondskata"
	internalcategory:"pondskata"
	tooltip:"AutoZoom Extents Selected All"
	buttontext:"AutoZoom Extents Selected All"
	Icon:#("ViewportNavigationControls",3)
	(

	---------------------------------------------------------------------------------------------------
	-- AutoZoom 1.0

	-- by pondskata (www.pondskata.com)
	-- August 2002

	-- One of two scripts; please distribute together...
	-- pondskata-AutoZoom_Extents_Selected.mcr
	-- pondskata-AutoZoom_Extents_Selected_All.mcr

	-- Autozooms to the selected object, except when in create or suboject mode.
	-- Stick this in your Quad menu or a toolbar. Look for "pondskata" in "Customise User Interface"

	---------------------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------------------
		-- declarations
		---------------------------------------------------------------------------------------------------
		local state = false
		local zoomOn, zoomOff
		global autoZoomSelAll


		---------------------------------------------------------------------------------------------------
		-- Functions
		---------------------------------------------------------------------------------------------------
		fn autoZoomSelAll =
			(
			if getCommandPanelTaskMode() == #create then
				(
				-- do nothing if in create mode
				)
			else if (subObjectLevel!=0 OR subObjectLevel==undefined) then
				(
				-- do nothing if in subobject mode
				)
			else max zoomext sel all
			)

		fn zoomOn =
			(
			callbacks.addScript #selectionSetChanged "autoZoomSelAll()" persistent:false id:#autoZoomSelAll
			autoZoomSelAll()
			state = true
			)
	
		fn zoomOff =
			(
			callbacks.removeScripts id:#autoZoomSelAll
			state = false
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