/*
-- Script:		Macro Lister
-- Author:		Dave Stewart
-- Release:		0.5
-- MaxVersion:	Tested on 8, will probably work on lower versions quite happily.
-- Date:		24 October 2005

-- Description:	Lists all installed macros in a tree-view, by category

-- Instructions:Run this file. UI access via Customize User Interface > MAX Script Tools > MacroLister
				Can be docked on the left or right sides of the screen

-- To do:		Lots, probably! But really, this was just for fun.
*/

macroScript MacroLister category:"MAX Script Tools"
	(
	global roMacroLister
	rollout roMacroLister "Macro Lister"
		(
		
		-- -----------------------------------------------------------------------------------
		-- interface
		-- -----------------------------------------------------------------------------------
		
			activeXControl tv "MSComctlLib.TreeCtrl" width:300 height:586 align:#left  pos:[0,0]
			--activeXControl ie "Shell.Explorer.2" pos:[396,6] width:380 height:780
			button btnCollapse "Collapse All" width:60 height:16 pos:[0,586]
			button btnExpand "Expand All" width:60 height:16 pos:[60,586]
			dropDownList ddl1 "" pos:[120,584] width:120 height:21
			
		-- -----------------------------------------------------------------------------------
		-- macro functions
		-- -----------------------------------------------------------------------------------


			-- variables
				local macroList
				local macroTable

			-- functions
			
				function createMacroArray=
					(
					local arr	= #()
					local ss	= stringstream ""
					macros.list to:ss
					seek ss 1
					while not eof ss do
						(
						local text		= (readLine ss) as stringstream
						local lineArr	= #()
						while peekToken text != undefined do (
							append lineArr (readToken text)
							)
						append arr lineArr
						)
					return arr 
					)
					
				function createOrderedMacroArray=
					(
				-- variables
					struct dataGrid (names,members)
					struct macroInfo (id, name, category, internalCategory, path)
					
					macroTable=dataGrid #() #()
					macroList=createMacroArray()
				
				-- convert the list of strings to a list of structs
					for i=1 to macroList.count do
						(
						local m=macroList[i]
						macroList[i]=macroInfo m[1] m[2] m[3] m[4] m[5]
						)
				
				-- loop through the list, and convert to a table
					for i = 1 to macroList.count do
						(
						-- get macro info
							local m=macroList[i]
							local category=m.category
					
						-- check datagrid
							local index=findItem macroTable.names category
							if index != 0 then
								(
								append macroTable.members[index] m
								)
							else
								(
								-- names
									append macroTable.names category
								-- members
									macroTable.members[macroTable.names.count]=#()
									append macroTable.members[macroTable.names.count] m
								)
						)
					)
			

				function getMacroList =
					(
					createMacroArray()
					createOrderedMacroArray()
					)

		-- -----------------------------------------------------------------------------------
		-- tv functions - UTILITY
		-- -----------------------------------------------------------------------------------
		
			fn getChildNodes rootNode=
				(
				local arr=#()
				local nextChild=rootNode.child
				for i = 1 to rootNode.children do
					(
					--print nextChild.text
					append arr nextChild
					nextChild=nextChild.next
					)
				return arr
				)

		-- -----------------------------------------------------------------------------------
		-- tv functions - BUILD
		-- -----------------------------------------------------------------------------------
		
			local total=0
			local newFile
			
			fn tvAddMacros tv theNode macroArr =
				(
				for i = 1 to macroArr.count do
					(
					total+=1
					newNode = tv.Nodes.add theNode.index 4 "" macroArr[i].name 0
					newNode.Tag=macroArr[i].id
					)
				theNode.sorted=true
				)


			fn tvAddCategories tv theNode arr =
				(
				for i = 1 to arr.count do
					(
					local txt=macroTable.names[i] +" ("+ (macroTable.members[i].count as string)+")"
					newNode = tv.Nodes.add theNode.index 4 "" txt 0
					newNode.bold=true
					newNode.Expanded=true
					--newNode.BackColor=color 255 225 225

					tvAddMacros tv newNode macroTable.members[i]
					)
				theNode.sorted=true
				)


		-- -----------------------------------------------------------------------------------
		-- tv functions - INIT
		-- -----------------------------------------------------------------------------------
		
			fn tvInit tv =
				(
				tv.Indentation = 28*15
				tv.LineStyle = #tvwRootLines 
				)

			fn tvBuild tv =
				(
				local theRoot
				local rootNodes
				
				theRoot = tv.Nodes.add()
				theRoot.text = "Macros"
				theRoot.Expanded=true
				rootNodes = for o in objects where o.parent == undefined collect o

				tvAddCategories tv theRoot macrotable.names 
				theRoot.text="Macros ("+total as string+")"
				theRoot.bold=true
				)
				
			local catNodes=#()
			fn populateDropDown =
				(
				catNodes=getChildNodes tv.nodes[1]
				local arr=#()
				for i = 1 to catNodes.count do arr[i]=catNodes[i].text
				ddl1.items=arr
				)

			on ddl1 selected item do
				(
				-- show last node
					local lastCatNode	= catNodes[roMacroLister.catNodes.count]
					local nodes			= getChildNodes lastCatNode
					nodes[nodes.count].ensureVisible()

				-- show chosen node
					catNodes[item].EnsureVisible()
					catNodes[item].Expanded = true
					catNodes[item].Selected = true

				)

		-- -----------------------------------------------------------------------------------
		-- UI handlers
		-- -----------------------------------------------------------------------------------
		
			--on tv nodeClick theNode do try(format "%\n" theNode.tag)catch()
			
			/*
			on tv nodeClick theNode do
				(
				try(
					format "%\n" theNode.tag
					--macros.run (theNode.tag as integer)
					--local newFile="C:/temp/tempMacro" + (random 0 1000) as string + ".txt"
					local newFile=getDir #plugcfg +"\\tempMacro.txt"
					copyFile theNode.tag newFile
					messagebox ""
					ie.Navigate newFile
					ie.Document.body.style.font="11px normal arial"
					)
				catch()
				)
				
				*/
			on tv DblClick do
				(
				try(
					local sel = roMacroLister.tv.SelectedItem
					macros.run (sel.Tag as integer)
					--messagebox sel
					)
				catch(err)
				)

			on tv Collapse Node do Node.bold=false
			on tv Expand Node do Node.bold=true

			on ie ProgressChange prog1 prog2 do
				(
				if prog1 == prog2 then
					(
					ie.Document.body.style.font="11px normal \"arial\""
					sleep 0.5
					--deleteFile newFile
					)
				)
			
			on btnCollapse pressed do
				(
				local nodes=getChildNodes tv.nodes[1]
				for n in (getChildNodes roMacroLister.tv.nodes[1]) do n.expanded=false
				)
			
			on btnExpand pressed do
				(
				local nodes=getChildNodes tv.nodes[1]
				for n in (getChildNodes roMacroLister.tv.nodes[1]) do n.expanded=true
				)
			
		-- -----------------------------------------------------------------------------------
		-- plugin start
		-- -----------------------------------------------------------------------------------
		
			on roMacroLister open do 
				(
				-- build macro table
					sleep 1
					getMacroList()					

				-- build tree view
					tvInit tv
					tvBuild tv
					tv.LabelEdit=#tvwManual
					tv.fullrowselect=true
					
				-- populate dropdown
					populateDropDown()
				)
				
			on roMacroLister resized size do 
				(
				tv.size=size-[0,16]
				btnCollapse.pos=[0,size[2]-16]
				btnExpand.pos=[60,size[2]-16]
				ddl1.pos=[120,size[2]-18]
				ddl1.width=size[1]-120
				)			
		)
	try(destroyDialog roMacroLister)catch()
	createDialog roMacroLister 300 600 style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
	cui.RegisterDialogBar roMacroLister minSize:[176,200] maxSize:[176*2,1000] style:#(#cui_dock_vert, #cui_floatable, #cui_handles, #cui_max_sized)
)

macros.run "Max Script Tools" "MacroLister"