fn getKeyTimes c=
	(
	try(
	-- function
		fn drill c &ctrl=
			(
			for k in c.keys do addNewKey ctrl.keys k.time
			for i = 1 to c.numSubs do drill (getSubAnim c i) &ctrl
			return ctrl
			)

	-- create controller
		local ctrl=execute((classof c as string)+"()")

	-- drill
		drill c &ctrl
		sortKeys ctrl
		return ctrl
		)
	catch(
		return undefined
		)
	)

--c=getKeys $.position.controller
c=getKeyTimes $.radius.controller
c.keys
