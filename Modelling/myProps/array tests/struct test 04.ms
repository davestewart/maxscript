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
for obj in selection do --get objects
(
	data = obj.name
	format "\n%:\n" data
	for mod = 1 to obj.modifiers.count do --get modifiers
	(
		data = obj.modifiers[mod]
		format "  %\n" data
		for prop = 1 to (getPropNames obj.modifiers[mod]).count do --get Props
		(
			data = (getPropNames obj.modifiers[mod])[prop]
			format "    %\n" data
			for prop = 1 to (getPropNames obj.modifiers[mod]).count do --get Props
			(
			)
		)
		-- append myModList obj.modifiers[mod] as String
	)
	-- data = objInfo name:obj.name  baseProps: (getPropNames obj) mods:obj.modifiers
	-- append myObjList data
	-- myModList = #()
)





