-------------------------------------------------------------------------------
-- BBoxMaker.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 08/01/01
-- Modified On: 08/01/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Creates bounding boxes for selected objects.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
undo "BBoxMaker" on
(
	for i in selection do
	(
		l = (i.max.y - i.min.y)
		w = (i.max.x - i.min.x)
		h = (i.max.z - i.min.z)
		c = i.center - [0, 0, (h/2)]		
		the_box = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:l width:w height:h pos:c
		the_box.name = i.name + "_box"
	)
)
)
-------------------------------------------------------------------------------