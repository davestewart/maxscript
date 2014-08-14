-- get cam pos
	cam		= cameras[1]
	pos		= objects[1].pos
	pt2		= worldToCam pos cam

-- output sizes
	v		= [640,480]
	r		= [640,385]
	
	v		= [gw.getWinSizeX(),gw.getWinSizeY()]
	r		= [renderwidth,renderHeight]

-- ratios
	vR		= v[1] / v[2] -- 1.33333
	rR		= r[1] / r[2] -- 1.66667
	mtx		= r / v

	mtx		= if vR > rR then r / v else v / r
	--mtx		= if vR > rR then v / r else r / v


-- get borders
	rBrd	= r * ([1,1] - mtx)	-- get borders
	vBrd	= v * ([1,1] - mtx)	-- get borders
	
	rBrd	= 
	

-- transform point by adding borders
	--pt2		+= vBrd / 2.0
	pt2		+= rBrd / 2.0

-- transform from rendersize to viewport size
	--pt2		/= mtx
	
-- cnvert to point3
	pt3		= [pt2.x, pt2.y, 0]
	

-- draw on viewport	
	gw.setTransform(Matrix3 1)
	gw.enlargeUpdateRect #whole
	gw.wMarker pt3 #PlusSign color:white
	gw.updateScreen()
