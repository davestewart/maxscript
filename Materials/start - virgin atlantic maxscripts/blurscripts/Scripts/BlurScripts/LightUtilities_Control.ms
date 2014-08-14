-------------------------------------------------------------------------------
-- LightUtilities_Control.ms
-- v 2.91
-- Required File For LightUtilities.ms and LightControl.ms
-------------------------------------------------------------------------------
(
-- Functions

fn luct_update_current_lights =
	(
	all_the_lights = (all_lights "scene")
	for l in all_the_lights do 
		(
		if l.ishidden == true and luct_show_hidden_value == false then continue
		else
			(
			if l.isfrozen == true and luct_show_frozen_value == false then continue
			else 
				(
				if l.isselected == false and luct_show_unselected_value == false then continue
				else
					(
					if findItem o_selected_lights l == 0 and luct_show_uno_selected_value == false then continue
					else
						(
						if contains_instance current_lights l == true and luct_show_instances_value == false then continue
						else
							(
							append current_lights l
							)
						)
					)
				)
			)
		)
	)

fn luct_sortbylighttype a = 
	(
	a1 = #()
	a2 = #()
	a3 = #()
	a4 = #()
	a5 = #()
	
	for o in a do
		(
		if classof o == targetSpot then append a1 o
		else if classof o == Omnilight then append a2 o
		else if classof o == TargetDirectionallight then append a3 o
		else if classof o == Directionallight then append a4 o
		else if classof o == freeSpot then append a5 o
		)
	
	qsort a1 name_compare_case_insensitive
	qsort a2 name_compare_case_insensitive
	qsort a3 name_compare_case_insensitive
	qsort a4 name_compare_case_insensitive
	qsort a5 name_compare_case_insensitive
	
	b = a1 + a2 + a3 + a4 + a5
	return b
	)

fn luct_update_scene =
	(
	previous_lights = current_lights
	current_lights = #()
	luct_update_current_lights()
	luct_lighttotal = current_lights.count
	if luct_lighttotal != 0 then 
		(
		if luct_sortby_value == 1 then qsort current_lights name_compare_case_insensitive
		else if luct_sortby_value == 3 then current_lights = luct_sortbylighttype current_lights
		)
	)

fn luct_update_o_selected_lights = 
	(
	if current_lights.count != 0 then
		(
		local new_array = #()
		for i = 1 to current_lights.count do
			(
			if finditem o_selected_lights current_lights[i] != 0 then append new_array current_lights[i]			
			)
		o_selected_lights = new_array
		)
	else o_selected_lights = #()
	)

fn luct_kill_ch = 
	(
	deleteChangeHandler luct_id1
	deleteChangeHandler luct_id2
	luct_id1 = undefined
	luct_id2 = undefined
	)

fn luct_update_rollout = 
	(
	-- width
	
	if luct_more1_value == false and luct_more2_value == false then luct_floater_width = 281
	if luct_more1_value == true and luct_more2_value == false then luct_floater_width = 660
	if luct_more1_value == false and luct_more2_value == true then luct_floater_width = 480
	if luct_more1_value == true and luct_more2_value == true then luct_floater_width = 857
	
	luct_user_close = false
	if luct_floater != undefined then 
		(
		luct_rollout_rolledup_value = (not luct_rollout.open)
		luct_key_rollout_rolledup_value = (not luct_key_rollout.open)
		luct_opt_rollout_rolledup_value = (not luct_opt_rollout.open)
		luct_oldpos = luct_floater.pos
		CloseRolloutFloater luct_floater
		luct_floater = undefined
		)
	luct_rollout_function()
	if luct_floater_height > systemTools.GetScreenHeight() then luct_floater_height = (systemTools.GetScreenHeight() - 88)
	luct_floater = newRolloutFloater "LightControl" luct_floater_width luct_floater_height luct_oldpos.x luct_oldpos.y
	
	-- Prepare key
	
	if luct_more1_value == false and luct_more2_value == false then luct_key = "O On         Name          Sel C   Mult      Sh    MapS"
	if luct_more1_value == true and luct_more2_value == false then luct_key = "O On         Name          Sel C   Mult      Sh    MapS       Con        SoftEdge   FarStart     FarEnd         ShadowType       Dens    Sample"
	if luct_more1_value == false and luct_more2_value == true then luct_key = "O On         Name          Sel C   Mult      Sh    MapS      D   S      Decay         DecayS      Bias"
	if luct_more1_value == true and luct_more2_value == true then luct_key = "O On         Name          Sel C   Mult      Sh    MapS       Con        SoftEdge   FarStart     FarEnd         ShadowType       Dens    Sample    D   S      Decay         DecayS      Bias"
	
	-- Rollouts
	
	addRollout luct_rollout luct_floater rolledup:true
	addRollout luct_key_rollout luct_floater rolledup:true
	addRollout luct_opt_rollout luct_floater rolledup:true

	luct_rollout.open = not luct_rollout_rolledup_value
	luct_key_rollout.open = not luct_key_rollout_rolledup_value
	luct_opt_rollout.open = not luct_opt_rollout_rolledup_value

	luct_user_close = true
	)

fn luct_full_update =
	(
	luct_update_scene()
	luct_update_o_selected_lights()
	luct_update_rollout()
	)
	
fn luct_lights_select_func = 
	(
	if has_scene_changed() == false then 
		(
		undo "LightUtilities" on
			(
			select o_selected_lights
			)
		)
	)

fn luct_rollout_function =
	(
	lrs=("Rollout luct_rollout \"LightControl\"\n")
	lrs+="(\n"

	lrs+="Button select_obj \"\" width:12 height:23 pos:[4,5] tooltip:\"Select In Scene\"\n"
	lrs+="Button all_button \"A\" width:20 height:23 pos:[18,5] tooltip:\"All\"\n"
	lrs+="Button none_button \"N\" width:20 height:23 pos:[40,5] tooltip:\"None\"\n"
	lrs+="Button inv_button \"I\" width:20 height:23 pos:[62,5] tooltip:\"Inverse\"\n"

	lrs+="Button update_button \"Update\" width:85 height:23 pos:[105,5] tooltip:\"Update\"\n"
	lrs+="Checkbutton auto_update_button height:23 width:12 pos:[192,5] checked:luct_auto_update_on highlightcolor:([255,255,0]as color) tooltip:\"Auto-Update\"\n"
	lrs+="checkbox more1_button pos:[210,9] width:12 checked:luct_more1_value\n"
	lrs+="checkbox more2_button pos:[233,9] width:12 checked:luct_more2_value\n"
	
	lrs+="CheckButton Divider width:247 height:4 pos:[4,34] checked:true enabled:off\n"

	lrs+="on select_obj pressed do luct_lights_select_func()\n"
	lrs+="on update_button pressed do (luct_full_update())\n"
	
	lrs+="on auto_update_button changed state do\n"
	lrs+="(\n"
	lrs+="if auto_update_button.checked == true then\n"
	lrs+="(\n"
	lrs+="luct_auto_update_on = true\n"
	lrs+="if luct_id1 == undefined then"
	lrs+="(\n"
	lrs+="luct_id1 = when parameters $* changes do luct_full_update()"
	lrs+="luct_id2 = when select $* changes do luct_full_update()"
	lrs+=")\n"	
	lrs+=")\n"
	lrs+="else\n"
	lrs+="(\n"
	lrs+="luct_auto_update_on = false\n"
	lrs+="if luct_id1 != undefined then luct_kill_ch()"
	lrs+=")\n"
	lrs+="luct_full_update()\n"
	lrs+=")\n"
	
	lrs+="on more1_button changed state do\n"
	lrs+="(\n"
	lrs+="if more1_button.checked == true then luct_more1_value = true else luct_more1_value = false\n"
	lrs+="luct_full_update()\n"
	lrs+=")\n"
	
	lrs+="on more2_button changed state do\n"
	lrs+="(\n"
	lrs+="if more2_button.checked == true then luct_more2_value = true else luct_more2_value = false\n"
	lrs+="luct_full_update()\n"
	lrs+=")\n"
	
	luct_Ypos=43
	luct_lighttotal = current_lights.count
	if luct_lighttotal != 0 then
		(
		all_the_lights = (all_lights "scene")
		
		if luct_more1_value == true then 
			(
			diffuse_pos = 632
			spec_pos = 650
			decay_pos = 665
			decaystart_pos = 735
			bias_pos = 786
			)
		else
			(
			diffuse_pos = 253
			spec_pos = 271
			decay_pos = 286
			decaystart_pos = 356
			bias_pos = 407
			)
		
		for i = 1 to luct_lighttotal do 
			(
			w = (i as string)
			if luct_instances_in_bold_value == true then
				(
				if (contains_instance all_the_lights current_lights[i]) == true then make_bold = true else make_bold = false
				)
			
			-- O-Select
			if finditem o_selected_lights current_lights[i] != 0 then sb_value = true else sb_value = false
			lrs+="Checkbutton select_button"+w+" height:16 width:12 pos:[4,"+luct_Ypos as string+"] checked:"+(sb_value as string)+" highlightcolor:([255,255,0]as color) tooltip:\"O-Select\"\n"

			-- On Off
			lrs+="Checkbox on_off_check"+w+" pos:[18,"+luct_Ypos as string+"] width:12 checked:"+current_lights[i].on as string+" \n"

			-- Name
			lrs+="EditText name_edit"+w+" fieldwidth:80 text:\""+current_lights[i].name+"\" pos:[29,"+luct_Ypos as string+"] bold:" + (make_bold as string)+ "\n"

			-- QuickSelect
			lrs+="Button quick_select_button"+w+"\"\" width:12 height:16 pos:[115,"+luct_Ypos as string+"] tooltip:\"Quick Select\"\n"

			-- Color
			lrs+="ColorPicker color_pick"+w+" color:"+(current_lights[i].rgb as point3) as string + " fieldwidth:12 height:16 pos:[125,"+luct_Ypos as string+"]\n"

			-- Multiplier
			lrs+="Spinner multiplier_spin" +w+" "+" width:42 pos:[143,"+luct_Ypos as string+"] range:[-1000,1000,"+current_lights[i].multiplier as string+"] \n"

			-- Shadow on off
			lrs+="Checkbox shadow_on_off_check"+w+" " + "pos:[188,"+luct_Ypos as string+"] width:12 checked:"+current_lights[i].baseobject.castshadows as string+" \n"

			-- Mapsize
			if classof (getproperty current_lights[i] "shadowgenerator") == shadowmap then the_mapsize = current_lights[i].mapsize
			else the_mapsize = 0
			lrs+="Spinner mapsize_spin" +w+" "+" width:50 pos:[201,"+luct_Ypos as string+"] type:#integer range:[0,10000,"+(the_mapsize as string)+"] \n"
			
			if luct_more1_value == true then
				(
				-- Contrast
				lrs+="Spinner contrast_spin" +w+" "+" width:50 pos:[251,"+luct_Ypos as string+"] type:#float range:[0.0,100.0,"+current_lights[i].contrast as string+"] \n"
				
				-- Soften Diffuse Edge
				lrs+="Spinner sde_spin" +w+" "+" width:50 pos:[302,"+luct_Ypos as string+"] type:#float range:[0.0,100.0,"+current_lights[i].softenDiffuseEdge as string+"] \n"

				-- Far Atten Start
				lrs+="Spinner farstart_spin" +w+" "+" width:50 pos:[353,"+luct_Ypos as string+"] type:#worldunits range:[0.0,9999999.0,"+current_lights[i].farAttenStart as string+"] \n"

				-- Far Atten End
				lrs+="Spinner farend_spin" +w+" "+" width:50 pos:[404,"+luct_Ypos as string+"] type:#worldunits range:[0.0,9999999.0,"+current_lights[i].farAttenEnd as string+"] \n"

				-- Shadow Type
				if classof (getproperty current_lights[i] "shadowgenerator") == shadowmap then the_shadowtype = 1 
				else the_shadowtype = 2
				lrs+="dropdownlist shadowtype_drop" +w+" \"\" Width:90 items:#(\"ShadowMap\", \"RayTrace\") pos:[457,"+luct_Ypos as string+"] selection:"+(the_shadowtype as string)+"\n"

				-- Shadow Density
				lrs+="Spinner shadowdensity_spin" +w+" "+" width:40 pos:[548,"+luct_Ypos as string+"] type:#float range:[-10000.0,10000.0,"+current_lights[i].shadowMultiplier as string+"] \n"

				-- Sample Range
				if classof (getproperty current_lights[i] "shadowgenerator") == shadowmap then the_samplerange = current_lights[i].sampleRange
				else the_samplerange = 0
				lrs+="Spinner samplerange_spin" +w+" "+"width:40 pos:[589,"+luct_Ypos as string+"] type:#float range:[0.01,50.0,"+the_samplerange as string+"] \n"
				)
				
			if luct_more2_value == true then
				(
				-- Diffuse
				lrs+="Checkbox diffuse_check"+w+" pos:["+diffuse_pos as string+","+luct_Ypos as string+"] width:12 checked:"+current_lights[i].affectDiffuse as string+" \n"
				
				-- Specular
				lrs+="Checkbox specular_check"+w+" pos:["+spec_pos as string+","+luct_Ypos as string+"] width:12 checked:"+current_lights[i].affectSpecular as string+" \n"

				-- Decay
				lrs+="dropdownlist decay_drop" +w+" \"\" Width:70 items:#(\"None\", \"Inverse\", \"InverseS\") pos:["+decay_pos as string+","+luct_Ypos as string+"] selection:"+(current_lights[i].attenDecay as string)+"\n"

				-- DecayStart
				lrs+="Spinner decaystart" +w+" "+" width:50 pos:["+decaystart_pos as string+","+luct_Ypos as string+"] type:#worldunits range:[0.0,9999999.0,"+current_lights[i].decayradius as string+"] \n"

				-- ShadowMapBias
				if classof (getproperty current_lights[i] "shadowgenerator") == shadowmap then the_bias = current_lights[i].mapBias
				else the_bias = 0
				lrs+="Spinner bias_spin" +w+" "+" width:40 pos:["+bias_pos as string+","+luct_Ypos as string+"] type:#float range:[0.0,10000.0,"+the_bias as string+"] \n"
				)
			
			lrs+="on select_button"+w+" changed state do (if has_scene_changed() == false then (\n if select_button"+w+".checked == true then append o_selected_lights current_lights["+w+"] else deleteitem o_selected_lights (finditem o_selected_lights current_lights["+w+"])\nluct_update_o_selected_lights()))\n"
			lrs+="on on_off_check"+w+" changed state do (if has_scene_changed() == false then current_lights["+w+"].on=on_off_check"+w+".checked)\n"
			lrs+="on name_edit"+w+" entered text do (if has_scene_changed() == false then current_lights["+w+"].name=text)\n"			
			lrs+="on quick_select_button"+w+" pressed do (if has_scene_changed() == false then select current_lights["+w+"])\n"
			lrs+="on color_pick"+w+" changed new_col do (if has_scene_changed() == false then current_lights["+w+"].rgb=color_pick"+w+".color)\n"
			lrs+="on multiplier_spin"+w+" changed value do (if has_scene_changed() == false then current_lights["+w+"].multiplier=multiplier_spin"+w+".value)\n"
			lrs+="on shadow_on_off_check"+w+" changed state do (if has_scene_changed() == false then current_lights["+w+"].baseobject.castshadows=shadow_on_off_check"+w+".checked)\n"
			lrs+="on mapsize_spin"+w+" changed value do (if has_scene_changed() == false then (if classof (getproperty current_lights["+w+"] \"shadowgenerator\") == shadowmap then current_lights["+w+"].mapsize=mapsize_spin"+w+".value else (mapsize_spin"+w+".value=0)))\n"

			if luct_more1_value == true then
				(
				lrs+="on contrast_spin"+w+" changed value do (if has_scene_changed() == false then current_lights["+w+"].contrast=contrast_spin"+w+".value)\n"
				lrs+="on sde_spin"+w+" changed value do (if has_scene_changed() == false then current_lights["+w+"].softenDiffuseEdge=sde_spin"+w+".value)\n"
				lrs+="on farstart_spin"+w+" changed value do (if has_scene_changed() == false then current_lights["+w+"].farAttenStart=farstart_spin"+w+".value)\n"
				lrs+="on farend_spin"+w+" changed value do (if has_scene_changed() == false then current_lights["+w+"].farAttenEnd=farend_spin"+w+".value)\n"
				lrs+="on shadowtype_drop"+w+" selected st do (if has_scene_changed() == false then ((if st == 1 then setproperty current_lights["+w+"] \"shadowgenerator\" (shadowmap()) else (setproperty current_lights["+w+"] \"shadowgenerator\" (raytraceShadow())))\nluct_full_update()))\n"
				lrs+="on shadowdensity_spin"+w+" changed value do (if has_scene_changed() == false then current_lights["+w+"].shadowMultiplier=shadowdensity_spin"+w+".value)\n"
				lrs+="on samplerange_spin"+w+" changed value do (if has_scene_changed() == false then (if classof (getproperty current_lights["+w+"] \"shadowgenerator\") == shadowmap then current_lights["+w+"].sampleRange=samplerange_spin"+w+".value else (samplerange_spin"+w+".value=0.01)))\n"
				)

			if luct_more2_value == true then
				(
				lrs+="on diffuse_check"+w+" changed state do (if has_scene_changed() == false then current_lights["+w+"].affectDiffuse=diffuse_check"+w+".checked)\n"
				lrs+="on specular_check"+w+" changed state do (if has_scene_changed() == false then current_lights["+w+"].affectSpecular=specular_check"+w+".checked)\n"
				lrs+="on decay_drop"+w+" selected st do (if has_scene_changed() == false then current_lights["+w+"].attenDecay=st)\n"
				lrs+="on decaystart"+w+" changed value do (if has_scene_changed() == false then current_lights["+w+"].decayradius=decaystart"+w+".value)\n"
				lrs+="on bias_spin"+w+" changed value do (if has_scene_changed() == false then (if classof (getproperty current_lights["+w+"] \"shadowgenerator\") == shadowmap then current_lights["+w+"].mapBias=bias_spin"+w+".value else (bias_spin"+w+".value=0.0)))\n"
				)
			luct_Ypos+=20
			)
		)
		
	lrs+="on all_button pressed do (if luct_lighttotal != 0 then\n(\n"
	lrs+="o_selected_lights = #()\n(\n"
	if luct_lighttotal != 0 then
		(
		for sa = 1 to luct_lighttotal do
			(
			lrs+="select_button"+(sa as string)+".checked = true\n"
			lrs+="append o_selected_lights current_lights["+(sa as string)+"]\n"
			)
		)
	lrs+=")\n)\n)\n"
	
	lrs+="on none_button pressed do (if luct_lighttotal != 0 then\n(\n"
	if luct_lighttotal != 0 then
		(
		for sa = 1 to luct_lighttotal do
			(
			lrs+="o_selected_lights = #()\n"
			lrs+="select_button"+(sa as string)+".checked = false\n"
			)
		)
	lrs+=")\n)\n"
	
	lrs+="on inv_button pressed do (if luct_lighttotal != 0 then\n(\n"
	if luct_lighttotal != 0 then
		(
		for sa = 1 to luct_lighttotal do
			(
			lrs+="if select_button"+(sa as string)+".checked == false then (select_button"+(sa as string)+".checked = true\n append o_selected_lights current_lights["+(sa as string)+"])\n else (select_button"+(sa as string)+".checked = false\ndeleteitem o_selected_lights (finditem o_selected_lights current_lights["+(sa as string)+"]))\n"
			)
		)
	lrs+=")\n)\n"

	lrs+="on luct_rollout close do \n"
	lrs+="(\n"
	lrs+="if luct_id1 != undefined and luct_user_close == true then"
	lrs+="(\n"
	lrs+="luct_kill_ch()\n"
	lrs+=")\n"
	lrs+=")\n"
	
	lrs+=")\n"
	
	execute lrs
	luct_floater_height = luct_Ypos + 111
	)

-- Script

rollout luct_key_rollout "LightControl Key"
	(
	label label1 "" align:#left
	on luct_key_rollout open do
		(
		label1.text = luct_key as string
		label1.pos = [4,5]
		)
	)

rollout luct_opt_rollout "LightControl Options"
	(
	group "Sort"
	(
	dropdownlist sortby_drop "" items:#("Alphabetical", "Creation", "LightType") selection:luct_sortby_value align:#left
	)

	on sortby_drop selected i do 
		(
		luct_sortby_value = i
		luct_full_update()
		)
	
	group "Filters"
	(
	checkbox show_hidden_check "Show Hidden" checked:luct_show_hidden_value
	checkbox show_frozen_check "Show Frozen" checked:luct_show_frozen_value
	checkbox show_unselected_check "Show Unselected" checked:luct_show_unselected_value
	checkbox show_uno_selected_check "Show Un-O-Selected" checked:luct_show_uno_selected_value
	checkbox show_instances_check "Show Instances" checked:luct_show_instances_value
	)

	on show_hidden_check changed state do 
		(
		luct_show_hidden_value = state
		luct_full_update()
		)
	on show_frozen_check changed state do 
		(
		luct_show_frozen_value = state
		luct_full_update()
		)
	on show_unselected_check changed state do 
		(
		luct_show_unselected_value = state
		luct_full_update()
		)
	on show_uno_selected_check changed state do 
		(
		luct_show_uno_selected_value = state
		luct_full_update()
		)
	on show_instances_check changed state do 
		(
		luct_show_instances_value = state
		luct_full_update()
		)
	
	group "Misc"
	(
	checkbox instances_in_bold_check "Instances In Bold" checked:luct_instances_in_bold_value
	)
	
	on instances_in_bold_check changed state do 
		(
		luct_instances_in_bold_value = state
		luct_full_update()
		)
	)
)
-------------------------------------------------------------------------------