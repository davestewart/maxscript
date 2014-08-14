
fn tieUpMaterials mmStr=
(
	
	fn loopThroughMatParams mm paramGroupStr=
	(
		local baseMat = mm[1]
		local tempMat
		local paramGroupProps = getsubanimnames baseMat[paramGroupStr]
		for prop in paramGroupProps do
		(
			if classof baseMat[paramGroupStr][prop].value == Float then
			(
				b = bezier_float()
				for i = 2 to mm.count do
				(
					try(
						tempMat = mm[i]
						baseMat[paramGroupStr][prop].controller = b
						tempMat[paramGroupStr][prop].controller = b
					)
					catch()
				)
			)
		)
	)


	/*
	Maps
	Shader_Basic_Parameters
	Extended_Parameters
	SuperSampling
	Dynamics_Properties
	*/

	mm = meditmaterials[mmStr]

	loopThroughMatParams mm #Shader_Basic_Parameters
	loopThroughMatParams mm #Extended_Parameters
)
	
tieUpMaterials "rgb"