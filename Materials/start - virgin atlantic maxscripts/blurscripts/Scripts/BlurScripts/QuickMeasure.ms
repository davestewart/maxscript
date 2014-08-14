-------------------------------------------------------------------------------
-- QuickMeasure.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 05/27/01
-- Modified On: 06/29/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to quickly measure the distance between two mouse clicks.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- Start the script (like assigning it to a hotkey), click once where you want
-- to start measuring, move the cursor and click the mouse again where you want 
-- to end measuring, the distance appears in the maxscript listener.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to quickly measure the distance between two mouse clicks.
--
-- v 1.01 Displays distance in current system units, such as feet and inches
-- or world units. Now prints to a message box.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global qms_a = [0,0,0]
global qms_b = [0,0,0]

-- The Script

tool quickmeasure
(
on mousePoint clickno do 
(
	if clickno == 2 then qms_a = worldPoint
	else if clickno == 3 then
	(
		qms_b = worldPoint
		to_print = "Distance: "+ ((units.formatvalue (distance qms_a qms_b)) as string) + "      "
		MessageBox to_print title:"QuickMeasure"
		#stop
	)
)
)

startTool quickmeasure
)
-------------------------------------------------------------------------------