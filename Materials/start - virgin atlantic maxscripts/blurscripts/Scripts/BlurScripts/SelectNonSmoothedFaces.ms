-------------------------------------------------------------------------------
-- SelectNonSmoothedFaces.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 06/19/02
-- Modified On: 06/19/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes an object, and selects all faces in the object that contain no
-- smothing group.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- The Script

if selection.count == 1 then
	(
	if $.faces.count != 0 then
		(
		disableSceneRedraw()

		the_faces = #{}
		subobjectLevel = 0
		if classof $ == Editable_mesh then
			(
			for i = 1 to $.faces.count do
				(
				gr = getFaceSmoothGroup $ i
				if gr == 0 then append the_faces i
				)
			subobjectLevel = 4
			setFaceSelection $ the_faces
			)
		if classof $ == Editable_Poly then
			(
			for i = 1 to $.faces.count do
				(
				gr = polyop.getFaceSmoothGroup $ i
				if gr == 0 then append the_faces i
				)
			subobjectLevel = 4
			polyop.setFaceSelection $ the_faces
			)

		enableSceneRedraw()
		completeRedraw()
		)
	)
)
-------------------------------------------------------------------------------