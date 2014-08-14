multimat = meditMaterials["rgba"]
for i = 2 to multimat.count do
(
	mat=multimat[1]
	m=multimat[i]

	/*
	m.opacityFallOffType = 1
	m.selfIllumAmount = 100
	m.opacityFallOff = 100
	m.opacityType = 0
	m.opacity = 80
	
	c = m.Diffuse
	c.s = 100
	c.v=200
	m.filterColor = cF
*/

	local b = bezier_float()
	mat.specularLevel.controller = m.specularLevel.controller = b
	m.glossiness.controller = mat.glossiness.controller = bezier_float()
	m.opacity.controller = mat.opacity.controller = bezier_float()
--	m.twoSided = mat.twoSided 

)

--select $LED*
