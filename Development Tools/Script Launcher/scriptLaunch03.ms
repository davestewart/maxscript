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

	fn runScript item editScript= 
		(
		try
			(
			fileIn scriptDB[item]

			-- Edit Name if script did contains errors, but is now fine

				if substring displayItems[item] 1 2 == "*  " then
					displayItems[item] = substring displayItems[item] 4 displayItems[item].count
				lbxScripts.items = displayItems

			ro2.lblStatus.text = "Script OK"

			)

		catch
			(
			if editScript==true then
				(
				-- open item for editing
					edit scriptDB[item]
		
				-- Edit Name if script contains errors
					if substring displayItems[item] 1 3 != "*  " then
						displayItems[item] = "*  " + displayItems[item]
					lbxScripts.items = displayItems

					
				-- Alert!
					-- messageBox "There appear to be errors in your script, \nso it has been opened for editing..." title:"Possible Script Error"
				ro2.lblStatus.text = "Script Error: Editing"

				)
			else ro2.lblStatus.text = "Script Error: Stopping"
			)
		)


	fn editScript item =
		(
		edit scriptDB[item]
		ro2.lblStatus.text = "Script: Editing"
		)

	fn deleteScript item =
		(
		deleteItem displayItems item
		deleteItem scriptDB item
		lbxScripts.items = displayItems

		ro2.lblStatus.text = "Script: Removed"
		)

	fn doAction item clicks =
		(
		if clicks == 2 AND ro2.rdoAction.state == 4 then deleteScript item -- if user is in delete mode and doubleclicked...
		else -- if user single clicked...
			(
			case ro2.rdoAction.state of
				(
				1: runScript item false
				2: runScript item true
				3: editScript item
				5: messageBox "Script: Moving"
				)
			)
		)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btnGetScript pressed do getPathImp()
	on lbxScripts selected item do doAction item 1
	on lbxScripts doubleClicked item do	doAction item 2
	
)


rollout ro2 "Action" width:160 height:300
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	GroupBox grpAction "Action" pos:[8,8] width:144 height:104
	radiobuttons rdoAction "" pos:[16,24] width:108 height:80 labels:#("Run", "Run (Edit if Errors)", "Edit", "Delete (dbl-click)", "Move") columns:1
	GroupBox grp1 "Status" pos:[8,120] width:144 height:36
	label lblStatus "OK" pos:[16,136] width:128 height:16

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

)

if scriptRunnerFloater != undefined then closerolloutfloater scriptRunnerFloater
	scriptRunnerFloater = newRolloutFloater "Dev Script Actions" 188 550
addRollout ro1 scriptRunnerFloater
addRollout ro2 scriptRunnerFloater
