plugin shape Spherical_Spline2
name:"Spherical Spline2"
extends:line
classID:#(0x34dcd13e, 0x695e9531)
version:0.5
category:"Splines"
	( 
	tool create
		(
		local startPoint
		on mousePoint click do
			(
			case click of
				(
				1: startPoint = nodeTM.translation = gridPoint
				3: #stop
				)
			)
		on mouseMove click do
			(
			case click of
				(
				2:	(
					local w				= abs gridDist.x
					local h				= abs gridDist.y
					local r				= sqrt ((w * w) + (h * h))
					--delegate.radius		= r
					nodeTM.translation	= startpoint-- + gridDist/2.
					addNewSpline delegate
					)
				3: (
					--delegate.corner_radius = amax 0 -gridDist.x
					)
				)
			)
		)
	)

