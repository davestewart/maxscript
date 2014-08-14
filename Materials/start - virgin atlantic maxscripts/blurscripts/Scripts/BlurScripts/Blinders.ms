-------------------------------------------------------------------------------
-- Blinders.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.02
-- Created On: 11/15/00
-- Modified On: 03/15/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Helps with projects such as ride films, where there's a lot of geometry that
-- gets processed needlessly. Basically, if an object isn't visible to the camera
-- at a given frame, (like you've already passed it and it's behind the camera 
-- now) it's still getting analyzed during the preparing objects stage, wasting 
-- render time. This wasted time can become tremendous when you have a really 
-- large environment, as in when you're doing tunnel blast scenes for ride films. 
-- So, what you do is create a box that follows your camera, everything inside 
-- this box at a given frame will be given a visibility track with a value of 1, 
-- everything outside the box will be given a visibility track with a value of 0, 
-- so now objects are only visible if it's near the camera inside the box.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Helps with projects such as ride films, where there's a lot of geometry that
-- gets processed needlessly. Basically, if an object isn't visible to the camera
-- at a given frame, (like you've already passed it and it's behind the camera 
-- now) it's still getting analyzed during the preparing objects stage, wasting 
-- render time. This wasted time can become tremendous when you have a really 
-- large environment, as in when you're doing tunnel blast scenes for ride films. 
-- So, what you do is create a box that follows your camera, everything inside 
-- this box at a given frame will be given a visibility track with a value of 1, 
-- everything outside the box will be given a visibility track with a value of 0, 
-- so now objects are only visible if it's near the camera inside the box.
--
-- v 1.01 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.02 Changed the function do_boxes_overlap in BSLib, those changes are
-- now reflected here.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- If objects behind the camera are still casting shadows into your current 
-- frame, you may have a problem or two with shadows popping on and off (when 
-- objects that are no longer in your box disappear, their shadows disappear as 
-- well). If this happens, just increase the size of your box (or you can 
-- animate the size so it just covers what it needs to when it needs to.)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global bound_obj = undefined

global bli_collect_objects
global edit_the_key
global fix_frame_0
global test_inter
global choose_objects
global choose_time
global start_bli

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

obj_collection = #()

bt_value = 1

use_active_time_value = true
start_time_value = 0
end_time_value = 100

update_view_value = false
no_hidden_value = true

-- Functions

fn bli_collect_objects = 
(
	obj_collection = #()
	for i in $* do
	(
		if i != bound_obj then 
		(
			if i.ishidden == true and no_hidden_value == true then continue
			else 
			(
				if superclassof i == GeometryClass or superclassof i == shape then 
				(
					append obj_collection i
				)
			)				
		)
	)
)
	
fn edit_the_key cont = 
(
	k = getkey cont (getKeyIndex cont sliderTime)
	k.inTangentType = #step
	k.outTangentType = #step
)
	
fn fix_frame_0 =
(
	sliderTime = 0
	choose_objects()
)
	
fn bt_obj_bb obj = 
(
	if (do_boxes_overlap bound_obj.max bound_obj.min obj.max obj.min) == true then animate on at time sliderTime obj.visibility=true
	else animate on at time sliderTime obj.visibility=false
)
	
fn choose_objects = 
(
	for w in obj_collection do
	(
		if bt_value == 1 then bt_obj_bb w
		edit_the_key w[1].controller
	)
)
	
fn choose_time = 
(
	if use_active_time_value == true then 
	(
		p = (animationRange.start as integer) / 160
		q = (animationRange.end as integer) / 160
	)
	else
	(
		p = start_time_value
		q = end_time_value
	)
	sliderTime = p
	if update_view_value == false then 
	(
		disableSceneRedraw()	
	)
	my_endtime = (q - p + 1)
	for mytime = 1 to my_endtime do 
	(
		if sliderTime != 0 then choose_objects()
		sliderTime += 1
	)
	fix_frame_0()
	if update_view_value == false then 
	(
		enableSceneRedraw()
		redrawViews()
	)
)

fn start_bli = 
(
	try 
	(
		if bound_obj == undefined then (MessageBox "Please select a Bounding Object" title:"Blinders")
		else
		(
			if use_active_time_value == 0 and start_time_value > end_time_value then
			(
				MessageBox "Your start time is later then your end time, please reenter." title:"Blinders"
			)
			else 
			(
				bli_collect_objects()
				choose_time()
			)
		)
	)
	catch (MessageBox "An error has occured, you may have accidently deleted your Bounding Object. If so, please re-pick it." title:"Blinders")
)

-- Script
	
rollout bli_rollout "Blinders"
(
	group "Bounding"
(
	dropdownlist bounding_type "" items:#("Object Bounding Box") align:#center
	
--	To be added, Object Volume, Plane, Camera Plane, Camera View
	
	label bound_obj_label "None" align:#center
	pickbutton pickobject "Pick" width:120 align:#center toolTip:"Pick" filter:geometry_filter
)
	
	on bounding_type selected i do bt_value = i	
	on pickobject picked obj do 
	(
		bound_obj = obj
		bound_obj_label.text = obj.name		
	)

	group "Time"
(
	spinner start_time "Start: " range:[-9999999,9999999,0] type:#integer fieldWidth:50 align:#center across:2 enabled:false
	spinner end_time " End: " range:[-9999999,9999999,100] type:#integer fieldWidth:50 align:#center enabled:false
	checkbox use_active_time "Use Active Time Segment" checked:true align:#center
)
	on start_time changed val do start_time_value = val
	on end_time changed val do end_time_value = val
	on use_active_time changed state do 
	(
		if use_active_time.checked == true then 
		(
			start_time.enabled = false
			end_time.enabled = false
			use_active_time_value = true
		)
		else 
		(
			start_time.enabled = true
			end_time.enabled = true
			use_active_time_value = false
		)
	)
	
	group "Process"
(
	checkbox update_view "Update Viewport After Each Frame" checked:false align:#center
	checkbox no_hidden "Do Not Process Hidden Objects" checked:true align:#center
	button doit "Start The Process" width:180 align:#center toolTip:"Start The Process"
)
	on update_view changed state do 
	(
		if update_view.checked == true then update_view_value = true
		else update_view_value = false
	)
	on no_hidden changed state do 
	(
		if no_hidden.checked == true then no_hidden_value = true
		else no_hidden_value = false
	)
	on doit pressed do start_bli()
)

if bli_floater != undefined then CloseRolloutFloater bli_floater
bli_floater = newRolloutFloater "Blinders v1.02" 240 322
addRollout bli_rollout bli_floater
)
-------------------------------------------------------------------------------