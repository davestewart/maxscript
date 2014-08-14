/*
Client:PEN Productions Inc.

Created By: Paul Neale
Company: PEN Productions Inc.
E-Mail: pen_productions@yahoo.com
web Site: http://members.rogers.com/paulneale
Start Date: July 01 2003
Version: 1.00

Purpose:
Max version 5x

Usage:
 
Updated:

Bugs:

ToDo:
-Add support for material CA's.

*/

--Globals
global objDefs = #(), getDefsCall, getDefs, editAttributesR, currentDefsLb, makeTempDefScriptFn
struct dataSt (object, type, def) --Struct for storing def data

--Collects all the definitions on the selected objects
fn getDefsFn =
(
	objDefs = #() --Clear the definition array.
	
	--Recursive search for all definition on objects and modifiers.
	--Need to add support for materials. This could be a big pain.
	for obj in selection do  
(
		if obj.modifiers.count > 0 then
	(
			for x = 1 to obj.modifiers.count do
		(
				for numDef = 1 to (custAttributes.count obj.modifiers[x]) do
			(
					data = dataSt object:obj type:("Modifier: " + obj.modifiers[x].name) def:(custAttributes.getDef obj.modifiers[x] numDef)
					append objDefs data
			)
		)
	)
		for numDef = 1 to (custAttributes.count obj) do
	(
			data = dataSt object:obj type:"Object" def:(custAttributes.getDef obj numDef)
			append objDefs data
	)
)
	--update the list box and make the temp scripts for the existing CA's
	editAttributesR.upDateCurListFn objDefs
	editAttributesR.makeTempDefScriptFn()
	
	return 1
)
fn getDefsCall = (getDefsFn()) --Used for the callBack


--Interface
try(destroyDialog editAttributesR)catch()
rollout editAttributesR "Edit Attributes" width:510
(
	local defFile = #() --Array of items in the new Definitions list.
	local tempFiles = #() --Array of temp definition files
	local curDefAr = #("Object:", "Type:", "Definition Names:")
	local newDefAr = #("Path:", "New Definition Names:")

	local axW = 360, btW = 120
	
	label curListlb "Current Attribute Definitions:" align:#left
	activeXControl CurListAx "MSComctlLib.ListViewCtrl.2" width:axW height:160
	label defListLb "Loaded Attribute Definitions:" align:#left
	activeXControl newDefListAx "MSComctlLib.ListViewCtrl.2" width:axW height:160
	
	hyperLink webSiteHl "http://members.rogers.com/paulneale" color:yellow hoverColor:red visitedColor:blue address:"http://members.rogers.com/paulneale"
	
	button openCaBt "Open Definition" width:btW offset:[190,-370]
	button updateDefBt "Redefine Definition" width:btW offset:[190,20]
	button makeUniqueBt "Make Unique" width:btW offset:[190,0]
	button delDefBt "Delete Definition" width:btW offset:[190,0]
	
	button getNewDefsBt "Load Definition" width:btW offset:[190,60]
	button removeBt "Remove from List" width:btW offset:[190,0]
	button openNewDefBt "Open Definition" width:btW offset:[190,10]
	button addNewDefBt "Add New Definition" width:btW offset:[190,10]
	button updateNewDefBt "Redefine Definition" width:btW offset:[190,0]

	--Setup axlists
	Fn axListSetupFn ax =
(
/*		clearListener()
		showProperties ax
		print "-------------"
		showMethods ax
		print "-------------"
		showEvents ax
*/		
		enableAccelerators = false
		ax.gridLines = true
		ax.view = #lvwReport
		ax.multiSelect = false
		ax.labelEdit = #lvwManual
		ax.sorted = false
		ax.fullRowSelect = true
		ax.hotTracking = true
		ax.hideSelection = false
)

	--Add columns to Axlists
	Fn axListCols ax colNames = 
(
		local LVM_First = 0x1000, LVM_SETCOLUMNWIDTH = (LVM_First + 30)
		
		for x = 1 to colNames.count do
	(
			col = ax.ColumnHeaders.add()
			col.text = colNames[x]
			windows.sendMessage ax.hwnd LVM_SETCOLUMNWIDTH (x - 1) (axW / colnames.count - 2)
	)
	--**local LVM_First = 0x1000
		--LVM_Fisrt is a binary variable that is used by the windows send message to define which command is being used.
	--**local LVM_SETCOLUMNWIDTH = (LVM_First + 30)
		--LVM_SETCOLUMNWIDTH is an undefined varriable that is needs a binary value assigned that represents 
		--which command it is. In this case it is 0x1000 + 30 which is the Set Column Width command.
		--http://www.winehq.com/hypermail/wine-devel/2002/10/0542.html	--List of all the binary integers for all hwnd commands for listView.
	--**windows.sendMessage ax.hwnd LVM_SETCOLUMNWIDTH 1 200
		--LVM commands always take two argumants, in this case the number of the column and the width of the column.
		--Windows.sendMessage sends a message to a window and in this case it is defined as the acitveX control that is being used.
		--hwnd stands for Window Handle and is the window that is being called.
)
	
	--Adds data to CurListAx
	Fn upDateCurListFn objDefs =
(
		CurListAx.listItems.clear()
		for x = 1 to objDefs.count do
	(
			li = CurListAx.ListItems.add()
			li.text = objDefs[x].object.name
			
			li1 = li.listSubItems.add()
			li1.text = objDefs[x].type 
			
			li1 = li.listSubItems.add()
			li1.text = objDefs[x].def.name as string 
	)
)
	
	--Adds data to newDefListAx
	Fn upDateNewDefListFn defFile =
(
		newDefListAx.listItems.clear()
		for x = 1 to defFile.count do
	(
			li = NewDefListAx.ListItems.add()
			li.text = (getFileNamePath defFile[x])
			
			li1 = li.listSubItems.add()
			li1.text = (fileNameFromPath defFile[x])
	)
)
	
	--Set Ini file
	Fn setIniFn =
(
		pathVr = ((getDir #plugCfg) + "\\editAttributes.ini")
		opFile = createFile pathVr
		
		format "DialogPos>%\n" (getDialogPos editAttributesR as string) to:opFile
		for x = 1 to defFile.count do
	(
			format "defFile>%>%\n" (x as string) defFile[x] to:opFile
	)
		close opFile
)
	
	--Get Ini file
	Fn getIniFn =
(
		pathVr = ((getDir #plugCfg) + "\\editAttributes.ini")
		if (getFiles pathVr).count != 0 then
	(
			opFile = openFile pathVr mode:"r"
			while not (eof opFile) do
		(
				str = readLine opFile
				if (findString str "DialogPos>") != undefined then (setDialogPos editAttributesR (execute (filterString str ">")[2]))
				if (findString str "defFile>") != undefined then (append defFile (filterString str ">")[3])
		)
			close opFile

	)
		upDateNewDefListFn defFile
)
	
	--Returns the selected item nubmer from the lists
	Fn getSelFromlistFn ax =
(
		for x = 1 to ax.listItems.count do (if ax.listItems[x].selected then (return x))
		return 0
)
	
	--Formats all custom attribute definitions to a script.
	fn formatDefsFn def =
(
		attribFile = newScript()
		reDef = (custAttributes.getDefSource def)
		format "%\n" redef to:attribFile
)
	
	--Reads and redefines a custom attribute set from a script.
	Fn redefineDefFn curDef reDef obj =
(
		
		openedFile = openFile reDef
		str = ""
		while not (eof openedFile) do
	(
			str += (readLine openedFile) + "\n"
	)
		custAttributes.redefine curDef str
)

	--Adds a new definition from a script file
	Fn addNewDefFn obj reDef =
(
		openedFile = openFile reDef
		str = ""
		while not (eof openedFile) do
	(
			str += (readLine openedFile) + "\n"
	)
		def = execute str
		custAttributes.add obj def
		
		getDefsFn()
)

	--Deletes Definitions
	fn delDefsFn =
(
		for obj in selection do
	(
			if obj.modifiers.count > 0 then
		(
				for x = 1 to obj.modifiers.count do
			(
					for numDef = 1 to (custAttributes.count obj.modifiers[x]) do
				(
						custAttributes.delete obj.modifiers[x] objDefs[getSelFromlistFn CurListAx].def
				)
			)
		)
			for numDef = 1 to (custAttributes.count obj) do
		(
				custAttributes.delete obj objDefs[getSelFromlistFn CurListAx].def
		)
	)
		getDefsFn()
)
	
	fn uniqueDefsFn =
(
		for obj in selection do
	(
			if obj.modifiers.count > 0 then
		(
				for x = 1 to obj.modifiers.count do
			(
					for numDef = 1 to (custAttributes.count obj.modifiers[x]) do
				(
						custAttributes.makeUnique obj.modifiers[x] objDefs[getSelFromlistFn CurListAx].def
				)
			)
		)
			for numDef = 1 to (custAttributes.count obj) do
		(
				custAttributes.makeUnique obj objDefs[getSelFromlistFn CurListAx].def
		)
	)
		getDefsFn()
)
	
	--Deletes tempFiles when selection changes.
	Fn deleteTempFilesFn tempFiles =
(
		for x in tempFiles do (deleteFile x)
)
	
	--Converts strings to UPPER case.
	Fn upperCase_fn inStr =
(
		if (inStr == undefined) then
			return undefined
		upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		lower = "abcdefghijklmnopqrstuvwxyz"
		
		outStr = copy inStr
		for i = 1 to outStr.count do
	(
			j = (findString lower outStr[i])
			if (j != undefined) do
		(
				outStr[i] = upper[j]
		)
	)
		return outStr
)
	
	--Remove Redefine from definition.
	Fn removeRedefineFn reDef =
(
		inStr = reDef as stringStream
		str = ""
		while not (eof inStr) do
	(
			tempStr = (readLine inStr)
			If (findString (upperCase_fn tempStr) (upperCase_fn "Redefine:")) == undefined do (str += (tempStr + "\n"))
	)
		return str
)
	
	--Makes temp scripts of the existing definitions
	--Update to handle file naming better.
	--Add deleting the temp files once the dialog is closed or another object is selected.
	fn makeTempDefScriptFn =
(
		deleteTempFilesFn tempFiles
		tempFiles = #()
		for x = 1 to objDefs.count do
	(
			reDef = removeRedefineFn (custAttributes.getDefSource objDefs[x].def)
			
			pathVr = ((getDir #scripts) + "\\" + objDefs[x].def.name + "_temp" + (x as string) + ".ms")
			theFile = createFile pathVr
			format "%\n" redef to:theFile
			
			append tempFiles pathVr
			
			flush theFile
			close theFile
	)
)	

	on editAttributesR open do
(	
		--Update ax lists
		axListSetupFn CurListAx
		axListCols CurListAx curDefAr
		axListSetupFn newDefListAx
		axListCols newDefListAx newDefAr
		
		getDefsFn() --Get the definitions when the script first runs.
		callBacks.addScript #selectionSetChanged "getDefsCall()" id:#allCalls
		
		getIniFn()
)
	on editAttributesR close do
(
		callBacks.removeScripts id:#allCalls
		deleteTempFilesFn tempFiles
		
		setIniFn()
)
	
	--Called on double clicking an object in the CurListAx control
	on CurListAx dblClick do
(
		selData = tempFiles[getSelFromlistFn CurListAx]
		edit selData
)
	
	on openCaBt pressed do
(
		sel = getSelFromlistFn CurListAx
		if sel > 0 then (edit tempFiles[sel])else (messageBox "No Definition selected" title:"Error:")
)
	
	on delDefBt pressed do
(
		if (queryBox "Do you want to delete this definition?" title:"Deleting definition") then (delDefsFn())
)
	
	on makeUniqueBt pressed do
(
		if (queryBox "Do you want to make this definition unique?" title:"Unique definition") then (uniqueDefsFn())
)
	
	on newDefListAx dblClick do
(
		sel = getSelFromlistFn newDefListAx
		if sel > 0 do (edit defFile[getSelFromlistFn newDefListAx])
)

	on getnewDefsBt pressed do
(
		file = getOpenFileName caption:"Get Definition File:" \
		fileName:"" \
		types:"Definition Files (*.ms)|*.ms|All Files (*.*)|*.*"
		if file != undefined then
	(
			append defFile file
	)
		upDateNewDefListFn defFile
)
	
	on removeBt pressed do
(
		sel = getSelFromlistFn newDefListAx
		if sel > 0 do 
	(
			deleteItem defFile sel
	)
		upDateNewDefListFn defFile
)
	
	on openNewDefBt pressed do
(
		sel = getSelFromlistFn newDefListAx
		if sel > 0 do (edit defFile[getSelFromlistFn newDefListAx])
)
	
	on updateDefBt pressed do
(
		sel = getSelFromlistFn CurListAx
		if sel > 0 then
	(
			selData = tempFiles[sel]
			redefineDefFn objDefs[getSelFromlistFn CurListAx].def selData objDefs[getSelFromlistFn CurListAx].object
		)else
	(
			messagebox "No Definition to Redefine" title:"Error:"
	)
)
	
	on addNewDefBt pressed do
(
		sel = getSelFromlistFn newDefListAx
		if selection.count == 1 then
	(
			if sel > 0 then 
		(
				max modify mode
				addNewDefFn (modPanel.getCurrentObject()) defFile[sel]
			)else
		(
				messageBox "You must have a New Definition loaded and selected in the list!" title:"Error:"
		)
		)else
	(
			messageBox "You must have ONE object selected!" title:"Error:"
	)
)
	
	on updateNewDefBt pressed do
(
		sel = getSelFromlistFn newDefListAx
		if sel > 0 then
	(
			selData = defFile[sel]
			redefineDefFn objDefs[getSelFromlistFn CurListAx].def selData objDefs[getSelFromlistFn CurListAx].object
	)
)
)

