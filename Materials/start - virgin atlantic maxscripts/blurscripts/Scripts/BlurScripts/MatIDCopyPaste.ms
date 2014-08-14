-------------------------------------------------------------------------------
-- MatIDCopyPaste.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 01/06/02
-- Modified On: 01/06/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Description:
-- Copies and pastes MatIDs from one object to another. Both objects must have
-- the same face count. Suggested by Campbell McGrouther.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- Object must be an Editable Mesh of Editable Poly.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global midcp_copy_mesh
global midcp_paste_mesh
global midcp_copy_poly
global midcp_paste_poly
global midcp_do

global midcp_rollout
global midcp_floater

global midcp_info = #()

-- Variables

-- Functions

fn midcp_copy_mesh obj = 
(
	midcp_info = #()
	for i = 1 to (getNumFaces obj) do 
	(
		append midcp_info (getFaceMatID obj i)
	)	
)
	
fn midcp_paste_mesh obj = 
(
	if (getNumFaces obj) != midcp_info.count then (MessageBox "Currently selected object does not have same number of faces as info you want to paste." title:"MatIDCopyPaste")
	else
	(
		disableSceneRedraw()
		try
		(
			for i = 1 to (getNumFaces obj) do 
			(
				setFaceMatID obj i midcp_info[i]
			)
		)
		catch ()
		enableSceneRedraw()
		completeRedraw()
	)
)
	
fn midcp_copy_poly obj = 
(
	midcp_info = #()
	for i = 1 to (getNumFaces obj) do 
	(
		append midcp_info (polyop.getFaceMatID obj i)
	)	
)
	
fn midcp_paste_poly obj = 
(
	if (getNumFaces obj) != midcp_info.count then (MessageBox "Currently selected object does not have same number of faces as info you want to paste." title:"MatIDCopyPaste")
	else
	(
		disableSceneRedraw()
		try
		(
			for i = 1 to (getNumFaces obj) do 
			(
				polyop.setFaceMatID obj i midcp_info[i]
			)
		)
		catch ()
		enableSceneRedraw()
		completeRedraw()
	)
)
	
fn midcp_do the_func = 
(
	if selection.count != 1 then (MessageBox "Please select only a single object." title:"MatIDCopyPaste")
	else
	(
		obj = selection[1]
		if classof obj == Editable_mesh then 
		(
			if the_func == 1 then midcp_copy_mesh obj
			else midcp_paste_mesh obj
		)
		else if classof obj == Editable_Poly then 
		(
			if the_func == 1 then midcp_copy_poly obj
			else midcp_paste_poly obj
		)
		else MessageBox "Please choose an Editable Mesh Or Editable Poly object." title:"MatIDCopyPaste"
	)
)
	
-- The Script

rollout midcp_rollout "MatIDCopyPaste"
(
	button midcp_copy_button "Copy" width:180 align:#center toolTip:"Copy" enabled:true
	button midcp_paste_button "Paste" width:180 align:#center toolTip:"Paste" enabled:true
	
	on midcp_copy_button pressed do midcp_do 1
	on midcp_paste_button pressed do midcp_do 2
)

if midcp_floater != undefined then CloseRolloutFloater midcp_floater
midcp_floater = newRolloutFloater "MatIDCopyPaste v1.00" 220 123
addRollout midcp_rollout midcp_floater
)
-------------------------------------------------------------------------------