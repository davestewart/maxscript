-------------------------------------------------------------------------------
-- IsolateByMaterial.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 02/22/01
-- Modified On: 03/19/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Like SelectByMaterial, but instead selects all objects in the scene that has 
-- the currently selected meditslot material assigned to it (even if those 
-- objects are hidden) and then hides everything else, effectively isolating the 
-- objects in your scene that have the current material applied to them.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Like SelectByMaterial, but instead selects all objects in the scene that has 
-- the currently selected meditslot material assigned to it (even if those 
-- objects are hidden) and then hides everything else, effectively isolating the 
-- objects in your scene that have the current material applied to them.
-- 
-- v 1.01 Allows Undo.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Variables

material_array = #()

-- Script

undo "IsolateByMaterial" on
	(
	for i in $* do
		(
		if i.material == meditmaterials[medit.GetActiveMtlSlot()] then append material_array i
		)
	for i in material_array do
		(
		if i.ishidden = true then i.ishidden = false
		)
	select material_array
	max hide inv
	completeRedraw()
	)
)
-------------------------------------------------------------------------------