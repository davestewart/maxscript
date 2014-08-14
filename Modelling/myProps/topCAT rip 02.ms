rollout roStack "Stack" width:464 height:336
(
----------------------------------------
-- interface
----------------------------------------
	listbox prop_list "TOPCAT" pos:[8,8] width:144 height:15 
	listbox ddlMods "Element" pos:[160,8] width:144 height:15
	listbox ddlAttribs "Attribute" pos:[312,8] width:144 height:15

	GroupBox grpAttribs "Element Info" pos:[160,232] width:296 height:72
	label lblAttrib "Attrib:" pos:[168,248] width:280 height:16
	label lblAttribVal "Value:" pos:[168,264] width:280 height:16
	label lblAttribClass "Class:" pos:[168,280] width:280 height:16
	button btnGetStackProps "Get stack properties" pos:[160,312] width:296 height:16


global daveObjects = #()
global daveModifiers = #()
global davePropNames= #()



global TopCAT_stack_props = #()
global TopCAT_stack_names = #()
global TopCAT_active_array = #()

fn get_stack_properties =
(
	TopCAT_stack_props = #()
	TopCAT_stack_names = #()
	TopCAT_active_array = #()

-- GET MODIFIER LIST
	for m = 1 to $.modifiers.count do
	(
		append TopCAT_stack_props #($.modifiers[m], ("--" + $.modifiers[m].name as string))
		get_all_prop_name = getSubAnimNames $.modifiers[m]

	-- GO THOUGH MODIFIER LIST AND GET PROPERTIES
		for i in get_all_prop_name do
		(
			 print $.modifiers[m][i].value

				try
					if classof ($.modifiers[m][i].value) == Float then
						append TopCAT_stack_props #($.modifiers[m], i, "Float")
				catch()

				try
					if classof ($.modifiers[m][i].value) == Integer then
						append TopCAT_stack_props #($.modifiers[m], i, "Integer")
				catch()

			)--end i loop	

		)--end m loop


-- GET BASEOBJECT NAME
	append TopCAT_stack_props #($.baseobject, "==> " + $.baseObject as String)

-- GO THOUGH BASEOBJECT PROPERTY LIST AND GET PROPERTIES
	get_all_prop_name = getSubAnimNames $.baseobject
	for i in get_all_prop_name do
	(
		try
			if classof ($.baseobject[i].value) == Float then
				append TopCAT_stack_props #($.baseobject, i, "Float")
		catch()

		try
			if classof ($.baseobject[i].value) == Integer then
				append TopCAT_stack_props #($.baseobject, i, "Integer")
		catch()
		
	)--end i loop	


-- GIVE FRIENDLY NAMES TO STACK_PROPS
	for i = 1 to TopCAT_stack_props.count do 
(
		append TopCAT_stack_names (TopCAT_stack_props[i][2] as string)
		append TopCAT_active_array false
)
	prop_list.items = TopCAT_stack_names

)--end fn

	on btnGetStackProps pressed do
		get_stack_properties()

)



---------------------------------------------------------------------------------------------------
-- Create Floater
---------------------------------------------------------------------------------------------------

	if ObjAttribs != undefined then closeRolloutFloater ObjAttribs 
	ObjAttribs = newRolloutFloater "Multi-Object Attribute Changer" 492 392 80 60
	addRollout roStack ObjAttribs
