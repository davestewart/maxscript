---------------------------------------------------------------------------------------------------
-- declarations
---------------------------------------------------------------------------------------------------
	global autoZoom, autoZoomCB, autoZoomProps
	global autoZoomNodeCreatedCB, autoZoomNodeCreated
	global autoZoomProps=#(false,false,false,0)


---------------------------------------------------------------------------------------------------
-- Global Functions
---------------------------------------------------------------------------------------------------

	-- set up global functions (callees of the intermediate callback functions)

		fn autoZoom =
		(
			format ">>> %\n" "autoZoom called!"

		-- check if autoZoom is enabled
			if autoZoomProps[3]==true then
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
		-- else the autoZoomNodeCreated callback has disabled autoZoom...
		-- so get click counting and re-enable when selection set changes twice
			else
				(
					format ">>> AUTOZOOM IS FALSE< SO I'M NOT ZOOMING..."
					format ">>> clicks: %\n" autoZoomProps[4]	-- how many times has the selection set changed?
					autoZoomProps[4] += 1						-- one more...
					if autoZoomProps[4] == 2 then
						-- reset everything :)
						(
							autoZoomProps[3]=true
							autoZoomProps[4]=0
							callbacks.addScript #nodeCreated "autoZoomNodeCreatedCB()" persistent:false id:#autoZoom
						)
				)
		)
	

	fn autoZoomNodeCreated =
	(
		format ">>> %" "Creating Node, and disabling autoZoom\n"

		try	(autoZoomProps[3]=false) -- disable autoZoom
		catch(
			format"> &" "There was a problem accessing autoZoom globals. Unregistering callbacks"
			callbacks.removeScripts id:#autoZoom
		)
		
		format ">>> AutoZoom is % \n" autoZoomProps[3]
	)
	

	-- setup intermediate callback functions
	
		fn autoZoomCB = autoZoom()
		fn autoZoomNodeCreatedCB = autoZoomNodeCreated()
		

---------------------------------------------------------------------------------------------------
-- initialise
---------------------------------------------------------------------------------------------------

	-- initialises global properties for autoZoom
		autoZoomProps=#(false,false,true,0)	--#('all viewports', 'active viewport', 'enabled', 'sel set change counter')
	
	-- add callback that tells autoZoom when an object is in the process of being created
		callbacks.addScript #nodeCreated "autoZoomNodeCreatedCB()" persistent:false id:#autoZoom

