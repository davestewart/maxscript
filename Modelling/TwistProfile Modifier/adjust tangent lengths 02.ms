

-- the point
	p = roCC.cc1.curves[1].points[2]
	p.corner = true

-- original dimensions
	x1 = 40.0
	y1 = 30.0

-- plot the point
	t		= p.inTangent = [x1,y1]

-- get the radius and angle
	r1 = sqrt (x1^2 + y1^2)
	a = atan (y1 / x1)

-- plot new points
	r2 = 300
	x2 = cos a * r2
	y2 = sin a * r2

-- plot the point
	t = p.outtangent = [x2,y2]


fn setTangentLength p r type:#in=
	(
	-- original dimensions
		local t		= if type == #in then p.inTangent else p.outTangent
		local x1	= t.x
		local y1	= t.y
		
		format "lengths 1: % %\n" x1 y1
		
	-- get the radius and angle
		local a		= atan (y1 / x1)
	
	-- plot new points
		local x2 = cos a * r
		local y2 = sin a * r
	
		format "lengths 2: % %\n" x2 y2
	-- plot the point
		if type == #in then 	p.inTangent = [-x2,-y2]
		else 					p.outTangent = [x2,y2]
	)


fn getTangentLengths cc ci type:#in =
	(
	
	return val
	)

p = roCC.cc1.curves[1].points[2]
setTangentLength p (random 50 200) type:#in
setTangentLength p (random 50 200) type:#out
