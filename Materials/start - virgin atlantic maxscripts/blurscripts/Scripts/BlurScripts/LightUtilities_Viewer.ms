-------------------------------------------------------------------------------
-- LightUtilities_Viewer.ms
-- v 2.91
-- Required File For LightUtilities.ms and LightControl.ms
-------------------------------------------------------------------------------
(
-- Functions

fn luv_collect_the_lights = 
	(
	luv_laststate = #()
	for s in all_lights "scene" do
		(
		append luv_laststate #(s, s.enabled)
		)
	)

fn luv_make_copies_of_lights = 
	(
	for i in luo_array do
		(
		new_light = copy i
		append luv_lights #(i, new_light)
		)
	)
	
fn luv_delete_copies_of_lights = 
	(
	temp_array = #()
	for i in luv_lights do
		(
		i[2].target = i[2]
		append temp_array i[2]
		)
	delete temp_array
	)
	
fn luv_turn_all_lights_off = 
	(
	for i in all_lights "scene" do
		(
		i.enabled = false
		)
	)

fn luv_start = 
	(
	freeSceneBitmaps()
	gc()
	luv_lights = #()
	luv_display_list = #()
	temp_array = lu_operation_on_what()
	luo_array = copy_array temp_array
	
	if luo_array.count !=0 then
		(
		if luv_type_value == 1 then luv_seperate_start()
		else if luv_type_value == 2 then luv_together_start()
		else luv_cumulative_start()
		)
	)
	
fn luv_do_a_render thename = 
	(
	if luv_save_value == true then 
		(
		luv_outfile = luv_outdir + (thename as string) + ".tga"
		)
	else
		(
		luv_outfile = (getdir #image) + "\\" + (thename as string) + ".tga"
		)
	try
		(
		temp1 = rendAtmosphere
		d = render vfb:luv_vfb_value antiAliasing:luv_aa_value mapping:luv_tex_value renderatmosphericeffects:luv_atm_value imageMotionBlur:false objectMotionBlur:false outputfile:luv_outfile
		rendAtmosphere = temp1
		close (openbitmap luv_outfile)
		append luv_display_list luv_outfile
		close d
		)
	catch
		(
		if luv_save_value == true then
			(
			MessageBox "An error has occured.\nPossible causes include:\n1) You have chosen an invalid Output Path\n2) One of your lights does not have a name.\nPlease fix this problem and then try again." title:"LightUtilities"
			)
		else 
			(
			MessageBox "An error has occured.\nPossible causes include:\n1) You have improperly configured your standard max image output directory\n2) One of your lights does not have a name.\nPlease fix this problem and then try again." title:"LightUtilities"
			)
		if luv_type_value != 2 then return exit
		)
	)

fn luv_display_or_delete = 
	(
	for i in luv_display_list do
		(
		if luv_show_images_value == true then display (openbitmap i)
		if luv_save_value == false then deleteFile i
		)
	)

fn luv_put_it_back =
	(
	for i = 1 to luv_laststate.count do luv_laststate[i][1].enabled = luv_laststate[i][2]
	)
	
-- Seperate
	
fn luv_seperate_start = 
	(
	luv_collect_the_lights()
	luv_turn_all_lights_off()
	luv_make_copies_of_lights()
	luv_seperate()
	)
	
fn luv_seperate = 
	(
	progressStart "LightViewer"
	escapeEnable = true
	for w = 1 to luv_lights.count do
		(
	  	if getProgressCancel() == true then exit
		m = ((w as float) / (luv_lights.count as float))*100
		for j = 1 to luv_lights.count do
			(
			if luv_lights[j][1] == luv_lights[w][1] then luv_lights[j][2].enabled = true
			else luv_lights[j][2].enabled = false
			)
		luv_do_a_render luv_lights[w][1].name
		progressUpdate m
		)
	progressEnd()
	luv_seperate_end()
	)
	
fn luv_seperate_end = 
	(
	luv_delete_copies_of_lights()
	luv_lights = #()
	luv_display_or_delete()
	luv_put_it_back()
	)
	
-- Together

fn luv_together_start = 
	(
	luv_collect_the_lights()
	luv_turn_all_lights_off()
	luv_make_copies_of_lights()
	luv_together()
	)

fn luv_together = 
	(
	for i = 1 to luv_lights.count do
		(
		luv_lights[i][2].enabled = true
		)
	luv_do_a_render "SelectedLights"
	luv_together_end()
	)
	
fn luv_together_end = 
	(
	luv_delete_copies_of_lights()
	luv_lights = #()
	luv_display_or_delete()
	luv_put_it_back()
	)
	
-- Cumulative
	
fn luv_cumulative_start = 
	(
	luo_start()
	)
	
fn luv_cumulative = 
	(
	luv_collect_the_lights()
	luv_turn_all_lights_off()
	luv_make_copies_of_lights()
		
	progressStart "LightViewer"
	escapeEnable = true
	num_repeats = luv_lights.count
	for w = 1 to num_repeats do
		(
	  	if getProgressCancel() == true then exit
		m = ((w as float) / (num_repeats as float))*100
		luv_lights[w][2].enabled = true
		luv_do_a_render ("Cumulative_" + (extra_zeros w 2))
		progressUpdate m
		)
	progressEnd()
	luv_cumulative_end()
	)
	
fn luv_cumulative_end = 
	(
	luv_delete_copies_of_lights()
	luv_lights = #()
	luv_display_or_delete()
	luv_put_it_back()
	)

-- Rollouts

rollout luv_rollout "LightViewer"
	(
	dropdownlist luv_type "" items:#("Seperate", "Together", "Cumulative") selection:1
	on luv_type selected i do luv_type_value = i
	
	checkbox luv_tex "Textures" checked:false align:#left
	on luv_tex changed state do 
		(
		if luv_tex.checked == false then luv_tex_value = false
		else luv_tex_value = true
		)

	checkbox luv_atm "Atmospherics" checked:false align:#left
	on luv_atm changed state do 
		(
		if luv_atm.checked == false then luv_atm_value = false
		else luv_atm_value = true
		)
		
	checkbox luv_aa "Antialiasing" checked:false align:#left
	on luv_aa changed state do 
		(
		if luv_aa.checked == false then luv_aa_value = false
		else luv_aa_value = true
		)

	checkbox luv_vfb "Show VFB" checked:true align:#left
	on luv_vfb changed state do 
		(
		if luv_vfb.checked == true then luv_vfb_value = true
		else luv_vfb_value = false
		)

	checkbox luv_show_images "Show Images" checked:true align:#left
	on luv_show_images changed state do 
		(
		if luv_show_images.checked == true then luv_show_images_value = true
		else luv_show_images_value = false
		)
		
	group "Save"
	(
	checkbox luv_save "Save Images" checked:false align:#left
	button luv_getpath "Path" align:#left across:2 enabled:false
	edittext luv_pathlabel "" fieldWidth:158 offset:[-60,4] text:"undefined" enabled:false
	)

	on luv_save changed state do 
		(
		if luv_save.checked == true then 
			(
			luv_getpath.enabled = true
			luv_pathlabel.enabled = true
			luv_save_value = true
			)
		else 
			(
			luv_getpath.enabled = false
			luv_pathlabel.enabled = false
			luv_save_value = false
			)
		)
	
	on luv_getpath pressed do
		(
		luv_outdir = getSavePath()
		luv_pathlabel.text = (luv_outdir as string)
		)
	on luv_pathlabel entered text do 
		(
		if luv_pathlabel.text == "undefined" then luv_outdir = undefined
		else luv_outdir = luv_pathlabel.text
		)
		
	button luv_view_b "View The Influence" width:200 align:#center toolTip:"View the influence of selected lights"
	on luv_view_b pressed do 
		(
		if luv_outdir == undefined and luv_save_value == true then
			(MessageBox "You have not defined an output directory to save your images to." title:"LightUtilities")
		else
			(
			if luv_outdir != undefined then
				(
				if luv_outdir[luv_outdir.count] != "\\" then luv_outdir = luv_outdir + "\\"
				)
			if has_scene_changed() == false then 
				(
				luct_full_update()
				luv_start()
				)
			)
		)
	)
)
-------------------------------------------------------------------------------