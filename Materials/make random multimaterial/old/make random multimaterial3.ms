
rollout components "Components" width:210 height:432
(
	checkbox chkCol "Color" pos:[8,8] width:192 height:16 checked:true
	checkbox chkSpec "Specular Highlights" pos:[8,24] width:192 height:16
	checkbox chkOpac "Opacity" pos:[8,40] width:192 height:16 checked:true
	checkbox chkBump "Bump" pos:[8,56] width:192 height:16 checked:false
	checkbox chkIllum "Self Illumination" pos:[8,72] width:192 height:16 checked:false

	checkbox chkOther "Other Parameters" pos:[8,88] width:192 height:16
	label lblCompNote "Note:
Clearing a checkbox will delete any existing values!" pos:[8,104] width:192 height:40
	
-- declare local rollouts
	local matColor, matSpec, matOpac, matOther, matGen


	
	on chkCol changed state do
(
	case chkCol.checked of
	(
		true: addRollout matColor multiMat
		false: removeRollout matColor multiMat
	)
)
	on chkSpec changed state do
(
	case chkSpec.checked of
	(
		true: addRollout matSpec multiMat
		false: removeRollout matSpec multiMat
	)
)
	on chkOpac changed state do
(
	case chkOpac.checked of
	(
		true: (print "Adding opacity options");	-- addRollout matOpac multiMat)
		false: ( print "Removing opacity options");	-- removeRollout matOpac multiMat)
	)
)
	on chkOther changed state do
(
	case chkOther.checked of
	(
		true: addRollout matOther multiMat
		false: removeRollout matOther multiMat
	)
)
)


rollout matColor "Color Options" width:210 height:600
(
	GroupBox grpCol "Base Colour" pos:[8,8] width:184 height:48
	colorPicker cpClr "" pos:[16,24] width:168 height:24 color:(color 237 178 50) title:"Choose a color"

	GroupBox grpColVar "Color Varience" pos:[8,64] width:184 height:168

	spinner spnClrRedVar "Red " pos:[39,89] width:56 height:16 range:[0,255,200] type:#integer
		colorPicker cpClrRedMin "" pos:[103,89] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrRedMin "000" pos:[108,108] width:20 height:16
	
		colorPicker cpClrRedBas "" pos:[132,89] width:24 height:16 enabled:false color:(color 64 128 255)
	
		colorPicker cpClrRedMax "" pos:[161,89] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrRedMax "000" pos:[166,108] width:20 height:16
	
	
	
	spinner spnClrGrnVar "Green " pos:[30,137] width:65 height:16 range:[0,255,100] type:#integer
		colorPicker cpClrGrnMin "" pos:[103,137] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrGrnMin "000" pos:[108,156] width:20 height:16
	
		colorPicker cpClrGrnBas "" pos:[132,137] width:24 height:16 enabled:false color:(color 64 128 255)
	
		colorPicker cpClrGrnMax "" pos:[161,137] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrGrnMax "000" pos:[166,156] width:20 height:16
	
	
	spinner spnClrBluVar "Blue " pos:[36,184] width:59 height:16 range:[0,255,50] type:#integer
		colorPicker cpClrBluMin "" pos:[103,185] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrBluMin "000" pos:[108,204] width:20 height:16
	
		colorPicker cpClrBluBas "" pos:[132,185] width:24 height:16 enabled:false color:(color 64 128 255)

		colorPicker cpClrBluMax "" pos:[161,185] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrBluMax "000" pos:[166,204] width:20 height:16
	
	GroupBox grpColGen "Colour Generation" pos:[8,240] width:184 height:50
	radiobuttons rdoColGen "" pos:[16,260] width:149 height:16 labels:#("Random", "Smooth") columns:2

	groupBox grpPrv "Preview" pos:[8,296] width:184 height:48
		colorPicker cpPrv1 pos:[16,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv2 pos:[32,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv3 pos:[48,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv4 pos:[64,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv5 pos:[80,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv6 pos:[96,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv7 pos:[112,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv8 pos:[128,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv9 pos:[144,316] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv10 pos:[160,316] width:20 height:16 enabled:false color:(color 255 255 255)

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
			cpClrRedBas.color = color cpClr.color.r 0 0
			cpClrRedMax.color = color rMax 0 0
			lblClrRedMax.text = rMax as String
			
			
		--green
			cpClrGrnMin.color = color 0 gMin 0
			lblClrGrnMin.text = gMin as String
			cpClrGrnBas.color = color 0 cpClr.color.g 0
			cpClrGrnMax.color = color 0 gMax 0
			lblClrGrnMax.text = gMax as String
	
		--blue
			cpClrBluMin.color = color 0 0 bMin
			lblClrBluMin.text = bMin as String
			cpClrBluBas.color = color 0 0 cpClr.color.b
			cpClrBluMax.color = color 0 0 bMax
			lblClrBluMax.text = bMax as String

		-- update preview
			for i = 1 to 10 do
			(
				swatch = execute("matColor.cpPrv" + i as String)
				swatch.color = matGen.setColor i 10
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
	on rdoColGen changed state do
		updateColor ()
)




rollout matGen "Material Generation" width:210 height:544
(
	GroupBox grpMain "Material Properties" pos:[8,8] width:184 height:64
		edittext matName "Name" pos:[18,24] width:166 height:16 text:"Autumn"
		spinner amtSubs "Sub Materials" pos:[114,48] width:70 height:16 range:[2,100,10] type:#integer

	GroupBox create "Create" pos:[8,80] width:184 height:40
		button btnCreate "Place in Material Editor slot:" pos:[16,96] width:136 height:16
		spinner spnSlot "" pos:[150,96] width:34 height:16 range:[1,24,1] type:#integer


	---------------------------------------------------------------------------------------------------
	-- functions
	---------------------------------------------------------------------------------------------------
	
	fn setColor i j =
	(
		case matColor.rdoColGen.state of
		(
			1:
			(
				r = random rMin rMax
				g = random gMin gMax
				b = random bMin bMax
			)

			2:
			(
				r = rMin + (((rMax - rMin) / j) * i)
					if r > 255 then r = 255
					if r < 0 then r = 0
				g = gMin + (((gMax - gMin) / j) * i)
					if g > 255 then g = 255
					if g < 0 then g = 0
				b = bMin + (((gMax - gMin) / j) * i)
					if b > 255 then b = 255
					if b < 0 then b = 0
			)
		)
		-- print ("r:" + r as String + " g:" + g as String + " b: " + b as String)
		return (color r g b)
	)

	fn setOpac matSub i j =
	(
		case matOpac.rdoOpacCtrl.state of
		(
			1: -- copy
			(
				matSub.opacity = random opacMin opacMax
			)

			2: -- instance
			(
				matSub.opacity.controller = opacCtrl
				opacCtrl.value = matOpac.spnOpacVal.value
			)
		)
		if matOpac.chkOpac2Sided.checked then matSub.twoSided = true
	)

	fn setOpacMap matSub =
	(
		if matOpac.btnOpacMap.map != undefined then
		(
			case matOpac.rdoOpacMapCtrl.state of
			(
				1:
				(
					matSub.opacityMap = copy matOpac.btnOpacMap.map
					matSub.opacityMap.name = matSub.opacityMap.name + " copy"
				)
				2:
				(
					matSub.opacityMap = matOpac.btnOpacMap.map
				)
			)
			if matOpac.chkOpacAffectMap.checked then matSub.opacityMapAmount = random opacMin opacMax
		)
	)



	fn createMaterial slot =
	(
		max mtledit
		global subs = amtSubs.value
	
		matTop = meditMaterials[slot] = Multimaterial ()
		matTop.name = matName.text -- " (Top Material)"
		matTop.numSubs = subs
	
		for i = 1 to subs do
		(
			matSub = meditMaterials[slot].materialList[i]
			matSub.name = matName.text + " sub" + i as String

			-- color
				if components.chkCol.checked then matSub.Diffuse = setColor i subs
			-- opacity
				if components.chkOpac.checked then
				(
					setOpac matSub i subs
					setOpacMap matSub
				)
		)
		activeMeditSlot = slot

		-- set Material editor preferences as a <bitarray>
		-- 1: MTL_BEING_EDITED, 2: BACKGROUND, 3: BACKLIGHT, 4: VIDEO_COLOR_CHECK
			setMTLMEditFlags meditMaterials[slot] #{2,3}

	)


	---------------------------------------------------------------------------------------------------
	-- handlers
	---------------------------------------------------------------------------------------------------

	on btnCreate pressed do ( createMaterial spnSlot.value  )
)


rollout matOpac "Opacity" width:210 height:432
(
	GroupBox grpOpacCtrl "Controllers (across range)" pos:[8,8] width:184 height:40
		radiobuttons rdoOpacCtrl "" pos:[16,24] width:134 height:16 labels:#("Copies", "Instances") columns:2

	GroupBox grpOpacParam "Opacity: ()" pos:[8,56] width:184 height:80
		spinner spnOpacVal "Opacity" pos:[44,80] width:60 height:16 range:[0,100,100] type:#integer
		spinner spnOpacVar "Varience" pos:[44,104] width:60 height:16 range:[0,100,10] type:#integer
		checkbox chkOpac2Sided "2 Sided" pos:[116,80] width:70 height:16 checked:true
		checkbox chkOpacAffectMap "Affect Map" pos:[116,104] width:70 height:16 checked:false enabled: false


	
	GroupBox grpOpacMapGroup "Maps (across range)" pos:[8,144] width:184 height:64
		mapButton btnOpacMap "None" pos:[16,160] width:166 height:16
		radioButtons rdoOpacMapCtrl "" pos:[16,184] width:134 height:16 labels:#("Copies", "Instances") columns:2


	---------------------------------------------------------------------------------------------------
	-- functions
	---------------------------------------------------------------------------------------------------

	fn updateOpac =
	(

		-- set variables
			opacBas = spnOpacVal.value
			opacVar = spnOpacVar.value
		
		-- interpret opacity ranges	
			global opacMin = (opacBas - (opacVar/2)) as Integer
			global opacMax = (opacBas + (opacVar/2)) as Integer
				if opacMin < 0 then opacMin = 0
				if opacMax > 100 then opacMax = 100

		-- update interface display
			grpOpacParam.text = "Opacity: (" + opacMin as String + " - " + opacMax as String + ")"

		-- set instanced controller, if needed
			opacCtrl = bezier_float ()
			opacCtrl.value = opacBas
			print opacCtrl
				
	)


	fn updateOpacDisplay =
	(
		case rdoOpacCtrl.state of
		(
			1:
			(
				-- copy
				spnOpacVar.value = 10
				spnOpacVar.enabled = true
				rdoOpacMapCtrl.enabled = true
				updateOpac()
			)
			2:
			(
				-- instance
				spnOpacVar.value = 0
				spnOpacVar.enabled = false
				rdoOpacMapCtrl.enabled = false
				rdoOpacMapCtrl.state = 2
				updateOpac()
			)
		)
	)


	fn setOpacMapBtnDisplay =
	(
		if btnOpacMap.map != undefined then
		(
			name =  btnOpacMap.map.name as string
			type = classof btnOpacMap.map as String
			btnOpacMap.text= name + " (" + type + ")"
			chkOpacAffectMap.enabled = true
		)
		else
		(
			btnOpacMap.text= "None"
			chkOpacAffectMap.enabled = false
		)
	)

	fn updateOpacMapCtrl =
	(
		case rdoOpacMapCtrl.state of
		(
			1:
			(
				print "Copy only"
			)
			2:
			(
				opacMapInst = btnOpacMap.map
				print "instance"
				print opacMapInst 
			)
		)
	)

	---------------------------------------------------------------------------------------------------
	-- handlers
	---------------------------------------------------------------------------------------------------
	on matOpac open do updateOpac()
	on rdoOpacCtrl changed state do updateOpacDisplay()
	on spnOpacVal changed value do updateOpac()
	on spnOpacVar changed value do updateOpac()
	on btnOpacMap picked texmap do setOpacMapBtnDisplay()
	on rdoOpacMapCtrl changed state do updateOpacMapCtrl()
)


---------------------------------------------------------------------------------------------------
-- create the rollout window and add the rollouts
---------------------------------------------------------------------------------------------------

if multiMat != undefined do
(
	closerolloutfloater multiMat 
)		
multiMat = newRolloutFloater "Random Multi Material" 230 800
addRollout matGen multiMat
addRollout components multiMat rolledup:true
addRollout matColor multiMat
addRollout matOpac multiMat

