(
fn getVertScreenPos obj i resetMatrix:false =
(
	if resetMatrix == true then	gw.setTransform(Matrix3 1)
	local p = getVert obj.baseobject.mesh i
	p += obj.objectOffsetPos
	p *= obj.transform
	return gw.wTransPoint p
)

fn getScreenPos obj resetMatrix:false =
(
	if resetMatrix == true then	gw.setTransform(Matrix3 1)
	local p = obj.pos
	return gw.wTransPoint p
)


fn getViewportSize =
(
	return [gw.getWinSizeX(),gw.getWinSizeY()]
)


fn clearScreen =
(
	local w = gw.getWinSizeX()
	local h = gw.getWinSizeY()
	gw.clearScreen (Box2 0 0 w h)
)

fn showVertexOrder obj =
(
	gw.resetUpdateRect()
	gw.enlargeUpdateRect #whole
	gw.setTransform(Matrix3 1)
	for i = 1 to getnumverts obj.baseobject.mesh do
	(
		local p = getVertScreenPos obj i
		gw.wText p ("Vert: " + i as string) color:red
		gw.wMarker p #plusSign color:red
	)
		
	gw.updateScreen()
)
	


fn showObjectPath obj start:animationRange.start end:animationRange.end =
(
	-- screen
		gw.setTransform(Matrix3 1)
		gw.enlargeUpdateRect #whole
	
	-- positions
		local arrPos = for t = start to end collect at time t (getScreenPos obj)
	
	-- line
		gw.setColor #line red
		gw.wPolyline arrPos false
		gw.updateScreen()
		
	-- points
		for p in arrPos do gw.wMarker p #PlusSign color:white
		gw.updateScreen()
		
	-- return
		return arrPos
)


fn showVertexPath obj start:animationRange.start end:animationRange.end =
(
	-- screen
		gw.setTransform(Matrix3 1)
		gw.enlargeUpdateRect #whole
	
	-- positions
		local numVerts = getnumverts obj.baseobject.mesh
		local arrVerts = for i = 1 to numVerts collect
		(
			for t = start to end collect
			(
				with redraw off
				(
					slidertime = 1
					--at time t 
					local p = (getVertScreenPos obj i resetMatrix:true)
					gw.wMarker p #point color:white
					gw.updateScreen()
					p
				)
			)
		)
		
	-- lines
		gw.setColor #line black --(white * 0.75)
		for arrPos in arrVerts do gw.wPolyline arrPos false
		gw.updateScreen()
		
	-- points
		for arrPos in arrVerts do
		(
			for p in arrPos do gw.wMarker p #point color:white
		)
		gw.updateScreen()
		
	-- return
		return arrVerts
)


arrVerts = showVertexPath objects[1]
/*
arrPos = showObjectPath objects[1]

arrVerts.count

t1 = timestamp()
t2 = timestamp()
format "%\n" (t2 - t1)


gw.getWinSizeX() as float

p = getVert $.baseobject.mesh 1
pt = point transform:($.transform)
pt.pos+=p
*/
)