rollout roCC "Twist Profile - profile" width:816 height:464
(

	-------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------
	
		local theMod

	-------------------------------------------------------------------------------------
	-- interface
	-------------------------------------------------------------------------------------
	
		CurveControl cc1 "" 
			pos:			[13,7]
			width:			800
			height:			396
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

			
		GroupBox grpPoints "Points" pos:[16,416] width:304 height:40
			label lblAlign "Align to: " pos:[24,432] width:40 height:16
			button btnAlignFirst "First" pos:[64,432] width:40 height:16
			button btnAlignLast "Last" pos:[104,432] width:40 height:16
			button btnAverage "Average" pos:[148,432] width:64 height:16
			checkbox chkFlatten "Flatten tangents" pos:[216,432] width:96 height:16 checked:true
				
		GroupBox grpTangents "Tangents" pos:[328,416] width:280 height:40
			spinner spnLengthIn "In: " pos:[328,432] width:72 height:16 range:[0,1000,50] fieldwidth:40 --indeterminate:true
			spinner spnLengthOut "Out: " pos:[408,432] width:72 height:16 range:[0,1000,50] fieldwidth:40 --indeterminate:true
			
			checkbox chkLockLengths "Lock" pos:[488,432] width:56 height:16 checked:false
			button btnFlatten "Flatten" pos:[536,432] width:64 height:16

		GroupBox grpCurves "Display" pos:[616,416] width:156 height:40
			checkButton ckbAutoZoom "Auto-Zoom" pos:[624,432] width:136 height:16 highlightColor:(color  255 200 0) checked:true
			
		button btnDone "Done" pos:[779,421] width:34 height:34
		
		
	-------------------------------------------------------------------------------------
	-- point functions
	-------------------------------------------------------------------------------------
	
		fn flattenSelPoints cc ci =
			(
			local baPoints = getSelectedPts cc.curves[ci]
			for pi in baPoints do
				(
				local p		= cc.curves[ci].points[pi]
				local pVal	= p.value
				local pIn	= p.inTangent * [1,0]
				local pOut	= p.outTangent * [1,0]
				local pCorn	= pi == 1 OR pi == cc.curves[ci].points.count
				local pNew	= ccPoint pVal pIn pOut bezier:true corner:pCorn select:true
				setPoint cc.curves[ci] pi pNew
				)
			)
			
		fn getSelPoints cc ci =
			(
			local baPoints = getSelectedPts cc.curves[ci]
			local arrPoints = for i in baPoints collect cc.curves[ci].points[i]
			return arrPoints
			)
			
		fn alignSelPoints cc ci align:#first =
			(
			local arrPoints = getSelPoints cc ci
			if arrPoints.count == 0 then return false
			local i = if align == #last then arrPoints.count else 1
			local y = arrPoints[i].value.y
			for p in arrPoints do p.value = [p.value.x,y]
			)
			
		fn averageSelPoints cc ci =
			(
			local arrPoints = getSelPoints cc ci
			if arrPoints.count == 0 then return false
			local y = 0.0
			for p in arrPoints do y += p.value.y
			y = y / arrPoints.count
			for p in arrPoints do p.value = [p.value.x,y]
			)
			
		fn adjustTangentLength cc ci val type =
			(
			local arrPoints = getSelPoints cc ci
			if arrPoints.count == 0 then return false
			for p in arrPoints do
				(
				--if type == #in then p.inTangent = 
				p.inTangent		= [-val,0]
				p.outTangent	= [val,0]
				p.bezier		= true
				)
			)
		
	-------------------------------------------------------------------------------------
	-- curve functions
	-------------------------------------------------------------------------------------

		fn createTestCurve cc ci name:"Curve" col:black=
			(
			-- Initialize curve properties
				local numPoints		= 5
				local crv			= cc.curves[ci]
				 
				crv.name			= name
				crv.color			= col
				crv.disabledColor	= col * 0.5
				crv.style			= #solid
				
			-- draw curve
				crv.numPoints		= numPoints
				local span			= cc.x_range[2] / (numPoints - 1)
/*
*/
				for i = 1 to numPoints do
					(
					local x			= span * (i - 1)
					local y			= random -180 180
					local p			= crv.points[i]
					p.value			= [x,y]
					p.bezier		= true
					p.corner		= false
					p.inTangent		= [-span/3.0,0]
					)
				for i = 1 to numPoints do
					(
					local p			= crv.points[i]
					p.outTangent	= [span/3.0,0]
					)
			)
		
		-- save curve to paramblock
			fn saveCurve m c = -- m:modifier, c:curve
				(
				local p
				m.twistVals.count = c.points.count
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
			
		-- load curve from paramblock
			fn loadCurve m c = -- m:modifier, c:curve
				(
				local p
				c.numPoints = m.twistVals.count
				for i = 1 to m.twistVals.count do
					(
					p						= m.twistVals[i]
					c.points[i].value		= point2 p.x p.y
			
					p						= m.twistValsIn[i]
					c.points[i].inTangent	= point2 p.x p.y
			
					p						= m.twistValsOut[i]
					c.points[i].outTangent	= point2 p.x p.y
				 	)
				)
				
	-------------------------------------------------------------------------------------
	-- modifier functions
	-------------------------------------------------------------------------------------
		
		function updateModifier =
			(
			if ckbAutoZoom.checked then zoom cc1 #all
			if theMod != undefined then theMod.valTwist += 0
--			try($.modifiers[1].valTwist += 0)
--			catch(print "failed to update modifier")
			)
			
			
	-------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------
			
		-- Curve control event handlers
		
			on cc1 ptChanged ci val do				updateModifier()
			on cc1 tangentChanged ci val type do	updateModifier()
			on cc1 reset ci do						updateModifier()
			on cc1 selChanged ci val do				updateModifier()

			
		-- buttons
		
			on btnAlignFirst pressed do
				(
				alignSelPoints cc1 1 align:#first
				if chkFlatten.checked then flattenSelPoints cc1 1
				)
				
			on btnAlignLast pressed do
				(
				alignSelPoints cc1 1 align:#last
				if chkFlatten.checked then flattenSelPoints cc1 1
				)
				
			on btnAverage pressed do
				(
				averageSelPoints cc1 1
				if chkFlatten.checked then flattenSelPoints cc1 1
				)
				
			on btnFlatten pressed do
				(
				flattenSelPoints cc1 1
				)
				
			on spnLengthIn changed val do adjustTangentLength cc1 1 val #in

			on spnLengthOut changed val do adjustTangentLength cc1 1 val #out
			
			on btnDone pressed do
				(
			
				)
			
		-- rollout
		
			on roCC open do
				(
				createTestCurve cc1 1 name:"Twist" col:red 
				zoom cc1 #all
				)
	


)
--createdialog roCC 
