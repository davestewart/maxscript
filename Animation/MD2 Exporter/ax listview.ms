rollout controlR92 "Microsoft ListView Control, version 6.0"
( 
	activeXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" height:200 width:300 align:#left
	--on ax Click do format "handler: Click\n"
	--on ax DblClick do format "handler: DblClick\n"
	on controlR92 open do
	(
		showProperties ax
		ax.MousePointer = #ccArrow
		ax.GridLines = true
		ax.AllowColumnReorder = true
		ax.BorderStyle = #ccFixedSingle
		ax.view = #lvwReport
		 
		chs = ax.columnHeaders
		--showProperties chs
		--showMethods chs
		 
		hTargets = chs.Add()
		hWeights = chs.Add()
		  
		hTargets.text = "Node"
		hWeights.text = "Weights"
		  
		lis = ax.listItems
		for i=0 to 10 do
		(
			local li
			li = lis.Add()
			li.text = "Item " + i as string
		)
		for li in ax.listItems do li.bold = true
		li = ax.HitTest 100 1500
		if li != undefined do
		(
			showProperties li
			li.text = "Just Hit Tested"
			showEvents controlR92.ax
			showMethods controlR92.ax
		)
	)
)
nr92 = newRolloutFloater "Microsoft ListView Control, version 6.0" 350 300 10 10
addRollout ControlR92 nr92

