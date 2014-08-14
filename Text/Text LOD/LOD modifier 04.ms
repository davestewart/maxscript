-----------------------------------------------------------------------------------------------
-- CA def
-----------------------------------------------------------------------------------------------

	if caLod == undefined then
		(
		caLod = (for ca in (custattributes.getSceneDefs()) where ca.name == "Level of Detail" collect ca)
		if caLod.count > 0 then caLod = caLod[1]
		else caLod = (
			attributes "Level Of Detail"
				(
				)
			)
		)

	caLod = attributes "Level Of Detail" redefine:caLod 
		(
		
		--------------------------------------------------------------------------
		-- pre-declarations
		--------------------------------------------------------------------------
	
			local roLod, params
	
			function setNodeGp obj	= roLod.setNodeGp obj
			function setNodeHi obj	= roLod.setNodeHi obj
			function setNodeLo obj	= roLod.setNodeLo obj

			function setObjects objHi objLo objGp =
				(
				setNodeGp objGp
				
				setNodeHi objHi
				setNodeLo objLo
				)

			function updateLod		= roLod.updateLod()

			function setLod level =
				(
				if level == #high OR level == false then roLod.setLod false
				else if level == #low OR level == true then roLod.setLod true
				)

		--------------------------------------------------------------------------
		-- parameters
		--------------------------------------------------------------------------
	
			parameters main rollout:roLod
				(
				lowres type:#boolean ui:ckbLod default:false animatable:false
				nodeHi type:#maxObject subAnim:true
				nodeLo type:#maxObject subAnim:true
				nodeGp type:#maxObject subAnim:true
				)
			


		--------------------------------------------------------------------------
		-- Rollout: Level of Detail
		--------------------------------------------------------------------------


			rollout roLod "Level Of Detail" width:#cmdPanel height:112
				(
				
				--------------------------------------------------------------------------
				-- interface
	
					checkbutton ckbLod "High detail" pos:[8,8] width:152 height:32 align:#center
					group "Nodes"
						(
						pickbutton pckHi "High: " width:144 height:16
						pickbutton pckLo "Low: " width:144 height:16
						)
	
				--------------------------------------------------------------------------
				-- functions
			
					-- ui
					
						function checkNodeHi =
							(
							return nodeHi != undefined AND isvalidnode nodeHi.node
							)
					
						function checkNodeLo =
							(
							return nodeLo != undefined AND isvalidnode nodeLo.node
							)
					
					
						function updateUI =
							(
							/*
							*/
							-- pick button text
								pckHi.text = "High: "
								pckLo.text = "Low: "
								
								if checkNodeHi() do pckHi.text += nodeHi.node.name
								if checkNodeLo() do pckLo.text += nodeLo.node.name

							-- checkbutton enabled
								ckbLod.enabled	= (checkNodeLo() AND checkNodeHi())
								ckbLod.text		= if lowres then "Low Detail" else "High Detail"
								
							-- checkbutton state
								--if NOT checkNodeLo() then ckbLod.state = false
								--else if NOT checkNodeHi() do ckbLod.state = true
							)
					
					-- grouping	
					
						function setGroup obj grp =
							(
							if isvalidnode grp then
								(
								setgroupmember obj true
								append grp.children obj
								)
							)
							
					-- nodes

						function setNodeHi obj prompt:false =
							(
							if isValidNode obj then
								(
								nodeHi = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
								--setGroup obj nodeGp.node
								)
							updateUI()
							)
						
						function setNodeLo obj prompt:false=
							(
							if isValidNode obj then
								(
								nodeLo = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
								--setGroup obj nodeGp.node
								)
							updateUI()
							)
	
						function setNodeGp obj =
							(
							if isValidNode obj then
								(
								nodeGp = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
								)
							)
	
					-- Lod

						function setLod state =
							(
							--print ("Setting Lod: " + state as string)
							if isvalidnode nodeHi.node then nodeHi.node.ishidden = state
							if isvalidnode nodeLo.node then nodeLo.node.ishidden = NOT state
							lowres = state
							updateUI ()
							)
					
						function updateLod =
							(
							setLod ckbLod.state
							)
			
				--------------------------------------------------------------------------
				-- handlers
			
					on ckbLod changed state do setLod state
					on pckHi picked obj do setNodeHi obj 
					on pckLo picked obj do setNodeLo obj
					on roLod open do
						(
						updateUI()
						)
					on btnPrint pressed do printObjects()

				)
			
			
				
		--------------------------------------------------------------------------
		-- Rollout: Utilities
		--------------------------------------------------------------------------


			rollout roUtilities "Utility" width:#cmdPanel height:56
				(
				--------------------------------------------------------------------------
				-- interface
	
					button btnAlign "Align Nodes" width:152 height:16
					button btnUnhide "Unhide Nodes" width:152 height:16
					button btnBreakApart "Break apart" width:152 height:16
					button btnPrint "Print Objects" width:152 height:16
					
		
				--------------------------------------------------------------------------
				-- functions

					function getLodNodes =
						(
						return #(nodeHi,nodeLo)
						)
						
					function printLodNodes =
						(
						try
							(
							format "Lo: % % %\n" nodeLo nodeLo.node.name nodeLo.node
							format "Hi: % % %\n" nodeHi nodeHi.node.name nodeHi.node
							format "Gp: % % %\n" nodeHi nodeGp.node.name nodeGp.node
							)
						catch(
							print "Couldn't print  nodes..."
							)
						)
				
					function alignLodNodes =
						(
						try(
							nodeHi.node.pos = nodeLo.node.pos
							)
						catch(
							print "Couldn't align nodes. "
							)
						)
						
					function unhideLodNodes =
						(
						if isvalidnode nodeHi.node then nodeHi.node.ishidden = false
						if isvalidnode nodeLo.node then nodeLo.node.ishidden = false
						)
						
					function breakApart =
						(
						unhideLodNodes()
						ungroup nodeGp.node
						local mIndex
						if isvalidnode nodeHi.node then
							(
							for m in nodeHi.node.modifiers do if m.name == "Level of Detail" then deletemodifier nodeHi.node m
							)
						if isvalidnode nodeLo.node then
							(
							for m in nodeLo.node.modifiers do if m.name == "Level of Detail" then deletemodifier nodeLo.node m
							)
						)
		
				--------------------------------------------------------------------------
				-- handlers
				
					on btnAlign pressed do alignLodNodes ()

					on btnUnhide pressed do unhideLodNodes ()
					on btnBreakApart pressed do breakApart()

					on btnPrint pressed do printLodNodes()


				)
		

		)





-----------------------------------------------------------------------------------------------
-- Floater / Dialog rollout panel
-----------------------------------------------------------------------------------------------

try(destroydialog roLod);catch()

rollout roLod "Level Of Detail" width:150 height:72
(

	-----------------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------------

	button btnCreate "Create LOD Group" pos:[5,7] width:140 height:16
	radioButtons rdo1 "Set all object's Level of Detail" pos:[8,32] width:102 height:30 labels:#("Low", "High") columns:2
	
		
	-----------------------------------------------------------------------------------------------
	-- functions
	-----------------------------------------------------------------------------------------------


		fn setAllLod state =
			(
			for obj in objects do
				(
				for m in obj.modifiers do
					(
					if m.name == "Level of Detail" then
						(
						--print (obj.name +" : "+m.arrNodes as string)
						m.setLod state
						)
					)
				)
			)
	

		function addLod =
			(
			-- variables
				local nodeHi, nodeLo, gp, m, ca
				local arrNodes = getCurrentSelection()

			-- get and sort the nodes			
				if arrNodes.count != 2 then
					(
					messagebox "The LOD utility requires 2 objects to be selected."
					return false
					)
				if (getnumverts (snapshotasmesh arrNodes[1])) > (getnumverts (snapshotasmesh arrNodes[2])) then
					(
					arrNodes = #(arrNodes [1],arrNodes [2])
					)
				else
					(
					arrNodes = #(arrNodes [2],arrNodes [1])
					)
				
			-- group and add CA
				local gp	= group arrNodes name:(arrNodes[1].name) -- prefix:"LOD " 
				addmodifier arrNodes (EmptyModifier name:"Level of Detail")
				
				local m = arrNodes[1].modifiers[1]
				custAttributes.add m caLod
			
				--print arrNodes
			
				m.setObjects arrNodes[1] arrNodes[2] gp
				m.setLod #low
		
				select gp

			)
			
			
	-----------------------------------------------------------------------------------------------
	-- handlers
	-----------------------------------------------------------------------------------------------
	

		on btnCreate pressed do
			(
			addLod ()
			)
			
		on rdo1 changed index do
			(
			if index == 1 then setAllLod #low
			else setAllLod #high
			)
		
		
	)
	
/*
createDialog roLod
clearlistener()
select objects




$'Bg text 01'.modifiers[1].setNodeHi $[1]
$'Bg text 01'.modifiers[1].setNodeLo $[3]

*/