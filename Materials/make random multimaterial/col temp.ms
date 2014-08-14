

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
