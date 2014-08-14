rollout editing "Manage Attributes" width:256 height:416
(

	button get_stack_props "GET STACK PROPERTIES" pos:[7,7] width:241 height:21 toolTip:"Click to get a List of Supported SubAnim Parameters"
	listbox prop_list "" pos:[8,32] width:240 height:22 


global TopCAT_stack_props = #()
global TopCAT_stack_names = #()
global TopCAT_active_array = #()

fn get_stack_properties =
(
	TopCAT_stack_props = #()
	TopCAT_stack_names = #()
	TopCAT_active_array = #()
	for m = 1 to $.modifiers.count do
	(
		append TopCAT_stack_props #($.modifiers[m], ("--" + $.modifiers[m].name as string))
		get_all_prop_name = getSubAnimNames $.modifiers[m]
		for i in get_all_prop_name do
		(
		 print $.modifiers[m][i].value
			try
				(
				if classof ($.modifiers[m][i].value) == Float then
					(
					append TopCAT_stack_props #($.modifiers[m], i, "Float")
					)
				)
			catch()
			try
				(
				if classof ($.modifiers[m][i].value) == Integer then
					(
					append TopCAT_stack_props #($.modifiers[m], i, "Integer")
					)
				)
			catch()
		)--end i loop	
	)--end m loop

	append TopCAT_stack_props #($.baseobject, "--BASE OBJECT")
	get_all_prop_name = getSubAnimNames $.baseobject
	for i in get_all_prop_name do
	(
		try
		(
		if classof ($.baseobject[i].value) == Float then
		(
			append TopCAT_stack_props #($.baseobject, i, "Float")
		)
		)catch()
		try
		(
		if classof ($.baseobject[i].value) == Integer then
		(
			append TopCAT_stack_props #($.baseobject, i, "Integer")
		)
		)catch()
		
	)--end i loop	
	for i = 1 to TopCAT_stack_props.count do 
	(
		append TopCAT_stack_names (TopCAT_stack_props[i][2] as string)
		append TopCAT_active_array false
	)
	prop_list.items = TopCAT_stack_names 
)--end fn





	on get_stack_props pressed do
		get_stack_properties()
	on prop_list doubleClicked itm do
	(
		if substring TopCAT_stack_names[itm] 1 2 != "--" then
		(
			if TopCAT_active_array[itm] == True then
			(
				TopCAT_active_array[itm] = False
				TopCAT_stack_names[itm] = substring TopCAT_stack_names[itm] 2 1000
			)
			else
			(
				TopCAT_active_array[itm] = True
				TopCAT_stack_names[itm] = ">" + TopCAT_stack_names[itm] 
			)
			prop_list.items = TopCAT_stack_names 
		)
	)
	on add_attribs pressed do
	(
		if custAttributes.getDef $.modifiers[#TopCAT_Modifier] 1 == undefined then
		(
	
		att_string1 = "attributes TopCAT version:1 silentErrors:True\n(\n"
		att_string1 += "parameters main rollout:params\n(\n"
		
		att_string2 = "rollout params \"TopCAT\" \n(\n"
		
		for p = 1 to TopCAT_stack_names.count do
		(
		 	if TopCAT_active_array[p] then
			(
			    stack_name = substring TopCAT_stack_names[p] 2 1000
				att_string1 += stack_name + p as string  + " type:#" + TopCAT_stack_props[p][3] + " ui:"+ stack_name + p as string + " default:0.0\n" 
				att_string2 += "spinner " + stack_name + p as string + " \""+ stack_name + "\" "+ " type:#" + TopCAT_stack_props[p][3] + " range:[-100000.0,1000000.0,0.0]\n"
			)	
		)--end p loop	
		att_string1 += "\n)\n"
		att_string2 += "\n))\n"
		att = execute (att_string1 + att_string2)
		custAttributes.add $.modifiers[#TopCAT_Modifier] att
		
		for p = 1 to TopCAT_stack_names.count do
		(
		if TopCAT_active_array[p] == True then
			(
			original_object = TopCAT_stack_props[p][1]
			original_parameter = TopCAT_stack_props[p][2]
			original_parameter_name = original_parameter as string
			target_parameter = $.modifiers[#TopCAT_Modifier].TopCAT[execute("#"+original_parameter_name+p as string)]
			target_parameter_string = target_parameter as string
			target_parameter_name = substring target_parameter_string ((findstring target_parameter_string ":")+1) 1000
			paramWire.connect2Way original_object[original_parameter] target_parameter target_parameter_name original_parameter_name
			)	
		)--end p loop
		)
	)--end on add
	on del_attribs pressed do
	(
		if custAttributes.getDef $.modifiers[#TopCAT_Modifier] 1 != undefined then
		(
			q = querybox "This will delete ALL Custom Attributes!"
			if q then
			(
			    att = custAttributes.getDef $.modifiers[#TopCAT_Modifier] 1
				custAttributes.delete $.modifiers[#TopCAT_Modifier] att
			)
		)
	)--end on del
)

	if getStackProps != undefined then closeRolloutFloater getStackProps
	getStackProps = newRolloutFloater "Multi-Object Attribute Changer" 344 874 80 60


	addRollout editing getStackProps