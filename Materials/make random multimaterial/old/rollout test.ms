rollout info "Info & Instructions" width:210 height:432 category: 1
	(
	
	)

rollout components "Components" width:210 height:432 category: 2
(
	checkbox chk1 "Color" pos:[8,8] width:192 height:16 checked:true
	checkbox chk2 "Specular Highlights" pos:[8,24] width:192 height:16
	checkbox chk3 "Opacity" pos:[8,40] width:192 height:16
	checkbox chk4 "Other Parameters" pos:[8,56] width:192 height:16
	label lbl1 "Note:\nClearing a checkbox will delete existing values!" pos:[8,75] width:160 height:40
	
		


	
	on chk1 changed state do
	(
	case chk1.checked of
		(
		true: addRollout matColor multiMat
		false: removeRollout matColor multiMat
		)
	)
	on chk2 changed state do
	(
	case chk2.checked of
		(
		true: addRollout matSpec multiMat
		false: removeRollout matSpec multiMat
		)
	)
	on chk3 changed state do
	(
	case chk3.checked of
		(
		true: addRollout matOpac multiMat
		false: removeRollout matOpac multiMat
		)
	)
	on chk4 changed state do
	(
	case chk4.checked of
		(
		true: addRollout matOther multiMat
		false: removeRollout matOther multiMat
		)
	)
)




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


rollout matSpec "Specular Highlights" width:210 height:432 category: 4
	(
	
	)

rollout matOpac "Opacity" width:210 height:432 category: 5
	(
	
	)

rollout matOther "Other Options" width:210 height:432 category: 5
	(
	
	)
---------------------------------------------------------------------------------------------------
-- create the rollout window and add the rollouts
---------------------------------------------------------------------------------------------------

if multiMat != undefined do
				(
				closerolloutfloater multiMat 
				)		
multiMat = newRolloutFloater "Random Multi Material" 200 500 
addRollout info multiMat rolledUp:true
addRollout components multiMat
addRollout matColor multiMat
