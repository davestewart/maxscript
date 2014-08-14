rollout ro1 "Rollout 1" width:162 height:200
(

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

		slider spnH "Hue" range:[0,255,0] type:#integer
		slider spnS "Saturation" range:[0,255,0] type:#integer
		slider spnV "Value" range:[0,255,0] type:#integer
		colorPicker cp1 "" width:144 height:144
	

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

		fn hsv2rgb H S V =
	(
			Hp	= (H/255.)*360
			Hex	= Hp/60
			pri	= Hex as integer
			sec	= Hex-pri
			Sp	= S/255.
			Vp	= V/255.
			a	= (1-Sp)*Vp
			b	= (1-(Sp*sec))*Vp
			c	= (1-(Sp*(1-sec)))*Vp
			aP	= a*255
			bP	= b*255
			cP	= c*255
			case pri of
		(
				1:			(R = bP; G =  V; B = aP)
				2:			(R = aP; G =  V; B = cP)
				3:			(R = aP; G = bP; B =  V)
				4:			(R = cP; G = aP; B =  V)
				5:			(R =  V; G = aP; B = bP)
				default:	(R =  V; G = cP; B = aP)
		)
			struct rgbStruct (r,g,b)
			return rgbStruct r:R g:G b:B
	)
	
	
	fn updateColor =
	(
		h = spnH.value
		s = spnS.value
		v = spnV.value
		
		newCol = hsv2rgb h s v
		
		cp1.color = [newCol.R, newCol.G, newCol.B]
	)
		
	fn updateSpinners color =
	(
		spnH.value = color.h
		spnS.value = color.s
		spnV.value = color.v
	)
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
	
		on spnH changed value do updateColor()
		on spnS changed value do updateColor()
		on spnV changed value do updateColor()
		on cp1 changed color do updateSpinners color
		on ro1 open do updateSpinners cp1.color

	
)
	
if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 200 360 
addRollout ro1 myFloater