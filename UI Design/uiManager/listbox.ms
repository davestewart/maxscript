rollout ro1 "Listbox items" width:160 height:232
(
	multilistbox lbx1 "ListBox" pos:[8,8] width:144 height:13 items:#("1", "2", "3", "4", "5", "6", "7")
	button btnUp "Up" pos:[8,208] width:72 height:16
	button btnDown "Down" pos:[80,208] width:72 height:16
	
	local ui
	
	function moveListboxItem lbx dir index: =
		(
		
		if dir == #up then dir = -1
		else if dir == #down do dir = 1
		
		local items		= lbx.items
		
		local index1	= if index == unsupplied then lbx.selection else index
		local index2	= index1 + dir
		
		if dir < 0 then if index1 == 1 do return false
		else if dir > 0 then if index1 == items.count do return false
		
		swap items[index1] items[index2]
		lbx.items = items
		if index == unsupplied do lbx.selection = index2
		)
	
	function moveMultiListboxItems lbx dir =
		(
		if dir == #up then dir = -1
		else if dir == #down do dir = 1
		
		local items		= lbx.items
		local sel		= lbx.selection as array
		local index1	= sel[1]
		local index2	= sel[sel.count]
		local selNew	= #()
		
		if dir < 0 then
			(
			if index1 == 1 do return false
			for i = 1 to sel.count do
				(
				moveListboxItem lbx dir index:sel[i]
				append selNew (sel[i] + dir)
				)
			)
		else if dir > 0 then
			(
			if index2 == items.count do return false
			for i = sel.count to 1 by - 1 do
				(
				moveListboxItem lbx dir index:sel[i]
				append selNew (sel[i] + dir)
				)
			)
		
		lbx.selection = selNew
		
		)

	on ro1 open do
		(
		ui = uiManager ro1
		)
	
	on btnUp pressed do
		(
		ui.moveMultiListboxItems lbx1 #up
		)
		
	on btnDown pressed do
		(
		ui.moveMultiListboxItems lbx1 #down
		)
)

createdialog ro1

/*
arr = #(1,2,3,4,5)
swap arr[1] arr[5]
arr*/

ro1.lbx1.selection as array
