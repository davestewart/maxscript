
fn doIt=
(
local oldP
local boneArr=$bone* as array
local planeArr=$plane* as array
for i = 1 to boneArr.count do
(
	-- get bone
		b=boneArr[i]

	-- create
		if planeArr.count==0 then
		(
		-- create
			p=plane width:b.length length:b.width widthsegs:1 lengthsegs:1
		-- pivot
			in coordsys p p.pivot=[-p.width/2.0,0,0]
		-- position
			p.pos=b.pos
		-- parent
			p.parent=boneArr[i].parent
		)
		else p=planeArr[i]

		-- rotation
			if b.parent==undefined then (
				p.transform=b.transform
			)
			else
			(
				trans = (b.transform * inverse b.parent.transform).rotation as eulerangles
				p.rotation.controller[1].value = trans.x
				p.rotation.controller[2].value = trans.y
				p.rotation.controller[3].value = trans.z
			)

		-- re-parent
			if planeArr.count==0 then
			(
				p.parent=oldP
				oldP=p
			)
	
)
)
---with animate on 
for t = 0 to 75  by 5 do at time t doit()