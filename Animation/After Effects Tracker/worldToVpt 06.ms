--------------------------------------------------------------------------------------------------
-- getVptObjPos:	gets the viewport coords of an object's center

-- arguments:
	-- obj:			any transformable object
	-- start:		an integer
	-- end:			an integer

-- returns:			an array of viewport-space transformed Point3s
	--				array[point3]

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


--------------------------------------------------------------------------------------------------
-- getVptPoints:	gets the viewport coords of an array of world-space point3s

-- arguments:
	-- arr:			an array of world-space point3s
	-- 				array[point3]
	-- start:		an integer
	-- end:			an integer

-- returns:			an array of viewport-space transformed Point3s
	--				array[point3]

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


--------------------------------------------------------------------------------------------------
-- getVptPointsArr:	gets the viewport coords of multiple world-space point3 arrays

-- arguments:
	-- arr:			a 2D array of world-space point3 arrays
	--				array (time) > array (point3) > point3
	-- 				array[time][point3]
	-- start:		an integer
	-- end:			an integer

-- returns:			a 2D array of transformed viewport-space Point3s over time
	--				array (time) > array (point3) > point3
	--				array[time][point3]

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


--------------------------------------------------------------------------------------------------
-- getMeshPoints:	gets a 2D array of a mesh's vertices in world-space, over time

-- arguments:
	-- obj:			a node that can be converted to a mesh object
	-- start:		an integer
	-- end:			an integer

-- returns:			an array of arrays of mesh's vertices in world-space, over time
	--				array (time) > array (point3) > point3
	--				array[time][point3]

	fn getMeshPoints obj start end =
		(
		local arr	= #()
		local objMesh, pt3
		local verts	= getNumVerts obj.mesh
		for t = start to end do
			(
			local arrVerts	= #()
			--local objMesh	= snapshotAsMesh obj
			for v = 1 to verts do
				(
				at time t
					(
					--objMesh	= obj.mesh
					--pt3		= ((getVert objMesh v) + obj.objectOffsetPos) * (obj.transform)
					objMesh	= snapshotAsMesh obj
					pt3		= getVert objMesh v
					)
				append arrVerts pt3
				)
			append arr arrVerts
			)
		return arr
		)

--getMeshPoints $geometry[1] 0 100

--------------------------------------------------------------------------------------------------
-- drawVptLine:		draws a single line on the viewport

-- arguments:
	-- arr:			an array of Point3s in viewport-coords
	--				array (point3) > point3
	-- marker:		a gw pointer value
	-- markerColor:	a color value
	-- lineColor:	a color value
	
-- returns:			no return value

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
	
	
--------------------------------------------------------------------------------------------------
-- drawVptLineArr:	draws multiple lines on the viewport

-- arguments:
	-- arr:			an array of arrays of Point3s in viewport-coords
	-- 				array (line) > array (point3) > point3
	-- colors:		an array of color values

-- returns:			no return value

	fn drawVptLineArr arr colors:#() =
		(
		for i = 1 to arr[1].count do
			(
			local line = for j = 1 to arr.count collect arr[j][i]
			local lineColor = if colors[i] != undefined then
				drawVptLine line lineColor:lineColor
			else
				drawVptLine line
			)
		)



--------------------------------------------------------------------------------------------------
-- showVertexOrder:	visually shows teh vertex order in the viewport 

-- arguments:
	-- obj:			any object that can be converted to a mesh

-- returns:			no return value

	fn showVertexOrder obj =
		(
		local p, objMesh
		objMesh = snapshotAsMesh obj
		gw.setTransform(Matrix3 1)
		for i = 1 to getnumverts objMesh do
			(
			local p		= gw.wTransPoint (getVert objMesh i)
			local txt	= "Vert: " + i as string
			
			gw.wText (p + [-1,0,0]) txt color:black
			gw.wText (p + [1,0,0]) txt color:black
			gw.wText (p + [0,-1,0]) txt color:black
			gw.wText (p + [0,1,0]) txt color:black
			
			gw.wText (p + [-1,-1,0]) txt color:black
			gw.wText (p + [1,1,0]) txt color:black
			gw.wText (p + [1,-1,0]) txt color:black
			gw.wText (p + [-1,1,0]) txt color:black

			gw.wText (p + [0,0,0]) txt color:white

			gw.wMarker p #plusSign color:black
			)
			
		gw.resetUpdateRect()
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
		)

--------------------------------------------------------------------------------------------------
-- examples

	fn testVpt =
		(
		-- times
			t1	= 0
			t2	= 100
		
		-- show position of an object
			arr1 = getVptObjPos geometry[1] t1 t2
			drawVptLine arr1 lineColor:green
	
			--arr2 = getVptObjPos geometry[1] t1 t2
			--drawVptLine arr2 lineColor:red
	
			
		-- show position of a mesh point
			arrMesh	= getMeshPoints geometry[1] t1 t2
			arrVert	= for j = 1 to arrMesh.count collect arrMesh[j][3]
			
			arr = getVptPoints arrVert t1 t2
			drawVptLine arr lineColor:blue
			
		-- show position of lots of mesh points
			arrMesh	= getMeshPoints geometry[1] t1 t2
			arrMeshVpt = getVptPointsArr arrMesh t1 t2
			drawVptLineArr arrMeshVpt
		)
