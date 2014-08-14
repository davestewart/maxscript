fn getChildrenRecursive obj arr=
	(
	if obj.children.count > 0 then
		(
		for c in obj.children do
			(
			append arrObj c
			getChildrenRecursive c arr
			)
		)
	)
	
arrObj = #()
getChildrenRecursive $ arrObj
print arrObj
