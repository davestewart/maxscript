rollout rFlash "Shockwave Flash Object" 
( 

-- interface
	activeXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" height:151 width:401 align:#left 
	
	button btnProps "Props" width:130 height:16 align:#left across:3
	button btnMethods "Methods" width:130 height:16 align:#left
	button btnEvents "Events" width:130 height:16 align:#left

	dropDownList ddl1 "" width:140 height:21 across:2 align:#left items:#("background","text","activeCommand","hilight","shadow","window","activeCaption","toolTipBackground","toolTipText","hilightText","windowText","itemHilight","subObjectColor","3dDarkShadow","3dLight","appWorkspace","trackbarBg","trackbarBgSel","trackbarText","trackbarTicks","trackbarKeys","trackbarSelKeys","trackbarCursor","pressedButton","timeSliderBg","viewportBorder","activeViewportBorder","rollupTitleFace","rollupTitleText","rollupTitleHilight","rollupTitleShadow","selectionRubberBand","stackViewSelection")
	colorPicker cp1 "" width:250 height:16 title:"" align:#left offset:[-50,0]


-- handlers
	-- flash
		on axFlash OnReadyStateChange arg1 do format "handler: OnReadyStateChange : %\n" arg1 
		on axFlash OnProgress arg1 do format "handler: OnProgress : %\n" arg1 
	
		on axFlash FSCommand arg1 arg2 do 
		(
			rFlash.title=(arg1 + " " +arg2)
			messagebox (arg1 + " " +arg2)
			setFocus axFlash
		) 
	
		on rFlash open do 
		(
			local path="X:/Dave/3ds to ae/03_3ds/interface/flash interface/"
			local file="flashBg.swf"
			--local file="flashFun01.swf"
			axFlash.movie = path+file 
			axFlash.movie = path+file -- need to load 2nd time sometimes
			
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
flashFloater = newRolloutFloater "Shockwave Flash Object" 450 250 10 10 
addRollout rFlash flashFloater 

/*
*/
colorpicker
--getopenfilename()