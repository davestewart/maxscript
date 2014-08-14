-------------------------------------------------------------------------------
-- RandomFaceRemover.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.12
-- Created On: 08/08/00
-- Modified On: 06/20/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes any Editable Mesh or Editable Poly, collapses it, and then randomly 
-- removes faces based on a weight or percentage value. Made to remove random 
-- faces from a particle emitter object, hence randomizing where particles tend 
-- to be emitted.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes any mesh object, converts it to an editable mesh, then rendomly 
-- removes faces based on a weight your specify (0 means no faces are removed, 
-- 100 means all faces are removed, 50 means that a face has a 50% chance of going 
-- away. Made to remove random faces from a particle emitter object, hence 
-- randomizing where particles tend to be emitted.
--
-- v 1.10 Added ability to select by percentage as well as the original weight.
-- Also broke out some of the script into BSLib.ms. Compatible now with R4.
--
-- v 1.11 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.12 Major code cleaning, moved some stuff to BSLib. Works with Editable 
-- Polys.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global remove_random_faces
global rfr_filters

global rfr_rollout
global rfr_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

weight_value = 50
percentage_value = 50

error_occured = false
delete_array = #()

-- Functions

fn remove_random_faces obj removetype = 
	(
	if obj.faces.count != 0 then
		(
		delete_array = #()
		
		a = (for i = 1 to obj.faces.count collect i)
		
		if removetype == 1 then delete_array = choose_unique_by_weight a weight_value
		else delete_array = choose_unique_by_percentage a percentage_value
			
		delete obj.faces[delete_array]
		delete_array = #()
		)
	)
	
fn rfr_filters removetype =
	(
	undo "RandomFaceRemover" on
		(
		error_occured = false
		for i in selection do 
			(
			if classof i == Editable_Poly or classof i == PolyMeshObject then convertTo i PolyMeshObject
			else if classof i == Editable_mesh then convertTo i TriMeshGeometry
			else error_occured = true
	
			if error_occured == false then remove_random_faces i removetype
			)
		if error_occured == true then (MessageBox "At least one object in your selection was not an Editable Mesh or Editable Poly object, and was not affected." title:"RandomFaceRemover")
		)
	)
	
-- Script

rollout rfr_rollout "RandomFaceRemover"
	(
	spinner weight_spinner "Weight:" range:[0,100,50] type:#integer fieldWidth:40 across:2 align:#right offset:[9,0] 
	button do_weight "Remove Faces" width:100 toolTip:"Remove Faces" align:#right
	spinner per_spinner "Percentage %:" range:[0,100,50] type:#float fieldWidth:40 across:2 align:#right offset:[9,0]
	button do_per "Remove Faces" width:100 toolTip:"Remove Faces" align:#right

	on weight_spinner changed val do weight_value = val
	on per_spinner changed val do percentage_value = val
	
	on do_weight pressed do rfr_filters 1
	on do_per pressed do rfr_filters 2
	)

if rfr_floater != undefined then CloseRolloutFloater rfr_floater
rfr_floater = newRolloutFloater "RandomFaceRemover v1.12" 290 121
addRollout rfr_rollout rfr_floater
)
-------------------------------------------------------------------------------