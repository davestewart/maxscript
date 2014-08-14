-------------------------------------------------------------------------------
-- AttachSelection.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 09/12/01
-- Modified On: 09/30/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes a selection of objects and attaches them into one object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes a selection of objects and attaches them into one object.
--
-- v 1.01 Added a progressbar, and turns off screen redraw.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
if selection.count >= 2 then
(
	disableSceneRedraw()
	try
	(
		objs = for i in selection collect i
		main_obj = objs[1]
		convertTo main_obj TriMeshGeometry
		
		progressStart "Make Unique"
		escapeEnable = false
		itemnum = objs.count
		curiter = 0
		
		for i = 2 to itemnum do
		(
			curiter += 1
			m = ((curiter as float)/(itemnum as float))*100
			attach main_obj objs[i]
			progressUpdate m
		)
		progressEnd()
	)
	catch
	(
		MessageBox "An error has occured, you may want to undo." title:"AttachSelection"
	)
		
	enableSceneRedraw()
	completeRedraw()
)
)
-------------------------------------------------------------------------------