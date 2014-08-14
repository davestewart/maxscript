/*
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
*/

mm = meditmaterials[medit.GetActiveMtlSlot()]
mat = mm[1]

for i = 1 to mat.maps.count do
	(
	if mat.maps[i] != undefined then
		(
		-- variables
			map = mat.maps[i]
			
		-- maps
			dir = getFilenamePath map.filename
			ext = getFilenameType map.filename
			files = getfiles (dir + "\\*" + ext)

		
		-- materials
			mm.numsubs = files.count
			for j = 2 to mm.numsubs do
				(
				m = mm[j] = copy mat
				m.name = "Material " + (j as string)
				m.maps[i].fileName = files[j]
				)
		)
	)
