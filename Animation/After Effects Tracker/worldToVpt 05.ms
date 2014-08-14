-- gets the viewport coords of an object's center by passing the object
	fn getVptObjPos obj start end =
	(
		local arr	= #()
		local st = slidertime
		with redraw off
		(
			for t = start to end do
			(
				local pt3	= at time t obj.pos
				slidertime	= t
				gw.setTransform(Matrix3 1)
				append arr (gw.wTransPoint pt3)
			)
		)
		slidertime = st
		return arr
	)

-- gets the viewport coords of a point by passing a 1D array of points
-- point array > point3
	fn getVptPoints arr start end =
	(
		local st = slidertime
		with redraw off
		(
			for t = start to end do
			(
				local i		= t - start + 1
				slidertime	= t
				gw.setTransform(Matrix3 1)
				arr[i]		= gw.wTransPoint arr[i]
			)
		)
		slidertime = st
		return arr
	)

-- gets the viewport coords of multiple points by passing a 2D array of points over time:
-- time array > point array > point3
	fn getVptPointsArr arrPts start end =
	(
		local arr	= #()
		local st = slidertime
		local i
		local pts
		with redraw off
		(
			for t = start to end do
			(
				slidertime = t
				gw.setTransform(Matrix3 1)
				local i = t - start + 1
				local pts = arrPts[i]
				format "% : %\n" i pts
				for p = 1 to pts.count do
				(
					pts[p] = gw.wTransPoint pts[p]
				)
				arrPts[i] = pts
			)
		)
		slidertime = st
		return arrPts
	)

-- gets the viewport coords of multiple points by passing a 2D array of points over time:
-- time array > point array > point3

fn getVptPointsArr arr start end =
(
	local st				= slidertime
	with redraw off
	(
		for t = start to end do
		(
			local i			= t - start + 1
			local arrVerts	= arr[i]
			slidertime		= t
			gw.setTransform(Matrix3 1)
			for v = 1 to arrVerts.count do
			(
				arrVerts[v]	= gw.wTransPoint arrVerts[v]
			)
			arr[i]			= arrVerts
		)
	)
	slidertime = st
	return arr
)




fn getMeshPoints obj start end =
(
	local arr	= #()
	local verts	= getNumVerts obj.mesh
	for t = start to end do
	(
		local arrVerts	= #()
		local objMesh	= obj.mesh
		for v = 1 to verts do
		(
			local pt3 = at time t (getVert objMesh v) * (obj.transform)
			append arrVerts pt3
		)
		append arr arrVerts
	)
	return arr
)




fn drawVptLine arr marker:#point markerColor:white lineColor:red =
(
	-- line
		gw.setColor #line lineColor
		gw.wPolyline arr false
		
	-- points
		if point != undefined then
		(
			for p in arr do gw.wMarker p marker color:markerColor
		)

	-- update
		gw.setTransform(Matrix3 1)
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
)


fn drawVptLineArr arr =
(
	for i = 1 to arr[1].count do
	(
		local line = for j = 1 to arr.count collect arr[j][i]
		local lineColor = random black white
		drawVptLine line lineColor:lineColor
	)
)

-- times
	t1	= 25
	t2	= 50

-- show position of a mesh point
	arrMesh	= getMeshPoints geometry[1] t1 t2
	arrVert	= for j = 1 to arrMesh.count collect arrMesh[j][3]
	
	arr = getVptPoints arrVert t1 t2
	drawVptLine arr lineColor:blue
	
	
	
	
-- show position of lots of mesh points
	arrMesh	= getMeshPoints geometry[1] t1 t2
	arrMeshVpt = getVptPointsArr arrMesh t1 t2
	drawVptLineArr arrMeshVpt



-- show position of an object
	ts1 = timestamp()
	arr1 = getVptObjPos geometry[1] t1 t2
	arr2 = getVptObjPos geometry[2] t1 t2
	drawVptLine arr1 lineColor:blue
	drawVptLine arr2 lineColor:red
	ts2 = timestamp()
	format "Completed in %\n" (ts2-ts1)
	
	