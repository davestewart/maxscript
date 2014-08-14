function walk ctrl =
(
	local sub, n
	print ctrl
	--if ctrl == undefined do return
	for i = 1 to ctrl.numSubs do
(
		print i
		sub = getsubanim ctrl i
		if sub.controller != undefined do
	(
			n = numKeys sub.controller
			if n > 0 do
		(
				for k = 1 to n do
			(
					if isKeySelected sub.controller k do
				(
						format "% % % \n" sub k n
						append keyList (getKeyTime sub.controller k)
				)
			)
		)
			walk sub
	)
)
)

function walkSubAnim ctrl =
(
	local sub, n, k
	--print ctrl
	--if ctrl == undefined do return

	-- controller and keys
		if ctrl.controller != undefined do
	(
			n = numKeys ctrl.controller
			if n > 0 do
		(
				for k = 1 to n do
			(
					if isKeySelected ctrl.controller k do
				(
						--format "% % % % \n" ctrl.controller k n ctrl.controller.value
						appendIfUnique keyList (getKeyTime ctrl.controller k)
				)
			)
		)
	)
	
	-- sub anim and children
		for i = 1 to ctrl.numSubs do
	(
			--print i
			sub = getsubanim ctrl i
			if sub.controller != undefined do
		(
				walkSubAnim sub
		)
	)
	/*
	*/
)

keyList = #()
ctrl = $.transform.controller
walkSubAnim ctrl

if $.modifiers.count > 0 do
(
	for i = 1 to $.modifiers[1].numSubs do
(
		walkSubAnim $.modifiers[1][i]
)
)
keyList
range = interval ((amin keyList)) ((amax keyList))

range.end as integer / ticksperframe