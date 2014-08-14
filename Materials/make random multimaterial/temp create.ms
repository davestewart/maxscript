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
		max mtledit
		global subs = spnGenSubs.value
	
		matTop = meditMaterials[slot] = Multimaterial ()
		matTop.name = edtGenMatName.text
		matTop.numSubs = subs
	
		for i = 1 to subs do
		(
			matSub = meditMaterials[slot].materialList[i]
			matSub.name = edtGenMatName.text + " sub" + i as String

			-- color
				if components.chkCol.checked then matSub.Diffuse = setColor i subs
			-- opacity
				if components.chkOpac.checked then
				(
					setOpac matSub i subs
					setOpacMap matSub
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
		if chkGenAuto.checked then
			if $ != undefined then
				$.material = meditMaterials[slot]

		activeMeditSlot = slot
	)


	---------------------------------------------------------------------------------------------------
	-- handlers CREATE
	---------------------------------------------------------------------------------------------------

	on btnGenCreate pressed do ( createMaterial spnGenSlot.value  )
