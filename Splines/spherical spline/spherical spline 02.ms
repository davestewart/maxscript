-- script:	spherical spline
-- author:	dave stewart
-- date:	18th december 2006
-- max:		5+

knots		= #()	
fn sphereSpline radius turns segments vertexTicks:off =
(
-- variables
	local ss
	
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
					s = cos va	-- horizontal scale
					x = sin(ha) * radius * s
					y = cos(ha) * radius * s
	
			-- do it		
				addknot ss 1 #smooth #curve [x, y, z]
				append knots [x, y, z]
		)

	-- finalise
		updateshape ss
		ss.vertexTicks = vertexTicks
		select ss
		return ss
	)
		
radius		= 150
turns		= 20
segments	= 500
		
ss = sphereSpline radius turns segments



-- add knots

ss2 = splineshape()

vSpans = (segments / turns)

for i = 0 to vSpans - 1 do
(
	addnewspline ss2
--	format "%\n" (i as string)
	si = i + 1
	addknot ss2 si #corner #curve knots[1] -- top knot
	for j = 1 to knots.count - 1 by (segments / turns) do
	(
		ki = i + j
		--format "%	%\n" (si as string) (ki as string)
		addknot ss2 si #corner #curve knots[ki]
	)
	addknot ss2 si #corner #curve knots[knots.count]
)
	
updateshape ss2
ss2.wirecolor = ss.wirecolor * 0.65
ss2.vertexTicks = on
select ss2
