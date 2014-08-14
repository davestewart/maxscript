--macroScript SceneTreeView category:"HowTo"
--	(
	rollout roTV "TreeView Scene Browser"
		(
		
		-- -----------------------------------------------------------------------------------
		-- interface
		-- -----------------------------------------------------------------------------------
		
			activeXControl tv "MSComctlLib.TreeCtrl" width:380 height:780 align:#left 
			activeXControl ie "Shell.Explorer.2" pos:[396,6] width:380 height:780
			
		-- -----------------------------------------------------------------------------------
		-- macro functions
		-- -----------------------------------------------------------------------------------


			-- variables
				local logFile="$plugcfg/macroList.txt"
				local macroList
				local macroTable

			-- functions
				function saveMacrosList =
					(
					clearListener()
					openLog logFile
					macros.list()
					flushLog()
					closeLog()
					)
			
				function createMacroArray=
					(
					local arr=#()
					local fs= openfile logFile
					while not eof fs do
						(
						local text= (readLine fs) as stringstream
						local lineArr=#()
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
					-- functions
						fn fileExists fname = return (getfiles fname).count != 0

					-- build macro list
						if NOT fileExists logFile then saveMacrosList()
						else if (querybox "Refresh macro list before starting?") then saveMacrosList()
						
						createMacroArray()
						createOrderedMacroArray()
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
					newNode.Tag=macroArr[i].path
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
		
			fn tvInit tv ilTv=
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
				


		-- -----------------------------------------------------------------------------------
		-- UI handlers
		-- -----------------------------------------------------------------------------------
		
			--on tv nodeClick theNode do try(format "%\n" theNode.tag)catch()
			
			
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
				
				
			on tv DblClick do
				(
				local sel = roTV.tv.SelectedItem
				macros.run sel.Key
				--messagebox sel
				)

			on ie ProgressChange prog1 prog2 do
				(
				if prog1 == prog2 then
					(
					ie.Document.body.style.font="11px normal \"arial\""
					sleep 0.1
					--deleteFile newFile
					)
				)
			
		-- -----------------------------------------------------------------------------------
		-- plugin start
		-- -----------------------------------------------------------------------------------
		
			on roTV open do 
				(
				-- build macro table
					sleep 0.1
					getMacroList()					

				-- build tree view
					tvInit tv ilTv
					tvBuild tv
					tv.LabelEdit=#tvwManual
					tv.fullrowselect=true
				)
				
			on roTV resized size do 
				(
				tv.size=size-[20,20]
				)			
		)
	try(destroyDialog roTV)catch()
	createDialog roTV 800 800 pos:[10,10] style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
	cui.RegisterDialogBar roTV style:#(#cui_dock_all, #cui_floatable, #cui_handles)
		
	
	