-------------------------------------------------------------------------------
-- RandomFaceSelect.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 06/05/01
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
-- selects faces based on a weight or percentage value.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- You'll get an assert fail if you do the following: Create a sphere, convert 
-- to editable poly, use the script on it, and then try and bevel the object.
-- Looks like a max bug, more info when I've got it, in the meantime, avoid doing 
-- that.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global select_random_faces
global rfs_filters

global rfs_rollout
global rfs_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

weight_value = 50
percentage_value = 50

select_array = #()

-- Functions

fn select_random_faces obj selecttype = 
	(
	if obj.faces.count != 0 then
		(
		subobjectLevel = 4
		select_array = #()
		
		a = (for i = 1 to obj.faces.count collect i)
		
		if selecttype == 1 then select_array = choose_unique_by_weight a weight_value
		else select_array = choose_unique_by_percentage a percentage_value
		
		select obj.faces[select_array]
		select_array = #()
		)
	)
	
fn rfs_filters selecttype =
	(
	undo "RandomFaceSelect" on
		(
		if selection.count == 1 then
			(
			for i in selection do
				(
				if classof i == Editable_Poly or classof i == PolyMeshObject then 
					(
					convertTo i PolyMeshObject
					select_random_faces i selecttype
					)
				else if classof i == Editable_mesh then
					(
					convertTo i TriMeshGeometry
					select_random_faces i selecttype
					)
				else (MessageBox "The object is not a PolyObject or Editable Mesh." title:"RandomFaceSelect")
				)
			)
		else (MessageBox "Please select only one object." title:"RandomFaceSelect")
		)
	)
	
-- Script

rollout rfs_rollout "RandomFaceSelect"
	(
	spinner weight_spinner "Weight:" range:[0,100,50] type:#integer fieldWidth:40 across:2 align:#right offset:[9,0] 
	button do_weight "Select Faces" width:100 toolTip:"Select Faces" align:#right
	spinner per_spinner "Percentage %:" range:[0,100,50] type:#float fieldWidth:40 across:2 align:#right offset:[9,0]
	button do_per "Select Faces" width:100 toolTip:"Select Faces" align:#right

	on weight_spinner changed val do weight_value = val
	on per_spinner changed val do percentage_value = val
	
	on do_weight pressed do rfs_filters 1
	on do_per pressed do rfs_filters 2
	)

if rfs_floater != undefined then CloseRolloutFloater rfs_floater
rfs_floater = newRolloutFloater "RandomFaceSelect v1.00" 290 121
addRollout rfs_rollout rfs_floater
)
-------------------------------------------------------------------------------