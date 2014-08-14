-------------------------------------------------------------------------------
-- PrepFamous.ms
-- By Brandon Davis (brandon@blur.com) and Neil Blevins (soulburn@blur.com)
-- v 1.12
-- Created On: 01/24/01
-- Modified On: 02/15/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Famous Faces, http://www.metamotion.com/
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Turns the tedious process of preparing a character for use with Famous Faces.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- To run famous faces on a head that's being affected by biped and some form
-- of deformation modifier (such as physique, bones pro or skin), the biped
-- needs to be placed in figure mode, and all modifiers on the skin need to be 
-- turned off except for the famous modifier. Once this is done, the animator
-- can go to famous through the famous modifier, make changes, and then once 
-- they return to max, they can hit the revert button to go back to their 
-- initial stage. This script automates the process.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History
--
-- v 1.10 Streamlined the process so that it didn't rely on selections. Added scene
-- checking to handle deleted core level objects without crashing.  Added selection
-- filters to pickbuttons.  Set the picked_biped to find the biped root object no
-- matter which part you select.
--
-- v 1.11 Fully compatible with r4.0, and uses BSLib for several functions.
--
-- v 1.12 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global prep_scene_changed
global prepare_bip
global revert_bip

global Prep_rollout
global Prep_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

global picked_skin = undefined
global picked_biped = undefined
global picked_biped_root = undefined

-- Functions

fn prep_scene_changed =
	(
	if isdeleted picked_skin == true or isdeleted picked_biped == true then return true
	else return false	
	)

fn prepare_bip =
	(
	picked_biped_root = get_biped_root picked_biped
	picked_biped_root.transform.controller.figuremode = true
	for i in picked_skin.modifiers do
		(
		if classof i == Famous then
			(
			i.enabled = true
			)
		else i.enabled = false
		)
	)
	
fn revert_bip =
	(
	picked_biped_root.transform.controller.figuremode = false
	picked_skin.modifiers.enabled = true
	)

-- The Script

rollout Prep_rollout "PrepFamous" 
	(
	group "Select" 
	(
	checkbutton toggle_skin "H" pos:[13,26] width:20 height:21 align:#left across:2 tooltip:"Hide/Unhide Skin"
	pickbutton select_skin "Skin Object" pos:[37,26] width:70 height:21 tooltip:"Select Skin Object" filter:geometry_filter
	checkbutton toggle_biped "H" pos:[13,52] width:20 height:21 align:#left across:2 tooltip:"Hide/Unhide Biped"
	pickbutton select_biped "Biped Root" pos:[37,52] width:70 height:21 enabled:false tooltip:"Select Biped" filter:biped_filter
	)
	
	group "Action" 
	(
	button prep_famous "Prepare" pos:[10,103] width:100 height:25 enabled:false tooltip:"Prepare the object for editing with Famous Faces"
	button rev_famous "Revert" pos:[10,133] width:100 height:25 enabled:false tooltip:"Revert the object back to its original state"
	)
		
	on select_skin picked obj do
	(
	select_skin.text = obj.name
	picked_skin = select_skin.object
	select_biped.enabled = true
	)

	on select_biped picked obj do
	(
	select_biped.text = obj.name
	picked_biped = select_biped.object
	prep_famous.enabled = true
	)

	on toggle_skin changed state do
		if state == on
			then hide picked_skin
			else unhide picked_skin	
	
	on toggle_biped changed state do
		if state == on
			then hide $*bip*
			else unhide $*bip*	

	on prep_famous pressed do
	(
	if prep_scene_changed () == true then
		(
		MessageBox "One of your core level objects has been deleted.  Please restart the script."
		CloseRolloutFloater Prep_floater
		)
	else 
		(
		rev_famous.enabled = true
		prepare_bip()
		)
	)

	on rev_famous pressed do
	(
	if prep_scene_changed () == true then
		(
		MessageBox "One of your core level objects has been deleted.  Please restart the script."
		CloseRolloutFloater Prep_floater
		)
	else revert_bip()
	)
	)

if Prep_floater != undefined then CloseRolloutFloater Prep_floater
Prep_floater = newRolloutFloater "PrepFamous v1.12" 150 230
addRollout Prep_rollout Prep_floater
)
-------------------------------------------------------------------------------


