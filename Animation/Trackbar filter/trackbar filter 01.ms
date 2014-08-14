--------------------------------------------------------------------------------
-- test filters

	-- core functions
		fn callbackFnCaller theAnim theParent theIndex theGParent theNode =
			(
			callbackFn theAnim theParent theIndex theGParent theNode
			)
		
		fn testCallbackAdditionFunction arg1 arg2 = (true)
	
	
	-- editable function
		fn callbackFn theAnim theParent theIndex theGParent theNode = 
			(
			-- call the functions here
			--testCallbackFilterFunction theAnimatable theParent theIndex theGParent theNode 
			filterTracks theAnim theParent theIndex theGParent theNode 
			)
			
	-- add
		theIndex = (maxOps.trackbar).registerFilter callbackFnCaller callbackAdditionFunction "Test Filter" 8 active:true stopTraversal:false
		
	-- remove
		(maxOps.trackBar).unRegisterFilter 8 


--------------------------------------------------------------------------------
-- testing

classof $.baseObject.Custom_Attributes



/*
theAnimatable: Controller:Bezier_Float
theParent: ReferenceTarget:ParamBlock2
theIndex: 1
theGParent: Custom_Attributes:Custom_Attributes
theNode: $Sphere:Sphere01 @ [-55.094841,13.165076,0.000000]
------------------------
customAtts: Controller:Bezier_Float
7.95859
*/


--------------------------------------------------------------------------------
-- new filters

	fn testCallbackFilterFunction theAnim theParent theIndex theGParent theNode  = (
		format "theAnimatable: %\n" theAnimatable 
		format "theParent: %\n" theParent 
		format "theIndex: %\n" theIndex 
		format "theGParent: %\n" theGParent 
		format "theNode: %\n" theNode 
		
		format "------------------------\n"
	
		try(format "theAnim name: %\n" theAnim.name);catch()
		try(format "theAnim value: %\n" theAnim.value);catch()
	
		try(format "theParent name: %\n" theParent.name);catch()
		try(format "theParent value: %\n" theParent.value);catch()
	
		try(format "theIndex name: %\n" theIndex.name);catch()
		try(format "theIndex value: %\n" theIndex.value);catch()
	
		try(format "theGParent name: %\n" theGParent.name);catch()
		try(format "theGParent value: %\n" theGParent.value);catch()
	
		try(format "theNode name: %\n" theNode.name);catch()
		try(format "theNode value: %\n" theNode.value);catch()
	
		
		format "\n\n"
		true
		) --always returns true, means show all keys
		

	paramList = #("Param1","Param2")


	fn filterTracks theAnim theParent theIndex theGParent theNode = 
		(
		if theParent != undefined then
			(
			return (findItem paramList theParent[theIndex]) != 0
			)
		return false
		)


	fn filterTracks theAnim theParent theIndex theGParent theNode = 
		(
		if theParent != undefined then
			(
			if ((findItem paramList theParent[theIndex]) != 0) then return true
			format "%\n" theParent[theIndex]
			try(
				format "%\n" theParent[theIndex]
				if (findItem paramList theParent[theIndex].name) > 0 then return true
				else return false
				)
			catch(
				format "\n"
				return false
				)
			)
		else return false
		)
		
	fn filterTracks theAnim theParent theIndex theGParent theNode = 
		(
		if(hasproperty theParent[theIndex] "name") then
			(
			if (findItem paramList theParent[theIndex].name) > 0 then return true
			else return false
			)
		else(
			return false
			)
		)
		
	fn filterTracks2 theAnim theParent theIndex theGParent theNode = 
		local param		= theNode.baseObject.Custom_Attributes[1]
		local paramName	= "Param1"
		format "%\n" param
		
		if theParent != undefined then 
			theParent[theIndex].name == "Visibility" 
		else 
			false 
			hasproperty
			
	/*
		try(param.name = paramName)
		catch(
			format"theAnim:%\n theParent:%\n theIndex:%\n theGParent:%\n theNode:%\n\n" theAnim theParent theIndex theGParent theNode 
			false
			)
			*/
		)
	
	-- add
		theIndex = (maxOps.trackBar).registerFilter filterTracks callbackAdditionFunction "Filter CA Tracks" 13 active:true stopTraversal:true

	-- remove
		(maxOps.trackBar).unRegisterFilter 8 



--------------------------------------------------------------------------------
-- filter commands testing

	$.baseObject.Custom_Attributes.name-- == "Param1"
	
	(maxOps.trackBar).filterCount()
	
	superclassof $.baseObject.Custom_Attributes == AttributeDef
	
classof $.baseobject.Custom_Attributes
	