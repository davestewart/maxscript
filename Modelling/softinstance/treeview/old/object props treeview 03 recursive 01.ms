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
	select b

destroydialog test
	
--------------------------------------------------------


	rollout test "test" width:512 height:584
		(
		local addToTreeView
	
		function setUpTreeView tv obj=
			(
			tv.nodes.Clear()
			addToTreeView tv obj false
			local n = tv.nodes[1].LastSibling.index
			tv.selectedItem = tv.nodes[n]
			)
	
		function styleTreeView tv singleSel=
			(
			tv.lineStyle = #tvwRootLines
			tv.lineStyle = #tvwTreeLines
			tv.Checkboxes= true
			tv.lineStyle = #tvwRootLines
			tv.BorderStyle=#ccFixedSingle
			tv.Appearance=#ccFlat
			tv.LabelEdit=#tvwManual
			tv.style = #tvwTreelinesPlusMinusText
			tv.SingleSel =singleSel
			tv.PathSeparator = "\\"
			)
		
	
		fn recurseSubAnims obj tv tvNode=
			(
			n = obj.numSubs
			for i = 1 to n do
				(
				newNode = tv.nodes.add tvNode.index 4 "" ((getSubAnimName obj i) as string)
				--(((getSubAnimName obj i) as string) +" ("+classof obj.controller as string+")")
				newNode.expanded=true
				newNode.tag=i as string
/*
				--newNode.tag=expformaxobject((getSubAnimNames obj)[i])	--OK!
				try(
					newNode.tag=expformaxobject(getSubAnimName obj i)
					)
				catch(
					newNode.tag=exprforMaxObject (getSubAnim obj i)			--OK!
					)
				
				try(
					newNode.tag=((expformaxobject obj) as string)
					)
				catch(
					)
*/

				recurseSubAnims obj[i] tv newNode
				)
			)
		

	ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:590 height:590
	label lbl1 "Label" pos:[5,615] width:400 height:15

	on tv1 NodeClick Node do
		(
		lbl1.text = Node.tag

		format "%\n" Node.tag
		)
	
	on test open do
		(
		styleTreeView tv1 true

		obj=$

		
		newNode = tv1.nodes.add()
		newNode.text = obj.name as string
		newNode.expanded=true

		recurseSubAnims obj tv1 newNode
		)
	
			
	
	)

createdialog test 600 630 50 50
--show test.tv1