rollout ro1 "Options" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	button btn1 "Find Similar" pos:[8,8] width:144 height:16
	button btn2 "Get Stack Info" pos:[8,32] width:144 height:16



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

fn goSearch =
(
	clearListener()
	
	-- declare globals
		global objArray1 = #(), objArray2 = #(), objArray3 = #(), objArray4 = #()

	-- declare source object
		local source = $
	
	-- find objects of same class
		for obj in objects do
			if iskindof obj (classOf source) then append objArray1 obj
	
	-- narrow to those with same number of modifiers
		for obj in objArray1 do
			if obj.modifiers.count == source.modifiers.count then append objArray2 obj
	
	-- loop through to see if they have same mods in same order (no matter what the name is)
		for obj in objArray2 do
		(
			format "\nObject % has % mods\n     - " obj.name source.modifiers.count --to:myWin
			score = 0
			for i = 1 to source.modifiers.count do
			(
				score += 1
				format "%:%, " i (obj.modifiers[i].name) 									-- modifier type
				if classof obj.modifiers[i] != classof source.modifiers[i] then
				(
					format "\n     -   Failed (%/%)\n" (score-1) source.modifiers.count		-- object failed at mod i
					exit
				)
				else if i == source.modifiers.count then
				(
					format "\n    OK   Passed (%/%)\n" score source.modifiers.count			-- object added
					append objArray3 obj
				)
			)

		)
	
		-- Convert matched objectList to NameList
			for obj in objArray3 do append objArray4 obj
			max select none
			-- for obj in objArray4 do selectMore (execute("$" + obj as String))
			for obj in objArray4 do selectMore obj
			return objArray4
)



fn getStacks =
(
	clearListener()
	
	-- define variables
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
	
		for obj in objArray4 do
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


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btn1 pressed do
	(
		goSearch() --lbx1.items = objArray4
	)

	on btn2 pressed do
	(
		getStacks()
	)
)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout ro1 myFloater