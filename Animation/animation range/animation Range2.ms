	rollout ro1 "Set Range" width:160 height:311
	(
		---------------------------------------------------------------------------------------------------
		-- declare globals
		---------------------------------------------------------------------------------------------------
		global oldAnimStart, oldAnimEnd, segAnimStart, segAnimEnd

		---------------------------------------------------------------------------------------------------
		-- Interface
		---------------------------------------------------------------------------------------------------
		spinner spn1 "Start" pos:[16,8] width:56 height:16 range:[0,10000,0] type:#integer
		spinner spn2 "End" pos:[96,8] width:56 height:16 range:[1,10000,100] type:#integer



		---------------------------------------------------------------------------------------------------
		-- Functions
		---------------------------------------------------------------------------------------------------
		fn setRange = 
			(
				animationRange = (interval spn1.value spn2.value)
			)


		---------------------------------------------------------------------------------------------------
		-- Handlers
		---------------------------------------------------------------------------------------------------
		on spn1 changed val do setRange()
		on spn2 changed val do setRange()
	)

	if animRangeFloater2 != undefined then closerolloutfloater animRangeFloater2
		animRangeFloater2 = newRolloutFloater "Anim range" 188 115 
	addRollout ro1 animRangeFloater2

