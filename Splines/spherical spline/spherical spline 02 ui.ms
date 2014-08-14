rollout roSphereSpline "Sphere Spline" width:162 height:300
	(
	--------------------------------------------------------------------------------------------
	-- UI
		spinner spnTurns "Turns" fieldWidth:50 height:16 range:[0,200,10] align:#right
		spinner spnRadius "Radius" fieldwidth:50 height:16 range:[0,1000,100] align:#right
		spinner spnSegments "Segments" fieldwidth:50 height:16 range:[1,1000,200] align:#right type:#integer
		radiobuttons rdoVertex labels:#("Smooth", "Corner") align:#left
		radiobuttons rdoSegment labels:#("Curve", "Line") align:#left
		button btnNew "Create new"
		button btnNewMouse "Create with mouse"

	--------------------------------------------------------------------------------------------
	-- variables
	
		local ss
		local radius, turns, segments
		local pt1, pt2

	--------------------------------------------------------------------------------------------
	-- utilities

		fn getCircleRadius pt1 pt2 =
			(
			local xy	= pt2 - pt1
			local r		= sqrt ((xy.x * xy.x) + (xy.y * xy.y))
			r
			)
		
		
		fn mouseDrag msg ir obj faceNum shift ctrl alt cb = 
			(
			-- stop
				if msg == #mousePoint then
					(
					return pt2
					)
			-- start
				else(
					pt2				= ir.pos
					radius			= getCircleRadius pt1 pt2
					spnRadius.value	= radius
					create()
					)
				#continue
			)
		


	--------------------------------------------------------------------------------------------
	-- functions
		fn sphereSpline =
		(
		-- variables
			local knots		= #()
			local lineType	= #(#curve, #line)[rdoSegment.state]
			local vertType	= #(#smooth, #corner)[rdoVertex.state]
			
		-- code
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
						addknot ss 1 vertType lineType [x, y, z]
						append knots [x, y, z]
					)
		
			-- finalise
				updateshape ss
				--ss.vertexTicks = vertexTicks
				--select ss
				)
		
		function resetSphereSpline=
			(
			if numsplines ss > 0 do deleteSpline ss 1
			addnewspline ss
			)

		function getValues =
			(
			radius		= spnRadius.value
			turns		= spnTurns.value
			segments	= spnSegments.value
			)
			
		function create = 
			(
			if isValidNode ss do
				(
				resetSphereSpline()
				getValues()
				sphereSpline()
				)
			)
			
		function

	--------------------------------------------------------------------------------------------
	-- handlers

		on roSphereSpline open do
			(
			ss = splineshape()
			create()
			select ss
			)
			
		on btnNew pressed do
			(
			ss = splineshape()
			create()
			select ss
			)
			
		on btnNewMouse pressed do
			(
			pt1			= pickpoint()
			pt2			= mouseTrack trackCallback:mouseDrag
			)

		on spnRadius changed val do create()
		on spnTurns changed val do create()
		on spnSegments changed val do create()
		on rdoVertex changed index do create()
		on rdoSegment changed index do create()

	)


try(destroydialog roSphereSpline)
catch()
createdialog roSphereSpline
