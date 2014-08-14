

 [ prompt:<string> ] [ snap:#2D|#3D ] \
[ rubberBand:<start_point3> ] \
[ mouseMoveCallback:fn | #(fn,arg) ] \
[ relativeTo:<relativePt_point3> ] \
[ terminators:#(<string>,<string>,...) ]


fn createDummy pt =
	(
	dummy pos:pt
	)

fn test str = format "%\n" (str[1] as string)
	

d = dummy pos:(pickPoint())



d = dummy pos:(pickPoint mouseMoveCallback:test rubberband:true)

fn callback_fn msg ir obj faceNum shift ctrl alt = 
	(
	format "\n msg:%\n ir:%\n" msg ir
	if msg == #mousePoint AND dragging == false do
		(
		dragging = true
		--messagebox (ir.pos as string)
		return ir.pos
		)
	#continue
	)


dragging = false
pt1 = mouseTrack trackCallback:callback_fn 
pickPoint rubberband:pt1

arr = #()
while arr.count < 5 do
	(
	local pt = pickpoint()
	append arr pt
	print pt as string
	)
print arr






fn getCircleRadius pt1 pt2 =
	(
	xy = pt2 - pt1
	r = sqrt ((xy.x * xy.x) + (xy.y * xy.y))
	)


fn makeCircle msg ir obj faceNum shift ctrl alt = 
	(
	-- stop
		if msg == #mousePoint then
			(
			messagebox (r as string)
			return pt2
			)
	-- start
		else(
			if isvalidnode c do
				(
				pt2			= ir.pos
				r			= getCircleRadius pt1 pt2
				c.radius	= r
				)
			)
		#continue
	)


r			= 0
pt1			= pickpoint()
c			= circle pos:pt1 radius:0
pt2			= mouseTrack trackCallback:makeCircle
c.radius	= r

