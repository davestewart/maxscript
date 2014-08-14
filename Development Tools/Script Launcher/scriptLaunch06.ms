---------------------------------------------------------------------------------------------------
-- declare globals
---------------------------------------------------------------------------------------------------
global roScriptDevScripts, roScriptDevActions, roScriptDevFav

rollout roScriptDevScripts "Script Organiser" width:272 height:441
(
	---------------------------------------------------------------------------------------------------
	-- declare locals
	---------------------------------------------------------------------------------------------------

	local initDisplayItems=#(), initScriptDB=#(), height=1, scriptFullPath


	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	button btnGetScript ">" pos:[8,8] width:16 height:16
	edittext edtPathImp "" pos:[24,8] width:240 height:16
	listbox lbxScripts "Scripts" pos:[8,32] width:256 height:19
	button btn2 "Get All in Directory" pos:[8,312] width:256 height:16


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn getPathImp =
		(
		try (
			scriptFullPath = getOpenFileName caption:"Select *.ms Script File" types:"Script Files(*.ms)|*.ms" ()
			scriptName = filenameFromPath scriptFullPath as String
	
			append initDisplayItems scriptName
			append initScriptDB scriptFullPath

			edtPathImp.text = getFilenamePath scriptFullPath
			lbxScripts.items = initDisplayItems
			)
		catch ()
		)	


	fn editScript item =
		(
		edit initScriptDB[item]
		roScriptDevActions.grpStatus.text = "Info: OK"
		roScriptDevActions.lblStatus.text = "Editing Script"
		)

	fn deleteScript item =
		(
		deleteItem initDisplayItems item
		deleteItem initScriptDB item
		lbxScripts.items = initDisplayItems

		roScriptDevActions.grpStatus.text = "Info: OK"
		roScriptDevActions.lblStatus.text = "Script Removed"

		)

	fn moveScript item =
		(
		targetRO = roScriptDevActions.ddlMoveTo.selected as String

		append (execute(targetRO + ".favScriptDB")) initScriptDB[item]
		append (execute(targetRO + ".favDisplayItems")) initDisplayItems[item]



		roScriptDevFav.lbxScripts.items = roScriptDevFav.favDisplayItems
		
		deleteScript item
		)

	fn runScript item = 
		(
		try
			(
			fileIn initScriptDB[item]

			-- Edit Name if script did contains errors, but is now fine

				if substring initDisplayItems[item] 1 3 == "*  " then
					initDisplayItems[item] = substring initDisplayItems[item] 4 initDisplayItems[item].count
				lbxScripts.items = initDisplayItems

				roScriptDevActions.grpStatus.text = "Status:"
				roScriptDevActions.lblStatus.text = "Script OK"

			)

		catch
			(
			-- Edit Name as script contains errors
				if substring initDisplayItems[item] 1 3 != "*  " then
					initDisplayItems[item] = "*  " + initDisplayItems[item]
				lbxScripts.items = initDisplayItems


			-- Take action
				case roScriptDevActions.rdoError.state of
					(
					1:
						(
						-- do nothing
							roScriptDevActions.grpStatus.text = "Info: ERROR"
							roScriptDevActions.lblStatus.text = "Halting Script"
						)
	
					2:
						(
						-- edit script
							edit initScriptDB[item]
							roScriptDevActions.grpStatus.text = "Info: ERROR"
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
		if clicks == 2 AND roScriptDevActions.rdoAction.state == 3 then deleteScript item -- if user is in delete mode and doubleclicked...
		else -- if user single clicked...
			(
			case roScriptDevActions.rdoAction.state of
				(
				1: runScript item
				2: editScript item
				4: moveScript item
				)
			)
		)


	fn SearchDir =
		(

		-- clear arrays
			initDisplayItems =#()
			initScriptDB =#()

		files = getFiles ((getFilenamePath scriptFullPath as String) + "*.ms")
		for f in files do
			(
			append initDisplayItems (filenameFromPath f as String)
			append initScriptDB f
			)
		lbxScripts.items = initDisplayItems
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
	radiobuttons rdoAction "" pos:[16,24] width:233 height:16 labels:#("Run", "Edit", "Delete", "Move") columns:4 align:#center

	GroupBox grpError "On error:" pos:[8,48] width:256 height:40
	radiobuttons rdoError "" pos:[16,64] width:240 height:16 labels:#("Stop", "Edit", "Delete  ") columns:4

	GroupBox grpStatus "Info: " pos:[8,96] width:256 height:36
	label lblStatus "OK" pos:[16,112] width:240 height:16

	dropDownList ddlMoveTo "" pos:[130,61] width:128 height:21 items:#("roScriptDevFav","Modelling","Doods")
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

rollout roScriptDevFav "Favourites" width:272 height:300
(
	---------------------------------------------------------------------------------------------------
	-- declare locals
	---------------------------------------------------------------------------------------------------

	local favDisplayItems=#(), favScriptDB=#()

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	listbox lbxScripts "" width:256 height:10
	radiobuttons rdoAction "" width:229 height:16 align:#centre labels:#("Run ", "Edit", "Delete") columns:3


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
	on lbxScripts selected item do fileIn favScriptDB[item]


)

if scriptRunnerFloater != undefined then closerolloutfloater scriptRunnerFloater
	scriptRunnerFloater = newRolloutFloater "Dev Script Actions" 300 598
addRollout roScriptDevScripts scriptRunnerFloater
addRollout roScriptDevActions scriptRunnerFloater
addRollout roScriptDevFav scriptRunnerFloater
