if ArrayIterator == undefined do filein (sysInfo.currentDir + "\\iterators 02.ms")

ArrayIterator = undefined
try(destroydialog InspectorGadgetAbout)catch()
rollout InspectorGadgetAbout "Inspector Gadget: About" width:200 height:280
( 
	dotNetControl web "System.Windows.Forms.WebBrowser" height:280 width:200 pos:[0,0]
	
	on InspectorGadgetAbout open do 
(
		local path	= InspectorGadget.scriptPath + "\\assets\\"
		local file	= if is64bitApplication() then "about-64.html" else "about-32.html"
		web.Navigate (path + file)
		web.ScrollBarsEnabled = false
)
) 

try(destroyDialog InspectorGadget);catch()
rollout InspectorGadget "Inspector Gadget" width:400 height:324
(
 

	
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██        ██               ████                   
	--  ██        ██               ██                     
	--  ██ █████ █████ █████ ████  ██   █████ █████ █████ 
	--  ██ ██ ██  ██   ██ ██ ██   █████    ██ ██    ██ ██ 
	--  ██ ██ ██  ██   █████ ██    ██   █████ ██    █████ 
	--  ██ ██ ██  ██   ██    ██    ██   ██ ██ ██    ██    
	--  ██ ██ ██  ████ █████ ██    ██   █████ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Interface
	
		label lblSearch "Search" pos:[113,6] width:36 height:18
		edittext edtSearch "" pos:[148,4] width:152 height:18
		button btnNext ">" pos:[300,4] width:18 height:18
		button btnAbout "About" pos:[324,4] width:72 height:18 toolTip:"Clear treeview"
			
		dotNetControl tv "TreeView" pos:[0,24] width:400 height:280
		
		dropdownList ddlCommands "" pos:[0,304] width:200 height:21
		button btnDdlCommand ">" tooltip:"Re-run dropdown command" pos:[199,305] width:18 height:18
		edittext edtCommand "" pos:[216,304] width:165 height:20
		button btnEdtCommand ">" tooltip:"Run script command" pos:[382,305] width:18 height:18

-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██            ██       ██    ██             
	--  ██  ██                     ██    ██             
	--  ██  ██ █████ ████ ██ █████ █████ ██ █████ █████ 
	--  ██  ██    ██ ██   ██    ██ ██ ██ ██ ██ ██ ██    
	--  ██  ██ █████ ██   ██ █████ ██ ██ ██ █████ █████ 
	--   ████  ██ ██ ██   ██ ██ ██ ██ ██ ██ ██       ██ 
	--    ██   █████ ██   ██ █████ █████ ██ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Variables
	
		local scriptPath	= ""
		local currentNode
		local colors		= DotNetClass "System.Drawing.Color"
		local DUMMY_TEXT	= "<dummy>"
		local add
		
		local commands		= #(
								#("Select...",""),
								#("---------------------------------------------------------------------------------",""),
								#("Objects: Object(s)' properties","$"),
								#("Objects: Single object's children","$.children"),
								#("Arrays: ","Selected object's Modifiers"),
								#("Materials: Selected object's Materials",""),
								#("Materials: Entire material editor",""),
								#("SubAnims: Selected object's Transform",""),
								#("SubAnims: A Position XYZ Controller", ""),
								#("DotNet: This Treeview",""),
								#("DotNet: This Treeview's selected node",""),
								#("DotNet","Available Windows Forms")
							)
	
		local commands		= #(
								#("Select...", ""),
								#("---------------------------------------------------------------------------------", ""),
								#("Objects: Object(s)' properties", "$"),
								#("Objects: Single object's children", "$.children"),
								#("Arrays: Selected object's Modifiers", "$.modifiers"),
								#("Materials: Selected object's Materials", "$.material"),
								#("Materials: Entire material editor", "Meditmaterials"),
								#("SubAnims: Selected object's Transform", "$.transform.controller"),
								#("SubAnims: A Position XYZ Controller", "Position_XYZ()"),
								#("DotNet: This Treeview", "InspectorGadget.tv"),
								#("DotNet: This Treeview's selected node", "InspectorGadget.tv.SelectedNode")
							)

			
								
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██  ██   ██ ██ ██  ██   ██             
	--  ██  ██  ██      ██     ██                  
	--  ██  ██ █████ ██ ██ ██ █████ ██ █████ █████ 
	--  ██  ██  ██   ██ ██ ██  ██   ██ ██ ██ ██    
	--  ██  ██  ██   ██ ██ ██  ██   ██ █████ █████ 
	--  ██  ██  ██   ██ ██ ██  ██   ██ ██       ██ 
	--  ██████  ████ ██ ██ ██  ████ ██ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Utilities

		fn getDotNetMxsExpression node = 
	(
			local dnClass		= (filterstring (node.tag.value as string) ":")[2]
			local dnProperty	= (filterstring node.text ":")[1]
			
			format "%\n" ("(dotNetClass(\"" + dnClass + "\"))." + dnProperty)
	)
		
		fn aboutDialog =
	(
			local pos = Mouse.screenpos - [InspectorGadgetAbout.width / 2, InspectorGadgetAbout.height / 2]
			createdialog InspectorGadgetAbout pos:pos
	)

		
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██                     ██                   ██████       ██ ██ ██                ██          
	--  ██  ██                     ██                   ██           ██ ██ ██                ██          
	--  ██ █████ █████ ████ █████ █████ █████ ████      ██     █████ ██ ██ █████ █████ █████ ██ ██ █████ 
	--  ██  ██   ██ ██ ██      ██  ██   ██ ██ ██        ██        ██ ██ ██ ██ ██    ██ ██    ████  ██    
	--  ██  ██   █████ ██   █████  ██   ██ ██ ██        ██     █████ ██ ██ ██ ██ █████ ██    ███   █████ 
	--  ██  ██   ██    ██   ██ ██  ██   ██ ██ ██        ██     ██ ██ ██ ██ ██ ██ ██ ██ ██    ████     ██ 
	--  ██  ████ █████ ██   █████  ████ █████ ██        ██████ █████ ██ ██ █████ █████ █████ ██ ██ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Iterator Callbacks

		--------------------------------------------------------------------------------------------------------------------------
		-- iterator functions
			
			fn appendArray obj =
		(
				format "adding array: %\n" (obj as string)
				add obj node:currentNode tooltip:"Array"
		)
			
			fn appendChild obj =
		(
				format "adding child: %\n" obj
		)
			
			fn appendObj obj =
		(
				format "adding object: %\n" obj
		)
			
			fn appendProperty obj =
		(
				--format "adding property: %\n" obj
				try
			(
					--local childNode = currentNode.nodes.add (obj.name as string + ": " +obj.value as string)
					--childNode.tag	= dotNetMXSValue obj.object
					add obj.value node:currentNode text:(obj.name as string + ": " +obj.value as string) tooltip:obj.name
			)
				catch
			(
					--format "FAILED!\n"
			)
				--add obj node:currentNode
		)
			
			fn appendSubAnim obj =
		(
				--format "adding subanim: % to % with %\n" obj.name currentNode.text add
				-- check for property or another sub anim
				--format "ANIM: %\n" obj.object
				if isProperty obj "object" AND obj.object.numSubs > 0 then
			(
					add obj node:currentNode text:obj.name --tooltip:obj.value
			)
				else
			(
					try
				(
						add obj node:currentNode text:(obj.name as string + ": " +obj.value as string) tooltip:obj.name
				)
					catch
				(
						add obj node:currentNode text:obj
				)
			)
		)
	
		--------------------------------------------------------------------------------------------------------------------------
		-- iterators
			
			function getIteratorObjects obj =
		(
				-- variables
					local iterator, iteratorFn, iteratorName
				
				-- iterators
				
					-- object: subanims
						if isValidNode obj OR (isProperty obj "numSubs" AND obj.numSubs > 0) then
					(
							iteratorName	= "SubAnimIterator"
							iterator		= SubAnimIterator obj
							iteratorFn		= appendSubAnim
					)
						
					-- selection: objects
						else if classOf obj == ObjectSet then
					(
							iteratorName	= "SelectionIterator"
							iterator		= SelectionIterator obj
							iteratorFn		= appendObj
					)
						
					-- array: elements
						else if 
							classOf obj == Array \
							OR classOf obj == MAXModifierArray \
							OR classOf obj == MaterialLibrary  \
							OR classOf obj == MeditMaterialsClass \
							then
					(
							iteratorName	= "ArrayIterator"
							iterator		= ArrayIterator obj
							iteratorFn		= appendArray
					)
						
					-- default: properties
						else
					(
							iteratorName	= "PropertyIterator"
							iterator		= PropertyIterator obj
							iteratorFn		= appendProperty
					)
					
				-- return
					#(iterator, iteratorFn, iteratorName)
		)

	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██████                    ██   ██                   
	--  ██                        ██                        
	--  ██     ██ ██ █████ █████ █████ ██ █████ █████ █████ 
	--  █████  ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██ ██    
	--  ██     ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██ █████ 
	--  ██     ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██    ██ 
	--  ██     █████ ██ ██ █████  ████ ██ █████ ██ ██ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Functions

		--------------------------------------------------------------------------------------------------------------------------
		-- populate
			
			function populateNode node =
		(
				-- node
					currentNode				= node
				
				-- iterators
					local obj				= node.tag.value
					local iteratorObjects	= getIteratorObjects obj
					local iterator			= iteratorObjects[1]
					local iteratorFn		= iteratorObjects[2]
					local iteratorName		= iteratorObjects[3]
				
				-- debug
					--format "Iterator: %\n" iteratorName
					--format "Populating node: % (%) with %\n" obj (classof obj) iteratorFn

				-- populate
					if iterator != undefined  AND iteratorFn != undefined do
				(
						currentNode.nodes.clear()
						iterator.iterate iteratorFn
				)
		)

			function expandNode node =
		(
				if node.nodes.count > 0 AND node.nodes.item[0].text == DUMMY_TEXT do
			(
					populateNode node
			)
		)
			
			function executeExample index =
		(
				local command = commands[index][2]
					execute ("__obj = " + command)
					add __obj
				try
			(
			)
				catch
			(
					messagebox "The command could not be executed - perhaps you had too many or too few objects selected!?"
			)
		)
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██████          ██       
	--  ██              ██       
	--  ██     █████ █████ █████ 
	--  ██     ██ ██ ██ ██ ██ ██ 
	--  ██     ██ ██ ██ ██ █████ 
	--  ██     ██ ██ ██ ██ ██    
	--  ██████ █████ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Code

		--------------------------------------------------------------------------------------------------------------------------
		-- add objects
			
			function add obj node: text: tooltip: =
		(
				try
			(
					-- parent node
						if node == unsupplied do node = tv
						if text == unsupplied do text = if isProperty obj "name" then obj.name else obj as string
						
					-- iterators
						local iteratorObjects	= getIteratorObjects obj
						local iterator			= iteratorObjects[1]
						
					-- current node
						local childNode			= node.nodes.add text
						childNode.tag			= dotNetMXSValue obj
						if tooltip != unsupplied do
					(
							childNode.ToolTipText = iteratorObjects[3]
					)
					
					-- dummy node
						if iterator.hasNext() do childNode.nodes.add DUMMY_TEXT
						--childNode.expand()
						
					-- debug
						--print (exprformaxobject obj)
						--format "Added node: % \n" obj
						
					-- return
						true
			)
				catch
			(
					format "Couldn't add node: % \n" obj
			)
		)
		
 
		fn initTreeView tv =
	(
			tv.Indent				= 20
			tv.ShowNodeToolTips		= true
			tv.AllowDrop		 	= true
			tv.Name					= "Property Explorer Treeview"
			tv.LabelEdit			= true
			
			local items				= for i = 1 to commands.count where commands[i][1] != "" collect commands[i][1]
			ddlCommands.items		= items
	)

		
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██                ██ ██                  
	--  ██  ██                ██ ██                  
	--  ██  ██ █████ █████ █████ ██ █████ ████ █████ 
	--  ██████    ██ ██ ██ ██ ██ ██ ██ ██ ██   ██    
	--  ██  ██ █████ ██ ██ ██ ██ ██ █████ ██   █████ 
	--  ██  ██ ██ ██ ██ ██ ██ ██ ██ ██    ██      ██ 
	--  ██  ██ █████ ██ ██ █████ ██ █████ ██   █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Handlers

		-- treeview
		
			on tv BeforeExpand evt do
		(
				expandNode evt.node
		)
				
			on tv DoubleClick arg do 
		(
				-- node
					local node		= tv.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
					local parent	= node.parent
					local exprNode	= if node.tag == undefined then parent.tag.value else node.tag.value
					
					node.text = (filterstring node.text ":")[2]
					node.beginEdit();
					
				-- something
					try
				(
						if classof exprNode == dotNetObject then
					(
							add exprNode node:node
					)
						else
					(
							format "%\n" (exprformaxobject exprNode)
					)
						--format "%\n" (classof exprNode)
				)
					catch
				(
						try
					(
							format "%\n" (exprNode.text)
					)
						catch()
				)
		)
			
		-- buttons
			
			on ddlCommands selected index do
		(
				executeExample index
		)
			
		-- rollout
			
			on InspectorGadget resized size do
		(
				local w					= size[1]
				local h					= size[2]
				
				tv.width				= w
				tv.height				= h - 20 - 24
				
				local ctrls				= #(ddlCommands, btnDdlCommand, edtCommand, btnEdtCommand)
				for c in ctrls do
			(
					c.pos = [c.pos[1], h - 20]
			)
				edtCommand.width		= w - edtCommand.pos[1] - 19
				btnDdlCommand.pos	 	= [btnDdlCommand.pos[1], btnDdlCommand.pos[2] + 1]
				btnEdtCommand.pos 		= [w - 18, btnEdtCommand.pos[2] + 1]
				
				if w > btnDdlCommand.pos[1] + 36 then
			(
					btnEdtCommand.pos 	= [w - 18, btnEdtCommand.pos[2]]
			)
				else
			(
					btnEdtCommand.pos 	= [btnDdlCommand.pos[1] + 18, btnEdtCommand.pos[2]]
			)
		)
			
			on btnAbout pressed do aboutDialog()

			on InspectorGadget open do 
		(
				initTreeView tv
				scriptPath = sysinfo.currentdir
		)
)

surrentScript

createDialog InspectorGadget style:#(#style_resizing, #style_minimizebox, #style_maximizebox, #style_titlebar, #style_sysmenu)
IG = InspectorGadget

--getDotNetMxsExpression InspectorGadget.tv.selectedNode

/*

encryptScript "iterators 02.ms"
encryptscript "dotnet treeview 04a.ms"

InspectorGadget.tv.nodes.item[0].nodes.count

showmethods InspectorGadget.tv.nodes.item[0]--.nodes

showEvents InspectorGadget.tv


rNode = InspectorGadget.tv.nodes.add "Instructions"
childNode = rNode.nodes.add "1. To use this utility, simply add items using PropertyExplorer.add someItem"
childNode = rNode.nodes.add "2. You can add anything you like!"

show InspectorGadget.tv.selectedNode

showMethods InspectorGadget.tv

InspectorGadget.tv.selectedNode.FullPath

showmethods InspectorGadget.tv.nodes.item[0]--.nodes

--NOTE that in the case of ActiveX controls, we were using the name 
--displayed by the TreeView node. In the case of DotNet, we are 
--using the actual MAXScript value pointing at the scene object.
--The arg argument provides a .node property containing the node
--that was checked. We use the .tag property to access the 
--DotNetMXSValue stored in the TreeView node and then the .value to
--get the MAXScript value stored in it. Then we set the isHidden
--property of the scene object to the inverse of the checked state 
--of the TreeView node:

on tv AfterCheck arg do 
(
	try
(
		arg.node.tag.value.isHidden = NOT arg.node.checked
)
	catch()
)

InspectorGadget.add ro.pg
*/

