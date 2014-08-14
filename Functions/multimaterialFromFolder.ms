function multimaterialFromFolder folder: =
(
	-- get directory
		if folder == unsupplied then
			dir = getSavePath caption:"Browse for files" initialDir:(if dir != undefined then dir else "")
		local files = getfiles (dir + "\\*.*")
	
	-- material
		local dirs = filterstring dir "\\"
		local m = meditmaterials[medit.GetActiveMtlSlot()] = multimaterial name:dirs[dirs.count]
		m.numsubs = files.count

	-- subs
		local i = 0
		for file in files do
		(
			-- check that file is a bitmap
				try(
					openBitMap file
					i += 1
				)
				catch(
					continue
				)
			-- make material
				local mat	= m[i]
				local map	= m[i].diffuseMap
				
				mat.name = getFilenameFile file
				mat.diffuseMap = Bitmaptexture fileName:file 
				mat.selfIllumAmount = 75
				
				showTextureMap mat true
		)
	-- clean up
		m.numsubs = i
)

--multimaterialFromFolder()
