

fn showPositions =
	(
	
		local cam = $camera01
		local obj = $plane01
			
		arrPos = for t = 0 to 100 collect
			(
			at time t
				(
				local m = obj.mesh
				local pt3 = (getVert m 1) * obj.transform
				local ctx = getCameraTransform cam
				worldToCam pt3 cam ctx:ctx
				)
			)
	
	-- line
		gw.setColor #line red
		gw.wPolyline arrPos false
		gw.updateScreen()
	
	-- points
		gw.enlargeUpdateRect #whole
		gw.setTransform(Matrix3 1)
		for p in arrPos do
			(
			gw.wMarker p #PlusSign color:white
			)
		gw.updateScreen()
		
	)
	
	
fn showVertPositions =
	(
		gw.setTransform(Matrix3 1)
		gw.enlargeUpdateRect #whole
	
		delete helpers
	
		arrPos = for t = 0 to 100 by 10 collect
			(
			slidertime = t
			at time t
				(
				local p = getVert $plane01.mesh 1
				worldToCam p $camera01
				)
			)
			
		print arrPos
	
	-- line
		gw.setColor #line red
		gw.wPolyline arrPos false
		gw.updateScreen()
		
	-- points
		for p in arrPos do gw.wMarker p #PlusSign color:white
		gw.updateScreen()
		
	)
	
showPositions ()


(getVert $.mesh 1) * $.transform