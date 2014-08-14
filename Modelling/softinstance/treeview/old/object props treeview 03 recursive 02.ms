if NOT isvalidnode b then
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
	b.material = meditmaterials[1]
	select b
	)
destroydialog test
	
--------------------------------------------------------


	rollout test "Copy Properties" width:512 height:584
		(
		local addToTreeView
		local obj, replaceAll

		fn replaceAll str outStr inStr =
			(
			-- str the original string
			-- the string/character to replace
			-- the replacement string/character
			
			origStr=str
			while ((n=findstring str outStr) != undefined) do str = replace str n inStr.count inStr
			if str != undefined then return str
			else return origStr
			)

		fn setUpTreeView tv obj=
			(
			tv.nodes.Clear()
			addToTreeView tv obj false
			local n = tv.nodes[1].LastSibling.index
			tv.selectedItem = tv.nodes[n]
			)
	
		fn styleTreeView tv singleSel=
			(
			tv.lineStyle = #tvwRootLines
			tv.lineStyle = #tvwTreeLines
			tv.Checkboxes= true
			--tv.lineStyle = #tvwRootLines
			tv.BorderStyle=#ccFixedSingle
			tv.Appearance=#ccFlat
			tv.LabelEdit=#tvwManual
			tv.style = #tvwTreelinesPlusMinusText
			tv.SingleSel=false--singleSel
			tv.PathSeparator = "\\"
			)
		
	
		fn recurseSubAnims obj tv tvNode d=
			(
			d+=1
			n = obj.numSubs
			for i = 1 to n do
				(
				local nodeText = ((getSubAnimName obj i) as string)
				newNode = tv.nodes.add tvNode.index 4 "" (replaceAll nodeText "_" " ")
				if d!=2 then newNode.expanded=true
				newNode.tag=i as string
				recurseSubAnims obj[i] tv newNode d
				)
			)

		fn reverseArray inArr =
			(
			local outArr = #()
			while inArr.count > 0 do
				(
				append outArr inArr[inArr.count]
				deleteItem inArr inArr.count
				)
			return outArr
			)

		fn getSubAnimArray nodeArr =
			(
			local str=""
			for n in nodeArr do str+="["+n as string+"]"
			return str
			)


	ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:400 height:590
	ActiveXControl tv2 "MSComctlLib.TreeCtrl" pos:[405,5] width:400 height:590
	label lbl1 "Label" pos:[5,615] width:400 height:15



	local prevNode, curNode

	
	
	on tv1 NodeClick Node do
		(
			prevNode=curNode
			curNode = tv1.selectedItem
			
			prevNode.bold=false
			curNode.bold=true
		
		-- update the label
			lbl1.text = Node.fullpath

		-- get the max object
			local inode = Node
			local nodeArr=#()
			
			while inode.parent!=undefined do
				(
				append nodeArr (inode.tag as Integer)
				inode=inode.parent
				)
			
			nodeArr= reverseArray nodeArr
			format "%\n" nodeArr
	
			local subAnimArr = getSubAnimArray nodeArr
			local subAnimObj = execute("$"+subAnimArr)
	
			format "%\n" (exprformaxobject subAnimObj)
		
		)
	
	on test open do
		(
		styleTreeView tv1 true
		styleTreeView tv2 true

		obj=$
		
		local newNode = tv1.nodes.add()
		newNode.text = obj.name as string
		newNode.expanded=true
		recurseSubAnims obj tv1 newNode 0

		local newNode = tv2.nodes.add()
		newNode.text = obj.name as string
		newNode.expanded=true
		recurseSubAnims obj tv2 newNode 0

		prevNode=tv1.nodes[1]
		curNode=tv1.nodes[1]
		)
	
			
	
	)

createdialog test 810 660 50 50 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu)
--show test.tv1

