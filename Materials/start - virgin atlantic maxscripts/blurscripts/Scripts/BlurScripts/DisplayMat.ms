-------------------------------------------------------------------------------
-- DisplayMat.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 04/06/01
-- Modified On: 04/06/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Pick an object, run the script, this will show you the material assigned to
-- the object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Script

if selection.count == 1 then
(
	m1 = $.material
	if m1 == undefined then m2 = "No Material" else m2 = (m1.name as string)
	MessageBox m2 title:"DisplayMat"
)
)
-------------------------------------------------------------------------------