-- get cam pos
	cam		= $camera01
	pos		= objects[1].pos
	pt3		= worldToCam pos cam

-- output sizes

	v		= [640,480]
	r		= [640,385]
	
	v		= [gw.getWinSizeX(),gw.getWinSizeY()]
	r		= [renderwidth,renderHeight]

-- ratios

	vRatio	= vpt[1] / vpt[2] -- 1.33333
	rRatio	= rnd[1] / rnd[2] -- 1.66667
	
	mtx		= rnd / vpt

	vHb	= vpt[2] * (1 - mtx[2])	-- V border on viewport
	vVb	= vpt[1] * (1 - mtx[1])	-- H border on viewport

	vPt2 = pt3 * mtx
	vPt3 = [vPt2.x + (vHb / 2.0), vPt2.y + (vVb / 2.0), 0]
	
	gw.setTransform(Matrix3 1)
	gw.enlargeUpdateRect #whole
	gw.wMarker vPt3 #PlusSign color:white
	gw.updateScreen()
	
	480 - 385