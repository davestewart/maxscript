rollout roScatter "Scatter utility" width:248 height:48
(
	-- variables
		local src, obj, objArr=#()

	-- functions
		fn alignObj theSrc theFace obj=
			(
			faceNormal = in coordsys theSrc (getFaceNormal theSrc theFace) 
			worldUpVector = [0,0,1] 
			rightVector = normalize (cross worldUpVector faceNormal) 
			upVector = normalize ( cross rightVector faceNormal )
			theMatrix = matrix3 rightVector upVector faceNormal [0,0,0] 
		
			obj.transform = theMatrix
			obj.position =meshop.getFaceCenter theSrc theFace
			)

	-- interface
		pickButton btnSrc "Source object" pos:[8,8] width:192 height:16
		pickButton btnObj "Scatter object" pos:[8,24] width:192 height:16
		button btnGo "Go" pos:[208,8] width:32 height:32

	-- handlers

		on btnSrc picked p do
			(
			src=p
			btnSrc.text=p.name
			)

		on btnObj picked p do
			(
			obj=p
			btnObj.text=p.name
			)

		on btnGo pressed do
			(
			if classof src != Editable_mesh then addModifier src (Turn_to_Mesh())
			for i = 1 to (getNumFaces src) do
				(
				local newObj=instance obj
				append objArr newObj
				alignObj src i newObj
				)
			for obj in objArr do obj.wirecolor=color (random 0 255) (random 0 255) (random 0 255)
			select objArr
			)
	)
createdialog roScatter