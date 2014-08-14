-------------------------------------------------------------------------------
-- BlurPrimitives.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.41
-- Created On: 05/08/00
-- Modified On: 09/27/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Solidify, http://www.max3d.com/~terralux/software.html
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Creates a few primitives I've wanted in the past.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Creates a few primitives I've wanted in the past, including a 
-- Triangular Block, a cube with a hole through it (square edges), and another 
-- cube with a hole that has trangular edges. The script used to be called 
-- Hollowcube.
--
-- v 1.10 Now compatible with R4.0. Added images instead of text for the 
-- buttons.
--
-- v 1.11 Fixed a bug where the images buttons would return an error if used 
-- as a macroscript.
--
-- v 1.12 Changed the way the images are included with the script from $scripts
-- to getdir #scripts. Also changed the name of the included bitmap.
--
-- v 1.20 Added 2 new primitives, the beveled wedge, and beveled wedge 2.
--
-- v 1.21 Now returns an error message when solidify is not installed.
--
-- v 1.30 Added two new primitives, and all primitives are now editable polys.
-- Changed interface a bit.
--
-- v 1.31 Changed the name of script from Primatives to Primitives. Yes, I can't
-- spell, so sue me. Also added a height spinner.
--
-- v 1.32 Moved solidify_test to BSLib.
--
-- v 1.40 Added a tool to allow the user to define the size in the viewports.
--
-- v 1.41 Replaced all references to Selection $ with i. Script now gives 
-- objects a unique name after creation. Now if you're in the modify panel 
-- when you run this script, it will automatically switch to create mode, to 
-- avoid several command panel redraws during the creation process.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global pt1 = [0,0,0]
global pt2 = [0,0,0]
global pt3 = [0,0,0]

global create_blurp
global quickdim

global blurp_floater
global blurp_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

blurp_size_value = 50
blurp_height_value = 50
im1 = (getdir #scripts) + "\\BlurScripts\\" + "Blurprimitives_images.bmp"
bpbs = 25
oldpos = [100,100]

-- Functions

fn create_blurp type =
	(
	undo "Blurprimitives" on
		(
		disableSceneRedraw()
		if getCommandPanelTaskMode() == #modify then max create mode
		if type == 1 then
			(
			if solidify_test() == true then
				(
				i = Plane length:blurp_size_value width:blurp_size_value pos:[0,0,0] isSelected:on widthsegs:3 lengthsegs:3
				convertTo i TriMeshGeometry
				deleteFace i 9
				deleteFace i 9
				addmodifier i (Solidify ())
				i.modifiers[#Solidify].amount = blurp_height_value
				convertTo i PolyMeshObject
				)
			else (MessageBox "You do not seem to have Solidify installed, and so cannot create this primitive. Read script documentation to see where to get Solidify" title:"Blurprimitives")
			)
		else if type == 2 then
			(
			newsize = (sqrt(blurp_size_value^2 + blurp_size_value^2))/2
			newsize2 = newsize/3
			i = Tube smooth:off sides:4 capsegs:1 heightsegs:1 radius1:newsize2 radius2:newsize height:blurp_height_value isSelected:on
			rotate i (angleaxis -45 [0,0,1])
			addmodifier i (XForm ())
			set coordsys local
			i.modifiers[#XForm].gizmo.rotation += quat 0 0 0.382683 0.92388
			subobjectLevel = 0
			rotate i (angleaxis 45 [0,0,1])
			convertTo i PolyMeshObject
			)
		else if type == 3 then
			(
			if solidify_test() == true then
				(
				i = Plane length:blurp_size_value width:blurp_size_value pos:[0,0,0] isSelected:on widthsegs:1 lengthsegs:1
				convertTo i TriMeshGeometry
				deleteFace i 2
				deleteVert i 2
				addmodifier i (Solidify ())
				i.modifiers[#Solidify].amount = blurp_height_value
				convertTo i PolyMeshObject
				)
			else (MessageBox "You do not seem to have Solidify installed, and so cannot create this primitive. Read script documentation to see where to get Solidify" title:"Blurprimitives")
			)
		else if type == 4 then
			(
			newsize1 = blurp_size_value/5
			newsize2 = 0.5*(blurp_size_value) - (newsize1)
			i = Cylinder smooth:on heightsegs:1 capsegs:1 sides:42 height:blurp_height_value radius:newsize1 pos:[0,0,0] isSelected:on
			convertTo i TriMeshGeometry
			subobjectLevel = 1
			select i.verts[#{2..12, 34..54, 76..85}]
			move i.selectedVerts [newsize2,0,0]
			select i.verts[#{13..33, 55..75}]
			move i.selectedVerts [-newsize2,0,0]
			subobjectLevel = 0
			convertTo i PolyMeshObject
			)
		else if type == 5 then
			(
			newsize1 = blurp_size_value/5
			newsize2 = (blurp_size_value)/2 + (newsize1)/2
			i = Cylinder smooth:on heightsegs:1 capsegs:1 sides:42 height:blurp_height_value radius:newsize1 pos:[0,0,0] isSelected:on
			convertTo i TriMeshGeometry
			subobjectLevel = 3
			extrudeFace i #{22..42, 85..126, 148..168} newsize2 100 dir:[0,-1,0]
			subobjectLevel = 0
			move i [0,(blurp_size_value*0.3),0]
			convertTo i PolyMeshObject
			)
		else if type == 6 then
			(
			if solidify_test() == true then
				(
				i = Plane length:blurp_size_value width:blurp_size_value lengthsegs:3 widthsegs:3 pos:[0,0,0] isSelected:on
				convertTo i PolyMeshObject
				polyop.deletefaces i 4
				polyop.deletefaces i 5

				select i.verts[#{2, 6, 10, 14}]
				move i.selectedVerts [(blurp_size_value*0.08),0,0]
				select i.verts[#{3, 7, 11, 15}]
				move i.selectedVerts [-(blurp_size_value*0.08),0,0]
				select i.verts[#{9..12}]
				move i.selectedVerts [0,(blurp_size_value*0.12),0]
				select i.verts[#{5..8}]
				move i.selectedVerts [0,-(blurp_size_value*0.12),0]
		
				select i.verts[#{5}]
				move i.selectedVerts [0,-(blurp_size_value*0.12),0]
				select i.verts[#{8}]
				move i.selectedVerts [0,-(blurp_size_value*0.12),0]
				select i.verts[#{9}]
				move i.selectedVerts [0,(blurp_size_value*0.12),0]
				select i.verts[#{12}]
				move i.selectedVerts [0,(blurp_size_value*0.12),0]
				addmodifier i (Solidify ())
				i.modifiers[#Solidify].amount = blurp_height_value
				convertTo i PolyMeshObject
				)
			else (MessageBox "You do not seem to have Solidify installed, and so cannot create this primitive. Read script documentation to see where to get Solidify" title:"Blurprimitives")
			)
		else if type == 7 then
			(
			if solidify_test() == true then
				(
				i = Plane length:blurp_size_value width:blurp_size_value lengthsegs:3 widthsegs:2 pos:[0,0,0] isSelected:on
				convertTo i PolyMeshObject
				polyop.deletefaces i 4

				select i.verts[#{7..9}]
				move i.selectedVerts [0,(blurp_size_value*0.12),0]
				select i.verts[#{4..6}]
				move i.selectedVerts [0,-(blurp_size_value*0.12),0]
				select i.verts[#{2, 5, 8, 11}]
				move i.selectedVerts [-(blurp_size_value*0.25),0,0]

				select i.verts[#{9}]
				move i.selectedVerts [0,(blurp_size_value*0.06),0]
				select i.verts[#{6}]
				move i.selectedVerts [0,-(blurp_size_value*0.06),0]

				addmodifier i (Solidify ())
				i.modifiers[#Solidify].amount = blurp_height_value
				convertTo i PolyMeshObject
				)
			else (MessageBox "You do not seem to have Solidify installed, and so cannot create this primitive. Read script documentation to see where to get Solidify" title:"Blurprimitives")
			)
		i.name = uniqueName "BlurPrimitive"
		enableSceneRedraw()
		redrawViews()
		)
	)
	
tool quickdim
	(
	on mousePoint clickno do 
		(
		if clickno == 2 then pt1 = worldPoint
		else if clickno == 3 then
			(
			pt2 = worldPoint
			)
		else if clickno == 4 then
			(
			pt3 = worldPoint
			a = distance pt1 pt2
			b = distance pt2 pt3
			blurp_size_value = a
			blurp_height_value = b
			oldpos = blurp_floater.pos
			if blurp_floater != undefined then CloseRolloutFloater blurp_floater
			blurp_floater = newRolloutFloater "BlurPrimitives v1.40" 150 277 oldpos.x oldpos.y
			addRollout blurp_rollout blurp_floater
			#stop		
			)
		)
	)

-- Script

rollout blurp_rollout "BlurPrimitives"
	(
	group "Primitives"
	(
	button shp_but width:bpbs height:bpbs toolTip:"SquareHolePunch" images:#(im1, undefined, 7, 1, 1, 1, 1) align:#center across:3
	button thp_but width:bpbs height:bpbs toolTip:"TriHolePunch" images:#(im1, undefined, 7, 2, 2, 2, 2) align:#center
	button triblock_but width:bpbs height:bpbs toolTip:"TriBlock" images:#(im1, undefined, 7, 3, 3, 3, 3) align:#center
	button beveled_wedge_but width:bpbs height:bpbs toolTip:"Beveled Wedge" images:#(im1, undefined, 7, 4, 4, 4, 4) align:#center across:3
	button beveled_wedge2_but width:bpbs height:bpbs toolTip:"Beveled Wedge 2" images:#(im1, undefined, 7, 5, 5, 5, 5) align:#center
	button i_beam_but width:bpbs height:bpbs toolTip:"I Beam" images:#(im1, undefined, 7, 6, 6, 6, 6) align:#center
	button c_beam_but width:bpbs height:bpbs toolTip:"C Beam" images:#(im1, undefined, 7, 7, 7, 7, 7) align:#center
	)
	on shp_but pressed do create_blurp 1
	on thp_but pressed do create_blurp 2
	on triblock_but pressed do create_blurp 3
	on beveled_wedge_but pressed do create_blurp 4
	on beveled_wedge2_but pressed do create_blurp 5
	on i_beam_but pressed do create_blurp 6
	on c_beam_but pressed do create_blurp 7
	
	group "Dimensions"
	(
	spinner blurp_size_spin "Size: " range:[0.01,9999999,blurp_size_value] type:#worldunits fieldWidth:50 align:#right
	spinner blurp_height_spin "Height: " range:[0.01,9999999,blurp_height_value] type:#worldunits fieldWidth:50 align:#right
	button define_dims "Define Dimensions" width:100 toolTip:"Define Dimensions" align:#center
	)
	on blurp_size_spin changed val do blurp_size_value = val
	on blurp_height_spin changed val do blurp_height_value = val
	on define_dims pressed do startTool quickdim
	)

if blurp_floater != undefined then CloseRolloutFloater blurp_floater
blurp_floater = newRolloutFloater "BlurPrimitives v1.41" 150 277 oldpos.x oldpos.y
addRollout blurp_rollout blurp_floater
)
-------------------------------------------------------------------------------