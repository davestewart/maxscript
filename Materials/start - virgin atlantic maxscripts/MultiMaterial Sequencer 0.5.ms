/*	-------------------------------------------------------------------------

	Script:	MultiMaterial Sequencer
	Author:	Dave Stewart
	www:	www.pondskata.com
	Date:	December 12 2005
	Version:0.5

	Purpose:Propogates a folder of bitmaps to a multimaterial's sub materials.

	Usage:	Set up your first multimaterial's material with the required settings 
		and the first bitmap from a folder of images (you can do this in any
		of the available map slots, eg diffuse and opacity) then click "Propogate
		Materials" to automatically create new submaterials based on the first in
		the list, but with different maps
	
	
*/	-------------------------------------------------------------------------

rollout roMultiMaterialPropogator "MultiMaterial Sequencer" width:168 height:40
	(
	
	-------------------------------------------------------------------------
	-- interface
	
		button btn1 "Propogate Maps" pos:[8,8] width:152 height:24


	-------------------------------------------------------------------------
	-- variables
	
		local materialList = #()

	-------------------------------------------------------------------------
	-- functions
	
	fn propogate mm=
		(
		mm.numSubs=1
		mat = mm[1]
		mat.name = mm.name + " sub 1"

		format "Updating: %\n" mm.name

		for i = 1 to mat.maps.count do
			(
			if mat.maps[i] != undefined then
				(
				-- feedback
					format "Updating: % (%)\n" mm[1].shaderByName materialList[mm[1].shaderType+1][i]
				
				-- variables
					map = mat.maps[i]
					
				-- maps
					local dir = getFilenamePath map.filename
					local ext = getFilenameType map.filename
					local files = getfiles (dir + "\\*" + ext)
		
				
				-- materials
					for j = 2 to files.count do
						(
					-- copy material
						--print j
						if j > mm.numSubs then
							(
							mm.numSubs=j
							mm[j] = copy mat
							mm[j].name = mm.name + " sub " + (j as string)
							)
	
					-- update maps
						mm[j].maps[i].fileName = files[j]
						)
		
				)
			)
		)
	
	-------------------------------------------------------------------------
	-- handlers
	
		on roMultiMaterialPropogator open do
			(
			append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "DiffuseLevelMap", "SpecularLevelMap", "GlossinessMap", "AnisotropyMap", "OrientationMap", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Anisotropic"
			append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "SpecularLevelMap", "GlossinessMap", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Blinn"
			append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "SpecularLevelMap", "GlossinessMap", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Metal"
			append materialList #("AmbientMap", "DiffuseMap", "DiffuseLevelMap", "DiffuseRoughnessMap", "SpecularMap", "SpecularLevelMap", "GlossinessMap", "AnisotropyMap", "OrientationMap", "specularMap2", "SpecularLevelMap2", "GlossinessMap2", "AnisotropyMap2", "OrientationMap2", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Multi-Layer"
			append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "GlossinessMap", "SpecularLevelMap", "SelfIllumMap", "OpacityMap", "FilterMap", "DiffuseLevelMap", "DiffuseRoughnessMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Oren-Nayar-Blinn"
			append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "SpecularLevelMap", "GlossinessMap", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Phong"
			append materialList #("DiffuseMap", "GlossinessMap", "MetalnessMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Strauss"
			)


		on btn1 pressed do
			(
			local mm = meditmaterials[medit.GetActiveMtlSlot()]
			if classof mm == MultiMaterial then
				(
				try(propogate mm)
				catch(messagebox "Sorry - there was a problem propogating the sub materials.")
				)
			else messagebox "The current material is not a MultiMaterial.\nSelect a Multimaterial in the Material Editor and try again."
			)
	)
	
createdialog roMultiMaterialPropogator
