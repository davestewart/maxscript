-------------------------------------------------------------------------------
-- BigBrother.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.85
-- Created On: 03/20/00
-- Modified On: 06/28/02
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Creates a list of various scene properties, to show what parts of the scene 
-- the animator may wish to optimize, like shadow maps that don't need to be
-- as big, or uncollapsed modifier stacks that are too deep, etc.
--
-- I feel a little here like that guy who created the first atom bomb. While 
-- this script is very useful in finding areas of your scene where you may 
-- wish to be more efficient, in the wrong hands, information like this can be 
-- used to "prove" numerically the inefficiency of a particular individual. As 
-- any experienced animator knows, using the information you get from this 
-- script to harm another individual in the end harms the company, and therefor 
-- you harm yourself, and no one wants that, so let this and the name of the 
-- script be a warning to you all, use with caution, and use with the intention 
-- of making a faster rendering and better looking scene. Big brother should 
-- be a helping hand, not an iron fist.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Creates a list of various scene properties, to show what parts of the 
-- scene the animator may wish to optimize, like shadow maps that don't need to 
-- be as big, or uncollapsed modifier stacks that are too deep, etc.
--
-- v 1.01 Fixed lots of bugs...
-- 
-- 1) It now filters out objects with no modifiers from the list. 
-- 2) Fixed it so scenes that have a lot of editable meshes in them will 
-- process like 10 times faster. 
-- 3) It now plays fair with objects that have geometric spacewarps applied. 
-- 4) Fixed a bug that would crash the script if a raytraced light was in the 
-- scene.
-- 5) Fixed a bug that would report a negative map depth. 
-- 6) Modifier Stack List is now ordered by number of modifiers
--
-- v 1.10 Now it gathers information on renderable splines too.
--
-- v 1.20 Will now tell the user the name of the group an object is a part of
-- or none if the object isn't part of a group. Also works recursively, so
-- it will accurately report groups that are in groups.
--
-- v 1.30 Cleaned up the code a bit. Also changed the format of the output a 
-- bit to try and make it more readable, hopefully I'll be able to make it
-- even more readable in later versions of the script.
--
-- v 1.40 I'm now using some code provided by Larry Minton to help format the
-- output into columns. Thanks Larry. Also changed the default so all report
-- types are checked when you start the script.
--
-- v 1.50 Added lower bounds to most of the reports, so you can ignore
-- objects that don't meet the minumum requirement.
--
-- v 1.51 Fixed a bug that was causing the script to crash when the mapdepth
-- report checkbox was unchecked.
--
-- v 1.60 Added max value as well as a min value, to help narrow down exactly 
-- what you want in your report. Added a new report that looks for instances
-- of objects (warning, it can be very slow). Combined the modifier count and 
-- list into one function. Moved the min max checking code out of the display
-- code and to the functions themselves, so performance on big scenes will 
-- speed up a bit.
--
-- v 1.61 Removed code for finding the total face count for renderable splines
-- in the scene (use my Renderable Splines Face Count script instead). Report
-- can still be generated showing individual splines. Changed script so that
-- the instance report does not report an instance of itself in the list 
-- (however, the object's own instance is counted towards the instance total,
-- since you want to say "There's 3 instances of this object in the scene")
--
-- v 1.70 Added ability to ignore hidden and frozen objects.
--
-- v 1.71 Fixed a bug that would slow down reporting tremendously if you
-- have more than 40-50 instances of any particular object in your scene.
-- Changed the interface a bit.
--
-- v 1.72 Deals with frozen and hidden objects in a much nicer, friendlier way.
-- And cleaned up the min max code a bit.
--
-- v 1.73 Jon Seagull reported a bug where max would start slowing down if you
-- have several hundred instances of an object in your scene and you run big 
-- brother a few times. This might have to do with the persistence of some
-- arrays even after the script has run, so I'm now clearing all arrays after
-- the script stops running, hopefully to keep memory useage to a minimum.
-- 
-- v 1.80 Now compatible with R4.0, also cleaned a bunch of code, and moved some
-- code out to BSLib.
--
-- v 1.81 Moved Larry's prettify and format_table code to BSlib.ms
--
-- v 1.82 Fixed an r4 bug that stopped the script from properly reporting the
-- castshadow value of a light. And another r4 bug that stopped the proper 
-- reporting of renderable splines. Changed the floater closing code from a 
-- try / catch to an undefined test.
--
-- v 1.83 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.84 SceneMaterials code now replaced with get_scene_materials().
--
-- v 1.85 Changed the way the script decides whether a light is using shadowmaps
-- or not.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global list_the_array
global are_you_part_of_a_group
global getfacecount
global getinstances
global compareinstances
global getmodifierstacklist
global getshadowcastinglights
global getshadowmapsize
global getmapdepth_single
global getmapdepth
global sortthearrays
global showtheoutput
global dothesearch
global minmax_error
global check_for_min_max_probs

global bb_rollout
global bb_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

ignore_hidden_value = 0
ignore_frozen_value = 0
min_instance_report_value = 1

do_facecount_value = 1
do_findinstances_value = 1
do_modifierstacklist_value = 1
do_shadowcastinglights_value = 1
do_shadowmapsize_value = 1
do_mapdepth_value = 1

facecount_min_value = 1
findinstances_min_value = 1
modifierstacklist_min_value = 1
shadowmapsize_min_value = 256
mapdepth_min_value = 1

facecount_max_value = 9999999
findinstances_max_value = 100
modifierstacklist_max_value = 10
shadowmapsize_max_value = 10000
mapdepth_max_value = 10

facecount_max_enable_value = 0
findinstances_max_enable_value = 0
modifierstacklist_max_enable_value = 0
shadowmapsize_max_enable_value = 0
mapdepth_max_enable_value = 0

maxdepth = 0
numberofshadowcastinglights = 0
ow = 0

facecount_array = #()
findinstances_array = #()
findinstances_single_array = #()
findinstances_compare_array = #()
findinstances_compare_single_array = #()
modifierstacklist_array = #()
modifierstacklist_single_array = #()
shadowmapsize_array = #()
mapdepth_array = #()
groupmember_array = #()

-- Functions

fn list_the_array inputarray theoutputarea =
	(
	for z = 1 to inputarray.count do
		(
		if z == inputarray.count then
			(
			format "%" inputarray[z] to:theoutputarea
			)
		else
			(
			format "%, " inputarray[z] to:theoutputarea
			)
		)
	)

fn are_you_part_of_a_group inputnode =
	(
	if isgroupmember inputnode == true then 
		(
		if isGroupHead inputnode.parent then
			(
			append groupmember_array inputnode.parent.name
			)
		if isgroupmember inputnode.parent then 
			(
			are_you_part_of_a_group inputnode.parent
			)
		)
	)

fn getfacecount myinput = 
	(
	groupmember_array = #()
	facenumber = howmanypolys myinput
	if facenumber >= facecount_min_value then
		(
		if facecount_max_enable_value == 1 then
			(
			if facenumber <= facecount_max_value then
				(
				are_you_part_of_a_group myinput
				append facecount_array #(myinput.name, facenumber, groupmember_array)
				)
			)
		else
			(
			are_you_part_of_a_group myinput
			append facecount_array #(myinput.name, facenumber, groupmember_array)
			)
		)
	)

fn getinstances myinput =
	(
	groupmember_array = #()
	if (refs.dependents myinput.baseobject).count != 0 then
		(
		for w = 1 to (refs.dependents myinput.baseobject).count do
			(
			if (refs.dependents myinput.baseobject)[w] != myinput then
				(
				if iskindof (refs.dependents myinput.baseobject)[w] (classof myinput) then
					(
					append findinstances_single_array (refs.dependents myinput.baseobject)[w].name
					append findinstances_compare_single_array (refs.dependents myinput.baseobject)[w]
					)
				)
			)
		)
	if findinstances_single_array.count >= findinstances_min_value then
		(
		if findinstances_max_enable_value == 1 then
			(
			if findinstances_single_array.count <= findinstances_max_value then
				(
				are_you_part_of_a_group myinput
				append findinstances_array #(myinput.name, findinstances_single_array.count, findinstances_single_array, groupmember_array)
				)
			)
		else
			(
			are_you_part_of_a_group myinput
			append findinstances_array #(myinput.name,(findinstances_single_array.count + 1), findinstances_single_array, groupmember_array)
			)
		)
	findinstances_compare_array = findinstances_compare_array + findinstances_compare_single_array
	)

fn compareinstances myinput =
	(
	ow = 0
	if findinstances_compare_array.count != 0 then
		(
		for w = 1 to findinstances_compare_array.count do
			(
			if myinput == findinstances_compare_array[w] then ow = 1
			)
		if ow == 0 then getinstances myinput
		)
	else getinstances myinput
	)

fn getmodifierstacklist myinput =
	(
	groupmember_array = #()
	if myinput.modifiers.count >= modifierstacklist_min_value then
		(
		if modifierstacklist_max_enable_value == 1 then
			(
			if myinput.modifiers.count <= modifierstacklist_max_value then
				(
				if (refs.dependents myinput.baseobject).count != 0 then
					(
					for w = 1 to myinput.modifiers.count do
						(
						append modifierstacklist_single_array (classof myinput.modifiers[w])
						)
					)
				are_you_part_of_a_group myinput
				append modifierstacklist_array #(myinput.name, myinput.modifiers.count, modifierstacklist_single_array, groupmember_array)
				)
			)
		else
			(
			if (refs.dependents myinput.baseobject).count != 0 then
				(
				for w = 1 to myinput.modifiers.count do
					(
					append modifierstacklist_single_array (classof myinput.modifiers[w])
					)
				)
			are_you_part_of_a_group myinput
			append modifierstacklist_array #(myinput.name, myinput.modifiers.count, modifierstacklist_single_array, groupmember_array)
			)
		)
	)

fn getshadowcastinglights myinput =
	(
	if myinput.baseobject.castShadows == true then numberofshadowcastinglights = numberofshadowcastinglights + 1
	)

fn getshadowmapsize myinput =
	(
	groupmember_array = #()
	if classof (getproperty myinput "shadowgenerator") == shadowmap then
		(
		if myinput.mapsize >= shadowmapsize_min_value then
			(
			if shadowmapsize_max_enable_value == 1 then
				(
				if myinput.mapsize <= shadowmapsize_max_value then
					(
					are_you_part_of_a_group myinput
					try (append shadowmapsize_array #(myinput.name, myinput.mapsize, groupmember_array)) catch ()
					)
				)
			else 
				(
				are_you_part_of_a_group myinput
				try (append shadowmapsize_array #(myinput.name, myinput.mapsize, groupmember_array)) catch ()
				)
			)
		)
	)

fn getmapdepth_single onwhat depth = 
	(
	if onwhat.numsubs != 0 then
		(
		for i = 1 to onwhat.numsubs do
			(
			if depth > maxdepth then maxdepth = depth
			getmapdepth_single onwhat[i] (depth+1)
			)
		)
	maxdepth - 2
	)

fn getmapdepth =
	(
	scenemat = (get_scene_materials())
	for k = 1 to scenemat.count do
		(
		depth = 0
		maxdepth = 0
		themaxdepth = (getmapdepth_single scenemat[k] 0)
		if themaxdepth < 0 then themaxdepth = 0
		if themaxdepth >= mapdepth_min_value then
			(
			if mapdepth_max_enable_value == 1 then
				(
				if themaxdepth <= mapdepth_max_value then
					(	
					append mapdepth_array #(scenemat[k].name, themaxdepth)
					)
				)
			else
				(
				append mapdepth_array #(scenemat[k].name, themaxdepth)
				)
			)
		)
	)

fn sortthearrays =
	(
	if facecount_array.count > 1 then qsort facecount_array (fn greater_then_sort x y = (y[2] - x[2]))
	if findinstances_array.count > 1 then qsort findinstances_array (fn greater_then_sort x y = (y[2] - x[2]))
	if modifierstacklist_array.count > 1 then qsort modifierstacklist_array (fn greater_then_sort x y = (y[2] - x[2]))
	if shadowmapsize_array.count > 1 then qsort shadowmapsize_array (fn greater_then_sort x y = (y[2] - x[2]))
	if mapdepth_array.count > 1 then qsort mapdepth_array (fn greater_then_sort x y = (y[2] - x[2]))
	)

fn showtheoutput = 
	(
	bigbrotherresults = newScript()
	format "---------------------------------------------------------------------------\n" to:bigbrotherresults
	format "Big Brother Results\n" to:bigbrotherresults
	format "---------------------------------------------------------------------------\n" to:bigbrotherresults
	if do_facecount_value == 1 then
		(
		format "\n" to:bigbrotherresults
		format "Face Count\n" to:bigbrotherresults
		format "---------------------------------------------------------------------------\n" to:bigbrotherresults
		outTable1=stringStream ""
		for j = 1 to facecount_array.count do
			(		
			if facecount_array[j][3].count == 0 then
				(
				format "\t%\t% Faces\n" (prettify facecount_array[j][1]) (prettify facecount_array[j][2]) to:outTable1
				)
			else
				(
				format "\t%\t% Faces" (prettify facecount_array[j][1]) (prettify facecount_array[j][2]) to:outTable1
				format "      Group: " to:outTable1
				list_the_array facecount_array[j][3] outTable1
				format "\n" to:outTable1
				)
			)
		format "%" (format_table outTable1 2) to:bigbrotherresults
		)
	if do_findinstances_value == 1 then
		(
		format "\n" to:bigbrotherresults
		format "Find Instances\n" to:bigbrotherresults
		format "---------------------------------------------------------------------------\n" to:bigbrotherresults
		outTable3=stringStream ""
		for j = 1 to findinstances_array.count do
			(
			if findinstances_array[j][4].count == 0 then
				(
				tempstream2=stringStream ""
				list_the_array findinstances_array[j][3] tempstream2
				format "\t%\t%\t%\n" (prettify findinstances_array[j][1]) (prettify findinstances_array[j][2]) (prettify tempstream2) to:outTable3
				)
			else
				(
				tempstream2=stringStream ""
				list_the_array findinstances_array[j][3] tempstream2
				tempstream3=stringStream ""
				list_the_array findinstances_array[j][4] tempstream3
				format "\t%\t%\t%\tGroup: %\n" (prettify findinstances_array[j][1]) (prettify findinstances_array[j][2]) (prettify tempstream2) (prettify tempstream3) to:outTable3
				)
			)
		format "%" (format_table outTable3 2) to:bigbrotherresults
		)
	if do_modifierstacklist_value == 1 then
		(
		format "\n" to:bigbrotherresults
		format "Modifier Stack List\n" to:bigbrotherresults
		format "---------------------------------------------------------------------------\n" to:bigbrotherresults
		outTable4=stringStream ""
		for j = 1 to modifierstacklist_array.count do
			(
			if modifierstacklist_array[j][4].count == 0 then
				(
				tempstream2=stringStream ""
				list_the_array modifierstacklist_array[j][3] tempstream2
				format "\t%\t%\t%\n" (prettify modifierstacklist_array[j][1]) (prettify modifierstacklist_array[j][2]) (prettify tempstream2) to:outTable4
				)
			else
				(
				tempstream2=stringStream ""
				list_the_array modifierstacklist_array[j][3] tempstream2
				tempstream3=stringStream ""
				list_the_array modifierstacklist_array[j][4] tempstream3
				format "\t%\t%\t%\tGroup: %\n" (prettify modifierstacklist_array[j][1]) (prettify modifierstacklist_array[j][2]) (prettify tempstream2) (prettify tempstream3) to:outTable4
				)
			)
		format "%" (format_table outTable4 2) to:bigbrotherresults
		)
	if do_shadowcastinglights_value == 1 then
		(
		format "\n" to:bigbrotherresults
		format "Shadow Casting Lights\n" to:bigbrotherresults
		format "---------------------------------------------------------------------------\n" to:bigbrotherresults
		format "Number Of Shadow Casting Lights:%\n" numberofshadowcastinglights to:bigbrotherresults
		)
	if do_shadowmapsize_value == 1 then
		(
		format "\n" to:bigbrotherresults
		format "Shadow Map Sizes\n" to:bigbrotherresults
		format "---------------------------------------------------------------------------\n" to:bigbrotherresults
		outTable5=stringStream ""
		for j = 1 to shadowmapsize_array.count do
			(
			if shadowmapsize_array[j][3].count == 0 then
				(
				format "\t%\t%\n" (prettify shadowmapsize_array[j][1]) (prettify shadowmapsize_array[j][2]) to:outTable5
				)
			else
				(
				format "% %" (prettify shadowmapsize_array[j][1]) (prettify shadowmapsize_array[j][2]) to:outTable5
				format "      Group: " to:outTable5
				list_the_array shadowmapsize_array[j][3] outTable5
				format "\n" to:outTable5
				)
			)
		format "%" (format_table outTable5 2) to:bigbrotherresults
		)
	if do_mapdepth_value == 1 then
		(
		format "\n" to:bigbrotherresults
		format "Map Depth\n" to:bigbrotherresults
		format "---------------------------------------------------------------------------\n" to:bigbrotherresults
		outTable6=stringStream ""
		for j = 1 to mapdepth_array.count do
			(
			format "\t%\t% Levels\n" (prettify mapdepth_array[j][1]) (prettify mapdepth_array[j][2]) to:outTable6
			)
		format "%" (format_table outTable6 2) to:bigbrotherresults
		)
	)

fn dothesearch =
	(
	-- Clear

	maxdepth = 0
	numberofshadowcastinglights = 0

	facecount_array = #()
	findinstances_array = #()
	findinstances_single_array = #()
	findinstances_compare_array = #()
	findinstances_compare_single_array = #()
	modifierstacklist_array = #()
	modifierstacklist_single_array = #()
	shadowmapsize_array = #()
	mapdepth_array = #()
	groupmember_array = #()

	-- Do The Search

	for i in $* do
		(
		if i.ishidden == true and ignore_hidden_value == 1 then continue
		else
			(
			if i.isfrozen == true and ignore_frozen_value == 1 then continue
			else
				(
				if superclassof i == GeometryClass and do_facecount_value == 1 then getfacecount i
				if superclassof i == shape and do_facecount_value == 1 then getfacecount i
				if do_findinstances_value == 1 then 
					(
					if min_instance_report_value == 1 then compareinstances i
					else getinstances i
					)
				if superclassof i == GeometryClass and do_modifierstacklist_value == 1 then getmodifierstacklist i
				if superclassof i == light and standard_light_filter i == true and do_shadowcastinglights_value == 1 then getshadowcastinglights i
				if superclassof i == light and standard_light_filter i == true and do_shadowmapsize_value == 1 and i.baseobject.castshadows == true then getshadowmapsize i
				findinstances_single_array = #()
				modifierstacklist_single_array = #()
				findinstances_compare_single_array = #()
				)
			)
		)
	if do_mapdepth_value == 1 then getmapdepth ()
	sortthearrays ()
	showtheoutput ()

	facecount_array = #()
	findinstances_array = #()
	findinstances_single_array = #()
	findinstances_compare_array = #()
	findinstances_compare_single_array = #()
	modifierstacklist_array = #()
	modifierstacklist_single_array = #()
	shadowmapsize_array = #()
	mapdepth_array = #()
	groupmember_array = #()
	)

fn minmax_error =
	(
	(MessageBox "One of your min values is greater then it's corresponding max value. Please reenter." title:"BigBrother")
	)

fn check_for_min_max_probs =
	(
	stopme = 0
	if facecount_max_value < facecount_min_value and facecount_max_enable_value == 1 then (minmax_error () stopme = 1)
	if findinstances_max_value < findinstances_min_value and findinstances_max_enable_value == 1 then (minmax_error () stopme = 1)
	if modifierstacklist_max_value < modifierstacklist_min_value and modifierstacklist_max_enable_value == 1 then (minmax_error () stopme = 1)
	if shadowmapsize_max_value < shadowmapsize_min_value and shadowmapsize_max_enable_value == 1 then (minmax_error () stopme = 1)
	if mapdepth_max_value < mapdepth_min_value and mapdepth_max_enable_value == 1 then (minmax_error () stopme = 1)
	if stopme == 0 then dothesearch ()
	)

-- The Script

rollout bb_rollout "BigBrother"
	(
	group "Report Types"
	(
	checkbox do_facecount "Face Count" checked:true across:4
	spinner facecount_min "Min: " range:[0,9999999,1] fieldWidth:60 type:#integer offset:[70,0]
	spinner facecount_max "Max: " range:[0,9999999,9999999] fieldWidth:60 type:#integer enabled:false offset:[75,0]
	checkbox facecount_max_enable "" offset:[81,0]

	checkbox do_findinstances "Find Instances" checked:true across:4
	spinner findinstances_min "Min: " range:[0,99999,1] fieldWidth:60 type:#integer offset:[70,0]
	spinner findinstances_max "Max: " range:[0,99999,100] fieldWidth:60 type:#integer enabled:false offset:[75,0]
	checkbox findinstances_max_enable "" offset:[81,0]

	checkbox do_modifierstacklist "Modifier Stack List" checked:true across:4
	spinner modifierstacklist_min "Min: " range:[0,99999,1] fieldWidth:60 type:#integer offset:[70,0]
	spinner modifierstacklist_max "Max: " range:[0,99999,10] fieldWidth:60 type:#integer enabled:false offset:[75,0]
	checkbox modifierstacklist_max_enable "" offset:[81,0]

	checkbox do_shadowcastinglights "Shadow Casting Lights" checked:true align:#left

	checkbox do_shadowmapsize "Shadow Map Size" checked:true across:4
	spinner shadowmapsize_min "Min: " range:[0,99999,256] fieldWidth:60 type:#integer offset:[70,0]
	spinner shadowmapsize_max "Max: " range:[0,99999,10000] fieldWidth:60 type:#integer enabled:false offset:[75,0]
	checkbox shadowmapsize_max_enable "" offset:[81,0]

	checkbox do_mapdepth "Map Depth" checked:true across:4
	spinner mapdepth_min "Min: " range:[0,99999,1] fieldWidth:60 type:#integer offset:[70,0]
	spinner mapdepth_max "Max: " range:[0,99999,10] fieldWidth:60 type:#integer enabled:false offset:[75,0]
	checkbox mapdepth_max_enable "" offset:[81,0]
	)

	on do_facecount changed state do 
		(
		if do_facecount.checked == true then do_facecount_value = 1
		else do_facecount_value = 0
		)
	on facecount_min changed val do facecount_min_value = val
	on facecount_max changed val do facecount_max_value = val
	on facecount_max_enable changed state do 
		(
		facecount_max.enabled = state
		if facecount_max_enable.checked == true then facecount_max_enable_value = 1
		else facecount_max_enable_value = 0
		)

	on do_findinstances changed state do 
		(
		if do_findinstances.checked == true then do_findinstances_value = 1
		else do_findinstances_value = 0
		)
	on findinstances_min changed val do findinstances_min_value = val
	on findinstances_max changed val do findinstances_max_value = val
	on findinstances_max_enable changed state do 
		(
		findinstances_max.enabled = state
		if findinstances_max_enable.checked == true then findinstances_max_enable_value = 1
		else findinstances_max_enable_value = 0
		)

	on do_modifierstacklist changed state do 
		(
		if do_modifierstacklist.checked == true then do_modifierstacklist_value = 1
		else do_modifierstacklist_value = 0
		)
	on modifierstacklist_min changed val do modifierstacklist_min_value = val
	on modifierstacklist_max changed val do modifierstacklist_max_value = val
	on modifierstacklist_max_enable changed state do 
		(
		modifierstacklist_max.enabled = state
		if modifierstacklist_max_enable.checked == true then modifierstacklist_max_enable_value = 1
		else modifierstacklist_max_enable_value = 0
		)

	on do_shadowcastinglights changed state do 
		(
		if do_shadowcastinglights.checked == true then do_shadowcastinglights_value = 1
		else do_shadowcastinglights_value = 0
		)

	on do_shadowmapsize changed state do 
		(
		if do_shadowmapsize.checked == true then do_shadowmapsize_value = 1
		else do_shadowmapsize_value = 0
		)
	on shadowmapsize_min changed val do shadowmapsize_min_value = val
	on shadowmapsize_max changed val do shadowmapsize_max_value = val
	on shadowmapsize_max_enable changed state do 
		(
		shadowmapsize_max.enabled = state
		if shadowmapsize_max_enable.checked == true then shadowmapsize_max_enable_value = 1
		else shadowmapsize_max_enable_value = 0
		)

	on do_mapdepth changed state do 
		(
		if do_mapdepth.checked == true then do_mapdepth_value = 1
		else do_mapdepth_value = 0
		)
	on mapdepth_min changed val do mapdepth_min_value = val
	on mapdepth_max changed val do mapdepth_max_value = val
	on mapdepth_max_enable changed state do 
		(
		mapdepth_max.enabled = state
		if mapdepth_max_enable.checked == true then mapdepth_max_enable_value = 1
		else mapdepth_max_enable_value = 0
		)

	group "Options"
	(
	checkbox ignore_hidden "Ignore Hidden" across:3
	checkbox ignore_frozen "Ignore Frozen"
	checkbox min_instance_report "Minimize Instance Report" checked:true
	)

	group "Make Report"
	(
	button Doit "Make Report" width:130 align:#center toolTip:"Make Report"
	)

	on Doit pressed do check_for_min_max_probs ()
	on ignore_hidden changed state do 
		(
		if ignore_hidden.checked == true then ignore_hidden_value = 1
		else ignore_hidden_value = 0
		)
	on ignore_frozen changed state do 
		(
		if ignore_frozen.checked == true then ignore_frozen_value = 1
		else ignore_frozen_value = 0
		)
	on min_instance_report changed state do 
		(
		if min_instance_report.checked == true then min_instance_report_value = 1
		else 
			(
			min_instance_report_value = 0
			(MessageBox "Warning: This could make the Find Instances report very slow if you have more then 40-50 instances of any particular object in your scene." title:"BigBrother")
			)
		)
	)

if bb_floater != undefined then CloseRolloutFloater bb_floater
bb_floater = newRolloutFloater "BigBrother v1.85" 465 315
addRollout bb_rollout bb_floater
)
-------------------------------------------------------------------------------