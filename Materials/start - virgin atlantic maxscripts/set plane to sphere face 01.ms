/*
polyop.getVert $globe01 23
polyOp.getVertFaces $globe01 23
polyOp.getFaceNormal $globe01 23
*/

$.EditablePoly.SetSelection #Face #{112}

arr=polyOp.getFacesUsingVert $globe01 112

norm=[0,0,0]
facecount=0
for a in arr do
(
	norm += (polyOp.getFaceNormal $globe01 a)
	facecount+=1
)

norm/=facecount

p=plane()
mat=p.transform
mat.rotationpart as eulerangles
p.rotation = (eulerAngles norm.x norm.y norm.z)

p.dir = norm
p.pos = polyop.getfacecenter $globe01 112