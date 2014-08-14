-------------------------------------------------------------------------------
-- LightUtilities.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 2.91
-- Created On: 05/13/00
-- Modified On: 02/18/02
-- tested using Max 4.2
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
-- A whole bunch of useful utilities relating to lights, including a lightboy
-- type floater, utilities for turning your scene lights on and off en masse, 
-- removing unnecesary attenuation range clutter, and a viewer to let you
-- view the influence of a particular light. 
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- You can perform a function on all lights, all selected lights, or o-selected 
-- lights (the little checkbutton beside each light in the LightControl panel). 
-- This lets you perform functions on sets of lights independent of your selection
-- set.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- Problems can occur if you hit Enter after changing a light's name in LightControl.
-- This appears to be a max bug, so if you want to avoid it, either hit Tab after
-- renaming the light instead of Enter, or don't use LightControl to rename your 
-- lights.
--
-- The interface can get slow when you have a lot of lights in your scene. This
-- is a limitation of maxscript, and I apologize, but there's little I can do
-- to solve the problem since the slow refresh time is due to the time it takes
-- to redraw the ui, which I have very little control over. I suggest smart use
-- of the filtering capabilities in LightControl is your best bet.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Turns on or off various parameters in all selected lights (show 
-- attenuation, show cone, etc). This lets you quickly "clean" your viewport of 
-- unneeded mess when you have lots of lights in your scene.
--
-- v 1.10 Andri Xhitomi (zhubra@yahoo.com) was nice enough to add some more
-- options and make a different UI for this script. I then went in and added a 
-- few changes of my own to the new code. Thanks again dude.
--
-- v 1.20 Added buttons to turn all the lights in a scene on or off. Cleaned 
-- the code a bit. Added R4 Compatability. Added code to stop the script from 
-- crashing if it encounters a light type it doesn't understand (like Shag 
-- Hair Lights). Started using some BSLib functions. Script renamed to 
-- LightUtilities.ms
--
-- v 2.00 Added LightViewer as part of this utility, and combined it with a 
-- Lightboy type selector interface that has two uses, 1) it can replace lightboy
-- (offering several more options), and 2) it lets you quickly select lights
-- in your scene on which to perform the light utility options. And I added a 
-- bunch of new functionality to the various utilities present. I'd like to
-- thank Scott and Steve for lightboy related information, and David Humpherys,
-- from whom I lifted a line or two of code.
--
-- v 2.10 Added ability to convert your current selection set to an operational 
-- selection set.
--
-- v 2.20 The script was getting so complex it was hard to read and manage, so I
-- broke it out into 6 seperate scripts, which are all controled by the main
-- LightUtilities.ms (all the other scripts don't do anything on their own, but
-- are called by LightUtilities.ms as includes). Also added the option to choose
-- the order lights are rendered in when doing a cumulative LightViewer render.
-- Fixed an r4 bug that stopped the script from properly reporting the
-- castshadow value of a light.
--
-- v 2.30 Changed the way change handlers are handled (haha!) so that they get
-- created and destroyed a lot less frequently, which may help speed up the
-- autoupdate function. Added the option to have the script function on "all", 
-- "selected" or "o-selected" lights. Renamed operational select to "o-select" 
-- in interface. Also added a filter under LightControl options to have it
-- show just the lights you have currently selected in the scene, as well as just
-- showing the light you currently have an operatinal select on.
--
-- v 2.40 Added a MultiChanger which allows you to affect the parameters of many
-- lights at the same time.
--
-- v 2.50 Added a way to turn off atmospherics in LightViewer.
--
-- v 2.51 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 2.60 Fixed a bug where Lightviewer would not work properly on instanced 
-- lights. Moved some stuff around, including making a new subfile called
-- LightUtilities_Globals in order to get the script LightControl to work. Fixed
-- a bug where LightViewer would return wrong results if you renamed a light 
-- before hitting the view button and the script hadn't had a chance to update 
-- yet. When you do a multichange now, the script then updates the LightControl
-- floater.
--
-- v 2.61 Fixed a bug that would screw up target lights if you ran LightViewer.
--
-- v 2.62 In order to fix a bug where only one vfb would appear at the end of
-- using the LightViewer script (this only seemed to happen in certain files
-- for some reason), I split things up a bit, now you have control
-- over viewing a single vfb where the images being rendered, control over 
-- loading the resulting images at the end of the script operation, and saving
-- those images to disk or not (as before). Moved part of the code out to a new 
-- subfile called LightUtilities_Common. Added a new mode in LightControl that 
-- lets you filter out instances of the same light. Added a checkbox to have
-- Lights in LightControl that are instanced appear in bold. Added a standard
-- max path dialogue box instead of the original text field.
--
-- v 2.63 Changed the format of the path button in LightViewer to reflect the 
-- new path buttons added to a bunch of other BlurScripts, including DepthMatte,
-- Rendercam, MaterialRipper and SceneRipper.
--
-- v 2.64 Increased the amount of text that can be seen in the name box in
-- LightControl. Added more details to the error message that occurs when you
-- get an error when trying to save a file using LightViewer.
--
-- v 2.70 A whole bunch of bugs and features... 
-- 1) Removed the code that allows longer light names in LightControl, because 
-- it was screwing up too many other things. That is a discreet bug, and hopefully 
-- will get fixed on their end in the next release allowing us to have longer 
-- names in editboxes.
-- 2) Added two new tools, isolate lights, and showlights.
-- 3) Added a bunch of new things that LightMultiChanger can affect.
--
-- v 2.80 A whole bunch of bugs and features... 
-- Added even more parameters to the LightControl dialog, which can be added
-- or removed using the checkboxes at the top of the floater. The LightOrder
-- dialog is now modal. Cleaned a bunch of code to get everything to run faster.
--
-- v 2.81 The path label has been replaced with a path editbox.
--
-- v 2.90 Added relative and absolute modes to multichanger. Fixed the bug 
-- where turning off atmospherics in a maxscript render turns off atmospherics 
-- for the current renderer as well. Changed code so the script now queries
-- the shadowclass of a light to decide what shadow type it has. Changing
-- shadow types in LightControl now refreshes the dialogue. Changing shadow types
-- in Multichanger happens first, so subsequent operations occur on the proper
-- shadow type. Redid the LightTools Interface, and added a ton of functionality.
-- Fixed the lengend key in LightControl so it shows the proper values, no matter 
-- what parameters are currently visible. Now the three rollouts in LightControl 
-- remain open upon update if you left them open when update was called. You 
-- can now sort the lights in lightcontrol by light type.
--
-- v 2.91 Added an update for after the delete lights function is called.
-- Cleaned the code a bit in isolate lights and added an unhide to lights so 
-- hidden lights would still get isolated properly.
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

lu_floater = newRolloutFloater "LightUtilities v2.91" 250 412 lu_oldpos.x lu_oldpos.y

addRollout luw_rollout lu_floater
addRollout lut_rollout lu_floater rolledup:true
addRollout luc_rollout lu_floater rolledup:true
addRollout luv_rollout lu_floater
addRollout lum_rollout lu_floater rolledup:true

luct_full_update()
)
-------------------------------------------------------------------------------