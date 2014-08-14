clearListener()


-- define structs
	struct objInfo (name, stack)
	struct stackInfo (position, name, props)
	struct propInfo (name, class, valStart, valNow, rnd)

-- define variables
	global mySelection = #()
	global myObjList = #()
	debug = true


-- make object list
	mySelection = objects as Array

-- create stack info for each object
	global i = 0
	global data

--get objects (loop)
	for obj in mySelection do
	(
		i +=1
		targetObj = obj.name
	
	-- append the objects array
		data = objInfo name:obj.name stack:#()
		append myObjList data
	
	-- print debugging information
		if debug then
		(
			format "\n\n================================================\n"
			format "== Loop  : "; print i
			format "== name  : %\n" targetObj
			format "== object: %\n" obj
			format "================================================\n"
		)
	
	--get modifiers (loop)
		for mod = 1 to obj.modifiers.count do
		(
			targetMod = obj.modifiers[mod]
	
		-- append the modifiers array
			data = modInfo position:mod name:targetMod props:#()
			append myObjList[i].stack data
	
		-- print debugging information
			if debug then
			(
				format "\n  ----------------------------------------------\n"
				format "  > Modifier:       %\n" mod
				format "  > targetMod:      %\n" targetMod
			)
	
		--get props & values (loop)
			for prop = 1 to ((getPropNames obj.modifiers[mod]).count) do
			(
				targetProp = (getPropNames targetMod)[prop]
				targetPropName = substring (targetProp as String) 1 (targetProp as String).count
				targetPropValStart = execute ("$" + obj.name + ".modifiers[" + mod as String + "]." + targetPropName)
				try targetPropClass =  execute("classOf " + targetPropValStart as String)
				catch()
	
			--append the properties array
				data = propInfo name:targetProp class:targetPropClass valStart:targetPropValStart valNow:undefined rnd: undefined
				append myObjList[i].stack[mod].props data
	
			-- print debugging information
				if debug then
				(
					format "     - - - - - - - - - - - - - - - - - - - - - -\n"
					format "     targetProp:         %\n" targetProp
					format "     targetPropName:     %\n" targetPropName
					format "     targetPropValStart: %\n" targetPropValStart
					format "     targetPropClass:    +%\n" targetPropClass
					format"     "; print data; format"\n"
				)
			)
		)


	-- sort out base object
		-- print debugging information
			if debug then format "\n  ----------------------------------------------\n"
			if debug then format "  > Base Object:    %\n" obj.baseObject

	 --get props & values (loop)
	 	mod = obj.modifiers.count + 1
		for prop = 1 to (getPropNames obj.baseObject).count do
		(
			format "         prop:         %\n" obj.baseObject
			
/*			targetProp = getPropNames baseObject
			targetPropName = substring (targetProp as String) 1 (targetProp as String).count
			targetPropValStart = execute ("$" + obj.name + ".modifiers[" + mod as String + "]." + targetPropName)
			try targetPropClass =  execute("classOf " + targetPropValStart as String)
			catch()

		--append the properties array
			data = propInfo name:targetProp class:targetPropClass valStart:targetPropValStart valNow:undefined rnd: undefined
			append myObjList[i].stack[mod].props data

		-- print debugging information
			if debug then
			(
				format "     - - - - - - - - - - - - - - - - - - - - - -\n"
				format "     targetProp:         %\n" targetProp
				format "     targetPropName:     %\n" targetPropName
				format "     targetPropValStart: %\n" targetPropValStart
				format "     targetPropClass:    +%\n" targetPropClass
				format "     "; print data; format"\n"
			)

*/

		)
	)





