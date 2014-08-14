-------------------------------------------------------------------------------
-- QuickMaterial.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.32
-- Created On: 08/12/00
-- Modified On: 08/03/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description: 
-- Just a quick 1 button solution for getting some commonly used materials 
-- (well, material I use commonly) without the need for a default material 
-- library.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- If you have the plugin Illustrate installed, it will stop this script
-- from functioning. Unfortunately, we don't have a copy of illustrate in
-- the studio for testing, so I can't fix the bug. In the meantime, remove
-- illustrate from your plugin.ini when you want to run this script.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Just a quick 1 button solution for getting some commonly used materials 
-- (well, material I use commonly) without the need for a default material 
-- library. WARNING: This script only works if you have avg_dlx.dlx version 2.07 or 
-- higher installed. Get this file from http://www.soulburn3d.com
--
-- v 1.10 Added two new materials, a grooved material, and a chrome base 
-- material (add your favorite reflection map to complete this material).
--
-- v 1.20 Added r4 compatability. Now places material in the currently selected 
-- slot. Removed the chrome material, because it really wasn't very useful.
--
-- v 1.30 Added an overbright white material for bright cards to replace lights
-- in reflection heavy renders.
--
-- v 1.31 Changed the interface to a dropdown list.
--
-- v 1.32 The material definitions have been moved into BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global quickmat

global qm_floater
global qm_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

qm = 1
qm_mat_names = #()

-- Functions

fn quickmat_update = 
	(
	qm_mat_names = #()
	mat_files = get_all_files_in_dir "$scripts/BlurMats/" false "mat"
	if mat_files.count != 0 then
		(
		for i = 1 to mat_files.count do
			(
			the_name = (filenameFromPath mat_files[i])
			append qm_mat_names (strip_file_extension the_name)
			)
		)
	)

fn quickmat = 
	(
	undo "QuickMaterial" on
		(
		m = get_blurmat (qm_mat_names[qm] as string)
		if m != false then meditMaterials[medit.GetActiveMtlSlot()] = copy m
		)
	)

-- The Script

rollout qm_rollout "QuickMaterial"
	(
	dropdownlist qm_list "" items:qm_mat_names height:20
	on qm_list selected i do qm = i
		
	button do_qm "Place Material In Selected Slot" width:200 align:#center toolTip:"Place Material In Selected Slot"
	on do_qm pressed do quickmat()
	)
	
quickmat_update()

if qm_floater != undefined then CloseRolloutFloater qm_floater
qm_floater = newRolloutFloater "QuickMaterial v1.32" 250 122
addRollout qm_rollout qm_floater
)
-------------------------------------------------------------------------------