-------------------------------------------------------------------------------
-- AssignObjectMatte.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.03
-- Created On: 10/09/00
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
-- on objects that are being used to block non Matte objects and that don't 
-- need to cast or recieve shadows.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Assigns a matte material to selected objects for use with compositing. 
-- Use on objects that are being used to block non Matte objects and that don't 
-- need to cast or recieve shadows.
--
-- v 1.01 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.02 Cleaned the code a bit.
--
-- v 1.03 The material definitions have been moved into BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Script

undo "AssignObjectMatte" on
(
	m = copy (get_blurmat "Matte_Object")
	for i in selection do
	(
		i.material = m
		i.castShadows = off
		i.receiveshadows = off
	)
)
)
-------------------------------------------------------------------------------