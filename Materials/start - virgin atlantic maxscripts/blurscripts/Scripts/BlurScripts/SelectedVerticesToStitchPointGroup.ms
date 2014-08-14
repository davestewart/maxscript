-------------------------------------------------------------------------------
-- SelectedVerticesToStitchPointGroup.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 04/26/01
-- Modified On: 04/26/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-- Stitch, http://www.digimation.com
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Copies selections from the editable mesh or editable poly level and makes 
-- stitch Point groups from them.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- Make an editable mesh, apply a stitch modifier. Go down to the Editable Mesh 
-- level and select some vertexes. Hit Copy. Then go to the stitch level, hit
-- paste, your selection is now a point group.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global svtspg_copy
global svtspg_paste

global svtspg_rollout
global svtspg_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

svtspg_vert = #{}

-- Functions

fn svtspg_copy = 
(
	if selection.count == 1 then
	(
		for i in selection do
		(
			if classof (modPanel.getCurrentObject ()) == Editable_mesh or classof (modPanel.getCurrentObject ()) == Editable_Poly then
			(
				svtspg_vert = getvertselection i
			)
			
		)
	)
)

fn svtspg_paste = 
(
	if selection.count == 1 then
	(
		for i in selection do
		(
			if svtspg_vert.count != 0 then
			(
				if classof (modPanel.getCurrentObject ()) == Stitch then
				(
					cm = current_modifier_index i
					stitchOps.selectVertices i.modifiers[cm] svtspg_vert i
					stitchOps.makePointGroup i.modifiers[cm] svtspg_vert i "temp01"
				)
			)
		)
	)
)

rollout svtspg_rollout "SelectedVerticesToStitchPointGroup"
(
	button svtspg_copy_button "Copy" width:200 align:#center toolTip:"Copy"
	button svtspg_paste_button "Paste" width:200 align:#center toolTip:"Paste"
	
	on svtspg_copy_button pressed do svtspg_copy()
	on svtspg_paste_button pressed do svtspg_paste()
)

if svtspg_floater != undefined then CloseRolloutFloater svtspg_floater
svtspg_floater = newRolloutFloater "SelectedVerticesToStitchPointGroup v1.00" 250 121
addRollout svtspg_rollout svtspg_floater
)
-------------------------------------------------------------------------------