/*
objSrc=$
objList=getCurrentSelection()

for objTrg in objList do
	(
	convertToMesh objTrg
	meshop.attach objSrc objTrg attachMat:#IDToMat condenseMat:true
	
)


while objects.count > 1 do
	(
	converttomesh objects[1]
	meshop.attach objects[1] objects[2] attachMat:#IDToMat condenseMat:true
	)
	
*/

while (getcurrentselection()).count > 1 do meshop.attach (converttomesh $[1]) $[2] attachMat:#IDToMat condenseMat:true
