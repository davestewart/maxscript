rollout ro2 "Control" width:144 height:20
(
	dropdownList ddl1 "" pos:[0,0] width:144 height:21 items:#("1", "2", "3", "4")
	on ddl1 selected val do destroydialog ro2
)

createdialog ro2 style:#()  pos:[200,200]



--destroydialog ro2
show ro2

