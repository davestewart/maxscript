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
			for obj in objArray3 do append objArray4 obj.name
			return objArray4
)
goSearch()
--lbx1.items = objArray4
