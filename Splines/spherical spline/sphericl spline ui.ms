rollout roSphericalSpline "Spherical Spline" width:120 height:152
(



	spinner spnRadius "Radius" fieldwidth:40 height:16 range:[0,10000,150] align:#right offset:[4,4]
	spinner spnTurns "Turns" fieldwidth:30 height:16 range:[0,100,10] type:#integer align:#right offset:[4,0]
	spinner spnSegments "Segments" fieldwidth:40 height:16 range:[0,2000,500] type:#integer align:#right offset:[4,0]
	checkbox chkSpans "Vertical spans" pos:[8,80] width:96 height:16
	checkbox chkSurface "Surface" pos:[8,96] width:96 height:16
	button btnCreate "Create Sphere" pos:[8,120] width:104 height:24
)


createdialog roSphericalSpline