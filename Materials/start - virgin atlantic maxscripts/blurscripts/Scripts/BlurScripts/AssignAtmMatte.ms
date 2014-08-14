-------------------------------------------------------------------------------
-- AssignAtmMatte.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 06/29/01
-- Modified On: 08/03/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Assigns a matte material to selected objects for use with compositing. Use
-- on objects that will be used to render out an atmospheric pass.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Assigns a matte material to selected objects for use with compositing. 
-- Use on objects that will be used to render out an atmospheric pass.
--
-- v 1.01 The material definitions have been moved into BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Script

undo "AssignAtmMatte" on
(
	m = copy (get_blurmat "Matte_Atmosphere")
	for i in selection do
	(
		i.material = m
	)
)
)
-------------------------------------------------------------------------------