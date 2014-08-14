

plugin simpleMod ccTest
name:"CurveControl Tester"
classID:#(0x2d60fac1, 0x2d0524a6)
(
	
	local roCC 
	local firstRun = true
	
	parameters main rollout:params
	(
		twist type:#float ui:spnTwist default:20
	)
		
	rollout roCC "Curve Control"
	(
	
		-------------------------------------------------------------------------------------
		-- interface
		-------------------------------------------------------------------------------------
		
			CurveControl ccTwist "" 
				height:			400
				width:			800
				align:			#left
				numCurves:		1
				visible:		true
				x_range:		[0,1000]
				y_range:		[-360,360]
				scrollValues:	[-100,100]
			 
				commandMode:#move_xy    
				rcmFlags:#(#delete)
				asPopup: false

		-------------------------------------------------------------------------------------
		-- handlers
		-------------------------------------------------------------------------------------
		
			on ccTwist ptChanged ci pi do
			(
				local val = ccTwist.curves[ci].points[pi].value[2]
				format "> % % %\n" ci pi val
				this.twist = val
			)
				
			on roCC open do
			(
				zoom ccTwist #all
				removeRollout roCC
			)
		
	)
	
	rollout params "Parameters"
	(
		button btn1 "Edit profile" width:160 height:20 align:#center
		button btn2 "Check values" width:160 height:20 align:#center
		spinner spnTwist "Twist : " type:#float range:[-2000,2000,20] fieldWidth:50 align:#right

		on btn1 pressed do
		(
			createdialog roCC 820 440
			destroydialog roCC
			createdialog roCC 820 440
		)
			
		on btn2 pressed do
		(
			local val = getValue roCC.ccTwist.curves[1] 0 750
			print val
		)
	)


		

		
	on map i p do
	(
	)

)
