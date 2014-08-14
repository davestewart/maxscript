-------------------------------------------------------------------------------
-- ReloadSelectedSlot.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.02
-- Created On: 10/09/00
-- Modified On: 03/09/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Reloads all bitmaps that exist in the material in your currently selected 
-- material slot.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Reloads all bitmaps that exist in the material in your currently 
-- selected material slot.
--
-- v 1.01 Fixed a bug that caused the script to not work on Blend Materials,
-- Multi/sub-object materials, etc. The script is now slower because it has
-- to search through more stuff, but at least now it's sure to get everything.
--
-- v 1.02 Removed reload_the_bitmaps function to BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Script

reload_bitmaps meditMaterials[medit.GetActiveMtlSlot()]
-------------------------------------------------------------------------------