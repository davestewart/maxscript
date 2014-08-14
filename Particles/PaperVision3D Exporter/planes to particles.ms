pf = $'PF Source 01'
--showinterfaces pf

boxes = $box* as array

for i = 1 to (pf.numParticles()) do
(
	pf.particleIndex = i
	local b = boxes[i]
	local pos = pf.particlePosition
	local rot = pf.particleOrientation

	--print (b.rotation.controller.value as string)-- = rot-- as quat

	--local tm = matrix3 [1,0,0]  [0,1,0]  [0,0,1]  [0,0,0]
	--rotate tm (eulertoquat (rot as eulerAngles))
	--print (rot)
	--b.transform = tm
	b.pos = pos
	--b.rotation.controller.value as string)-- = rot-- as quat
	
	x = rot.x * 180 / Pi
	y = rot.y * 180 / Pi
	z = rot.z * 180 / Pi
	
	b.rotation.controller[1].controller.value = x
	b.rotation.controller[2].controller.value = y
	b.rotation.controller[3].controller.value = z
	
	format "%, %, %\n" x y z
	
	--format "%, %, %\n" i pos rot
)