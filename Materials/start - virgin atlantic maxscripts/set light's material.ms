for i = 2 to meditMaterials["RGB_on"].count do
(
	m0=	m=meditMaterials["RGB_on"][1]
	m=meditMaterials["RGB_on"][i]

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

	m.specularLevel = m0.specularLevel
	m.glossiness = m0.glossiness
	m.opacity = m0.opacity
	m.twoSided = m0.twoSided 

)

--select $LED*
