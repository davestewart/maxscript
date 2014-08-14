fn round n = 
(
	if classof n == Point3 do return [round n.x, round n.y, round n.z]
	return floor (n as float + 0.5)
)

arrMesh = #()
arrFaces = #()
arrMats = #()
mat = $.material
createMesh = true

for f = 1 to polyOp.getNumFaces $ do
(
	-- material
		local id = polyOp.getFaceMatID $ f
		append arrMats id

	-- verts	
		baVerts = polyOp.getFaceVerts $ f
		arrFaceVerts = for v in baVerts collect polyOp.getVert $ v
		append arrFaces arrFaceVerts
		
	-- create mesh
		if createMesh do
		(
			if arrFaceVerts.count == 3 then
				m = mesh vertices:arrFaceVerts faces:#([1,2,3])
			else
				m = mesh vertices:arrFaceVerts faces:#([1,2,3], [3,4,1])
			append arrMesh m
		)
)


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
