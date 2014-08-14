--macroScript SceneTreeView category:"HowTo"
--(
	rollout roTV "TreeView Scene Browser"
	(
		-- variables
			local total=0
		
		-- functions
			fn initTreeView tv ilTv=
			(
				tv.Indentation = 28*15
				tv.LineStyle = #tvwRootLines 
			)

			fn addMacros tv theNode macroArr =
			(
				for i = 1 to macroArr.count do
				(
					total+=1
					newNode = tv.Nodes.add theNode.index 4 "" macroArr[i].name 0
					newNode.Tag=macroArr[i].id
					--newNode.title=macroArr[i].path
				)
				theNode.sorted=true
			)


			fn addCategories tv theNode arr =
			(
				for i = 1 to arr.count do
				(
					local txt=macroTable.names[i] +" ("+ (macroTable.members[i].count as string)+")"
					newNode = tv.Nodes.add theNode.index 4 "" txt 0
					--newNode = tv.add theNode.index 4 "" macroTable.names[i] 0
					newNode.bold=true
					newNode.Expanded=true
					--newNode.BackColor=color 255 225 225

					addMacros tv newNode macroTable.members[i]
				)
				theNode.sorted=true
			)


			fn fillInTreeView tv =
			(
				theRoot = tv.Nodes.add()
				theRoot.text = "Macros"
				theRoot.Expanded=true
				rootNodes = for o in objects where o.parent == undefined collect o

				addCategories tv theRoot macrotable.names 
				theRoot.text="Macros ("+total as string+")"
				theRoot.bold=true
			)
				
		-- interface
			activeXControl tv "MSComctlLib.TreeCtrl" width:380 height:780 align:#left 


		-- handlers
			--on tv nodeClick theNode do try(format "%\n" theNode.tag)catch()
			
			on tv nodeClick theNode do
			(
				try(
					format "%\n" theNode.tag
					macros.run (theNode.tag as integer)
				)
				catch()
			)
			
			/*
			on spn_indent changed val do tv.indentation = val*15
			*/

			on roTV open do 
			(
				initTreeView tv ilTv
				fillInTreeView tv
				tv.LabelEdit=#tvwManual
				tv.fullrowselect=true

			)
				
			on roTV resized size do 
			(
				tv.size=size-[20,20]
			)			
	)
	try(destroyDialog roTV)catch()
	createDialog roTV 400 800 style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
--)
	
	
	