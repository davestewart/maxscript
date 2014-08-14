-- author
	-- Dave Stewart
	-- 30 Sept 2005
	
-- max versions
	-- 6 + (maybe 5 -, not sure...)

-- function
	function getUnmappedObjects printObj:false selObj:false=
		(
		local objArr=#(), matArr
		render missingUVWAction:#(#logmsg,#abort) missingUVWList:&matArr quiet:true
		for obj in matArr do append objArr (getNodeByName (trimleft ((filterstring obj ":")[2])))
		if printObj then
			(
			format "\n-------------------------\nUnmapped Objects:\n-------------------------\n"
			for obj in objArr do format "%\n" obj.name
			format "-------------------------\n\n"
			)
		if selObj then
			(
			clearSelection()
			select objArr
			)
		return objArr
		)

-- usage

	-- sample setup
		s=sphere mapCoords:off
		convertToMesh s
		
		m=meditmaterials[1]
		m.diffuseMap = Checker ()
		s.material=m


	-- get unmapped objects only into an array
		getUnmappedObjects()
	
	-- select unmapped objects
		getUnmappedObjects selObj:true
		select (getUnmappedObjects())
	
	--print a list of unmapped objects
		getUnmappedObjects printObj:true
	


