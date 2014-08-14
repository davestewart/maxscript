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
	


fn showObjectPath obj =
(
	gw.setTransform(Matrix3 1)

	local pArr = #()

	for t = 1 to 75 do
	(
		at time t 
		(
			local p = getScreenPos obj
			append pArr p
		)
	)
	
	gw.enlargeUpdateRect #whole

	gw.setColor #line red
	gw.wPolyline pArr false
	gw.updateScreen()
	
	for p in pArr do gw.wMarker p #PlusSign color:white
	gw.updateScreen()
)


fn showVertexPath obj =
(
	gw.setTransform(Matrix3 1)
	local numVerts = getnumverts obj.baseobject.mesh
	for t = 1 to 75 do
	(
		at time t
		(
			for i = 1 to numVerts do
			(
				local p = getVertScreenPos obj i
				gw.wMarker p #plusSign 
	
				local p = getScreenPos obj
				gw.wMarker p #circle color:green
			)
		)
		--format "[%,%]\n" p.x p.y
	)
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
)
	
/*

showVertexPath objects[1]
showObjectPath objects[1]

gw.getWinSizeX() as float

p = getVert $.baseobject.mesh 1
pt = point transform:($.transform)
pt.pos+=p
*/