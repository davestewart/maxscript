rollout roGrabFrame "Grab Frame" width:160 height:208
(
	button btnGrab "Grab frame now" pos:[8,8] width:144 height:75
	button btnRender "Render" pos:[8,176] width:144 height:24 fieldwidth:144
	editText edt1 "" pos:[4,88] width:148 height:80
	
	
	on btnGrab pressed do
		(
		local frame = ((slidertime as integer / ticksperframe) as string)+ ", "
		edt1.text += frame
		rendPickupFrames += frame
		--renderSceneDialog.commit()
		renderSceneDialog.update()
		)
)

createDialog roGrabFrame


