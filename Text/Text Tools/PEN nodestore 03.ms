def=attributes nodeStore redefine:def
	(



	--------------------------------------------------------------------------
	-- variables
	--------------------------------------------------------------------------



	--------------------------------------------------------------------------
	-- parameters
	--------------------------------------------------------------------------

		parameters nodesP rollout:roNodes
			(
			refNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
			nodeHi type:#maxObject subAnim:true
			)
		

	--------------------------------------------------------------------------
	-- rollouts
	--------------------------------------------------------------------------
	
		rollout roNodes "Nodes 2" rolledUp:true
		(
		
		--------------------------------------------------------------------------
		-- interface
		--------------------------------------------------------------------------
	
			local btW=135, btW2=65
			listBox lbxNodesList "Nodes:"
			
			pickButton btnAddObject "Add Object" width:btW2 across:2
			button btnDeleteObject "Delete" width:btW2

			pickButton btnAdd2 "Add MaxObject" width:btW
			
			group "Tests:"
				(
				button btnPrintRefNodes "Print refNodes" width:btW
				button btnPrintMaxObject "Print MaxObject" width:btW
				)
	
		--------------------------------------------------------------------------
		-- functions
		--------------------------------------------------------------------------
	
			-- DEBUG -----------------------------------------------------------------------
				
				fn updateList=
					(
					nNames=for n in refNodes collect n.node.name
					lbxNodesList.items=nNames
					)
					
				fn printNodes =
					(
					for n in refNodes do
						(
						format "% : %\n" n n.node
						)
					)
					
				fn printMaxObject =
					(
					format "% : %\n" nodeHi nodeHi.node
					)
		
			-- OBJECTS -----------------------------------------------------------------------
				
				fn addObject =
					(
					append refNodes (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
					updateList()
					)
					
				fn addObject2 obj =
					(
					if obj != undefined then nodeHi = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false

					printMaxObject()
					)
					
				fn deleteObject =
					(
					num=lbxNodesList.selection
					if num>0 then
						(
						deleteItem refNodes num
						updateList()
						)
					)
				
			-- DO IT -----------------------------------------------------------------------
			
				fn hideNodes index =
					(
					for i = 1 to refNodes.count do
						(
						local state = i == index
						local theNode = refNodes[i].node
						
						theNode.isHidden = state
						format "% % \n" state theNode
						)
					)

		
		--------------------------------------------------------------------------
		-- handlers
		--------------------------------------------------------------------------
	
			on btnAddObject picked obj do addObject()
		
			on btnDeleteObject pressed do deleteObject ()
			
			on btnPrintRefNodes pressed do printNodes()
			on btnPrintMaxObject pressed do printMaxObject()
			
			on lbxNodesList doubleclicked index do hideNodes index
			
			on roNodes open do updateList()
			
			on btnAdd2 picked obj do addObject2 obj
		)
	

)

