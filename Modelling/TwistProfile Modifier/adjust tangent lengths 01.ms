

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
