arrMesh = #()
arrFaces = #()

createMesh = true
for f = 1 to polyOp.getNumFaces $ do
	(
	-- verts	
		baVerts			= polyOp.getVertsUsingFace $ #{f}
		arrFaceVerts	= for v in baVerts collect polyOp.getVert $ v
		append arrFaces arrFaceVerts
		
	-- create mesh
		if createMesh do
			(
			if arrFaceVerts.count == 3 then
				m = mesh vertices:arrFaceVerts faces:#([1,2,3])
			else
				m = mesh vertices:arrFaceVerts faces:#([1,2,3],[4,3,2])
			append arrMesh m
			)
	)



//showallactivexcontrols to:(newscript())