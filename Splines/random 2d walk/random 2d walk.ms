fn drawLineBetweenTwoPoints pointA pointB = 
( 
	ss = SplineShape pos:pointA renderable:true thickness:0.05 wirecolor:red
	addNewSpline ss 
	addKnot ss 1 #corner #line PointA 
	addKnot ss 1 #corner #line PointB 
	updateShape ss 
	ss 
) 

fn drawline =
(
	for i in 1 to (arr.count - 1) do
	(
		PointA = arr[i]
		PointB = arr[i+1]
		drawLineBetweenTwoPoints pointA pointB
	)
)

fn drawline =
(
	for i = 1 to stepCount do
	(
		pointA = posArr[i]
		pointB = pointA + dir_2d[(Random 1 dir_2d.count )]
		if findItem posArr pointB != 0 then
		(
			append posArr pointB
			drawLineBetweenTwoPoints pointA pointB
		)
	)
)


clearlistener()
delete objects

--variables
	stepCount = 100
	startPos = [0,0,0]
	posArr=#(startPos)

--direction vectors
	dir_2d = #([1,0,0], [0,1,0], [-1,0,0], [0,-1,0]) 
	--dir_2d = #([0.5,1,0], [1,1,0], [-0.5,-1,0], [-1,-1,0],[-1,-0.5,0],[1,0.5,0] )-- try different net 

--collect random steps
	--2d
	pos = copy startPos --reset start position
	Steps_2d = for j = 1 to stepCount collect 
	(
		pos += dir_2d[(Random 1 dir_2d.count )]
	)


	--3d
	pos = copy startPos --reset start position
	Steps_3d = for j = 1 to stepCount collect 
	(
		pos += dir_3d[(Random 1 dir_3d.count )] 
	) 

--end maxscript
	arr = n
	arr = n = steps_2d 
	drawline ()