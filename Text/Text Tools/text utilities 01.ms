filein "make sentence 01.ms"
filein "replace object for bitmap 01.ms"
filein "LOD modifier 04.ms"



rollout roAll "Uber-Rollout" width:150 height:30
(


	-----------------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------------

		button btnCreate "Create Text" width:140 height:16
		button btnSetLodLo "Low Detail" width:70 height:16 across:2
		button btnSetLodHi "High Detail" width:70 height:16

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
	
	-----------------------------------------------------------------------------------------------
	-- handlers
	-----------------------------------------------------------------------------------------------

		on btnCreate pressed do
			(
			roMakeSentence.btnSet.pressed()
			roReplaceWithBitmap.btnReplace.pressed()
			roLod.btnCreate.pressed()
			)
	
		on btnSetLodLo pressed do
			(
			setAllLod #low
			setAllLod #high
			)
	
)

try(closeRolloutFloater rf);catch()
rf = newRolloutFloater "Text Utilities" 162 500
addRollout roMakeSentence rf 
addRollout roReplaceWithBitmap rf 
addRollout roLod rf 
addRollout roAll rf 
/*
unhide $bg*
unhide objects
*/