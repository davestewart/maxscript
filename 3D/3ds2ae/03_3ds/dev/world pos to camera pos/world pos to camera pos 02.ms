-- this script has been altered to work with the circle's pos controller
fn moveCirc=
(


	-- objects
		c=$camera01
		p=$point01
		--dependsOn p c
		--circ=$Circle01
	
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
			x=xf*opp
			
		-- align the circle using the fractional value and the width
			--in coordsys circ.parent circ.pos.
			x=-(opp/2)+(xf*opp)
			
		
	-- working out y
		-- opposite side, or view width at intersection of object
			opp=abs(tan a*adj)*2*(renderHeight as float/renderWidth as float)
			
		-- get the actual measurement of the position of the point
			yc=in coordsys c p.pos[2] 
		
		-- get the measurement of the position of the point compared to the edge of the screen
			y=(opp/2)+yc
			
		-- get the proportional measurement of the point as a float
			yf=(y/opp)
			y=yf*opp
			
		-- align the circle using the fractional value and the width
			--in coordsys circ.parent circ.pos.
			y=-(opp/2)+(yf*opp)

			in coordsys circ.parent circ.pos=[x,y,0]
)
	
