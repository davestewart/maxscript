rollout roVis "Visibility" width:168 height:56
(
	slider sld1 "Visibility" pos:[8,8] width:152 height:44 range:[0.0,1.0,1] type:#float ticks:10
	on sld1 changed value do
		(
		for obj in (getCurrentSelection()) do
			(
			if obj[1].controller == undefined then
				(
				obj.visibility = true
				obj.visibility.controller = bezier_float()
				)
			obj[1].value = sld1.value
			)
		)
	
)
createdialog roVis

