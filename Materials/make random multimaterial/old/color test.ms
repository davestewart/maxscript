rollout matColor "Color Options" width:208 height:600 category: 3
(




	colorPicker cpBase "Base Color" pos:[32,8] width:128 height:21 color:(color 64 128 255) title:"Choose a color"
	spinner spnVarR "R" pos:[32,104] width:40 height:16 range:[0,255,10] type:#integer
	radiobuttons rdoVarR "" pos:[40,40] width:23 height:48 labels:#("", "", "") default:2 columns:1


	colorPicker cpBaseR "" pos:[32,128] width:16 height:12 enabled:false color:(color 64 128 255)
	label lblBaseR "" pos:[80,128] width:40 height:16
	colorPicker cpVarR1 "" pos:[32,144] width:16 height:12 enabled:false color:(color 64 128 255)
	label lblVarR1 "" pos:[80,144] width:40 height:16
	colorPicker cpVarR2 "" pos:[32,160] width:16 height:12 enabled:false color:(color 64 128 255)
	label lblVarR2 "" pos:[80,160] width:40 height:16



---------------------------------------------------------------------------------------------------
-- functions
---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------
-- handlers
---------------------------------------------------------------------------------------------------



	on matOptions open do
	(
		max mtledit
	)

	on cpBase changed value do
	(
		cpBaseR.color = color cpBase.color.r 0 0
	)

	on spnVarR changed value do
	(
		value = cpBase.color.r - spnVarR.value
		cpVarR1.color = color value 0 0
		lblVarR1.text = value as String

	)
)


---------------------------------------------------------------------------------------------------
-- create the rollout window and add the rollouts
---------------------------------------------------------------------------------------------------

if multiMat != undefined do
			(
				closerolloutfloater multiMat 
			)		
multiMat = newRolloutFloater "Random Multi Material" 200 250 
addRollout matColor multiMat
