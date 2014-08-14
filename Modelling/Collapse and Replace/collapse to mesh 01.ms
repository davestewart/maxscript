mats = #()
for obj in $ do if finditem mats obj.material == 0 do append mats obj.material

print mats


for f = 1 to $.numfaces do print (getFaceMatID $ f)

meditmaterials[5] = mMat
mMat = multimaterial numsubs:mats.count
for i = 1 to mats.count do mMat[i] = mats[i]


attach


deleteSourceNode:<boolean=true>
clonenodes

c = copy (getcurrentselection())
select c
move c [100,0,0]

sel2
maxops.cloneNodes &sel offset:[20,0,0] cloneType:#copy newNodes:sel2 actualNodeList:&sel2
select sel2

-- copy objects
	sel = (getcurrentselection())
	arr = #()
	for obj in sel do
		(
		newObj = copy obj
		append arr newObj
		)
	--move arr [20,0,0]
	delete sel
	select arr
	
-- collapse to mesh
	for obj in arr do convertToMesh obj
	objSource = arr[arr.count]
	arr.count = arr.count - 1

	for obj in arr do
		(
		print obj
		meshop.attach objSource obj attachMat:#IDToMat condenseMat:true
		)
