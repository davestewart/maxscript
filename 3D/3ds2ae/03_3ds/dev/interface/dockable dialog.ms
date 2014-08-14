-- dockable dialog
	
	rollout ro1 "DropDown" width:160 height:40
		(
		dropDownList ddl1 "" pos:[2,2] width:134 height:21 items:#("1","2","3")
		on ddl1 selected sel do messagebox (sel as string)
		)
	
	rf=createdialog  ro1 height:38 width:150
	cui.RegisterDialogBar ro1 style:#(#cui_dock_all, #cui_floatable, #cui_handles)
	
	
-- flyout

	rollout ro2 "test" width:32 height:96
		(
		button btn1 "1" pos:[0,0] width:32 height:32
		button btn2 "2" pos:[0,32] width:32 height:32
		button btn3 "3" pos:[0,64] width:32 height:32
		)	
	createdialog ro2 style:#(#style_border)
	createdialog ro2 style:#(#style_sunkenedge) pos:(mouse.screenpos-[0,96])
	destroydialog ro2
	
	