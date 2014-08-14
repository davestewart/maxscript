
(
--------------------------------------------------------------------------
-- functions

	local filterObject
	local filterParams
	local callbackIndex

--------------------------------------------------------------------------
-- core filter code

	-- variables
		global filterTracks

	-- callbacks
		fn callbackFnCaller theAnim theParent theIndex theGParent theNode =
			(
			callbackFn theAnim theParent theIndex theGParent theNode
			)
		
		fn testCallbackAdditionFunction arg1 arg2 = (true)
	
	
	-- editable function
		fn callbackFn theAnim theParent theIndex theGParent theNode = 
			(
			filterTracks theAnim theParent theIndex theGParent theNode 
			)
			
		
--------------------------------------------------------------------------
-- custom filter

		fn filterTracks theAnim theParent theIndex theGParent theNode = 
			(
			if theParent != undefined then
				(
				return (findItem filterParams theParent[theIndex].controller) != 0
				)
			else false
			)


--------------------------------------------------------------------------
-- parameters

	-- get parameters
		filterObject = select $[1]
		filterParams = trackView.pickTrackDlg #multiple options:12
		filterParams = for i in filterParams collect i.anim
		select $
		
--------------------------------------------------------------------------
-- register callbacks

	-- remove
		(maxOps.trackBar).unRegisterFilter callbackIndex
	-- add
		callbackIndex = (maxOps.trackbar).registerFilter callbackFnCaller callbackAdditionFunction "Filter User-selected Tracks" 8 active:true stopTraversal:false
		
		
)