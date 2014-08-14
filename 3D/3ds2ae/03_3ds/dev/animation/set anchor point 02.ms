-- get bounds function
	fn getBounds obj baseObject:false=
		(
		local n, xf, size
		xf				= xform()
		n				= if base == true then obj.modifiers.count else 0
		addModifier obj xf before:n
		size			= (getModContextBBoxMax obj xf - getModContextBBoxMin obj xf)
		deleteModifier obj xf
		return round size
		)

-- get anchor point
	fn getAnchor obj =
		(
		local bounds	= getBounds obj
		local x			= bounds.x/2 - obj.objectoffsetpos.x
		local y			= bounds.y/2 + obj.objectoffsetpos.y
		local z			= 0
		local v			= [x,y,z]
--		local p3		= round (Point3 v.x -v.z v.y)
		local p3		= round (Point3 v.x v.y -v.z)
		return p3
		)

-- move pivot
	with redraw off
		(
		$.objectoffsetpos	= [0,0,0]
		$.objectoffsetpos	= [50,-25,0]
		$.objectoffsetpos	= [40,-10,0]
		)

-- get offset
	$.objectoffsetpos

-- get anchor
	getAnchor $
	
	round 32.54577 2
	
	showsource round