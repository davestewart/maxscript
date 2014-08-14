fn getKeyTimes c=
(
	try(
		local ctrl=execute((classof c as string)+"()")
		fn drill c &ctrl=
		(
			for i = 1 to c.numSubs do
			(
				local cs=getSubAnim c i
				if cs.controller!=undefined then
				(
					if cs.controller.keys.count > 0 then
					(
						for k in cs.controller.keys do
						(
							addNewKey ctrl.keys k.time
						)
					)
				)
				drill cs &ctrl
			)
			return ctrl
		)
		drill c &ctrl
		sortKeys ctrl
		return ctrl.keys
	)
	catch(
		return undefined
	)
)

--c=getKeys $.position.controller
k=getKeyTimes $.position.controller
--c.keys[1].value

--c.keys[4]