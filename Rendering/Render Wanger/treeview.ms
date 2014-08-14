rollout rTreeView "Microsoft TreeView Control 6.0 (SP4)"
( 
	activeXControl tvObjects "{C74190B6-8589-11D1-B16A-00C0F0283628}" height:200 width:300 align:#left setupEvents:false
	
	fn initTreeView tv =
	(
		tv.labelEdit = #tvwManual
		tv.lineStyle = #tvwRootLines
		tv.style = #tvwTreelinesPlusMinusText
		tv.indentation = 0
		tv.pathseparator = "."
		tv.hotTracking = true
		tv.hideSelection = false
	)
	
	fn addNodesToTreeView tv_nodes max_nodes parent:undefined =
	(
		for i=1 to max_nodes.count do
		(
			local c = max_nodes[i], tvn
			tvn = tv_nodes.add()
			tvn.text = c.name
			if parent != undefined then tvn.parent = parent
			addNodesToTreeView tv_nodes c.children parent:tvn
		)
	)
	
	on rTreeView open do
	(
		showMethods tvObjects
		initTreeView tvObjects
		addNodesToTreeView tvObjects.nodes rootNode.children
		--showProperties tvObjects
	)
	
	on tvObjects click do
	(
		local obj = tvObjects.SelectedItem 
		print obj
		select (getNodeByName obj)
	)
)
createDialog rTreeView height:210 width:330

--With compliments of Ravi from discreet
