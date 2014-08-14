		--ActiveXControl tv2 "MSComctlLib.TreeCtrl" pos:[405,5] width:400 height:590

------------------------------------------------------------------------------------


		-- add second treeview
	/*		
	
			local newNode = tv2.nodes.add()
			newNode.text = obj.name as string
			newNode.expanded=true
			recurseSubAnims obj tv2 newNode 0
			recurseSubAnims obj tv1 tv1.nodes 1
	*/
	--		local newNode = tv1.nodes.add()
	
	


------------------------------------------------------------------------------------

	-- rollout resized
		on test resized size do
			(
--			tv1.size.x = size.x/2 - 4
			tv1.size.x = size.x - 4
			tv1.size.y = size.y - 50
/*
			tv2.size.x = size.x/2 - 4
			tv2.size.y = size.y - 50
			tv2.pos.x  = size.x/2 +4
*/
			lbl1.pos.y  = size.y - 40
			lbl2.pos.y  = size.y - 20
			spn1.pos.y = size.y - 20
			)
------------------------------------------------------------------------------------
			
	-- spinner change
		on spn1 changed val do
			(
			if val <= il.ListImages.count then
				(
				tv1.nodes[1].image=val
				lbl2.text = classArr[val] as string
				)
			else spn1.value=il.ListImages.count
			)


------------------------------------------------------------------------------------

-- place after POPULATE TREEVIEWS
			prevNode=tv1.nodes[1]
			curNode=tv1.nodes[1]
	

-- place before on tv1 open

		-- SET UP NODE CLICKS
		local prevNode, curNode

------------------------------------------------------------------------------------
	on tv1 NodeClick Node do
		(
			prevNode=curNode
			curNode = tv1.selectedItem
			
			prevNode.bold=false
			curNode.bold=true
			--curNode.backcolor = (color 200 200 200)
		-- update the label
			lbl1.text = Node.fullpath

		-- get the max object
	
		)