rollout ro1 "Camera renderer" width:231 height:259
	(
	local c
	fn camFilter c = classOf c == Targetcamera

	pickButton pck1 "Viewport" pos:[8,8] width:96 height:16 filter:camFilter tooltip:"Pick Camera from scene..."
	button btnRC "x" pos:[104,8] width:16 height:16 tooltip:"Revert to viewport"

	button btnRnd "Render" pos:[8,88] width:96 height:16
	
	on pck1 picked obj do
		(
		pck1.text = obj.name
		c=obj
		)

	on btnRC pressed do
		(
		pck1.text = "Viewport"
		c=undefined
		)


	on btnRnd pressed do
		(
		-- start the string
			str = "render "
		-- get the camera (if any)
			if isValidNode c then str+= "camera: c "
			try(if isDeleted c then MessageBox ("Camera has been deleted!\nRendering from current viewport"))
			catch()
			format "c: %\n%\n" c str
		)
	)
if nRF != undefined then closerolloutfloater nRF 
	nRF = newRolloutFloater "Cam chooser" 350 300 10 10 
	addRollout ro1 nRF 

