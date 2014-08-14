
	TopCAT_stack_props = #()
	TopCAT_stack_names = #()

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

	TopCAT_stack_props
	TopCAT_stack_names
