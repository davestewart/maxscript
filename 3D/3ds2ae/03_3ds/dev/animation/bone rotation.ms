global p,b
boneArr=$bone* as array
planeArr=$plane* as array
(
local oldP
local i=0
for b in boneArr do
	(
	-- sort bone rotation
		try(
		trans = (b.transform * inverse b.parent.transform).rotation as eulerangles
		fk=b.controller[4]
		fk.rotation.controller[1].value = trans.x
		fk.rotation.controller[2].value = trans.y
		fk.rotation.controller[3].value = trans.z
		)
		catch()

	-- create
		--p=plane width:b.length length:b.width widthsegs:1 lengthsegs:1
		p=planeArr[(i+=1)]
	-- pivot
		in coordsys p p.pivot=[-p.width/2.0,0,0]
	-- parent
		if oldP != undefined then p.parent=oldP
		oldP=p

	-- separate transforms
		-- scale
			p.scale=b.scale
		-- rotation
			local cSys=if b.parent != undefined then #parent else #world
			--in coordsys cSys 
			p.rotation=b.rotation
		-- position
			p.pos=b.pos

	-- combined transform
		--p.transform=b.transform

	-- setting rows manually
		/*
		local trans= p.transform 
		trans.row1= b.transform.row1
		trans.row2= b.transform.row2
		trans.row3= b.transform.row3
		
		p.transform = trans
		*/


	)
)

fn RotatePivotOnly obj rotation= (
	local rotValInv=inverse (rotation as quat)
	animate off in coordsys local obj.rotation*=RotValInv
	obj.objectoffsetrot*=RotValInv
	obj.objectoffsetpos*=RotValInv
)
/*
RotatePivotOnly $ ((eulerangles 0 0 90) as quat)


in coordsys $bone01 $.rotation = (pickObject()).rotation

in coordsys $bone01 $.pos= (pickObject()).pos

in coordsys $bone01 $.transform = (pickObject()).transform

$.rotation as eulerangles
*/