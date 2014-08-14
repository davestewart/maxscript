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
			
		-- button btnLoad "Load" pos:[779,421] width:34 height:17
		-- button btnSave "Save" pos:[779,438] width:34 height:17
		
		
	-------------------------------------------------------------------------------------
	-- point / tangent functions
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
			
		fn setTangentLength cc ci val type:#in =
			(
			-- get points
				--format "% % %\n" cc ci val 
				local arrPoints = getSelPoints cc ci
				if arrPoints.count == 0 then return false
				
			-- set lengths
				for p in arrPoints do
					(
					-- original dimensions
						local t		= if type == #in then p.inTangent else p.outTangent
						local x1	= t.x
						local y1	= t.y
						
					-- get the radius and angle
						local a		= atan (y1 / x1)
					
					-- plot new points
						local x2 = cos a * val
						local y2 = sin a * val
					
					-- plot the point
						if type == #out OR p.corner == false then
						 	p.outTangent = [x2,y2]
						else
							p.inTangent = [-x2,-y2]				
					)
			)

		
	-------------------------------------------------------------------------------------
	-- curve functions
	-------------------------------------------------------------------------------------

		fn createTestCurve cc ci name:"Curve" col:black numPoints:10 =
			(
			-- Initialize curve properties
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
					local y			= random -180 180
					local p			= crv.points[i]
					p.bezier		= true
					p.corner		= false
					p.value			= [x,y]
					p.outTangent	= [span/3.0,0]
					p.inTangent		= [-span/3.0,0]
					)

			)
		
		fn createBaseCurve cc ci name:"Curve" col:red=
			(
			-- Initialize curve properties
				local crv			= cc.curves[ci]
		 
				crv.name			= name
				crv.color			= col
				crv.style			= #solid
				crv.numPoints		= 2
				
			-- draw curve
				crv.points[1].value		= [0,-90]
				crv.points[2].value		= [cc.x_range[2],90]

				crv.points[1].bezier	= true
				crv.points[2].bezier	= true

				crv.points[1].corner	= true
				crv.points[2].corner	= true
				
				crv.points[1].outTangent= [333,0]
				crv.points[2].inTangent	= [-333,0]
				
			)

		
		-- save curve to paramblock
			fn saveCurve m cc ci = -- m:modifier, cc:curve control, ci:curve index
				(
				-- escape
					if m == undefined then return

				-- variables
					local p, tIn, tOut, cp
					local c							= cc.curves[ci]
					local numPoints					= c.points.count
					format "Points: %\n" c.points

				-- tab sizes				
					m.pPoints.count					= numPoints
					m.pTangents.count				= numPoints
					m.pBeziers.count				= numPoints
					m.pCorners.count				= numPoints

				-- do it				
				try(
					for i = 1 to numPoints do
						(
						-- variables
							cp						= c.points[i]
							p						= cp.value
							tIn						= cp.inTangent
							tOut					= cp.outTangent
						-- set values					
							m.pPoints[i]			= [p.x, p.y, 0]
							m.pTangents[i]			= [tIn.x, tIn.y, tOut.x, tOut.y]
							
							m.pBeziers[i]			= cp.bezier
							m.pCorners[i]			= cp.corner
					 	)
					)
				catch(
					print "Couldn't save values"
					)
				)
			
		-- load curve from paramblock
			fn loadCurve m cc ci = -- m:modifier, cc:curve control, ci:curve index
				(
				-- escape
					if m == undefined then return
				
				-- variables
					local p3, p2, t, b, c, tIn, tOut
					local numPoints 				= m.pPoints.count
					local c							= cc.curves[ci]

				-- set up curve
					if numPoints < 2 then return false
					c.numPoints = numPoints
					
					format "Loading:\n"
					format "pPoints: %\n" m.pPoints
					format "pTangents: %\n" m.pTangents
					format "pBeziers: %\n" m.pBeziers
					format "pCorners: %\n" m.pCorners

				-- do it				
				try(
					for i = numPoints to 1 by -1 do
						(
						-- variables
							p3						= m.pPoints[i]
							t4						= m.pTangents[i]
							bezier					= m.pBeziers[i]
							corner					= m.pCorners[i]
	
						-- converted variables
							p2						= point2 p3.x p3.y
							tIn						= [t4.x,t4.y]
							tout					= [t4.z,t4.w]

						-- new point
							local pNew				= ccPoint p2 tIn tOut bezier:bezier corner:corner select:true
							setPoint c i pNew
					 	)
					)
				catch(
					print "Couldn't load values"
					)
				)
				
	-------------------------------------------------------------------------------------
	-- other functions
	-------------------------------------------------------------------------------------
		
		function init m =
			(
			theMod = m
			roCC.title = "Twist Profile : " + theMod as string
			loadCurve theMod cc1 1
			)

		function updateModifier =
			(
			if ckbAutoZoom.checked then zoom cc1 #all
			if theMod != undefined then theMod.valTwist += 0
			--saveCurve theMod cc1 1
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

			
		-- points
		
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
				
				
		-- curves
		
			on spnLengthIn changed val do
				(
				setTangentLength cc1 1 val type:#in
				if chkLockLengths.checked then
					(
					spnLengthOut.value = val 
					setTangentLength cc1 1 val type:#out
					)
				)

			on spnLengthOut changed val do setTangentLength cc1 1 val type:#out
			
			on chkLockLengths changed state do spnLengthOut.enabled = NOT state
			
			on btnFlatten pressed do
				(
				flattenSelPoints cc1 1
				)

		-- display
				
			on ckbAutoZoom changed state do if state then zoom cc1 #all
			
		-- rollout
		
			on roCC open do
				(
				--createTestCurve cc1 1 name:"Twist" col:red numPoints:5
				createBaseCurve cc1 1
				zoom cc1 #all
				updateModifier()
				--if (getCurrentSelection())[1] != undefined then theMod = $.modifiers[1]
				--loadCurve theMod cc1 1
				)
	
			on btnLoad pressed do
				(
				loadCurve theMod cc1 1
				)

			on btnSave pressed do
				(
				saveCurve theMod cc1 1
				)
			
			on roCC close do
				(
				saveCurve theMod cc1 1
				)
			
			


)
/*
createdialog roCC 
roCC.theMod = $.modifiers[1]
$.modifiers[1].pPoints = #([0,0,0],[500,0,0],[100,100,0] )
$.modifiers[1].pTangents = #([0,0,100,0],[-100,50,100,-100],[100,0,0,0] )
$.modifiers[1].pBeziers
$.modifiers[1].pCorners
*/