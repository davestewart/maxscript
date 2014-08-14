fn flattenSelPoints cc ci =
	(
	local baPoints = getSelectedPts cc.curves[ci]
	for pi in baPoints do
		(
		local p		= cc.curves[ci].points[pi]
		local pVal	= p.value
		local pIn	= p.inTangent * [1,0]
		local pOut	= p.outTangent * [1,0]
		local pCorn	= pi == 1 OR pi == cc.curves[ci].points.count
		
		local pNew	= ccPoint pVal pIn pOut bezier:true corner:pCorn select:true
		
		setPoint cc.curves[ci] pi pNew
		)
	)
	
fn getSelPoints cc ci =
	(
	local baPoints = getSelectedPts cc.curves[ci]
	local arrPoints = for i in baPoints collect cc.curves[ci].points[i]
	return arrPoints
	)
	
fn alignSelPoints cc ci =
	(
	local arrPoints = getSelPoints cc ci
	local y = arrPoints[1].value.y
	for p in arrPoints do p.value = [p.value.x,y]
	)
	
fn averageSelPoints cc ci =
	(
	local arrPoints = getSelPoints cc ci
	local y = 0.0
	for p in arrPoints do y += p.value.y
	y = y / arrPoints.count
	for p in arrPoints do p.value = [p.value.x,y]
	)
	
alignSelPoints roCC.cc1 1
averageSelPoints roCC.cc1 1
flattenSelPoints roCC.cc1 1


roCC.cc1.curves[1].points[9].intangent = [-45.7832,0]
roCC.cc1.curves[1].points[9].outtangent = [0,0]

