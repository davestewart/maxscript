struct showLastHidden
	(
	nodeList = #()
	,
	fn addNode =
		(
		local obj = callbacks.notificationParam()
		showLastHidden.nodes[showLastHidden.nodes.count].append obj
		)
	,
	fn showNodes =
		(
		unhide showLastHidden.nodes[nodes.count]
		showLastHidden.nodes.count = nodes.count - 1
		)
	,
	fn update=
		(
		if showLastHidden.nodes[showLastHidden.nodes.count] > 0 then append showLastHidden.nodes (#())
		)
	)


struct showLastHidden
	(
	nodes = #(#())
	,
	fn addNode =
		(
		local obj = callbacks.notificationParam()
		append nodes[nodes.count] obj
		)
	,
	fn showNodes =
		(
		unhide nodes[nodes.count]
		nodes.count = nodes.count - 1
		)
	,
	fn update=
		(
		if nodes[nodes.count].count > 0 then append nodes[nodes.count] (#())
		)
	)


callbacks.removeScripts id:#addNodeToHiddenList
callbacks.removeScripts id:#updateToHiddenList

callbacks.addScript #nodeHide "hiddenList.addNode()" id:#addNodeToHiddenList
callbacks.addScript #selectionSetChanged "hiddenList.update()" id:#updateToHiddenList

global hiddenList = showLastHidden()



hiddenList.addNode


 callbacks.notificationParam()


showLastHidden.showNodes()


fn unhideLastHiddenNodes =
	(
	unhide lastHiddenNodes
	lastHiddenNodes = #()
	)
	
unhideLastHiddenNodes()
showLastHidden.nodeList
.nodes

macroScript unhideLastHiddenNodes category:"Tools"

tooltip:"Unhide Last Hidden" Icon:#("Cameras",1)

(

StartObjectCreation TargetCamera

)
