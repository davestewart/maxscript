fileIn  "utilityRollouts.ms"

rollout rProp "Property Grid" 
	( 

-- interface
	activeXControl axProp "vbAcceleratorSGrid.vbalGrid" height:300 width:401 align:#left 

	button btnSet "Set properties" width:400 height:16
	button btnProps "Props" width:130 height:16 align:#left across:3
	button btnMethods "Methods" width:130 height:16 align:#left
	button btnEvents "Events" width:130 height:16 align:#left


	on btnSet pressed do 
		(
		format"rProp.axProp.\n"
		)

	--show rProp.axProp.categories[1]
	on axProp ValueChanged Item do
		(
		if item.type==#PropertyItemString then
			item.caption=item.value + " ("+item.value as string+")"
		format ">%\n" item.type
	 	)
	
	on axProp RClick Item do 
		(
	--	if item == Categories[1].childs[2]
	--		messagebox item.index as string
		show item
		if item.type==#PropertyItemColor then
			(
			global curItem=item
			--messagebox "Item is Color"
			createdialog roColor 100 100 mouse.screenpos[1] mouse.screenpos[2] modal:true
	
	
			)
	
		)

--rProp.

	on btnProps pressed do showproperties axProp
	on btnMethods pressed do showmethods axProp
	on btnEvents pressed do showevents axProp

	on rProp open do
		(
		axProp.gridlines=true
		)

	) 
if propfloater != undefined then closerolloutfloater propfloater
propFloater = newRolloutFloater "Grid" 450 450 10 10 
addRollout rProp propFloater 
addRollout rAccelState propFloater 
