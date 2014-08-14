-------------------------------------------------------------------------------
-- PivotPlacer.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 09/23/00
-- Modified On: 06/30/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description: 
-- A quick and painless way to place an object's pivot at 27 places on the 
-- object's bounding box. Two modes exist, local, that aligns the pivot with the
-- "local" bounding box (ie, it takes rotational information into account), or
-- world that'll align the pivot with the object's bounding box with respect
-- to the world axis.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 A quick and painless way to place an object's pivot at 27 places on the 
-- object's bounding box. Two modes exist, local, that aligns the pivot with the
-- "local" bounding box (ie, it takes rotational information into account), or
-- world that'll align the pivot with the object's bounding box with respect
-- to the world axis.
--
-- v 1.01 Fixed a bug where the images buttons would return an error if used 
-- as a macroscript.
--
-- v 1.02 Changed the way the images are included with the script from $scripts
-- to getdir #scripts. Also combined the three icons into a single file.
--
-- v 1.10 Added code which allows groups to have their pivot affected as either
-- a single object or as a collection of individual objects.
--
-- v 1.11 Moved the options group to a new rollout
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global move_the_pivot

global pp_floater
global pp_rollout
global pp_options_rollout

-- Variables

transtype_value = 1
im1 = (getdir #scripts) + "\\BlurScripts\\" + "PivotPlacer_images.bmp"
pp_groups_value = true

-- Functions

fn move_the_pivot location = 
(
	undo "PivotPlacer" on
	(
		error = 0
		if selection.count != 0 then
		(
			for obj in selection do
			(
				if isgroupmember obj == true and pp_groups_value == true then continue
				else
				(
					if superclassof obj == GeometryClass or superclassof obj == shape or superclassof obj == helper then
					(
						try	
						(
							if transtype_value == 1 then
							(
								org_center = [(obj.max.x+obj.min.x)/2, (obj.max.y+obj.min.y)/2, (obj.max.z+obj.min.z)/2]
								org_rot = coordsys world obj.rotation
								obj.rotation = quat 0 0 0 1
							)
						) 
						catch (error = 1)
		
						if location == 1 then try (obj.pivot = [obj.min.x, obj.min.y, obj.max.z]) catch (error = 1)
						if location == 2 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, obj.min.y, obj.max.z]) catch (error = 1)
						if location == 3 then try (obj.pivot = [obj.max.x, obj.min.y, obj.max.z]) catch (error = 1)
						if location == 4 then try (obj.pivot = [obj.min.x, obj.min.y, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 5 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, obj.min.y, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 6 then try (obj.pivot = [obj.max.x, obj.min.y, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 7 then try (obj.pivot = [obj.min.x, obj.min.y, obj.min.z]) catch (error = 1)
						if location == 8 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, obj.min.y, obj.min.z]) catch (error = 1)
						if location == 9 then try (obj.pivot = [obj.max.x, obj.min.y, obj.min.z]) catch (error = 1)
		
						if location == 10 then try (obj.pivot = [obj.min.x, (obj.max.y+obj.min.y)/2, obj.max.z]) catch (error = 1)
						if location == 11 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, (obj.max.y+obj.min.y)/2, obj.max.z]) catch (error = 1)
						if location == 12 then try (obj.pivot = [obj.max.x, (obj.max.y+obj.min.y)/2, obj.max.z]) catch (error = 1)
						if location == 13 then try (obj.pivot = [obj.min.x, (obj.max.y+obj.min.y)/2, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 14 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, (obj.max.y+obj.min.y)/2, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 15 then try (obj.pivot = [obj.max.x, (obj.max.y+obj.min.y)/2, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 16 then try (obj.pivot = [obj.min.x, (obj.max.y+obj.min.y)/2, obj.min.z]) catch (error = 1)
						if location == 17 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, (obj.max.y+obj.min.y)/2, obj.min.z]) catch (error = 1)
						if location == 18 then try (obj.pivot = [obj.max.x, (obj.max.y+obj.min.y)/2, obj.min.z]) catch (error = 1)
		
						if location == 19 then try (obj.pivot = [obj.min.x, obj.max.y, obj.max.z]) catch (error = 1)
						if location == 20 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, obj.max.y, obj.max.z]) catch (error = 1)
						if location == 21 then try (obj.pivot = [obj.max.x, obj.max.y, obj.max.z]) catch (error = 1)
						if location == 22 then try (obj.pivot = [obj.min.x, obj.max.y, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 23 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, obj.max.y, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 24 then try (obj.pivot = [obj.max.x, obj.max.y, (obj.max.z+obj.min.z)/2]) catch (error = 1)
						if location == 25 then try (obj.pivot = [obj.min.x, obj.max.y, obj.min.z]) catch (error = 1)
						if location == 26 then try (obj.pivot = [(obj.max.x+obj.min.x)/2, obj.max.y, obj.min.z]) catch (error = 1)
						if location == 27 then try (obj.pivot = [obj.max.x, obj.max.y, obj.min.z]) catch (error = 1)
		
						try 
						(
							if transtype_value == 1 then
							(
								obj.rotation = org_rot
		
								mid_pivot = obj.pivot
								obj.pivot = [(obj.max.x+obj.min.x)/2, (obj.max.y+obj.min.y)/2, (obj.max.z+obj.min.z)/2]
								mid_pos = obj.pos
								obj.pos = org_center
								deltapos = obj.pos - mid_pos
								obj.pivot = mid_pivot + deltapos
							)
						) 
						catch (error = 1)
					)
				)
			)
		)
		if error == 1 then (MessageBox "At least one object in your selection has a pivot that could not be changed." title:"PivotPlacer")
	)
)
	
-- The Script

rollout pp_rollout "PivotPlacer"
(
	Group "Front:"
	(
		button but_f1 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1) across:3
		button but_f2 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_f3 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_f4 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1) across:3
		button but_f5 width:15 align:#center images:#(im1, undefined, 3, 2, 2, 2, 2)
		button but_f6 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_f7 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1) across:3
		button but_f8 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_f9 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
	)
	Group "Middle:"
	(
		button but_m1 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1) across:3
		button but_m2 width:15 align:#center images:#(im1, undefined, 3, 2, 2, 2, 2)
		button but_m3 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_m4 width:15 align:#center images:#(im1, undefined, 3, 2, 2, 2, 2) across:3
		button but_m5 width:15 align:#center images:#(im1, undefined, 3, 3, 3, 3, 3)
		button but_m6 width:15 align:#center images:#(im1, undefined, 3, 2, 2, 2, 2)
		button but_m7 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1) across:3
		button but_m8 width:15 align:#center images:#(im1, undefined, 3, 2, 2, 2, 2)
		button but_m9 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
	)
	Group "Back:"
	(
		button but_b1 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1) across:3
		button but_b2 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_b3 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_b4 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1) across:3
		button but_b5 width:15 align:#center images:#(im1, undefined, 3, 2, 2, 2, 2)
		button but_b6 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_b7 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1) across:3
		button but_b8 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
		button but_b9 width:15 align:#center images:#(im1, undefined, 3, 1, 1, 1, 1)
	)

	on but_f1 pressed do move_the_pivot 1
	on but_f2 pressed do move_the_pivot 2
	on but_f3 pressed do move_the_pivot 3
	on but_f4 pressed do move_the_pivot 4
	on but_f5 pressed do move_the_pivot 5
	on but_f6 pressed do move_the_pivot 6
	on but_f7 pressed do move_the_pivot 7
	on but_f8 pressed do move_the_pivot 8
	on but_f9 pressed do move_the_pivot 9

	on but_m1 pressed do move_the_pivot 10
	on but_m2 pressed do move_the_pivot 11
	on but_m3 pressed do move_the_pivot 12
	on but_m4 pressed do move_the_pivot 13
	on but_m5 pressed do move_the_pivot 14
	on but_m6 pressed do move_the_pivot 15
	on but_m7 pressed do move_the_pivot 16
	on but_m8 pressed do move_the_pivot 17
	on but_m9 pressed do move_the_pivot 18

	on but_b1 pressed do move_the_pivot 19
	on but_b2 pressed do move_the_pivot 20
	on but_b3 pressed do move_the_pivot 21
	on but_b4 pressed do move_the_pivot 22
	on but_b5 pressed do move_the_pivot 23
	on but_b6 pressed do move_the_pivot 24
	on but_b7 pressed do move_the_pivot 25
	on but_b8 pressed do move_the_pivot 26
	on but_b9 pressed do move_the_pivot 27

	dropdownlist transtype "" items:#("Local", "World")
	on transtype selected i do transtype_value = i
)
	
rollout pp_options_rollout "Options"
(
	checkbox treat_groups "Treat Group" checked:true
	label label1 "as Single Obj"
	on treat_groups changed state do 
	(
		if treat_groups.checked == true then pp_groups_value = true
		else pp_groups_value = false
	)
)

if pp_floater != undefined then CloseRolloutFloater pp_floater
pp_floater = newRolloutFloater "PivotPlacer v1.11" 130 374
addRollout pp_rollout pp_floater
addRollout pp_options_rollout pp_floater rolledup:true
)
-------------------------------------------------------------------------------