	fn replaceAll str inStr outStr=
		(
		while (local i=findstring str inStr) != undefined do str=replace str i 1 outStr
		--format ">%\n" str
		return str
		)


rollout ro1 "Setup" width:162 height:24 rolledup:true 
	(
	colorPicker cp1 "" width:400 height:16 color:red
	on ro1 open do rFlash.roCurrent=ro1
	)
rollout ro2 "Animation" rolledup:true (
	colorPicker cp1 "" width:400 height:16 color:orange
	)
rollout ro3 "Rendering" rolledup:true (
	colorPicker cp1 "" width:400 height:16 color:yellow
	)
rollout ro4 "Effects" rolledup:true (
	colorPicker cp1 "" width:400 height:16 color:green
	)
rollout ro5 "Extras" rolledup:true (
	colorPicker cp1 "" width:400 height:16 color:blue
	)

rollout rFlash "Shockwave Flash Object" 
	( 

-- variables
	local rollouts=#(ro1,ro2,ro3,ro4,ro5)
	local roCurrent

-- interface
	activeXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" height:75 width:401 align:#left 
/*
	button btnProps "Props" width:130 height:16 align:#left across:3
	button btnMethods "Methods" width:130 height:16 align:#left
	button btnEvents "Events" width:130 height:16 align:#left

	dropDownList ddl1 "" width:140 height:21 across:2 align:#left items:#("background","text","activeCommand","hilight","shadow","window","activeCaption","toolTipBackground","toolTipText","hilightText","windowText","itemHilight","subObjectColor","3dDarkShadow","3dLight","appWorkspace","trackbarBg","trackbarBgSel","trackbarText","trackbarTicks","trackbarKeys","trackbarSelKeys","trackbarCursor","pressedButton","timeSliderBg","viewportBorder","activeViewportBorder","rollupTitleFace","rollupTitleText","rollupTitleHilight","rollupTitleShadow","selectionRubberBand","stackViewSelection")
	colorPicker cp1 "" width:250 height:16 title:"" align:#left offset:[-50,0]
*/

-- handlers
	-- flash
		on axFlash OnReadyStateChange arg1 do format "handler: OnReadyStateChange : %\n" arg1 
		on axFlash OnProgress arg1 do format "handler: OnProgress : %\n" arg1 
	
		on axFlash FSCommand arg1 arg2 do 
			(
			-- messagebox
				--rFlash.title=(arg1 + " " +arg2)
				--messagebox (arg1 + " " +arg2)
				setFocus axFlash
			-- rollout open/close
				/*
				for r in rollouts do r.open=false
				execute("ro"+arg1 as string+".open=true")
				*/
			-- rollout add/remove
			--removeRollout roCurrent
			--roCurrent=execute("ro"+arg1 as string)
			--addRollout roCurrent flashFloater
			for i = 2 to 6 do flashFloater.rollouts[i].open=false
			flashFloater.rollouts[(arg1 as Number)+1].open=true

			) 
	
		on rFlash open do 
			(
			local f=(openfile "flashBg.swf")
			local fStr
			if f!= undefined then
				(
				flush f; close f
		
				fStr=f as string
				fStr = substring fStr 7 (fStr.count-7)
				fStr=replaceAll fStr "\\" "/"
				--execute("rollout VMSTidyHelp \"VMS Tidy Help\"(activeXControl ax \"file://"+fStr+"\" pos:[6,6] width:400 height:600)")
				--createdialog VMSTidyHelp 412 612
				
				)
			else messageBox "Help file not found..."

			local path="E:/03_Scripting/3ds2ae/03_3ds/interface/flash interface/"
			local file="flashBg.swf"
			--local file="flashFun01.swf"
			axFlash.movie = fStr--path+file 
			--axFlash.movie = path+file -- need to load 2nd time sometimes
			
			axFlash.BackgroundColor=((colorMan.getColor #background)*255)as color
			axFlash.menu=false
			)

	-- else

	on btnProps pressed do showproperties axFlash
	on btnMethods pressed do showmethods axFlash
	on btnEvents pressed do showevents axFlash


	on ddl1 selected arg do
		(
		local ui=ddl1.items[arg] as name
		cp1.color=(colorMan.getColor ui)*255
		axFlash.BackgroundColor=((colorMan.getColor ui)*255) as color
		)

	) 

if flashFloater!=undefined then closerolloutfloater flashfloater
flashFloater = newRolloutFloater "Shockwave Flash Object" 450 350 10 10 
addRollout rFlash flashFloater
addRollout ro1 flashFloater rolledUp:false

addRollout ro2 flashFloater rolledUp:false
addRollout ro3 flashFloater rolledUp:true
addRollout ro4 flashFloater rolledUp:true
addRollout ro5 flashFloater rolledUp:true



