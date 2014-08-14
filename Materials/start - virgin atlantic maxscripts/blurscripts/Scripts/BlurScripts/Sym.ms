-------------------------------------------------------------------------------
-- Sym.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.30
-- Created On: 09/02/99
-- Modified On: 11/03/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes any selected objects and instances and mirrors them across the x axis
-- in one button press. A very simple script, I wrote it primarily for people 
-- like me who are modeling cars, buildings, helicopters, whatever, and want 
-- to build everything on one side and then make frequent previews of what 
-- the model will look like with both sides (and who don't want to click on 
-- many buttons).
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes any selected objects and instances and mirrors them across the x 
-- axis. A very simple script, I wrote it primarily for people like me who are 
-- modeling cars, buildings, helicopters, whatever, and want to build 
-- everything on one side and then make frequent previews of what the model 
-- will look like with both sides (and who don't want to click on many
-- buttons).
--
-- v 1.10 adds the ability to delete using a button your mirrored objects
-- once you finish your render and / or visualization preview.
--
-- v 1.11 Added an error box if you haven't selected an object, an error box
-- if you delete your object using delete and then press the Delete Mirrored 
-- Instance button and optimized the code a bit.
--
-- v 1.20 Removes the ability to delete the geometry made by the script. Why
-- am I removing functionality? Because I've been using the script for a year
-- now and don't use it the delete button, and it gets in the way since it's 
-- creating an unwanted window and an unwanted selection set. I commented out 
-- the code so if someone wants to reenable it, they can.
--
-- v 1.30 Removed the excess code. Now compatible with R4.0.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
undo "Sym" on
	(
	If selection.count == 0 then (MessageBox "Please select at least 1 object" title:"Sym")
	else
		(
		instance $
		about [0,0,0] scale $ [-1,1,1]
		)
	)
)
-------------------------------------------------------------------------------