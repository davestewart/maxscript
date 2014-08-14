ext="jpg"

/*
r=getSavePath "Select the directory with the files..."
files = getfiles (dir + "\\*." + ext)
*/

map = "opacityMap"


mm = meditmaterials[medit.GetActiveMtlSlot()]

mat = mm[1]
map = mat.opacityMap
dir = getFilenamePath map.filename
ext = getFilenameType map.filename


files = getfiles (dir + "\\*." + ext)

mm.numsubs = files.count

for i = 2 to mm.numsubs do
	(
	m = mm[i] = copy mat
	m.name = "Material " + i as string
	m.opacityMap.fileName = files[i]
	)
	
	mm[4].name
	
	
struct mapList (a, b, c)