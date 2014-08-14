-------------------------------------------------------------------------------
-- ReloadAllBitmaps.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.13
-- Created On: 02/24/01
-- Modified On: 07/09/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Reloads all bitmaps that exist in all scene materials and medit slots.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Reloads all bitmaps that exist in all scene materials and medit slots.
--
-- v 1.01 Fixed a bug that caused the script to not work on Blend Materials,
-- Multi/sub-object materials, etc. The script is now slower because it has
-- to search through more stuff, but at least now it's sure to get everything.
--
-- v 1.10 Now the script makes a floater that lets you choose to reload just the
-- scene materials or just the materials editor. I did this primarily to speed
-- the script up, since it takes awhile for the tree traversal to happen, so the
-- user can choose exactly what they want reloaded. Removed reload_all_bitmaps
-- function to BSLib.
--
-- v 1.11 SceneMaterials code now replaced with get_scene_materials().
--
-- v 1.12 Replaced get_scene_materials() everywhere in code with variable scene_mats.
--
-- v 1.13 Cleaned some code.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global rab_reload_scene
global rab_reload_medit

global rab_rollout
global rab_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Functions

fn rab_reload_scene = 
	(
	progressStart "Reload Bitmaps in Scene"
	escapeEnable = false
	scene_mats = get_scene_materials()
	itemnum = scene_mats.count
	if itemnum != 0 then
		(
		for i = 1 to itemnum do
			(
			reload_bitmaps scene_mats[i]
			m = ((i as float)/(itemnum as float))*100
			progressUpdate m
			)
		)
	progressEnd()
	)
	
fn rab_reload_medit = 
	(
	progressStart "Reload Bitmaps in Medit"
	escapeEnable = false
	itemnum = 24
	for i = 1 to itemnum do
		(
		reload_bitmaps meditmaterials[i]
		m = ((i as float)/(itemnum as float))*100
		progressUpdate m
		)
	progressEnd()
	)

-- Script

rollout rab_rollout "ReloadAllBitmaps"
	(
	button button_rab_scene "Reload Bitmaps in Scene" width:170 align:#center toolTip:"Reload Bitmaps in Scene"
	button button_rab_medit "Reload Bitmaps in Medit" width:170 align:#center toolTip:"Reload Bitmaps in Medit"
	button button_rab_all "Reload All Bitmaps" width:170 align:#center toolTip:"Reload All Bitmaps"
	on button_rab_scene pressed do rab_reload_scene()
	on button_rab_medit pressed do rab_reload_medit()
	on button_rab_all pressed do 
		(
		rab_reload_scene()
		rab_reload_medit()
		)
	)

if c != undefined then CloseRolloutFloater rab_floater
rab_floater = newRolloutFloater "ReloadAllBitmaps v1.12" 230 147
addRollout rab_rollout rab_floater
)
-------------------------------------------------------------------------------