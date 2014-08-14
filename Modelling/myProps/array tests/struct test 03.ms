struct objInfo (name, baseProps, mods)
struct modInfo (position, name, modProps)
struct propInfo (name, class, valueStart, valueNow, randomOffset)


-- define variables
	global mySelection = #()
	global myObjList = #()
	global myModList = #()
	global myPropList = #()
	global data = undefined

-- make object list
mySelection = objects as Array



-- create stack info for each object
for obj in selection do
	(
	format "\n%:\n" obj.name
	for mod = 1 to obj.modifiers.count do
		(
		format "  %\n" obj.modifiers[mod]
		append myModList obj.modifiers[mod] as String
		)
	data = objInfo name:obj.name  baseProps: (getPropNames obj) mods:obj.modifiers
	append myObjList data
	myModList = #()
	)





