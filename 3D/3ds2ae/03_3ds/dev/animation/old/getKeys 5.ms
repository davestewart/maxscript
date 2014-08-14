c=undefined
(
local drill
fn getKeyTimes c=
	(
	-- create temporary controller
		local ctrl=execute((classof c as string)+"()")
	-- recursive function
		fn drill c &ctrl=
			(
			for k in c.keys do addNewKey ctrl.keys k.time
			for i = 1 to c.numSubs do
				(
				sa=getSubAnim c i
				if sa.controller!=undefined then drill sa &ctrl
				)
			)

	-- drill
		drill c &ctrl
		sortKeys ctrl
		return ctrl
	try(
		)
	catch(
		return undefined
		)
	)

c=getKeyTimes $.position.controller
c.keys
)
--c[1].keys[1].value