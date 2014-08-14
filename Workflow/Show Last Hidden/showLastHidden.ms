-- script:	showLastHidden
-- author:	Dave Stewart
-- date:	October 2nd 2006
-- www:		www.davestewart.co.uk/maxscript

-- purpose:	Allows user to show the last set of objects hidden

-- install:	1 - Drop the file in the 3dsMax8/Scripts/Startup directory
--			2 - Go to Customize UI, navigate to Tools > Show Last Hidden
--			3 - Drag to a menu or quad, or asign to a hotkey

-- notes:	Creates a global struct which holds the order objects were hidden, and some functions


--------------------------------------------------------------------------------------------------
-- main struct

	-- struct
		struct showLastHidden
			(
			nodes = #(#())
			,
			fn addNode =
				(
				local obj = callbacks.notificationParam()
				append nodes[nodes.count] obj
				)
			,
			fn showLastHidden =
				(
				
				if nodes.count > 0 then	
					(
					if nodes.count > 1 AND nodes[nodes.count].count == 0 then nodes.count = nodes.count - 1
					unhide nodes[nodes.count]
					nodes.count = nodes.count - 1
					if nodes.count == 0 do nodes = #(#())
					)
				else nodes = #(#())
				)
			,
			fn update =
				(
				if nodes[nodes.count].count > 0 do append nodes (#())
				)
			)
			
	-- instance
		global hiddenList = showLastHidden()
	

--------------------------------------------------------------------------------------------------
-- setup callbacks

	-- remove	
		callbacks.removeScripts id:#addNodeToHiddenList
		callbacks.removeScripts id:#updateHiddenList

	-- add
		callbacks.addScript #nodeHide "hiddenList.addNode()" id:#addNodeToHiddenList
		callbacks.addScript #selectionSetChanged "hiddenList.update()" id:#updateHiddenList
		

--------------------------------------------------------------------------------------------------
-- define macroscript for binding to hotkey, etc

	macroScript showLastHiddenNodes
		category:"Tools" 
		tooltip:"Show Last Hidden Objects" 
		buttontext:"Show Last Hidden" 
		icon: #("ViewportNavigationControls",8)
		(
		if hiddenList == undefined then hiddenList = showLastHidden()
		hiddenList.showLastHidden()
		
		--on isEnabled do hiddenList.nodes[1].count > 0
		)
	
	/*
	print hiddenList.nodes
	hiddenList.addNode()
	hiddenList.update()
	hiddenList.showLastHidden()
	*/
	
	
	