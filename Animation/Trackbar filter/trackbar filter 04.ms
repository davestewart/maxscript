
-------------------------------------------------------------------------------------------------------------------------------
--
-- Filter Trackbar Keys
-- Provides per-track control over which keys display in trackbar
--
-------------------------------------------------------------------------------------------------------------------------------
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
-- date:		15 July 2006
-- version:		1.0
-- max version:	7+
--
-------------------------------------------------------------------------------------------------------------------------------

macroScript FilterKeys
	category:"Animation Tools"
	buttonText:"Filter Trackbar Keys"
	tooltip:"Filter Trackbar Keys"

(

	global filterRollout

	-----------------------------------------------------------------------------------------------------
	-- rollout
		
	rollout filterRollout "Filter Keys" width:88 height:24
(
		
		-----------------------------------------------------------------------------------------------------
		-- interface
		
			checkbutton ckb1 "Filter Keys" pos:[4,6] width:88 height:24 highlightColor:(color 255 0 0) toolTip:"Show only selected tracks' keys in trackbar..."
		
		
		-----------------------------------------------------------------------------------------------------
		-- variables

			local callbackIndex
			local filterTracks
			
			global filterParams
			
		-----------------------------------------------------------------------------------------------------
		-- callback functions

			-- custom filter
				function filterTracks theAnim theParent theIndex theGParent theNode = 
			(
					if theParent != undefined then
				(
						return (findItem filterParams theParent[theIndex].controller) != 0
				)
					else false
			)

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
			
			-- add or remove callbacks
				fn addCallback = 
			(
					filterRollout.callbackIndex = (maxOps.trackbar).registerFilter callbackFnCaller undefined "Filter User-selected Tracks" 8 active:true stopTraversal:false
			)
	
				fn removeCallback =
			(
					if callbackIndex != undefined then
				(
						try(
						(maxOps.trackBar).unRegisterFilter filterRollout.callbackIndex
					)
						catch()
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
				


		-----------------------------------------------------------------------------------------------------
		-- handlers
		
			on ckb1 changed state do
		(
				if state == true then
			(
					-- selection
						if (getCurrentSelection()).count > 0 then
							getParameters()
						else
					(
							messagebox "Select an object first, then choose the tracks for which you want keys displayed in the trackbar."
							ckb1.state = false
							return false
					)
						
					-- tracks
						if(filterParams != undefined) then
							addCallback()
						else
							ckb1.state = false
			)
				else
			(
					removeCallback()
			)
		)
				
			on filterRollout close do 
		(
				removeCallback()
		)			
)
		
	-----------------------------------------------------------------------------------------------------
	-- create dialog
		
		local uiSize1			= [100,30]
		local uiSize2			= uiSize1+[12-2,7]
	
		destroyDialog filterRollout
	
		try(destroyDialog filterRollout)catch()
	
		createDialog filterRollout uiSize1[1] uiSize1[2] style:#(#style_titlebar, #style_border, #style_sysmenu)
		cui.RegisterDialogBar filterRollout style:#(#cui_dock_all, #cui_floatable, #cui_handles ) minSize:uiSize2 maxSize:uiSize2 

)
macros.run "Animation Tools" "FilterKeys"
