-- objects

fn worldToCam p c=
(
	-- variables	
		-- angle, or fov/2
			a=c.fov/2	
	
		-- adjacent side, or z distance
			dist_z = in coordsys c p.pos[3] 
	
	-- calculations
		-- opposite side, or view width at intersection of object
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
			x=xf*renderWidth
			
			yf=y/view_h
			y=renderHeight-(yf*renderHeight)
		
	-- return
		return point2 x y
)

(
)
tp=worldToCam $point01 $camera01
in coordsys parent $Circle01.pos=[tp.x,tp.y,0]
redrawViews()
forceCompleteRedraw()
print tp

$Circle01.pos.controller.value

$Circle01.pos.controller.value