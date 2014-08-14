rollout treeview_rollout "TreeView Scene Browser"
	(

	activeXControl tv "MSComctlLib.TreeCtrl" width:290 height:490 align:#center 
	activeXControl ilTv "MSComctlLib.ImageListCtrl" height:0 width:0


	fn getIconFromBitmap thePath number =
		(
		tempBmp = openBitmap thePath
		iconBmp = bitmap 16 15
		for v = 0 to 14 do
		setPixels iconBmp [0,v] (getPixels tempBmp [(number-1)*16, v] 16)
		iconBmp.filename = getDir #image +"/_temp.bmp"
		save iconBmp
		close iconBmp 
		close tempBmp
		getDir #image +"/_temp.bmp"
		)
	 
	fn initTreeView tv ilTv =
		(
		tv.Indentation = 28*15
		tv.LineStyle = #tvwRootLines 
		tv.checkboxes = true
		tv.sorted = true
		ilTv.imagewidth = 16
		ilTv.imageheight = 15
		iconDir = (getDir #ui) + "\\icons"
		ilTv.listImages.add 1 #root (loadPicture (getIconFromBitmap (iconDir + "\\Standard_16i.bmp") 2))
		ilTv.listImages.add 2 #geomnode (loadPicture (getIconFromBitmap (iconDir + "\\Standard_16i.bmp") 1))
		ilTv.listImages.add 3 #light (loadPicture (getIconFromBitmap (iconDir + "\\Lights_16i.bmp") 3))
		ilTv.listImages.add 4 #camera (loadPicture (getIconFromBitmap (iconDir + "\\Cameras_16i.bmp") 2))
		ilTv.listImages.add 5 #helper (loadPicture (getIconFromBitmap (iconDir + "\\Helpers_16i.bmp") 1))
		tv.imageList = ilTv 
		) 
	 
	fn addChildren tv theNode theChildren =
		(
		for c in theChildren do
			(
			theIcon = case superclassof c of
				(
				GeometryClass: 2
				Light: 3
				Camera: 4
				Helper: 5
				Default:2
				)
			newNode = tv.Nodes.add theNode.index 4 "" c.name theIcon
			theNode.sorted = true
			newNode.checked = not c.isHidden
			newNode.forecolor = color c.wirecolor.b c.wirecolor.g c.wirecolor.r
			addChildren tv newNode c.children
			)
		)
	 
	fn fillInTreeView tv =
		(
		theRoot = tv.Nodes.add()
		theRoot.image = 1
		theRoot.text = "WORLD ROOT"
		rootNodes = for o in objects where o.parent == undefined collect o
		addChildren tv theRoot rootNodes 
		) 
	 
	on tv NodeCheck theNode do 
		(
		theSceneNode = (getNodeByName theNode.text)
		if theSceneNode != undefined do
		theSceneNode.isHidden = not theNode.checked
		) 
	 
	on tv nodeClick theNode do try(select (getNodeByName theNode.text))catch()
	on treeview_rollout open do 
		(
		initTreeView tv ilTv
		fillInTreeView tv
		) 
	)
try(destroyDialog treeview_rollout)catch()
createDialog treeview_rollout 300 500