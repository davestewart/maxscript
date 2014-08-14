---------------------------------------------------------------------------------------------------
-- declare globals
---------------------------------------------------------------------------------------------------
global roScriptDevScripts, roScriptDevActions 

rollout roScriptDevScripts "Scripts" width:272 height:441
(

	local displayItems=#(), scriptDB=#(), height=1, scriptFullPath, deleteScript 
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	button btnGetScript ">" pos:[8,8] width:16 height:16
	edittext edtPathImp "" pos:[24,8] width:240 height:16
	listbox lbxScripts "Scripts" pos:[8,32] width:256 height:19
	button btn2 "Replace with full directory contents" pos:[8,312] width:256 height:16


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn getPathImp =
		(
		try (
			scriptFullPath = getOpenFileName caption:"Select *.ms Script File" types:"Script Files(*.ms)|*.ms" ()
			scriptName = filenameFromPath scriptFullPath as String
	
			append displayItems ("   " + scriptName)
			append scriptDB scriptFullPath

			edtPathImp.text = getFilenamePath scriptFullPath
			lbxScripts.items = displayItems
			)
		catch ()
		)	


	fn editScript item =
		(
		edit scriptDB[item]
		roScriptDevActions.grpStatus.text = "Status: OK"
		roScriptDevActions.lblStatus.text = "Editing Script"
		)

	fn deleteScript item =
		(
		deleteItem displayItems item
		deleteItem scriptDB item
		lbxScripts.items = displayItems

		roScriptDevActions.grpStatus.text = "Status: OK"
		roScriptDevActions.lblStatus.text = "Script Removed"

		)


	fn runScript item = 
		(
		try
			(
			fileIn scriptDB[item]

			-- Edit Name if script did contains errors, but is now fine

				if substring displayItems[item] 1 3 == "*  " then
					displayItems[item] = "   " + substring displayItems[item] 4 displayItems[item].count
				lbxScripts.items = displayItems

				roScriptDevActions.grpStatus.text = "Status:"
				roScriptDevActions.lblStatus.text = "Script OK"

			)

		catch
			(
			-- Edit Name as script contains errors
				if substring displayItems[item] 1 3 != "*  " then
					displayItems[item] = "*  " + displayItems[item]
				lbxScripts.items = displayItems


			-- Take action
				case roScriptDevActions.rdoError.state of
					(
					1:
						(
						-- do nothing
							roScriptDevActions.grpStatus.text = "Status: ERROR"
							roScriptDevActions.lblStatus.text = "Halting Script"
						)
	
					2:
						(
						-- edit script
							edit scriptDB[item]
							roScriptDevActions.grpStatus.text = "Status: ERROR"
							roScriptDevActions.lblStatus.text = "Editing Script"
	
						)
					3: 
						(
						-- delete script
							deleteScript item
						)
					)
			)
		)


	fn doAction item clicks =
		(
	 -- check for doubleclick and that user is in delete mode...
		if clicks == 2 AND roScriptDevActions.rdoAction.state == 3 then deleteScript item
		else -- if user single clicked...
			(
			case roScriptDevActions.rdoAction.state of
				(
				1: runScript item
				2: editScript item
				--3: deleteScript item
				4: messageBox "Script: Moving"
				)
			)
		)

	fn SearchDir =
		(
		-- clear arrays
			displayItems =#()
			scriptDB =#()
		
		-- put new files into arrays		
			files = getFiles ((getFilenamePath scriptFullPath as String) + "*.ms")
			for f in files do
				(
				append displayItems ("   " + filenameFromPath f as String)
				append scriptDB f
				)
			lbxScripts.items = displayItems
		)
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	
	on btnGetScript pressed do
		getPathImp()
	on lbxScripts selected item do
		doAction item 1
	on lbxScripts doubleClicked item do
		doAction item 2
	on btn2 pressed do
		searchDir()
)


rollout roScriptDevActions "Actions" width:272 height:300
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	GroupBox grpAction "Action" pos:[8,8] width:256 height:40
	radiobuttons rdoAction "" pos:[16,24] width:229 height:16 labels:#("Run ", "Edit", "Delete  ", "Move") columns:4

	GroupBox grpError "On error:" pos:[8,48] width:256 height:40
	radiobuttons rdoError "" pos:[16,64] width:240 height:16 labels:#("Stop", "Edit", "Delete  ") columns:4

	GroupBox grpStatus "Status" pos:[8,96] width:256 height:36
	label lblStatus "OK" pos:[16,112] width:240 height:16

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn rdoActionTextUpdate state =
		(
		case state of
			(
			1: lblStatus.text="User: Click item to Run."
			2: lblStatus.text="User: Click item to Edit only."
			3: lblStatus.text="User: Dbl-click item to Delete."
			4: lblStatus.text="User: Click item to Keep."
			)

		if state == 1 then (rdoError.enabled = true; grpError.enabled = true)
		else (rdoError.enabled = false; grpError.enabled = false)
		)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on roScriptDevActions open do
		rdoActionTextUpdate 1
	on rdoAction changed state do
		rdoActionTextUpdate state
)

if scriptRunnerFloater != undefined then closerolloutfloater scriptRunnerFloater
	scriptRunnerFloater = newRolloutFloater "Dev Script Actions" 300 598
addRollout roScriptDevScripts scriptRunnerFloater
addRollout roScriptDevActions scriptRunnerFloater
