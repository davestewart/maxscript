-------------------------------------------------------------------------------
-- WhoIncludesMe.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 08/01/01
-- Modified On: 08/01/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Makes a list of lights that have the picked object in their Include list.
-- Based on a script by Bobo called WhoLightsMe (http://www.scriptspot.com/bobo/)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
check_obj = pickobject()
lights_array = #()

for l in Lights where classof l != TargetObject do
(
	incl_list = l.includeList
	if incl_list != undefined then
	(
		if findItem incl_list check_obj != 0 then append lights_array l
	)
)
format "Object % is included on the following lights:\n" check_obj.name
for i in lights_array do format "%\n" i.name
)
-------------------------------------------------------------------------------