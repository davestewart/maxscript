-------------------------------------------------------------------------------
-- BSLib.ms
-- By Neil Blevins (neil@soulburn3d.com)
-- v 1.33
-- Created On: 09/18/00
-- Modified On: 06/28/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- A set of useful functions required for many of the blurscripts to run.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.01 Added a whole bunch of new functions, changed a few names, reorganized
-- functions by category. Afraid I've pretty much forgotten the specifics, I'll
-- do a much better job from now on reporting changes to this file.
--
-- v 1.02 Simplified the howmanyfaces function considerably, now that I know about
-- the getpolycount function. Added howmanyverts function.
--
-- v 1.03 Added biped_filter. Added a biped section and added get_biped_root.
--
-- v 1.04 Added axisRotate.
--
-- v 1.05 Added filter_array_string_wildcard.
-- 
-- v 1.06 Renamed random_unique_int_func to random_unique_int_rec. Added 
-- get_all_max_files_in_dir function.
-- 
-- v 1.07 Fixed a bug in get_all_max_files_in_dir_rec()
--
-- v 1.08 Renamed get_all_max_files_in_dir get_all_files_in_dir and gave it a
-- new variable that lets you tell the function which type of files to get.
-- 
-- v 1.09 Fixed a major crash bug by moving this file out of startup and instead
-- including it in seperate scripts.
--
-- v 1.10 Added current_modifier_index.
--
-- v 1.11 Added reverse_string, get_file_name, and strip_file_extension.
--
-- v 1.12 Added contains_instance
--
-- v 1.13 Added commafy
--
-- v 1.14 Added reload_bitmaps and remove_from_string. Deleted function flip_var 
-- since it wasn't being used anywhere and wasn't very useful anyways.
--
-- v 1.15 Added get_scene_bbox, get_sel_bbox, box_dim, box_center, create_scene_bbox,
-- and create_sel_bbox. Revised the current box functions to accept min and max 
-- instead of a box3, and moved them to their own section. Added get_instances, 
-- compare_case_insensitive, and compare_case_sensitive.
--
-- v 1.16 Added and improved solidify_test. Added unhiddenobj, hiddenobj, 
-- linecount_in_file
--
-- v 1.17 Did a little reorganizing, changed the name of a variable in all_lights,
-- and added all_cameras
--
-- v 1.18 Added show_lights.
--
-- v 1.19 Changed append_num_array_members to append_number_to_array_members. 
-- Changed dec_sort to sort_dec, and added sort_asc. Moved some stuff from the 
-- array area to a values subheading. Removed deleteitems, and replaced it with
-- 4 new functions, remove_from_array_by_index, remove_from_array_by_indexes,
-- remove_from_array_by_item, remove_from_array_by_items.
--
-- v 1.20 Fixed a bug in solidify_test that would crash it if nothing was selected
-- when the test was run. Moved the test to a new subheading, and added 
-- ink_n_paint_test to test if Ink 'N Paint is present, and toon_assistant_test
-- to test for Toon Assistant. Added a message printed to listener when BSLib gets
-- loaded.
--
-- v 1.21 Enhanced the get_scene_materials function to properly report all true
-- scene materials, unlike the built in MAXScript Scenematerials array which
-- included materials from deleted scene objects.
--
-- v 1.22 Rewrote the functions random_notunique_int and random_unique_int
-- into a series of 3 functions: choose_unique_by_number, choose_unique_by_percentage,
-- and choose_unique_by_weight. The original random_unique_int was having problems 
-- with large datasets due to its recursive nature. Moved the 3 funcs back to the
-- array section. In the Object Collection section, took all 4 functions and sorted
-- their results before returning them.
--
-- v 1.23 Added get_all_materials, get_all_scene_materials and get_sub_materials.
-- These three functions don't quite work yet, due to a max error. I'll tell
-- you when you can feel free to use them, in the meantime, consider them very 
-- experimental. Added trim_dups, which i took from John Burnett, but renamed it 
-- as to not cause any conflict. Fixed a bug in filter_array_string_wildcard.
--
-- v 1.24 Changed the functionality and name of FaR_obj, postfix_obj, prefix_obj
-- and rename_obj, now they are called rename_string, postfix_string, prefix_string,
-- and findandreplace_string. Added a get_all_scene_bitmaps, get_all_scene_maps,
-- get_bitmaps_from_mat, get_maps_from_mat functions, and get_misc_scene_maps, 
-- which are temporary code for getting maps from a scene. Created a new maps 
-- section. Cleaned append_number_to_array_members a bit.
--
-- v 1.25 Added blur_matte_test. Added all_atm, an array of all atmospherics in 
-- the scene. Finished the get_misc_scene_maps function. Added get_maps_from_fog.
-- Made some minor edits to the map functions to fix some crash bugs. Removed
-- get_file_name since it exists in max as filenameFromPath. Added 
-- get_all_medit_bitmaps and get_all_medit_maps. Added file_exist. Fixed small
-- error in choose_unique_by_weight. Added get_blurmat which lets you get a 
-- specific blur material from the Blurmat directory. Added get_mat_array.
--
-- v 1.26 Removed get_bitmaps_from_mat, get_all_medit_bitmaps and get_all_scene_bitmaps,
-- replaced them with the more general function get_bitmaps_from_maps that takes 
-- an array and returns all bitmaps from that array. Added get_all_maps_in_selected_objs.
-- Added read_ini_file and write_ini_file.
--
-- v 1.27 Added string_is_number. Added instant_uv_test. Added rgb_to_hsv
-- and hsv_to_rgb to the new Colors section. Added average_mean_of_array,
-- average_median_of_array, average_mode_of_array, average_minmax_of_array and 
-- number_of_instances_in_array.
--
-- v 1.28 Added indexes_of_instances_in_array.
--
-- v 1.29 Added identical_file. Added double_backslash_string. Removed
-- read_ini_file and write_ini_file, since they were no longer needed, and
-- named incorrectly anyways.
--
-- v 1.30 Modified face_center so it does editable meshes and editable polys.
--
-- v 1.31 Modified get_misc_scene_maps so that it works with brazil lights. Fixed
-- a bug in get_sub_materials, get_maps_from_mat, and get_maps_from_fog that 
-- would crash in recursion.
--
-- v 1.32 Modified get_misc_scene_maps so it won't crash on unknown light types.
--
-- v 1.33 Modified get_mat_array such that it can return the members of the
-- current material library. Added get_scene_ss_names function which returns
-- an array of scene selection set names.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Initialization Begin
-------------------------------------------------------------------------------
global bslib_enabled
if bslib_enabled == undefined then
(
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Globals
-------------------------------------------------------------------------------

global append_number_to_array_members
global average_mean_of_array
global average_median_of_array
global average_minmax_of_array
global average_mode_of_array
global choose_unique_by_number
global choose_unique_by_percentage
global choose_unique_by_weight
global compare_array
global copy_array
global indexes_of_instances_in_array
global number_of_instances_in_array
global remove_from_array_by_index
global remove_from_array_by_indexes
global remove_from_array_by_item
global remove_from_array_by_items
global filter_array_string_wildcard
global sort_asc
global sort_dec
global trim_dups

global get_biped_root
global is_biped_root

global box_center
global box_dim
global create_scene_bbox
global create_sel_bbox
global do_boxes_overlap
global get_scene_bbox
global get_sel_bbox
global percent_boxes_overlap

global hsv_to_rgb
global rgb_to_hsv

global addVisController
global add_vis_controller

global identical_file
global file_exist
global get_all_files_in_dir
global get_all_files_in_dir_rec
global linecount_in_file
global linecount_in_file_rec
global read_ini_file
global strip_file_extension
global write_ini_file

global biped_filter
global camera_filter
global geometry_filter
global particles_filter
global standard_light_filter
global standard_particle_filter

global format_table
global prettify

global how_many_nonstandard_lights
global show_lights

global get_all_maps_in_selected_objs
global get_all_medit_maps
global get_all_scene_maps
global get_bitmaps_from_maps
global get_maps_from_fog
global get_maps_from_mat
global get_misc_scene_maps
global reload_bitmaps

global get_all_materials
global get_all_scene_materials
global get_blurmat
global get_mat_array
global get_scene_materials
global get_sub_materials
global make_matte_material

global current_modifier_index

global all_atm
global all_cameras
global all_lights
global hiddenobj
global unhiddenobj

global blur_matte_test
global ink_n_paint_test
global instant_uv_test
global solidify_test
global toon_assistant_test

global contains_instance
global get_instances
global facecenter
global howmanypolys
global howmanyverts

global get_scene_ss_names

global commafy
global compare_case_insensitive
global compare_case_sensitive
global double_backslash_string
global extra_zeros
global findandreplace_string
global lowercase
global name_compare_case_insensitive
global name_compare_case_sensitive
global postfix_string
global prefix_string
global remove_from_string
global rename_string
global reverse_string
global string_is_number
global uppercase

global axisRotate

-------------------------------------------------------------------------------
-- Arrays
-------------------------------------------------------------------------------

fn append_number_to_array_members a start step = 
	(
	inc = 0
	for i in a do
		(
		if (start + inc) <= 9 then extra_zero = "0" else extra_zero = ""
		i.name = i.name + extra_zero + ((start + inc) as string)
		inc += (1 * step)
		)
	)

fn average_mean_of_array a = 
	(
	total = 0
	for i in a do
		(
		if superclassof i == number then total += i
		)
	return ((total as float)/(a.count as float))
	)
	
fn average_median_of_array a = 
	(
	sort a
	if mod a 2 != 0 then return a[((a.count as float)/(2 as float))+1]
	else return ((a[((a.count as float)/(2 as float))+1] as float) + (a[((a.count as float)/(2 as float))] as float)/2)
	)
	
fn average_minmax_of_array a = 
	(
	a1 = amax a
	a2 = amin a
	return ((abs (((a1 as float) - (a2 as float)) / (2 as float))) + a2)
	)
	
fn average_mode_of_array a = 
	(
	e = undefined
	if a.count != 0 then
		(
		sort a 
		b = #()
		for i in a do
			(
			append b #(i,number_of_instances_in_array a i)
			)
		qsort b (fn greater_then_sort x y = (y[2] - x[2]))
		c = #(b[1])
		if b.count > 1 then
			(
			d = (remove_from_array_by_index (copy_array b) 1)
			for i in d do
				(
				if i[2] == c[1][2] then append c i
				)
			)
		e = #()
		for i in c do
			(
			append e i[1]
			)
		trim_dups e
		sort e
		if e.count == 1 then e = e[1]
		)
	return e
	)
	
fn choose_unique_by_number a num =
	(
	if num < 1 then return #() 
	else
		(
		if num < a.count then
			(
			for i = 1 to ((a.count)-num) do
				(
				deleteItem a (random 1 a.count)
				)
			)
		return a
		)
	)

fn choose_unique_by_percentage a percentage =
	(
	num = a.count*(percentage*0.01)
	choose_unique_by_number a num
	)
	
fn choose_unique_by_weight a weight =
	(
	b = #()
	if a.count >= 1 then 
		(
		for i = 1 to a.count do
			(
			if ((random 1 99) + (weight-50)) > 50 then append b a[i]
			)
		)
	return b
	)

fn compare_array a b = 
	(
	if a.count != b.count then return false
	else
		(
		for i = 1 to a.count do
			(
			if a[i] != b[i] then return false
			)
		true
		)
	)

fn copy_array a = 
	(
	local b = #()
	if a.count != 0 then 
		(
		for i = 1 to a.count do
			(
			append b a[i]
			)
		)
	return b
	)
	
fn indexes_of_instances_in_array thearray val = 
	(
	a = #()
	if thearray.count == 0 then return undefined
	else
		(
		for i = 1 to thearray.count do
			(
			if thearray[i] == val then append a i
			)
		return a
		)
	)

fn number_of_instances_in_array thearray val = 
	(
	a = filter_array_string_wildcard thearray val
	return a.count
	)

fn remove_from_array_by_index thearray index =
	(
	local a = copy_array thearray
	deleteitem a index
	return a
	)

fn remove_from_array_by_indexes thearray thearray_to_remove =
	(
	local a = copy_array thearray
	local b = copy_array thearray_to_remove
	if b.count != 0 then
		(
		sort b
		for i = 1 to b.count do
			(
			deleteitem a b[i]
			for w = 1 to b.count do
				(
				b[w] -= 1
				)
			)
		)
	return a
	)
	
fn remove_from_array_by_item thearray item =
	(
	b = copy_array thearray
	if b.count != 0 then
		(
		delete_array = #()
		for i = 1 to b.count do
			(
			if b[i] == item then append delete_array i
			)
		b = remove_from_array_by_indexes b delete_array
		)
	return b
	)
	
fn remove_from_array_by_items thearray items =
	(
	local a = copy_array thearray
	local b = copy_array items
	if b.count != 0 then
		(
		for i in b do 
			(
			a = remove_from_array_by_item a i
			)
		)
	return a
	)

fn filter_array_string_wildcard a p = 
	(
	b = copy_array a
	if b.count != 0 then 
		(
		delete_array = #()
		for i = 1 to b.count do
			(
			if (findstring (b[i] as string) (p as string)) == undefined then 
				(
				append delete_array i
				)
			)
		b = remove_from_array_by_indexes b delete_array
		)
	b
	)

fn sort_asc a = 
	(
	sort a
	)
	
fn sort_dec a =
	(
	the_new_array = #()
	sort a
	for w = 1 to a.count do
		(
		append the_new_array a[a.count]
		deleteitem a a.count
		)
	the_new_array
	)
	
fn trim_dups a = 
	(
	for i in a.count to 1 by -1 do 
		(
		idx = findItem a a[i]
		if (idx != 0) AND (idx != i) do deleteItem a i
		)
	a
	)

-------------------------------------------------------------------------------
-- Bipeds
-------------------------------------------------------------------------------

fn get_biped_root i =
	(
	if (is_biped_root i) == true then return i
	else get_biped_root i.parent
	)

fn is_biped_root i =
	(
	if classof i == Biped_Object and classof i.parent != Biped_Object then return true
	else return false
	)
	
-------------------------------------------------------------------------------
-- Boxes
-------------------------------------------------------------------------------

fn box_center b1_max b1_min = 
	(
	return [(b1_max.x+b1_min.x)/2, (b1_max.y+b1_min.y)/2, (b1_max.z+b1_min.z)/2]
	)
	
fn box_dim b1_max b1_min = 
	(
	l = (b1_max.x-b1_min.x)
	w = (b1_max.y-b1_min.y)
	h = (b1_max.z-b1_min.z)
	return [l,w,h]
	)
	
fn create_scene_bbox =
	(
	m = get_scene_bbox()
	c = box_center m[1] m[2]
	s = box_dim m[1] m[2]
	pos_value = [c[1], c[2], m[2].z]
	Box lengthsegs:1 widthsegs:1 heightsegs:1 length:s[2] width:s[1] height:s[3] pos:pos_value isSelected:on
	)
	
fn create_sel_bbox =
	(
	m = get_sel_bbox()
	c = box_center m[1] m[2]
	s = box_dim m[1] m[2]
	pos_value = [c[1], c[2], m[2].z]
	Box lengthsegs:1 widthsegs:1 heightsegs:1 length:s[2] width:s[1] height:s[3] pos:pos_value isSelected:on
	)

fn do_boxes_overlap b1_max b1_min b2_max b2_min = 
	(
	if (b1_min.x > b2_max.x) then false
	else if (b2_min.x > b1_max.x) then false
	else if (b1_min.y > b2_max.y) then false
	else if (b2_min.y > b1_max.y) then false
	else if (b1_min.z > b2_max.z) then false
	else if (b2_min.z > b1_max.z) then false
	else true
	)
	
fn get_scene_bbox = 
	(
	onwhat = $*
	if onwhat.count == 0 then return #([0,0,0],[0,0,0])
	else
		(
		max = [onwhat[1].max.x,onwhat[1].max.y,onwhat[1].max.z]
		min = [onwhat[1].min.x,onwhat[1].min.y,onwhat[1].min.z]
		for i in onwhat do 
			(
			if superclassof i != light and superclassof i != camera and superclassof i != SpacewarpObject then
				(
				if i.max.x > max.x then max.x = i.max.x
				if i.max.y > max.y then max.y = i.max.y
				if i.max.z > max.z then max.z = i.max.z
				if i.min.x < min.x then min.x = i.min.x
				if i.min.y < min.y then min.y = i.min.y
				if i.min.z < min.z then min.z = i.min.z
				)
			)
		return #([max.x,max.y,max.z],[min.x,min.y,min.z])
		)
	)
	
fn get_sel_bbox = 
	(
	onwhat = selection
	if onwhat.count == 0 then return #([0,0,0],[0,0,0])
	else
		(
		max = [onwhat[1].max.x,onwhat[1].max.y,onwhat[1].max.z]
		min = [onwhat[1].min.x,onwhat[1].min.y,onwhat[1].min.z]
		for i in onwhat do 
			(
			if superclassof i != light and superclassof i != camera and superclassof i != SpacewarpObject then
				(
				if i.max.x > max.x then max.x = i.max.x
				if i.max.y > max.y then max.y = i.max.y
				if i.max.z > max.z then max.z = i.max.z
				if i.min.x < min.x then min.x = i.min.x
				if i.min.y < min.y then min.y = i.min.y
				if i.min.z < min.z then min.z = i.min.z
				)
			)
		return #([max.x,max.y,max.z],[min.x,min.y,min.z])
		)
	)
	
fn percent_boxes_overlap b1_max b1_min b2_max b2_min = 
	(
	diffBox_max = [0,0,0]
	diffBox_min = [0,0,0]
	frac = 0.0
	
	if (b1_min.x > b2_min.x) then diffBox_min.x = b1_min.x
	else diffBox_min.x = b2_min.x

	if (b1_max.x < b2_max.x) then diffBox_max.x = b1_max.x
	else diffBox_max.x = b2_max.x

	if (b1_min.y > b2_min.y) then diffBox_min.y = b1_min.y
	else diffBox_min.y = b2_min.y

	if (b1_max.y < b2_max.y) then diffBox_max.y = b1_max.y
	else diffBox_max.y = b2_max.y

	if (b1_min.z > b2_min.z) then diffBox_min.z = b1_min.z
	else diffBox_min.z = b2_min.z
	
	if (b1_max.z < b2_max.z) then diffBox_max.z = b1_max.z
	else diffBox_max.z = b2_max.z

	extent1 = diffBox_max - diffBox_min
	extent2 = b2_max - b2_min

	vol1 = extent1.x * extent1.y * extent1.z
	vol2 = extent2.x * extent2.y * extent2.z

	if (vol2 != 0.0) then frac = vol1 / vol2
	else frac = 0.0

	frac
	)

-------------------------------------------------------------------------------
-- Colors
-------------------------------------------------------------------------------

fn hsv_to_rgb hue sat val = 
	(
	h = ((hue as float)/(255 as float))*(6 as float)
	s = (sat as float)/(255 as float)
	v = (val as float)/(255 as float)
	
	if h == undefined then return color (v*255) (v*255) (v*255)
	else
		(
		i = floor h
		f = h - i
		if (mod i 2) == 0 then f = 1 - f
		
		m = v*(1-s)
		n = v*(1-(s*f))
		
		m=m*255
		n=n*255
		v=v*255

		case i of 
			( 
			6: return color v n m
			0: return color v n m
			1: return color n v m
			2: return color m v n
			3: return color m n v 
			4: return color n m v 
			5: return color v m n 
			) 
		)
	)

fn rgb_to_hsv c = 
	(
	R = c.r/255
	G = c.g/255
	B = c.b/255
	x = amin #(R, G, B)
	v = amax #(R, G, B)
	if v == x then return #(255,0,v)
	else
		(
		if R == x then f = (G-B)
		else if G == x then f = (B-R)
		else f = (R-G)

		if R == x then i = 3
		else if G == x then i = 5 
		else i = 1
		
		hsv1 = (i-(f/(v-x)))
		hsv2 = ((v-x)/v)
		hsv3 = v
		return #((hsv1*255)/6,hsv2*255,hsv3*255)
		)
	)

-------------------------------------------------------------------------------
-- Controllers
-------------------------------------------------------------------------------

-- addVisController by Larry Minton

fn addVisController obj = 
	(
	if obj.visibility.controller == undefined do
		(
		animate on at time (currenttime+1) obj.visibility=obj.visibility
		deletekeys obj.visibility.controller #allkeys
		)
	)

fn add_vis_controller obj = 
	(
	obj.visibility = true
	obj[1].controller = Bezier_float()
	)

-------------------------------------------------------------------------------
-- Files
-------------------------------------------------------------------------------

fn identical_file f1 f2 = 
	(
	if (filenameFromPath f1) != (filenameFromPath f2) then return false
	else if (getFileModDate f1) != (getFileModDate f2) then return false
	else if (getFileCreateDate f1) != (getFileCreateDate f2) then return false
	else return true
	)

fn file_exist fname = 
	(
	(getfiles fname).count != 0 
	)

fn get_all_files_in_dir start_dir rec type = 
	(
	all_files = #()
	get_all_files_in_dir_rec start_dir rec type all_files
	all_files
	)
	
-- required by get_all_files_in_dir, not to be used as a function by itself.
fn get_all_files_in_dir_rec start_dir rec type all_files =  
	(
	cur_files = getFiles (start_dir + "*." + (type as string))
	for i in cur_files do
		(
		append all_files i
		)
	if rec == true then
		(
		sub_dirs = getDirectories (start_dir + "*.*")
		for i in sub_dirs do
			(
			get_all_files_in_dir_rec i rec type all_files
			)
		)
	)
	
fn linecount_in_file thefile = 
	(
	m = openFile thefile
	curcount = 0
	mo = 0
	if classof m == FileStream then
		(
		mo = linecount_in_file_rec m curcount
		)
	close m
	return (curcount + mo)
	)
	
-- required by linecount_in_file, not to be used as a function by itself.
fn linecount_in_file_rec thefile thecount =
	(
	if eof thefile == false then
		(
		readLine thefile
		thecount += 1
		linecount_in_file_rec thefile thecount
		)
	else return thecount
	)
	
fn strip_file_extension string = 
	(
	the_filename = reverse_string string
	where_to_cut = findString the_filename "."
	backwards_name = substring the_filename (where_to_cut + 1) the_filename.count
	return reverse_string backwards_name
	)

-------------------------------------------------------------------------------
-- Filters
-------------------------------------------------------------------------------

fn biped_filter o = 
	(
	ClassOf o == Biped_Object
	)

fn camera_filter o = 
	(
	superClassOf o == camera 
	)
	
fn geometry_filter o = 
	(
	superClassOf o == GeometryClass
	)

fn particles_filter o =
	(
	if \
	classof o.baseobject == SuperSpray or \
	classof o.baseobject == PArray or \
	classof o.baseobject == PCloud or \
	classof o.baseobject == Blizzard or \
	classof o.baseobject == Snow or \
	classof o.baseobject == Spray or \
	classof o.baseobject == ParticleStudio or \
	classof o.baseobject == Sand_Blaster or \
	classof o.baseobject == Particles \
	then true
	else false
	)

fn standard_light_filter o = 
	(
	if \
	classof o == targetSpot or \
	classof o == Omnilight or \
	classof o == TargetDirectionallight or \
	classof o == Directionallight or \
	classof o == freeSpot \
	then true
	else false
	)
	
fn standard_particle_filter o =
	(
	if \
	classof o.baseobject == SuperSpray or \
	classof o.baseobject == PArray or \
	classof o.baseobject == PCloud or \
	classof o.baseobject == Blizzard \
	then true
	else false
	)

-------------------------------------------------------------------------------
-- Formatting
-------------------------------------------------------------------------------

-- a function to take an stringstream defining a table output where columns are 
-- separated by tabs, and expand the tabs to spaces to create consistent table 
-- columns. minSpacing is the minimum spacing between columns (written by Larry Minton)

fn format_table outline minSpacing =
	(
		-- get width of columns
		seek outline 0
		local colwidths=#(0)
		local ncol=1
		local colwidth=0
		while not eof outline do 
		(	local inchar = readchar outline
			if inchar == "\t" then
			(	if colwidth > colwidths[ncol] do colwidths[ncol]=colwidth 
				ncol += 1
				if colwidths[ncol] == undefined do colwidths[ncol]=0
				colwidth = 0
			)
			else if inchar == "\n" then
			(	if colwidth > colwidths[ncol] do colwidths[ncol]=colwidth
				ncol = 1
				colwidth = 0
			)
			else
				colwidth += 1
		)
		if colwidth > colwidths[ncol] do colwidths[ncol]=colwidth
		-- output replacing tabs with spaces needed to line up columns
		local newout = stringstream ""
		for i = 1 to colwidths.count do colwidths[i] += minSpacing
		seek outline 0
		ncol=1
		colwidth=0
		while not eof outline do 
		(	local inchar = readchar outline
			if inchar == "\t" then
			(	for i = (colwidth+1) to colwidths[ncol] do format " " to:newout
				ncol += 1
				colwidth = 0
			)
			else if inchar == "\n" then
			(	format inchar to:newout
				ncol = 1
				colwidth = 0
			)
			else
			(	format inchar to:newout
				colwidth += 1
			)
		)
		newout as string
	)

-- a function to make pretty output of floats, point3s, and ints (written by Larry Minton)

fn prettify val = 
	(	local res, tval
		if classof val == float then
		(	tval=val
			tval = if abs val < 1e-4 then 0. else val
			res=tval as string
			if res == "0.0" do res = "0.00000"
			if tval >= 0.0 do res = " "+res
			while res.count < 8 do res += "0"
		)
		else if classof val == point3 then
			res = "[" + prettify val.x + "," + prettify val.y + "," + prettify val.z + "]"
		else if classof val == integer then
		(	res = val as string
			while res.count < 8 do res = " "+res
		)
	    else
			res = val as string
		res
	)

-------------------------------------------------------------------------------
-- Lights
-------------------------------------------------------------------------------

fn how_many_nonstandard_lights onwhat = 
	(
	nsl = 0
	if onwhat == "scene" then
		(
		for s in lights do
			(
			if superclassof s != GeometryClass then	
				(
				if standard_light_filter s == false then nsl += 1
				)
			)
		)
	else if onwhat == "selected" then
		(
		for s in selection do
			(
			if superclassof s == light then
				(
				if superclassof s != GeometryClass then	
					(
					if standard_light_filter s == false then nsl += 1
					)
				)
			)
		)
	else (MessageBox "how_many_nonstandard_lights was called with an improper parameter" title:"BSLib")
	nsl
	)

fn show_lights = 
	(	
	local all_visible = true
	for l in lights do
		(
		if l.ishidden == true then 
			(
			all_visible = false
			exit
			)
		else continue
		)
	
	l = Omnilight()
	delete l
	
	for l in lights do
		(
		l.ishidden = all_visible
		)
	completeredraw()
	)

-------------------------------------------------------------------------------
-- Maps
-------------------------------------------------------------------------------

fn get_all_maps_in_selected_objs = 
	(
	b = #()
	for i in selection do
		(
		if i.material != undefined then
			(
			a = #()
			get_maps_from_mat i.material a
			join b a
			)
		)
	trim_dups b
	qsort b name_compare_case_insensitive
	return b
	)

fn get_all_medit_maps = 
	(
	b = #()
	for i = 1 to 24 do
		(
		a = #()
		get_maps_from_mat meditmaterials[i] a
		join b a
		)
	trim_dups b
	qsort b name_compare_case_insensitive
	return b
	)

fn get_all_scene_maps = 
	(
	mats = get_all_scene_materials()
	b = #()
	for m in mats do
		(
		a = #()
		get_maps_from_mat m a
		join b a
		)
	trim_dups b
	qsort b name_compare_case_insensitive
	return b
	)

fn get_bitmaps_from_maps a = 
	(
	b = #()
	for i in a do
		(
		if classof i == Bitmaptexture then append b i
		)
	return b
	)
	
fn get_maps_from_fog fg x = 
	(
	if fg.numsubs != 0 then
		(
		for i = 1 to fg.numsubs do
			(
			if fg[i] != undefined then
				(
				if classof fg[i] == SubAnim then
					(
					if superclassof fg[i].object == textureMap then
						(
						if fg[i].object != undefined then append x fg[i].object
						)
					)
				get_maps_from_fog fg[i] x
				)
			)
		)
	)
	
fn get_maps_from_mat mat x = 
	(
	if mat.numsubs != 0 then
		(
		for i = 1 to mat.numsubs do
			(
			if mat[i] != undefined then
				(
				if classof mat[i] == SubAnim then
					(
					if superclassof mat[i].object == textureMap then
						(
						if mat[i].object != undefined then append x mat[i].object
						)
					)
				get_maps_from_mat mat[i] x
				)
			)
		)
	)

fn get_misc_scene_maps bk dm ds g f = 
	(
	b = #()
	
	-- Background
	
	if bk == true then
		(
		if EnvironmentMap != undefined then append b EnvironmentMap
		)
	
	-- Displace Modifiers
	
	if dm == true then
		(	
		for i in $* do 
			(
			for m in i.modifiers do
				(
				if classof m == Displace then 
					(
					if m.map != undefined then append b m.map
					)
				)
			)
		)
		
	-- Displace Spacewarps

	if ds == true then
		(		
		for i in $* do 
			(
			if classof i == Spacedisplace then if i.map != undefined then append b i.map
			)
		)

	-- Projector Lights

	if g == true then
		(
		for i in lights do 
			(
			if superclassof i == light then 
				(
				if classof i == Brazil_Light then
					(
					if i.projector_map != undefined then append b i.projector_map
					)
				else if standard_light_filter i == true then
					(
					if i.projectorMap != undefined then append b i.projectorMap
					)
				)
			)
		)
	
	-- Fog
	
	if f == true then
		(
		for i in (all_atm()) do
			(
			if classof i == fog then
				(
				a = #()
				get_maps_from_fog i a
				join b a
				)
			)
		)

	trim_dups b
	return b
	)
	
fn reload_bitmaps mat = 
	(
	if mat.numsubs != 0 then
		(
		for i = 1 to mat.numsubs do
			(
			if mat[i] != undefined then
				(
				if iskindof mat[i] bitmaptexture == true then
					(
					mat[i].bitmaptex.Reload()
					)
				)
			reload_bitmaps mat[i]
			)
		)
	)
	
-------------------------------------------------------------------------------
-- Materials
-------------------------------------------------------------------------------

fn get_all_materials mat = 
	(
	aa = #()
	x = #()
	append aa mat
	get_sub_materials mat x
	for i in x do
		(
		if finditem aa i == 0 then append aa i
		)
	return aa
	)
	
fn get_all_scene_materials = 
	(
	a = #()
	for i in $* do
		(
		if i.material != undefined then
			(
			for i in (get_all_materials i.material) do
				(
				if (finditem a i) == 0 then append a i
				)
			)
		)
	qsort a name_compare_case_insensitive
	return a
	)

fn get_blurmat matname =
	(
	saveMaterialLibrary "$scripts/BlurMats/temp.ms"
	try
		(
		loadMaterialLibrary ("$scripts/BlurMats/" + matname + ".mat")
		m = currentMaterialLibrary[1]
		)
	catch
		(
		MessageBox "An Error has occured loading the requested Material. Possibly you're missing a plugin that the material requires." title:"BSLib"
		m = false
		)
	loadMaterialLibrary "$scripts/BlurMats/temp.ms"
	deletefile "$scripts/BlurMats/temp.ms"
	return m
	)

fn get_mat_array type start end = 
	(
	mat_array = #()
	if type == 1 then mat_array = get_scene_materials()
	else if type == 2 then 
		(
		for i in selection do 
			(
			if i.material != undefined then append mat_array i.material
			)
		)
	else if type == 3 then for i = 1 to 24 do append mat_array meditMaterials[i]
	else if type == 4 then
		(
		if start > end then
			(
			for i = end to start do append mat_array meditMaterials[i]
			)
		else for i = start to end do append mat_array meditMaterials[i]
		)
	else if type == 5 then append mat_array meditMaterials[medit.GetActiveMtlSlot()]
	else if type == 6 then mat_array = currentMaterialLibrary
	trim_dups mat_array
	return mat_array
	)

fn get_scene_materials = 
	(
	a = #()
	for i in $* do
		(
		if i.material != undefined then
			(
			if (finditem a i.material) == 0 then append a i.material
			)
		)
	qsort a name_compare_case_insensitive
	return a
	)
	
fn get_sub_materials mat x = 
	(
	if mat.numsubs != 0 then
		(
		for i = 1 to mat.numsubs do
			(
			if mat[i] != undefined then
				(
				if iskindof mat[i] material == true then 
					(
					if classof mat[i] == SubAnim then
						(
						if superclassof mat[i].object == material then 
							(
							if finditem x (mat[i].object) == 0 then append x (mat[i].object)
							)
						)
					if superclassof mat[i] == material then 
						(
						if finditem x (mat[i]) == 0 then append x (mat[i])
						)
					)
				get_sub_materials mat[i] x
				)
			)
		)
	)

fn make_matte_material mattetype = 
	(
	atm_matte = MatteShadow ()
	atm_matte.name = "Atmosphere Matte"
	atm_matte.opaqueAlpha = off
	atm_matte.applyAtmosphere = on
	atm_matte.atmosphereDepth = 1

	object_matte = MatteShadow ()
	object_matte.name = "Object Matte"
	object_matte.opaqueAlpha = off
	object_matte

	scn_matte = MatteShadow ()
	scn_matte.name = "Scene Matte"
	scn_matte.opaqueAlpha = off
	scn_matte.receiveshadows = on
	scn_matte.affectAlpha = on

	if mattetype == "atm" then (atm_matte)
	else if mattetype == "object" then (object_matte)
	else if mattetype == "scene" then (scn_matte)
	else return (object_matte)
	)
	
-------------------------------------------------------------------------------
-- Modifiers
-------------------------------------------------------------------------------

fn current_modifier_index obj = 
	(
	local current_mod_index
	try 
		(
		current_mod_index = modPanel.getModifierIndex $ (modPanel.getCurrentObject())
		)
	catch
		(
		current_mod_index = 0
		)
	return current_mod_index
	)

-------------------------------------------------------------------------------
-- Object Collecting
-------------------------------------------------------------------------------

fn all_atm =
	(
	a = #()
	if numAtmospherics != 0 then
		(
		for i = 1 to numAtmospherics do
			(
			append a (getAtmospheric i)
			)
		)
	return a
	)

fn all_cameras = 
	(
	a = #()
	for i in $* do
		(
		if superclassof i == camera then append a i
		)
	qsort a name_compare_case_insensitive
	return a
	)

fn all_lights onwhat = 
	(
	a = #()
	if onwhat == "scene" then
		(
		for s in lights do
			(
			if standard_light_filter s == true then append a s
			)
		)
	else if onwhat == "selected" then
		(
		for s in selection do
			(
			if standard_light_filter s == true then append a s
			)
		)
	else (MessageBox "all_lights was called with an improper parameter" title:"BSLib")
	qsort a name_compare_case_insensitive
	return a
	)

fn hiddenobj = 
	(
	a = #()
	for i in $* do
		(
		if i.ishidden == true then append a i
		)
	qsort a name_compare_case_insensitive
	return a
	)

fn unhiddenobj = 
	(
	a = #()
	for i in $* do
		(
		if i.ishidden == false then append a i
		)
	qsort a name_compare_case_insensitive
	return a
	)

-------------------------------------------------------------------------------
-- Plugin Tests
-------------------------------------------------------------------------------

fn blur_matte_test = 
	(
	answer = true
	try 
		(
		b = Blur_Matte_Mtl ()
		)
	catch 
		(
		answer = false
		)
	return answer
	)

fn ink_n_paint_test = 
	(
	answer = true
	try 
		(
		b = Ink__n_Paint()
		)
	catch 
		(
		answer = false
		)
	return answer
	)

fn instant_uv_test = 
	(
	disableSceneRedraw()
	answer = true
	s = for obj in selection collect obj
	try
		(
		test_plane = Plane length:10 width:10 pos:[0,0,0] isSelected:on
		addmodifier $ (InstantUV ())
		)
	catch	
		(
		answer = false
		)
	delete test_plane
	if s != undefined then select s
	
	enableSceneRedraw()
	completeRedraw()

	return answer
	)

fn solidify_test = 
	(
	disableSceneRedraw()
	answer = true
	s = for obj in selection collect obj
	try
		(
		test_plane = Plane length:10 width:10 pos:[0,0,0] isSelected:on
		addmodifier $ (Solidify ())
		)
	catch	
		(
		answer = false
		)
	delete test_plane
	if s != undefined then select s
	
	enableSceneRedraw()
	completeRedraw()

	return answer
	)
	
fn toon_assistant_test = 
	(
	answer = true
	try 
		(
		b = Toon_Assistant()
		)
	catch 
		(
		answer = false
		)
	return answer
	)
	
-------------------------------------------------------------------------------
-- Scene Geometry
-------------------------------------------------------------------------------

fn contains_instance the_array the_obj = 
	(
	if the_obj != undefined then
		(
		if the_array != 0 then
			(
			if (refs.dependents the_obj.baseobject).count != 0 then
				(
				the_refs = #()
				for w = 1 to (refs.dependents the_obj.baseobject).count do
					(
					if (refs.dependents the_obj.baseobject)[w] != the_obj then
						(
						if iskindof (refs.dependents the_obj.baseobject)[w] (classof the_obj) then
							(
							append the_refs (refs.dependents the_obj.baseobject)[w]
							)
						)
					)
				for i in the_array do
					(
					if (finditem the_refs i) != 0 then 
						(
						return true
						exit
						)
					)
				return false
				)
			else return false
			)
		else return false
		)
	else return false
	)
	
fn facecenter theobject theface = 
	(
	if classof theobject == Editable_Mesh then
		(
		ta = for i in (meshop.getVertsUsingFace theobject theface) collect theobject.verts[i].pos
		return [(ta[1].x + ta[2].x + ta[3].x)/3, (ta[1].y + ta[2].y + ta[3].y)/3, (ta[1].z + ta[2].z + ta[3].z)/3]
		)
	else if classof theobject = Editable_Poly then
		(
		ta = for i in (polyop.getVertsUsingFace theobject theface) collect theobject.verts[i].pos
		return [(ta[1].x + ta[2].x + ta[3].x + ta[4].x)/4, (ta[1].y + ta[2].y + ta[3].y + ta[4].y)/4, (ta[1].z + ta[2].z + ta[3].z + ta[4].z)/4]
		)
	)
	
fn get_instances myinput = 
	(
	instances_array = #()
	if (refs.dependents myinput.baseobject).count != 0 then
		(
		for w = 1 to (refs.dependents myinput.baseobject).count do
			(
			if (refs.dependents myinput.baseobject)[w] != myinput then
				(
				if iskindof (refs.dependents myinput.baseobject)[w] (classof myinput) then
					(
					append instances_array (refs.dependents myinput.baseobject)[w]
					)
				)
			)
		)
	return instances_array
	)
	
fn howmanypolys i = 
	(
	(getpolygoncount i)[1]
	)
	
fn howmanyverts i = 
	(
	(getpolygoncount i)[2]
	)

fn percent_boxes_overlap box1 box2 = 
	(
	diffBox_max = [0,0,0]
	diffBox_min = [0,0,0]
	frac = 0.0
	
	if (box1.min.x > box2.min.x) then diffBox_min.x = box1.min.x
	else diffBox_min.x = box2.min.x

	if (box1.max.x < box2.max.x) then diffBox_max.x = box1.max.x
	else diffBox_max.x = box2.max.x

	if (box1.min.y > box2.min.y) then diffBox_min.y = box1.min.y
	else diffBox_min.y = box2.min.y

	if (box1.max.y < box2.max.y) then diffBox_max.y = box1.max.y
	else diffBox_max.y = box2.max.y

	if (box1.min.z > box2.min.z) then diffBox_min.z = box1.min.z
	else diffBox_min.z = box2.min.z
	
	if (box1.max.z < box2.max.z) then diffBox_max.z = box1.max.z
	else diffBox_max.z = box2.max.z

	extent1 = diffBox_max - diffBox_min
	extent2 = box2.max - box2.min

	vol1 = extent1.x * extent1.y * extent1.z
	vol2 = extent2.x * extent2.y * extent2.z

	if (vol2 != 0.0) then frac = vol1 / vol2
	else frac = 0.0

	frac
	)

-------------------------------------------------------------------------------
-- Selections
-------------------------------------------------------------------------------

fn get_scene_ss_names = 
	(
	a = #()
	num = getNumNamedSelSets()
	if num != 0 then
		(
		for i = 1 to num do
			(
			append a (getNamedSelSetName i)
			)
		)
	return a
	)

-------------------------------------------------------------------------------
-- Strings
-------------------------------------------------------------------------------

fn commafy s =
	(
	ss = s as string
	r = (ss.count)/3
	if r < 1 then return ss
	else
		(
		rs = reverse_string ss
		fs = ""
		for i = 1 to r do
			(
			fs += (substring rs ((i*3)-2) 3) + ","
			)
		fs += substring rs ((r*3)+1) (rs.count-(r*3))
		if fs[fs.count] == "," then fs = substring fs 1 (fs.count-1)
		return (reverse_string fs)
		)
	)
	
fn compare_case_insensitive s1 s2 = 
	(
	if (lowercase s1) < (lowercase s2) then return -1
	else if (lowercase s1) > (lowercase s2) then return 1
	else return 0
	)

fn compare_case_sensitive s1 s2 = 
	(
	if s1 < s2 then return -1
	else if s1 > s2 then return 1
	else return 0
	)
	
fn double_backslash_string s1 = 
	(
	s2 = ""
	if s1.count != 0 then
		(
		for i = 1 to s1.count do
			(
			m = s1[i]
			if m == "\\" and s1[(i+1)] != "\\" then
				(
				m = "\\\\"
				)
			s2 += m
			)
		)
	return s2
	)

fn extra_zeros num zeros =
	(
	local a = (num as string)
	for w = 1 to 99999 do
		(
		if a.count < zeros then a = "0" + a
		else exit
		)
	return a
	)

fn findandreplace_string s f r = 
	(
	where_to_add = findString s f
	if where_to_add != undefined then return (replace s where_to_add f.count r)
	else return s
	)
	
fn lowercase instring =
	(
	upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	lower="abcdefghijklmnopqrstuvwxyz" 
	outstring=copy instring 
	for i = 1 to outstring.count do 
		(
		j=findString upper outstring[i]
		if (j != undefined) do outstring[i]=lower[j]
		)
	outstring
	)
	
fn name_compare_case_insensitive s1 s2 = 
	(
	if (lowercase s1.name) < (lowercase s2.name) then return -1
	else if (lowercase s1.name) > (lowercase s2.name) then return 1
	else return 0
	)

fn name_compare_case_sensitive s1 s2 = 
	(
	if s1.name < s2.name then return -1
	else if s1.name > s2.name then return 1
	else return 0
	)

fn postfix_string s n = 
	(
	return s + n
	)

fn prefix_string s n = 
	(
	return n + s
	)
	
fn remove_from_string s token = 
	(
	if s.count == 0 then return s
	else
		(
		newstring = ""
		for i = 1 to s.count do
			(
			if s[i] != token then newstring += s[i]
			)
		return newstring	
		)
	)

fn rename_string s n = 
	(
	return n
	)

fn reverse_string s =
	(
	new_string = ""
	if s.count != 0 then
		(
		for i = s.count to 1 by -1 do
			(
			new_string += s[i]
			)
		)
	return new_string
	)
	
fn string_is_number s = 
	(
	if classof s != string then return false
	else
		(
		if s.count == 0 then return false
		else
			(
			for i = 1 to s.count do
				(
				if \
				s[i] == "0" or \
				s[i] == "1" or \
				s[i] == "2" or \
				s[i] == "3" or \
				s[i] == "4" or \
				s[i] == "5" or \
				s[i] == "6" or \
				s[i] == "7" or \	
				s[i] == "8" or \
				s[i] == "9" \
				then continue
				else return false
				)
			return true
			)
		)
	)

fn uppercase instring =
	(
	upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	lower="abcdefghijklmnopqrstuvwxyz" 
	outstring=copy instring 
	for i = 1 to outstring.count do 
		(
		j=findString lower outstring[i]
		if (j != undefined) do outstring[i]=upper[j]
		)
	outstring
	)
	
-------------------------------------------------------------------------------
-- Transforms
-------------------------------------------------------------------------------

fn axisRotate obj rotation =  
	(	
	local axis
	local objA = if classof obj == objectSet or classof obj == array then obj else #(obj)
	if getCoordCenter() != #local then
		(
		axis = getTransformAxis objA[1] 0
		for obj1 in objA do in coordsys axis about axis rotate obj1 rotation
		)
	else
		(
		for obj1 in objA do
			(
			axis = getTransformAxis obj1 0
			in coordsys axis about axis rotate obj1 rotation
			)
		)
	)

-------------------------------------------------------------------------------
-- Initialization End
-------------------------------------------------------------------------------
Print "BSLib v 1.33 Loaded"
bslib_enabled = true
)
-------------------------------------------------------------------------------