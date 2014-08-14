macroScript FilterKeys category:"MAX Script Tools"
(
	global filterRollout

	rollout filterRollout "Filter Keys" width:88 height:24
	(
		
		-----------------------------------------------------------------------------------------------------
		-- interface
		
			checkbutton ckb1 "Filter Keys" pos:[4,8] width:108 height:24 highlightColor:(color 255 0 0) toolTip:"Clcik to show only selected track's keys in trackbar..."
		
		-----------------------------------------------------------------------------------------------------
		-- variables

			global filterTracks
			global filterParams
			
			local callbackIndex

			local filterObject
			
		-----------------------------------------------------------------------------------------------------
		-- callback functions


			-- editable callback function
				fn callbackFn theAnim theParent theIndex theGParent theNode = 
				(
					filterTracks theAnim theParent theIndex theGParent theNode 
				)
				
			-- hardcoded callback
				fn callbackFnCaller theAnim theParent theIndex theGParent theNode =
				(
					callbackFn theAnim theParent theIndex theGParent theNode
				)
					
			-- not sure what this is supposed to be, but it was in the docs
				fn callbackAdditionFunction arg1 arg2 = (true)
			
			-- custom filter
				function filterTracks theAnim theParent theIndex theGParent theNode = 
				(
					if theParent != undefined then
					(
						return (findItem filterParams theParent[theIndex].controller) != 0
					)
					else false
				)

			-- add or remove callbacks
				fn addCallback = 
				(
					filterRollout.callbackIndex = (maxOps.trackbar).registerFilter callbackFnCaller callbackAdditionFunction "Filter User-selected Tracks" 8 active:true stopTraversal:false
				)
	
				fn removeCallback =
				(
					if callbackIndex != undefined then
					(
						(maxOps.trackBar).unRegisterFilter filterRollout.callbackIndex
						filterRollout.callbackIndex = undefined
					)
				)



		-----------------------------------------------------------------------------------------------------
		-- UI functions

			-- get parameters
			
				function getParameters =
				(
					filterObject = select (getCurrentSelection())[1]
					filterParams = trackView.pickTrackDlg #multiple options:12
					if(filterParams != undefined) then
					(
						filterParams = for i in filterParams collect i.anim
					)
					select $
				)
				
		--------------------------------------------------------------------------
		-- register callbacks
		
			-- add
		-----------------------------------------------------------------------------------------------------
		-- handlers
		
			on ckb1 changed state do
			(
				if state == true then
				(
					getParameters()
					if(filterParams != undefined) then addCallback()
					else ckb1.state = false
				)
				else
				(
					removeCallback()
				)
			)
		
			on filterRollout open do 
			(
			)
				
			on filterRollout close do 
			(
				removeCallback()
			)			
	)
	try(destroyDialog filterRollout)catch()
	createDialog filterRollout 88 20 style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
	cui.RegisterDialogBar filterRollout minSize:[88,24] maxSize:[88,24] style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
)

macros.run "Max Script Tools" "FilterKeys"