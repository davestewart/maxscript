rollout components "Components" width:210 height:432
	(
	)




rollout matOptions "Options" width:210 height:432
	(

	on matOptions open do
		(
		max mtledit
		)

	GroupBox grp1 "Material Names" pos:[8,8] width:144 height:96
	edittext nameMain "Main" pos:[16,24] width:128 height:16 text:"MultiMaterial"
	edittext nameSubs "Subs" pos:[15,48] width:129 height:16 text:"Blue"
	spinner amtSubs "Sub Materials" pos:[48,72] width:96 height:16 range:[2,100,10] type:#integer
	GroupBox grp3 "Color and Varience" pos:[8,112] width:144 height:152
	colorPicker cp1 "" pos:[16,128] width:128 height:21 color:(color 64 128 255)
	spinner spnVarR "R" pos:[24,184] width:40 height:16 range:[0,255,10] type:#integer
	radiobuttons rVarOpt "" pos:[79,185] width:69 height:16 labels:#("", "", "") default:2 columns:3

	spinner spnVarG "G" pos:[24,208] width:40 height:16 range:[0,255,10] type:#integer
	spinner spnVarB "B" pos:[24,232] width:40 height:16 range:[0,255,10] type:#integer
	radiobuttons gVarOpt "" pos:[80,208] width:69 height:16 labels:#("", "", "") default:2 columns:3
	radiobuttons bVarOpt "" pos:[80,232] width:69 height:16 labels:#("", "", "") default:2 columns:3
	label lbl1 "+" pos:[128,160] width:8 height:21
	label lbl3 "-" pos:[80,160] width:8 height:21
	label lbl4 "=" pos:[104,160] width:8 height:21

	GroupBox grp12 "Material Editor Slot" pos:[8,272] width:144 height:113
	button btn1 "1" pos:[17,292] width:21 height:21
	button btn2 "2" pos:[38,292] width:21 height:21
	button btn3 "3" pos:[59,292] width:21 height:21
	button btn4 "4" pos:[80,292] width:21 height:21
	button btn5 "5" pos:[101,292] width:21 height:21
	button btn6 "6" pos:[122,292] width:21 height:21
	button btn7 "7" pos:[17,313] width:21 height:21
	button btn8 "8" pos:[38,313] width:21 height:21
	button btn9 "9" pos:[59,313] width:21 height:21
	button btn10 "10" pos:[80,313] width:21 height:21
	button btn11 "11" pos:[101,313] width:21 height:21
	button btn12 "12" pos:[122,313] width:21 height:21
	button btn13 "13" pos:[17,334] width:21 height:21
	button btn14 "14" pos:[38,334] width:21 height:21
	button btn15 "15" pos:[59,334] width:21 height:21
	button btn16 "16" pos:[80,334] width:21 height:21
	button btn17 "17" pos:[101,334] width:21 height:21
	button btn18 "18" pos:[122,334] width:21 height:21
	button btn19 "19" pos:[17,355] width:21 height:21
	button btn20 "20" pos:[38,355] width:21 height:21
	button btn21 "21" pos:[59,355] width:21 height:21
	button btn22 "22" pos:[80,355] width:21 height:21
	button btn23 "23" pos:[101,355] width:21 height:21
	button btn24 "24" pos:[122,355] width:21 height:21


---------------------------------------------------------------------------------------------------
-- functions
---------------------------------------------------------------------------------------------------

	fn randomColor =
		-- assign random colors
		( 
			base = random 1 255
			offset = 20
			
			x = base + random -offset offset
			y = base + random -offset offset
			z = base + random -offset offset
			
			return (color x y z)
		)

	fn checkSlot slot =
		-- check if material in slot is in scene
		(
		for i = 1 to sceneMaterials.count do
			(
			print sceneMaterials[i].name
			print meditMaterials[i].name
			)
		)


	fn createMaterial slot =
		-- make the materials
		(
		checkSlot slot

		matTop = meditMaterials[slot] = Multimaterial ()
		matTop.numSubs = amtSubs.value

		for i = 1 to amtSubs.value do
			(
			matSub = meditMaterials[slot].materialList[i]
			matSub.name = "Grey" + i as String
			matSub.adLock = off
			matSub.diffuse = randomColor()
			)
		)


---------------------------------------------------------------------------------------------------
-- handlers
---------------------------------------------------------------------------------------------------


	on btn1 pressed do	( slot = 1; createMaterial slot  )
	on btn2 pressed do	( slot = 2; createMaterial slot  )
	on btn3 pressed do	( slot = 3; createMaterial slot  )
	on btn4 pressed do	( slot = 4; createMaterial slot  )
	on btn5 pressed do	( slot = 5; createMaterial slot  )
	on btn6 pressed do	( slot = 6; createMaterial slot  )
	on btn7 pressed do	( slot = 7; createMaterial slot  )
	on btn8 pressed do	( slot = 8; createMaterial slot  )
	on btn9 pressed do	( slot = 9; createMaterial slot  )
	on btn10 pressed do	( slot = 10; createMaterial slot  )
	on btn11 pressed do	( slot = 11; createMaterial slot  )
	on btn12 pressed do	( slot = 12; createMaterial slot  )
	on btn13 pressed do	( slot = 13; createMaterial slot  )
	on btn14 pressed do	( slot = 14; createMaterial slot  )
	on btn15 pressed do	( slot = 15; createMaterial slot  )
	on btn16 pressed do	( slot = 16; createMaterial slot  )
	on btn17 pressed do	( slot = 17; createMaterial slot  )
	on btn18 pressed do	( slot = 18; createMaterial slot  )
	on btn19 pressed do	( slot = 19; createMaterial slot  )
	on btn20 pressed do	( slot = 20; createMaterial slot  )
	on btn21 pressed do	( slot = 21; createMaterial slot  )
	on btn22 pressed do	( slot = 22; createMaterial slot  )
	on btn23 pressed do	( slot = 23; createMaterial slot  )
	on btn24 pressed do	( slot = 24; createMaterial slot  )


	) -- end of rollout
	
---------------------------------------------------------------------------------------------------
-- create the rollout window and add the rollouts
---------------------------------------------------------------------------------------------------

if multiMat != undefined do
				(
				closerolloutfloater multiMat 
				)		
multiMat = newRolloutFloater "Random Multi Material" 200 500 
addRollout matOptions multiMat
