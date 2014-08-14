(

iSize	= point2 renderWidth renderHeight
vSize	= point2 (gw.getWinSizeX()) (gw.getWinSizeY())
r		= [0.5,0.5]

iAspect	= iSize.x / iSize.y
vAspect	= vSize.x / vSize.y

print vAspect

x = vSize.x * r.x
y = vSize.y * r.y

if vAspect >= iAspect then
(
	-- viewport is wider than image, so take away from x
	v = vSize.y --* iAspect
	x = vSize.x - (v / 2)
)
else
(
	-- viewport is higher than image, so take away from y
	v = vSize.x --* iAspect
	y = vSize.y - (v / 2)
)

gw.wMarker [x,y,0] #plusSign 
gw.enlargeUpdateRect #whole
gw.updateScreen()
)
