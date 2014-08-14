
--p = point pos:p3
--gw.hMarker p3 #hollowBox color:yellow
--gw.setTransform ss.transform
gw.Marker p3 #smallDiamond
gw.enlargeUpdateRect #whole
gw.updateScreen()




ss = shapes[1]
p3 = lengthInterp ss 1 0.5

gw.setTransform(Matrix3 1)
gw.htransPoint p3

gw.hMarker p3 #smallDiamond
gw.enlargeUpdateRect #whole
gw.updateScreen()


gw.getTransform()-- (identity $.transform)


arr = #("point","hollowBox","plusSign","asterisk","xMarker","bigBox","circle","triangle","diamond","smallHollowBox","smallCircle","smallTriangle","smallDiamond" )

for i=1 to arr.count do
	(
	local p = [100, (50 + i*10), 0]
	format "p: %\n" p
	local marker = (arr[i] as name)
	gw.hMarker p marker
	)
gw.enlargeUpdateRect #whole
gw.updateScreen()


for i=1 to arr.count do gw.hMarker p3 (arr[i] as name)
gw.enlargeUpdateRect #whole
gw.updateScreen()



worldToScreen

p3

$.pos = [100, 120, 50]
