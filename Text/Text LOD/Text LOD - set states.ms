theMod = 1
fn setAllLod state =
(
	for obj in objects do
	(
		for m in obj.modifiers do
		(
			if m.name == "Level of Detail" then
			(
				--print (obj.name +" : "+m.arrNodes as string)
				m.setLod #high
			)
		)
	)
)

setAllLod #high

$[1].modifiers[1].setLod #low

$[1].modifiers[1].main.setLod #low



--themod.setLod #high