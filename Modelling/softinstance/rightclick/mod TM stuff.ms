obj=$
addModifier obj (affect_region()) 
objTM=obj.objecttransform 
modTM=getModContextTM obj obj.affect_region 
-- calculate world coordinates of end point 
	obj.affect_region.end_point * (inverse modTM) * objTM 
-- set end point at world coordinates [20,20,0] 
	obj.affect_region.end_point = [20,20,0] * modTM * (inverse objTM) 
