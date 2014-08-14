---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "Options" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------
	local state = false
	local zoomOn, zoomOff, errorLevel
	global autoZoomSelAll



	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	checkButton ckb1 "Auto-Zoom is Off" pos:[8,8] width:144 height:16 highlightColor:(color 255 168 0) checked:false
	label lbl1 "Label" pos:[8,32] width:144 height:16




	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn autoZoomSelAll =
	(
		errorLevel = 0

		if getCommandPanelTaskMode() == #create then errorLevel+=1
		if (subObjectLevel!=0 OR subObjectLevel==undefined) then errorLevel+=1
		if selection.count == 0 then errorLevel=0

		--print errorLevel
		if  errorLevel == 0 then max zoomext sel all
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
)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout ro1 myFloater