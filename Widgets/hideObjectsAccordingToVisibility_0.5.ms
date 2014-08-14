rollout r1 "Hide / Unhide Objects" width:160 height:104
(

	-- info
		-- author:			dave stewart
		-- site:			www.pondskata.com
		-- script version:	0.5
		-- max version:		5+ (I would imagine)
		-- date:			4th October 2005
		

	-- interface
		checkbutton ckb1 "Active" pos:[8,80] width:144 height:16
		button btnPick "All Objects" pos:[8,56] width:128 height:16
		button btnClear "x" pos:[136,56] width:16 height:16
		label lbl1 "Check / uncheck the button to automatically hide  / unhide objects with animated visibility." pos:[8,8] width:144 height:40
	
	-- variables	
		local objArr=#()
		local hideArr=#()
	
	-- functions
		fn hideObjectsAccordingToVisibility = 
		(
			with redraw off
			(
				if objArr.count==0 then hideArr=objects else hideArr=objArr
				for obj in hideArr do
				(
					if obj[1].controller != undefined then
					(
						if obj[1].value > 0 then unhide obj else hide obj
					)
				)
			)
			redrawviews()
		)
		
		fn unhideObjects =
		(
			with redraw off
			(
				for obj in objects do
				(
					if obj[1].controller != undefined then unhide obj
				)
			)
		)
		
		fn tcb = hideObjectsAccordingToVisibility()
	
	-- handlers
		on r1 close do
		(
			unregisterTimeCallback tcb
			if querybox "Unhide all objects?" == true then unhideObjects()
		)
	
		on ckb1 changed state do
		(
			hideObjectsAccordingToVisibility()
			if state == true then registerTimeCallback tcb
			else unregisterTimeCallback tcb
		)
			
		on btnPick pressed do
		(
			objArr=selectByName()
			if objArr != undefined AND objArr.count > 0 then btnPick.text=objArr.count as string+" Objects"
			else if objArr != undefined AND objArr.count == 0 then btnClear.pressed()
		)
	
		on btnClear pressed do
		(
			objArr=#()
			btnPick.text="All Objects"
		)

)

destroydialog r1
createdialog r1