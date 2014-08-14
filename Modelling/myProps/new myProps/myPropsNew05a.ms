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
	label lblSource "" pos:[80,12] width:224 height:16
	label lblSimilar "" pos:[80,32] width:224 height:16
	label lblStackInfo "" pos:[80,52] width:224 height:16




	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

fn goSearch =
	(
	clearListener()
	displayTempPrompt"Finding similar objects..." 1000

	
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
			select (objArray4 as Array)

			return objArray4
	)



fn getStacks =
	(
	clearListener()
	displayTempPrompt"Getting stack info..." 1000

	
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
					catch(targetPropClass = "-")
		
				--append the properties array
					data = propInfo name:targetProp class:targetPropClass valStart:targetPropValStart valNow:undefined rnd: (random 0.1000 1.0000)
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
			catch(targetPropClass = "-")
	
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
		select (objArray4 as Array)

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
	
	goSearch()
	lblSimilar.text = ((objArray4.count-1) as String) + " similar objects found..."
	
	getStacks()
	lblStackInfo.text = myObjList[1].stack.count as String + " elements in stack..."
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
	spinner spn1 "" pos:[8,312] width:80 height:16 range:[-1000,1000,0]


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

fn updateProp val =
	(
	stackSel = ddlStack.selection
	propSel = ddlProps.selection


-- define mod & prop
	mod = myObjList[1].stack[stackSel].position
	prop = myObjList[1].stack[stackSel].props[propSel].name


	for i = 1 to myObjList.count do
		(

		-- define object name
			obj = myObjList[i].name

		-- if a modifier is selected...
			if stackSel < myObjList[1].stack.count then
				(
				target = ("$" +obj as String+ ".modifiers[" +mod as String+ "]." + prop as String)
				if debugMinor then format "%\n" target
				
				rnd = myObjList[i].stack[stackSel].props[propSel].rnd
				newVal = val*rnd

				-- update props in array with correct values
					myObjList[i].stack[stackSel].props[propSel].valNow = newVal		-- current value of spinner * random offset

				execute (target + "=" + newVal as String )
				)

		-- if the baseobject is selected...
			else 
			(

			)

		)

	)


fn propsSelected sel =
	(
	stackSel = ddlStack.selection
	lblProp.text = "Property: " + myObjList[1].stack[stackSel].props[sel].name as String
	lblVal.text = "Value: " + myObjList[1].stack[stackSel].props[sel].valStart as String
	lblClass.text = "Class: " + myObjList[1].stack[stackSel].props[sel].class as String
		)

fn stackSelected sel =
	(
	items = #()
	for i = 1 to myObjList[1].stack[sel].props.count do
		(
		append items myObjList[1].stack[sel].props[i].name
		)
	ddlProps.items = items
	ddlProps.selection = 1
	propsSelected 1
	)

fn populateLists =
	(
-- Populate StackList
	items = #()
	for i = 1 to myObjList[1].stack.count do
		(
		append items myObjList[1].stack[i].name
		)
	ddlStack.items = items

-- update highlight
	ddlStack.selection = 1
	ddlProps.selection = 1

-- Populate PropsList
	stackSelected 1
	)



	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------


	on ddlStack selected sel do
		stackSelected sel
	on ddlProps selected sel do
		propsSelected sel
	on spn1 changed val do
		updateProp val
)



if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 344 493 280 13 -- 80 60
 
addRollout roSource myFloater
addRollout roStack myFloater