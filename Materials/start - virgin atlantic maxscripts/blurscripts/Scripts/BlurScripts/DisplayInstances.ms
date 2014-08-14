-------------------------------------------------------------------------------
-- DisplayInstances.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 05/14/01
-- Modified On: 05/14/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Displays a list of all other objects in your scene that are an instance
-- of your currently selected object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Script

if selection.count == 1 then
	(
	to_print = ""
	iarray = get_instances $
	qsort iarray name_compare_case_insensitive
	for i in iarray do
		(
		to_print += i.name as string
		to_print += "\n"
		)
	to_print_title = "Instances of " + $.name
	MessageBox to_print title:to_print_title
	)
else MessageBox "Please Select Only One Object" title:"DisplayInstances"
)
-------------------------------------------------------------------------------