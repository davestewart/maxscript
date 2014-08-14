---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "AutoZoom Selected" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------
	local state = false
	local zoomOn, zoomOff, errorLevel
	global autoZoomCallback, autoZoom



	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	checkButton ckb1 "Active Viewport" pos:[8,8] width:144 height:16 highlightColor:(color 255 168 0) checked:false
	checkButton ckb2 "All viewports" pos:[8,24] width:144 height:16 highlightColor:(color 255 168 0) checked:false



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn autoZoomSel type =
	(
		-- type: 1 - single viewport only
		--       2 - all viewports
		
		if getCommandPanelTaskMode() == #create then
		(
			-- do nothing if in create mode
		)
		else if (subObjectLevel!=0 OR subObjectLevel==undefined) then
		(
			-- do nothing if in subobject mode
		)
		else
		(
			case type of
			(
				1:	max zoomext sel
				2:	max zoomext sel all
			)
		)

	)


	fn autoZoomCallback type =
		case type of
		(
			1 : autoZoomSel 1
			2 : autoZoomSel 2
			default : messageBox "The argument specified needs to be as follows:\
			\n\n1: Zoom selected viewport\
			\n2: Zoom all viewports"
		)

	fn zoomOn =
	(
		callbacks.addScript #selectionSetChanged "autoZoomCallback 1" persistent:false id:#autoZoomSel
		autoZoomSel 1
		state = true
	)

	fn zoomOff =
	(
		callbacks.removeScripts id:#autoZoomSel
		state = false
	)
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on ro1 open do
	(
		zoomOn()
		ckb1.checked = true
	)
	on ro1 close do
		zoomOff()

	on ckb1 changed state do
	(
		if state then zoomOn()
		else zoomOff()
	)

	on ckb2 changed state do
	(
		if state then zoomOn()
		else zoomOff()
	)
)

if autoZoomFloater != undefined then closerolloutfloater autoZoomFloater
	autoZoomFloater = newRolloutFloater "My Floater" 188 105
addRollout ro1 autoZoomFloater