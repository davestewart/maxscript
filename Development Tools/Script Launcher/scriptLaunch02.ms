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


	fn runScript item = 
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

	fn editScript item =
	(
		edit scriptDB[item]
	)

	fn deleteScript item =
	(
		deleteItem displayItems item
		deleteItem scriptDB item
		lbxScripts.items = displayItems
	)

	fn doAction item clicks =
	(
		if clicks == 2 AND ro2.rdoAction.state == 3 then deleteScript item -- if user is in delete mode and doubleclicked...
		else -- if user single clicked...
		(
			case ro2.rdoAction.state of
			(
				1: runScript item
				2: editScript item
				4: message
			)
		)
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btnGetScript pressed do
		getPathImp()
	on lbxScripts selected item do doAction item 1
	on lbxScripts doubleClicked item do	doAction item 2
	
)


rollout ro2 "Script Actions" width:160 height:441
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	radiobuttons rdoAction "" pos:[8,8] width:108 height:32 labels:#("Run", "Edit", "Delete", "Keep") columns:2
	label lblPrompt "" pos:[8,48] width:144 height:16

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn rdoActionTextUpdate state =
	(
		case state of
		(
			1: lblPrompt.text="User: Click item to Run."
			2: lblPrompt.text="User: Click item to Edit only."
			3: lblPrompt.text="User: Dbl-click item to Delete."
			4: lblPrompt.text="User: Click item to Keep."
		)
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on rdoAction changed state do rdoActionTextUpdate state
	on ro2 open do rdoActionTextUpdate 1
)

if scriptRunnerFloater != undefined then closerolloutfloater scriptRunnerFloater
	scriptRunnerFloater = newRolloutFloater "Dev Script Actions" 188 460
addRollout ro1 scriptRunnerFloater
addRollout ro2 scriptRunnerFloater
