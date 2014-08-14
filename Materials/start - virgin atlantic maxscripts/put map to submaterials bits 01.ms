
materialList = #()
append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "DiffuseLevelMap", "SpecularLevelMap", "GlossinessMap", "AnisotropyMap", "OrientationMap", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Anisotropic"
append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "SpecularLevelMap", "GlossinessMap", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Blinn"
append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "SpecularLevelMap", "GlossinessMap", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Metal"
append materialList #("AmbientMap", "DiffuseMap", "DiffuseLevelMap", "DiffuseRoughnessMap", "SpecularMap", "SpecularLevelMap", "GlossinessMap", "AnisotropyMap", "OrientationMap", "specularMap2", "SpecularLevelMap2", "GlossinessMap2", "AnisotropyMap2", "OrientationMap2", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Multi-Layer"
append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "GlossinessMap", "SpecularLevelMap", "SelfIllumMap", "OpacityMap", "FilterMap", "DiffuseLevelMap", "DiffuseRoughnessMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Oren-Nayar-Blinn"
append materialList #("AmbientMap", "DiffuseMap", "SpecularMap", "SpecularLevelMap", "GlossinessMap", "SelfIllumMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Phong"
append materialList #("DiffuseMap", "GlossinessMap", "MetalnessMap", "OpacityMap", "FilterMap", "BumpMap", "ReflectionMap", "RefractionMap", "DisplacementMap") -- "Strauss"



rollout ro1 "MultiMaterial Aligner" width:168 height:168
(
	listBox lbx1 "ListBox" pos:[8,8] width:152 height:10
	
	on ro1 open do 	
		(
		mm = meditmaterials[medit.GetActiveMtlSlot()]
		lbx1.items = getsubanimnames mm.[1]
		)
)

createdialog ro1

mm = meditmaterials[medit.GetActiveMtlSlot()]

for i = 1 to mm[1].maps.count do
	(
	local st=mm[1].shaderType+1
	if mm[1].maps[i] != undefined then
		(
		format "% %\n" i materialList[st][i]
		)
	)


mm[1].shaderType

maps

mm[1].maps.count

for i = 1 to mm[1][1].numsubs do print mm[1][1][i][3]


print (getpropnames mm[1])

show mm[1].maps[7]


mm[1].opacityMap