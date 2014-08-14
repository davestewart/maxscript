rollout treeview_rollout "TreeView Scene Browser"
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
		spinner spn_indent "Indentation" range:[0,100,28] type:#integer fieldwidth:40

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
			newNode = theNode.Nodes.add c.name --add to the parent!
			newNode.tag = dotNetMXSValue c --.tag can contain a MXS value
			addChildren newNode c.children --recursive call for new node
		)
	)
	 
		fn fillInTreeView tv =
	(
			theRoot = tv.Nodes.add "WORLD ROOT" --add parent node
			rootNodes = for o in objects where o.parent == undefined collect o
			addChildren theRoot rootNodes --no need to pass the TreeView
	)

		fn initTreeView tv =
	(
			tv.Indent= 20 --property name is different and value is in pixels
			--the default style already has root lines.
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
			--First get the TreeView node below the mouse cursor
			--The arg argument has properties .x and .y with the current pos.
			--Use showProperties arg to see what is available...
			--We use the TreeView method GetNodeAt to see what was clicked:
			
			hitNode = tv.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
			if hitNode != undefined do --if a TreeView node was clicked,
			try(select hitNode.tag.value)
			catch(max select none) 
			
			--...we try to select the object stored as value in the .tag
	)
		 
		on spn_indent changed val do tv.indent = val
		 
		on treeview_rollout open do 
	(
			initTreeView tv 
			fillInTreeView tv
	)
)
 
try(destroyDialog treeview_rollout)catch()
createDialog treeview_rollout 200 320
)
 
