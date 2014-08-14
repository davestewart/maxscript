-------------------------------------------------------------------------------
-- ChamferConverter.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.21
-- Created On: 08/30/00
-- Modified On: 01/17/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Converts a box to a chamferbox, and vice versa, and a cylinder to a chamfer
-- cylinder to a cylinder and vice versa.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- Only works on primatives with no modifiers.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Converts a box to a chamferbox, and vice versa in one click. Will convert
-- a few simple parameters, not higher level modifiers or anything, this script
-- is primarily for someone who makes a box, places it right, maybe rotates it,
-- then suddenly thinks "d'oh! I wanted to have a chamfered edge on it."
--
-- v 1.10 Now also works on cylinders, so I renamed the script 
-- ChamferConverter
--
-- v 1.20 Compatible with R4. Fixed a bug that affected the ability to
-- copy smoothing information when converting a chamfercyl to a cylinder.
--
-- v 1.21 Made it so when you perform the function, it selects the newly created
-- objects.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global box_to_cham
global cham_to_box
global cyl_to_cham
global cham_to_cyl
global start_ccon

-- Variables

to_delete = #()
to_select = #()
maxdimdiv = 30

-- Functions

fn box_to_cham the_object= 
	(
	l = the_object.length
	w = the_object.width
	h = the_object.height
	sl = the_object.lengthsegs
	sw = the_object.widthsegs
	sh = the_object.heightsegs
	maxdim_array = sort #(l,w,h)
	maxdim = maxdim_array[maxdim_array.count]

	opos = the_object.pos
	orot = the_object.rotation
	oscale = the_object.scale
	omat = the_object.material
	ocolor = the_object.wirecolor

	new_box = ChamferBox Length_Segments:sl Width_Segments:sw Height_Segments:sh Fillet_Segments:1 length:l width:w height:h Fillet:(maxdim/maxdimdiv) pos:opos
	new_box.rotation = orot
	new_box.scale = oscale
	new_box.pos = opos
	new_box.material = omat
	new_box.wirecolor = ocolor

	append to_delete the_object
	append to_select new_box
	)

fn cham_to_box the_object= 
	(
	l = the_object.length
	w = the_object.width
	h = the_object.height
	sl = the_object.Length_Segments
	sw = the_object.Width_Segments
	sh = the_object.Height_Segments

	opos = the_object.pos
	orot = the_object.rotation
	oscale = the_object.scale
	omat = the_object.material
	ocolor = the_object.wirecolor

	new_box = Box lengthsegs:sl widthsegs:sw heightsegs:sh length:l width:w height:h pos:opos
	new_box.rotation = orot
	new_box.scale = oscale
	new_box.pos = opos
	new_box.material = omat
	new_box.wirecolor = ocolor

	append to_delete the_object
	append to_select new_box
	)

fn cyl_to_cham the_object= 
	(
	r = the_object.radius
	h = the_object.height
	s = the_object.sides
	hs = the_object.heightsegs
	cs = the_object.capsegs
	if the_object.smooth == false then so = 0 else so = 1
	slo = the_object.Slice_On
	slf = the_object.sliceFrom
	slt = the_object.sliceTo

	opos = the_object.pos
	orot = the_object.rotation
	oscale = the_object.scale
	omat = the_object.material
	ocolor = the_object.wirecolor

	new_cyl = ChamferCyl radius:r height:h Fillet:(r/maxdimdiv) Height_Segments:hs Fillet_Segments:1 sides:s Cap_Segments:cs Smooth_On:so Slice_On:slo Slice_From:slf Slice_To:slt pos:opos
	new_cyl.rotation = orot
	new_cyl.scale = oscale
	new_cyl.pos = opos
	new_cyl.material = omat
	new_cyl.wirecolor = ocolor

	append to_delete the_object
	append to_select new_cyl
	)

fn cham_to_cyl the_object= 
	(
	r = the_object.radius
	h = the_object.height
	s = the_object.sides
	hs = the_object.Height_Segments
	cs = the_object.Cap_Segments
	if the_object.Smooth_On == 0 then so = false else so = true
	if the_object.Slice_On == 0 then slo = off else slo = on
	slf = the_object.Slice_From
	slt = the_object.Slice_To

	opos = the_object.pos
	orot = the_object.rotation
	oscale = the_object.scale
	omat = the_object.material
	ocolor = the_object.wirecolor

	new_cyl = Cylinder heightsegs:hs capsegs:cs sides:s height:h radius:r pos:opos sliceFrom:slf sliceTo:slt
	new_cyl.smooth = so
	new_cyl.slice = slo
	new_cyl.rotation = orot
	new_cyl.scale = oscale
	new_cyl.pos = opos
	new_cyl.material = omat
	new_cyl.wirecolor = ocolor

	append to_delete the_object	
	append to_select new_cyl
	)

fn start_ccon = 
	(
	undo "ChamferConverter" on
		(
		for obj in $ do
			(
			if classof obj == box then box_to_cham obj
			else if classof obj == ChamferBox then cham_to_box obj
			else if classof obj == Cylinder then cyl_to_cham obj
			else if classof obj == ChamferCyl then cham_to_cyl obj
			else append to_select obj
			)
		delete to_delete
		select to_select
		to_delete = #()
		to_select = #()
		)
	)

-- Script

if selection.count == 0 then (MessageBox "Please select at least one object" title:"ChamferConverter")
else if (queryBox "Perform ChamferConverter to selected objects?" title:"ChamferConverter v1.21") == true then start_ccon()
)
-------------------------------------------------------------------------------