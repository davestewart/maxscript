fn drawLineBetweenTwoPoints pointA pointB = 
	( 
	ss = SplineShape pos:pointA renderable:true thickness:0.05 wirecolor:red
	addNewSpline ss 
	addKnot ss 1 #corner #line PointA 
	addKnot ss 1 #corner #line PointB 
	updateShape ss 
	ss 
	) 

clearlistener()
delete objects

--variables
	stepCount = 100
	posArr=#([0,0,0])
	dir2D = #([1,0,0], [0,1,0], [-1,0,0], [0,-1,0]) 

--collect random steps
	--2d
	pos = copy startPos --reset start position
	Steps_2d = for j = 1 to stepCount collect 
		(
		pos += dir_2d[(Random 1 dir_2d.count )]
		)


for i = 1 to 100 do
	(
	pointA = posArr[i]
	pointB = pointA + dir2D[random 1 dir2D.count]

	if findItem posArr pointB == 0 then
		(
		append posArr pointB
		drawLineBetweenTwoPoints pointA pointB
		)
	
	)


