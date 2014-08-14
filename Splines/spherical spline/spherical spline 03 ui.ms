try(destroydialog roSphereSpline);catch()



rollout roSphereSpline "Sphere Spline" width:162 height:300
(
	--------------------------------------------------------------------------------------------
	-- UI
		spinner spnTurns "Turns" fieldWidth:50 height:16 range:[0,200,10] align:#right
		spinner spnRadius "Radius" fieldwidth:50 height:16 range:[0,1000,100] align:#right
		spinner spnSegments "Segments" fieldwidth:50 height:16 range:[1,1000,200] align:#right type:#integer
		radiobuttons rdoVertex labels:#("Smooth", "Corner") align:#left
		radiobuttons rdoSegment labels:#("Curve", "Line") align:#left
		checkbox chkSpans "Create vertical spans"
		button btnNew "Create new"
		button btnNewMouse "Create with mouse"

	--------------------------------------------------------------------------------------------
	-- variables
	
		local ss
		local radius, turns, segments
		local pt1, pt2
		local knots
		local update -- predeclare for mousetrack!

	--------------------------------------------------------------------------------------------
	-- utilities

		fn getCircleRadius pt1 pt2 =
		(
			local xy	= pt2 - pt1
			local r		= sqrt ((xy.x * xy.x) + (xy.y * xy.y))
			r
		)
		
		fn mouseDrag msg ir obj faceNum shift ctrl alt = 
		(
			--format "%\n" msg
			-- stop
				if msg == #mousePoint do
				(
					return pt2
				)
			-- start
				pt2				= ir.pos
				radius			= getCircleRadius pt1 pt2
				spnRadius.value	= radius
				update()
				--format "%\n" radius
			-- continue
				#continue
		)
		


	--------------------------------------------------------------------------------------------
	-- functions
		fn sphereSpline =
	(
		-- variables
			local lineType	= #(#curve, #line)[rdoSegment.state]
			local vertType	= #(#smooth, #corner)[rdoVertex.state]
			
		-- code
			-- knots
				knots = #()
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
							
						-- final
							kt	= [x, y, z] + pt1
			
					-- do it
						addknot ss 1 vertType lineType kt
						append knots kt
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
			
		function update =
		(
			if isvalidnode ss do
			(
				resetSphereSpline()
				getValues()
				sphereSpline()
			)
		)
			
		function create = 
		(
			ss 			= splineshape()
			ss.pos		= pt1
			select ss
			update()
		)
			
			
	function createSpans =
	(
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
	)
			
/*
*/
	--------------------------------------------------------------------------------------------
	-- handlers

		on roSphereSpline open do
		(
			--create()
		)
			
		on btnNew pressed do
		(
			pt1	= [0,0,0]
			create()
			update()
			if chkSpans.checked do createSpans()
		)
			
		on btnNewMouse pressed do
		(
			pt1			= pickpoint()
			create()
			pt2			= mouseTrack trackCallback:mouseDrag
			if chkSpans.checked do createSpans()
		)

		on spnRadius changed val do update()
		on spnTurns changed val do update()
		on spnSegments changed val do update()
		on rdoVertex changed index do update()
		on rdoSegment changed index do update()

)


createdialog roSphereSpline
