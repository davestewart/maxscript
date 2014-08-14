-- variables
	ss = splineshape()
	addnewspline ss
	
	radius		= 150
	turns		= 10
	segments	= 100
	
	knots		= #()

-- code
	for i = 0 to segments do
	(
		-- variables
			pc = i / (segments as float)
	
		-- horizontal	
			a = (360.0 * turns) * pc
			x = sin(a) * radius
			y = cos(a) * radius

		-- vertical		
			a = (180.0 * pc) - 90
			z = sin a * radius

		-- do it		
			format "%\n" z
			addknot ss 1 #smooth #curve [x, y, z]
	)
		
	updateshape ss