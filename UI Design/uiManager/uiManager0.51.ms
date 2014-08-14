-------------------------------------------------------------------------------------------------------------------------------
-- 
-- UI Manager
-- A struct containing methods to save and load rollout settings, such as size, position, control states, items, etc 
-- to a preferences file, as well as methods to accomplish UI control tasks for example keeping one spinner higher or lower 
-- than another when editing ranges.
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
-- date:		1st May 2008
-- max version:	not sure, probably all
/*
-- updates:		0.5		- created
				0.51	- added floater functions
*/
-------------------------------------------------------------------------------------------------------------------------------

struct uiManager
(
	------------------------------------------------------------------------------------------------------
	-- properties
	------------------------------------------------------------------------------------------------------
	
		dialog			= undefined,
		inifile			= "",
		position		= [0,0],
		size			= [0,0],
		type			= "",
		
		loadPosition	= undefined,
		loadSize		= undefined,

	------------------------------------------------------------------------------------------------------
	-- ini settings
	------------------------------------------------------------------------------------------------------

		function saveSetting section key value =
		(
			setinisetting inifile section key (value as string)
			),
			
		function loadSetting section key =
		(
			getinisetting inifile section key
			),

			
	------------------------------------------------------------------------------------------------------
	-- dialog functions
	------------------------------------------------------------------------------------------------------
	
		function savePosition =
		(
			saveSetting "dialog settings" "position" (getDialogPos dialog)
			),
			
		function loadPosition =
		(
			local pos = execute (loadSetting "dialog settings" "position")
			if classof pos == Point2 do setDialogPos dialog pos
			position = getDialogPos dialog
			),
			
		function saveSize =
		(
			saveSetting "dialog settings" "size" (getDialogSize dialog)
			),
			
		function loadSize =
		(
			local size = execute (loadSetting "dialog settings" "size")
			if classof size == Point2 do setDialogSize dialog size
			size = getDialogSize dialog
			),
			
	------------------------------------------------------------------------------------------------------
	-- floater rollout functions
	------------------------------------------------------------------------------------------------------

		function autoSizeFloater floater =
		(
			local height = 0
			for ro in floater.rollouts do height += if ro.open == false then 22 else ro.height + 25
			floater.size = [floater.size[1],height + 1]
			),
		
		function toggleRollout floater test rollouts: =
		(
			if rollouts == unsupplied do rollouts = floater.rollouts
			if classof test == Integer then for i = 1 to rollouts.count do rollouts[i].open = i == test
			else if classof test == Array then for i = 1 to rollouts.count do rollouts[i].open = finditem test i > 0
			else if classof test == RolloutClass then for i = 1 to rollouts.count do rollouts[i].open = rollouts[i] == test
			),
			
		function loadRolloutStates =
		(
			),
			
		function saveRolloutStates =
		(
			),
			
	------------------------------------------------------------------------------------------------------
	-- control functions
	------------------------------------------------------------------------------------------------------
	
		function updateSpinnerPair spn1 spn2 index offset:1 =
		(
			if index == 1 then if spn1.value >= spn2.value do spn2.value = spn1.value + offset
			else if spn2.value <= spn1.value do spn1.value = spn2.value - offset
			),
			
		function getValue c =
		(
			),

		function setValue c value =
		(
			),

	------------------------------------------------------------------------------------------------------
	-- preference functions
	------------------------------------------------------------------------------------------------------
	
		function saveValue c =
		(
			local value = case (classof c) of
			(
				ButtonControl:		c.text
				CheckButtonControl:	c.checked
				ComboBoxControl:	c.selection
				EditTextControl:	c.text
				GroupBoxControl:	c.text
				LabelControl:		c.text
				ProgressBar:		c.value
				SpinnerControl:		c.range
			)
			saveSetting "control values" c.name value
			),
			
		function loadValue c =
		(
			local value = loadSetting "control values" c.name
			if value == undefined do return false
			
			case (classof c) of
			(
				ButtonControl:		c.text			= value
				CheckButtonControl:	c.checked		= if value == "true" then true else false
				ComboBoxControl:	c.selection		= value as integer
				EditTextControl:	c.text			= value
				GroupBoxControl:	c.text			= value
				LabelControl:		c.text			= value
				ProgressBar:		c.value			= value as integer
				SpinnerControl:		c.range			= if value != "" then execute value else c.range
			)
			),
			
		function saveAllValues =
		(
			for c in dialog.controls do saveValue c
			),

		function loadAllValues =
		(
			for c in dialog.controls do loadValue c
			),

	------------------------------------------------------------------------------------------------------
	-- initialization functions
	------------------------------------------------------------------------------------------------------
	
		function initialize d =
		(
			dialog		= d
			inifile		= getdir #plugcfg + "\\" + d.title + ".ini"
			loadPosition()
			loadSize()
			),
			
		function deinitialize =
		(
			savePosition()
			saveSize()
		)
			
)


-------------------------------------------------------------------------------------------------------------------------------
-- Code examples
-------------------------------------------------------------------------------------------------------------------------------
/*

rollout roTools "Tools" width:100 height:50
(
	-- interface
		spinner spn1 "Start" range:[1,100,20] type:#integer fieldwidth:30 align:#right
		spinner spn2 "End" range:[1,100,80] type:#integer fieldwidth:30 align:#right

	-- reference to the local UI Manager
		local ui

	-- handlers
		on roTools open do
		(
			-- initialize the UI manager upon on opening the rollout
			-- this will create a file named after the rollout (Tools.ini) if it doesn't exist
			-- or will simply reference the file if it does exist
				ui = uiManager()
				ui.initialize roTools

			-- load all previously saved values
				ui.loadAllValues()

			-- load previously saved position
				ui.loadPosition()
		)

		on roTools close do
		(
			-- save all control values
				ui.saveAllValues()

			-- save rollout position
				ui.savePosition()
		)

	-- handlers
		-- this spinner pair are instructed to update when each other's vales are changed.
		-- this is useful for low and high values, such as frame ranges
			on spn1 changed val do ui.updateSpinnerPair spn1 spn2 1
			on spn2 changed val do ui.updateSpinnerPair spn1 spn2 2

)

createdialog roTools
*/
