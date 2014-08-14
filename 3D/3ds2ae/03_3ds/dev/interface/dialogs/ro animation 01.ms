--VMS Tidy test rollout

try(destroyDialog roAnimation);catch()

rollout roAnim "Animation" width:496 height:456
(
	GroupBox grpObj "Object Manager" pos:[8,8] width:312 height:312
	ActiveXControl axObj "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,24] width:296 height:264
	dropdownList ddlGet "" pos:[160,294] width:152 height:21 items:#("Add from...", "----------------------", "Layer: One", "Layer: Houses", "Layer: Trees", "----------------------", "Selection Set: Groups", "Selection Set: Characters", "Selection Set: Ball")
	button btnAdd "Add" pos:[16,296] width:72 height:16
	button btnRemove "Remove" pos:[88,296] width:72 height:16
	GroupBox grpProp "Object Properties" pos:[8,328] width:312 height:120
	ActiveXControl axProp "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,344] width:296 height:96
	GroupBox grpAnimation "Animation" pos:[328,8] width:160 height:72
	radiobuttons rdoKeyframes "Keyframes:" pos:[336,24] width:123 height:46 labels:#("Bezier keyframes", "A key on every frame") columns:1
	GroupBox grpHierarchy "Hierarchy" pos:[328,88] width:160 height:144
	radiobuttons rdoOptions "Options" pos:[336,104] width:111 height:62 labels:#("Always use", "Use only if needed", "Never use") columns:1
	radiobuttons rdoExport "Export as" pos:[336,176] width:149 height:46 labels:#("Local space (parented)", "World space (un-parented)") columns:1


		

	on roAnim open do
(
	
	-- objects -------------------------------------
	-- style
		axObj.MultiSelect=true
		axObj.MousePointer = #ccArrow 
		axObj.GridLines = true 
		axObj.Checkboxes = true 
		axObj.AllowColumnReorder = false 
		axObj.BorderStyle = #ccFixedSingle 
		axObj.view = #lvwReport
		axObj.LabelEdit=#lvwManual
	
	-- set headers
		ch = axObj.columnHeaders 
		hProp = ch.Add index:"Object"
		hProp = ch.Add index:"Class"
	
	-- populate
		list = axObj.listItems
		local controlData=#("Sphere01","Box02","Point01", "Dummy01")
		for i=1 to controlData.count do 
		(
			local itemHead, itemBody
			itemHead = list.Add index:(controlData[i] as string)
			itemBody = itemHead.listsubitems.add index:"Geometry"
		)
		
		axObj.refresh()
	
	
	
	
	
	-- properties -------------------------------------
	-- style
		axProp.MousePointer = #ccArrow 
		axProp.GridLines = true 
		axProp.Checkboxes = true 
		axProp.AllowColumnReorder = false 
		axProp.BorderStyle = #ccFixedSingle 
		axProp.view = #lvwReport
	
	-- set headers
		ch = axProp.columnHeaders 
		ch.Add index:"Propety"
		ch.Add index:"Value"
	--				hControlName = ch.Add index:"Control"
	
	-- populate
		list = axProp.listItems
		local controlData=#("Transform","Position","Rotaton", "Scale")
		for i=1 to controlData.count do 
		(
			local itemHead, itemBody
			itemHead = list.Add index:(controlData[i] as string)
			if i == 1 then itemHead.bold=true
			--itemBody = itemHead.listsubitems.add index:(controlData[i][1] as string)
		)
	
		local controlData=#("Camera Parameters","Field of View","Focus")
		for i=1 to controlData.count do 
		(
			local itemHead, itemBody
			itemHead = list.Add index:(controlData[i] as string)
			if i == 1 then itemHead.bold=true
			--itemBody = itemHead.listsubitems.add index:(controlData[i][1] as string)
		)
	
	
	-- update interface
	--				ax.columnHeaders[1].position=2
		axProp.refresh()
	
	
	
)
	on axObj itemClick Item do
(
	--messagebox (Item.selected as string)
	local obj=getnodebyname (Item.text)
	if Item.selected then selectmore obj
	else deselect obj
)
	on btnAdd pressed do
(
	for o in objects do
	(
		li=roAnimation.axObj.ListItems.Add index:o.name
		--print li.ListSubItems.count
		li.ListSubItems.Add text:(superclassof o as string)
	)
	axProp.refresh()
)
)createDialog roAnim
/*
for i = 1 to roAnimation.axObj.listitems.count do roAnimation.axObj.listitems[i].forecolor=if (mod i 2 == 1) then (color 255 0 0) else (color 255 255 0)
.backcolor = (color 255 240 240)
*/