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
	
		local rootObject
		local colors = DotNetClass "System.Drawing.Color"
	
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
		
		fn addDummyNode node =
	(
			node.nodes.add "<empty>"
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

		fn addProperties node =
	(
			local property		= node.tag.value
			local props			= getpropnames property
			
			for i = 1 to props.count do
		(
				try
			(
				-- properties
					local propName		= props[i] as string
					local propObject	= property[propName]
					local propClass		= classof prop
					local propValue		= getProperty property propName
				
					local nodeText		= if propValue != undefined then  (propName + ": " +propValue as string+ " (" +propClass as string+ ")" ) else  (propName + " (" +propClass as string+ ")" )
				
				-- new nodes
					newNode				= node.nodes.add nodeText
					
				-- node properties
					try
				(
						newNode.tag			= prop
				)
					catch
				(
						try
					(
							newNode.tag			= dotNetMXSValue prop
					)
						catch
					(
							--newNode.tag			= prop
							format "Could not add property '%:%'\n" property propName
					)
				)
					
				-- add a child node?
					if testForProperties prop do addDummyNode newNode
			)
				catch
			(
			)
					
				-- expand
					node.Expand()
		)
	)
		
		fn add obj =
	(
			print obj
			-- add the node
				local node			= tv.Nodes.add (obj as string)
				node.tag			= dotNetMXSValue obj
				
			-- add any children
				if testForProperties obj do addDummyNode node
				--else if
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
			if node.nodes.item[0].text == "<empty>" do
		(
				try
			(
					node.nodes.clear()
					addProperties node
			)
				catch
			(
					format "Could not add properties to %\n" + (node as string)
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
			if (sel = getObj()) != undefined do add sel
	)
		 
		on btnModifiers pressed do
	(
			if (sel = getObj()) != undefined do add sel
	)
		 
		on btnMaterial pressed do
	(
			if (sel = getObj()) != undefined do add sel.material
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
	)
		
		on roProps open do 
	(
			initTreeView tv 
	)
)

createDialog roProps  style:#(#style_resizing,#style_minimizebox,#style_titlebar,#style_sysmenu,#style_toolwindow)
 

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