-------------------------------------------------------------------------------
-- FindByMaterial.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 02/22/01
-- Modified On: 05/23/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Like SelectByMaterial, but instead just gives you a list of all scene objects
-- that have the currently selected meditslot material assigned to it.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Like SelectByMaterial, but instead just gives you a list of all scene 
-- objects that have the currently selected meditslot material assigned to it.
--
-- v 1.01 Now sorts the material_array before displaying. Changed the name of 
-- some variables.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Variables

fbm_obj_array = #()
fbm_obj_string = ""

-- Script

for i in $* do
	(
	if i.material == meditmaterials[medit.GetActiveMtlSlot()] then append fbm_obj_array i
	)
qsort fbm_obj_array name_compare_case_insensitive
for i in fbm_obj_array do
	(
	fbm_obj_string += i.name as string
	fbm_obj_string += "\n"
	)
MessageBox fbm_obj_string title:"FindByMaterial"
)
-------------------------------------------------------------------------------