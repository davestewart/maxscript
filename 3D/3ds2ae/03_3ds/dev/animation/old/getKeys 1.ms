fn getKeys c=
	(
	local ctrl=execute((classof c as string)+"()")
	--local arr=#()
	fn drill c=
		(
		for i = 1 to c.numSubs do
			(
			local cs=getSubAnim c i
			if cs.controller!=undefined then
				(
				--print (cs.controller.keys)
--				if finditem arr 
				--append arr
				if cs.controller.keys.count > 0 then
					(
					for k in cs.controller.keys do
						(
						print k.time
						--addNewKey ctrl.keys k.time
						)
					)
				)
			drill cs
			)
		)
	drill c
	sortKeys ctrl
	print ctrl
	)

$.position.controller.numSubs

$.position.controller.numSubs


$.position.isAnimated -- true


cArr=getSubAnimNames $.position.controller
for c in cArr do getSubAnimNames c.controller



c=$.position.controller
for i = 1 to c.numSubs do
	(
	local cs=getSubAnim c i
	print (cs.controller.keys)--()
	)


k = c[1].controller[1].keys
classof k
print c[1].numsubsc[1].
getSubAnim c[1] 1

getKeys $.position.controller



b=bezier_point3()
addNewKey b.keys 46
sortKeys b
b.keys

p

Position_XYZ()
p.keys.count
superclassof c as string+"()"
execute ("p=PositionController()")
position_XYZ()
classof c
p=undefined
ctrl=undefined
