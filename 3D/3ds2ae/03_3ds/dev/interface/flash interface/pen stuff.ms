ax--globals
global floatHeight = 90, floatWidth = 170, btWidth = 63, btWidth3 = 43, btHeight = 18
global characterSetup_F, controllers_R, linkInfo_R, boneTools_R, editCon_R, extraUtil_R, help_R
global updateCons_fn, selsetchanged_fn, CreateListCon_fn, addListCon_fn
--try(fileIn ((getDir #scripts) + "\\PEN_extraUtils.ms"))catch( extraUtil_R = undefined)
--try(fileIn ((getDir #scripts) + "\\PEN_FindControllers.ms"))catch( editCon_R = undefined)
--try(fileIn ((getDir #scripts) + "\\PEN_editAttributes.ms"))catch( editAttributesR = undefined)

--***Updated***
global update_str = "July 02 2003"
--***Version***
global version_str = "4.01"

global author_str = 
"Created By: Paul Neale
Company: PEN Productions Inc.
E-Mail: pen_productions@yahoo.com
Last Updated: " + update_str + 
"\nMax version 5 \n" +
"Script Version: " + version_str

try(destroyDialog util_R)catch()

-- Utilities Rollout
rollout util_R "PEN Rigging Utils" 
(
	local tabNames = #("None", "Controllers", "Edit Controllers", "Link Info", "Extras", "Help", "Edit Attributes")
	local tabTips = 
	#("Close all Rollouts",
	 "List controller manager",
	 "Edit controllers by type",
	 "Link and Inherit controls",
	 "Lots of extra stuff",
	 "Help & Author",
	 "Add, Redefine and Edit Custom Attributes"
	 )

	--Interface
	activeXControl ax "MSComctlLib.TabStrip.2" height:floatHeight width:500
	
	--SubRollouts
	subRollout sub1 width:floatWidth height:0 pos:[1,floatHeight - 2]
	
	local roll_ar = -- array of rollouts
	#(
		undefined,
		controllers_R,
		editCon_R,
		linkInfo_R,
		extraUtil_R,
		help_R,
		editAttributesR
	)
	local rollHeight = -- array of rollout heights
	#(
		floatHeight,
		665,
		710,
		359,
		480,
		135,
		420
	)
	
	local rollWidth = --array of rollout widths
	#(
		floatWidth,
		0,
		300,
		0,
		0,
		0,
		360
	)

--characterSetup_F.size[2] - floatHeight

	-- Called when Utility button is pressed. Opens the correct rollout.
	FN btCon_fn btPres =
	(
		if btPres == 1 then
		(
			sub1.width = floatWidth
			sub1.height = floatHeight
			util_R.width = floatWidth
			util_R.height = floatHeight
			for x in roll_ar do (if x != undefined do (removeSubRollout Sub1 x))
		)else
		(
			for x in roll_ar do (if x != undefined do (removeSubRollout Sub1 x))
			sub1.width = (floatWidth + rollWidth[btPres])
			sub1.height = (floatHeight + rollHeight[btPres])
			util_R.width = (floatWidth + rollWidth[btPres])
			util_R.height = (floatHeight + rollHeight[btPres])
			addSubRollout Sub1 roll_ar[btPres]
		)
	)
	
	on util_R close do
	(
		callbacks.removescripts #selectionSetChanged
	)

	on util_R open do
	(
		
		ax.tabs.clear()
		ax.multiRow = true
		
		for x = 1 to tabNames.count do --Add new tabs
		(
			newTab = ax.tabs.add()
			newTab.caption = tabNames[x]
			newTab.toolTipText = tabTips[x]
		)
	)

	on ax click do
	(
		axT = ax.selectedItem
		btCon_fn axT.index
		for x = 1 to tabNames.count do ax.tabs[x].highLighted = false --Clear highlights in tabs.
		ax.tabs[axT.index].highLighted = true --Set highlight in selected tab.
		
		clearListener()
		--Show all the stuff
		showProperties ax.tabs[1]
		print "--------------"
		showMethods ax.tabs
		print "--------------"
		showEvents ax.tabs
	)

)-- End util_R

rollout help_R "Help"
(
	local helpPath = ("file://" + (getDir #help) + "\\" + "RiggingUtilsHelp.html")
	
	label h1 "Paul Neale" align:#left
	label h2 "PEN Productions Inc." align:#left
	hyperLink h6 "pen_production@yahoo.com" address:"mailTo:pen_productions@yahoo.com" color:yellow hoverColor:red visitedColor:blue align:#center
--	label h3 "pen_production@yahoo.com" align:#left
	hyperLink h4 "PEN Productions web site" address:"http://members.rogers.com/paulneale" color:yellow hoverColor:red visitedColor:blue align:#center
	hyperLink h5 "Help Page" address:helpPath color:yellow hoverColor:red visitedColor:blue align:#center
)

-- Controllers Rollout
rollout controllers_R "Controllers" 
(
	group "List Controllers Names:"
	(
		dropDownList conPre_ddl ""
	
	)

	group "Remove List Controllers:"
	(
		button removePoslist "Pos" width:btWidth3 align:#center across:3 toolTip:"Removes position list controllers and set them to a default of Postion_XYZ."
		button removeRotlist "Rot" width:btWidth3  align:#center toolTip:"Removes Rotation list controllers and set them to a default of Euler_XYZ."
		button removeScllist "Scl" width:btWidth3  align:#center toolTip:"Removes Scale list controllers and set them to a default of Scale_XYZ."
	)

	group "Zero Out Objects:"
	(
		button zeroPos "0 Pos" width:btWidth align:#center across:2 toolTip:"Adds List Controller with a Position_XYZ controller in the second track."
		button zeroRot "0 Rot" width:btWidth align:#center toolTip:"Add List Controller with a Euler_XYZ controller in the second track."
	)
	
	group "Add Controllers:"
	(
		checkBox makeList_cb ":Make List Controller" checked:true
		
		label ACTL01_lb "List Controller Name:" align:#left
		editText setactiveName_et ""
		spinner addnList_sp "List Number" fieldWidth:30 type:#integer range:[1,100,1] align:#left enabled:false across:2
		checkbox addnList_cb "" align:#right
		
		label ACTL02_lb "P:" across:2 align:#left
		dropDownList conPos_ddl "" Width:110 align:#right
		
		label ACTL03_lb "R:" across:2 align:#left
		dropDownList conRot_ddl "" Width:110 align:#right
		
		label ACTL04_lb "S:" across:2 align:#left
		dropDownList conScl_ddl "" Width:110 align:#right
		
		checkBox makeActive_cb ":Make Active" checked:true
		button addConTolist_bt "Add/Replace/Rename" width:130 align:#center toolTip:"Adds/Replaces/Renames selected controllers to/in List controller."
	)
	
	group "Set / Del Controllers:"
	(
		radioButtons setBy_rb "By:" labels:#(":Number", ":Name") default:2
		
		spinner nlist_sp "List Number" fieldWidth:40 type:#integer range:[1,100,1] enabled:false
		
		label conName_lb "Controller Name:" align:#left
		editText conName_et "" enabled:true
		
		checkBox setP_cb ":Pos" checked:true across:3
		checkBox setR_cb ":Rot" checked:true
		checkBox setS_cb ":Scl" checked:true
		
		button conApply_bt "Set Con" width:btWidth align:#center across:2 toolTip:"Set controllers active by name or number"
		button conDelete_bt "Del Con" width:btWidth align:#center toolTip:"Delete controllers by name or number"
		
		button set1stActive "Set 1st" width:btWidth align:#center across:2 toolTip:"Set the first controller active in a list"
		button setTopActive "Set Top" width:btWidth align:#center toolTip:"Set the top controller active in a list"
	)
	
	group "Resets:"
	(
		button resetPos "Pos" width:btWidth3 align:#center across:3 toolTip:"Reset the active position controller to a value of 0"
		button resetRot "Rot" width:btWidth3 align:#center toolTip:"Reset the active rotation contoller to a value of 0"
		button resetScl "Scl" width:btWidth3 align:#center toolTip:"Reset the active scale controller to a value of 0"
	)
	
		on conPre_ddl selected i do
	(
		setactiveName_et.text = conPre_ddl.selected
		conName_et.text = conPre_ddl.selected
	)
	
	on removePoslist pressed do
	(
		disableSceneRedraw()
		obj = getCurrentSelection()
		Con = position_XYZ()
		for x in selection do
		(	
			posVal = x.pos.controller.value
			x.pos.controller = copy Con
			x.pos.controller.value = posVal
		)
		
		select obj
		enableSceneRedraw()
		reDrawViews()
	)
	
	on removeRotlist pressed do
	(
		disableSceneRedraw()
		obj = getCurrentSelection()
		Con = euler_XYZ()
		for x in selection do
		(	
			rotVal = x.rotation.controller.value
			x.rotation.controller = copy Con
			x.rotation.controller.value = rotVal
		)
		
		select obj
		enableSceneRedraw()
		reDrawViews()
		
	)
	
	on removeScllist pressed do
	(
		disableSceneRedraw()
		obj = getCurrentSelection()
		Con = scaleXYZ()
		for x in selection do
		(	
			scaleVal = x.scale.controller.value
			x.scale.controller = copy Con
			x.scale.controller.value = scaleVal
		)
		
		select obj
		enableSceneRedraw()
		reDrawViews()
		
	)
	
	on zeropos pressed do
	(
		disablesceneredraw()
		posXYZcon_var = position_XYZ()
		obj_sel01 = getcurrentselection()
		
		for x = 1 to obj_sel01.count do
		(
			poscon = obj_sel01[x].position.controller
			if (classof poscon) != position_list do
			(
				poslistcon_var = position_list()
				obj_sel01[x].position.controller = poslistcon_var
				obj_sel01[x].position.controller[2].controller = copy posXYZcon_var
				obj_sel01[x].position.controller.setactive 2
				listctrl.setname obj_sel01[x].position.controller 1 "Zero"
				listctrl.setname obj_sel01[x].position.controller 2 "Animation"
			)
		)
		
		for x = 1 to obj_sel01.count do
		(
			if obj_sel01[x].position.controller.numsubs == 2 do
			(
				obj_sel01[x].position.controller[2].controller = copy posXYZcon_var
				obj_sel01[x].position.controller.setactive 2
				listctrl.setname obj_sel01[x].position.controller 1 "Zero"
				listctrl.setname obj_sel01[x].position.controller 2 "Animation"
			)
			
			poslistcon2 = obj_sel01[x].position.controller[2].controller
			if (classof poslistcon2) == position_XYZ do
			(
				obj_sel01[x].position.controller[1].value += obj_sel01[x].position.controller[2].value
				obj_sel01[x].position.controller[2].value = [0,0,0]
			)
		)
		select obj_sel01
		enablesceneredraw()
		redrawviews()
	)
	
	on zerorot pressed do
	(
	disablesceneredraw()
	
		obj_sel = getcurrentselection()
		rotTCBcon = tcb_rotation()
		rotXYZcon = euler_XYZ()
		rotfloatcon = bezier_float()
		
		for x = 1 to obj_sel.count do
		(
			rotlistcon1 = obj_sel[x].rotation.controller --check for list controller
			if (classof rotlistcon1) == rotation_list then
			(
				rotlistcon2 = obj_sel[x].rotation.controller[2].controller --check for euler_xyz controller
				if (classof rotlistcon2) == euler_XYZ do
				(
					float_count = 0
					for m = 1 to 3 do --check for bezier_float controller
					(
						rotlistcon2con = obj_sel[x].rotation.controller[2][m].controller 
						if (classof rotlistcon2con) == bezier_float do
						(float_count +=1)
					)
						if float_count == 3 do
						(
							--copy current controllers
							currotcon = #()
							for y = 1 to 3 do (append currotcon obj_sel[x].rotation.controller[2][y].controller)
							
							--replace list controller with TCB
								currot = obj_sel[x].rotation.controller.value
								obj_sel[x].rotation.controller = copy rotTCBcon
								obj_sel[x].rotation.controller.value = currot
							
							--recreate list controller
							rotlistcon = rotation_list() 							obj_sel[x].rotation.controller = rotlistcon
							obj_sel[x].rotation.controller[2].controller = copy rotXYZcon
							for z = 1 to 3 do 
							(
								obj_sel[x].rotation.controller[2][z].controller = currotcon[z]
								obj_sel[x].rotation.controller[2][z].controller.value = 0
							)
							
							--set second controller active
							obj_sel[x].rotation.controller.setactive 2
							
							--name controllers
							listctrl.setname obj_sel[x].rotation.controller 1 "Zero"
							listctrl.setname obj_sel[x].rotation.controller 2 "Animation"
							
						)--end if float_count
				)--end if rotlistcon2
			)
			else
			(
				--Create 1st and 2nd list controller
				rotlistcon = rotation_list()
				obj_sel[x].rotation.controller = rotlistcon
				obj_sel[x].rotation.controller[2].controller = copy rotXYZcon
				for y = 1 to 3 do
				(obj_sel[x].rotation.controller[2][y].controller = copy rotfloatcon)
				
				--set second controller active
				obj_sel[x].rotation.controller.setactive 2
	
				--name controllers
	 			listctrl.setname obj_sel[x].rotation.controller 1 "Zero"
				listctrl.setname obj_sel[x].rotation.controller 2 "Animation"
	
			)--end if rotlistcon1
		)--end x loop
	
	select obj_sel
	enablesceneredraw()
	redrawviews()
	)-- end on ZerOut pressed
	

--********************************************Add Controller
	on makeList_cb changed state do
	(
		if state then
		(
			setactiveName_et.enabled = true
			if (addnList_cb.checked == true) do (addnList_sp.enabled = true)
			addnList_cb.enabled = true
			makeActive_cb.enabled = true
		)else
		(
			setactiveName_et.enabled = false
			addnList_sp.enabled = false
			addnList_cb.enabled = false
			makeActive_cb.enabled = false
		)
	)
	
	on addnList_cb changed state do -- Checkbox to enable addcontroller in a given track
	(
		if state then (addnList_sp.enabled = true) else (addnList_sp.enabled = false)
	)

	local posCon_ar =
	#(
		"None",
		"Bezier_position()",
		"Position_XYZ()",
		"Noise_Position()",
		"Position_Script()",
		"Position_Constraint()"
	)
	local rotCon_ar =
	#(
		"None",
		"Euler_XYZ()",
		"TCB_Rotation()",
		"Orientation_Constraint()"
	)
	local sclCon_ar =
	#(
		"None"
	)
	
	-- adds controllers to list and renames controllers 	
	on addConTolist_bt pressed do  
	(
		makeCon = makeList_cb.state
		posCon_vr = conPos_ddl.selected
		rotCon_vr = conRot_ddl.selected
		sclCon_vr = conScl_ddl.selected
		newName_vr = setactiveName_et.text
		numTrack = addnList_sp.value
		useNumTrack = addnList_cb.state
		PRS_ar =#(posCon_vr, rotCon_vr, sclCon_vr)
		if makeCon do (CreateListCon_fn PRS_ar)
		addListCon_fn makeCon posCon_vr rotCon_vr sclCon_vr newName_vr numTrack useNumTrack makeActive_cb.state
	)
	
	--Sets 1st controllers active.
	on set1stActive pressed do -- sets the 1st controller active
	(
		for x in selection do
		(
			try(x.pos.controller.setActive 1)catch()
			try(x.rotation.controller.setActive 1)catch()
		)
	)
	
	--Sets top controller active
	on setTopActive pressed do -- sets the top controler active
	(
		for x in selection do
		(
			try(x.pos.controller.setActive (x.pos.controller.count))catch()
			try(x.rotation.controller.setActive (x.rotation.controller.count))catch()
		)
	)
	
	--Updates interface when radio buttons are changed in setBy_rb
	Fn setBy_fn state =
	(
		case state of
		(
			1:
			(
				nlist_sp.enabled = true
				conName_et.enabled = false
			)
			2:
			(
				nlist_sp.enabled = false
				conName_et.enabled = true
			)
		)
	)
	
	--Called by setBy_rb
	on setBy_rb changed state do
	(
		setBy_fn state
	)
	
	--Converts strings to upper case.
	fn uppercase_fn instring =
	( 
		local upper, lower, outstring -- declare variables as local 
		upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ" -- set variables to literals 
		lower="abcdefghijklmnopqrstuvwxyz" 
		
		outstring=copy instring 
		
		for i=1 to outstring.count do 
		
		( 
			j=findString lower outstring[i] 
			
			if (j != undefined) do outstring[i]=upper[j] 
		) 
		outstring
	) -- end uppercase_fn

	--Sets controllers active by number.
	FN listByNum_fn =
	(
		for x in selection do
		(
			if setP_cb.state do
			(
				try(nPosCon = (if nList_sp.value > x.pos.controller.count then (x.pos.controller.count)else(nList_sp.value))
				x.pos.controller.setActive nPosCon)catch()
			)
			if setR_cb.state do
			(
				try(nRotCon = (if nList_sp.value > x.rotation.controller.count then (x.rotation.controller.count)else(nList_sp.value))
				x.rotation.controller.setActive nRotCon)catch()
			)
			if setS_cb.state do
			(
				try(nSclCon = (if nList_sp.value > x.scale.controller.count then (x.scale.controller.count)else(nList_sp.value))
				x.scale.controller.setActive nSclCon)catch()
			)
		)
	)
	
	-- Deletes controllers by number.
	FN delListByNum_fn =
	(
		for x in selection do
		(
			if setP_cb.state do
			(
				try(nPosCon = (if nList_sp.value > x.pos.controller.count then (x.pos.controller.count)else(nList_sp.value))
				x.pos.controller.delete nPosCon)catch()
			)
			if setR_cb.state do
			(
				try(nRotCon = (if nList_sp.value > x.rotation.controller.count then (x.rotation.controller.count)else(nList_sp.value))
				x.rotation.controller.delete nRotCon)catch()
			)
			if setS_cb.state do
			(
				try(nSclCon = (if nList_sp.value > x.scale.controller.count then (x.scale.controller.count)else(nList_sp.value))
				x.scale.controller.delete nRotCon)catch()
			)
			
		)
	)
	
	-- Set controllers active by name.
	FN listByName_fn =
	(
		for x in selection do
		(
			if (classof x.pos.controller) == Position_List do
			(
				for c = 1 to x.pos.controller.count do
				(
					if (uppercase_fn (x.pos.controller.getName c)) == uppercase_fn (conName_et.text) do
					(
						x.pos.controller.setActive c
					)
				)
			)
			if (classof x.rotation.controller) == Rotation_List do
			(
				for c = 1 to x.rotation.controller.count do
				(
					if (uppercase_fn (x.rotation.controller.getName c)) == uppercase_fn (conName_et.text) do
					(
						x.rotation.controller.setActive c
					)
				)
			)
		)
	)
	
	--Deletes Controllers by name.
	FN delListByName_fn =
	(
		for x in selection do
		(
			if (classof x.pos.controller) == Position_List do
			(
				for c = x.pos.controller.count to 1 by -1 do
				(
					if (uppercase_fn (x.pos.controller.getName c)) == uppercase_fn (conName_et.text) do
					(
						x.pos.controller.delete c
					)
				)
			)
			if (classof x.rotation.controller) == Rotation_List do
			(
				for c = x.rotation.controller.count to 1 by -1 do
				(
					if (uppercase_fn (x.rotation.controller.getName c)) == uppercase_fn (conName_et.text) do
					(
						x.rotation.controller.delete c
					)
				)
			)
		)
	)
	
	-- sets controller active by name and number
	on conApply_bt pressed do 
	(
		case setBy_rb.state of
		(
			1:
			(
				listByNum_fn()
			)
			2:
			(
				listByName_fn()
			)
		)
	
	)
	
	-- deletes controller by name and number
	on conDelete_bt pressed do 
	(
		case setBy_rb.state of
		(
			1:
			(
				delListByNum_fn()
				updateCons_fn()
			)
			2:
			(
				delListByName_fn()
				updateCons_fn()
			)
		)
	
	)
	
	on resetPos pressed do
	(
		disableSceneRedraw()
		for x in selection do
		(
			try(activeList = x.pos.controller.active)catch()
			if (classof x.pos.controller) == position_list then
			(
				x.pos.controller[activeList].value = [0,0,0]
			)else
			(
				x.pos.controller.value = [0,0,0]
			)
		)		
		
		enableSceneredraw()
		redrawViews()
	)
	
	on resetRot pressed do
	(
		disableSceneRedraw()
		for x in selection do
		(
			try(activeList = x.rotation.controller.active)catch()
			if (classof x.rotation.controller) == rotation_list then
			(
				x.rotation.controller[activeList].value = (quat 0 0 0 1)
			)else
			(
				x.rotation.controller.value = (quat 0 0 0 1)
			)
		)		
		
		enableSceneredraw()
		redrawViews()
	)
	
	on resetScl pressed do
	(
		disableSceneRedraw() 		for x in selection do
		(
			try(activeList = x.scale.controller.active)catch()
			if (classof x.scale.controller) == scale_list then
			(
				x.scale.controller[activeList].value = [1,1,1]
			)else
			(
				x.scale.controller.value = [1,1,1]
			)
		)		
		
		enableSceneredraw()
		redrawViews()
	)
	
	
	on controllers_R open do
	(
		updateCons_fn()
		callbacks.addscript #selectionSetChanged "selsetchanged_fn()" id:#selSetChanged_id
		conPos_ddl.items = posCon_ar
		conRot_ddl.items = RotCon_ar
		conScl_ddl.items = sclCon_ar
--		try(setactiveName_et.text = conPre_ddl.selected)catch() -- upadates the editText fields with names of current controllers
--		try(conName_et.text = conPre_ddl.selected)catch() -- upadates the editText fields with names of current controllers

	)
	
	on controllers_R close do
	(
		callbacks.removescripts #selectionSetChanged
	
	)

)-- end controller_R

--*************************************************************************************************
--*****************************Link Info*********************************************************
--*************************************************************************************************

rollout linkInfo_R "Link Info"
(
	group "Locks"
	(
		label locklinkinfo01 "Move:" align:#left
		checkbox lockmove_X "X" checked:true align:#right across:5
		checkbox lockmove_Y "Y" checked:true align:#right offset:[5,0]
		checkbox lockmove_Z "Z" checked:true align:#right offset:[10,0]
		button lockmove_all "All" width:25 height:15 offset:[8,0]
		button lockMove_None "N" width:25 height:15 offset:[8,0]
		
		label locklinkinfo02 "Rotate:" align:#left
		checkbox lockrotate_X "X" checked:true align:#right across:5
		checkbox lockrotate_Y "Y" checked:true align:#right offset:[5,0]
		checkbox lockrotate_Z "Z" checked:true align:#right offset:[10,0]
		button lockrotate_all "All" width:25 height:15 offset:[8,0]
		button lockRotate_None "N" width:25 height:15 offset:[8,0]

		label locklinkinfo03 "Scale:" align:#left
		checkbox lockscale_X "X" checked:true align:#right across:5
		checkbox lockscale_Y "Y" checked:true align:#right offset:[5,0]
		checkbox lockscale_Z "Z" checked:true align:#right offset:[10,0]
		button lockscale_all "All" width:25 height:15 offset:[8,0]
		button lockScale_None "N" width:25 height:15 offset:[8,0]
		
		button locklinkinfo_apply "Apply" width:60 height:20 align:#left
		button locklinkinfo_checkAll "All" width:25 height:20 offset:[33,-25]
		button locklinkinfo_clearall "N" width:25 height:20 offset:[60,-25]
	)

	group "Inherit"
	(
		label inheritlinkinfo01 "Move:" align:#left
		checkbox inheritmove_X "X" checked:true align:#right across:5
		checkbox inheritmove_Y "Y" checked:true align:#right offset:[5,0]
		checkbox inheritmove_Z "Z" checked:true align:#right offset:[10,0]
		button inheritmove_all "All" width:25 height:15 offset:[8,0]
		button inheritmove_None "N" width:25 height:15 offset:[8,0]
		
		label inheritlinkinfo02 "Rotate:" align:#left
		checkbox inheritrotate_X "X" checked:true align:#right across:5
		checkbox inheritrotate_Y "Y" checked:true align:#right offset:[5,0]
		checkbox inheritrotate_Z "Z" checked:true align:#right offset:[10,0]
		button inheritrotate_all "All" width:25 height:15 offset:[8,0]
		button inheritrotate_None "N" width:25 height:15 offset:[8,0]

		label inheritlinkinfo03 "Scale:" align:#left
		checkbox inheritscale_X "X" checked:true align:#right across:5
		checkbox inheritscale_Y "Y" checked:true align:#right offset:[5,0]
		checkbox inheritscale_Z "Z" checked:true align:#right offset:[10,0]
		button inheritscale_all "All" width:25 height:15 offset:[8,0]
		button inheritscale_None "N" width:25 height:15 offset:[8,0]
		
		button inheritlinkinfo_apply "Apply" width:60 height:20 align:#left
		button inheritlinkinfo_checkAll "All" width:25 height:20 offset:[33,-25]
		button inheritlinkinfo_clearall "N" width:25 height:20 offset:[60,-25]
	)

--**********************************************************reply Linkinfo
--*******Lock return
	local lockcheck_array = #(lockmove_X,lockmove_Y,lockmove_Z,lockrotate_X,lockrotate_Y,lockrotate_Z,lockscale_X,lockscale_Y,lockscale_Z)
	
	on lockmove_all pressed do (for i = 1 to 3 do (lockcheck_array[i].checked = true))
	on lockMove_None pressed do (for i = 1 to 3 do (lockcheck_array[i].checked = false))
	on lockrotate_all pressed do (for i = 4 to 6 do (lockcheck_array[i].checked = true))
	on lockrotate_None pressed do (for i = 4 to 6 do (lockcheck_array[i].checked = false))
 	on lockscale_all pressed do (for i = 7 to 9 do (lockcheck_array[i].checked = true))
	on lockscale_None pressed do (for i = 7 to 9 do (lockcheck_array[i].checked = false))
	on locklinkinfo_clearall pressed do (for i = 1 to 9 do (lockcheck_array[i].checked = false))
	on locklinkinfo_checkAll pressed do (for i = 1 to 9 do (lockcheck_array[i].checked = true))
	
	on locklinkinfo_apply pressed do
	(
		lock_array = #()
		for i = 1 to 9 do
		(
			if lockcheck_array[i].checked == true do (append lock_array i)
		)
		for x in selection do ( settransformlockflags x (lock_array as bitarray) ) 
	)
	
	--*****Inherit return
	local inheritcheck_array = #(inheritmove_X,inheritmove_Y,inheritmove_Z,inheritrotate_X,inheritrotate_Y,inheritrotate_Z,inheritscale_X,inheritscale_Y,inheritscale_Z)
	
	on inheritmove_all pressed do (for i = 1 to 3 do (inheritcheck_array[i].checked = true))
	on inheritmove_None pressed do (for i = 1 to 3 do (inheritcheck_array[i].checked = false))
	on inheritrotate_all pressed do (for i = 4 to 6 do (inheritcheck_array[i].checked = true))
	on inheritrotate_None pressed do (for i = 4 to 6 do (inheritcheck_array[i].checked = false))
	on inheritscale_all pressed do (for i = 7 to 9 do (inheritcheck_array[i].checked = true))
	on inheritscale_None pressed do (for i = 7 to 9 do (inheritcheck_array[i].checked = false))
	on inheritlinkinfo_clearall pressed do (for i = 1 to 9 do (inheritcheck_array[i].checked = false))
	on inheritlinkinfo_checkAll pressed do (for i = 1 to 9 do (inheritcheck_array[i].checked = true))
	
	on inheritlinkinfo_apply pressed do
	(
		inherit_array = #()
		for i = 1 to 9 do
		(
			if inheritcheck_array[i].checked == true do (append inherit_array i)
		)
		for x in selection do ( setinheritanceflags x (inherit_array as bitarray) ) 
	)
	

)--end linkInfo_R

FN updateCons_fn = -- updates list controllers names DDL with current selected object cotnroler names.
(
	conPre_ar = #()
	for x in selection do
	(
		if (classof x.pos.controller) == Position_List do
		(
			for c = 1 to x.pos.controller.count do
			(
				name01 = x.pos.controller.getName c
				findit = finditem conPre_ar name01
				if findit == 0 do
				(
					append conPre_ar name01
				)
			)
		)
		
		if (classof x.rotation.controller) == Rotation_List do
		(
			for c = 1 to x.rotation.controller.count do
			(
				name01 = x.rotation.controller.getName c
				findit = finditem conPre_ar name01
				if findit == 0 do
				(
					append conPre_ar name01
				)
			)
		)
	)
	
	controllers_R.conPre_ddl.items = conPre_ar

)--end updateCons_fn

-- Used for selectionSet callback.	
FN selsetchanged_fn = updateCons_fn() 

-- Adds list controllers if they don't exist
FN CreateListCon_fn PRS_ar = 
(
	--Why the hell did I do this?
	tracks_ar = 
	#(
		1, -- Position
		2, -- Rotation
		3  -- Scale
	)
	
	listCon_ar =
	#(
		position_list,
		rotation_list,
		scale_list
	)
	
	obj = selection as array
	for x in selection do
	(
		for t = 1 to tracks_ar.count do
		(
			if ((classof x[3][t].controller) != listCon_ar[t]) and (PRS_ar[t] != "None") do
			(
				x[3][t].controller = (listCon_ar[t]())
			)
		)
	)
	select obj
)--end CreateListCon_fn

--Adds controllers by name and number.
fn addListCon_fn makeCon posCon_vr rotCon_vr sclCon_vr newName_vr numTrack useNumTrack makeActive_cb =
(
	obj = selection as array
	for x in selection do
	(
		NumTrackP = if (useNumTrack != true) and ((classof x.position.controller) == position_list) then 
		(
			x.position.controller.count + 1
		)else 
		(
			if ((classof x.position.controller) == position_list) and (numTrack > x.position.controller.count + 1) then
			(
				x.position.controller.count + 1
			)else
			(
				numTrack
			)
		)
		
		NumTrackR = if (useNumTrack != true) and ((classof x.rotation.controller) == rotation_list) then 
		(
			x.rotation.controller.count + 1
		)else 
		(
			if ((classof x.rotation.controller) == rotation_list) and (numTrack > x.rotation.controller.count + 1) then
			(
				x.rotation.controller.count + 1
			)else
			(
				numTrack
			)
		)
		
		NumTrackS = if (useNumTrack != true) and ((classof x.scale.controller) == scale_list) then 
		(
			x.scale.controller.count + 1
		)else 
		(
			if ((classof x.scale.controller) == scale_list) and (numTrack > x.scale.controller.count + 1) then
			(
				x.scale.controller.count + 1
			)else
			(
				numTrack
			)
		)
		
		if (posCon_vr != "None") and (makeCon == false) do
		(
			x.position.controller = (execute posCon_vr)
		)
		
		if (posCon_vr != "None") and (makeCon == true) do
		(
			x.position.controller[NumTrackP].controller = (execute posCon_vr)
			if makeActive_cb do (x.position.controller.setActive NumTrackP)
		)

		if (rotCon_vr != "None") and (makeCon == false) do
		(
			x.rotation.controller = (execute rotCon_vr)
		)
		
		if (rotCon_vr != "None") and (makeCon == true) do
		(
			x.rotation.controller[NumTrackR].controller = (execute rotCon_vr)
			if makeActive_cb do (x.rotation.controller.setActive NumTrackR)
		)

		if (sclCon_vr != "None") and (makeCon == false) do
		(
			x.scale.controller = (execute sclCon_vr)
		)
		
		if (sclCon_vr != "None") and (makeCon == true) do
		(
			x.scale.controller[NumTrackS].controller = (execute sclCon_vr)
			if makeActive_cb do (x.scale.controller.setActive NumTrackS)
		)
		
		if (newName_vr != "") and (makeCon == true) do
		(
			try(x.position.controller.setName NumTrackP newName_vr)catch()
			try(x.rotation.controller.setName NumTrackR newName_vr)catch()
			try(x.scale.controller.setName NumTrackS newName_vr)catch()
		)

	)
	select obj
)-- end addListCon_fn

try(destroyDialog util_R)catch()
createDialog util_R 500 floatHeight+200 10 100
--util_R.title = ("PEN Rigging Utils " + version_str)













