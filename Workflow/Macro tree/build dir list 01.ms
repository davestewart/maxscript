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
		
	
	