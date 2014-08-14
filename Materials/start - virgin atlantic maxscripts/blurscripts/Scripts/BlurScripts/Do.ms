-------------------------------------------------------------------------------
-- Do.ms
-- By Neil Blevins (soulburn@blur.com) and Grant Adam (ghra@optushome.com.au)
-- v 2.02
-- Created On: 03/09/00
-- Modified On: 10/30/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to change properties in an object or in a selection of similar 
-- objects or its modifiers.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to change properties in an object or in a selection of similar 
-- objects or its modifiers. If you want to change the property of the base 
-- object, put the property name in the top field. If you want to change a 
-- modifier property, put a check in the modifier checkbox, choose the modifier 
-- Stack Position (1 being the lowest modifier in the stack) and choose the modifier 
-- property to change. The value you want this property to be is the next field, 
-- of if you want a random value for each object, check the random checkbox and 
-- set your high and low values. The names of properties are the same names 
-- you'd use in a maxscript, if you're unsure of the name of the property, 
-- select an object that has that property, turn your macrorecorder on, change 
-- that property, and the property name will appear in the macrorecorder window. 
-- For example, change a sphere's radius, you'll see $.radius = ??? so the 
-- propety name to stick in the field would be the word "radius" without 
-- quotation marks.
--
-- v 1.01 Now instead of by index, it changes properties by modifier name. 
-- Warning, this will now change any modifier in the stack with that name, not
-- just the modifier at a specific index, but that's probably more desirable
-- anyways. Also ui elements now grey out properly when not in use.
--
-- v 1.02 Fixed a bug in which the script would only change the first modifier
-- of any particular name instead of all of them. Now changes all of them,
-- but you now have to use the name of the modifier as it appears in the stack,
-- and the name is case sensitive.
--
-- v 1.03 Added version number to titlebar. And fixed the busted modifier 
-- preset.
--
-- v 1.10 You can now change checkboxes with the script as well as apply values
-- and random values.
--
-- v 1.11 Fixed a bug that would cause the script to give one error message per
-- object selected as opposed to a single error message for all the objects.
--
-- v 1.20 Compatible with R4.0
--
-- v 1.21 Fixed a misnamed variable that was causing the modifier part of the
-- script to never get activated.
--
-- v 1.30 Added an absolute or relative mode.
--
-- v 2.00 Here's where Grant Adam added the following code:
-- 1) auto list of properties
-- 2) auto list of modifiers and modifier properties
-- 3) detection of type of property
-- 4) indication of integer/float
-- 5) gets current first value found and puts that in relevant control
-- However, using this new method, you cannot affect certain object parameters
-- (such as the renderability of objects), so if you still want the old method
-- of manually entering text instead of the dropdown lists, use the script
-- DoClassic.ms.
--
-- v 2.01 Now items in the dropdown lists are ordered alphabetically. Requires
-- BSLib to perform the sorting.
--
-- v 2.02 Renamed "Rebuild Items" "Get Properties" to avoid any confusion
-- on what it does. Did some mild cleaning.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global doit_property
global doit_modifier_property
global rebuildArray
global resetParams
global rebuildModProps
global rebuildModDetect

global do_rollout
global do_floater

global doit_current_property

global doit_propArrayMod = #()
global doit_propArray = #()

global doit_nameArray = #()
global doit_nameArrayMod = #()
global doit_nameArrayModName = #()
global doit_modArrayWhich = #()

global doit_value_type = 1
global doit_do_type = 1

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

do_rlow_value = 1
do_rhigh_value = 100

-- Functions

fn doit_property = 
	(
	undo "Do" on
		(
		for i in selection do
			(
			local the_value
			if doit_value_type == 1 then the_value = do_rollout.propertyvalue.value
			else if doit_value_type == 2 then the_value = do_rollout.c_or_unc.checked
			else if doit_value_type == 3 then the_value = random do_rlow_value do_rhigh_value
			if doit_do_type == 1 then
				(
				try 
					(
					setProperty i doit_current_property the_value
					)
				catch
					(
					MessageBox "Either the property doesn't exist in at least one of your selected objects, or you're trying to assign the wrong kind of value to that property, please try again" title:"Do"
					exit
					)
				)
			else
				(
				try 
					(
					if doit_value_type == 2 then setProperty i doit_current_property the_value
					else 
						(
						old_value = getProperty i doit_current_property
						setProperty i doit_current_property (the_value + old_value)
						)
					)
				catch
					(
					MessageBox "Either the property doesn't exist in at least one of your selected objects, or you're trying to assign the wrong kind of value to that property, please try again" title:"Do"
					exit
					)
				)
			)
		)
	)
	
fn doit_modifier_property =
	(
	local do_stop_called = false
	undo "Do" on
		(
		for i in selection do
			(
			if i.modifiers.count != 0 then
				(
				for j in i.modifiers do
					(
					local the_value
					if doit_value_type == 1 then the_value = do_rollout.propertyvalue.value
					else if doit_value_type == 2 then the_value = do_rollout.c_or_unc.checked
					else if doit_value_type == 3 then the_value = random do_rlow_value do_rhigh_value
					if j.name == do_rollout.modifiername.selected then 
						(
						if doit_do_type == 1 then
							(
							try
								(
								setProperty j do_rollout.modifierpropertytext.selected the_value
								)
							catch
								(
								MessageBox "Either the property doesn't exist in at least one of your selected objects, or you're trying to assign the wrong kind of value to that property, please try again" title:"DoClassic"
								do_stop_called = true
								exit
								)
							)
						else
							(
							try 
								(
								if doit_value_type == 2 then setProperty j do_rollout.modifierpropertytext.selected the_value
								else 
									(
									old_value = getProperty j do_rollout.modifierpropertytext.selected
									setProperty j do_rollout.modifierpropertytext.selected (the_value + old_value)
									)
								)
							catch
								(
								MessageBox "Either the property doesn't exist in at least one of your selected objects, or you're trying to assign the wrong kind of value to that property, please try again" title:"Do"
								do_stop_called = true
								exit
								)
							)
						)
					)
				)
			if do_stop_called == true then exit
			)
		)
	)
	
fn rebuildArray =
	(
	doit_nameArray = #()
	for j in selection do
		(
		doit_propArray = (getpropnames j)
		for i in doit_propArray do
			(
			if finditem doit_nameArray (i as string) == 0 then append doit_nameArray (i as string)
			)
		)
	qsort doit_nameArray compare_case_insensitive
	do_rollout.propertytext.items = doit_nameArray
	do_rollout.propertytext.selection = 1
	doit_current_property = doit_nameArray[1]
	valcls = 0
	valStor = 0
	for i in selection do
		(
		try (valcls = classof (getproperty i doit_current_property);valStor = (getproperty i doit_current_property))
		catch()
		if valcls != 0 then exit -- so exits on first hit
		)
	if valcls == BooleanClass then
		(
		do_rollout.value_type_list.selection = 2
		doit_value_type = 2
		do_rollout.propertyvalue.enabled = false
		do_rollout.propertyint.text = "Boolean"
		do_rollout.c_or_unc.enabled = true
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.c_or_unc.state = valStor 			
		)		
	else if valcls == Float then
		(
		do_rollout.value_type_list.selection = 1
		doit_value_type = 1
		do_rollout.propertyvalue.enabled = true
		do_rollout.propertyint.text = valcls as string
		do_rollout.c_or_unc.enabled = false
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.propertyvalue.value = valStor 		
		)
	else if valcls == Integer then
		(
		do_rollout.value_type_list.selection = 1
		doit_value_type = 1
		do_rollout.propertyvalue.enabled = true
		do_rollout.propertyint.text = valcls as string
		do_rollout.c_or_unc.enabled = false
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.propertyvalue.value = valStor 		
		)
	doit_nameArrayMod = #()
	doit_nameArrayModName = #()
	doit_modArrayWhich = #()
	for j in selection do
		(
		for i in 1 to j.modifiers.count do
			(
			if finditem doit_nameArrayMod (j.modifiers[i].name) == 0 then
				(
				append doit_nameArrayMod j.modifiers[i].name
				append doit_modArrayWhich j.modifiers[i]
				)
			)
		qsort doit_nameArrayMod compare_case_insensitive
		qsort doit_modArrayWhich name_compare_case_insensitive
		do_rollout.modifiername.items = doit_nameArrayMod
		)
	do_rollout.modifiername.selection = 1
	do_rollout.modifierpropertytext.selection = 1
	try
		(
		doit_propArrayMod = (getpropnames doit_modArrayWhich[1])
		for i in doit_propArrayMod do
			(
			append doit_nameArrayModName (i as string)
			)
		qsort doit_nameArrayModName compare_case_insensitive
		do_rollout.modifierpropertytext.items = doit_nameArrayModName
		)
	catch()
	if doit_nameArrayModName.count == 0 then 
		(
		do_rollout.doamodifier.enabled = false
		do_rollout.modifiername.enabled = false
		do_rollout.modifierpropertytext.enabled = false
		do_rollout.doamodifier.checked = false
		do_rollout.propertytext.enabled = true
		) 
	else do_rollout.doamodifier.enabled = true
	)

fn resetParams val = 
	(
	doit_current_property = doit_nameArray[val]
	valcls = 0
	valStor = 0
	for i in selection do
		(
		try (valcls = classof (getproperty i doit_current_property);valStor = (getproperty i doit_current_property))
		catch()
		if valcls != 0 then exit
		)
	if valcls == BooleanClass then
		(
		do_rollout.value_type_list.selection = 2
		doit_value_type = 2
		do_rollout.propertyvalue.enabled = false
		do_rollout.propertyint.text = "Boolean"
		do_rollout.c_or_unc.enabled = true
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.c_or_unc.state = valStor 			
		)		
	else if valcls == Float then
		(
		do_rollout.value_type_list.selection = 1
		doit_value_type = 1
		do_rollout.propertyvalue.enabled = true
		do_rollout.propertyint.text = valcls as string
		do_rollout.c_or_unc.enabled = false
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.propertyvalue.value = valStor 		
		)
	else if valcls == Integer then
		(
		do_rollout.value_type_list.selection = 1
		doit_value_type = 1
		do_rollout.propertyvalue.enabled = true
		do_rollout.propertyint.text = valcls as string
		do_rollout.c_or_unc.enabled = false
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.propertyvalue.value = valStor 		
		)
	)

fn rebuildModProps val val2 = 
	(
	doit_nameArrayModName = #()
	doit_propArrayMod = (getpropnames doit_modArrayWhich[val])
	do_rollout.modifierpropertytext.selection = 1
	for i in doit_propArrayMod do
		(
		append doit_nameArrayModName (i as string)
		)
	do_rollout.modifierpropertytext.items = doit_nameArrayModName
	current_mod = doit_modArrayWhich[val]
	valcls = classof (getproperty current_mod doit_nameArrayModName[val2])
	valStor = (getproperty current_mod  doit_nameArrayModName[val2])
	if valcls == BooleanClass then
		(
		do_rollout.value_type_list.selection = 2
		doit_value_type = 2
		do_rollout.propertyvalue.enabled = false
		do_rollout.propertyint.text = "Boolean"
		do_rollout.c_or_unc.enabled = true
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.c_or_unc.state = valStor 			
		)		
	else if valcls == Float then
		(
		do_rollout.value_type_list.selection = 1
		doit_value_type = 1
		do_rollout.propertyvalue.enabled = true
		do_rollout.propertyint.text = valcls as string
		do_rollout.c_or_unc.enabled = false
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.propertyvalue.value = valStor 		
		)
	else if valcls == Integer then
		(
		do_rollout.value_type_list.selection = 1
		doit_value_type = 1
		do_rollout.propertyvalue.enabled = true
		do_rollout.propertyint.text = valcls as string
		do_rollout.c_or_unc.enabled = false
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.propertyvalue.value = valStor 		
		)
	if doit_nameArrayModName.count == 0 then do_rollout.doamodifier.enabled = false
	else do_rollout.doamodifier.enabled = true
	)

fn rebuildModDetect val val2 =
	(
	current_mod = doit_modArrayWhich[val]
	valcls = classof (getproperty current_mod doit_nameArrayModName[val2])
	valStor = (getproperty current_mod  doit_nameArrayModName[val2])
	if valcls == BooleanClass then
		(
		do_rollout.value_type_list.selection = 2
		doit_value_type = 2
		do_rollout.propertyvalue.enabled = false
		do_rollout.propertyint.text = "Boolean"
		do_rollout.c_or_unc.enabled = true
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.c_or_unc.state = valStor 			
		)		
	else if valcls == Float then
		(
		do_rollout.value_type_list.selection = 1
		doit_value_type = 1
		do_rollout.propertyvalue.enabled = true
		do_rollout.propertyint.text = valcls as string
		do_rollout.c_or_unc.enabled = false
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.propertyvalue.value = valStor 		
		)
	else if valcls == Integer then
		(
		do_rollout.value_type_list.selection = 1
		doit_value_type = 1
		do_rollout.propertyvalue.enabled = true
		do_rollout.propertyint.text = valcls as string
		do_rollout.c_or_unc.enabled = false
		do_rollout.randompropertyvaluelow.enabled = false
		do_rollout.randompropertyvaluehigh.enabled = false
		do_rollout.propertyvalue.value = valStor 		
		)
	if doit_nameArrayModName.count == 0 then do_rollout.doamodifier.enabled = false
	else do_rollout.doamodifier.enabled = true
	)

-- The Script

rollout do_rollout "Do"
	(
	local valStor, valcls

	group "Object Property:"
	(
	dropdownlist propertytext "Property:" fieldWidth:120 align:#right
	button rbld "Get Properties" width:200 align:#center toolTip:"Get Properties"
	)
	
	group "Modifier Property:"
	(
	checkbox doamodifier "Modifier?" align:#left
	dropdownlist modifiername "Modifier Name:" fieldWidth:120 align:#right enabled:false
	dropdownlist modifierpropertytext "Modifier Property:" fieldWidth:120 align:#right enabled:false
	)

	on doamodifier changed state do
		(
		if doamodifier.checked == true then 
			(
			doamodifier_value = 1
			modifiername.enabled = true
			modifierpropertytext.enabled = true
			propertytext.enabled = false
			rebuildModDetect modifiername.selection modifierpropertytext.selection
			)
		else 
			(
			doamodifier_value = 0
			modifiername.enabled = false
			modifierpropertytext.enabled = false
			propertytext.enabled = true
			current_modifier_property = stored_current_modifier_property
			resetParams propertytext.selection
			)
		)

	group "Mode:"
	(
	dropdownlist domode "" items:#("Absolute", "Relative")
	)

	on domode selected i do doit_do_type = i

	group "Value Type:"
	(
	dropdownlist value_type_list "" items:#("Simple Value", "Checkbox", "Random Value")
	label propertydet "Detected:" align:#left across:2
	label propertyint "" align:#right
	)

	group "Simple Value:"
	(
	spinner propertyvalue "Value: " range:[-99999,99999,100] fieldWidth:50 align:#right
	)

	group "Checkbox:"
	(
	label lb1 "Boolean:" across:2 offset:[107,0]
	checkbox c_or_unc "" align:#right enabled:false
	)
	
	on c_or_unc changed state do c_or_unc_value = c_or_unc.checked
	
	group "Random Value:"
	(
	spinner randompropertyvaluelow "Low: " range:[-999999,999999,1] fieldWidth:50 align:#right enabled:false
	spinner randompropertyvaluehigh "High: " range:[-999999,999999,100] fieldWidth:50 align:#right enabled:false
	)
	on value_type_list selected i do 
		(
		if i == 1 then 
			(
			doit_value_type = 1
			propertyvalue.enabled = true
			propertyint.enabled = true
			propertyint.text = ""
			c_or_unc.enabled = false
			randompropertyvaluelow.enabled = false
			randompropertyvaluehigh.enabled = false
			)
		else if i == 2 then 
			(
			doit_value_type = 2
			propertyvalue.enabled = false
			c_or_unc.enabled = true
			c_or_unc_value = true
			randompropertyvaluelow.enabled = false
			randompropertyvaluehigh.enabled = false
			)
		else
			(
			doit_value_type = 3
			propertyvalue.enabled = false
			c_or_unc.enabled = false
			randompropertyvaluelow.enabled = true
			randompropertyvaluehigh.enabled = true
			)
		)

	on randompropertyvaluelow changed val do do_rlow_value = val
	on randompropertyvaluehigh changed val do do_rhigh_value = val

	button doit "Do it!" width:170 align:#center toolTip:"Do It!"
	on doit pressed do 
		(
		if $ == undefined then (MessageBox "Please select at least one object" title:"Do")
		else
			(
			if doamodifier.checked then doit_modifier_property ()
			else doit_property ()
			)
		)

	on do_rollout open do rebuildArray()
	
	on rbld pressed do
		(
		rebuildArray()
		if doamodifier.checked then rebuildModProps modifiername.selection 1 
		)
	
	on propertytext selected val do resetParams val
	on modifiername selected val do	rebuildModProps val 1
	on modifierpropertytext selected val do rebuildModDetect modifiername.selection val
	)

if do_floater != undefined then CloseRolloutFloater do_floater
do_floater = newRolloutFloater "Do v2.02" 265 607
addRollout do_rollout do_floater
)
-------------------------------------------------------------------------------