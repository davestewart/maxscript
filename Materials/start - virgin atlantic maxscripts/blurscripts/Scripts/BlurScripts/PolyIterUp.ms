-------------------------------------------------------------------------------
-- PolyIterUp.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.03
-- Created On: 02/19/01
-- Modified On: 06/20/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes a Polyobject and increases its iterations up one level.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes a Polyobject and increases its iterations up one level.
--
-- v 1.01 Grant Adam brought to my attention that if an object doesn't have any 
-- modifiers, all that code to change stack levels does nothing but slow down 
-- the process by doing unnecessary screen redraws. So now the code branches,
-- doing one thing if modifiers are present, and another much faster thing if no
-- modifiers are presents.
--
-- v 1.02 I'm now turning screen redraw off and back on again to speed up
-- performance with meshes that have modifiers.
--
-- v 1.03 Now it can work on multiple objects, thanks to a fix in max4.2. Removed
-- modifier code since another 4.2 fix fixes that issue.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Script

for i in selection do
(
	if classof i.baseobject == Editable_Poly then 
	(
		disableSceneRedraw()
		try
		(
			if i.surfSubdivide == off then i.surfSubdivide = on
			i.iterations += 1
		)
		catch ()
		enableSceneRedraw()
		completeRedraw()
	)
)
)
-------------------------------------------------------------------------------