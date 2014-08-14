rollout ro1 "MultiMaterial Aligner" width:168 height:168
(
	listBox lbx1 "ListBox" pos:[8,8] width:152 height:10
	
	on ro1 open do 	
	(
		mm=meditmaterials["rgb"][1]
		lbx1.items = getsubanimnames mm[1]
	)
)

createdialog ro1