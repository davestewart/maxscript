-------------------------------------------------------------------------------
-- ShowLights.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.02
-- Created On: 10/09/00
-- Modified On: 05/17/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Made for hotkey use, if any lights are visible, the script hides the lights,
-- if all lights are hidden, it makes all light visible. Good for quickly 
-- hiding and unhiding all your scene lights. Note: While there is a toggle under
-- display to show or hide lights, if you hide a light and then uncheck that 
-- box, the light is still not shown because you manually hid it. This script
-- does not have that limitation.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Made for hotkey use, if any lights are visible, the script hides the lights,
-- if all lights are hidden, it makes all light visible. Good for quickly 
-- hiding and unhiding all your scene lights. Note: While there is a toggle under
-- display to show or hide lights, if you hide a light and then uncheck that 
-- box, the light is still not shown because you manually hid it. This script
-- does not have that limitation.
--
-- v 1.01 Now makes sure that the hide by category light filter is off when unhiding
-- lights.
--
-- v 1.02 Moved the whole damn script to BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Script

show_lights()
)
-------------------------------------------------------------------------------