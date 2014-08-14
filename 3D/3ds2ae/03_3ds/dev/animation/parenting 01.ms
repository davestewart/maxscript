-- get a sub selection
	selArr=$ as array
	
-- collect objects to new array according to their order in the $objects array
	arr=for obj in objects where (finditem selArr obj > 0) collect obj
	
-- examine arrays
	print selArr
	print arr
	
	arr.count
	selArr.count
	objects.count
	
-- step through arrays
	i=0
	select arr[i+=1]
	
	i=0
	select selArr[i+=1]
	
	i=0
	select objects[i+=1]

