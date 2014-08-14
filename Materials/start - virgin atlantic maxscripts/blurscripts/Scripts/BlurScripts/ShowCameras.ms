-------------------------------------------------------------------------------
-- ShowCameras.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 04/29/01
-- Modified On: 04/29/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Made for hotkey use, if any cameras are visible, the script hides the cameras,
-- if all cameras are hidden, it makes all cameras visible. Good for quickly 
-- hiding and unhiding all your scene cameras. Note: While there is a toggle under
-- display to show or hide cameras, if you hide a cameras and then uncheck that 
-- box, the cameras is still not shown because you manually hid it. This script
-- does not have that limitation.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global all_visible = true

-- Script

for c in cameras do
	(
	if c.ishidden == true then 
		(
		all_visible = false
		exit
		)
	else continue
	)

c = Freecamera()
delete c

for c in cameras do
	(
	c.ishidden = all_visible
	)
completeredraw()
)
-------------------------------------------------------------------------------