for obj in $ do
(
	-- get controller
		local ctrl = obj.visibility.controller

	-- base variable
		local keyTime = 0

	-- loop through time and get existing values from script controller
		for t = animationRange.start to animationRange.end do
		(
			at time t if ctrl.value == 1 then
			(
				if keytime == 0 then keyTime = t
				exit
			)
		)

	-- assign new controller, keys and values
		ctrl=obj.visibility.controller=bezier_float()
		if keyTime > 0 then
		(
			addnewkey ctrl keyTime
			addnewkey ctrl (keyTime+1)
			ctrl.keys[1].value=0
			ctrl.keys[2].value=1
		)
)
	
	
	
--select $b*

