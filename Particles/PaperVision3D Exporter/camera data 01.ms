clearlistener()
(
obj=$camera01
obj=$Dummy01

str	= stringstream ""

for i = 0 to 131 do
	(
	at time i
		(
		in coordsys #world
			(
			px	= obj.pos.x
			py	= obj.pos.y
			pz	= obj.pos.z
			
			rot	= obj.rotation as eulerangles

			rx	= rot.x as integer
			ry	= rot.y as integer
			rz	= rot.z as integer
			)
		format "[%, %, %, %, %, %]" px -pz py rx ry rz to:str
		if i < 131 do format ",\n" to:str
		--format "\n" to:str
		
		--str+="	"+i as string+"	"+px as string+"	"+(-pz) as string+"	"+py as string+"\n"

		)
	)


format "\n\nvar animation_array:Array = [\n%\n];" (str as string)


)