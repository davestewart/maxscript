mapped function resetPosition obj collapse:false = 
(
	pos = obj.center
	addmodifier obj (xform())
	xf = obj.modifiers[1]
	xf.gizmo.pos -= pos
	obj.pos += pos
	if collapse do collapseStack obj
)

resetPosition $ collapse:true