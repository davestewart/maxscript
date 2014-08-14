fn worldToCam p c z:false=
(
	-- notes
		-- p is the point (node) or a point3 value
		-- c is the camera

	-- camera variables
		-- angle, or fov/2
			a=c.fov/2	
	
		-- adjacent side, or z distance
			dist_z = in coordsys c p.pos[3] 
			
	-- node / position variables
		--if classof p != point3 then p=p.pos
		
	-- calculations
		-- opposite side(s), or view width/height at intersection of object
			view_w=abs(tan a*dist_z)*2
			view_h=abs(tan a*dist_z)*2*(renderHeight as float/renderWidth as float)
			
		-- get the position of the point compared to the camera
			x=in coordsys c p.pos[1]
			y=in coordsys c p.pos[2] 
		
		-- get the position of the point compared to the edge of the screen
			x+=view_w/2
			y+=view_h/2
			
		-- get the proportional measurement of the point as a float
			xf=x/view_w
			x=xf*renderWidth--/renderPixelAspect
			
			yf=y/view_h
			y=renderHeight-(yf*renderHeight)
		
	-- return
	
		return point2 x y
		
		return point3 x y z
)
	
	
fn dumpTransforms p c=
(
	-- array
		arr=#()
		for t = 0 to 100 do
		(
			-- get point
				at time t pos=worldToCam p c
				append arr pos
			-- draw points
				drawPointOnVpt pos.x pos.y
		)
		-- update viewport
			gw.enlargeUpdateRect #whole 
			gw.updateScreen() 

	-- string
		str=""
		for i = 1 to arr.count do
		(
			str+=arr[i] as string+","
		)
		str=substring str 1 (str.count-1)
		format "%\n" str
)

tp=worldToCam $point01 $camera01

dumpTransforms $ $camera01

/*
--tp=worldToCam ($'PF Source 01'.getParticlePosition 5) $camera01

in coordsys parent $Circle01.pos=[tp.x,tp.y,0]
redrawViews()
forceCompleteRedraw()
print tp

*/

