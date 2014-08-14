-----------------------------------------------------------------------------------------------
-- CA def
-----------------------------------------------------------------------------------------------

	caLod = attributes "Level Of Detail" redefine:caLod 
	(
		
		local ckbLod
		local arrNodes
		local params
		
		function setLod level =
		(
			if level == #high OR level == false then roParams.setLod false
			else if level == #low OR level == true then roParams.setLod true
		)
		
		function getLodNodes =
		(
			return #(nodeHi,nodeLo)
		)
		
		parameters main rollout:roParams
		(
			lowres type:#boolean ui:ckbLod default:false animatable:false
			nodeHi type:#maxObject
			nodeLo type:#maxObject
			nodeGp type:#maxObject
		)
		
		rollout roParams "Level of Detail" width:168 height:136
	(
		
			checkbutton ckbLod "High Detail" pos:[8,8] width:152 height:16 -- pos:[8,72]
			
			function setLod state =
			(
				if isvalidnode nodeHi then nodeHi.ishidden = state
				if isvalidnode nodeLo then nodeLo.ishidden = NOT state
				
				ckbLod.text = if state then "Low Detail" else "High Detail"
			)
		
			on ckbLod changed state do
			(
				setLod state
			)
				
	)


		rollout roUtilities "Level of Detail" width:168 height:136
	(
		
			GroupBox grpUtilities "Utilities" pos:[8,32] width:152 height:52
			button btnUnhide "Unhide" pos:[16,56] width:68 height:16 across:2
			button btnUngroup "Break apart" pos:[84,56] width:68 height:16 -- pos:[8,72]
			
			function unhideLodNodes =
			(
				if isvalidnode nodeHi then nodeHi.ishidden = false
				if isvalidnode nodeLo then nodeLo.ishidden = false
			)
				
			on btnUnhide pressed do unhideLodNodes ()
			
			on btnUngroup pressed do
			(
				unhideLodNodes()
				ungroup nodeGp
				local mIndex
				if isvalidnode nodeHi then
				(
					for m in nodeHi.modifiers do if m.name == "Level of Detail" then deletemodifier nodeHi m
				)
				if isvalidnode nodeLo then
				(
					for m in nodeLo.modifiers do if m.name == "Level of Detail" then deletemodifier nodeLo m
				)
			)
			
		)
	)


rollout roLod "Level Of Detail" width:150 height:30
(

	-----------------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------------

		button btnCreate "Create LOD Group" width:140 height:16
	
		
	-----------------------------------------------------------------------------------------------
	-- functions
	-----------------------------------------------------------------------------------------------

		function addLod =
		(
			local nodeHi, nodeLo, gp, mod, ca
			local arr = getCurrentSelection()
			local arrNodes = #()
			
			if arr.count != 2 then
			(
				messagebox "The LOD utility requires 2 objects to be selected."
				return false
			)
			if (getnumverts (snapshotasmesh arr[1])) > (getnumverts (snapshotasmesh arr[2])) then
			(
				arrNodes = #(arr[1],arr[2])
			)
			else
			(
				arrNodes = #(arr[2],arr[1])
			)
				
			
			gp		= group arr prefix:"LOD Group "
			addmodifier arr (EmptyModifier name:"Level of Detail")
			
			mod		= arr[1].modifiers
			custAttributes.add mod caLod
		
			setProperty mod #nodeHi arrNodes[1]
			setProperty mod #nodeLo arrNodes[2]
			setProperty mod #nodeGp gp
			
			select gp
			
			nodeLo.isHidden = true
		)
			
			
	-----------------------------------------------------------------------------------------------
	-- handlers
	-----------------------------------------------------------------------------------------------
	

		on btnCreate pressed do
		(
			addLod ()
		)
		
		
)

createDialog roLod