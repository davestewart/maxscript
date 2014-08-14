rollout ro1 "Set Range" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------
	global oldAnimStart, oldAnimEnd, segAnimStart, segAnimEnd

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	checkbutton ckb1 "Do it" pos:[88,8] width:64 height:16 highlightColor:(color 255 255 0)
	spinner spn1 "Duration" pos:[24,8] width:56 height:16 range:[0,100,10] type:#integer



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn setRange state = 
	(
		case state of
		(
			true:
			(
				oldAnimStart = animationRange.start
				oldAnimEnd = animationRange.end

				range = spn1.value
				segAnimStart = currentTime - (range/2)
				segAnimEnd = currentTime + (range/2)

				animationRange = (interval segAnimStart segAnimEnd )
				
				ckb1.text = oldAnimStart as String + " - " + oldAnimEnd as String
			)

			false:
			(
				animationRange = (interval oldAnimStart oldAnimEnd)
				ckb1.text = segAnimStart as String + " - " + segAnimEnd as String
			)
		)
	)

	fn spnUpdate =
	(
		range = spn1.value
		start = currentTime - (range/2)
		end = currentTime + (range/2)
		ckb1.text = start as String + " - " + end as String
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
	on ckb1 changed state do setRange state
	on spn1 changed val do spnUpdate()
	on ro1 open do spnUpdate()
)

if animRangeFloater != undefined then closerolloutfloater animRangeFloater
	animRangeFloater = newRolloutFloater "Anim range" 188 89 
addRollout ro1 animRangeFloater
