-- create object
/*
	if b==undefined then
		(
		b=box()
		addModifier b (Bend ())
		addModifier b (Taper ())
		addModifier b (Twist ())
		addModifier b (Noisemodifier ())
		addModifier b (Stretch ())
		addModifier b (Squeeze ())
		addModifier b (Push ())
		addModifier b (Relax ())
		addModifier b (Relax ())
		addModifier b (Ripple ())
		addModifier b (Wave ())
		addModifier b (Skew ())
		addModifier b (SliceModifier ())
		addModifier b (Spherify ())
		addModifier b (Affect_Region ())
		addModifier b (Lattice ())
		addModifier b (Mirror ())
		addModifier b (Displace ())
		addModifier b (XForm ())
		addModifier b (Preserve ())
		)
		select b
*/

-- do the ax stuff
--------------------------------------------------------






--------------------------------------------------------
	--destroydialog test
	
--------------------------------------------------------


	rollout test "test" width:512 height:584
	(
	local addToTreeView
	

--------------------------------------------------------
	
		ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:240 height:500
		ActiveXControl tv2 "MSComctlLib.TreeCtrl" pos:[265,5] width:240 height:500
		--activeXControl il "MSComctlLib.ImageListCtrl" height:100 width:100 pos:[505,5]-- imagelist control

--------------------------------------------------------

	function setUpTreeView tv obj=
		(
		tv.nodes.Clear()
		addToTreeView tv obj false
		local n = tv.nodes[1].LastSibling.index
		tv.selectedItem = tv.nodes[n]
		)


	function styleTreeView tv singleSel=
		(

	-- styling
		tv.lineStyle = #tvwRootLines
		tv.lineStyle = #tvwTreeLines
		  /*
		  .LineStyle : TreeLineStyleConstants( 
		  	#tvwTreeLines
			#tvwRootLines
			)
		  */

		tv.Checkboxes= true

		tv.lineStyle = #tvwRootLines
		tv.BorderStyle=#ccFixedSingle
		tv.Appearance=#ccFlat
		tv.LabelEdit=#tvwManual
		

		tv.style = #tvwTreelinesPlusMinusText
--		tv.style = #tvwTreelinesText

		  /*
		  .Style : TreeStyleConstants( 
		  	#tvwTextOnly
			#tvwPictureText
			#tvwPlusMinusText
			#tvwPlusPictureText
			#tvwTreelinesText
			#tvwTreelinesPictureText
			#tvwTreelinesPlusMinusText
			#tvwTreelinesPlusMinusPictureText
			)
		  */

		tv.SingleSel =singleSel
		tv.PathSeparator = "\\"


	-- select baseObject
	
		)
	

	function addToTreeView tv obj expand =
		(
		-- mods
			for m = 1 to obj.modifiers.count do
				(
				--format "\n\n>%\n" obj.modifiers[m]
				mNode = tv.nodes.add()
				mNode.text = obj.modifiers[m].name as string
				mNode.expanded=expand 
				--mNode.bold=true
				local propArr = getPropNames obj.modifiers[m]
				for p in propArr do
					(
					pNode = tv.nodes.add mNode.index 4 "" (p as string)
					pNode.expanded=expand 
					pNode.checked=false
					--color...
						prop = execute("$"+obj.name+".modifiers["+m as string+"][#"+ p as string+"]")
						--format "%\n" (classof prop)
						if classof prop != SubAnim then pNode.forecolor = (color 200 200 200)
						
					theNode=execute("$"+obj.name+".modifiers["+m as string+"]."+p as string)
					if (classof theNode==SubAnim) then
						(
						saArr=getPropNames theNode
						for s in saArr do
							(
							gNode = tv.nodes.add pNode.index 4 "" (s as string)
							gNode.expanded=true
							gNode.checked=true
							)
						)
					)
				)	
		
		-- baseobject
		
			bNode = tv.nodes.add()
			bNode.text = obj.baseobject as string
			bNode.expanded=expand 
			bNode.bold=true
			local propArr = getPropNames obj.baseobject
			for p in propArr do
				(
				pNode = tv.nodes.add bNode.index 4 "" (p as string)
				pNode.checked=true
				theNode=execute("$"+obj.name+".baseobject."+p as string)
				if (classof theNode==SubAnim) then
					(
					saArr=getPropNames theNode
					for s in saArr do
						(
						gNode = tv.nodes.add	pNode.index	4	""	(s as string)
/*
												Relative:undefined
															Relationship:undefined
																Key:undefined
																	Text:undefined
																					Image:undefined
																							SelectedImage:undefined
*/

						gNode.expanded=true
						gNode.checked=true
						)
					)
				)
	)-- end function	
/*
  node.Add 
  	Relative:undefined
	Relationship:undefined
	Key:undefined
	Text:undefined
	Image:undefined
	SelectedImage:undefined

*/
--------------------------------------------------------


		button btn1 "Pick Object" pos:[5,510] width:240 height:15
		button btn2 "Pick Object" pos:[265,510] width:240 height:15
		button btnDir ">" pos:[245,5] width:20 height:500

		label lbl1 "Label" pos:[5,530] width:240 height:15
		label lbl2 "Label" pos:[265,530] width:240 height:15

		on test open do
			(
			styleTreeView tv1 true
			styleTreeView tv2 true
			)

		on btn1 pressed do setUpTreeView tv1 (pickObject())
		on btn2 pressed do setUpTreeView tv2 (pickObject())

		on btnDir pressed do
			(
			if btnDir.text==">" then btnDir.text="<"
			else btnDir.text=">"
			)

		on tv1 NodeClick Node do lbl1.text = Node.fullpath
		on tv2 NodeClick Node do lbl2.text = Node.fullpath



		

	)
--------------------------------------------------------
	


	createdialog test --510 510

show test.tv1