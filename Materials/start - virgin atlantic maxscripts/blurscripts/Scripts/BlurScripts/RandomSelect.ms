-------------------------------------------------------------------------------
-- RandomSelect.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.21
-- Created On: 08/28/00
-- Modified On: 06/20/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes any selection and deselects objects at random based on a weight, number
-- or percentage. Good for selecting random objects from a set and then later 
-- applying modifiers or materials to them.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes any selection and deselects objects at random based on a weight. 
-- Good for selecting random objects from a set and then later applying modifiers
-- or materials to them.
--
-- v 1.10 Added ability to select by number and percentage as well as the
-- original weight. 
--
-- v 1.20 Compatible now with R4.
--
-- v 1.21 Major code cleaning, moved some stuff to BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global select_random_objects
global rs_filters

global rs_rollout
global rs_floater

-- Variables

weight_value = 50
percentage_value = 50
exact_num_value = 0

select_array = #()

-- Functions

fn select_random_objects objs selecttype = 
	(
	select_array = #()
		
	if selecttype == 1 then select_array = choose_unique_by_weight objs weight_value
	else if selecttype == 2 then select_array = choose_unique_by_number objs exact_num_value
	else select_array = choose_unique_by_percentage objs percentage_value
		
	select select_array
	select_array = #()
	)
	
fn rs_filters selecttype =
	(
	undo "RandomSelect" on
		(
		if selection.count == 0 then (MessageBox "Please select at least one object" title:"RandomSelect")
		else
			(
			objs = for i in selection collect i
			select_random_objects objs selecttype
			)
		)
	)

-- Script

rollout rs_rollout "RandomSelect"
	(
	spinner weight_spinner "Weight:" range:[0,100,50] type:#integer fieldWidth:40 across:2 align:#right offset:[22,0] 
	button do_weight "Select" width:65 toolTip:"Select" align:#right
	spinner exact_number "Exact Number:" range:[0,9999999,0] type:#integer fieldWidth:40 across:2 align:#right offset:[22,0] 
	button do_num "Select" width:65 toolTip:"Select" align:#right
	spinner per_spinner "Percentage %:" range:[0,100,50] type:#float fieldWidth:40 across:2 align:#right offset:[22,0]
	button do_per "Select" width:65 toolTip:"Select" align:#right

	on weight_spinner changed val do weight_value = val
	on exact_number changed val do exact_num_value = val
	on per_spinner changed val do percentage_value = val

	on do_weight pressed do rs_filters 1
	on do_num pressed do rs_filters 2
	on do_per pressed do rs_filters 3
	)

if rs_floater != undefined then CloseRolloutFloater rs_floater
rs_floater = newRolloutFloater "RandomSelect v1.21" 250 148
addRollout rs_rollout rs_floater
)
-------------------------------------------------------------------------------