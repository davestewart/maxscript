rollout r1 "Untitled" width:320 height:347
(
	ActiveXControl ax "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[8,8] width:300 height:300
	button btn1 "Button" pos:[8,312] width:300 height:24

	on r1 open do
		(
		local flashPath	="E:/03_Scripting/maxScript/max 8/graphing/"
		ax.movie		=flashPath+"graphing_example.swf"
		)
		
	on btn1 pressed do
		(
		delete objects
		s=sphere()
		function getPos=
			(
			return [random -100 100,random -100 100,random -100 100]
			)
		with animate on
			(
			at time 0	s.pos=getPos()
			at time 50	s.pos=getPos()
			at time 100	s.pos=getPos()
			)
		
		local posStr=""
		for t = animationRange.start to animationRange.end do
			(
			str+=s.pos.x as string + "," + s.pos.y + " "
			)

		ax.SetVariable "pointsStr" str
		ax.TCallLabel "_root" "update"
		)
)

destroydialog r1
createdialog r1