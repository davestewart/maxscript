rollout ro1 "Animation Range" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	spinner spnTotalStart "Start Time" pos:[48,8] width:104 height:16 range:[-9999,9999,0] type:#integer
	spinner spnTotalEnd "End Time" pos:[51,32] width:101 height:16 range:[-9999,9999,100] type:#integer
	spinner spnTotalLength "Frame Count" pos:[37,56] width:115 height:16 range:[1,19998,100] type:#integer

	---------------------------------------------------------------------------------------------------
	-- Globals
	---------------------------------------------------------------------------------------------------
	global animRangeInit

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn animRangeInit =
		(
		spnTotalStart.value = animationRange.start
		spnTotalEnd.value = animationRange.end
		spnTotalLength.value = (animationRange.end - animationRange.start) + 1

		)

	fn updateAnimationRange start end =
		(
		if ro2.ckbFocus.state == false then animationRange = (interval start end)
		)


	fn updateStart = 
		(
		start = spnTotalStart.value
		end = spnTotalEnd.value
		spnTotalLength.value = (end - start) + 1

		if start >= end then
			(
			end = start + 1
			spnTotalEnd.value = end
			)
		updateAnimationRange start End
		)

	fn updateEnd = 
		(
		start = spnTotalStart.value
		end = spnTotalEnd.value
		spnTotalLength.value = (end - start) + 1

		if end <= start then
			(
			start = end - 1
			spnTotalStart.value = start
			)

		updateAnimationRange start End
		)

	fn updateLength = 
		(
		start = spnTotalStart.value
		end = (start + spnTotalLength.value) - 1
		spnTotalEnd.value = end
		updateAnimationRange start End
		)






	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on ro1 open do
		(
		callbacks.addScript #filePostOpen "animRangeInit()" id:#updateAnimRange
		animRangeInit()
		)

	on spnTotalStart changed val do updateStart()
	on spnTotalEnd changed val do updateEnd()
	on spnTotalLength changed val do updateLength()

	on ro1 close do
		(
		animationRange = (interval spnTotalStart.value spnTotalEnd.value)
		callbacks.removeScripts id:#updateAnimRange
		)
	


)


rollout ro2 "Focus" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------
	local spnFocusActive = false
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	GroupBox grpFocus "Focus on:" pos:[4,4] width:152 height:108

	spinner spnFocus "Frame" pos:[24,24] width:64 height:16 range:[-9999,9999,50] type:#integer
	label lbl1 "..." pos:[90,24] width:12 height:16

	spinner spnDuration "...for" pos:[30,48] width:58 height:16 range:[10,999,10] type:#integer
	label lbl2 "frames..." pos:[90,48] width:40 height:16

	radiobuttons rdoScope "" pos:[72,72] width:80 height:32 labels:#("...after", "...around") default:1 columns:1


	GroupBox grpSetFocus "Focus:" pos:[4,120] width:152 height:40
	checkbutton ckbFocus "Focus" pos:[8,136] width:144 height:16 highlightColor:(color 255 255 0)


	---------------------------------------------------------------------------------------------------
	-- Functions (callbacks)
	---------------------------------------------------------------------------------------------------
	fn time_cb =
		(
		format "% " currentTime
		spnFocus.value = slidertime
		if spnFocusActive == false then ckbFocus.state = false
		--ro1.animRangeInit()
		)

	fn timeUpdateCB = time_cb() 


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------


	fn update =
		(
	-- get spinner values as vars
		foc = spnFocus.value
		dur = spnDuration.value



	-- set spnFocus range (can't be higher or lower than the total animation time)
		if rdoScope.state == 1 then
			(
			focusMin = ro1.spnTotalStart.value
			focusMax = ro1.spnTotalEnd.value - dur

			focusVal = spnFocus.value
		-- check the rdo change state hasn't put the spinner value out of range
			if focusVal>focusMax then focusVal = focusMax
			else if focusVal<focusMin then focusVal = focusMin
			)
		else
			(
			focusMin = ro1.spnTotalStart.value + (dur/2)
			focusMax = ro1.spnTotalEnd.value - (dur/2)

			focusVal = spnFocus.value
		-- check the rdo change state hasn't put the spinner value out of range
			if focusVal>=focusMax then focusVal = focusMax
			else if focusVal<=focusMin then focusVal = focusMin
			)
		spnFocus.range = [focusMin,focusMax,focusVal]



	-- set spnDuration range (can't be higher or lower than the total animation time)
		if rdoScope.state == 1 then
			(
			durMax = ro1.spnTotalEnd.value - spnFocus.value
			durVal = spnDuration.value
		-- check the rdo change state hasn't put the spinner value out of range
			if durVal>=durMax then durVal = durMax
			)
		else
			(
			durMax = ro1.spnTotalEnd.value - (spnFocus.value/2)

			durVal = spnDuration.value
		-- check the rdo change state hasn't put the spinner value out of range
			if durVal>=durMax then durVal = durMax
			)
		spnDuration.range = [1,durMax,durVal]



	-- get spinner values as vars
		foc = spnFocus.value
		dur = spnDuration.value


	-- set scope
		if rdoScope.state == 1 then
			(
			start = foc
			end = foc + dur
			)
		else
			(
			start = foc - (dur/2)
			end = start + dur
			)

	-- adjust that an odd duration value 
		if end > ro1.spnTotalEnd.value then
			(
			end-=1
			start-=1
			)
		else if start < ro1.spnTotalStart.value then
			(
			start+=1
			end+=1
			)

		grpSetFocus.text = "Result: " + start as String + " to " + end as String

		if ckbFocus.state == true then animationRange = (interval start end)

		)

	fn checkFocus state = 
	(
	case state of
		(
		true: update()
		false: animationRange = (interval ro1.spnTotalStart.value ro1.spnTotalEnd.value)
		)
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
	on ro2 open do
		(
		registerTimeCallback timeUpdateCB
		update()
		)
	on ro2 close do unregisterTimeCallback timeUpdateCB

	on spnFocus buttonDown do
		(
		spnFocusActive = true
		update()
		)
	on spnFocus buttonUp do
		(
		spnFocusActive = false
		update()
		)
	on spnFocus changed val do
		(
		slidertime = spnFocus.value as Time
		update()
		)

	on spnDuration changed val do update()
	on rdoScope changed state do update()
	on ckbFocus changed state do checkFocus state

)

if animRangeFloater2 != undefined then closerolloutfloater animRangeFloater2
	animRangeFloater2 = newRolloutFloater "Anim range" 188 244 
addRollout ro1 animRangeFloater2 --rolledup:true
addRollout ro2 animRangeFloater2

animRangeFloater2.pos = [44,150]
animRangeFloater2.size = [188,325]
