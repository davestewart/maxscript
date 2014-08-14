-------------------------------------------------------------------------------
-- WipeLayermanData.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 01/29/01
-- Modified On: 02/09/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Layerman, http://www.rezn8.com/gearhead/
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Destroys all layerman information for selected objects. Using the clear-LM data
-- in Layerman clears the global data, but objects still contain Layerman 
-- information in their Appdata. This script clears all of that info.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Destroys all layerman information for selected objects.
-- 
-- v 1.01 Added a yes/no dialogue so that people know the script is about to 
-- be run.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
if selection.count == 0 then
		(MessageBox "Please select at least one object." title:"WipeLayermanData")
	else
	(
		if (queryBox "Do you wish to wipe all Layerman data from your selected objects?" title:"WipeLayermanData") == true then 
		(
			for i in selection do
			(
				deleteappdata i 9901
				deleteappdata i 9902
			)
		)
	)
)
-------------------------------------------------------------------------------