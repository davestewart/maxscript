rollout r1 "Graphing Example 2" width:320 height:336
(

	ActiveXControl ax "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[8,8] width:300 height:300

	label lbl1 "Trajectory:" pos:[8,312] width:56 height:16
	radioButtons rdo1 "" pos:[72,312] width:129 height:16 labels:#("x,y", "x,z", "y,z") columns:3
	button btn1 "Plot" pos:[192,312] width:80 height:16
	button btn2 "New" pos:[272,312] width:32 height:16


	local s

	function getPos=
		(
		return [random -100 100,random -100 100,random -100 100]
		)

	function createNewAnimation=
		(
		delete objects
		s=sphere()
		s.showTrajectory =on
		
		local t1		=animationRange.start
		local t2		=animationRange.end
		
		with animate on
			(
			at time (t1)				s.pos=getPos()
			at time ((t2-t1)*0.25)		s.pos=getPos()
			at time ((t2-t1)*0.5)		s.pos=getPos()
			at time ((t2-t1)*0.75)		s.pos=getPos()
			at time (t2)				s.pos=getPos()
			)

		plotGraph()
		)

	function plotGraph=
		(
		local posStr=""
		for t = animationRange.start to animationRange.end do
			(
			case rdo1.state of
				(
				1:		at time t posStr+=s.pos.x as string + "," + s.pos.y as string + " "
				2:		at time t posStr+=s.pos.x as string + "," + s.pos.z as string + " "
				3:		at time t posStr+=s.pos.y as string + "," + s.pos.z as string + " "
				default:	""
				)
			)

		ax.SetVariable "pointsStr" posStr
		ax.TCallLabel "_root" "update"
		--messagebox posStr
		)
		
	on r1 open do
		(

		-- BE SURE TO UPDATE YOUR FLASH PATH HERE!
		local flashPath	="E:/03_Scripting/maxScript/max 8/graphing/"

		ax.movie		=flashPath+"graphing_example_2.swf"
		createNewAnimation()
		)
		
	on btn1 pressed do plotGraph()
	on btn2 pressed do createNewAnimation()


)

destroydialog r1
createdialog r1