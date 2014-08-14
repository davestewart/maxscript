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



obj = $
for i = 1 to getnumverts mesh1 do
(
	local p = getVertScreenPos obj i
	gw.wText p ("Vert: " + i as string)
	gw.wMarker p #plusSign 
)
	
gw.enlargeUpdateRect #whole
gw.updateScreen()
	

$.objectTransform 

(
gw.setTransform(Matrix3 1)
local numVerts = getnumverts obj.mesh
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
)

gw.enlargeUpdateRect #whole
gw.updateScreen()

gw.getWinSizeX() as float

p = getVert $.baseobject.mesh 1
pt = point transform:($.transform)
pt.pos+=p
