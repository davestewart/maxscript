-------------------------------------------------------------------------------
-- DoClassic.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 03/16/01
-- Modified On: 03/16/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to change properties in an object or in a selection of similar 
-- objects or its modifiers. This script was originally called Do.ms, Do.ms now
-- has dropdown list of paramaters instead of the manual textfield. However, 
-- the dropdown method doesn't work for every paramater that can still be 
-- affected by manually entering text, so if there's a parameter you wish to 
-- change and Do does not access it, use DoClassic.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- If you want to change the property of the base object, put the property name 
-- in the top field. If you want to change a modifier property, put a check in 
-- the modifier checkbox, choose the modifier name you want changed, and choose 
-- the modifier property to change. The value you want this property to be is the 
-- next field, of if you want a random value for each object, check the random 
-- checkbox and set your high and low values. The names of properties are the 
-- same names you'd use in a maxscript, if you're unsure of the name of the 
-- property, select an object that has that property, turn your macrorecorder on, 
-- change that property, and the property name will appear in the macrorecorder 
-- window. For example, change a sphere's radius, you'll see $.radius = ??? so 
-- the propety name to stick in the field would be the word "radius" without 
-- quotation marks.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global doc_property
global doc_modifier_property

global doc_rollout
global doc_floater

-- Variables

doc_current_property = "radius"
doc_doamodifier_value = 0
doc_current_modifier_name = "Bend"
doc_current_modifier_property = "angle"
doc_stored_current_modifier_property = "angle"

doc_value_type = 1
doc_do_type = 1

doc_current_value = 100
doc_c_or_unc_value = false
doc_rlow_value = 1
doc_rhigh_value = 100

-- Functions

fn doc_property = 
(
	undo "Do" on
	(
		for i in selection do
		(
			local the_value
			if doc_value_type == 1 then the_value = doc_current_value
			else if doc_value_type == 2 then the_value = doc_c_or_unc_value
			else if doc_value_type == 3 then the_value = random doc_rlow_value doc_rhigh_value
			if doc_do_type == 1 then
			(
				try 
				(
					setProperty i doc_current_property the_value
				)
				catch
				(
					MessageBox "Either the property doesn't exist in at least one of your selected objects, or you're trying to assign the wrong kind of value to that property, please try again" title:"DoClassic"
					exit
				)
			)
			else
			(
				try 
				(
					if doc_value_type == 2 then setProperty i doc_current_property the_value
						else 
					(
						old_value = getProperty i doc_current_property
						setProperty i doc_current_property (the_value + old_value)
					)
				)
				catch
				(
					MessageBox "Either the property doesn't exist in at least one of your selected objects, or you're trying to assign the wrong kind of value to that property, please try again" title:"DoClassic"
					exit
				)
			)
		)
	)
)


fn doc_modifier_property =
(
	local doc_stop_called = false
	undo "Do" on
	(
		for i in selection do
		(
			if i.modifiers.count != 0 then
			(
				for j in i.modifiers do
				(
					local the_value
					if doc_value_type == 1 then the_value = doc_current_value
					else if doc_value_type == 2 then the_value = doc_c_or_unc_value
					else if doc_value_type == 3 then the_value = random doc_rlow_value doc_rhigh_value
					if j.name == doc_current_modifier_name then 
					(
						if doc_do_type == 1 then
						(
							try
							(
								setProperty j doc_current_modifier_property the_value
							)
							catch
							(
								MessageBox "Either the property doesn't exist in at least one of your selected objects, or you're trying to assign the wrong kind of value to that property, please try again" title:"DoClassic"
								doc_stop_called = true
								exit
							)
						)
						else
						(
							try
							(
								if doc_value_type == 2 then setProperty j doc_current_modifier_property the_value
								else 
								(
									old_value = getProperty j doc_current_modifier_property
									setProperty j doc_current_modifier_property (the_value + old_value)
								)
							)
							catch
							(
								MessageBox "Either the property doesn't exist in at least one of your selected objects, or you're trying to assign the wrong kind of value to that property, please try again" title:"DoClassic"
								doc_stop_called = true
								exit
							)
						)
					)
				)
			)
			if doc_stop_called == true then exit	
		)
	)
)

-- The Script

rollout doc_rollout "DoClassic"
(
	group "Object Property:"
(
	edittext propertytext "Property:" fieldWidth:120 text:"radius" align:#right
)

	on propertytext changed text do doc_current_property = propertytext.text

	group "Modifier Property:"
(
	checkbox doamodifier "Modifier?" align:#left
	edittext modifiername "* Modifier Name:" fieldWidth:120 text:"Bend" align:#right enabled:false
	edittext modifierpropertytext "Modifier Property:" fieldWidth:120 text:"angle" align:#right enabled:false
)

	on doamodifier changed state do
	(
		if doamodifier.checked == true then 
		(
			doc_doamodifier_value = 1
			modifiername.enabled = true
			modifierpropertytext.enabled = true
			propertytext.enabled = false
		)
		else 
		(
			doc_doamodifier_value = 0
			modifiername.enabled = false
			modifierpropertytext.enabled = false
			propertytext.enabled = true
			doc_current_modifier_property = doc_stored_current_modifier_property
		)
	)
	on modifiername changed text do 
	(
		doc_current_modifier_name = modifiername.text
	)
	on modifierpropertytext changed text do 
	(
		doc_current_modifier_property = modifierpropertytext.text
		doc_stored_current_modifier_property = modifierpropertytext.text
	)

	group "Mode:"
(
	dropdownlist domode "" items:#("Absolute", "Relative")
)

	on domode selected i do doc_do_type = i

	group "Value Type:"
(
	dropdownlist doc_value_type_list "" items:#("Simple Value", "Checkbox", "Random Value")
)

	group "Simple Value:"
(
	spinner propertyvalue "Value: " range:[-99999,99999,100] fieldWidth:50 align:#right
)

	on propertyvalue changed val do doc_current_value = val

	group "Checkbox:"
(
	label lb1 "Boolean:" across:2 offset:[107,0]
	checkbox c_or_unc "" align:#right enabled:false
)
	
	group "Random Value:"
(
	spinner randompropertyvaluelow "Low: " range:[-999999,999999,1] fieldWidth:50 align:#right enabled:false
	spinner randompropertyvaluehigh "High: " range:[-999999,999999,100] fieldWidth:50 align:#right enabled:false
)

	on doc_value_type_list selected i do 
	(
		if i == 1 then 
		(
			doc_value_type = 1
			propertyvalue.enabled = true
			c_or_unc.enabled = false
			randompropertyvaluelow.enabled = false
			randompropertyvaluehigh.enabled = false
		)
		else if i == 2 then 
		(
			doc_value_type = 2
			propertyvalue.enabled = false
			c_or_unc.enabled = true
			randompropertyvaluelow.enabled = false
			randompropertyvaluehigh.enabled = false
		)
		else
		(
			doc_value_type = 3
			propertyvalue.enabled = false
			c_or_unc.enabled = false
			randompropertyvaluelow.enabled = true
			randompropertyvaluehigh.enabled = true
		)
	)

	on c_or_unc changed state do
	(
		if c_or_unc.checked == true then doc_c_or_unc_value = true
		else doc_c_or_unc_value = false
	)

	on randompropertyvaluelow changed val do doc_rlow_value = val
	on randompropertyvaluehigh changed val do doc_rhigh_value = val

	button doit "Do it!" width:150 align:#center toolTip:"Do It!"
	on doit pressed do 
	(
		if $ == undefined then (MessageBox "Please select at least one object" title:"DoClassic")
		else
		(
			if doc_doamodifier_value == 1 then doc_modifier_property()
			else doc_property()
		)
	)

	label label1 "* Modifier name is how it appears in the"
	label label2 "modifier stack and is case sensitive"
)

if doc_floater != undefined then CloseRolloutFloater doc_floater
doc_floater = newRolloutFloater "DoClassic v1.00" 265 531
addRollout doc_rollout doc_floater
)
-------------------------------------------------------------------------------