fn round n = 
(
	if classof n == Point3 do return [round n.x, round n.y, round n.z]
	return floor (n as float + 0.5)
)


fn arrayToString arr del:"," =
(
	local str = ""
	if del == unsupplied do del = ","
	for i = 1 to arr.count do
	(
		str += arr[i] as string
		if i < arr.count do str += del
	)
	str
)
obj
fn exportObject obj =
(
	-- variables
		local numVerts	= polyOp.getNumVerts obj
		local numFaces	= polyOp.getNumFaces obj

		local arrVerts	= #()
		local arrFaces	= #()
		local arrMats	= #()
		
		local ssVerts = stringstream ""
		local ssFaces = stringstream ""
		local ssColors = stringstream ""
		
	-- verts
		for v = 1 to numVerts do
		(
			append arrVerts (polyOp.getVert obj v)
		)
	
	-- faces
		for f = 1 to numFaces do
		(
			append arrFaces (polyOp.getFaceVerts obj f)
			append arrMats (polyOp.getFaceMatID obj f)
		)

	-- colors

	-- print output
		for v in arrVerts do
		(
			local str	= arrayToString #(v.x, v.y, v.z)
			format "\t\t<vert>%</vert>\n" str to:ssVerts
		)
			
		for i = 1 to arrFaces.count do
		(
			local id	= arrMats[i]
			local str	= arrayToString arrFaces[i]
			format "\t\t<face id=\"%\">%</face>\n" id str to:ssFaces
		)
		
		if classof obj.material == MultiMaterial do
		(
			local mm = obj.material
			for i = 1 to mm.numSubs do
			(
				local col	= mm[i].diffuse
				local str	= arrayToString #(col.r, col.g, col.b)
				format "\t\t<color>%</color>\n" str to:ssColors
			)
		)
		
		for i = 1 to arrFaces.count do
		(
			local id	= arrMats[i]
			local str	= arrayToString arrFaces[i]
			format "\t\t<face id=\"%\">%</face>\n" id str to:ssFaces
		)
		
	

		format "<mesh>\n"
		format "\t<verts>\n%\t</verts>\n" (ssVerts as string) 
		format "\t<faces>\n%\t</faces>\n" (ssFaces as string)
		format "\t<colors>\n%\t</colors>\n" (ssColors as string) 
		format "</mesh>\n"
)




exportObject $
/*
for arrVerts in arrFaces do
(
	format "arrFaces.push(["
	for i = 1 to arrVerts.count do
	(
		local x = floor arrVerts[i].x
		local y = floor arrVerts[i].y
		local z = floor arrVerts[i].z
		format "[%,%,%]" x y z
		if i < arrVerts.count do format ","
	)
	format "])\n"
)
	
	
	
for m in arrFaceId do format "%," m

*/