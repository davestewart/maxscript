mp = mouse.pos

r = mapScreenToWorldRay mp
p = r.pos
--point pos:r.pos

--c = cylinder pos:r.pos dir:(r.dir * 360) height:(distance r.pos [0,0,0])


--d = dummy pos:(r.pos / r.dir)


fn planeLineIntersect planePoint planeNormal linePoint lineVector = (
	local lineVector	= normalize lineVector
	local d1			= dot (planePoint-linePoint) planeNormal
	local d2			= dot lineVector planeNormal
	if abs(d2)<.0000000754 then (
		if abs(d1)>.0000000754 then 0 else -1
	)
	else(
		linePoint + ( (d1/d2)*lineVector )
	)
)
	
	
	
p3 = planeLineIntersect [0,0,0] [0,0,1] r.pos r.dir
d = dummy pos:p3