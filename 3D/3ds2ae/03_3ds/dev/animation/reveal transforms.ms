fn DumpXForms obj =
( -- output node transform properties
	format "%:\t%\n" "transform" obj.transform
	format "%:\t%\n" "position " obj.pos
	format "%:\t%\n" "rotation " obj.rotation
-- output node’s pivot point location
	format "%:\t%\n" "pivot " obj.pivot
-- output object offsets
	format "%:\t%\n" "objectoffsetpos " obj.objectoffsetpos
	format "%:\t%\n" "objectoffsetrot " obj.objectoffsetrot
	format "%:\t%\n" "objectoffsetscale" obj.objectoffsetscale
-- output object transform
	format "%:\t%\n" "objecttransform " obj.objecttransform
	try(
	-- output vertex position in local and world coordinates
		format "%:\t%\n" "vert 1 (local) " (in coordsys local getvert obj 1)
		format "%:\t%\n" "vert 1 (world1) " (in coordsys world getvert obj 1)
	-- calculate and output vertex position in world coordinates
		local v_pos=(in coordsys local getvert obj 1)* obj.objecttransform
		format "%:\t%\n" "vert 1 (world2) " v_pos
	)
	catch()
)

DumpXForms $
in coordsys local $.pivot



p1=$plane01
p2=$plane02
$.objecttransform :	(matrix3 [1,0,0] [0,1,0] [0,0,1] [4.55,37.5485,0])
p2.transform.translationPart


