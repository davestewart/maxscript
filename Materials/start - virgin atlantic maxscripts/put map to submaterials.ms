ext="jpg"

/*
r=getSavePath "Select the directory with the files..."
files = getfiles (dir + "\\*." + ext)
*/

map = "opacityMap"
mm = meditmaterials["Clouds"]

mat = meditmaterials[1][1]

getFilenamePath 
files = getfiles (dir + "\\*." + ext)

for i = 2 to mm.numsubs do
	(
	m = meditmaterials[1][i] = copy mat
	f = m.opacityMap.fileName 
	m.opacityMap.fileName = files[i]
	)
getfiles

 

getFiles <wild_card_filename_string>

Returns an array of file names that match the given wild-card path name. The following example gets an array of all the .max scene files in c:\foo and then loops over the array, opening each file and printing the objects in each:

files = getFiles "c:\\foo\\*.max"

for f in files do (loadMAXFile f; print objects)
getsavefilename


