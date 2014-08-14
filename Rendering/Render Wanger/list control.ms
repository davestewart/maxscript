rollout controlR92 "Camera renderer" width:231 height:259
(
	dropdownList ddl1 "DropDownList" pos:[8,8] width:216 height:40
	button btn1 "Button" pos:[37,106] width:102 height:24
	
	on controlR92 open do
(
	camArr = for c in cameras 
		where (classOf c == Targetcamera)
			collect c.name
	
	camArr = join #("") camArr
	ddl1.items = camArr
)
	
	on btn1 pressed do
(
	c = getNodeByName ddl1.selected
	if ! isValidNode c then c = undefined
	print c
	render camera:undefined
)
)

if nr92 != undefined then closerolloutfloater nr92 
	nr92 = newRolloutFloater "Microsoft ListView Control, version 6.0" 350 300 10 10 
	addRollout ControlR92 nr92 
