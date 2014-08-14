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

	mtx		= if vR > 1 then r / v else v / r

-- ratios
	vR		= v[1] / v[2] -- 1.33333
	rR		= r[1] / r[2] -- 1.66667
	--mtx		= r / v
	mtx		= v / r

	--mtx		= if vR > rR then r / v else v / r
	--mtx		= if vR > rR then v / r else r / v


-- get borders
	rBrd	= - r * ([1,1] - mtx)	-- get borders
	--rBrd	= v * ([1,1] - mtx)	-- get borders
	

-- transform point by adding borders
	--pt2		+= vBrd / 2.0
	pt2		+= rBrd / 2.0

-- transform from rendersize to viewport size
	pt2		*= v[1] / r[1]
	
-- convert to point3
	pt3		= [pt2.x, pt2.y, 0]
	

-- draw on viewport	
	gw.setTransform(Matrix3 1)
	gw.enlargeUpdateRect #whole
	gw.wMarker pt3 #circle color:black
	gw.updateScreen()


fn testGw =
(
	local start	= 0
	local end	= 100 -- animationrange.end
	local arr	= #()
	with redraw off
	(
		for t = start to end do
		(
			slidertime = t
			gw.setTransform(Matrix3 1)
			local pos	= objects[1].pos
			local pt3 = at time t pos
			pt3 = gw.wTransPoint pt3
			append arr pt3
		)
	)
	for pt3 in arr do
	(
		gw.wMarker pt3 #circle color:black
	)
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
	return arr
)

fn testCam =
(
	gw.setTransform(Matrix3 1)
	gw.enlargeUpdateRect #whole
	for t = 1 to animationrange.end do
	(
		local pos	= objects[1].pos
		local pt2	= at time t worldToCam pos cam
		pt3 = gw.wTransPoint [pt2.x,pt2.y,0]
		gw.wMarker pt3 #circle color:black
	)
	gw.updateScreen()
)



t1 = timestamp()
arr = testGw()
t2 = timestamp()
format "Completed in %\n" (t2-t1)

t1 = timestamp()
testCam()
t2 = timestamp()
format "Completed in %\n" (t2-t1)

