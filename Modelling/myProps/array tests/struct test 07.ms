clearListener()


-- define structs
	struct objInfo (name, mods)
	struct modInfo (position, name, props)
	struct propInfo (name, class, valStart, valNow, rnd)

-- define variables
	global mySelection = #()
	global myObjList = #()
/*
	global myModList = #()
	global myPropList = #()
*/
	global data
	global i = 0

-- make object list
mySelection = objects as Array



-- create stack info for each object
for obj in mySelection do --get objects (loop)
(
	i +=1
	targetObj = obj.name
	--format "\n\n================================================\n"
	--format "== Loop  : "; print i
	--format "== name  : %\n" targetObj
	--format "== object: %\n" obj
	--format "================================================\n"

-- append the array
	data = objInfo name:obj.name mods:#()
	append myObjList data

	for mod = 1 to obj.modifiers.count do --get modifiers (loop)
	(
		--format "\n  ----------------------------------------------\n"
		--format "  > Modifier:       %\n" mod
		targetMod = obj.modifiers[mod]
		--format "  > targetMod:      %\n" targetMod

	--append the array
		data = modInfo position:mod name:targetMod props:#()
		append myObjList[i].mods data

		for prop = 1 to ((getPropNames obj.modifiers[mod]).count) do --get props & values (loop)
		(
			--format "     - - - - - - - - - - - - - - - - - - - - - -\n"
			targetProp = (getPropNames targetMod)[prop]
			--format "     targetProp:         %\n" targetProp

			targetPropName = substring (targetProp as String) 1 (targetProp as String).count
			--format "     targetPropName:     %\n" targetPropName

			targetPropValStart = execute ("$" + obj.name + ".modifiers[" + mod as String + "]." + targetPropName)
			--format "     targetPropValStart: %\n" targetPropValStart

			try
			(
				targetPropClass =  execute("classOf " + targetPropValStart as String)
				--format "     targetPropClass:    +%\n" targetPropClass
			)
			catch()

		--append the array
			data = propInfo name:targetProp class:targetPropClass valStart:targetPropValStart valNow:undefined rnd: undefined
			--format"     "; print data; --format"\n"
			append myObjList[i].mods[mod].props data


		)
	)
)



