-------------------------------------------------------------------------------
-- Tracer.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.20
-- Created On: 08/10/01
-- Modified On: 02/02/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- The user draws a top, front and side view of an object, scans in the pictures, 
-- and then this script will create 3 planes in your viewport with your three 
-- pictures on them, allowing the user to use the reference photos as a guide 
-- for building their 3d model.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 The user draws a top, front and side view of an object, scans in the 
-- pictures, and then this script will create 3 planes in your viewport with 
-- your three pictures on them, allowing the user to use the reference photos 
-- as a guide for building their 3d model.
--
-- v 1.01 Fixed a bug that would crash the script if you don't define all
-- three images, or if one of the images was invalid. Added option for making 
-- the templates non-renderable.
--
-- v 1.10 Added some controls for modifying the template after it's been 
-- created.
--
-- v 1.20 Changed the ui of the script a bit.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global get_info
global make_tr_info_array
global make_plane
global start_tdt
global rebuild_tracer_array

global tr_create_rollout
global tr_modify_rollout
global tr_floater

-- Variables

tr_info_array = #()
tr_objs = #()

scale_factor = 1.0
tr_rend_value = off

bm_top = ""
bm_front = ""
bm_side = ""

-- Functions

fn get_info bm = 
(
	try
	(
		the_bm = openbitmap bm
		a = #(bm, (getFilenameFile bm), scale_factor*(the_bm.width), scale_factor*(the_bm.height))
		return a		
	)
	catch
	(
		Messagebox "An error occured reading one of the bitmaps" Title:"3DTracer"
		return #(undefined, undefined, 0, 0)
	)
)

fn make_tr_info_array = 
(
	tr_info_array = #()
	if bm_top != "" then append tr_info_array (get_info bm_top) else append tr_info_array #(undefined, undefined, 0, 0)
	if bm_front != "" then append tr_info_array (get_info bm_front) else append tr_info_array #(undefined, undefined, 0, 0)
	if bm_side != "" then append tr_info_array (get_info bm_side) else append tr_info_array #(undefined, undefined, 0, 0)
)

fn make_plane a = 
(
	if a == 1 then
	(
		obj = Plane length:tr_info_array[1][4] width:tr_info_array[1][3] pos:[0,0,0]
	)
	else if a == 2 then
	(
		obj = Plane length:tr_info_array[2][4] width:tr_info_array[2][3] pos:[0,0,0] transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
		obj.pos = [0,0.5*(tr_info_array[1][4]),0.5*(tr_info_array[2][4])]
	)
	else if a == 3 then
	(
		obj = Plane length:tr_info_array[3][4] width:tr_info_array[3][3] pos:[0,0,0] transform:(matrix3 [0,1,0] [0,0,1] [1,0,0] [0,0,0])
		obj.pos = [-0.5*(tr_info_array[1][3]),0,0.5*(tr_info_array[2][4])]
	)
	
	mat = Standardmaterial ()
	mat.name = tr_info_array[a][2]
	mat.diffuseMap = Bitmaptexture fileName:tr_info_array[a][1]
	mat.selfIllumAmount = 100
	mat.twoSided = on
	
	obj.name = "Tracer" + tr_info_array[a][2]
	obj.material = mat
	showTextureMap obj.material obj.material.diffusemap on
	obj.showFrozenInGray = off
	obj.isfrozen = true
	obj.wirecolor = color 70 70 70
	obj.renderable = tr_rend_value
	
	setUserProp obj "tracer" true
	
	append tr_objs obj
)
	
fn start_tdt = 
(
	make_tr_info_array()
	for i = 1 to 3 do 
	(
		if tr_info_array[i][1] != undefined then make_plane i
	)
	if tr_objs.count != 0 then selectionSets["Tracer Templates"] = tr_objs
	tr_objs = #()
)
	
fn rebuild_tracer_array = 
(
	tr_objs = #()
	for i in $* do
	(
		if (getUserProp i "tracer") == true then append tr_objs i
	)
)

-- Script

rollout tr_create_rollout "Create Template"
(
	group "Source Images"
(
	edittext bm_top_edit "Top:" fieldWidth:360 text:bm_top align:#right
	edittext bm_front_edit "Front:" fieldWidth:360 text:bm_front align:#right
	edittext bm_side_edit "Side:" fieldWidth:360 text:bm_side align:#right
)

	on bm_top_edit changed text do bm_top = bm_top_edit.text
	on bm_front_edit changed text do bm_front = bm_front_edit.text
	on bm_side_edit changed text do bm_side = bm_side_edit.text

	Group "Options"
(
	spinner sf_spin "Scale Factor: " range:[0.01,9999.0,1.0] type:#float fieldWidth:50 align:#right
	checkbox tr_rend "Renderable" checked:tr_rend_value align:#right
)

	on sf_spin changed val do scale_factor = val
	on tr_rend changed state do 
	(
		if tr_rend.checked == true then tr_rend_value = on
		else tr_rend_value = off
	)

	button tr_doit "Build Template" width:410 align:#center toolTip:"Build Template"
	on tr_doit pressed do start_tdt()
)
	
rollout tr_modify_rollout "Modify Template"
(
	checkbox tr_mod_hid "Hidden" checked:false align:#center enabled:true offset:[-20,3] across:4
	checkbox tr_mod_froz "Frozen" checked:true align:#center enabled:true offset:[-46,3]
	checkbox tr_mod_rend "Renderable" checked:false align:#center enabled:true offset:[-65,3]
	button tr_mod_del "Delete Existing Template" width:160 align:#right toolTip:"Delete Existing Template"

	on tr_mod_rend changed state do 
	(
		rebuild_tracer_array()
		for i in tr_objs do
		(
			i.renderable = state
		)
	)
	on tr_mod_hid changed state do 
	(
		rebuild_tracer_array()
		for i in tr_objs do
		(
			i.ishidden = state
		)
	)
	on tr_mod_froz changed state do 
	(
		rebuild_tracer_array()
		for i in tr_objs do
		(
			i.isfrozen = state
		)
	)
	on tr_mod_del pressed do 
	(
		rebuild_tracer_array()
		for i in tr_objs do
		(
			delete i
		)
	)
)

if tr_floater != undefined then CloseRolloutFloater tr_floater
tr_floater = newRolloutFloater "Tracer v1.20" 450 311
addRollout tr_create_rollout tr_floater
addRollout tr_modify_rollout tr_floater
)
-------------------------------------------------------------------------------