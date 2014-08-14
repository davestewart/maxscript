-------------------------------------------------------------------------------
-- BipedCataloger.ms
-- By Brandon Davis (brandon@blur.com)
-- v 1.00
-- Created On: 02/13/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Point this script at a directory of .bip files and it will generate AVIs showing
-- what each .bip does.  This makes it handy when working with multiple .bips in 
-- production because you can look at a directory of AVIs to find the proper file.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

global new_path, files, path_rollout

recurse = false
vfb_active = true
back_color = [150,150,150]
avi_width = 320
avi_height = 240

-- Functions

fn process_bip =
(
	for i = 1 to files.count do
	(
		path_rollout.process_gauge.value = ((i as float)/(files.count as float))*100
		resetMAXfile(#noPrompt)
		backgroundColor = back_color
		bip_obj = biped.createNew 100 0 [0,0,0]
		bip = bip_obj.transform.controller
		max tool zoomextents
		biped.loadBipFile bip files[i]
		$bip01.transform.controller.inPlaceMode = true
		final_avi_path = ((files[i] as string)+(".avi"))
		path_rollout.prog_label.text = ("Rendering ") + (final_avi_path) 
	    render vfb:vfb_active outputSize: [avi_width,avi_height] framerange:#active outputfile:final_avi_path
	)
	path_rollout.process_gauge.value = 0	
	messageBox "Catalog Complete" beep:true
)	

-- Script

rollout path_rollout "Biped Path"
(

group "Get Biped Files"
(
button get_bip_path "BipPath" align:#left across:3
checkbox check_recursion "Include Subfolders"
label lab_num_files
edittext lab_bip_path
)

group "AVI Parameters"
(
spinner ren_width "Width: " across:3 align:#left range:[10,1000,320]
spinner ren_height "Height: " align:#left range:[10,1000,240]
colorpicker background_color "Background" color:[150,150,150]
checkbox framebuffer "Display Framebuffer" checked:true align:#center
)

group "Process"
(
button execute_process "Process" height:25
label prog_label
progressbar process_gauge 
)

on get_bip_path pressed do
	(
		new_path = getSavePath()
		if getSavePath != undefined then lab_bip_path.text = new_path
		files = get_all_files_in_dir new_path recurse "bip"
		lab_num_files.text = ("Total BIPs: ") + (files.count as string)
	)
		
on check_recursion changed state do
(
	recurse = state
)

on ren_width changed val do
(
	avi_width = val
)
	
on ren_height changed val do
(
	avi_height = val
)

on background_color changed val do back_color = val

on framebuffer changed state do
(
	vfb_active = state
	print state
)	

on execute_process pressed do process_bip()		
)

if BC_floater != undefined then CloseRolloutFloater BC_floater
BC_floater = newRolloutFloater "Biped Cataloger v1.00" 400 300
addRollout path_rollout BC_floater
)
-------------------------------------------------------------------------------