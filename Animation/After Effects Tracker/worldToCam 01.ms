fn worldToCam p c z:false =
(
	-- variables
		local a, x, y, xf, yf, deletePoint = false
	
	-- notes
		-- p is the point (node) or a point3 value
		-- c is the camera

	-- node / position variables
		if classof p == point3 then
		(
			p = point pos:p
			deletePoint = true
		)
		
		
		forceCompleteRedraw()
		messagebox ""
	-- camera variables
		-- angle, or fov/2
			a		= c.fov / 2	
	
		-- adjacent side, or z distance
			dist_z	= in coordsys c p.pos[3] 
			
	-- calculations
		-- opposite side(s), or view width/height at intersection of object
			view_w	= abs(tan a * dist_z) * 2
			view_h	= abs(tan a * dist_z) * 2 *(renderHeight as float / renderWidth as float)
			
		-- get the position of the point compared to the camera
			x		= in coordsys c p.pos[1]
			y		= in coordsys c p.pos[2] 
		
		-- get the position of the point compared to the edge of the screen
			x		+= view_w / 2
			y		+= view_h / 2
			
		-- get the proportional measurement of the point as a float
			xf		= x / view_w
			x		= xf * renderWidth--/renderPixelAspect
			
			yf		= y / view_h
			y		= renderHeight-(yf * renderHeight)
	
	-- cleanup
		--if deletePoint == true then delete p
	
	-- return
	
		return point3 x y 0
		
		return point2 x y
)
