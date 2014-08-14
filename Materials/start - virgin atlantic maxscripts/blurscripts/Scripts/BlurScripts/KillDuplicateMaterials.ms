-------------------------------------------------------------------------------
-- KillDupicateMaterials.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 06/06/01
-- Modified On: 06/20/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Goes through your scene, and will remove all materials that have duplicate 
-- names. Does not work on subobject materials.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global kill_dup_mats

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Functions

fn kill_dup_mats = 
(
	scene_mats = get_scene_materials()
	scene_mats_names = for i in scene_mats collect i.name
	
	for i in $* do
	(
		if i.material != undefined then
		(
			w = finditem scene_mats_names i.material.name
			i.material = scene_mats[w]
		)
	)
)

-- The Script

if (queryBox "Remove all Duplicate Materials In This Scene?" title:"KillDupicateMaterials") == true then kill_dup_mats()
)
-------------------------------------------------------------------------------