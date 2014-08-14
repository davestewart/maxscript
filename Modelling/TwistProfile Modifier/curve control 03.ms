

rollout roCC "Curve Control"
	(

	-------------------------------------------------------------------------------------
	-- interface
	-------------------------------------------------------------------------------------
	
		CurveControl cc1 "" 
			height:			400
			width:			800
			align:			#left
			numCurves:		1
			visible:		true
			x_range:		[0,1000]
			y_range:		[-3600,3600]
			scrollValues:	[-100,100]
		 
			commandMode:	#move_xy	-- #move_xy, #move_x, #move_y, #scale, #corner, bezier
			uiFlags:		#(#drawBG, #drawgrid, #upperToolbar, #lowerToolbar, #showReset, #scrollBars, #autoScroll, #ruler, #constrainY, #hideDisabled, #all, #xvalue, #singleSelect, #noFilterButtons)
							-- #drawBG, #drawgrid, #upperToolbar, #showReset, #lowerToolbar, #scrollBars, #autoScroll, #ruler, #constrainY, #hideDisabled, #all, #xvalue, #singleSelect, #noFilterButtons
			rcmFlags:		#(#delete)	-- #move_xy, #move_x, #move_y, #scale, #corner, #bezier, #delete, #all
			asPopup: false
	

		button btnFlatten "Flatten tangents" width:200 height:20


	-------------------------------------------------------------------------------------
	-- functions
	-------------------------------------------------------------------------------------

	-- get
		fn saveCurve m c = -- m:modifier, c:curve control
			(
			local p
			for i = 1 to c.points.count do
				(
				p						= c.points[i].value
				m.twistVals[i]			= point3 p.x p.y 0
				
				p						= c.points[i].inTangent
				m.twistValsIn[i]		= point3 p.x p.y 0
			
				p						= c.points[i].outTangent
				m.twistValsOut[i]		= point3 p.x p.y 0
			 	)
			)
		
	-- set
		fn loadCurve m c = -- m:modifier, c:curve control
			(
			local p
			for i = 1 to c.points.count do
				(
				p						= m.twistVals[i]
				c.points[i].value		= point2 p.x p.y
		
				p						= m.twistValsIn[i]
				c.points[i].inTangent	= point2 p.x p.y
		
				p						= m.twistValsOut[i]
				c.points[i].outTangent	= point2 p.x p.y
			 	)
			)
			
			function updateModifier =
				(
				zoom cc1 #all
				try($.modifiers[1].twist += 0)
				catch()
				)
				
			fn flattenTangents cc ci =	-- cc:curvecontrol, ci:curve index
				(
				local arrPoints = getSelectedPts cc.curves[ci]
				for pi = 1 to arrPoints.count do
					(
					if arrPoints[pi] == true then
						(
						local p = getPoint cc.curves[ci] pi
						p.inTangent = p.inTangent * [1,0]
						p.outTangent = p.outTangent * [1,0]
						print p.outTangent
						)
					)

				)
				
			fn createTestCurve cc ci name:"Curve" col:black=
				(
				-- Initialize curve properties
					local numPoints		= 10
					local crv			= cc.curves[ci]
					 
					crv.name			= name
					crv.color			= col
					crv.disabledColor	= col * 0.5
					crv.style			= #solid
					
				-- draw curve
					crv.numPoints		= numPoints
					local span			= cc.x_range[2] / (numPoints - 1)
					for i = 1 to numPoints do
						(
						local x			= span * (i - 1)
						local y			= random -360 360
						crv.points[i].value	= [x,y]
						crv.points[i].bezier = true
						crv.points[i].corner = false
						)
				-- stuff
					--local del = (cc1.x_range.y - cc1.x_range.x)/(crv.numPoints-1)
					-- format "del:%\n" del
					-- Place intermediate points equally spaced
				)

	-------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------
	 	on btnFlatten pressed do flattenTangents cc1 1
			
		on roCC open do 
			(
			createTestCurve cc1 1 name:"Twist" col:red 
			zoom cc1 #all
			print "Opened: " + cc1.name
			)
	 
	 
		-- Curve control event handlers
			on cc1 ptChanged ci val do				updateModifier()
			on cc1 tangentChanged ci val type do	updateModifier()
			on cc1 reset ci do						updateModifier()
			on cc1 selChanged ci val do				updateModifier()

		/*
			on cc1 selChanged ci val do format "curve % numSelected : %\n" ci val
			on cc1 tangentChanged ci val type do format "curve % tangentChanged : % %\n" ci val (type as string)
			on cc1 deleted ci pi do format "curve % deleted : %\n" ci pi
			on cc1 reset ci do format "curve % resetted\n" ci
		*/
	)
 
createdialog roCC 820 440


/*

setproperty roCC.cc1 #x_range [0,500]

roCC.cc1.curves[1].points[2].value = [100,0]
roCC.cc1.curves[1].points[2].value = [100,0]

roCC.cc1.curves[1].points[2].end

getValue roCC.cc1.curves[1] 0 500

roCC.cc1.curves[1].width = 2
roCC.cc1.curves[1].color = red

roCC.cc1.curves[1].style = #solid --#solid, #dash, #dot, #dashDot, #dashDotDot, #null, #insideFrame



-- vars
	twistMod = $.modifiers[1]
	twistCrv = roCC.cc1.curves[1]
	

	
	
twistMod.twistValsIn

getValue roCC.cc1.curves[1] 0 750

roCC.cc1.curves[1].points[2].value
roCC.cc1.curves[1].points[2].inTangent
roCC.cc1.curves[1].points[2].outTangent

twistMod 
*/
