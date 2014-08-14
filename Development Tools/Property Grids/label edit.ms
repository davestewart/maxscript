rollout ro1 "ListView Selected"
	(
	fn initListView lv =
		(
		lv.gridLines = true  
		lv.View = #lvwReport  
		lv.fullRowSelect = true 
		 
		layout_def = #("Object Name","Object Class","Verts","Faces","Material")
		 
		for i in layout_def do
			(
			column = lv.ColumnHeaders.add() 
			column.text = I
			) 
		) 
	 
	fn fillInSpreadSheet lv =
		(
		for o in selection do
			(
			li = lv.ListItems.add()
			li.text = o.name
			sub_li = li.ListSubItems.add()
			sub_li.text = (classof o) as string
			sub_li = li.ListSubItems.add()
			sub_li.text = try((o.mesh.numverts) as string)catch("--")
			sub_li = li.ListSubItems.add()
			sub_li.text = try((o.mesh.numfaces) as string)catch("--")
			sub_li = li.ListSubItems.add()
			sub_li.text = (o.material) as string
			)
		) 
	 
	activeXControl ax1 "MSComctlLib.ListViewCtrl" width:490 height:190 align:#center 
	on ro1 open do 
		(
		initListView ax1
		fillInSpreadSheet ax1
		ax1.LabelEdit = #lvwManual

		) 
	)
	
try(destroyDialog listview_rollout)catch()
createDialog ro1 500 200


show ro1.ax1