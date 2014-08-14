fn assignRandomColors =
(
	meditmaterials[1] = multimaterial()
	for i = 1 to 10 do
	(
		meditmaterials[1][i].diffuse = random (white * 0.25) white
		meditmaterials[1][i].opacity = 50
	)
)

--assignRandomColors()

fn round n = 
(
	if classof n == Point3 do return [round n.x, round n.y, round n.z]
	floor (n as float + 0.5)
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

fn exportObject obj =
(
	
	-- check class
		if classof obj != Editable_Poly do convertToPoly obj
	
	-- variables
		local numVerts	= polyOp.getNumVerts obj
		local numFaces	= polyOp.getNumFaces obj

		local arrVerts	= #()
		local arrFaces	= #()
		local arrMats	= #()
		
		local ssVerts	= stringstream ""
		local ssFaces	= stringstream ""
		local ssColors	= stringstream ""
		local ssXml		= stringstream ""
		
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
		-- verts
			for v in arrVerts do
			(
				local str	= arrayToString #(v.x, -v.z, v.y)
				format "\t\t<vert>%</vert>\n" str to:ssVerts
			)
				
		-- faces
			for i = 1 to arrFaces.count do
			(
				local id	= arrMats[i]
				local str	= arrayToString arrFaces[i]
				format "\t\t<face id=\"%\">%</face>\n" id str to:ssFaces
			)

		-- material			
			if classof obj.material == MultiMaterial do
			(
				local mm = obj.material
				for i = 1 to mm.numSubs do
				(
					local col		= mm[i].diffuse
					local colStr	= arrayToString #(col.r, col.g, col.b)
					local opac		= mm[i].opacity as string
					
					format "\t\t<color alpha=\"%\">%</color>\n" opac colStr to:ssColors
				)
			)
/*
		for i = 1 to arrFaces.count do
		(
			local id	= arrMats[i]
			local str	= arrayToString arrFaces[i]
			format "\t\t<face id=\"%\">%</face>\n" id str to:ssFaces
		)
*/

		format "<mesh>\n" to:ssXml
		format "\t<verts>\n%\t</verts>\n" (ssVerts as string) to:ssXml
		format "\t<faces>\n%\t</faces>\n" (ssFaces as string) to:ssXml
		format "\t<colors>\n%\t</colors>\n" (ssColors as string) to:ssXml
		format "</mesh>\n" to:ssXml
		
		local fName	 = getsavefilename caption:"Save XML file:" filename:(obj.name + ".xml")
		local fFile
		
		if fName != undefined do fFile = createfile fName
		if fFile != undefined do
		(
			format "%" (ssXml as string) to:fFile
			flush fFile
			close fFile
		)
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