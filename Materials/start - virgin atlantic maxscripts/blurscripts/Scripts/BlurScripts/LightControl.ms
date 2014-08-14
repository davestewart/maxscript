-------------------------------------------------------------------------------
-- LightControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 02/25/01
-- Modified On: 02/27/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-- LightUtilities_Cleaner.ms, http://www.blur.com/blurmaxscripts
-- LightUtilities_Common.ms, http://www.blur.com/blurmaxscripts
-- LightUtilities_Control.ms, http://www.blur.com/blurmaxscripts
-- LightUtilities_Globals.ms, http://www.blur.com/blurmaxscripts
-- LightUtilities_MultiChanger.ms, http://www.blur.com/blurmaxscripts
-- LightUtilities_Order.ms, http://www.blur.com/blurmaxscripts
-- LightUtilities_Tools.ms, http://www.blur.com/blurmaxscripts
-- LightUtilities_Viewer.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- A lightboy type interface that lets you change multiple parameters in your scene
-- lights quickly and easily. This is basically our LightUtilities script but
-- without the extra floater, to be used in case you don't want all the other
-- utilities, just the LightControl Floater.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 A lightboy type interface that lets you change multiple parameters in 
-- your scene lights quickly and easily. This is basically our LightUtilities 
-- script but without the extra floater, to be used in case you don't want all 
-- the other utilities, just the LightControl Floater.
--
-- v 1.01 Moved part of the code out to a new subfile called LightUtilities_Common.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Include

include "$scripts\BlurScripts\BSLib.ms"
include "$scripts\BlurScripts\LightUtilities_Globals.ms"
include "$scripts\BlurScripts\LightUtilities_Common.ms"
include "$scripts\BlurScripts\LightUtilities_Control.ms"
include "$scripts\BlurScripts\LightUtilities_Tools.ms"
include "$scripts\BlurScripts\LightUtilities_Cleaner.ms"
include "$scripts\BlurScripts\LightUtilities_Viewer.ms"
include "$scripts\BlurScripts\LightUtilities_Order.ms"
include "$scripts\BlurScripts\LightUtilities_MultiChanger.ms"

-- Script

if luct_floater != undefined then CloseRolloutFloater luct_floater
if lu_floater != undefined then CloseRolloutFloater lu_floater

luct_full_update()
)
-------------------------------------------------------------------------------