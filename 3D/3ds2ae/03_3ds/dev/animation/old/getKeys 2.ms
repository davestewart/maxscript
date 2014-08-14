(
fn getKeys c=
(
	--global tmpCtrl
	local tmpCtrl=execute((classof c as string)+"()")
	fn drill c &tmpCtrl=
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
						addNewKey tmpCtrl.keys k.time
					)
				)
			)
			drill cs &tmpCtrl
		)
		return tmpCtrl
	)
	ctrl=drill c &tmpCtrl
	sortKeys ctrl
	tmpCtrl=undefined
	return ctrl
)
)

c=getKeys $.position.controller
--c.keys[1].value

c.keys