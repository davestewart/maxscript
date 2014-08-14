-------------------------------------------------------------------------------
-- FigureModeControl.ms
-- By Brandon Davis (brandon@blur.com) and Neil Blevins (soulburn@blur.com)
-- v 1.20
-- Created On: 04/17/01
-- Modified On: 04/25/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Character Studio, http://www.discreet.com/
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description: 
-- When executed it stores all Bips in a floater where they can interactively be
-- placed in and out of figure mode. This is a time saver especially with large
-- scenes with lots of characters.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 When executed it stores all Bips in a floater where they can 
-- interactively be placed in and out of figure mode. This is a time saver 
-- especially with large scenes with lots of characters.
--
-- v 1.10 Did some code cleanup and now works with bipeds that include spaces 
-- in their names - Neil
--
-- v 1.11 Fixed a bug that would occur if you didn't choose a biped in the 
-- dropdown.
--
-- v 1.12 Fixed a bug where you couldn't affect the biped if you had layers in 
-- the biped.
--
-- v 1.20 Added a compact mode.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global fmc_advanced = true

global fmc_get_list_of_bips
global fmc_rebuild_dialogue

global fmc_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

fmc_bips = #()
fmc_bips_names = #()
fmc_selected_bip = 0
fmc_fig_state = false
fmc_fig_mode_tooltip = "Figure Mode"

fmc_xsize = 232
fmc_ysize = 25
fmc_xpos = 200
fmc_ypos = 200

-- Functions

fn fmc_get_list_of_bips =
	(
	for i in $* do
		(
		if classof i == Biped_Object then 
			(
			if i.controller.rootName == i.name then 
				(
				append fmc_bips i
				append fmc_bips_names (i.name as string)
				)
			)
		)
	if fmc_bips.count != 0 then 
		(
		fmc_selected_bip = 1
		fmc_fig_mode_tooltip = fmc_bips_names[1]
		)
	else
		(
		fmc_selected_bip = 0
		fmc_fig_mode_tooltip = "Figure Mode"
		)
	)
	
fn fmc_rebuild_dialogue = 
	(
	-- Dialog Pos
	
	fmc_xpos = (GetDialogPos fmc_rollout).x
	fmc_ypos = (GetDialogPos fmc_rollout).y
	if fmc_xpos == 0 or fmc_ypos == 0 then
		(	
		fmc_xpos = 200
		fmc_ypos = 200
		)
		
	-- Dialog Size
	
	if fmc_advanced == true then
		(
		fmc_xsize = 232
		fmc_ysize = 25
		)
	else
		(
		fmc_xsize = 53
		fmc_ysize = 25	
		)

	-- Destroy + Create Dialog

	destroyDialog fmc_rollout
	createDialog fmc_rollout width:fmc_xsize height:fmc_ysize pos:[fmc_xpos, fmc_ypos] modal:false
	)
	
-- Script

fmc_get_list_of_bips()

rollout fmc_rollout ""
	(
	checkbutton fig_mode "Fig" width:26 highlightcolor:red tooltip:fmc_fig_mode_tooltip pos:[5,5] across:4 checked:fmc_fig_state
	checkbutton advanced_button ">" width:16 highlightcolor:blue tooltip:"Advanced Toggle" pos:[35,5] checked:fmc_advanced
	dropdownlist select_bips "" items:fmc_bips_names width:120 pos:[55,5] selection:fmc_selected_bip
	button refresh_list "Refresh" width:48 tooltip:"Refresh Biped List" pos:[179,5]

	on fig_mode changed state do
		(
		fmc_fig_state = state
		if fmc_selected_bip != 0 then
			(
			i = fmc_bips[fmc_selected_bip]
			if isdeleted i == false then
				(
				if state == true then 
					(
					if i.transform.controller.figuremode != true then
						(
						biped.setCurrentLayer i.transform.controller 0
						i.transform.controller.figuremode = true
						)
					)
				else 
					(
					if i.transform.controller.figuremode != false then
						(
						biped.setCurrentLayer i.transform.controller 0
						i.transform.controller.figuremode = false
						w = (biped.numLayers i.transform.controller) - 1
						biped.setCurrentLayer i.transform.controller w
						)
					)
				)
			)
		)
		
	on advanced_button changed state do
		(
		fmc_advanced = state
		fmc_rebuild_dialogue()
		)
		
	on select_bips selected i do 
		(
		fmc_selected_bip = i
		fmc_fig_mode_tooltip = fmc_bips_names[i]
		fmc_rebuild_dialogue()
		)
	on refresh_list pressed do
		(
		fmc_bips = #()
		fmc_bips_names = #()
		fmc_selected_bip = 0
		fmc_fig_state = false
		fmc_get_list_of_bips()
		fmc_rebuild_dialogue()
		)
	)

fmc_rebuild_dialogue()
)
-------------------------------------------------------------------------------