fn rebuild obj=
(
	for i = 1 to (getNumFaces obj) do
	(
		f=getface obj i
		n=getfacenormal obj i
		in coordsys #world
		(
			r=(matrixfromnormal n).rotationpart
			p=meshop.getFaceCenter obj i
			p=[0,0,0]
			plane pos:p rotation:r width:5 length:5 name:("plane" + i as string)
		)
	)
)

rebuild $