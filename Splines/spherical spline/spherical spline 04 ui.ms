-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Spherical Spline
-- Description
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		1.0
-- max version:	all
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
--
-- history:		18th Dec 2006 - created
--
-------------------------------------------------------------------------------------------------------------------------------

try(destroydialog roSphereSpline);catch()
rollout roSphereSpline "Sphere Spline" width:192 height:338

	(
	--------------------------------------------------------------------------------------------
	-- UI
	
		GroupBox grpParams "Parameters" pos:[8,8] width:176 height:80
			spinner spnRadius "Radius" pos:[80,24] width:95 height:16 range:[0,1000,100] fieldwidth:50
			spinner spnTurns "Turns" pos:[86,45] width:89 height:16 range:[0,200,10] fieldwidth:50
			spinner spnSegments "Segments" pos:[66,66] width:109 height:16 range:[1,1000,200] type:#integer fieldwidth:50
	
		GroupBox grpSplines "Splines" pos:[8,96] width:176 height:80
			label lblVerts "Verts:" pos:[16,112] width:32 height:16
			radiobuttons rdoVertex "" pos:[56,112] width:138 height:16 labels:#("Smooth", "Corner") columns:2
			label lblSegs "Segs:" pos:[16,128] width:32 height:16
			radiobuttons rdoSegment "" pos:[56,128] width:112 height:16 labels:#("Curve", "Line") columns:2
			checkbox chkSpans "Create vertical spans" pos:[16,152] width:123 height:15
	
		GroupBox grpCreate "Splines" pos:[8,184] width:176 height:72
			button btnNew "Create new" pos:[16,200] width:160 height:21
			button btnNewMouse "Create with mouse" pos:[16,224] width:160 height:21
		
		GroupBox grpAbout "About" pos:[8,264] width:176 height:64
			ActiveXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[16,280] width:160 height:40


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
			
		-- about
			fn initAbout =
				(
				local col = colorMan.getColor #background
				axFlash.BackgroundColor = ((col.x * 65536) + (col.y * 256) + col.z) * 255
				try(
					local mov		= "http://www.davestewart.co.uk/images/web/davestewart.swf"
					axFlash.movie	= mov
					axFlash.movie	= mov
					axFlash.SAlign	= "ML"
					axFlash.Menu	= false
					);
				catch()
				)

	--------------------------------------------------------------------------------------------
	-- handlers

		on roSphereSpline open do
			(
			initAbout()
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
