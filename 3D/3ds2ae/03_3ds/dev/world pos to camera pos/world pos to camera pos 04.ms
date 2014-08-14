-- objects

(
tp=worldToCam $point01 $camera01
in coordsys parent $Circle01.pos=[tp.x,tp.y,0]
print tp
)

fn worldToCam p c=
(

-- variables	
	-- adjacent side, or z distance
		dist_z = in coordsys c p.pos[3] 

	-- angle, or fov/2
		a=c.fov/2	

-- working out x
	-- opposite side, or view width at intersection of object
		picturePlaneWidth=abs(tan a*dist_z)*2
		
	-- get the actual measurement of the position of the point
		xc=in coordsys c p.pos[1] 
	
	-- get the measurement of the position of the point compared to the edge of the screen
		x=(picturePlaneWidth/2)+xc
		
	-- get the proportional measurement of the point as a float
		xf=(x/picturePlaneWidth)
		x=xf*renderWidth
		
	
-- working out y
	-- opposite side, or view width at intersection of object
		picturePlaneHeight=abs(tan a*dist_z)*2*(renderHeight as float/renderWidth as float)
		
	-- get the actual measurement of the position of the point
		yc=in coordsys c p.pos[2] 
	
	-- get the measurement of the position of the point compared to the edge of the screen
		y=(picturePlaneHeight/2)+yc
		
	-- get the proportional measurement of the point as a float
		yf=(y/picturePlaneHeight)
		y=renderHeight-(yf*renderHeight)
		


-- return
	return point2 x y
)

