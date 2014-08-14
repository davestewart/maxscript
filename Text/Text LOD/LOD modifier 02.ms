-----------------------------------------------------------------------------------------------
-- CA def
-----------------------------------------------------------------------------------------------

	caLod = attributes "Level Of Detail"
	(
		
		local ckbLod
		local nodeHi, nodeLo, arrNodes
		local params
		
		function setLod level =
		(
			if level == #high OR level == false then params.setLod false
			else if level == #low OR level == true then params.setLod true
		)
		
		parameters main rollout:params
		(
			lowres type:#boolean ui:ckbLod default:false animatable:false
			nodeHiName type:#string
			nodeLoName type:#string
			nodeGroupHead type:#node
		)
		
		rollout params "Level of Detail" width:168 height:136
		(
		
			checkbutton ckbLod "High Detail" pos:[8,8] width:152 height:16 -- pos:[8,72]
			GroupBox grpUtilities "Utilities" pos:[8,32] width:152 height:52
			button btnUnhide "Unhide" pos:[16,56] width:68 height:16 across:2
			button btnUngroup "Break apart" pos:[84,56] width:68 height:16 -- pos:[8,72]
			
			function getLodNodes =
			(
				nodeHi	= getNodeByName nodeHiName
				nodeLo	= getNodeByName nodeLoName
				arrNodes = #(nodeHi,nodeLo)
			)
			
			function unhideLodNodes =
			(
				getLodNodes ()
				if isvalidnode nodeHi then nodeHi.ishidden = false
				if isvalidnode nodeLo then nodeLo.ishidden = false
			)
				
			function setLod state =
			(
				getLodNodes ()
				if isvalidnode nodeHi then nodeHi.ishidden = state
				if isvalidnode nodeLo then nodeLo.ishidden = NOT state
				
				ckbLod.text = if state then "Low Detail" else "High Detail"
			)
		
			on ckbLod changed state do
			(
				setLod state
			)
				
			on btnUnhide pressed do unhideLodNodes ()
			
			on btnUngroup pressed do
			(
				unhideLodNodes()
				ungroup nodeGroupHead
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
			
			if arr.count != 2 then
			(
				messagebox "The LOD utility requires 2 objects to be selected."
				return false
			)
			if (getnumverts (snapshotasmesh arr[1])) > (getnumverts (snapshotasmesh arr[2])) then
			(
				nodeHi = arr[1]
				nodeLo = arr[2]
			)
			else
			(
				nodeHi = arr[2]
				nodeLo = arr[1]
			)
				
			
			gp		= group arr prefix:"LOD Group "
			addmodifier arr (EmptyModifier name:"Level of Detail")
			mod		= arr[1].modifiers
			custAttributes.add mod caLod
		
			setProperty mod #nodeLoName nodeLo.name
			setProperty mod #nodeHiName nodeHi.name
			setProperty mod #nodeGroupHead gp
			
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


		/*
		for obj in gp do (if (superclassof obj == GeometryClass) then setProperty obj.modifiers[1] #nodeLo $[3].name)
		for obj in gp do (if (superclassof obj == GeometryClass) then setProperty obj.modifiers[1] #nodeHi $[1].name)
		
		getproperty $[1].modifiers[1] #nodeHi
		*/
