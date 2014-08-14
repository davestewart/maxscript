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
		adj = in coordsys c p.pos[3] 

	-- angle, or fov/2
		a=c.fov/2	

-- working out x
	-- opposite side, or view width at intersection of object
		opp=abs(tan a*adj)*2
		
	-- get the actual measurement of the position of the point
		xc=in coordsys c p.pos[1] 
	
	-- get the measurement of the position of the point compared to the edge of the screen
		x=(opp/2)+xc
		
	-- get the proportional measurement of the point as a float
		xf=(x/opp)
		x=xf*renderWidth
		
	
-- working out y
	-- opposite side, or view width at intersection of object
		opp=abs(tan a*adj)*2*(renderHeight as float/renderWidth as float)
		
	-- get the actual measurement of the position of the point
		yc=in coordsys c p.pos[2] 
	
	-- get the measurement of the position of the point compared to the edge of the screen
		y=(opp/2)+yc
		
	-- get the proportional measurement of the point as a float
		yf=(y/opp)
		y=renderHeight-(yf*renderHeight)
		


-- return
	return point2 x y
)

