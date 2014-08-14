clearListener()


-- define structs
	struct objInfo (name, baseProps, mods)
	struct modInfo (position, name, modProps)
	struct propInfo (name, class, valueStart, valueNow, randomOffset)

-- define variables
	global mySelection = #()
	global myObjList = #()
	global myModList = #()
	global myPropList = #()
	global data

-- make object list
mySelection = objects as Array



-- create stack info for each object
for obj in selection do --get objects (loop)
	(
	targetObj = obj.name
	format "\n\n================================================\n"
	format "==  name  : %\n" targetObj
	format "==  object: %\n" obj
	format "================================================\n"

	for mod = 1 to obj.modifiers.count do --get modifiers (loop)
		(
		format "\n  ----------------------------------------------\n"
		format "  > Modifier:       %\n" mod
		targetMod = obj.modifiers[mod]
		format "  > targetMod:      %\n" targetMod
		for prop = 1 to ((getPropNames obj.modifiers[mod]).count) do --get props & values (loop)
			(
		-- this bit tries to define the whole prop path as a variable, so it can be targeted
			format "     - - - - - - - - - - - - - - - - - - - - - -\n"
			targetProp = (getPropNames targetMod)[prop]
			format "     targetProp:     %\n" targetProp

			targetPropName = substring (targetProp as String) 1 (targetProp as String).count
			format "     targetPropName: %\n" targetPropName

			targetPropPath = execute ("$" + obj.name + ".modifiers[" + mod as String + "]." + targetPropName)
			format "     targetPropPath: %\n" targetPropPath

			try
				(
				targetPropClass =  execute("classOf " + targetPropPath as String)
				format "     class:          %\n\n" targetPropClass
				)
			catch()


/*
*/
			)
		-- append myModList obj.modifiers[mod] as String
		)
	)

	-- data = objInfo name:obj.name  baseProps: (getPropNames obj) mods:obj.modifiers
	-- append myObjList data
	-- myModList = #()



