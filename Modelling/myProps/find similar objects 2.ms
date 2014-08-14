-- declare source object
	source = $

-- find objects of same class
	objArray1 = #()
	for obj in objects do
		if iskindof obj (classOf source) then append objArray1 obj
		objArray1

-- narrow to those with same number of modifiers
	objArray2 = #()
	for obj in objArray1 do
		if obj.modifiers.count == source.modifiers.count then append objArray2 obj
		objArray2

-- loop through to see if they have same mods in same order (no matter what the name is)
	objArray3 = #()
	unmatched = 0
	for obj in objArray2 do
	(
		format "\nObject % has % mods\n" obj.name source.modifiers.count --to:myWin
		for i = 1 to source.modifiers.count do
		(
			score = 0
			if classof source.modifiers[1] != classof obj.modifiers[1] then
			(
				format "     - % FAILED!\n       " obj.name --to:myWin
				unmatched += 1
				exit
			)
			score += 1
			format "     - Mod % is %\n" i (obj.modifiers[i]) --to:myWin

			if i == source.modifiers.count then
			(
				score += 1
				format "    :) % added (%/%)\n" obj.name score source.modifiers.count
				append objArray3 obj
			)
		)
		format "\nMatched objects:   %" objArray3.count
		format "\nUnmatched objects: %\n\n" unmatched
	)

-- apply a random bend
	for obj in objArray3 do
	(
		obj.baseObject.heightsegs = 10
		obj.modifiers[2].bendAngle = random -90 90
		)