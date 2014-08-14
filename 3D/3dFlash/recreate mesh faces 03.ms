arrFaces	= #()
arrFaceId	= #()



fn createObjPerFace obj = (

	local meshes = #()

	-- Number of faces of the original object
		local numFaces = polyOp.getNumFaces obj

	-- Loop through all faces
		for f = 1 to numFaces do (
	
	
			-- id
				append arrFaceId (polyOp.getFaceMatID obj f)
	
			-- Indices to the vertices for the current face
				indices = polyOp.getFaceVerts obj f
	
			-- Face vertices
				verts = for idx in indices collect (polyOp.getVert obj idx)
			
				append arrFaces verts
	
			-- Temporary indices
				local v1, v2, v3		
				
			-- Array of indices that conform the new face (mesh)
				local meshFaces = #()
				
			-- Number of faces (triangles) to create
				local numMeshFaces = verts.count - 2
	
			-- Loop through the faces of the new mesh and create the indices
				for nFace = 1 to numMeshFaces do (
		
					if nFace == 1 then (
						-- If this is the first face, we know the indices
						v1 = 1; v2 = 2; v3 = 3
					)
					else (
						-- Else, we have to increment them based upon previous indices
						v2 += 1; v3 += 1
					)
	
				-- Append the current face to the array of faces
					append meshFaces [v1,v2,v3]
			)
		
		-- Create and append the new mesh to our list of meshes
			--append meshes (mesh vertices:verts faces:meshFaces)
	)

	-- Return the mesh list
		--return meshes
)


createObjPerFace $
