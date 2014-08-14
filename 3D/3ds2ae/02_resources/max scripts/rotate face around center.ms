(
angle = 45
selected_faces = (polyOp.getFaceSelection $) as array
center_face = polyOp.getFaceCenter $ selected_faces[1]
transform_mat = matrixFromNormal (polyOp.getFaceNormal $ selected_faces[1])
transform_mat.row4 = center_face --move TM to center of polygon

face_vertices = (polyOp.getVertsUsingFace $ #selection) as array

for v in face_vertices do
	(
	in coordsys transform_mat --get vertex in Normal's TM coordinates
	vertex_position = (polyOp.getVert $ v) 
	-- create a Rotation TM, transform in the Normal's TM:
	RotateZ = (rotateZMatrix angle) * transform_mat 
	-- finally, set the vertex to the position transformed by the rotation matrix
	polyOp.setVert $ v (vertex_position * RotateZ)
	)
)

