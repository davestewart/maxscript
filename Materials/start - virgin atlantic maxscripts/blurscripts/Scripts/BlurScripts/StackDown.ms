-------------------------------------------------------------------------------
-- StackDown.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 02/19/01
-- Modified On: 02/19/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes you one modifier lower then your currently selected modifier.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Script

if selection.count == 1 then 
(
	current_mod_index = current_modifier_index $
	if current_mod_index != 0 then
	(
		if current_mod_index == $.modifiers.count then
		(
			modPanel.setCurrentObject $
		)
		else 
		(
			current_mod_index = current_mod_index + 1
			modPanel.setCurrentObject $.modifiers[current_mod_index]
		)
	)
)
)
-------------------------------------------------------------------------------