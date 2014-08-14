-------------------------------------------------------------------------------
-- VertexPlacer.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 2.00
-- Created On: 01/09/01
-- Modified On: 02/02/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- What this script does: 
-- Allows you to change the x y or z position of a selection of vertexes.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to change the x y or z position of a selection of vertexes 
-- at the same time.
--
-- v 1.10 Added a bunch of new functions for finding the selected verts in
-- a variety of situations. Eventually the script will be able to affect a much
-- broader range of mesh types then it does now (Hopefully).
--
-- v 1.20 Now works on Editable Polys with and without modifiers, and editable
-- meshes that have modifiers (except Edit Mesh).
--
-- v 1.21 Turns screen redraw off before doing operation.
--
-- v 1.30 Added flatten options that align the vertexes along the desired
-- plane at the average height of the vertexes.
--
-- v 1.40 Now works with Editable Splines.
--
-- v 2.00 Added Undo, doesn't work in all situations, but should in some of them
-- at least. Totally redid interface.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- This script doesn't work with edit mesh modifiers.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals 

global currently_selected_vertexes_in_editable_mesh
global currently_selected_vertexes_in_editable_mesh_with_modifiers
global currently_selected_vertexes_in_edit_mesh
global currently_selected_vertexes_in_editable_poly
global currently_selected_vertexes_in_editable_spline

global place_vertexes_in_editable_mesh
global place_vertexes_in_editable_mesh_with_modifiers
global place_vertexes_in_editable_poly
global place_vertexes_in_editable_spline

global what_to_do
global kind_of_object
global vpl_start

global vpl_floater
global vpl_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

flatten_x_value = false
flatten_y_value = false
flatten_z_value = false
place_x_value = false
place_y_value = false
place_z_value = false
newx = 0
newy = 0
newz = 0

-- Functions

fn currently_selected_vertexes_in_editable_mesh ob = 
(
	the_verts = #{}
	if classof ob == Editable_mesh then the_verts = getvertselection ob
	return the_verts
)
	
fn currently_selected_vertexes_in_editable_mesh_with_modifiers ob = 
(
	the_verts = #{}
	if classof ob == Editable_mesh then the_verts = getvertselection ob
	return the_verts
)
	
fn currently_selected_vertexes_in_edit_mesh ob = 
(
	the_verts = #{}
	if classof (modPanel.getCurrentObject ()) == Edit_Mesh then
	(
		current_mod = modPanel.getCurrentObject ()
		current_mod_index = modPanel.getModifierIndex ob current_mod
		the_verts = getVertSelection ob ob.modifiers[current_mod_index]
	)
	return the_verts
)

fn currently_selected_vertexes_in_editable_poly ob = 
(
	the_verts = #{}
	if classof ob == Editable_Poly then the_verts = getvertselection ob
	return the_verts
)
	
fn currently_selected_vertexes_in_editable_spline ob splin = 
(
	the_verts = #{}
	if classof ob == line or classof ob == SplineShape then the_verts = getKnotSelection ob splin
	return the_verts
)

fn place_vertexes_in_editable_mesh obj1 = 
(
	av_x = 0
	av_y = 0
	av_z = 0
	theverts = (currently_selected_vertexes_in_editable_mesh obj1)
	if flatten_x_value == true or flatten_y_value == true or flatten_z_value == true then
	(
		all_x = #()
		all_y = #()
		all_z = #()
		for i in theverts do 
		(
			append all_x (getvert obj1 i).x
			append all_y (getvert obj1 i).y
			append all_z (getvert obj1 i).z
		)
		av_x = average_minmax_of_array all_x
		av_y = average_minmax_of_array all_y
		av_z = average_minmax_of_array all_z
	)
		
	for i in theverts do 
	(
		tempx = (getvert obj1 i).x
		tempy = (getvert obj1 i).y
		tempz = (getvert obj1 i).z
		if flatten_x_value == true then tempx = av_x
		if place_x_value == true then tempx = newx
		if flatten_y_value == true then tempy = av_y
		if place_y_value == true then tempy = newy
		if flatten_z_value == true then tempz = av_z
		if place_z_value == true then tempz = newz
		setvert obj1 i [tempx,tempy,tempz]
	)
)
	
fn place_vertexes_in_editable_mesh_with_modifiers obj1 = 
(
	av_x = 0
	av_y = 0
	av_z = 0
	theverts = (currently_selected_vertexes_in_editable_mesh_with_modifiers obj1)
	if flatten_x_value == true or flatten_y_value == true or flatten_z_value == true then
	(
		all_x = #()
		all_y = #()
		all_z = #()
		for i in theverts do 
		(
			append all_x (meshop.getvert obj1 i).x
			append all_y (meshop.getvert obj1 i).y
			append all_z (meshop.getvert obj1 i).z
		)
		av_x = average_minmax_of_array all_x
		av_y = average_minmax_of_array all_y
		av_z = average_minmax_of_array all_z
	)

	for i in theverts do 
	(
		tempx = (meshop.getvert obj1 i).x
		tempy = (meshop.getvert obj1 i).y
		tempz = (meshop.getvert obj1 i).z
		if flatten_x_value == true then tempx = av_x
		if place_x_value == true then tempx = newx
		if flatten_y_value == true then tempy = av_y
		if place_y_value == true then tempy = newy
		if flatten_z_value == true then tempz = av_z
		if place_z_value == true then tempz = newz
		meshop.setvert obj1 i [tempx,tempy,tempz]
	)
)
	
fn place_vertexes_in_editable_poly obj1 = 
(
	av_x = 0
	av_y = 0
	av_z = 0
	theverts = (currently_selected_vertexes_in_editable_poly obj1)
	if flatten_x_value == true or flatten_y_value == true or flatten_z_value == true then
	(
		all_x = #()
		all_y = #()
		all_z = #()
		for i in theverts do 
		(
			append all_x (polyop.getvert obj1 i).x
			append all_y (polyop.getvert obj1 i).y
			append all_z (polyop.getvert obj1 i).z
		)
		av_x = average_minmax_of_array all_x
		av_y = average_minmax_of_array all_y
		av_z = average_minmax_of_array all_z
	)
	
	for i in theverts do 
	(
		tempx = (polyop.getvert obj1 i).x
		tempy = (polyop.getvert obj1 i).y
		tempz = (polyop.getvert obj1 i).z
		if flatten_x_value == true then tempx = av_x
		if place_x_value == true then tempx = newx
		if flatten_y_value == true then tempy = av_y
		if place_y_value == true then tempy = newy
		if flatten_z_value == true then tempz = av_z
		if place_z_value == true then tempz = newz
		polyop.setvert obj1 i [tempx,tempy,tempz]
	)
)

fn place_vertexes_in_editable_spline obj1 = 
(
	av_x = 0
	av_y = 0
	av_z = 0
	
	a = numSplines obj1
	
	for w = 1 to a do
	(
		theverts = (currently_selected_vertexes_in_editable_spline obj1 w)
		if flatten_x_value == true or flatten_y_value == true or flatten_z_value == true then
		(
			all_x = #()
			all_y = #()
			all_z = #()
			for i in theverts do 
			(
				append all_x (getKnotPoint obj1 w i).x
				append all_y (getKnotPoint obj1 w i).y
				append all_z (getKnotPoint obj1 w i).z
			)
			av_x = average_minmax_of_array all_x
			av_y = average_minmax_of_array all_y
			av_z = average_minmax_of_array all_z
		)
		
		for i in theverts do 
		(
			tempx = (getKnotPoint obj1 w i).x
			tempy = (getKnotPoint obj1 w i).y
			tempz = (getKnotPoint obj1 w i).z
			if flatten_x_value == true then tempx = av_x
			if place_x_value == true then tempx = newx
			if flatten_y_value == true then tempy = av_y
			if place_y_value == true then tempy = newy
			if flatten_z_value == true then tempz = av_z
			if place_z_value == true then tempz = newz
			setKnotPoint obj1 w i [tempx,tempy,tempz]
		)
	)
	updateshape obj1
)
	
fn what_to_do the_type obj = 
(
	undo "VertexPlacer" on
(
		if the_type == 1 then place_vertexes_in_editable_mesh obj
		else if the_type == 2 then place_vertexes_in_editable_mesh_with_modifiers obj
		else if the_type == 3 then (MessageBox "This script doesn't work with edit mesh modifiers." title:"VertexPlacer")
		else if the_type == 4 then place_vertexes_in_editable_poly obj
		else if the_type == 5 then place_vertexes_in_editable_spline obj
		else (MessageBox "The object type you have selected cannot be affected by this script" title:"VertexPlacer")
	)
)

fn kind_of_object obj = 
(
	local obj_type = 0
	
	if obj.modifiers.count == 0 and classof obj == Editable_mesh then obj_type = 1
	else if classof obj == Editable_Poly then obj_type = 4
	else if obj.modifiers.count != 0 then
	(
		if classof (modPanel.getCurrentObject ()) == Editable_mesh then obj_type = 2
		else if classof (modPanel.getCurrentObject ()) == Edit_Mesh then obj_type = 3
	)
	else if obj.modifiers.count == 0 and classof obj == line or classof obj == SplineShape then obj_type = 5
		
	-- Editable Mesh = 1
	-- Editable Mesh with Modifiers = 2
	-- Object with Edit Mesh = 3
	-- Editable Poly = 4
	-- Editable Spline = 5
	
	what_to_do obj_type obj
)
	
fn vpl_start = 
(
	if selection.count != 1 then (MessageBox "Please select only one object." title:"VertexPlacer")
	else 
	(
		disableSceneRedraw()
		try
		(
			kind_of_object $
		)
		catch ()
		enableSceneRedraw()
		completeRedraw()
	)
)

-- The Script

rollout vpl_rollout "VertexPlacer"
(
	label x_check "X" align:#left across:4
	button x_flatten "Flatten" height:19 width:55 offset:[-35,-2] tooltip:"Flatten on X"
	button x_place "Place:" height:19 width:55 offset:[-25,-2] tooltip:"Place"
	spinner x_amount "" range:[-9999999,9999999,0] fieldWidth:60 type:#worldunits offset:[0,0]
	label y_check "Y" align:#left across:4
	button y_flatten "Flatten" height:19 width:55 offset:[-35,-2] tooltip:"Flatten on Y"
	button y_place "Place:" height:19 width:55 offset:[-25,-2] tooltip:"Place"
	spinner y_amount "" range:[-9999999,9999999,0] fieldWidth:60 type:#worldunits offset:[0,0]
	label z_check "Z" align:#left across:4
	button z_flatten "Flatten" height:19 width:55 offset:[-35,-2] tooltip:"Flatten on Z"
	button z_place "Place:" height:19 width:55 offset:[-25,-2] tooltip:"Place"
	spinner z_amount "" range:[-9999999,9999999,0] fieldWidth:60 type:#worldunits offset:[0,0]

	on x_amount changed val do newx = val
	on x_flatten pressed do
	(
		flatten_x_value = true
		vpl_start()
		flatten_x_value = false
	)
	on x_place pressed do
	(
		place_x_value = true
		vpl_start()
		place_x_value = false
	)
	
	on y_amount changed val do newy = val
	on y_flatten pressed do
	(
		flatten_y_value = true
		vpl_start()
		flatten_y_value = false
	)
	on y_place pressed do
	(
		place_y_value = true
		vpl_start()
		place_y_value = false
	)
	
	on z_amount changed val do newz = val
	on z_flatten pressed do
	(
		flatten_z_value = true
		vpl_start()
		flatten_z_value = false
	)
	on z_place pressed do
	(
		place_z_value = true
		vpl_start()
		place_z_value = false
	)
)

if vpl_floater != undefined then CloseRolloutFloater vpl_floater
vpl_floater = newRolloutFloater "VertexPlacer v2.00" 270 135
addRollout vpl_rollout vpl_floater
)
-------------------------------------------------------------------------------