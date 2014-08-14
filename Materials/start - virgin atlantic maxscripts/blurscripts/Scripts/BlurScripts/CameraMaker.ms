-------------------------------------------------------------------------------
-- CameraMaker.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 2.30
-- Created On: 07/31/99
-- Modified On: 11/02/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes any perspective viewport that is currently active and creates a camera
-- with the same perspective, and changes that view into the view of the 
-- camera. In short, changes your view from a perspective to a camera view in 
-- one click (without having to create a camera, select it, match it using the 
-- match to perspective function, and then switching the current view to the 
-- newly created camera.) Also works if you select a camera view to convert to 
-- a second camera view with the same perspective. Not recommended for use with
-- orthogonal views, but it still works (sorta).
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes any perspective viewport that is currently active and creates a 
-- camera with the same perspective, and changes that view into the view of the 
-- camera. In short, changes your view from a perspective to a camera view in 
-- one click (without having to create a camera, select it, match it using the 
-- match to perspective function, and then switching the current view to the 
-- newly created camera.) Also works if you select a camera view to convert to 
-- a second camera view with the same perspective. Not recommended for use with
-- orthogonal views, but it still works (sorta).
--
-- Special thanks to Larry Minton for the MatchCameraToViewport function. I 
-- really only wrote the last three lines of code and came up with the idea, 
-- so Larry deserves most of the credit.
-- 
-- v 2.00 is a rewrite using a new algorithm based on code originally written 
-- by Andrew Marek
--
-- v 2.01 fixes a bug that caused the target to be too close to the camera
-- under certain conditions. Thanks to Scott Kirvan for some math and 
-- inspiration here.
--
-- v 2.10 Now it displays a safeframe. Also fixed a bug where the target would
-- have a wrong name. However, the camera and target name remain unlinked, 
-- unlike a camera made using conventional methods.
--
-- v 2.20 Now accurately converts the perspective view's FOV to your new camera.
--
-- v 2.21 The script no longer affects your selection set. This was done to 
-- prevent a crash that would occur if you had the "Lock Selection Set" button
-- on when the script was initialized.
--
-- v 2.30 Compatible with R4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
focdistance = gw.GetFocalDist()
cp = mapscreentoworldray (getviewsize()/2)
ct = targetobject position:(cp.pos+(cp.dir*focdistance))
fov_value = getViewFOV()

NewCamera = targetcamera pos:cp.pos target:ct
NewCamera.fov = fov_value
NewCamera.target.name = NewCamera.name + ".Target"
viewport.setCamera NewCamera
displaySafeFrames = true
-------------------------------------------------------------------------------