-- script:	spherical spline
-- author:	dave stewart
-- date:	18th december 2006
-- max:		5+


-- variables
	radius		= 150
	turns		= 20
	segments	= 500
	knots		= #()
	
-- code
	-- spline
		ss = splineshape()
		addnewspline ss

	-- knots	
		for i = 0 to segments do
			(
			-- %
				pc = i / (segments as float)
		
			-- angles
				-- vertical
					va = (180.0 * pc) - 90
					
				-- horizontal
					ha = (360.0 * turns) * pc
		
			-- knots
				-- vertical
					z = sin va * radius
	
				-- horizontal
					s = cos va
					x = sin(ha) * radius * s
					y = cos(ha) * radius * s
	
			-- do it		
				addknot ss 1 #smooth #curve [x, y, z]
				append knots [x, y, z]
			)

	-- finalise
		updateshape ss
		ss.vertexTicks = on
		select ss