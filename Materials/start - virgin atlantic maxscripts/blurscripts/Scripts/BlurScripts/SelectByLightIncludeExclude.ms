-------------------------------------------------------------------------------
-- SelectByLightIncludeExclude.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 08/10/01
-- Modified On: 08/10/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Select a light, and the script selects everything that is in the light's 
-- include or exclude list. It also prints whether these objects are included
-- or excluded in the listener.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
if selection.count == 1 then
(
	for l in selection do
	(
		if superclassof l == light then
		(
			if l.includeList != undefined then 
			(
				answer = "Include"
				select l.includeList
			)
			if l.excludeList != undefined then 
			(
				answer = "Exclude"
				select l.excludeList
			)
			print answer
		)		
	)
)
)
-------------------------------------------------------------------------------