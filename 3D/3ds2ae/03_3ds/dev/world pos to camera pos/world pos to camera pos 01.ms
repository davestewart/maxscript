-- objects
	c=$camera01
	p=$point01

	circ=$Circle01

-- variables	
	-- adjacent side, or z distance
		adj = in coordsys c p.pos[3] 

	-- angle, or fov/2
		a=c.fov/2	

	--w= renderWidth
	w=$Rectangle01.width
	h=$Rectangle01.length
	
-- working out x
	-- opposite side, or view width at intersection of object
		opp=abs(tan a*adj)*2
		
	-- get the actual measurement of the position of the point
		xc=in coordsys c p.pos[1] 
	
	-- get the measurement of the position of the point compared to the edge of the screen
		x=(opp/2)+xc
		
	-- get the proportional measurement of the point as a float
		xf=(x/opp)
		x=xf*w
		
	-- align the circle using the fractional value and the width
		in coordsys circ.parent circ.pos.x=-(w/2)+(xf*w)
		
	
-- working out y
	-- opposite side, or view width at intersection of object
		opp=abs(tan a*adj)*2*(renderHeight as float/renderWidth as float)
		
	-- get the actual measurement of the position of the point
		yc=in coordsys c p.pos[2] 
	
	-- get the measurement of the position of the point compared to the edge of the screen
		y=(opp/2)+yc
		
	-- get the proportional measurement of the point as a float
		yf=(y/opp)
		y=yf*h
		
	-- align the circle using the fractional value and the width
		in coordsys circ.parent circ.pos.y=-(h/2)+(yf*h)
		




/*
degToRad(atan(w/c.targetDistance/2)*2) 
atan(w/c.targetDistance/2)*2

*/

apropos "rend"