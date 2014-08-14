	
with animate on
	(
	for i = 1 to cameraData.count do
		at time i
			(
			--$.pos = cameraData[i].pos
			local rot = 
			$.rotation = cameraData[i].rot
			)
	)

	t = currenttime as integer / ticksperframe
	rot = cameraData[t].rot
	pos = cameraData[t].pos
	
	$.rotation.controller.x_rotation = rot.x
	$.rotation.controller.y_rotation = rot.y
	$.rotation.controller.z_rotation = rot.z
	
	$.rotation.z = -rot.y / (180 / pi)
	$.rotation.y = -rot.z / (180 / pi)
	
	$.pos = pos




	
b = particleData[10]
arr = for d in b collect d.pos
arrayToSpline arr

d = getParticleData 1
arr = for i in d collect i.pos
arrayToSpline arr


cameraData

cameraData[94].rot
	for i = 1 to particleData.count do
		(
		b = particleData[i]
		arr = for d in b collect d.pos
		arrayToSpline arr
		)
		
	paths = 	$shape* as array
	
	paths.pos += origin.pos

	b = getParticleData pf 1
	b = particleData[9]
	
	arr = for d in b collect d.pos
	arrayToSpline arr
