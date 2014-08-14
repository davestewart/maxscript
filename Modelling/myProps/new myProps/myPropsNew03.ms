---------------------------------------------------------------------------------------------------
-- declare globals
---------------------------------------------------------------------------------------------------
	global debugMajor = false
	global debugMinor = false
	global roStack, populateLists
	global myObjList = #()


rollout roSource "Source" width:312 height:496
(

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	pickbutton btnPickSource "Pick..." pos:[8,8] width:64 height:64 message:"Pick a source object" toolTip:"Pick a source object, on which to base comparisons"
	label lblSource "" pos:[80,8] width:224 height:16
	label lblSimilar "" pos:[80,24] width:224 height:16
	label lblStackInfo "" pos:[80,40] width:224 height:32




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
	
		-- Reselect objects for visual clarity
			for obj in objArray3 do append objArray4 obj
			max select none
			for obj in objArray4 do selectMore obj
			return objArray4
	)



fn getStacks =
	(
	clearListener()
	
	-- define variables
		global myObjList = #()
	
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
			if debugMinor then
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
				data = stackInfo position:stackLevel name:target.name props:#()
				append myObjList[i].stack data
		
			-- print debugging information
				if debugMinor then
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
					if debugMajor then
						(
						format "     - - - - - - - - - - - - - - - - - - - - - -\n"
						format "     targetProp:         %\n" targetProp
						format "     targetPropName:     %\n" targetPropName
						format "     targetPropValStart: %\n" targetPropValStart
						format "     targetPropClass:    %\n" targetPropClass
						)
						if debugMinor then (format"     "; print data;) --format"\n"
					)
				)
	
		----------------------------------------------------------------------------
		--get base object
		----------------------------------------------------------------------------
			target = obj.baseObject
			stackLevel = obj.modifiers.count + 1
	
			-- append the modifiers array
				data = stackInfo position:stackLevel name:(target as String) props:#()
				append myObjList[i].stack data
	
			-- print debugging information
				if debugMinor then
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
			if debugMajor then
				(
				format "     - - - - - - - - - - - - - - - - - - - - - -\n"
				format "     targetProp:         %\n" targetProp
				format "     targetPropName:     %\n" targetPropName
				format "     targetPropValStart: %\n" targetPropValStart
				format "     targetPropClass:    %\n" targetPropClass
				)
				if debugMinor then (format "     "; print data;) -- format"\n"
			)
		)

	-- Reselect objects for visual clarity
		for obj in objArray4 do selectMore obj

		return objList
	)

fn start =
	(
	if selection.count == 1 then
		(
		btnFindSimilar.enabled = true
		btnPickSource.text = "Source: " + selection[1].name as String
		)
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btnPickSource picked obj do
	(
	select obj
	lblSource.text = "$" + selection[1].name
	lblSimilar.text = "n/a"
	lblStackInfo.text = "n/a"
	
	goSearch()
	lblSimilar.text = (objArray4.count as String) + " similar objects found"
	
	getStacks()
	text = #()
	for i = myObjList[1].stack.count to 1 by -1 do append text myObjList[1].stack[i].name
	lblStackInfo.text = text as String
	roStack.populateLists()
	)
)


rollout roStack "Stack" width:312 height:496
(
	----------------------------------------
	-- interface
	----------------------------------------
	listbox ddlStack "Stack Element" pos:[8,8] width:144 height:15
	listbox ddlProps "Property" pos:[160,8] width:144 height:15

	
	GroupBox grpAttribs "Property Info" pos:[8,232] width:308 height:72
	label lblProp "Property:" pos:[16,248] width:280 height:16
	label lblVal "Value:" pos:[28,264] width:268 height:16
	label lblClass "Class:" pos:[30,280] width:266 height:16


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

fn propsSelected sel =
	(
	stackSel = ddlStack.selected

	lblProp.text = "Property: " + myObjList[1].stack[stackSel].props[sel].name
	lblVal.text = "Value: " + myObjList[1].stack[stackSel].props[sel].valueStart
	lblClass.text = "Class: + myObjList[1].stack[stackSel].props[sel].class

	)

fn stackSelected sel =
	(
	items = #()
	for i = 1 to myObjList[1].stack[sel].props.count do
		(
		append items myObjList[1].stack[sel].props[i].name
		)
	ddlProps.items = items
	)

fn populateLists =
	(
	print "Populating list"
	items = #()
	for i = 1 to myObjList[1].stack.count do
		(
		append items myObjList[1].stack[i].name
		)
	ddlStack.items = items
	stackSelected 1
	)



	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on ddlStack selected sel do
		stackSelected sel
	on ddlProps selected sel do
		propsSelected sel
)



if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 344 874 80 60
 
addRollout roSource myFloater
addRollout roStack myFloater