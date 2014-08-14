macroScript SetVisibility
	category:"Animation Tools"
	tooltip:"Animate Visibility"
	ButtonText:"Animate Visibility"

	(

	fn setVis state=
		(
		for obj in $ do
			(
			-- set controller
				if NOT obj.visibility.isAnimated then
					(
					obj.visibility=true
					obj.visibility.controller= boolean_float ()
					)

			-- create key
				local c=	obj.visibility.controller
				local k=	addNewKey c currenttime
				if state != undefined then
					k.value = (if state then 1 else 0)
				else
					(
					k.value = (if c.value>0 then 0 else 1)
					print c.value
					)
			)
		)

	fn createVisRo=
		(
		destroydialog roVisibility 
		createDialog roVisibility pos:mouse.screenpos
		)

	rollout roVisibility "Visibility" width:96 height:16
		(
		button btn1 "On" pos:[0,0] width:48 height:16
		button btn2 "Off" pos:[48,0] width:48 height:16
		
		on btn1 pressed do setVis true
		on btn2 pressed do setVis false
		)

/*
	on isChecked do setVis true
	on isChecked do setVis false
*/
	on execute do setVis undefined
	on altExecute type do createVisRo()

	)

macros.run "Animation Tools" "SetVisibility"