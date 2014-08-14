-------------------------------------------------------------------------------
-- BoxSkeleton.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.10
-- Created On: 05/28/00
-- Modified On: 11/02/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Character Studio, http://www.discreet.com/
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Creates a set of boxes and attaches them to the bones of a biped. We've had
-- some issues here at blur before where bonespro has had trouble deforming 
-- objects when a biped was the bone system, so this creates a new bone system 
-- of boxes, you link bonespro to the boxes instead of the biped bones, and
-- then move the biped as normal, the bones will follow, and the mesh will now
-- follow as well.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Creates a set of boxes and attaches them to the bones of a biped. We've 
-- had some issues here at blur before where bonespro has had trouble deforming 
-- objects when a biped was the bone system, so this creates a new bone system 
-- of boxes, you link bonespro to the boxes instead of the biped bones, and
-- then move the biped as normal, the bones will follow, and the mesh will now
-- follow as well.
--
-- v 1.10 Now compatible with R4.0.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global make_bb_box

-- Functions

fn make_bb_box n =
	(
	-- Dimensions of box

	l = (n.max.y - n.min.y)
	w = (n.max.x - n.min.x)
	h = -(n.max.z - n.min.z)
	c = n.center - [0, 0, (h/2)]
	
	-- Create box
	
	the_box = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:l width:w height:h pos:c
	
	-- Modify Box
	
	the_box.parent = n
	the_box.name = n.name + "_box"
	-- the_box.pivot = n.pivot
	)

-- Script

if selection.count != 0 then
	(
	undo "BoxSkeleton" on
		(
		for i = 1 to selection.count do
			(
			if classof selection[i].parent == Biped_Object and classof selection[i] == Biped_Object then
				(
				make_bb_box selection[i]
				)
			)
		)
	)
)
-------------------------------------------------------------------------------