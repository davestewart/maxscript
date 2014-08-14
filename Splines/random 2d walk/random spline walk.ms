-- fns
	fn drawLineBetweenTwoPoints pointA pointB col= 
	(
		ss = SplineShape pos:pointA renderable:true thickness:0.05 wirecolor:col
		addNewSpline ss 
		addKnot ss 1 #corner #line PointA 
		addKnot ss 1 #corner #line PointB 
		updateShape ss 
		--ss 
	) 


	function new2DDir=
	(
		dirArr=#(
			[1,0,0], 
			[0,1,0], 
			[-1,0,0], 
			[0,-1,0]
		) 
		return dirArr[random 1 dirArr.count]
	)

	function new3DDir=
	(
		dirArr=#(
			[1,0,0], 
			[0,1,0], 
			[-1,0,0], 
			[0,-1,0], 
			[0,0,1], 
			[0,0,-1]
		) 
		return dirArr[random 1 dirArr.count]
	)


	function plot steps threed trace:false drawMode:1=
	(
		-- utility
			if trace then clearlistener()
			delete objects
		--vars
			r=ray [0,0,0] [1,0,0]
			rayArr=#(r)
			
		-- code
			for i = 1 to steps do
			(
				-- feedback
					local pc=((i as float/steps)*100) as integer
					displaytempprompt ("Processing: " + pc as string +"% done") 1

				-- color
					local c=(i as float/steps)*255
					col=color c c c 255
					
				-- new ray
					dir=	if threed then new3DDir() else new2DDir()
					pointA= rayArr[rayArr.count].pos+ rayArr[rayArr.count].dir
					pointB=	pointA+dir
					r=		ray pointA dir
			
				-- test that this ray / dir hasn't been used yet
					-- one of two modes:
						-- 1: don't use same space and direction
						-- 2: don't use same space
					draw=true
					if drawMode==1 then
					(
						for test in rayArr do if (r.pos==test.pos AND r.dir==test.dir) then (draw=false;continue)
					)
					else
					(
						for test in rayArr do if (r.pos+r.dir==test.pos) then (draw=false;continue)
					)

					
				-- draw the line
					if draw then
					(
						drawLineBetweenTwoPoints pointA pointB col
						append rayArr r
					)
				-- trace result
					if trace then format "% %\n" pointA pointB

			)
		-- zoom
			max zoomext sel all
	)

	
-- code
	plot 1000 true drawMode:0
