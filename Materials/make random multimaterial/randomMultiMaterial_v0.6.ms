-- make random multimaterial - 5s-v0_10.ms
-- Modified by swami* <swami@cfl.rr.com> on 13Aug2001
-- Search "s*" for mods.
-- ds,
-- Fixed!  Well, at least a quick fix, and a quick test (more is required!).
-- I highly recommend you see the MXSHelp for "scope."
-- I also recommend you check out "Learning MAXScript" in the FAQ's conference at
-- http://support.discreet.com/webboard/wbpx.dll/read?45104,40
--
-- Good luck, and CODE ON!...	
--
-- s* [Forum Assistant]

------------------------------------
-- multiMaterial Maker v0.2
------------------------------------

-- Created:  		11th August 2001
-- Last Updated:	13th August 2001
--
-- Author :			Dave Stewart
-- Homepage:		www.davestewart.co.uk
-- Version:  		3ds max 4
--
-- Description:		A utility to quickly create a good starting point for a multiMaterial
--					Just to add a bit of subtlety to scenes, you know ?
-- Uses: 			Grass, space panels, stones, bubbles, tiles

------------------------------------
-- Items not implimented yet:
------------------------------------
-- 
-- Specular Level map
-- Glossines controls
-- shader type
--
------------------------------------
-- Problems
------------------------------------
-- I can't seem to get the rollouts reading from eachother!
-- Will setting this script to run as a macroScript solve this?
-- Once the script has failed once, everything seems to run fine, but it is a real pain in the ass...
--

--s*: Declare as global since matColor roll calls it before it is declared otherwise!
global matGen, matColor, matHigh, matOpac, matOther
global colorLightGreen = [156, 255, 128] as color 


rollout components "Components" width:210 height:432
(
	---------------------------------------------------------------------------------------------------
	-- Interface COMPONENTS
	---------------------------------------------------------------------------------------------------
	checkbox chkCol "Color" pos:[8,8] width:192 height:16 					checked:true
	checkbox chkHigh "Specular Highlights" pos:[8,24] width:192 height:16	checked:false
	checkbox chkOpac "Opacity" pos:[8,40] width:192 height:16 				checked:false
	checkbox chkBump "Bump" pos:[8,56] width:192 height:16 					checked:false	enabled:false
	checkbox chkIllum "Self Illumination" pos:[8,72] width:192 height:16 	checked:false	enabled:false
	checkbox chkOther "Other Parameters" pos:[8,88] width:192 height:16		checked:false	enabled:false
	

	---------------------------------------------------------------------------------------------------
	-- Handlers & functions
	---------------------------------------------------------------------------------------------------

	on chkCol changed state do
	(
		if chkCol.checked then matColor.open = true
		else matColor.open = false
	)

	on chkHigh changed state do
	(
		if chkHigh.checked then matHigh.open = true
		else matHigh.open = false
	)
	on chkOpac changed state do
	(
		if chkOpac.checked then	(	matOpac.open = true; matOpac.chkOpacStatus.checked=false)
		else (	matOpac.open = false; matOpac.chkOpacStatus.checked=true)
	)
	on chkOther changed state do
	(
		if chkOther.checked then matOther.open = true
		else matOther.open = false
	)
)



rollout matColor "Color Options" width:210 height:600
(
	---------------------------------------------------------------------------------------------------
	-- Interface COLOR
	---------------------------------------------------------------------------------------------------
	GroupBox grpColStatus "Status" pos:[8,8] width:184 height:40
	checkbutton chkColStatus "Enabled" pos:[16,24] width:166 height:16 toolTip:"Click to enable / disable on create" checked:true highlightColor:(color 197 220 197)

	GroupBox grpCol "Base" pos:[8,56] width:184 height:48
	colorPicker cpClr "" pos:[16,72] width:168 height:24 color:(color 237 178 50) title:"Choose a color"

	GroupBox grpColVar " +/- " pos:[8,112] width:184 height:168

	spinner spnClrRedVar "Red " pos:[39,137] width:56 height:16 range:[0,255,200] type:#integer
	colorPicker cpClrRedMin "" pos:[103,137] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrRedMin "000" pos:[108,156] width:20 height:16
	colorPicker cpClrRedBas "" pos:[132,137] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpClrRedMax "" pos:[161,137] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrRedMax "000" pos:[166,156] width:20 height:16
	
	
	
	spinner spnClrGrnVar "Green " pos:[30,185] width:65 height:16 range:[0,255,100] type:#integer
	colorPicker cpClrGrnMin "" pos:[103,185] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrGrnMin "000" pos:[108,204] width:20 height:16
	colorPicker cpClrGrnBas "" pos:[132,185] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpClrGrnMax "" pos:[161,185] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrGrnMax "000" pos:[166,204] width:20 height:16
	
	
	spinner spnClrBluVar "Blue " pos:[36,232] width:59 height:16 range:[0,255,50] type:#integer
	colorPicker cpClrBluMin "" pos:[103,233] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrBluMin "000" pos:[108,252] width:20 height:16
	colorPicker cpClrBluBas "" pos:[132,233] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpClrBluMax "" pos:[161,233] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrBluMax "000" pos:[166,252] width:20 height:16
	
	GroupBox grpColGen "Colour Generation" pos:[8,288] width:184 height:50
	radiobuttons rdoColGen "" pos:[16,308] width:149 height:16 labels:#("Random", "Smooth") columns:2

	GroupBox grpPrv "Preview" pos:[8,344] width:184 height:48
	colorPicker cpPrv1 "" pos:[16,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv2 "" pos:[32,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv3 "" pos:[48,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv4 "" pos:[64,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv5 "" pos:[80,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv6 "" pos:[96,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv7 "" pos:[112,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv8 "" pos:[128,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv9 "" pos:[144,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv10 "" pos:[160,364] width:20 height:16 enabled:false color:(color 255 255 255)



	---------------------------------------------------------------------------------------------------
	-- functions COLOR
	---------------------------------------------------------------------------------------------------
	
	fn updateColor =
	(
		-- set variables
			baseClr = cpClr.color
			rVar = spnClrRedVar.value
			gVar = spnClrGrnVar.value
			bVar = spnClrBluVar.value
		
--s*: Note: Passing rMin, rMax, etc. as globals is dangerous. These could easily be in conflict w/ other scripts.
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
-- s*: Nxt line flagged on 1st run error.
				swatch.color = matGen.setColor i 10
			)

	)
	
	
	---------------------------------------------------------------------------------------------------
	-- handlers COLOR
	---------------------------------------------------------------------------------------------------
	
	on matColor open
		do	updateColor ()
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



--s*: Moved matGen rollout to preceed matColor rollout due to 'undefined' error on 1st run.
--    You can't call a var before it is defined! and matColor did just that.
--    Had to move back!  rMin, rMax, etc. are globally defined on rollout open.

rollout matGen "Material Generation" width:210 height:544
(
	---------------------------------------------------------------------------------------------------
	-- Interface CREATE
	---------------------------------------------------------------------------------------------------
	GroupBox grpGenProps "Material Properties" pos:[8,8] width:184 height:64
	edittext edtGenMatName "Name:" pos:[18,24] width:166 height:16 text:"mMaterial"
	spinner spnGenSubs "Sub Materials" pos:[114,48] width:70 height:16 range:[2,100,10] type:#integer

	GroupBox genCreate "Create" pos:[8,80] width:184 height:80
	button btnGenCreate "Place in Material Editor slot:" pos:[16,96] width:136 height:16
	spinner spnGenSlot "" pos:[150,96] width:34 height:16 range:[1,24,1] type:#integer
	checkbox chkGenAutoPut "Auto apply to selected" pos:[16,120] width:168 height:16 enabled:true checked:true
	checkbox chkGenAutoMat "Auto popup Material Editor" pos:[16,136] width:168 height:16 enabled:true checked:false


	---------------------------------------------------------------------------------------------------
	-- functions CREATE
	---------------------------------------------------------------------------------------------------
	
	------------------------------------
	-- define locals
	------------------------------------

		local matSub


	------------------------------------
	-- create COLOR
	------------------------------------

	fn setColor i j =
	(
		local r,g,b	--s* These vars cannot be seen by the 'return' because they are in the scope of the case
					--   expression and not the fn.
		case matColor.rdoColGen.state of
--s*: Nxt line flagged on 1st run error after 1st fix.
--    Problem: matColor and matGen reference each other, there for one will have to be declared local at
--    start of script.
		(
			1: -- random
			(
				r = random rMin rMax
				g = random gMin gMax
				b = random bMin bMax
			)

			2: -- smooth
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


	------------------------------------
	-- create OPACITY
	------------------------------------

	fn setOpac matSub i j =
	(
		case matOpac.ckbOpacValInst.state of
		(
			true: -- instance
			(
				matSub.opacity.controller = opacCtrl
			--	need to update the controller value for some reason, now...
				opacCtrl.value = matOpac.spnOpacVal.value
				
			)
			false: -- copy
			(
				matSub.opacity = random opacMin opacMax
			)
		)
		if matOpac.chkOpac2Sided.checked then matSub.twoSided = true
	)

	fn setOpacMap matSub =
	(
		if matOpac.btnOpacMap.map != undefined then
		(
			case matOpac.ckbOpacMapCtrlInst.state of
			(
				true:
				(
					matSub.opacityMap = matOpac.btnOpacMap.map
				)
				false:
				(
					matSub.opacityMap = copy matOpac.btnOpacMap.map
					matSub.opacityMap.name = matSub.opacityMap.name + " copy"
				)
			)
			if matOpac.chkOpacAffectMap.checked then matSub.opacityMapAmount = random opacMin opacMax
		)
	)


	------------------------------------
	-- create SPECULAR LEVEL
	------------------------------------

	fn setSpec matSub i j =
	(
		case matHigh.ckbSpecValInst.state of
		(
			true: -- instance
			(
				matSub.specularLevel.controller = specCtrl
			--	need to update the controller value for some reason, now...
				specCtrl.value = matHigh.spnSpecVal.value

			)
			false: -- copy
			(
				print ("matSub is " + matSub as String)
				matSub.specularLevel = random specMin specMax
			)
		)
	)

	------------------------------------
	-- create GLOSSINESS
	------------------------------------

	fn setGlos matSub i j =
	(
		case matHigh.ckbGlosValInst.state of
		(
			true: -- instance
			(
				matSub.glossiness.controller = glosCtrl
			--	need to update the controller value for some reason, now...
				glosCtrl.value = matHigh.spnGlosVal.value

			)
			false: -- copy
			(
				print ("matSub is " + matSub as String)
				matSub.glossiness = random glosMin glosMax
			)
		)
	)

	------------------------------------
	-- create
	------------------------------------

	fn createMaterial slot =
	(
		global subs = spnGenSubs.value
	
		matTop = meditMaterials[slot] = Multimaterial ()
		matTop.name = edtGenMatName.text
		matTop.numSubs = subs
	
		for i = 1 to subs do
		(
			matSub = meditMaterials[slot].materialList[i]
			matSub.name = edtGenMatName.text + " sub" + i as String

			-- color
				if components.chkCol.checked do
				(
					matSub.adLock = off
					matSub.Diffuse = setColor i subs
					matSub.Ambient = (setColor i subs) / 3
				)
			-- opacity
				if components.chkOpac.checked then
				(
					setOpac matSub i subs
					-- setOpacMap matSub
					-- set Material editor preferences as a <bitarray>
					-- 1: MTL_BEING_EDITED, 2: BACKGROUND, 3: BACKLIGHT, 4: VIDEO_COLOR_CHECK
					setMTLMEditFlags meditMaterials[slot] #{2,3}
				)
			-- specular highlights
				if components.chkHigh.checked then
				(
					setSpec matSub i subs
					setGlos matSub i subs
				)
		)
		if chkGenAutoPut.checked then
			if $ != undefined then
				$.material = meditMaterials[slot]
		if chkGenAutoMat.checked then
			(max mtledit; activeMeditSlot = slot)
	)


	---------------------------------------------------------------------------------------------------
	-- handlers CREATE
	---------------------------------------------------------------------------------------------------

	on btnGenCreate pressed do ( createMaterial spnGenSlot.value  )
	on spnGenSlot changed value do activeMeditSlot = spnGenSlot.value

)




rollout matHigh "Specular Highlights" width:210 height:432
(
	---------------------------------------------------------------------------------------------------
	-- Interface HIGHLIGHTS
	---------------------------------------------------------------------------------------------------
	GroupBox grpHighStatus "Status" pos:[8,8] width:184 height:40
	checkbutton chkHighStatus "Enabled" pos:[16,24] width:166 height:16 toolTip:"Click to enable / disable on create" checked:true highlightColor:(color 197 220 197)

	GroupBox grpSpecParam "Specular Highlights: ()" pos:[8,56] width:184 height:72
	spinner spnSpecVal "Base: " pos:[32,80] width:58 height:16 range:[0,999,30] type:#integer
	spinner spnSpecVar "+/- " pos:[104,80] width:48 height:16 range:[0,999,10] type:#integer
	checkbutton ckbSpecValInst "in" pos:[168,80] width:16 height:16 highlightColor:(color 156 255 128) toolTip:"Instance controller across materials" 

	
	label lblSpecMap "Map:" pos:[16,104] width:24 height:16
	mapButton btnSpecMap "None" pos:[48,104] width:120 height:16
	checkbutton ckbSpecMapCtrlInst "in" pos:[168,104] width:16 height:16 highlightColor:(color 156 255 128) toolTip:"Instance controller across materials" 


	GroupBox grpGlosParam "Glossiness: ()" pos:[8,136] width:184 height:72
	spinner spnGlosVal "Base: " pos:[32,160] width:58 height:16 range:[0,100,30] type:#integer
	spinner spnGlosVar "+/- " pos:[104,160] width:48 height:16 range:[0,100,10] type:#integer
	checkbutton ckbGlosValInst "in" pos:[168,160] width:16 height:16 highlightColor:(color 156 255 128) toolTip:"Instance controller across materials"

	
	label lblGlosMap "Map:" pos:[16,184] width:24 height:16
	mapButton btnGlosMap "None" pos:[48,184] width:120 height:16
	checkbutton ckbGlosMapCtrlInst "in" pos:[168,184] width:16 height:16 highlightColor:(color 156 255 128) toolTip:"Instance controller across materials"


	---------------------------------------------------------------------------------------------------
	-- functions HIGHLIGHTS
	---------------------------------------------------------------------------------------------------

	-- initialize variables
		local spnSpecVarTemp = 10			-- remembered value for when instance / copy is changed
		global specCtrl = bezier_float()		-- setup instanced controller, for when needed
		local spnGlosVarTemp = 10			-- remembered value for when instance / copy is changed
		global glosCtrl = bezier_float()		-- setup instanced controller, for when needed

	fn updateSpec =
	(

		-- set variables
			specBas = spnSpecVal.value
			specVar = spnSpecVar.value
			specCtrl.value = copy specBas
			print ("specCtrl value is " + specCtrl.value as String)
		
		-- interpret opacity ranges	
			global specMin = (specBas - (specVar/2)) as Integer
			global specMax = (specBas + (specVar/2)) as Integer
				if specMin < 0 then specMin = 0
				if specMax > 999 then specMax = 999

		-- update interface display
			grpSpecParam.text = "Specular Level: (" + specMin as String + " - " + specMax as String + ")"

		-- update instanced controller, if needed
			specCtrl.value = specBas
			print ("specCtrl value is " + specCtrl.value as String)


	)

	fn updateSpecDisplay =
	(
		case ckbSpecValInst.state of
		(
			true:
			(
				-- instance
				spnSpecVarTemp = spnSpecVar.value
				spnSpecVar.value = 0
				spnSpecVar.enabled = false
				updateSpec()
			)
			false:
			(
				-- copy
				spnSpecVar.value = spnSpecVarTemp
				spnSpecVar.enabled = true
				updateSpec()
			)
		)
	)



	fn updateGlos =
	(

		-- set variables
			glosBas = spnGlosVal.value
			glosVar = spnGlosVar.value
			glosCtrl.value = copy glosBas
			print ("glosCtrl value is " + glosCtrl.value as String)
		
		-- interpret opacity ranges	
			global glosMin = (glosBas - (glosVar/2)) as Integer
			global glosMax = (glosBas + (glosVar/2)) as Integer
				if glosMin < 0 then glosMin = 0
				if glosMax > 100 then glosMax = 100

		-- update interface display
			grpGlosParam.text = "Glossiness: (" + glosMin as String + " - " + glosMax as String + ")"

		-- update instanced controller, if needed
			glosCtrl.value = glosBas
			print ("glosCtrl value is " + glosCtrl.value as String)



	)

	fn updateGlosDisplay =
	(
		case ckbGlosValInst.state of
		(
			true:
			(
				-- instance
				spnGlosVarTemp = spnGlosVar.value
				spnGlosVar.value = 0
				spnGlosVar.enabled = false
				updateGlos()
			)
			false:
			(
				-- copy
				spnGlosVar.value = spnGlosVarTemp
				spnGlosVar.enabled = true
				updateGlos()
			)
		)
	)



	---------------------------------------------------------------------------------------------------
	-- handlers HIGHLIGHTS
	---------------------------------------------------------------------------------------------------

	-- Both
		on matHigh open do
		(
			updateSpec(); print "Updating Spec"
			updateGlos(); print "Updating Glos"
		)


	-- Specular Level
		on spnSpecVal changed value do
			updateSpec()
		on spnSpecVar changed value do
			updateSpec()
		on ckbSpecValInst changed state do
			updateSpecDisplay()

	-- Glossiness
		on spnGlosVal changed value do
			updateGlos()
		on spnGlosVar changed value do
			updateGlos()
		on ckbGlosValInst changed state do
			updateGlosDisplay()



)




rollout matOpac "Opacity" width:210 height:432
(
	---------------------------------------------------------------------------------------------------
	-- Interface OPACITY
	---------------------------------------------------------------------------------------------------
	GroupBox grpOpacStatus "Status" pos:[8,8] width:184 height:40
	checkbutton chkOpacStatus "Enabled" pos:[16,24] width:166 height:16 toolTip:"Click to enable / disable on create" checked:true highlightColor:(color 197 220 197)

	GroupBox grpOpacParam "Opacity: ()" pos:[8,56] width:184 height:120
	spinner spnOpacVal "Base: " pos:[32,80] width:58 height:16 range:[0,100,75] type:#integer
	spinner spnOpacVar "+/- " pos:[104,80] width:48 height:16 range:[0,100,10] type:#integer
	checkbutton ckbOpacValInst "in" pos:[168,80] width:16 height:16 highlightColor:(color 156 255 128) toolTip:"Instance controller across materials" 

	
	label lblOpacMap "Map:" pos:[16,104] width:24 height:16
	mapButton btnOpacMap "None" pos:[48,104] width:120 height:16
	checkbutton ckbOpacMapCtrlInst "in" pos:[168,104] width:16 height:16 highlightColor:(color 156 255 128) toolTip:"Instance controller across materials" 

	checkbox chkOpac2Sided "2 Sided" pos:[16,152] width:70 height:16 checked:true
	checkbox chkOpacAffectMap "Base value affects map" pos:[16,128] width:152 height:16 enabled:false checked:false



	---------------------------------------------------------------------------------------------------
	-- functions OPACITY
	---------------------------------------------------------------------------------------------------
	-- initialize variables
		local spnOpacVarTemp = 10				-- remembered value for when instance / copy is changed
		global opacCtrl = bezier_float()		-- setup instanced controller, for when needed


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

		-- update instanced controller, if needed
			opacCtrl.value = opacBas
			print ("opacCtrl value is " + opacCtrl.value as String)

	)


	fn updateOpacDisplay =
	(
		case ckbOpacValInst.state of
		(
			true:
			(
				-- instance
				spnOpacVarTemp = spnOpacVar.value
				spnOpacVar.value = 0
				spnOpacVar.enabled = false
				updateOpac()
			)
			false:
			(
				-- copy
				spnOpacVar.value = spnOpacVarTemp
				spnOpacVar.enabled = true
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
		case ckbOpacMapCtrlInst.state of
		(
			true:
			(
				opacMapInst = btnOpacMap.map
				print "Instance"
			)
			false:
			(
				print "Copy only"
			)
		)
	)

	fn updateStatus =
	(
		chkOpacStatus.text = "Disabled"
		matOpac.open = false
		components.chkOpac.checked = false
	)

	---------------------------------------------------------------------------------------------------
	-- handlers OPACITY
	---------------------------------------------------------------------------------------------------
	on matOpac open do
		updateOpac()
	on spnOpacVal changed value do
		updateOpac()
	on spnOpacVar changed value do
		updateOpac()
	on ckbOpacValInst changed state do
		updateOpacDisplay()
	/*
	on btnOpacMap picked texmap do
		setOpacMapBtnDisplay()
	on ckbOpacMapCtrlInst changed state do
		updateOpacMapCtrl()
	on chkOpacStatus changed state do
		updateStatus()
	*/


)




rollout credits "Credits" width:210 height:340
(
	---------------------------------------------------------------------------------------------------
	-- everything CREDITS
	---------------------------------------------------------------------------------------------------
	button webBtn "www.davestewart.co.uk" pos:[8,8] width:184 height:16
	GroupBox grpCrdInfo "Multi Material Maker v0.6" pos:[8,32] width:184 height:216
	label lblCrdInfo "
OK... my first proper stab at writing a plugin script!

Items not yet implimented:

> Rollup / rolldown functionality
> Maps
> Instanced map controllers
> Bump mapping / Self Illumation
> Shader types
> Instance other channels

Hope you like it so far!
" pos:[16,48] width:160 height:192
	on webBtn pressed do
(
	ShellLaunch "iexplore.exe" "http://www.davestewart.co.uk"
)
)
---------------------------------------------------------------------------------------------------
-- create the rollout window and add the rollouts
---------------------------------------------------------------------------------------------------


-- create the floater
	if multiMatMaker != undefined do
	(
		closerolloutfloater multiMatMaker
	)		
	multiMatMaker = newRolloutFloater "Multi Material Maker v0.6" 230 800


-- add the rollouts
	addRollout matGen multiMatMaker
	addRollout components multiMatMaker
	addRollout matColor multiMatMaker
	addRollout matHigh multiMatMaker rolledup:true
	addRollout matOpac multiMatMaker rolledup:true
	addRollout credits multiMatMaker rolledup:true

-- position & setup the floater