try(destroyDialog roProps);catch()

filein "iterators.ms"

rollout roProps "Property Debugger" width:300 height:324
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
	
	dotNetControl tv "TreeView" pos:[0,0] width:300 height:304
	button btnObject "Object" pos:[0,304] width:48 height:20
	button btnModifiers "Modifiers" pos:[48,304] width:48 height:20
	button btnMaterial "Material" pos:[96,304] width:48 height:20
	button btnTransform "Transform" pos:[144,304] width:48 height:20
	
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
	
		local currentNode
		local colors		= DotNetClass "System.Drawing.Color"
		local DUMMY_TEXT	= "<dummy>"
	
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
	
		fn testForProperties obj =
		(
			try
			(
				getPropNames obj
				true
			)
			catch
			(
				false
			)
		)
		
		fn testForArray obj =
		(
			return isKindOf obj Array
		)
		
		fn testForChildren obj =
		(
			return obj.children > 1
		)
		
		fn getObj =
		(
			(getCurrentSelection())[1]
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
		-- add object functions
			
			fn appendArray obj =
			(
				format "adding array: %\n" obj
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
				currentNode.add (obj as string)
				format "adding property: %\n" obj
			)
			
			fn appendSubAnim obj =
			(
				format "adding subanim: % to %\n" obj.name currentNode.text
				try(add obj node:currentNode)
				catch(print "Couldn't add node")
				--show obj
				--local node = currentNode.nodes.add (obj.name as string)
				--add obj currentNode
			)
			
		--------------------------------------------------------------------------------------------------------------------------
		-- add dummy functions
			
			fn appendDummyNode node iterator =
			(
				print iterator
				node.tag		= dotNetMXSValue iterator
				local newNode	= node.nodes.add DUMMY_TEXT
			)
			
			fn hasDummyNode node =
			(
				node.nodes.count > 0 AND node.nodes.item[0].text == DUMMY_TEXT
			)
			
			fn replaceDummyNode node =
			(
				print "Replace node"
				local iterator		= node.tag.value.value
				local iteratorFn	= case (classof iterator) of
				(
					ArrayIterator:		appendArray
					SelectionIterator:	appendObj
					ChildIterator:		appendChild
					PropertyIterator:	appendProperty
					SubAnimIterator:	appendSubAnim

				)
				print #(iterator, iteratorFn, classof iterator)
				currentNode = node
				currentNode.nodes.clear()
				iterator.iterate iteratorFn
			)

		--------------------------------------------------------------------------------------------------------------------------
		-- add node
			
			function appendNode obj =
			(
				-- add the node
					local node			= currentNode.add (obj as string)
					node.tag			= dotNetMXSValue obj
					
				-- add any children
					if testForProperties obj do addDummyNode node
					--else if
			)
			

			function add obj node: =
			(
				-- debug
					print "ADDING NODE: "
				
				-- variables
					local iterator
					if node == unsupplied do node = tv
						
				-- iterators
					-- object: addsubanims obj
						if isValidNode obj then
						(
							currentNode		= node.nodes.add (obj as string)
							iterator		= dotNetMXSValue (SubAnimIterator obj)
							appendDummyNode currentNode iterator
						)
						
					-- selection: iterate over objects and add them
						else if classOf obj == ObjectSet then
						(
							currentNode		= node.nodes.add (obj as string)
							i				= SelectionIterator obj
							i.iterate appendObj
						)
						
					-- array: iterate over elements and add them
						else if classOf obj == Array OR classOf obj == MAXModifierArray then
						(
							currentNode		= node.nodes.add (obj as string)
							i				= ArrayIterator obj
							i.iterate appendArray
						)
						
					-- default: iterate over properties and add them
						else
						(
							currentNode		= node.nodes.add (obj as string)
							i				= PropertyIterator obj
							i.iterate appendProperty
						)
					/*
					*/
						
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

		fn initTreeView tv =
		(
			tv.Indent = 20
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

		on tv BeforeExpand evt do
		(
			local node = evt.node
			if hasDummyNode node do
			(
				try
				(
					replaceDummyNode node
					--node.nodes.clear()
					--addProperties node
				)
				catch
				(
					--format "Could not add properties to %\n" + (node as string)
				)
			)
		)
			
		on tv DoubleClick arg do 
		(
			-- get the node
				local node = tv.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
			
			-- try to select the object stored as value in the .tag
				if node != undefined AND node.nodes.count == 0 do
				(
					try
					(
						addProperties node
					)
					catch
					(
						--print (node as string)
						format "Could not add properties to \n" node.tag.value
					)
				)
			
		)
		
		on btnObject pressed do
		(
			if isValidNode $ do add $
		)
		 
		on btnModifiers pressed do
		(
			if isValidNode $ do add $.modifiers
		)
		 
		on btnMaterial pressed do
		(
			if isValidNode $ do add $.material
		)
		 
		on btnTransform pressed do
		(
			if isValidNode $ do add $.transform.controller
		)
		 
		on roProps resized size do
		(
			local w					= size[1]
			local h					= size[2]
			
			tv.width				= w
			tv.height				= h - 20
			
			btnObject.pos			= [btnObject.pos[1], h - 20]
			btnModifiers.pos		= [btnModifiers.pos[1], h - 20]
			btnMaterial.pos			= [btnMaterial.pos[1], h - 20]
			btnTransform.pos		= [btnTransform.pos[1], h - 20]
		)
		
		on roProps open do 
		(
			initTreeView tv 
		)
)

createDialog roProps  style:#(#style_resizing, #style_minimizebox, #style_titlebar, #style_sysmenu, #style_toolwindow)
 

/*

roProps.tv.nodes.item[0].nodes.count

showmethods roProps.tv.nodes.item[0]--.nodes

showEvents roProps.tv

showmethods roProps.tv.nodes.item[0]--.nodes

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

*/