rollout ro1 "Combo Test" width:344 height:324
(
	dropdownList ddl1 "" pos:[9,299] width:100 height:21 items:#("1", "2", "3", "4") selection:1
	dropdownList ddl2 "" pos:[9,299] width:100 height:21 items:#("1", "2", "3", "4") selection:1
	ActiveXControl ax "MSComctlLib.ListViewCtrl" pos:[8,8] width:328 height:224
	

	local activeCell
	local twip			= 13.2 *2
	local yOffset		= 8
	local ddItems = #()
	local ddTypes = filterstring "Boolean,Float,Integer,String,Node" ","
	
	function initDD item=
		(
		local x			= (item.left / twip) + 8
		local y			= (item.top / twip) + yOffset
		local w			= (ro1.ax.columnheaders[1].width / twip)
		
		
		ddl1.pos		= [x,y]
		ddl1.width		= w
		ax.DropHighlight= undefined
		ddl1.selection = findItem ddl1.items (item.text)
		setFocus ddl1
		/*
		local pos		= getDialogPos ro1 + [12,24] + [x,y]
		createdialog ro2 style:#() pos:pos modal:true
		setfocus ro2.ddl1
		*/
		
		)
	
		
	on ro1 open do 
		(
		chs			= ax.ColumnHeaders
		
		ch1			= chs.add()
		ch1.text	= "Item"
		
		ch2			= chs.add()
		ch2.text	= "Type"
		
		ax.view		= #lvwReport 
		ax.LabelEdit= #lvwManual
		
		for i = 1 to 10 do
			(
			local li	= ax.listitems.Add()
			li.text		= "Item " + i as string
			append ddItems	li.text
			
			lis = li.ListSubItems.add()
			lis.text =  "String"
			)
		ddl1.items = ddItems
		)
		
	on ax ItemClick item do
		(
		initDD item
		activeCell = item
		)

	on ddl1 selected val do
		(
		activeCell.text = ddl1.items[val]
		)
		
	on ax MouseUp button shift x y do
		(
		ax.DropHighlight= undefined
		setfocus ddl1
		)
	/*
	on ax MouseDown button shift x y do
		(
		format "% %\n" x y
		ddl1.pos		=[x,y]+[8,8]
		setfocus ddl1
		)
*/
)
createDialog ro1 style:#(#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
/*

showmethods ro1.ax.ListItems

show ro1.ax


show ro1.ax.listitems[1]

showevents ro1.ax

.ColumnHeaders.add "item"



show ro1.ax

UpdateWindow ro1.ax

ro1.ax.columnheaders[2].width += 0
*/

/*
showevents ro1.ax
  on <control_name> BeforeLabelEdit Cancel:integer do ( ... )
  on <control_name> AfterLabelEdit Cancel:integer NewString:string do ( ... )
  on <control_name> ColumnClick ColumnHeader:ColumnHeader do ( ... )
  on <control_name> ItemClick Item:ListItem do ( ... )
  on <control_name> KeyDown KeyCode:integer Shift:integer do ( ... )
  on <control_name> KeyUp KeyCode:integer Shift:integer do ( ... )
  on <control_name> KeyPress KeyAscii:integer do ( ... )
  on <control_name> MouseDown Button:integer Shift:integer x:OLE_XPOS_PIXELS y:OLE_YPOS_PIXELS do ( ... )
  on <control_name> MouseMove Button:integer Shift:integer x:OLE_XPOS_PIXELS y:OLE_YPOS_PIXELS do ( ... )
  on <control_name> MouseUp Button:integer Shift:integer x:OLE_XPOS_PIXELS y:OLE_YPOS_PIXELS do ( ... )
  on <control_name> Click do ( ... )
  on <control_name> DblClick do ( ... )
  on <control_name> OLEStartDrag &Data:DataObject &AllowedEffects:integer do ( ... )
  on <control_name> OLEGiveFeedback &Effect:integer &DefaultCursors:boolean do ( ... )
  on <control_name> OLESetData &Data:DataObject &DataFormat:integer do ( ... )
  on <control_name> OLECompleteDrag &Effect:integer do ( ... )
  on <control_name> OLEDragOver &Data:DataObject &Effect:integer &Button:integer &Shift:integer &x:float &y:float &State:integer do ( ... )
  on <control_name> OLEDragDrop &Data:DataObject &Effect:integer &Button:integer &Shift:integer &x:float &y:float do ( ... )
  on <control_name> ItemCheck Item:ListItem do ( ... )
OK
*/


lis = ro1.ax.listitems[1].ListSubItems.add()
lis.text =  "Boolean"

 ro1.ddl1.selected "Boolean"