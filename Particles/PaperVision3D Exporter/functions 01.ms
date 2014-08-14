
function trajectoryAsArray obj =
	(
	local arr	= for t = 0 to animationrange.end collect at time t obj.pos
	arr
	)

function tragectoryToSpline arr =
	(
	-- spline
		local ss		= SplineShape pos:arr[1]
		addNewSpline ss
		
	-- knots
		for i = 1 to arr.count do
			(
			for i = 1 to 100 do addKnot ss 1 #corner #line arr[i]
			)
		updateShape ss
		
	-- return
		ss
	)

function particleTrajectoryToArray pf index =
	(
	local arr	= for t = 0 to animationrange.end collect at time t pf.getParticlePositionByID index
	arr
	
	)
