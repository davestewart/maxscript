rollout uTestCurveControl "Curve Control"
	(

	-------------------------------------------------------------------------------------
	-- interface
	-------------------------------------------------------------------------------------
	
		CurveControl cc_test "Curve Control:" 
			height:			400
			width:			800
			align:			#left
			numCurves:		1
			visible:		true
			x_range:		[0,1000]
			y_range:		[-360,360]
			scrollValues:	[-100,100]
		 
			commandMode:#move_xy    
				-- The following parameters default to all flags if not specified
				--uiFlags:#(#drawBG, #drawgrid, #upperToolbar, #showReset, #scrollBars, #constrainY, #xvalue)
				
			rcmFlags:#(#delete)
			asPopup:false -- true
	

	-------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------
	
		on uTestCurveControl open do
			(
			local colors = #(red, green, blue)
			local styles = #(#solid, #dash, #dot, #dashDot, #dashDotDot, #null, #insideFrame)
			local num = cc_test.numCurves 
			  
			-- Initialize curve properties
			local crv = cc_test.curves[1]
			local ci = 0
			local si = #solid
			 
			crv.name = "Twist"
			crv.color = red
			crv.disabledColor = red * 0.5
			crv.style = #solid
			crv.numPoints = 2
			 
			crv.points[1].value = [0,100]
			crv.points[2].value = [100,-100]
			--local del = (cc_test.x_range.y - cc_test.x_range.x)/(crv.numPoints-1)
			-- format "del:%\n" del
			-- Place intermediate points equally spaced
	
			zoom cc_test #all
			)
	 
	 
		-- Curve control event handlers
		/*
			on cc_test selChanged ci val do format "curve % numSelected : %\n" ci val
			on cc_test ptChanged ci val do format "curve % ptChanged : %\n" ci val
			on cc_test tangentChanged ci val type do format "curve % tangentChanged : % %\n" ci val (type as string)
			on cc_test deleted ci pi do format "curve % deleted : %\n" ci pi
			on cc_test reset ci do format "curve % resetted\n" ci
		*/
	)
 
--curveFloater = newRolloutFloater "Curve Control Test"
 
--addRollout uTestCurveControl curveFloater
createdialog uTestCurveControl 820 440


/*

setproperty uTestCurveControl.cc_test #x_range [0,500]

uTestCurveControl.cc_test.curves[1].points[2].value = [100,0]
uTestCurveControl.cc_test.curves[1].points[2].value = [100,0]

uTestCurveControl.cc_test.curves[1].points[2].end

getValue uTestCurveControl.cc_test.curves[1] 0 500

uTestCurveControl.cc_test.curves[1].width = 2
uTestCurveControl.cc_test.curves[1].color = red

uTestCurveControl.cc_test.curves[1].style = #solid --#solid, #dash, #dot, #dashDot, #dashDotDot, #null, #insideFrame


*/

twistMod = $.modifiers[1]
twistCrv = uTestCurveControl.cc_test.curves[1]

for i = 1 to twistCrv.points.count do
	(
	twistMod.twistVals[i]		= twistCrv.points[i].value
	twistMod.twistValsIn[i]		= twistCrv.points[i].inTangent
	twistMod.twistValsOut[i]	= twistCrv.points[i].outTangent
 	)

getValue uTestCurveControl.cc_test.curves[1] 0 750

uTestCurveControl.cc_test.curves[1].points[2].value
uTestCurveControl.cc_test.curves[1].points[2].inTangent
uTestCurveControl.cc_test.curves[1].points[2].outTangent