-------------------------------------------------------------------------------
-- ModifierManager.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.50
-- Created On: 03/19/01
-- Modified On: 02/22/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to add a modifer to selected objects (each modifier is a seperate
-- modifier, not an instance of the same modifier which happens if you multiselect
-- objects and apply a modifier in the modifier panel), and to delete modifiers 
-- from selected objects (Any selected objects will have their modifier stacks 
-- checked, and any modifier that you specify in there will be deleted.) 
-- Replaces RemoveModifier.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to add a modifer to selected objects (each modifier is a 
-- seperate modifier, not an instance of the same modifier which happens if you 
-- multiselect objects and apply a modifier in the modifier panel), and to delete 
-- modifiers from selected objects (Any selected objects will have their modifier 
-- stacks checked, and any modifier that you specify in there will be deleted.) 
-- Replaces RemoveModifier.
--
-- v 1.10 Added noise to the list.
--
-- v 1.11 Turned off Screen Redraw. Fixed a stupid bug that stops the script from
-- adding a noise modifier. Did some code cleaning.
--
-- v 1.20 Added InstantUV to the list. It also now prints to the listener
-- the number of Modifiers it removed when using the remove modifiers option.
--
-- v 1.21 When applying modifiers to instanced objects, the modifier is only 
-- applied once to an instance, since by the nature of an instance the modifier
-- will automatically get applied to the other instances.
--
-- v 1.30 Added taper and Polyselect to the list.
--
-- v 1.31 dec_sort has now been changed to a new function sort_dec.
--
-- v 1.40 Added FFD 2x2x2 to the list. Fixed a couple of crash bugs. Now when
-- removing it removes by class instead of by name, so if you rename your modifier 
-- it will still get removed properly.
--
-- v 1.41 Added CameraMap. Cleaned the code a bit.
--
-- v 1.42 Another slight modification to add_mod_func in the spirit of
-- spring cleaning.
--
-- v 1.43 Fixed a small bug that stopped you from adding a UVWmap.
--
-- v 1.44 Added Disp Approx.
--
-- v 1.50 Added the ability to delete all modifiers on the selected objects.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global add_mod = "Bend"
global rem_mod = "Bend"

global kill_the_modifiers
global rem_mod_func
global add_mod_func

global mm_floater
global mm_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

mymods = #("Bend", "CameraMap", "Disp_Approx", "Extrude", "FFD_2x2x2", "InstantUV", "MeshSmooth", "NoiseModifier", "Poly_Select", "Relax", "Solidify", "Taper", "UvwMap")
rem_all_mods_value = false
numberkilled = 0

-- Functions

fn kill_the_modifiers obj which_modifiers =
	(
	if which_modifiers.count == 0 then continue
	else
		(
		which_modifiers = (sort_dec which_modifiers)
		for k = 1 to which_modifiers.count do
			(
			deleteModifier obj obj.modifiers[which_modifiers[k]]
			)
		numberkilled += which_modifiers.count
		)
	)

fn rem_mod_func = 
	(
	numberkilled = 0
	undo "ModifierManager" on
		(
		disableSceneRedraw()
		for i in selection do
			(
			if rem_all_mods_value == true then
				(
				num_mods = i.modifiers.count
				if num_mods == 0 then continue
				else
					(
					for j = num_mods to 1 by -1 do
						(
						deleteModifier i i.modifiers[j]
						)
					numberkilled += num_mods
					)
				)
			else
				(
				killit_array = #()
				if i.modifiers.count == 0 then continue
				else
					(
					for j = 1 to i.modifiers.count do
						(
						if classof i.modifiers[j] == (execute rem_mod) then 
						append killit_array j 
						else continue
						)
					)
				kill_the_modifiers i killit_array
				)
			)
		enableSceneRedraw()
		completeRedraw()
		)
	to_print = "Number Of Modifiers Removed: " + (numberkilled as string)
	print to_print
	)
	
fn add_mod_func = 
	(
	undo "ModifierManager" on
		(
		disableSceneRedraw()
		objects_done = #()
		for i in selection do
			(
			if contains_instance objects_done i == false then
				(
				if add_mod == "Bend" and validmodifier i (Bend ()) then addmodifier i (Bend ())
				else if add_mod == "CameraMap" and validmodifier i (CameraMap ()) then addmodifier i (CameraMap ())
				else if add_mod == "Disp_Approx" and validmodifier i (Disp_Approx ()) then addmodifier i (Disp_Approx ())
				else if add_mod == "Extrude" and validmodifier i (Extrude ()) then addmodifier i (Extrude ())
				else if add_mod == "FFD_2x2x2" and validmodifier i (FFD_2x2x2 ()) then addmodifier i (FFD_2x2x2 ())
				else if add_mod == "InstantUV" then
					(
					if instant_uv_test() == true then
						(
						if validmodifier i (InstantUV ()) then addmodifier i (InstantUV ())
						)
					)
				else if add_mod == "MeshSmooth" and validmodifier i (meshsmooth ()) then addmodifier i (meshsmooth ())
				else if add_mod == "NoiseModifier" and validmodifier i (Noisemodifier ()) then addmodifier i (Noisemodifier ())
				else if add_mod == "Poly_Select" and validmodifier i (Poly_Select ()) then addmodifier i (Poly_Select ())
				else if add_mod == "Relax" and validmodifier i (Relax ()) then addmodifier i (Relax ())
				else if add_mod == "Solidify" then
					(
					if solidify_test() == true then
						(
						if validmodifier i (Solidify ()) then addmodifier i (Solidify ())
						)
					)
				else if add_mod == "Taper" and validmodifier i (Taper ()) then addmodifier i (Taper ())
				else if add_mod == "UvwMap" and validmodifier i (Uvwmap ()) then addmodifier i (Uvwmap ())
				)
			append objects_done i
			)
		enableSceneRedraw()
		completeRedraw()
		)
	)
		
-- The Script

rollout mm_rollout "ModifierManager"
	(
	group "Add Modifier"
	(
	dropdownlist add_list "" items:mymods height:15
	button add_list_do "Add Modifier" width:160 align:#center toolTip:"Add Modifier"
	)
	
	on add_list selected i do add_mod = mymods[i]
	on add_list_do pressed do add_mod_func()

	group "Remove Modifier"
	(
	dropdownlist rem_list "" items:mymods height:15
	checkbox rem_all_mods "Remove All Modifiers" checked:rem_all_mods_value
	button rem_list_do "Remove Modifier" width:160 align:#center toolTip:"Remove Modifier"
	)
	
	on rem_list selected i do rem_mod = mymods[i]
	on rem_all_mods changed state do 
		(
		rem_list.enabled = (not (state))
		rem_all_mods_value = state
		)
	on rem_list_do pressed do rem_mod_func()
	)

if mm_floater != undefined then CloseRolloutFloater mm_floater
mm_floater = newRolloutFloater "ModifierManager v1.50" 230 246
addRollout mm_rollout mm_floater
)
-------------------------------------------------------------------------------