-------------------------------------------------------------------------------
-- SelectByNoMaterial.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 10/25/01
-- Modified On: 10/25/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Checks every object in your scene, if no material is applied the object
-- is selected.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
sbnm_mat_array = #()
for i in $* do
(
	if i.material == undefined then append sbnm_mat_array i
)
select sbnm_mat_array
)
-------------------------------------------------------------------------------