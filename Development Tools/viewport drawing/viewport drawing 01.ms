/*

Drawing Methods
---------------

Methods that start with "h" take integer device coordinates with the origin at the lower-left. 
Methods that start with "w" in front take Windows device coordinates with the origin at the upper left. 

These "h" and "w" routines perform NO clipping unless otherwise noted. Drawing outside the allowable 
region is likely to cause 3ds Max to crash. These coordinate systems are left-handed.

Methods that don’t start with "h" or "w" map points from the graphic window's current transform 
to device space. This coordinate system is right-handed. If the graphic window's transform is set 
to the identity matrix then the mapping is done from points specified in world space. 

Otherwise the points given are transformed by the graphic window’s transform, and are then considered 
to be in world space. Thus, to get a world-space to screen-space conversion, you need to set the 
graphic window’s transform to the identity with:

	gw.setTransform(Matrix3 1)

After completing any drawing to the graphics window with the methods described in this section, you 
need to call gw.updateScreen() to update the viewport display.

 

*/

------------------------------------------------------------------------------------------------
-- utilities
------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------
	-- clears screen
		
		fn clearGw =
		(
			w = gw.getWinSizeX()
			h = gw.getWinSizeY()
			gw.clearScreen (Box2 [0,0] [w,h])
		)
		clearGw()
		
	------------------------------------------------------------------------------------------------
	-- resets gw matrix
		
		fn resetGwTransform =
		(
			identityMatrix = matrix3 1
			gw.setTransform identityMatrix 
		)
		resetGwTransform ()
		
------------------------------------------------------------------------------------------------
-- working examples
------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------
	-- draws a triangle
	
			identityMatrix = matrix3 1
		-- plot points
			gw.hPolyline #([300,50,16], [300,200,8], [450,250,4]) true 
			gw.hPolygon #([200,100,16], [280,100,8], [250,200,4]) #(red, blue, green) #([1.0,.5,0], [0.5,0.5,0], [0,0,0.5]) 
	
		-- Update the viewports 
			gw.enlargeUpdateRect #whole 
			gw.updateScreen()

	
	------------------------------------------------------------------------------------------------
	-- draws markers
	
		-- plot markers
			arr = #("point","hollowBox","plusSign","asterisk","xMarker","bigBox","circle","triangle","diamond","smallHollowBox","smallCircle","smallTriangle","smallDiamond")
			for i=1 to arr.count do
			(
				local p = [100, (50 + i*10), 50]
				local m = arr[i] as name
				gw.hMarker (p + [100,0,0]) m
				gw.wMarker p m
			)
		
		-- Update the viewports 
			gw.enlargeUpdateRect #whole
			gw.updateScreen()


	------------------------------------------------------------------------------------------------
	-- draws text
	
		(
			gw.setTransform (matrix3 1)

			local col	= black
			local p		= $.pos
			p = gw.transPoint p
			
			gw.text p "normal method" color:col
			gw.hText p "h method" color:col	-- device coordinates with the origin at the lower-left.
			gw.wText p "w method" color:col	-- Windows device coordinates with the origin at the upper left
		)

			gw.enlargeUpdateRect #whole
			gw.updateScreen()

	------------------------------------------------------------------------------------------------
	-- build marker at object pivot
	
			fn drawMarker p3 m:#circle c:red =
			(
				-- reset gw matrix
					gw.setTransform(Matrix3 1)
					
				-- 3d point
					p3 = gw.wTransPoint p3	-- transform to gw space
					
				-- draw marker
					gw.wMarker p3 m color:c
		
				-- update screen
					gw.enlargeUpdateRect #whole
					gw.updateScreen()
			)
			
		drawMarker $.pos
		

	------------------------------------------------------------------------------------------------
	-- build marker along curve
	

		fn drawPointOnSpline ss i d m:#circle c:red =
		(
			local p3 = lengthInterp ss i d
			drawMarker p3 m:m c:c 
		)
			
		drawPointOnSpline shapes[1] 1 0.5 c:green
		
	
	
	------------------------------------------------------------------------------------------------
	-- trace a curve
	
	(
		-- variables
			--local 
			ss = shapes[1]
			--local 
			arr = for d = 0.0 to 1.0 by 0.05 collect (lengthInterp ss 1 d)
			
		-- reset
			gw.setTransform(Matrix3 1)
			
		-- plot points
			for i = 1 to arr.count do
			(
				local dx = i * (1.0/arr.count)
				drawPointOnSpline ss 1 dx c:green
				arr[i] = gw.wTransPoint arr[i]
			)
				
			gw.wPolyline arr false 
	
		-- Update the viewports 
			gw.enlargeUpdateRect #whole 
			gw.updateScreen()

	)
		
	
	
	
	
	------------------------------------------------------------------------------------------------
	-- build a grid of 2D markers
	
			gw.setTransform (matrix3 1)
			for x = 1 to 1000 by 100 do
			(
				for y = 1 to 1000 by 100 do
				(
					local p = [x,y,0]
					local m = #hollowbox
					p = gw.transPoint p
					gw.wMarker p m
				)
			)
			gw.enlargeUpdateRect #whole
			gw.updateScreen()
	


	------------------------------------------------------------------------------------------------
	-- build a grid of 3D markers
	
			gw.setTransform objects[1].transform
			gw.setTransform (matrix3 1)
			--resetGwTransform ()
			
			for x = 1 to 1000 by 100 do
			(
				for y = 1 to 1000 by 100 do
				(
					local v = 1000
					local p = random [-v,-v,-v] [v,v,v]
					local p = [x,y,0]
					local m = #hollowbox
					gw.transPoint p
					gw.hMarker p m
				)
			)
			gw.enlargeUpdateRect #whole
			gw.updateScreen()
	


