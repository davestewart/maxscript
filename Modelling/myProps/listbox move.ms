utility listScroll "listScroll" width:162 height:455
(
	listbox lbx1 "ListBox" pos:[8,8] width:144 height:5 items:#("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")
	listbox lbx2 "ListBox" pos:[8,104] width:144 height:5 items:#("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")

	on lbx1 selected sel do lbx2.selection = sel

)
