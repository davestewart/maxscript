	fn getAnchor obj =
		(
		local v=obj.pos
		local p3=Point3 (round v.x) (-round v.z) (round v.y)
		return p3
		)




-(round ($.objectoffsetpos - [($.width/2),$.length/2,0]))

-- move pivot
	$.objectoffsetpos=-$.verts[5].pos

-- get offset
	$.objectoffsetpos

/*
p=point()
in coordsys $ p.pos=[0,0,0]--(round ($.objectoffsetpos - [($.width/2),-$.length/2,0]))
select p
when transform $plane01 changes do $point01.pos=$plane01.pivot -- id:#pivTest
when transform $plane01 changes do (format "%\n" "hello") -- id:#pivTest
*/
 
in coordsys world $.max-$.min

$.transform

in coordsys ($.transform * inverse $.transform) $.max-$.min

$.transform = $.transform * inverse $.transform


-- get bounds function
	fn getBounds obj=
		(
		at time 0 with animate off
			(
			storedTransform=obj.transform
			obj.transform = identity obj.transform
			size=obj.max-obj.min
			obj.transform=storedTransform
			)
		return size
		)
	getBounds $
	
-- better get bounds function
	fn getBounds obj baseObject:false=
		(
		local n, xf, size
		xf=xform()
		n=if base==true then obj.modifiers.count else 0
		addModifier obj xf before:n
		size=(getModContextBBoxMax $ xf - getModContextBBoxMin $ xf)
		deleteModifier obj xf
		return round size
		)
	
	getBounds $-- baseObject:true