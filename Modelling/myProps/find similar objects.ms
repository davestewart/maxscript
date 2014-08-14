
-- declare source object
	source = $
	sourceClass = classOf source
	sourceStack = source.modifiers

-- find similar base objects
	objArray1 = #()
	for obj in objects do
		if iskindof obj sourceClass then append objArray1 obj 
-- narrow to objects with identical modifiers
	objArray2 = #()
	for obj in objArray1 do
		if obj.modifiers = sourceStack then append objArray2 obj
		objArray2
	

compatibleObjects = obj in 

$.modifiers.count

if $.modifiers.count == 3 then
	collect $ objArray 

sort objArray

bigones = for obj in $box* -- you can sequence pathnames! 
where obj.height > 100 collect obj -- 
objArray =  for obj in superclassof $
	where .modifiers.count == 2 collect obj
