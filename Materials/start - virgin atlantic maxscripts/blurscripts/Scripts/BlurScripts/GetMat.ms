-------------------------------------------------------------------------------
-- GetMat.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.02
-- Created On: 02/22/01
-- Modified On: 08/03/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Quickly gets the material from the currently selected object and places
-- it into the selected material slot.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- Assign this script to, say, a keyboard shortcut. Select a medit slot you
-- want the material to be in, select the object you want the material from,
-- and hit the button.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Quickly gets the material from the currently selected object and places
-- it into the selected material slot.
--
-- v 1.01 Added some error handling so it returns an error message if you try
-- and get a material from an object that has no material (thanks grant!)
--
-- v 1.02 Simplified the script tremendously, now it just gets the material
-- of the first object in your selectionset, or no material if you have
-- nothing selected or if the selected object has no material.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
if selection.count != 0 then
(
	if selection[1].material != undefined then meditmaterials[medit.GetActiveMtlSlot()] = selection[1].material
)
)
-------------------------------------------------------------------------------