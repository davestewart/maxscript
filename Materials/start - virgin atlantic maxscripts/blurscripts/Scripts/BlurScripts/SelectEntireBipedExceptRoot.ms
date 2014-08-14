-------------------------------------------------------------------------------
-- SelectEntireBipedExceptRoot.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 05/06/02
-- Modified On: 05/06/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Character Studio, http://www.discreet.com/
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- If you select any piece of a biped and then run this script, it will select
-- the entire biped except for the root.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global seber_get_kids

-- Variables

seb_biped_array = #()

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Functions

fn seber_get_kids i the_array = 
	(
	if classof i == Biped_object then append the_array i
	if i.children.count != 0 then
		(
		for w = 1 to i.children.count do
			(
			seber_get_kids i.children[w] the_array
			)
		)
	)

-- The Script

if selection.count == 1 and classof selection[1] == biped_object then
	(
	seb_biped_array = #()
	
	-- Get root
	the_root = get_biped_root selection[1]
	
	-- Populate Array
	seb_get_kids the_root seb_biped_array
	
	-- Remove Root
	for i = 1 to seb_biped_array.count do
		(
		if seb_biped_array[i] == the_root then deleteItem seb_biped_array i
		)
	
	-- Select Biped
	disableSceneRedraw()
	select seb_biped_array
	enableSceneRedraw()
	completeRedraw()
	)
)
-------------------------------------------------------------------------------