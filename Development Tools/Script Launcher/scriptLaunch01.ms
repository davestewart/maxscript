---------------------------------------------------------------------------------------------------
-- declare globals
---------------------------------------------------------------------------------------------------

rollout ro1 "Scripts" width:160 height:441
(

	local displayItems=#(), scriptDB=#(), height=1
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	button btnGetScript ">" pos:[8,8] width:16 height:16
	edittext edtPathImp "" pos:[24,8] width:128 height:16
	listbox lbxScripts "Scripts" pos:[8,32] width:144 height:19


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn getPathImp =
	(
		try (
			scriptFullPath = getOpenFileName caption:"Select *.ms Script File" types:"Script Files(*.ms)|*.ms" ()
			scriptName = filenameFromPath scriptFullPath as String
	
			edtPathImp.text = scriptName as String
			append displayItems scriptName
			append scriptDB scriptFullPath
			lbxScripts.items = displayItems
		)
		catch ()
	)	

	fn doScript item =
	(
		case ro2.rdoAction.state of
		(
			1:
			(
				try
				(
					fileIn scriptDB[item]
	
				-- Edit Name if script did contains errors, but is now fine
					if substring displayItems[item] 1 2 == "*  " then
						displayItems[item] = substring displayItems[item] 4 displayItems[item].count
					lbxScripts.items = displayItems
	
	
				)
				catch
				(
				-- open item for editing
					edit scriptDB[item]
					--deleteItem displayItems item
					--deleteItem scriptDB item
	
				-- Edit Name if script contains errors
					if substring displayItems[item] 1 3 != "*  " then
						displayItems[item] = "*  " + displayItems[item]
					lbxScripts.items = displayItems
					
				-- Alert!
					messageBox "There appear to be errors in your script, \nso it has been opened for editing..." title:"Possible Script Error"
				)
			)

			2:	edit scriptDB[item]

			3:
			(
				deleteItem displayItems item
				deleteItem scriptDB item
				lbxScripts.items = displayItems
			)
		)
	)



	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btnGetScript pressed do
		getPathImp()
	on lbxScripts selected item do
		doScript(item)
)
rollout ro2 "Script Actions" width:160 height:441
(
	radiobuttons rdoAction "" pos:[8,8] width:108 height:32 labels:#("Run", "Edit", "Delete", "Move") columns:2
)

if scriptRunnerFloater != undefined then closerolloutfloater scriptRunnerFloater
	scriptRunnerFloater = newRolloutFloater "Dev Script Actions" 188 435
addRollout ro1 scriptRunnerFloater
addRollout ro2 scriptRunnerFloater
