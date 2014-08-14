ccPoint <pt_point2> <in_point> <out_point2> \ 

[bezier:<false>] [corner:<false>] [lock_x:<false>] \

[lock_y:<false>] \ [select:<false>] [end:<false>] \

[noXConstraint:<false>]


fn setPointType cc ci pi bezier corner =
	(
	local p		= cc.curves[ci].points[pi]
	local pVal	= p.value
	local pIn	= p.inTangent
	local pOut	= p.outTangent
	local pNew	= ccPoint pVal pIn pOut bezier:true select:true
	setPoint cc.curves[ci] pi pNew
	)

setPointType roCC.cc1 1 6 true true

for i = 1 to 10 do
	(
	roCC.cc1.curves[1].points[i].intangent = [-40,0]
	roCC.cc1.curves[1].points[i].outtangent = [40,0]
	roCC.cc1.curves[1].points[i].corner = true
	roCC.cc1.curves[1].points[i].bezier = true
	)

for i = 1 to 10 do
	(
	roCC.cc1.curves[1].points[i].outtangent = [40,0]
	)
	
for i = 1 to 10 do
	(
	roCC.cc1.curves[1].points[i].intangent = [-40,0]
	)


show roCC.cc1.curves[1].points[5]--.outtangent-- = [40,0]

roCC.cc1.curves[1].points[5].lock_x = false
roCC.cc1.curves[1].points[5].noXConstraint = false
