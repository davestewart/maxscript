---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "Options" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------



	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	checkButton ckb1 "Auto-Zoom is Off" pos:[8,8] width:144 height:16 highlightColor:(color 255 168 0) checked:false
	label lbl1 "Label" pos:[8,32] width:144 height:16



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn zoomOn =
		(
		callbacks.addScript #selectionSetChanged "autoZoom()" persistent:true id:#autoZoom
		autoZoom()
		)

	fn zoomOff =
		(
		callbacks.removeScripts id:#autoZoom
		)

	fn autoZoom =
		(
		--if (subObjectLevel == 0 || subObjectLevel == undefined) then max zoomext sel
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


