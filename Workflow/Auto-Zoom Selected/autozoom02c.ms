---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "AutoZoom Selected" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------
	local state = false
	global autoZoomSel = "a function..."
	global autoZoomSelCallback = "a function..."
	global autoZoomType=#(false,false)


	local debug = true

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	checkButton ckb1 "Active Viewport" pos:[8,8] width:144 height:16 highlightColor:(color 255 168 0) checked:false
	checkButton ckb2 "All viewports" pos:[8,24] width:144 height:16 highlightColor:(color 255 168 0) checked:false

	button btn1 "autoZoomType" pos:[8,48] width:144 height:16
	button btn2 "callbacks.show()" pos:[8,64] width:144 height:16
	button btn3 "Clear Listener" pos:[8,80] width:144 height:16


	on btn1 pressed do print autoZoomType
	on btn2 pressed do print (callbacks.show())
	on btn3 pressed do clearListener()




	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn autoZoomSel =
	(
if debug then messageBox "autoZoomSel"
		print "autoZoomSel called!"

		if getCommandPanelTaskMode() == #create then
		(
			-- do nothing if in create mode
		)
		else if (subObjectLevel!=0 OR subObjectLevel==undefined) then
		(
			-- do nothing if in subobject mode
		)
		else if autoZoomType[2]==true then
		(
			max zoomext sel all
		)
		else if autoZoomType[1]==true then
		(
			max zoomext sel
		)

	)


	fn autoZoomSelCallback =
	(
		if debug then messageBox "autoZoomSelCallback running..."
		autoZoomSel()
	)

	fn checkZoom =
	(
if debug then messageBox "checkZoom running..."

		callbacks.removeScripts id:#autoZoomSel
		if (findItem autoZoomType true) > 0 then
		(

if debug then messageBox "checkZoom : about to register callback"
			callbacks.addScript #selectionSetChanged "autoZoomSelCallback()" persistent:false id:#autoZoomSel


if debug then messageBox "checkZoom : about to call autoZoomSel"
			autoZoomSel()

		)
	)
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on ro1 open do
	(
		ckb1.checked = true
		autoZoomType[1] = true
		checkZoom()
	)

	on ro1 close do autoZoomType=#(false,false)

	on ckb1 changed state do
	(
		autoZoomType[1] = state
		checkZoom()
	)

	on ckb2 changed state do
	(
		autoZoomType[2] = state
		checkZoom()
	)
)

if autoZoomFloater != undefined then closerolloutfloater autoZoomFloater
	autoZoomFloater = newRolloutFloater "My Floater" 188 205
addRollout ro1 autoZoomFloater
