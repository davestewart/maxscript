-- script:	showLastHidden
-- author:	dave stewart
-- date:	October 2nd 2006
-- www:		www.davestewart.co.uk/maxscript

-- purpose:	Allows user to show the last set of objects hidden
-- notes:	Creates a global list of the order objects were hidden
-- install:	Drop the file in the UI/MacroScripts directory, go to Customize UI, navigate to Tools and drag to a menu / quad / hotkey


--------------------------------------------------------------------------------------------------
-- main struct

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
				select nodes[nodes.count]
				nodes.count = nodes.count - 1
				if nodes.count == 0 then nodes = #(#())
			)
			else nodes = #(#())
		)
		,
		fn update =
		(
			print "Making empty slot"
			if nodes[nodes.count].count > 0 then append nodes (#())
		)
	)
	
--------------------------------------------------------------------------------------------------
-- instantiate instance

	global hiddenList = showLastHidden()
	
--------------------------------------------------------------------------------------------------
-- setup callbacks

	-- remove	
		callbacks.removeScripts id:#addNodeToHiddenList
		callbacks.removeScripts id:#updateHiddenList

	-- add
		callbacks.addScript #nodeHide "hiddenList.addNode()" id:#addNodeToHiddenList
		callbacks.addScript #selectionSetChanged "hiddenList.update()" id:#updateHiddenList
		
unhide $sphere*
print hiddenList.nodes
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
	)
	
	/*
	print hiddenList.nodes
	hiddenList.addNode()
	hiddenList.update()
	hiddenList.showLastHidden()
	*/
	
	
	