-------------------------------------------------------------------------------
-- GodsEyeView.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.02
-- Created On: 08/08/01
-- Modified On: 10/15/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Quickly makes an ortho camera from one of three vantage points. Good if you
-- say want to quickly setup a camera aligned to an orthoview, or good if
-- you want to render some elements flat.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Quickly makes an ortho camera from one of three vantage points. Good if 
-- you say want to quickly setup a camera aligned to an orthoview, or good if
-- you want to render some elements flat.
--
-- v 1.01 No longer looses selection when you run the script.
--
-- v 1.02 Renames camera target to reflect camera name.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global gev_func
global gev_ok

global gev_rollout

-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Variables

prim_axis_value = 2

-- Functions

fn gev_func = 
(
	undo "GodsEyeView" on
	(
		w = get_scene_bbox()
		myc = box_center w[1] w[2]
		
		if prim_axis_value == 1 then
		(
			c = Targetcamera pos:[myc.x,3*(w[2][2]),myc.z] target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [myc.x,0,myc.z]))
		)
		else if prim_axis_value == 2 then
		(
			c = Targetcamera pos:[myc.x,myc.y,3*(w[1][3])] target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [myc.x,myc.y,0]))
		)
		else
		(
			c = Targetcamera pos:[3*(w[2][1]),myc.y,myc.z] target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,myc.y,myc.z]))
		)
		c.target.name = c.name + ".Target"
			
		c.orthoProjection = true
		viewport.setCamera c
		displaySafeFrames = true
	)
)
	
fn gev_ok = 
(
	gev_func()
	destroydialog gev_rollout
)

-- Rollouts

rollout gev_rollout "GodsEyeView v1.02" 
(
	dropdownlist prim_axis items:#("Front View", "Top View", "Side View") selection:2

	on prim_axis selected i do prim_axis_value = i
	on prim_axis doubleClicked i do gev_ok()

	button button_ok "Ok" width:160 align:#center toolTip:"Ok"
	button button_cancel "Cancel" width:160 align:#center toolTip:"Cancel"
	
	on button_ok pressed do gev_ok()
	on button_cancel pressed do destroydialog gev_rollout
)

-- Script

createDialog gev_rollout width:190 height:83
)
-------------------------------------------------------------------------------