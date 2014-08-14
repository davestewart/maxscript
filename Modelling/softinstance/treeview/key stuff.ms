local 
	kCtrl = 2, 
	kF2 = 113, 
	kF5 = 116, 
	kDelete = 46, 
	kCtrlX = 24, 
	kCtrlC = 3, 
	kCtrlV = 22, 
	kCtrlG = 7


on tv1 keyUp KeyCode Shift do
(
	print keyCode
	case keyCode of
(
		kF5		: fRefresh()
		kF2 	: startEdit()
		kDelete	: fDeleteItem()				
)
)


local kCtrl = 2

on tv1 keyPress keyCode do
(
	--local sel = tv1.selectedItem
	case keyCode of
	(
		kCtrl 	: if dropNode.expanded==true then dropNode.expanded=false else dropNode.expanded=true
/*
		kCtrlX 	: if isValidNode sel.tag then ensMenu.mi_cut.picked()
		kCtrlC	: if isValidNode sel.tag then ensMenu.mi_copy.picked()
		kCtrlV	: if sel.parent != undefined then ensMenu.mi_paste.picked()
		kCtrlG  : findNext()
*/
	)
)		


local kCtrl = 2

on tv1 keyPress keyCode do
(
	if keyCode == kCtrl then
	(
		if dropNode.expanded==true then dropNode.expanded=false
		else dropNode.expanded=true
	)
)		
	