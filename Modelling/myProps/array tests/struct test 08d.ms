fn getStacks =
	(
	clearListener()
	
	-- define variables
		global mySelection = objects as Array
		global myObjList = #()
		global debug = false
	
	-- define structs
		struct objInfo (name, stack)
		struct stackInfo (position, name, props)
		struct propInfo (name, class, valStart, valNow, rnd)
	
	----------------------------------------------------------------------------
	--get objects (loop)
	----------------------------------------------------------------------------
	
		global i = 0
		global data
	
		for obj in mySelection do
			(
			i +=1
			targetObj = obj.name

		-- select the object for visual feedback
			select obj
		
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
		
		----------------------------------------------------------------------------
		--get modifiers (loop)
		----------------------------------------------------------------------------
			for stackLevel = 1 to obj.modifiers.count do
				(
				target = obj.modifiers[stackLevel]
		
			-- append the modifiers array
				data = stackInfo position:stackLevel name:target props:#()
				append myObjList[i].stack data
		
			-- print debugging information
				if debug then
					(
					format "\n  ----------------------------------------------\n"
					format "  > Stack Level:    %\n" stackLevel
					format "  > target:         %\n" target
					)
		
			----------------------------------------------------------------------------
			--get props & values (loop)
			----------------------------------------------------------------------------
				for prop = 1 to (getPropNames target).count do
					(
					targetProp = (getPropNames target)[prop]
					targetPropName = substring (targetProp as String) 1 (targetProp as String).count
					targetPropValStart = execute ("$" + obj.name + ".modifiers[" + stackLevel as String + "]." + targetPropName)
					try targetPropClass =  execute("classOf " + targetPropValStart as String)
					catch()
		
				--append the properties array
					data = propInfo name:targetProp class:targetPropClass valStart:targetPropValStart valNow:undefined rnd: undefined
					append myObjList[i].stack[stackLevel].props data
		
				-- print debugging information
					if debug then
						(
						format "     - - - - - - - - - - - - - - - - - - - - - -\n"
						format "     targetProp:         %\n" targetProp
						format "     targetPropName:     %\n" targetPropName
						format "     targetPropValStart: %\n" targetPropValStart
						format "     targetPropClass:    %\n" targetPropClass
						format"     "; print data; format"\n"
						)
					)
				)
	
		----------------------------------------------------------------------------
		--get base object
		----------------------------------------------------------------------------
			target = obj.baseObject
			stackLevel = obj.modifiers.count + 1
	
			-- append the modifiers array
				data = stackInfo position:stackLevel name:target props:#()
				append myObjList[i].stack data
	
			-- print debugging information
				if debug then
					(
					format "\n  ----------------------------------------------\n"
					format "  > Stack Level:    %\n" stackLevel
					format "  > target:         %\n" target
					)
		
		----------------------------------------------------------------------------
		--get props & values (loop)
		----------------------------------------------------------------------------
		for prop = 1 to (getPropNames target).count do
			(
			targetProp = (getPropNames target)[prop]
			targetPropName = substring (targetProp as String) 1 (targetProp as String).count
			targetPropValStart = execute ("$" + obj.name + ".baseObject." + targetPropName)
			try targetPropClass =  execute("classOf " + targetPropValStart as String)
			catch()
	
		--append the properties array
			data = propInfo name:targetProp class:targetPropClass valStart:targetPropValStart valNow:undefined rnd: undefined
			append myObjList[i].stack[stackLevel].props data
	
	
		-- print debugging information
			if debug then
				(
				format "     - - - - - - - - - - - - - - - - - - - - - -\n"
				format "     targetProp:         %\n" targetProp
				format "     targetPropName:     %\n" targetPropName
				format "     targetPropValStart: %\n" targetPropValStart
				format "     targetPropClass:    %\n" targetPropClass
				format "     "; print data; format"\n"
				)
			)
		)
		return objList
	)
getStacks() 