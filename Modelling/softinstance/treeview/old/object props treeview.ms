-- create object

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


-- do the ax stuff

	destroydialog test
	
	rollout test "test" (
	
		activeXControl tv "MSComctlLib.TreeCtrl" height:500 width:300 pos:[5,5]
	
--		on tv Click do format"%\n" tv.SelectedItem.fullpath

		on tv OLEDragDrop  Data Effect Button Shift x y do
			(
			-- Data:DataObject
			-- Effect:integer
			-- Button:integer
			-- Shift:integer
			-- x:float
			-- y:float

			format "\n>>OLEDragDrop\n"
			format "> Data		%\n" Data
			format "> Effect	%\n" Effect
			format "> Button	%\n" Button
			format "> Shift		%\n" Shift
			format "> x			%\n" x
			format "> y			%\n" y

			show Data
			)

/*
*/
		on tv NodeClick theNode do
			(
			format ">theNode	%\n" theNode.text
			)


		on test.tv OLEStartDrag Data:DataObject AllowedEffects:integer do
			(
			format "%\n" AllowedEffects
			)

		on test open do (
			tv.lineStyle = #tvwRootLines
			tv.Checkboxes= true
			
			tv.style = #tvwTreelinesPlusMinusText
			tv.SingleSel =false
			tv.PathSeparator = "\\"


	
	-- mods
		for m = 1 to $.modifiers.count do
			(
			--format "\n\n>%\n" $.modifiers[m]
			mNode = tv.nodes.add()
			mNode.text = $.modifiers[m].name as string
			mNode.expanded=true
			mNode.bold=true
			local propArr = getPropNames $.modifiers[m]
			for p in propArr do
				(
				pNode = tv.nodes.add mNode.index 4 "" (p as string)
				pNode.expanded=true
				pNode.checked=true
				--color...
					prop = execute("$.modifiers["+m as string+"][#"+ p as string+"]")
					--format "%\n" (classof prop)
					if classof prop != SubAnim then pNode.forecolor = (color 200 200 200)
					
				theNode=execute("$.modifiers["+m as string+"]."+p as string)
				if (classof theNode==SubAnim) then
					(
					saArr=getPropNames theNode
					for s in saArr do
						(
						gNode = tv.nodes.add pNode.index 4 "" (s as string)
						gNode.checked=true
						)
					)
				)
			)	
	
	-- baseobject
	
		bNode = tv.nodes.add()
		bNode.text = $.baseobject as string
		bNode.expanded=true
		bNode.bold=true
		local propArr = getPropNames $.baseobject
		for p in propArr do
			(
			pNode = tv.nodes.add bNode.index 4 "" (p as string)
			pNode.checked=true
			theNode=execute("$.baseobject."+p as string)
			if (classof theNode==SubAnim) then
				(
				saArr=getPropNames theNode
				for s in saArr do
					(
					gNode = tv.nodes.add pNode.index 4 "" (s as string)
					gNode.checked=true
					)
				)
			)
	
	
	
		)
	)
	
	
	createdialog test 310 510
	/*
	showMethods test.tv
	showEvents test.tv
	
	showproperties test.tv
	showproperties test.tv.nodes[1]
	test.tv.nodes[1].bold=true
	theNode = test.tv.nodes[1].Next.Next
	show theNode
	theNode.ForeColor = (color 200 200 200)
	*/
	test.tv.Font="Tahoma"
	--test.tv.SingleSel=true
	test.tv.OLEDragMode=#ccOLEDragAutomatic 
		-- OLEDragConstants( #ccOLEDragManual | #ccOLEDragAutomatic )
	test.tv.OLEDropMode=#ccOLEDropManual 
		--OLEDropConstants( #ccOLEDropNone | #ccOLEDropManual )
