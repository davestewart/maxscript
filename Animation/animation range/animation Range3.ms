rollout ro1 "Animation Range" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	spinner spnTotalStart "Start Time" pos:[48,8] width:104 height:16 range:[-9999,9999,0] type:#integer
	spinner spnTotalEnd "End Time" pos:[51,32] width:101 height:16 range:[-9999,9999,100] type:#integer
	spinner spnTotalLength "Length" pos:[62,56] width:90 height:16 range:[1,19998,100] type:#integer
	button btnInit "Re-initialize" pos:[92,80] width:60 height:16 tooltip:"Use this if you have manually changed the animation range"

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn init =
		(
		spnTotalStart.value = animationRange.start
		spnTotalEnd.value = animationRange.end
		spnTotalLength.value = animationRange.end - animationRange.start
		)

	fn updateStart = 
		(
		start = spnTotalStart.value
		end = spnTotalEnd.value
		spnTotalLength.value = end - start

		if start >= end then
			(
			end = start + 1
			spnTotalEnd.value = end
			)

		animationRange = (interval start end)
		)

	fn updateEnd = 
		(
		start = spnTotalStart.value
		end = spnTotalEnd.value
		spnTotalLength.value = end - start

		if end <= start then
			(
			start = end - 1
			spnTotalStart.value = start
			)

		animationRange = (interval start end)
		)

	fn updateLength = 
		(
		start = spnTotalStart.value
		end = spnTotalEnd.value
		length = spnTotalLength.value

		if end <= start then
			(
			start = end - 1
			spnTotalStart.value = start
			)

		animationRange = (interval start end)
		)
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on ro1 open do init()
	on btnInit pressed do init()

	on spnTotalStart changed val do updateStart()
	on spnTotalEnd changed val do updateEnd()
	on spnTotalLength changed val do updateLength()

)


rollout ro2 "Focus" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------
	global oldAnimStart, oldAnimEnd, segAnimStart, segAnimEnd

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	GroupBox grpFocus "Focus on:" pos:[4,4] width:152 height:108

	spinner spnFocus "Frame" pos:[24,24] width:64 height:16 range:[-9999,9999,50] type:#integer
	label lbl1 "..." pos:[90,24] width:12 height:16

	spinner spnDuration "...for" pos:[30,48] width:58 height:16 range:[10,999,10] type:#integer
	label lbl2 "frames..." pos:[90,48] width:40 height:16

	radiobuttons rdoScope "" pos:[72,72] width:80 height:32 labels:#("...after", "...either side") default:1 columns:1


	GroupBox grpSetFocus "Set Focus to:" pos:[4,120] width:152 height:40
	button btnSetFocus "Now" pos:[8,136] width:72 height:16
	checkbutton ckbAuto "Automatically" pos:[80,136] width:72 height:16 highlightColor:(color 255 255 0)


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn time_cb =
		(
		print currentTime
		ckbAuto.state = false
		)
	fn timeUpdateCB = time_cb() 


	fn setRange = 
		(
		foc = spnFocus.value
		dur = spnDuration.value
		
		if rdoScope.state == 1 then
			(
			start = foc
			end = foc + dur
			)
		else
			(
			start = foc-(dur/2)
			end = foc+(dur/2)
			)
		
			animationRange = (interval start end)
		)


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
on ro2 open do
	(
	registerTimeCallback timeUpdateCB
	)
on spnFocus buttonDown do spnFocus.range = [ro1.spnTotalStart.value,ro1.spnTotalEnd.value,sliderTime]
on spnFocus changed val do setRange()



on spnDuration changed val do setRange()
on rdoScope changed state do setRange()
)

if animRangeFloater2 != undefined then closerolloutfloater animRangeFloater2
	animRangeFloater2 = newRolloutFloater "Anim range" 188 244 
addRollout ro1 animRangeFloater2 rolledup:true
addRollout ro2 animRangeFloater2


