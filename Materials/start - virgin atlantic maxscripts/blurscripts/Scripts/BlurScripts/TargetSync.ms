-------------------------------------------------------------------------------
-- TargetSync.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 06/02/01
-- Modified On: 06/02/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes all your cameras and lights in the scene, and changes the name of their
-- targets to properly reflect the name of their parent camera or light.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global target_sync_func

-- Functions

fn target_sync_func = 
	(
	for i in $* do
		(
		if superclassof i == light or superclassof i == camera then
			(
			if i.target != undefined then i.target.name = i.name + ".Target"
			)
		)
	)

-- The Script

if (queryBox "Sync light and camera target names in the scene to their parent light or camera?" title:"TargetSync") == true then target_sync_func()
)
-------------------------------------------------------------------------------