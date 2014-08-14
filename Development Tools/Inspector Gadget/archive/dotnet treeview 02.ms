try(destroyDialog roProps)
catch()

rollout roProps "Property Debugger"
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
	
		dotNetControl tv "TreeView" width: 190 height:290 align:#center
		spinner spnIndent "Indentation" range:[0,100,20] type:#integer fieldwidth:40

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
	
		fn debugProperty property =
	(
			local props = getpropnames property
			for i = 1 to props.count do
		(
				-- properties
					local propName		= props[i] as string
					local prop			= getproperty property propName
					local propClass		= classof prop
					
				-- output
					format ".% (%)\n----------------------------------------------------------------\n" propName propClass
					try
				(
						getPropNames prop
						show prop
				)
					catch
				(
						format "  %\n" prop
				)
					format "\n"
		)
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

		fn addChildren theNode theChildren =
	(
			for c in theChildren do
		(
			newNode			= theNode.Nodes.add c.name --add to the parent!
			newNode.tag		= dotNetMXSValue c --.tag can contain a MXS value
			addChildren newNode c.children --recursive call for new node
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

		fn initTreeView tv =
	(
			tv.Indent = 20
	)

		fn populateTreeView tv =
	(
			theRoot			= tv.Nodes.add "Scene"
			rootNodes		= for o in objects where o.parent == undefined collect o
			addChildren theRoot rootNodes
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

		on tv Click arg do 
	(
			-- First get the TreeView node below the mouse cursor
			-- The arg argument has properties .x and .y with the current pos.
			-- Use showProperties arg to see what is available...
			-- We use the TreeView method GetNodeAt to see what was clicked:
			
				local node = tv.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
			
			-- try to select the object stored as value in the .tag
			
				if node != undefined do
			(
					try
				(
						select node.tag.value
				)
					catch
				(
						max select none
				)
			)
			
	)
		 
		on spnIndent changed val do tv.indent = val
		 
		on roProps open do 
	(
			initTreeView tv 
			populateTreeView tv
	)
)

createDialog roProps 200 320
 

/*



showEvents 


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