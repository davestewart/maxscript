-------------------------------------------------------------------------------
-- MissingUVWSelect.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 07/06/01
-- Modified On: 07/06/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes your selected objects and selects any objects among them that do not
-- have a UVW mapping modifier present. Useful for finding objects that may 
-- require mapping coordinates in order to render. Will only select geometry, 
-- not lights or helper, etc. Written for Flappy.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Variables

sel = #()
uvw = #()
no_uvw = #()

-- The Script

disableSceneRedraw()

for i in selection do
	(
	if superclassof i == GeometryClass then append sel i
	)

for i in sel do
	(
	if i.modifiers.count == 0 then continue
	else
		(
		for j = 1 to i.modifiers.count do
			(
			if i.modifiers[j].name == "UVW Mapping" then 
				(
				append uvw i 
				)
			else continue
			)
		)
	)

no_uvw = remove_from_array_by_items sel uvw
select no_uvw

enableSceneRedraw()
completeRedraw()
)
-------------------------------------------------------------------------------