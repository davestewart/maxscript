rollout matColor "Color Options" width:200 height:600
(
	GroupBox grpColVar "Color Varience" pos:[8,40] width:184 height:168

	colorPicker cpClr "Base Color" pos:[8,8] width:184 height:24 color:(color 64 128 255) title:"Choose a color"

	spinner spnClrRedVar "Red" pos:[32,65] width:56 height:16 range:[0,255,50] type:#integer
	colorPicker cpClrRedMin "" pos:[96,65] width:32 height:16 enabled:false color:(color 64 128 255)
	label lblClrRedMin "000" pos:[101,89] width:40 height:16
	colorPicker cpClrRedMax "" pos:[136,65] width:32 height:16 enabled:false color:(color 64 128 255)
	label lblClrRedMax "000" pos:[141,89] width:40 height:16


	spinner spnClrGrnVar "Green" pos:[32,113] width:56 height:16 range:[0,255,50] type:#integer
	colorPicker cpClrGrnMin "" pos:[96,113] width:32 height:16 enabled:false color:(color 64 128 255)
	label lblClrGrnMin "000" pos:[101,137] width:40 height:16
	colorPicker cpClrGrnMax "" pos:[136,113] width:32 height:16 enabled:false color:(color 64 128 255)
	label lblClrGrnMax "000" pos:[141,137] width:40 height:16

	spinner spnClrBluVar "Blue" pos:[32,161] width:56 height:16 range:[0,255,50] type:#integer
	colorPicker cpClrBluMin "" pos:[96,161] width:32 height:16 enabled:false color:(color 64 128 255)
	label lblClrBluMin "000" pos:[101,185] width:40 height:16
	colorPicker cpClrBluMax "" pos:[136,161] width:32 height:16 enabled:false color:(color 64 128 255)
	label lblClrBluMax "000" pos:[141,185] width:40 height:16

	GroupBox grpColGen "Color Generation" pos:[8,216] width:184 height:168
	radiobuttons rdoColGen "Colour generation" pos:[16,232] width:63 height:46 labels:#("Smooth graduation", "Random") columns:1
	button btn1 "Create material in Slot 1" pos:[8,272] width:184 height:16













---------------------------------------------------------------------------------------------------
-- functions
---------------------------------------------------------------------------------------------------

fn updateColor =
(
	-- set variables
		baseClr = cpClr.color
		rVar = spnClrRedVar.value
		gVar = spnClrGrnVar.value
		bVar = spnClrBluVar.value
	
	-- interpret red ranges	
		global rMin = (cpClr.color.r - (rVar/2)) as Integer
		global rMax = (cpClr.color.r + (rVar/2)) as Integer
			if rMin < 0 then rMin = 0
			if rMax > 255 then rMax = 255
		
		global gMin = (cpClr.color.g - (gVar/2)) as Integer
		global gMax = (cpClr.color.g + (gVar/2)) as Integer
			if gMin < 0 then gMin = 0
			if gMax > 255 then gMax = 255

		global bMin = (cpClr.color.b - (bVar/2)) as Integer
		global bMax = (cpClr.color.b + (bVar/2)) as Integer
			if bMin < 0 then bMin = 0
			if bMax > 255 then bMax = 255


	-- update interface display
	--red
		cpClrRedMin.color = color rMin 0 0
		lblClrRedMin.text = rMin as String
		cpClrRedMax.color = color rMax 0 0
		lblClrRedMax.text = rMax as String
	--green
		cpClrGrnMin.color = color 0 gMin 0
		lblClrGrnMin.text = gMin as String
		cpClrGrnMax.color = color 0 gMax 0
		lblClrGrnMax.text = gMax as String

	--blue
		cpClrBluMin.color = color 0 0 bMin
		lblClrBluMin.text = bMin as String
		cpClrBluMax.color = color 0 0 bMax
		lblClrBluMax.text = bMax as String
)


fn setColor i j =
(
	case rdoColGen.state of
	(
		1:
		(
			r = rMin + (((rMax - rMin) / j) * i)
			g = gMin + (((gMax - gMin) / j) * i)
			b = bMin + (((gMax - gMin) / j) * i)
		)
		2:
		(
			r = random rMin rMax
			g = random gMin gMax
			b = random bMin bMax
		)
	)
	return (color r g b)
)


fn createMaterial slot =
(
	subs = 10

	matTop = meditMaterials[slot] = Multimaterial ()
	matTop.numSubs = subs

	for i = 1 to subs do
	(
		matSub = meditMaterials[slot].materialList[i]
		matSub.diffuse = setColor i subs
	)
)



---------------------------------------------------------------------------------------------------
-- handlers
---------------------------------------------------------------------------------------------------

	on matColor open do
		updateColor ()
	on cpClr changed value do
		updateColor ()
	on spnClrRedVar changed value do
		updateColor ()
	on spnClrGrnVar changed value do
		updateColor ()
	on spnClrBluVar changed value do
		updateColor ()
	on btn1 pressed do
		createMaterial 1
)

---------------------------------------------------------------------------------------------------
-- create the rollout window and add the rollouts
---------------------------------------------------------------------------------------------------

if multiMat != undefined do
			(
				closerolloutfloater multiMat 
			)		
multiMat = newRolloutFloater "Random Multi Material" 230 400
addRollout matColor multiMat
