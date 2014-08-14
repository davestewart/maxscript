---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------
global autoZoom, autoZoomCB, autoZoomProps
global autoZoomNodeCreatedCB, autoZoomNodeCreated

rollout ro1 "AutoZoom Selected" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------
	local state = false


	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	checkButton ckb1 "Active Viewport" pos:[8,8] width:144 height:16 highlightColor:(color 255 168 0) checked:false
	checkButton ckb2 "All viewports" pos:[8,24] width:144 height:16 highlightColor:(color 255 168 0) checked:false

	button btn1 "autoZoomProps" pos:[8,48] width:144 height:16
	button btn2 "subObjectLevel" pos:[8,64] width:144 height:16

	button btn3 "CBs.show()" pos:[8,88] width:144 height:16
	button btn4 "Clear Listener" pos:[8,104] width:144 height:16


	on btn1 pressed do print autoZoomProps
	on btn2 pressed do print subObjectLevel


	on btn3 pressed do callbacks.show()
	on btn4 pressed do clearListener()




	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn checkZoom =
	(
		autoZoomProps[3] = true -- enable autoZoom

		callbacks.removeScripts id:#autoZoom
		if (findItem autoZoomProps true) > 0 then
		(
			callbacks.addScript #selectionSetChanged "autoZoomCB()" persistent:false id:#autoZoom
			autoZoom()
		)
	)

	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on ro1 open do
	(

		-- set up global functions (callees of the intermediate callback functions)
	
			fn autoZoom =
			(
				format ">>> %\n" "autoZoom called!"

			-- check that nodeCreated() hasn't flagged true to a scene Node being added
				if autoZoomProps[3]==false then
				(
					-- check that subObjectLevel is 0 or undefined (top level)
						if (subObjectLevel==0 OR subObjectLevel==undefined) then 
					(
						-- check autoZoom type and do the zoom
							if autoZoomProps[2]==true then
							(
								max zoomext sel all
							)
							else if autoZoomProps[1]==true then
							(
								max zoomext sel
							)
					)
				)
			-- else the nodeCreated callback has been called...
			-- so get click counting and re-enable when selection set changes twice
				else
					(
						format ">>> AUTOZOOM IS FALSE< SO I'M NOT ZOOMING..."
						format ">>> clicks: %\n" autoZoomProps[4]	-- how many times has the selection set changed?
						autoZoomProps[4] += 1						-- one more...
						if autoZoomProps[4] == 2 then
							-- reset everything :)
							(
								autoZoomProps[3]=false
								autoZoomProps[4]=0
								callbacks.addScript #nodeCreated "autoZoomNodeCreatedCB()" persistent:false id:#autoZoom
							)
					)
			)
		

		fn autoZoomNodeCreated =
		(
			format ">>> %" "Creating Node, and disabling autoZoom\n"

			try	(autoZoomProps[3]=true) -- tell autoZoom that there is a node being created
			catch(
				format"> &" "There was a problem accessing autoZoom globals. Unregistering callbacks"
				callbacks.removeScripts id:#autoZoom
			)
			
			format ">>> AutoZoom[3] (node in creation) is % \n" autoZoomProps[3]
		)
		

		-- setup intermediate callback functions
		
			fn autoZoomCB = autoZoom()
			fn autoZoomNodeCreatedCB = autoZoomNodeCreated()
			

		-- initialise
	
			ckb1.checked = true
			autoZoomProps=#(true,false,false,0) --#('all viewports', 'active viewport', 'object creation started', 'sel set change counter')
			checkZoom()

			callbacks.addScript #nodeCreated "autoZoomNodeCreatedCB()" persistent:false id:#autoZoom


	)

	on ro1 close do
	(
		autoZoomProps=#(false,false,false,0)
		callbacks.removeScripts id:#autoZoom
	)

	on ckb1 changed state do
	(
		autoZoomProps[1] = state
		checkZoom()
	)

	on ckb2 changed state do
	(
		autoZoomProps[2] = state
		checkZoom()
	)
)

if autoZoomFloater != undefined then closerolloutfloater autoZoomFloater
	autoZoomFloater = newRolloutFloater "My Floater" 188 205
addRollout ro1 autoZoomFloater
