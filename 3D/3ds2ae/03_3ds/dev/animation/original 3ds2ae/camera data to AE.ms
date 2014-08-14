obj=$camera01
obj=$Dummy01

str=""
for i = 0 to 50 do
(
	at time i
	(
		in coordsys #world
		(
			px=obj.pos.x
			py=obj.pos.y
			pz=obj.pos.z
			
			rot=obj.rotation as eulerangles

			rx=rot.x
			ry=rot.y
			rz=rot.z
		)
		--format "	%	%	%	%\n" i px -pz py) to str
		--format "%	%	%	%\n" i rx ry rz
		
		str+="	"+i as string+"	"+px as string+"	"+(-pz) as string+"	"+py as string+"\n"

	)
)


format "\n\n
Adobe After Effects 6.0 Keyframe Data				
				
	Units Per Second	29.97		
	Source Width	640		
	Source Height	480		
	Source Pixel Aspect Ratio	1		
	Comp Pixel Aspect Ratio	1		
				
Position				
	Frame	X pixels	Y pixels	Z pixels
%
End of Keyframe Data\n\n" str


