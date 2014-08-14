-------------------------------------------------------------------------------
-- SelectInstances.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 03/16/01
-- Modified On: 05/15/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Select any object, and run this script, it will select any objects in your
-- scene that's an instance of your current object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Select any object, and run this script, it will select any objects in 
-- your scene that's an instance of your current object.
--
-- v 1.01 I'm now turning screen redraw off and back on again to speed up
-- performance.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global select_instances

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Functions

fn select_instances myinput = 
(
	disableSceneRedraw()
	iarray = get_instances myinput
	append iarray $ 
	select iarray
	enableSceneRedraw()
	completeRedraw()
)
	
-- Script

if selection.count == 1 then
(
	select_instances selection[1]
)
)
-------------------------------------------------------------------------------