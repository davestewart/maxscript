--------------------------------------------------------------------------------
--    MaterialID to faces by polygon
--    version 1.0
--    max version 7
--    written by Joshua Newman
--    josh@here.net.au
--    www.joshuanewman.net
--    last updated 12/11/04
--    copyright 2004
--------------------------------------------------------------------------------
--
-- assigns materialID to faces by polygon
--
--------------------------------------------------------------------------------


fn materialbypolygon obj theshold=
(
	local polys=#(),done=#()
	
	for i=1 to obj.faces.count do
	(
		if (finditem done i)==0 then
		(
			faces=(meshop.getpolysusingface $ #(i) threshold:threshold) as array
			append polys faces
			for f in faces do append done f
		)
	)
	for i=1 to polys.count do 
	(
		for f in polys[i] do (setfacematid obj f i)
	)
)

materialbypolygon selection[1] 100
