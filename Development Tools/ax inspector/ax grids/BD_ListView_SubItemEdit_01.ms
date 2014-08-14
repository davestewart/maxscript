global foo, editDialog  --global only to examine from listner
function getMaxColors = 
(
	function GetColorValue v = (return (color ( v[1]*255) (v[2]*255) (v[3]*255))) --converts the float value to 256 based value
	bkColor =  (GetColorValue (colorMan.getColor #window))
	txtColor =  (GetColorValue (colorMan.getColor #windowtext))
	dialogColor = (GetColorValue (colorMan.getColor #backGround))
)
function fixOleColor col =(	local newCol = (color col.b col.g col.r) )
/*--------------ROLLOUTS-----------------*/
rollout editDialog "" width:200 height:17
(
	button x "x" width:16 height:16 pos:[editDialog.width - 16,0]
	edittext edt1 "" width:(editDialog.width-12) height:16 pos:[-3,0]
	on x pressed do destroyDialog editDialog
)
rollout foo "ListViewTester" width:680 height:500
(
	label lb1 "Active-X Listview Example:" pos:[7,8] 
	ActiveXControl lvObjects "MSComctlLib.ListViewCtrl.2" pos:[0,30] width:(foo.width) height:(foo.height-60)
	groupBox grp1 "" pos:[1,-3] width:160 height:30
	fn initListView lv = (
		lv.Appearance = #ccFlat; lv.HoverSelection = false; lv.MousePointer = #ccArrow; lv.GridLines = true; 
		lv.AllowColumnReorder = false; lv.BorderStyle = #ccFixedSingle;	lv.view = #lvwReport; lv.Checkboxes = true; 
		lv.FullRowSelect = true; lv.MultiSelect = false; lv.HideColumnHeaders = false; lv.LabelEdit = #lvwmanual; 
		lv.FlatScrollBar = false; lvColumnsAdd = lv.columnHeaders
		tmp = lvColumnsAdd.add(); tmp.text = "Label"; windows.sendMessage lv.hwnd (0x1000+30) 0 120
		tmp = lvColumnsAdd.add(); tmp.text = "In"; windows.sendMessage lv.hwnd (0x1000+30) 1 45
		tmp = lvColumnsAdd.add(); tmp.text = "Out"; windows.sendMessage lv.hwnd (0x1000+30) 2 45
		tmp = lvColumnsAdd.add(); tmp.text = "Width"; windows.sendMessage lv.hwnd (0x1000+30) 3 45
		tmp = lvColumnsAdd.add(); tmp.text = "Height"; windows.sendMessage lv.hwnd (0x1000+30) 4 45
		tmp = lvColumnsAdd.add(); tmp.text = "Aspect"; windows.sendMessage lv.hwnd (0x1000+30) 5 45
		tmp = lvColumnsAdd.add(); tmp.text = "Output Path"; windows.sendMessage lv.hwnd (0x1000+30) 6 335
		lv.backColor = fixOleColor bkColor 
		lv.foreColor = fixOleColor txtColor
		lv.font = "arial"
		lv.font.size = 8
	)
	fn addSomeStuff lv = (
		for t = 1 to 30 do(
			local newEvent1 = lv.listItems.add()
			newEvent1.text = "My Label " + (t as string)
			newEvent1.bold = true
			local newEvent2 = newEvent1.ListSubItems.add()	--Create the Start Frame field
			newEvent2.text = animationRange.start as string
			newEvent2.foreColor = (color 120 150 0)
			local newEvent3 = newEvent1.ListSubItems.add()	--Create the Start Frame field
			newEvent3.text = animationRange.end as string
			newEvent3.foreColor = (color 120 150 0)
			local newEvent4 = newEvent1.ListSubItems.add()	--Create the Start Frame field
			newEvent4.text = renderWidth as string
			newEvent4.foreColor = (color 0 150 0)
			local newEvent5 = newEvent1.ListSubItems.add()	--Create the Start Frame field
			newEvent5.text = renderHeight as string
			newEvent5.foreColor = (color 0 150 0)
			local newEvent6 = newEvent1.ListSubItems.add()	--Create the Start Frame field
			newEvent6.text = renderPixelAspect as string
			newEvent6.foreColor = (color 0 150 0)
			local newEvent7 = newEvent1.ListSubItems.add()	--Create the Start Frame field
			newEvent7.text = (getDir #scripts) + "\\my_output_" + (t as string)
			newEvent7.foreColor = (color 200 0 0)
		)	
	)	
	local h_offset
	on foo open do(
		initListView lvObjects --Initialize the List View Control
		addSomeStuff lvObjects --include some temp listitems:
		h_offset = lvObjects.listItems[1].left --gets the standard size of the leftmost column offset to be used later
	)
	on foo resized p do(
		lvObjects.size = p - [0,60]	
		windows.sendMessage lvObjects.hwnd (0x1000+30) 6 (p.x - 345) --adjust last column width
	)
	on lvObjects dblclick do(	
		global selItemArray = #()
		local twipPerPixelConstant = 26.47058882353 --arial 7 point
		selItemArray = (listview.hitTest lvObjects.hwnd (getCursorPos lvObjects))
		local item = if selItemArray[2] == 0 then( lvObjects.listItems[selItemArray[1]] )else( lvObjects.listItems[selItemArray[1]].listSubItems[selItemArray[2]] )--gets a reference to the listItem or listSubItem
		local Y1 = ( lvObjects.listItems[selItemArray[1]].top / twipPerPixelConstant ) as integer
		local y = (getDialogPos foo).y + lvObjects.pos.y + ( Y1 + 32 ) --get the y position of the top of the selected listSubItem with a "+ 30" constant that is needed to adjust for the column headers. If you don't have the column headers visible, then I believe you would take the "+ 30" out
		global columnPositions = #()
		local num_columns = 7 --place your value here
		local lastColPos = 0
		for t = 0 to (num_columns-1) do(
		    local thisColWidth = (windows.sendMessage lvObjects.hwnd (0x1000+29) t 0 )
		    append columnPositions (lastColPos + 4); --the "+4" is an offset needed to get exact position of the column..adjust to your own needs
		    lastColPos += thisColWidth
		)
		columnPositions[1] -= 4 --you may want to trim back only the first column by the offset you gave it above...because the get column message includes and extra 4 pixels for the first column
		local x = (getDialogPos foo).x + lvObjects.pos.x + columnPositions[selItemArray[2]+1]  	
		--adjust for horizontal scroll
		local h_offset2 = ( lvObjects.selectedItem.left / twipPerPixelConstant ) - (h_offset / twipPerPixelConstant ) + 1
		x += h_offset2
		local w
		case (selItemArray[2]+1) of(
			1:( --label column
				w = (columnPositions[selItemArray[2]+2] - columnPositions[selItemArray[2]+1]-1) - ( h_offset / twipPerPixelConstant ) 
				x += ( h_offset / twipPerPixelConstant ) + 4 
			)
			num_columns:( --path column
				w = (foo.width - columnPositions[selItemArray[2]+1]) - 15
			)
			default:(
				w = (columnPositions[selItemArray[2]+2] - columnPositions[selItemArray[2]+1]-1) 
			)
		)
		createDialog editDialog width:w height:17  pos:[x,y] style:#() modal:true
	)
)


getMaxColors()


createDialog foo style:#(#style_titlebar,#style_resizing,#style_sysmenu)