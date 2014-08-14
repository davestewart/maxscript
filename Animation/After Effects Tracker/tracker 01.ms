obj1 = $
mesh1 = obj.baseobject.mesh
points = #()
for i = 1 to getnumverts mesh1 do
(
	local p = getVert mesh1 i
	p += obj.objectOffsetPos
	p *= obj1.transform
	--pt = point pos:p
	--append points pt
	
	gw.setTransform(Matrix3 1)
	p = gw.wTransPoint p
	gw.wText p ("Vert: " + i as string)
	gw.wMarker p #plusSign 
)
	
gw.enlargeUpdateRect #whole
gw.updateScreen()
	
delete points
$.pivot - $.pos
obj1.pos


$.objectTransform 

for t = 1 to 75 do
(
	at time t p = $.pos
	gw.setTransform(Matrix3 1)
	p = gw.wTransPoint p
	format "[%,%]\n" p.x p.y
	gw.wMarker p #circle
)
--gw.enlargeUpdateRect #whole
--gw.updateScreen()

gw.getWinSizeX() as float

p = getVert $.baseobject.mesh 1
pt = point transform:($.transform)
pt.pos+=p
